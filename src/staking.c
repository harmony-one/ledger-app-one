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
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <os.h>
#include <os_io_seproxyhal.h>
#include "harmony.h"
#include "ui.h"
#include "rlp.h"
#include "bech32.h"
#include "uint256.h"

static signStakingContext_t *ctx = &global.signStakingContext;

static void sign_staking_tx() {
    cx_sha3_t sha3;
    cx_keccak_init(&sha3, 256);
    cx_hash((cx_hash_t *)&sha3, CX_LAST, ctx->buf, ctx->length, ctx->hash, 32);
    deriveAndSign(G_io_apdu_buffer, ctx->hash);
}

#if defined(HAVE_UX_FLOW) // UI using Nano X SDK
unsigned int io_seproxyhal_touch_staking_ok(const bagl_element_t *e) {
    sign_staking_tx();
    io_exchange_with_code(SW_OK, SIGNATURE_LEN);

    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

unsigned int io_seproxyhal_touch_staking_cancel(const bagl_element_t *e) {

    // Send back the response, do not restart the event loop
   // io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, 2);
   io_exchange_with_code(SW_USER_REJECTED, 0);

    // Display back the original UX
    ui_idle();
    return 0; // do not redraw the widget
}

//////////////////////////////////////////////////////////////////////
UX_FLOW_DEF_NOCB(
    ux_staking_flow_1_step,
    pnn,
    {
      &C_icon_eye,
      "Verify",
      "Staking",
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_2_step,
    bnnn_paging,
    {
      .title = "Directive",
      .text = global.signStakingContext.partialStr,
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_3_step,
    bnnn_paging,
    {
      .title = "DelegatorAddress",
      .text = global.signStakingContext.delegatorAddr,
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_4_step,
    bnnn_paging,
    {
      .title = "ValidatorAddress",
      .text = global.signStakingContext.validatorAddr,
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_5_step,
    bnnn_paging,
    {
      .title = "Amount",
      .text = global.signStakingContext.amountStr,
    });
UX_FLOW_DEF_VALID(
    ux_staking_flow_6_step,
    pb,
    io_seproxyhal_touch_staking_ok(NULL),
    {
      &C_icon_validate_14,
      "Approve",
    });
UX_FLOW_DEF_VALID(
    ux_staking_flow_7_step,
    pb,
    io_seproxyhal_touch_staking_cancel(NULL),
    {
      &C_icon_crossmark,
      "Reject",
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_8_step,
    bnnn_paging,
    {
      .title = "Description",
      .text = global.signStakingContext.nameStr,
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_9_step,
    bnnn_paging,
    {
      .title = "CommissionRate",
      .text = global.signStakingContext.commissionRateStr,
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_10_step,
    bnnn_paging,
    {
      .title = "Delegation",
      .text = global.signStakingContext.delegationStr,
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_11_step,
    bnnn_paging,
    {
      .title = "BlsKey",
      .text = global.signStakingContext.fullStr,
    });
UX_FLOW_DEF_NOCB(
    ux_staking_flow_12_step,
    bnnn_paging,
    {
      .title = "EposStatus",
      .text = global.signStakingContext.statusStr,
    });

const ux_flow_step_t *        const ux_staking_create_valiator_flow [] = {
  &ux_staking_flow_1_step,
  &ux_staking_flow_2_step,
  &ux_staking_flow_8_step,
  &ux_staking_flow_4_step,
  &ux_staking_flow_9_step,
  &ux_staking_flow_10_step,
  &ux_staking_flow_11_step,
  &ux_staking_flow_5_step,
  &ux_staking_flow_6_step,
  &ux_staking_flow_7_step,
  FLOW_END_STEP,
};
const ux_flow_step_t *        const ux_staking_edit_validator_flow [] = {
  &ux_staking_flow_1_step,
  &ux_staking_flow_2_step,
  &ux_staking_flow_8_step,
  &ux_staking_flow_4_step,
  &ux_staking_flow_9_step,
  &ux_staking_flow_10_step,
  &ux_staking_flow_11_step,
  &ux_staking_flow_12_step,
  &ux_staking_flow_6_step,
  &ux_staking_flow_7_step,
  FLOW_END_STEP,
};
const ux_flow_step_t *        const ux_staking_delegate_flow [] = {
  &ux_staking_flow_1_step,
  &ux_staking_flow_2_step,
  &ux_staking_flow_3_step,
  &ux_staking_flow_4_step,
  &ux_staking_flow_5_step,
  &ux_staking_flow_6_step,
  &ux_staking_flow_7_step,
  FLOW_END_STEP,
};
const ux_flow_step_t *        const ux_staking_collect_rewards_flow [] = {
  &ux_staking_flow_1_step,
  &ux_staking_flow_2_step,
  &ux_staking_flow_3_step,
  &ux_staking_flow_6_step,
  &ux_staking_flow_7_step,
  FLOW_END_STEP,
};

#else  // UI using ledger Nano S SDK
static const bagl_element_t ui_confirm_signing[] = {
        UI_BACKGROUND(),
        UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
        UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

        UI_TEXT(0x00, 0, 12, 128, "Sign Stake?"),
};

static unsigned int ui_confirm_signing_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            sign_staking_tx();
            io_exchange_with_code(SW_OK, SIGNATURE_LEN);

            // Return to the main screen.
            ui_idle();
            break;
    }
    return 0;
}

static const bagl_element_t ui_bls_keys[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "BLS Keys"),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialStr),
};

static unsigned int ui_bls_keys_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
            }
            memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->fullStrLength - 12) {
                ctx->displayIndex++;
            }
            memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            UX_DISPLAY(ui_confirm_signing, NULL);
            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
}

static const bagl_element_t ui_delegation_rate[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Delegation"),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialStr),
};

static unsigned int ui_delegation_rate_button(unsigned int button_mask, unsigned int button_mask_counter) {
    uint32_t offset = 0;
    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
            }
            memmove(ctx->partialStr, ctx->fullStr + ctx->displayIndex, 12);
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->fullStrLength - 12) {
                ctx->displayIndex++;
            }
            memmove(ctx->partialStr, ctx->fullStr + ctx->displayIndex, 12);
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            memset(ctx->fullStr, 0, sizeof(ctx->fullStr));
            if ( ctx->txContent.directive == DirectiveCreateValidator)  {
                int totalNumOfKeysToDisplay = ctx->txContent.blsPubKeySize;
                //cap at 10 BLS keys, each key takes 13 bytes
                if (totalNumOfKeysToDisplay > 10) {
                    totalNumOfKeysToDisplay = 10;
                }
                memmove(ctx->fullStr, ctx->txContent.blsKeyStr, 13 * totalNumOfKeysToDisplay);
                offset += 13 * totalNumOfKeysToDisplay;
            } else {
                //7 + 13 + 5 + 13 = 38 bytes
                memmove(ctx->fullStr, ctx->txContent.blsKeyStr, 38);
                offset += 38;
            }

            ctx->fullStrLength = offset;
            memmove(ctx->partialStr, ctx->fullStr, 12);
            UX_DISPLAY(ui_bls_keys, NULL);
            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
}

