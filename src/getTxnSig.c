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
#include "rlp.h"
#include "bech32.h"
#include "uint256.h"

static signTxnContext_t *ctx = &global.signTxnContext;

static void convertU256ToString(uint8_t *buffer, uint32_t  *outLength) {
    uint256_t target;
    uint256_t amount;
    uint256_t nanoAmount;
    uint256_t rMod;
    uint256_t nano;

    clear256(&target);
    clear256(&amount);
    clear256(&nanoAmount);
    clear256(&rMod);
    clear256(&nano);

    readu256BE(buffer, &target);

    UPPER(LOWER(nano)) = 0;
    LOWER(LOWER(nano)) = 1000000000;

    //convert to nano
    divmod256(&target, &nano, &nanoAmount, &rMod);

    //convert to one
    divmod256(&nanoAmount, &nano, &amount, &rMod);

    os_memset(ctx->amountStr, 0, 78);
    tostring256(&amount, 10, (char *)ctx->amountStr, 78, outLength);
}


static const bagl_element_t ui_toshard_approve[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
        UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

        UI_TEXT(0x00, 0, 12, 128, "To Shard:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.toShardStr),
};

static unsigned int ui_toshard_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
    cx_sha3_t sha3;

    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            // Return to the main screen.
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            cx_keccak_init(&sha3, 256);
            cx_hash((cx_hash_t *)&sha3, CX_LAST, ctx->buf, ctx->length, ctx->hash, 32);
            //debug the hash
            //os_memmove(G_io_apdu_buffer, ctx->hash, 32);
            //io_exchange_with_code(SW_OK, 32);
            deriveAndSign(G_io_apdu_buffer, ctx->hash);
            io_exchange_with_code(SW_OK, 65);

            // Return to the main screen.
            ui_idle();
            break;
    }
    return 0;
}

static const bagl_element_t ui_fromshard_approve[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
        UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

        UI_TEXT(0x00, 0, 12, 128, "From Shard:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.fromShardStr),
};

static unsigned int ui_fromshard_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            // Return to the main screen.
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            UX_DISPLAY(ui_toshard_approve, NULL);
            break;
    }
    return 0;
}

static const bagl_element_t ui_amount_compare_large[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Amount:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.partialAmountStr),
};



static const bagl_element_t* ui_prepro_amount_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
        case 2:
            return (ctx->displayIndex >= ctx->amountLength-12) ? NULL : element;
        default:
            return element;
    }
}

// This is the button handler for the comparison screen. Unlike the approval
// button handler, this handler doesn't send any data to the computer.
static unsigned int ui_amount_compare_large_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
            }
            if (ctx->amountLength > 12) {
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, 12);
            }
            else {
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, ctx->amountLength);
            }
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->amountLength-12) {
                ctx->displayIndex++;
            }
            if (ctx->amountLength > 12) {
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, 12);
            }
            else {
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, ctx->amountLength);
            }
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            bin2dec(ctx->fromShardStr, ctx->txContent.fromShard);
            bin2dec(ctx->toShardStr, ctx->txContent.toShard);
            UX_DISPLAY(ui_fromshard_approve, NULL);
            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
}

static const bagl_element_t ui_amount_compare[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
        UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

        UI_TEXT(0x00, 0, 12, 128, "Amount:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.partialAmountStr),
};

static unsigned int ui_amount_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            // Return to the main screen.
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            bin2dec(ctx->fromShardStr, ctx->txContent.fromShard);
            bin2dec(ctx->toShardStr, ctx->txContent.toShard);
            UX_DISPLAY(ui_fromshard_approve, NULL);
            break;
    }
    return 0;
}

static const bagl_element_t ui_address_compare[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Send to Addr:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.partialAddrStr),
};


static const bagl_element_t* ui_prepro_address_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
        case 2:
            return (ctx->displayIndex == sizeof(ctx->toAddr)-12) ? NULL : element;
        default:
            return element;
    }
}

static unsigned int ui_address_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
    uint8_t numberBuf[32];

    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
            }

            os_memmove(ctx->partialAddrStr, ctx->toAddr+ctx->displayIndex, 12);
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < sizeof(ctx->toAddr)-12) {
                ctx->displayIndex++;
            }
            os_memmove(ctx->partialAddrStr, ctx->toAddr+ctx->displayIndex, 12);
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            os_memset(numberBuf, 0, 32);
            os_memcpy(&numberBuf[32- ctx->txContent.value.length], ctx->txContent.value.value, ctx->txContent.value.length);
            convertU256ToString(numberBuf, &ctx->amountLength);
            ctx->displayIndex = 0;
            if (ctx->amountLength > 12) {
                os_memmove(ctx->partialAmountStr, ctx->amountStr, 12);
                ctx->partialAmountStr[12] = 0;
                UX_DISPLAY(ui_amount_compare_large, ui_prepro_amount_compare);
            }
            else {
                os_memmove(ctx->partialAmountStr, ctx->amountStr, ctx->amountLength);
                ctx->partialAmountStr[ctx->amountLength] = 0;
                UX_DISPLAY(ui_amount_compare, NULL);
            }

            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
}

static const bagl_element_t ui_signTx_approve[] = {
        UI_BACKGROUND(),
        UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
        UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

        UI_TEXT(0x00, 0, 12, 128, global.signTxnContext.typeStr),
};

static unsigned int ui_signTx_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            processTx(& ctx->txContext);
            bech32_get_address((char *)ctx->toAddr, ctx->txContent.destination, 20);
            os_memmove(ctx->partialAddrStr, ctx->toAddr, 12);
            ctx->partialAddrStr[12] = '\0';
            ctx->displayIndex = 0;
            UX_DISPLAY(ui_address_compare, ui_prepro_address_compare);
            break;
    }
    return 0;
}

void handleSignTx(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
    os_memset(ctx, 0, sizeof(signTxnContext_t));

    //txContext_t txContext;
    os_memset(& ctx->txContext, 0, sizeof(ctx->txContext));

    ctx->length = dataLength;
    os_memmove(ctx->buf, dataBuffer, dataLength);

    ctx->txContext.workBuffer = ctx->buf;
    ctx->txContext.commandLength = ctx->length;

    ctx->txContext.currentField = TX_RLP_CONTENT;
    ctx->txContext.content = &ctx->txContent;

    os_memmove(ctx->typeStr, "Sign Transaction?", 19);
    UX_DISPLAY(ui_signTx_approve, NULL);

    *flags |= IO_ASYNCH_REPLY;
}