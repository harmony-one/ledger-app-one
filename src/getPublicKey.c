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

#include <stdint.h>
#include <stdbool.h>
#include <os.h>
#include <os_io_seproxyhal.h>
#include "harmony.h"
#include "ux.h"

// Get a pointer to getPublicKey's state variables.
static getPublicKeyContext_t *ctx = &global.getPublicKeyContext;

static uint16_t getOneAddress() {
    uint16_t tx = 0;
    cx_ecfp_public_key_t publicKey;

    deriveOneKeypair(NULL, &publicKey);
    pubkeyToOneAddress(G_io_apdu_buffer + tx, &publicKey);
    tx += MAX_ONE_ADDRESS;
    return tx;
}

static void getPublicKey() {
    uint16_t tx = getOneAddress();

    // Flush the APDU buffer, sending the response.
    io_exchange_with_code(SW_OK, tx);
}

#if defined(HAVE_UX_FLOW)


unsigned int io_seproxyhal_touch_address_ok(const bagl_element_t *e) {
    uint16_t tx = 0;

    // Send back the response, do not restart the event loop
    tx += MAX_ONE_ADDRESS;
    io_exchange_with_code(SW_OK, tx);

    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

unsigned int io_seproxyhal_touch_address_cancel(const bagl_element_t *e) {

    // Send back the response, do not restart the event loop
   // io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
   io_exchange_with_code(SW_USER_REJECTED, 0);

    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

//////////////////////////////////////////////////////////////////////
UX_FLOW_DEF_NOCB(
    ux_display_public_flow_1_step,
    pnn,
    {
      &C_icon_eye,
      "Verify",
      "address",
    });
UX_FLOW_DEF_NOCB(
    ux_display_public_flow_2_step,
    bnnn_paging,
    {
      .title = "Address",
      .text = global.getPublicKeyContext.fullStr,
    });
UX_FLOW_DEF_VALID(
    ux_display_public_flow_3_step,
    pb,
    io_seproxyhal_touch_address_ok(NULL),
    {
      &C_icon_validate_14,
      "Approve",
    });
UX_FLOW_DEF_VALID(
    ux_display_public_flow_4_step,
    pb,
    io_seproxyhal_touch_address_cancel(NULL),
    {
      &C_icon_crossmark,
      "Reject",
    });

const ux_flow_step_t *        const ux_display_public_flow [] = {
  &ux_display_public_flow_1_step,
  &ux_display_public_flow_2_step,
  &ux_display_public_flow_3_step,
  &ux_display_public_flow_4_step,
  FLOW_END_STEP,
};

#else

// Define the comparison screen. This is where the user will compare the
// public key (or address) on their device to the one shown on the computer.
static const bagl_element_t ui_getPublicKey_compare[] = {
	UI_BACKGROUND(),
	UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
	UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),
	UI_TEXT(0x00, 0, 12, 128, "Compare:"),
	// The visible portion of the public key or address.
	UI_TEXT(0x00, 0, 26, 128, global.getPublicKeyContext.partialStr),
};

static const bagl_element_t* ui_prepro_getPublicKey_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
        case 2:
            return (ctx->displayIndex >= MAX_ONE_ADDRESS - 12) ? NULL : element;
        default:
            return element;
    }
}

// Define the button handler for the comparison screen. Again, this is nearly
// identical to the signHash comparison button handler.
static unsigned int ui_getPublicKey_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
	switch (button_mask) {
	case BUTTON_LEFT:
	case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
		if (ctx->displayIndex > 0) {
			ctx->displayIndex--;
		}
		os_memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
		UX_REDISPLAY();
		break;

	case BUTTON_RIGHT:
	case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
		if (ctx->displayIndex < MAX_ONE_ADDRESS - 12) {
			ctx->displayIndex++;
		}
		os_memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
		UX_REDISPLAY();
		break;

	case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
		// The user has finished comparing, so return to the main screen.
		ui_idle();
		break;
	}
	return 0;
}

static const bagl_element_t ui_getPublicKey_approve[] = {
	UI_BACKGROUND(),
	UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
	UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

	UI_TEXT(0x00, 0, 12, 128, global.getPublicKeyContext.typeStr),
};


static unsigned int ui_getPublicKey_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {

	switch (button_mask) {
	case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
		io_exchange_with_code(SW_USER_REJECTED, 0);
		ui_idle();
		break;

	case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
        getPublicKey();

		// Prepare the comparison screen, filling in the header and body text.
		os_memmove(ctx->typeStr, "Compare:", 9);
		os_memmove(ctx->fullStr, G_io_apdu_buffer, MAX_ONE_ADDRESS);
		ctx->fullStr[MAX_ONE_ADDRESS] = '\0';

		os_memmove(ctx->partialStr, ctx->fullStr, 12);
		ctx->partialStr[12] = '\0';
		ctx->displayIndex = 0;

		// Display the comparison screen.
		UX_DISPLAY(ui_getPublicKey_compare, ui_prepro_getPublicKey_compare);
		break;
	}
	return 0;
}
#endif

// These are APDU parameters that control the behavior of the getPublicKey
// command.
#define P2_DISPLAY_ADDRESS 0x00
#define P2_SILENT_MODE     0x01

void handleGetPublicKey(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
    os_memset(ctx, 0, sizeof(getPublicKeyContext_t));

    if (p2 == P2_DISPLAY_ADDRESS) {
#if defined(HAVE_UX_FLOW)
        int16_t tx = getOneAddress();
        os_memmove(ctx->fullStr, G_io_apdu_buffer, tx);
        ctx->fullStr[tx] = '\0';
        ux_flow_init(0, ux_display_public_flow, NULL);
#else
        // Prepare the approval screen, filling in the header and body text.
        os_memmove(ctx->typeStr, "Display Address?", 17);
        UX_DISPLAY(ui_getPublicKey_approve, NULL);
#endif
    }
    else if (p2 == P2_SILENT_MODE) {
        // Return public key without display it in LED
        getPublicKey();
    }
    else {
        THROW(SW_INVALID_PARAM);
    }

    *flags |= IO_ASYNCH_REPLY;
}