static const bagl_element_t ui_commission_rate[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Commission"),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialStr),
};

static unsigned int ui_commission_rate_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
            }
            memmove(ctx->partialStr, ctx->fullStr + ctx->displayIndex, 12);
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->fullStrLength - 12) {
                ctx->displayIndex++;
            }
            memmove(ctx->partialStr, ctx->fullStr + ctx->displayIndex, 12);
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            if ( (ctx->txContent.directive == DirectiveCreateValidator) ||
                 (ctx->txContent.directive == DirectiveEditValidator) ) {
                uint32_t outLen, offset = 0;
                //re-use hash buf to save stack space
                uint8_t *numberBuf = &ctx->hash[0];

                memset(ctx->fullStr, 0, sizeof(ctx->fullStr));

                if (ctx->txContent.directive == DirectiveCreateValidator) {
                    memmove(ctx->fullStr + offset, "amount:", 7);
                    offset += 7;
                    memset(numberBuf, 0, 32);
                    memmove(&numberBuf[32 - ctx->txContent.value.length], ctx->txContent.value.value,
                               ctx->txContent.value.length);
                    if (convertU256ToString(numberBuf, (char *)ctx->fullStr + offset, 78, &outLen) == false) {
                        THROW(EXCEPTION_OVERFLOW);
                        return 0;
                    }

                    offset += outLen;

                    memmove(ctx->fullStr + offset, ",min:", 5);
                    offset += 5;
                } else {
                    memmove(ctx->fullStr + offset, "min:", 4);
                    offset += 4;
                }

                memset(numberBuf, 0, 32);
                memmove(&numberBuf[32 - ctx->txContent.minSelfDelegation.length],
                           ctx->txContent.minSelfDelegation.value, ctx->txContent.minSelfDelegation.length);
                if (convertU256ToString(numberBuf, (char *)ctx->fullStr + offset, 78, &outLen) == false) {
                    THROW(EXCEPTION_OVERFLOW);
                    return 0;
                }
                offset += outLen;

                memmove(ctx->fullStr + offset, ",max:", 5);
                offset += 5;
                memset(numberBuf, 0, 32);
                memmove(&numberBuf[32 - ctx->txContent.maxTotalDelegation.length],
                           ctx->txContent.maxTotalDelegation.value, ctx->txContent.maxTotalDelegation.length);
                if (convertU256ToString(numberBuf, (char *)ctx->fullStr + offset, 78, &outLen) == false) {
                    THROW(EXCEPTION_OVERFLOW);
                    return 0;
                }
                offset += outLen;

                ctx->fullStrLength = offset;
                memmove(ctx->partialStr, ctx->fullStr, 12);
                UX_DISPLAY(ui_delegation_rate, NULL);
            }
            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
}

