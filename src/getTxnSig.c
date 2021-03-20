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

static void assign_shard_string() {
    uint8_t shardStr[5];
    int shardStrlen;

    strncpy((char*)&ctx->shardStr[0], "from:", 5);
    memset(shardStr, 0, sizeof(shardStr));
    shardStrlen = bin2dec(shardStr, ctx->txContent.fromShard);
    strncpy((char*)&ctx->shardStr[5], shardStr, shardStrlen);
    strncpy((char*)&ctx->shardStr[5 + shardStrlen], " to:", 4);
    memset(shardStr, 0, sizeof(shardStr));
    bin2dec(shardStr, ctx->txContent.toShard);
    strncpy((char*)&ctx->shardStr[9 + shardStrlen], shardStr, sizeof(shardStr));
}

#if defined(HAVE_UX_FLOW)

unsigned int io_seproxyhal_touch_tx_ok(const bagl_element_t *e) {
  cx_sha3_t sha3;

  cx_keccak_init(&sha3, 256);
  cx_hash((cx_hash_t *)&sha3, CX_LAST, ctx->buf, ctx->length, ctx->hash, 32);

  deriveAndSign(G_io_apdu_buffer, ctx->hash);
  io_exchange_with_code(SW_OK, SIGNATURE_LEN);

  // Return to the main screen.
  ui_idle();
  return 0;
}

unsigned int io_seproxyhal_touch_tx_cancel(const bagl_element_t *e) {

    // Send back the response, do not restart the event loop
   // io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
   io_exchange_with_code(SW_USER_REJECTED, 0);

    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

//////////////////////////////////////////////////////////////////////
UX_FLOW_DEF_NOCB(ux_approval_tx_1_step,
    pnn,
    {
      &C_icon_eye,
      "Review",
      "Transaction",
    });
UX_FLOW_DEF_NOCB(
    ux_approval_tx_2_step,
    bnnn_paging,
    {
      .title = "Amount",
      .text = global.signTxnContext.amountStr,
    });
UX_FLOW_DEF_NOCB(
    ux_approval_tx_3_step,
    bnnn_paging,
    {
      .title = "Address",
      .text = global.signTxnContext.toAddr,
    });
UX_FLOW_DEF_NOCB(
    ux_approval_tx_4_step,
    bnnn_paging,
    {
      .title = "Shard",
      .text = global.signTxnContext.shardStr,
    });
UX_FLOW_DEF_VALID(
    ux_approval_tx_5_step,
    pbb,
    io_seproxyhal_touch_tx_ok(NULL),
    {
      &C_icon_validate_14,
      "Accept",
      "and send",
    });
UX_FLOW_DEF_VALID(
    ux_approval_tx_6_step,
    pb,
    io_seproxyhal_touch_tx_cancel(NULL),
    {
      &C_icon_crossmark,
      "Reject",
    });

const ux_flow_step_t *        const ux_approval_tx_flow [] = {
  &ux_approval_tx_1_step,
  &ux_approval_tx_2_step,
  &ux_approval_tx_3_step,
  &ux_approval_tx_4_step,
  &ux_approval_tx_5_step,
  &ux_approval_tx_6_step,
  FLOW_END_STEP,
};

#else

static const bagl_element_t ui_tx_approve[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
        UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

        UI_TEXT(0x00, 0, 12, 128, "Sign Transaction?"),
};

static unsigned int ui_tx_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
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
            io_exchange_with_code(SW_OK, SIGNATURE_LEN);

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

        UI_TEXT(0x00, 0, 12, 128, "Shard:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.shardStr),
};

static unsigned int ui_fromshard_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            // Return to the main screen.
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            UX_DISPLAY(ui_tx_approve, NULL);
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
            assign_shard_string();
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
            assign_shard_string();
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
            if ( convertU256ToString(numberBuf, (char *)ctx->amountStr, 78,  &ctx->amountLength) == false) {
                THROW(EXCEPTION_OVERFLOW);
                return 0;
            }
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

#endif

void handleSignTx(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
    if (p1 == P1_FIRST) {
        os_memset(ctx, 0, sizeof(signTxnContext_t));
        os_memset(& ctx->txContext, 0, sizeof(ctx->txContext));
        ctx->length = 0;

        ctx->txContext.workBuffer = ctx->buf;
        ctx->initialized = true;
    }

    //maximal 4 cmd buffers
    if (ctx->length + dataLength > CMD_BUFFER_SIZE * 4) {
        THROW(EXCEPTION_OVERFLOW);
        return;
    }

    // Add the new data to transaction decoder.
    os_memmove(ctx->buf + ctx->length, dataBuffer, dataLength);
    ctx->length += dataLength;

    // Get more packets
    if (p2 != P2_FINISH) {
        THROW(SW_OK);
        return;
    }

    ctx->txContext.commandLength = ctx->length;
    ctx->txContext.txCurrentField = TX_RLP_CONTENT;
    ctx->txContext.content = &ctx->txContent;
    ctx->initialized = false;

#if defined(HAVE_UX_FLOW)
    uint8_t numberBuf[32];
    processTx(& ctx->txContext);
    bech32_get_address((char *)ctx->toAddr, ctx->txContent.destination, 20);

    os_memset(numberBuf, 0, 32);
    os_memcpy(&numberBuf[32- ctx->txContent.value.length], ctx->txContent.value.value, ctx->txContent.value.length);
    if ( convertU256ToString(numberBuf, (char *)ctx->amountStr, 78,  &ctx->amountLength) == false) {
    	THROW(EXCEPTION_OVERFLOW);
    }

    assign_shard_string();
    ux_flow_init(0, ux_approval_tx_flow, NULL);
#else
    os_memmove(ctx->typeStr, "Review Transaction?", 19);
    UX_DISPLAY(ui_signTx_approve, NULL);
#endif

    *flags |= IO_ASYNCH_REPLY;
}
