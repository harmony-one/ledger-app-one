/*
 * Copyright (c) 2018-2019 Simple Rules Company.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */

// Each command has some state associated with it that sticks around for the
// life of the command. A separate context_t struct should be defined for each
// command.
#include "rlp.h"

// APDU parameters
#define P1_FIRST        0x00 // 1st packet of multi-packet transfer
#define P1_MORE         0x80 // nth packet of multi-packet transfer

#define P2_SIGN_HASH    0x01 // sign transaction hash
#define P2_FINISH       0x02 // last packet of multi-packet transfer

#define CMD_BUFFER_SIZE 255

typedef struct {
	bool genAddr;
	uint8_t displayIndex;
	// NUL-terminated strings for display
	uint8_t typeStr[40]; // variable-length
	uint8_t keyStr[40]; // variable-length
	uint8_t fullStr[77]; // variable length
	// partialStr contains 12 characters of a longer string. This allows text
	// to be scrolled.
	uint8_t partialStr[13];
} getPublicKeyContext_t;

typedef struct {
	uint8_t hash[32];
	uint8_t hexHash[64];
	uint8_t displayIndex;
	// NUL-terminated strings for display
	uint8_t indexStr[40]; // variable-length
    uint8_t typeStr[40]; // variable-length
	uint8_t partialHashStr[13];
} signHashContext_t;

typedef struct {
    uint8_t displayIndex;
    uint8_t buf[1024]; // holds RLP encoded tx bytes; large enough for four txn reads
    uint16_t length;  // holds RLP encoded tx length
    txContext_t txContext;
    txContent_t txContent;
    uint8_t hash[32];
    uint8_t fullStr[132]; // variable length
    uint32_t fullStrLength;
    uint8_t partialStr[18];
    bool initialized; // protects against certain attacks
} signStakingContext_t;

typedef struct {
    uint8_t displayIndex;
    uint8_t buf[510]; // holds RLP encoded tx bytes; large enough for two 0xFF reads
    uint16_t length;  // holds RLP encoded tx length
    txContext_t txContext;
    txContent_t txContent;
    // NUL-terminated strings for display
    uint8_t  toAddr[42];
    uint8_t partialAddrStr[13];
    //largest 256 bit unsigned integer is 115792089237316195423570985008687907853269984665640564039457584007913129639935
    uint8_t amountStr[78];
    uint32_t amountLength;
    uint8_t partialAmountStr[13];
    uint8_t shardStr[13];
    uint8_t hash[32];
    uint8_t fullStr[128]; // variable length
    uint8_t typeStr[40]; // variable-length
    bool initialized; // protects against certain attacks
} signTxnContext_t;

// To save memory, we store all the context types in a single global union,
// taking advantage of the fact that only one command is executed at a time.
typedef union {
	getPublicKeyContext_t getPublicKeyContext;
	signHashContext_t     signHashContext;
    signTxnContext_t      signTxnContext;
    signStakingContext_t  signStakingContext;
} commandContext;
extern commandContext global;

// ux is a magic global variable implicitly referenced by the UX_ macros. Apps
// should never need to reference it directly.
extern ux_state_t ux;

// These are helper macros for defining UI elements. There are four basic UI
// elements: the background, which is a black rectangle that fills the whole
// screen; icons on the left and right sides of the screen, typically used for
// navigation or approval; and text, which can be anywhere. The UI_TEXT macro
// uses Open Sans Regular 11px, which I've found to be adequate for all text
// elements; if other fonts are desired, I suggest defining a separate macro
// for each of them (e.g. UI_TEXT_BOLD).
//
// In the event that you want to define your own UI elements from scratch,
// you'll want to read include/bagl.h and include/os_io_seproxyhal.h in the
// nanos-secure-sdk repo to learn what each of the fields are used for.
#define UI_BACKGROUND() {{BAGL_RECTANGLE,0,0,0,128,32,0,0,BAGL_FILL,0,0xFFFFFF,0,0},NULL,0,0,0,NULL,NULL,NULL}
#define UI_ICON_LEFT(userid, glyph) {{BAGL_ICON,userid,3,12,7,7,0,0,0,0xFFFFFF,0,0,glyph},NULL,0,0,0,NULL,NULL,NULL}
#define UI_ICON_RIGHT(userid, glyph) {{BAGL_ICON,userid,117,13,8,6,0,0,0,0xFFFFFF,0,0,glyph},NULL,0,0,0,NULL,NULL,NULL}
#define UI_TEXT(userid, x, y, w, text) {{BAGL_LABELINE,userid,x,y,w,12,0,0,0,0xFFFFFF,0,BAGL_FONT_OPEN_SANS_REGULAR_11px|BAGL_FONT_ALIGNMENT_CENTER,0},(char *)text,0,0,0,NULL,NULL,NULL}

// ui_idle displays the main menu screen. Command handlers should call ui_idle
// when they finish.
void ui_idle(void);

// io_exchange_with_code is a helper function for sending APDUs, primarily
// from button handlers. It appends code to G_io_apdu_buffer and calls
// io_exchange with the IO_RETURN_AFTER_TX flag. tx is the current offset
// within G_io_apdu_buffer (before the code is appended).
void io_exchange_with_code(uint16_t code, uint16_t tx);