static const bagl_element_t ui_description_compare[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Name"),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialStr),
};

static unsigned int ui_description_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
            }
            memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->fullStrLength-12) {
                ctx->displayIndex++;
            }
            memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            if ( (ctx->txContent.directive == DirectiveCreateValidator) ||
                 (ctx->txContent.directive == DirectiveEditValidator) ) {
                char      output[80];
                uint32_t  offset = 0;

                memset(ctx->fullStr, 0, sizeof(ctx->fullStr));
                memmove(ctx->fullStr + offset, "rate:", 5);
                offset += 5;
                if (convertNumericDecimalToString(ctx->txContent.rate.value, ctx->txContent.rate.length, output) == false) {
                    THROW(EXCEPTION_OVERFLOW);
                    return 0;
                }
                memmove(ctx->fullStr + offset , output, strlen(output));
                offset += strlen(output);

                if (ctx->txContent.directive == DirectiveCreateValidator) {
                    memmove(ctx->fullStr + offset, ",max:", 5);
                    offset += 5;
                    if (convertNumericDecimalToString(ctx->txContent.maxRate.value, ctx->txContent.maxRate.length, output) == false) {
                        THROW(EXCEPTION_OVERFLOW);
                        return 0;
                    }
                    memmove(ctx->fullStr + offset , output, strlen(output));
                    offset += strlen(output);

                    memmove(ctx->fullStr + offset, ",change:", 8);
                    offset += 8;
                    if (convertNumericDecimalToString(ctx->txContent.maxChangeRate.value, ctx->txContent.maxChangeRate.length, output) == false) {
                        THROW(EXCEPTION_OVERFLOW);
                        return 0;
                    }
                    memmove(ctx->fullStr + offset , output, strlen(output));
                    offset += strlen(output);
                }

                ctx->fullStrLength = offset;
                memmove(ctx->partialStr, ctx->fullStr, 12);
                UX_DISPLAY(ui_commission_rate, NULL);
            }
            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
}

static const bagl_element_t ui_amount_compare_large[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Amount:"),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialStr),
};


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
            if (ctx->fullStrLength > 12) {
                memmove(ctx->partialStr, ctx->fullStr + ctx->displayIndex, 12);
            }
            else {
                memmove(ctx->partialStr, ctx->fullStr + ctx->displayIndex, ctx->fullStrLength);
            }
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->fullStrLength - 12) {
                ctx->displayIndex++;
            }
            if (ctx->fullStrLength > 12) {
                memmove(ctx->partialStr, ctx->fullStr + ctx->displayIndex, 12);
            }
            else {
                memmove(ctx->partialStr, ctx->fullStr + ctx->displayIndex, ctx->fullStrLength);
            }
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            UX_DISPLAY(ui_confirm_signing, NULL);
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
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialStr),
};

