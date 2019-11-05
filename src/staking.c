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

static signStakingContext_t *ctx = &global.signStakingContext;

static void sign_staking_tx() {
    cx_sha3_t sha3;
    cx_keccak_init(&sha3, 256);
    cx_hash((cx_hash_t *)&sha3, CX_LAST, ctx->buf, ctx->length, ctx->hash, 32);
    deriveAndSign(G_io_apdu_buffer, ctx->hash);
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
            sign_staking_tx();
            io_exchange_with_code(SW_OK, 65);

            // Return to the main screen.
            ui_idle();
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
            sign_staking_tx();
            io_exchange_with_code(SW_OK, 65);

            // Return to the main screen.
            ui_idle();
            break;
    }
    return 0;
}

static const bagl_element_t ui_validator_address_compare[] = {
        UI_BACKGROUND(),

        UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
        UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),

        UI_TEXT(0x00, 0, 12, 128, "Validator Address:"),
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialAddrStr),
};

static const bagl_element_t* ui_prepro_validator_address_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
        case 2:
            return (ctx->displayIndex == sizeof(ctx->toAddr)-12) ? NULL : element;
        default:
            return element;
    }
}

static unsigned int ui_validator_address_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
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
            if ( (ctx->txContent.directive == DirectiveCreateValidator) ||
                 (ctx->txContent.directive == DirectiveEditValidator) ) {
                sign_staking_tx();
                io_exchange_with_code(SW_OK, 65);

                // Return to the main screen.
                ui_idle();
            } else {
                os_memset(numberBuf, 0, 32);
                os_memcpy(&numberBuf[32 - ctx->txContent.value.length], ctx->txContent.value.value,
                          ctx->txContent.value.length);
                convertU256ToString(numberBuf, (char *) ctx->amountStr, &ctx->amountLength);
                ctx->displayIndex = 0;
                if (ctx->amountLength > 12) {
                    os_memmove(ctx->partialAmountStr, ctx->amountStr, 12);
                    ctx->partialAmountStr[12] = 0;
                    UX_DISPLAY(ui_amount_compare_large, ui_prepro_amount_compare);
                } else {
                    os_memmove(ctx->partialAmountStr, ctx->amountStr, ctx->amountLength);
                    ctx->partialAmountStr[ctx->amountLength] = 0;
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
        UI_TEXT(0x00, 0, 26, 128, global.signStakingContext.partialAddrStr),
};

static const bagl_element_t* ui_prepro_delegator_address_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
        case 2:
            return (ctx->displayIndex == sizeof(ctx->toAddr)-12) ? NULL : element;
        default:
            return element;
    }
}

static unsigned int ui_delegator_address_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
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
            if (ctx->txContent.directive == DirectiveCollectRewards) {
                sign_staking_tx();
                io_exchange_with_code(SW_OK, 65);

                // Return to the main screen.
                ui_idle();
            } else {
                bech32_get_address((char *) ctx->toAddr, ctx->txContent.validatorAddress, 20);
                os_memmove(ctx->partialAddrStr, ctx->toAddr, 12);
                ctx->partialAddrStr[12] = '\0';
                ctx->displayIndex = 0;
                UX_DISPLAY(ui_validator_address_compare, ui_prepro_validator_address_compare);
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

        UI_TEXT(0x00, 0, 12, 128, global.signStakingContext.typeStr),
};

static unsigned int ui_signStaking_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
    switch (button_mask) {
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            if ( (ctx->txContent.directive == DirectiveCreateValidator) ||
                 (ctx->txContent.directive == DirectiveEditValidator) ) {
                bech32_get_address((char *)ctx->toAddr, ctx->txContent.validatorAddress, 20);
                os_memmove(ctx->partialAddrStr, ctx->toAddr, 12);
                ctx->partialAddrStr[12] = '\0';
                ctx->displayIndex = 0;
                UX_DISPLAY(ui_validator_address_compare, ui_prepro_validator_address_compare);
            } else {
                bech32_get_address((char *) ctx->toAddr, ctx->txContent.destination, 20);
                os_memmove(ctx->partialAddrStr, ctx->toAddr, 12);
                ctx->partialAddrStr[12] = '\0';
                ctx->displayIndex = 0;
                UX_DISPLAY(ui_delegator_address_compare, ui_prepro_delegator_address_compare);
            }
            break;
    }
    return 0;
}

void handleSignStaking(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
    os_memset(ctx, 0, sizeof(signStakingContext_t));
    os_memset(& ctx->txContext, 0, sizeof(ctx->txContext));

    ctx->length = dataLength;
    os_memmove(ctx->buf, dataBuffer, dataLength);

    ctx->txContext.workBuffer = ctx->buf;
    ctx->txContext.commandLength = ctx->length;

    ctx->txContext.stakeCurrentField = STAKE_RLP_CONTENT;
    ctx->txContext.content = &ctx->txContent;

    if (processStaking(& ctx->txContext) != 0 ) {
        THROW(INVALID_PARAMETER);
    }

    if (ctx->txContent.directive == DirectiveCreateValidator) {
        os_memmove(ctx->typeStr, "Create Validator?", 18);
    }
    else if (ctx->txContent.directive == DirectiveEditValidator) {
        os_memmove(ctx->typeStr, "Edit Validator?", 16);
    }
    else if (ctx->txContent.directive == DirectiveDelegate) {
        os_memmove(ctx->typeStr, "Sign Delegate?", 15);
    }
    else if (ctx->txContent.directive == DirectiveUndelegate) {
        os_memmove(ctx->typeStr, "Sign Undelegate?", 17);
    }
    else if (ctx->txContent.directive == DirectiveCollectRewards) {
        os_memmove(ctx->typeStr, "Collect Rewards?", 17);
    }
    else {
        THROW(INVALID_PARAMETER);
    }

    UX_DISPLAY(ui_signStaking_approve, NULL);
    *flags |= IO_ASYNCH_REPLY;
}