static unsigned int ui_amount_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            // Return to the main screen.
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            UX_DISPLAY(ui_confirm_signing, NULL);
            break;
    }
    return 0;
}

static const bagl_element_t ui_validator_address_compare[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Validator Address:"),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialStr),
};

static unsigned int ui_validator_address_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
            }

            memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->fullStrLength-12) {
                ctx->displayIndex++;
            }
            memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            memset(ctx->fullStr, 0, sizeof(ctx->fullStr));
            if ( (ctx->txContent.directive == DirectiveCreateValidator) ||
                 (ctx->txContent.directive == DirectiveEditValidator) ) {
                    memmove(ctx->fullStr, ctx->txContent.name, strlen(ctx->txContent.name));
                    ctx->fullStrLength = strlen(ctx->txContent.name);
                    memmove(ctx->partialStr, ctx->fullStr, 12);
                    UX_DISPLAY(ui_description_compare, NULL);

            } else {
                //re-use hash buf to save stack space
                uint8_t *numberBuf = &ctx->hash[0];
                memset(numberBuf, 0, 32);
                memcpy(&numberBuf[32 - ctx->txContent.value.length], ctx->txContent.value.value,
                          ctx->txContent.value.length);
                if (convertU256ToString(numberBuf, (char *)ctx->fullStr, 78, &ctx->fullStrLength) == false) {
                    THROW(EXCEPTION_OVERFLOW);
                    return 0;
                }
                ctx->displayIndex = 0;
                if (ctx->fullStrLength > 12) {
                    memmove(ctx->partialStr, ctx->fullStr, 12);
                    ctx->partialStr[12] = 0;
                    UX_DISPLAY(ui_amount_compare_large, NULL);
                } else {
                    memmove(ctx->partialStr, ctx->fullStr, ctx->fullStrLength);
                    ctx->partialStr[ctx->fullStrLength] = 0;
                    UX_DISPLAY(ui_amount_compare, NULL);
                }
            }

            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
}

static const bagl_element_t ui_delegator_address_compare[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Delegator Address:"),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialStr),
};

static unsigned int ui_delegator_address_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
            }

            memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
            // Re-render the screen.
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->fullStrLength-12) {
                ctx->displayIndex++;
            }
            memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            memset(ctx->fullStr, 0, sizeof(ctx->fullStr));
            if (ctx->txContent.directive == DirectiveCollectRewards) {
                UX_DISPLAY(ui_confirm_signing, NULL);
            } else {
                bech32_get_address((char *) ctx->fullStr, ctx->txContent.validatorAddress, 20);
                memmove(ctx->partialStr, ctx->fullStr, 12);
                ctx->partialStr[12] = '\0';
                ctx->displayIndex = 0;
                UX_DISPLAY(ui_validator_address_compare, NULL);
            }
            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
}

static const bagl_element_t ui_signStaking_approve[] = {
        UI_BACKGROUND(),
        UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
        UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

        UI_TEXT(0x00, 0, 12, 128, global.signStakingContext.partialStr),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.fullStr),
};

static unsigned int ui_signStaking_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            memset(ctx->fullStr, 0, sizeof(ctx->fullStr));
            if ( (ctx->txContent.directive == DirectiveCreateValidator) ||
                 (ctx->txContent.directive == DirectiveEditValidator) ) {
                bech32_get_address((char *)ctx->fullStr, ctx->txContent.validatorAddress, 20);
                ctx->fullStrLength = MAX_ONE_ADDRESS;
                memmove(ctx->partialStr, ctx->fullStr, 12);
                ctx->partialStr[12] = '\0';
                ctx->displayIndex = 0;
                UX_DISPLAY(ui_validator_address_compare, NULL);
            } else {
                bech32_get_address((char *) ctx->fullStr, ctx->txContent.destination, 20);
                ctx->fullStrLength = MAX_ONE_ADDRESS;
                memmove(ctx->partialStr, ctx->fullStr, 12);
                ctx->partialStr[12] = '\0';
                ctx->displayIndex = 0;
                UX_DISPLAY(ui_delegator_address_compare, NULL);
            }
            break;
    }
    return 0;
}

#endif

void handleSignStaking(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
    if (p1 == P1_FIRST) {
        memset(ctx, 0, sizeof(signStakingContext_t));
        memset(& ctx->txContext, 0, sizeof(ctx->txContext));
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
    memmove(ctx->buf + ctx->length, dataBuffer, dataLength);
    ctx->length += dataLength;

    // Get more packets
    if (p2 != P2_FINISH) {
        THROW(SW_OK);
        return;
    }

    ctx->txContext.commandLength = ctx->length;
    ctx->txContext.stakeCurrentField = STAKE_RLP_CONTENT;
    ctx->txContext.content = &ctx->txContent;
    ctx->initialized = false;

    if (processStaking(& ctx->txContext) != 0 ) {
        THROW(INVALID_PARAMETER);
    }

    if (ctx->txContent.directive == DirectiveCreateValidator) {
        memmove(ctx->partialStr, "Create Validator", 17);
    }
    else if (ctx->txContent.directive == DirectiveEditValidator) {
        memmove(ctx->partialStr, "Edit Validator", 15);
    }
    else if (ctx->txContent.directive == DirectiveDelegate) {
        memmove(ctx->partialStr, "Delegate", 9);
    }
    else if (ctx->txContent.directive == DirectiveUndelegate) {
        memmove(ctx->partialStr, "Undelegate", 11);
    }
    else if (ctx->txContent.directive == DirectiveCollectRewards) {
        memmove(ctx->partialStr, "Collect Rewards", 16);
    }
    else {
        THROW(INVALID_PARAMETER);
    }

#if defined(HAVE_UX_FLOW)
    memset(ctx->fullStr, 0, sizeof(ctx->fullStr));
    if ( (ctx->txContent.directive == DirectiveCreateValidator) ||
    	(ctx->txContent.directive == DirectiveEditValidator) ) {

         bech32_get_address((char *)ctx->validatorAddr, ctx->txContent.validatorAddress, 20);

	 char      output[80];
         uint32_t  outLen,offset = 0;
	 uint8_t   *numberBuf = &ctx->hash[0];

         memset(ctx->commissionRateStr, 0, sizeof(ctx->commissionRateStr));
         memmove(ctx->commissionRateStr + offset, "rate:", 5);
               
	 offset += 5;
         if (convertNumericDecimalToString(ctx->txContent.rate.value, ctx->txContent.rate.length, output) == false) {
         	THROW(EXCEPTION_OVERFLOW);
         }

         memmove(ctx->commissionRateStr + offset , output, strlen(output));
         offset += strlen(output);

	 if (ctx->txContent.directive == DirectiveCreateValidator) {
		// process commission rate
         	memmove(ctx->commissionRateStr + offset, ",max:", 5);
                offset += 5;
                if (convertNumericDecimalToString(ctx->txContent.maxRate.value, ctx->txContent.maxRate.length, output) == false) {
                	THROW(EXCEPTION_OVERFLOW);
                }

                memmove(ctx->commissionRateStr + offset , output, strlen(output));
                offset += strlen(output);

                memmove(ctx->commissionRateStr + offset, ",change:", 8);
                offset += 8;
                if (convertNumericDecimalToString(ctx->txContent.maxChangeRate.value, ctx->txContent.maxChangeRate.length, output) == false) {
                	THROW(EXCEPTION_OVERFLOW);
                }
                memmove(ctx->commissionRateStr + offset , output, strlen(output));

		// process amount
         	memset(numberBuf, 0, 32);
         	memcpy(&numberBuf[32 - ctx->txContent.value.length], ctx->txContent.value.value,
                          ctx->txContent.value.length);
         	if (convertU256ToString(numberBuf, (char *)ctx->amountStr, 78, &ctx->fullStrLength) == false) {
               	     THROW(EXCEPTION_OVERFLOW);
         	}
	 }

         offset = 0;
         memmove(ctx->delegationStr + offset, "min:", 4);
         offset += 4;

         memset(numberBuf, 0, 32);
         memmove(&numberBuf[32 - ctx->txContent.minSelfDelegation.length],
                   ctx->txContent.minSelfDelegation.value, ctx->txContent.minSelfDelegation.length);
         if (convertU256ToString(numberBuf, (char *)ctx->delegationStr + offset, 78, &outLen) == false) {
         	THROW(EXCEPTION_OVERFLOW);
         }

         offset += outLen;
         memmove(ctx->delegationStr + offset, ",max:", 5);
         offset += 5;
         memset(numberBuf, 0, 32);
         memmove(&numberBuf[32 - ctx->txContent.maxTotalDelegation.length],
                   ctx->txContent.maxTotalDelegation.value, ctx->txContent.maxTotalDelegation.length);
         if (convertU256ToString(numberBuf, (char *)ctx->delegationStr + offset, 78, &outLen) == false) {
                   THROW(EXCEPTION_OVERFLOW);
         }

	 memset(ctx->fullStr, 0, sizeof(ctx->fullStr));
         if ( ctx->txContent.directive == DirectiveCreateValidator)  {
         	int totalNumOfKeysToDisplay = ctx->txContent.blsPubKeySize;
                //cap at 10 BLS keys, each key takes 13 bytes
                if (totalNumOfKeysToDisplay > 10) {
                    totalNumOfKeysToDisplay = 10;
                }
                memmove(ctx->fullStr, ctx->txContent.blsKeyStr, 13 * totalNumOfKeysToDisplay);
          } else {
                //7 + 13 + 5 + 13 = 38 bytes
                memmove(ctx->fullStr, ctx->txContent.blsKeyStr, 38);
          }
    } else {
         bech32_get_address((char *)ctx->delegatorAddr, ctx->txContent.destination, 20);

	 if (ctx->txContent.directive != DirectiveCollectRewards) {
         	bech32_get_address((char *)ctx->validatorAddr, ctx->txContent.validatorAddress, 20);

	 	uint8_t *numberBuf = &ctx->hash[0];
         	memset(numberBuf, 0, 32);
         	memcpy(&numberBuf[32 - ctx->txContent.value.length], ctx->txContent.value.value,
                          ctx->txContent.value.length);
         	if (convertU256ToString(numberBuf, (char *)ctx->amountStr, 78, &ctx->fullStrLength) == false) {
               	     THROW(EXCEPTION_OVERFLOW);
         	}
	 }
    }

    if (strlen(ctx->txContent.name) == 0) {
        memcpy(ctx->nameStr, "null", 4 );
    } else {
        memcpy(ctx->nameStr, ctx->txContent.name, strlen(ctx->txContent.name));
    }

    if (ctx->txContent.directive == DirectiveCreateValidator) {
    	ux_flow_init(0, ux_staking_create_valiator_flow, NULL);
    } else if (ctx->txContent.directive == DirectiveEditValidator)  {
        if (ctx->txContent.fromShard == 0) {
                memmove(ctx->statusStr, "Same", 4 );
	} else if (ctx->txContent.fromShard == 1) {
                memmove(ctx->statusStr, "Active", 6);
	} else {
                memmove(ctx->statusStr, "Inactive", 8);
        }
    	ux_flow_init(0, ux_staking_edit_validator_flow, NULL);
    } else if (ctx->txContent.directive == DirectiveCollectRewards) {
    	ux_flow_init(0, ux_staking_collect_rewards_flow, NULL);
    } else {
    	ux_flow_init(0, ux_staking_delegate_flow, NULL);
    }

#else
    if (ctx->txContent.directive == DirectiveEditValidator)  {
	// 15 is size of string "Status:Inactive" 
        memmove(ctx->fullStr, ctx->txContent.destination, 15);
    } else {
        memset(ctx->fullStr, 0, sizeof(ctx->fullStr));
    }
    UX_DISPLAY(ui_signStaking_approve, NULL);
#endif
    *flags |= IO_ASYNCH_REPLY;
}
