/*******************************************************************************
*   Ledger Ethereum App
*   (c) 2016-2019 Ledger
*
*  Licensed under the Apache License, Version 2.0 (the "License");
*  you may not use this file except in compliance with the License.
*  You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License.
********************************************************************************/

// Adapted from https://github.com/LedgerHQ/ledger-app-eth/src_common/ethUstream.c
#include <stdbool.h>
#include <stdint.h>

#include "rlp.h"

bool rlpCanDecode(uint8_t *buffer, uint32_t bufferLength, bool *valid) {
    if (*buffer <= 0x7f) {
    } else if (*buffer <= 0xb7) {
    } else if (*buffer <= 0xbf) {
        if (bufferLength < (1 + (*buffer - 0xb7))) {
            return false;
        }
        if (*buffer > 0xbb) {
            *valid = false; // arbitrary 32 bits length limitation
            return true;
        }
    } else if (*buffer <= 0xf7) {
    } else {
        if (bufferLength < (1 + (*buffer - 0xf7))) {
            return false;
        }
        if (*buffer > 0xfb) {
            *valid = false; // arbitrary 32 bits length limitation
            return true;
        }
    }
    *valid = true;
    return true;
}

static void processContent(txContext_t *context) {
    // Keep the full length for sanity checks, move to the next field
    if (!context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_CONTENT\n");
        THROW(EXCEPTION);
    }
    context->dataLength = context->currentFieldLength;
    context->txCurrentField++;
    context->stakeCurrentField++;
    context->processingField = false;
}

void copyTxData(txContext_t *context, uint8_t *out, uint32_t length) {
    if (context->commandLength < length) {
        PRINTF("copyTxData Underflow\n");
        THROW(EXCEPTION);
    }
    if (out != NULL) {
        os_memmove(out, context->workBuffer, length);
    }
    context->workBuffer += length;
    context->commandLength -= length;
    if (context->processingField) {
        context->currentFieldPos += length;
    }
}

static void processNonce(txContext_t *context) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_NONCE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT256) {
        PRINTF("Invalid length for RLP_NONCE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context, NULL, copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        context->txCurrentField++;
        context->stakeCurrentField++;
        context->processingField = false;
    }
}

static void processDirective(txContext_t *context) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for STAKING DIRECTIVE \n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > 4) {
        PRINTF("Invalid length for STAKING DIRECTIVE %d\n",
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   (uint8_t *)&context->content->directive + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        context->stakeCurrentField++;
        context->processingField = false;
    }
}

static void processStakingMessage(txContext_t *context) {
    if (! context->currentFieldIsList) {
        PRINTF("Invalid type for RLP STAKING MESSAGE \n");
        THROW(EXCEPTION);
    }

    if ( (context->content->directive == DirectiveCreateValidator) ||
         (context->content->directive == DirectiveEditValidator)) {
        context->stakeCurrentField = STAKE_RLP_VALIDATORADDR;
    }
    else {
        //DirectiveDelegate, DirectiveUnDelegate, DirectiveCollectReWards
        context->stakeCurrentField = STAKE_RLP_DELEGATORADDR;
    }
    context->processingField = false;
}


static void processGasLimit(txContext_t *context) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_GASLIMIT\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT256) {
        PRINTF("Invalid length for RLP_GASLIMIT %d\n",
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   context->content->startgas.value + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        context->content->startgas.length = context->currentFieldLength;
        context->txCurrentField++;
        context->stakeCurrentField++;
        context->processingField = false;
    }
}

static void processGasprice(txContext_t *context) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_GASPRICE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT256) {
        PRINTF("Invalid length for RLP_GASPRICE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   context->content->gasprice.value + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        context->content->gasprice.length = context->currentFieldLength;
        context->txCurrentField++;
        context->stakeCurrentField++;
        context->processingField = false;
    }
}

bool rlpDecodeLength(uint8_t *buffer, uint32_t bufferLength,
                     uint32_t *fieldLength, uint32_t *offset, bool *list) {
    if (*buffer <= 0x7f) {
        *offset = 0;
        *fieldLength = 1;
        *list = false;
    } else if (*buffer <= 0xb7) {
        *offset = 1;
        *fieldLength = *buffer - 0x80;
        *list = false;
    } else if (*buffer <= 0xbf) {
        *offset = 1 + (*buffer - 0xb7);
        *list = false;
        switch (*buffer) {
            case 0xb8:
                *fieldLength = *(buffer + 1);
                break;
            case 0xb9:
                *fieldLength = (*(buffer + 1) << 8) + *(buffer + 2);
                break;
            case 0xba:
                *fieldLength =
                        (*(buffer + 1) << 16) + (*(buffer + 2) << 8) + *(buffer + 3);
                break;
            case 0xbb:
                *fieldLength = (*(buffer + 1) << 24) + (*(buffer + 2) << 16) +
                               (*(buffer + 3) << 8) + *(buffer + 4);
                break;
            default:
                return false; // arbitrary 32 bits length limitation
        }
    } else if (*buffer <= 0xf7) {
        *offset = 1;
        *fieldLength = *buffer - 0xc0;
        *list = true;
    } else {
        *offset = 1 + (*buffer - 0xf7);
        *list = true;
        switch (*buffer) {
            case 0xf8:
                *fieldLength = *(buffer + 1);
                break;
            case 0xf9:
                *fieldLength = (*(buffer + 1) << 8) + *(buffer + 2);
                break;
            case 0xfa:
                *fieldLength =
                        (*(buffer + 1) << 16) + (*(buffer + 2) << 8) + *(buffer + 3);
                break;
            case 0xfb:
                *fieldLength = (*(buffer + 1) << 24) + (*(buffer + 2) << 16) +
                               (*(buffer + 3) << 8) + *(buffer + 4);
                break;
            default:
                return false; // arbitrary 32 bits length limitation
        }
    }

    return true;
}

uint8_t readTxByte(txContext_t *context) {
    uint8_t data;
    data = *context->workBuffer;
    context->workBuffer++;
    context->commandLength--;
    if (context->processingField) {
        context->currentFieldPos++;
    }

    return data;
}

static void processValue(txContext_t *context, txInt256_t *value) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_VALUE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT256) {
        PRINTF("Invalid length for RLP_VALUE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   value->value + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        value->length = context->currentFieldLength;
        context->txCurrentField++;
        context->stakeCurrentField++;
        context->processingField = false;
    }
}


static void processShard(txContext_t *context, uint8_t *shard) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for FROM SHARD \n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > 4) {
        PRINTF("Invalid length for FROM SHARD %d\n",
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   shard + context->currentFieldPos,
                   copySize);

        //adjust from big endian to little endian
        uint32_t shardId = 0;
        uint8_t *shardIdArray = (uint8_t *) &context->content->fromShard;
        for(uint32_t i = 0 ; i < context->currentFieldLength;  i++ ) {
            shardId <<= 8;
            shardId |= shardIdArray[i];
        }
        context->content->fromShard = shardId;
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        context->txCurrentField++;
        context->processingField = false;
    }
}


static void processAddress(txContext_t *context, uint8_t *address) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_ADDRESS\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_ECC_ADDRESS) {
        PRINTF("Invalid length for RLP ADDRESS\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   address + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        context->txCurrentField++;
        context->stakeCurrentField++;
        context->processingField = false;
    }
}

static void processDescription(txContext_t *context) {
    if (! context->currentFieldIsList) {
        PRINTF("Invalid type for RLP STAKING MESSAGE \n");
        THROW(EXCEPTION);
    }

    context->stakeCurrentField = STAKE_RLP_NAME;
    context->processingField = false;
}

static void processCommissionRates(txContext_t *context) {
    if (! context->currentFieldIsList) {
        PRINTF("Invalid type for RLP STAKING COMMISSIONRATES \n");
        THROW(EXCEPTION);
    }

    context->stakeCurrentField = STAKE_RLP_RATE;
    context->processingField = false;
}

static void processSlotPubKeys(txContext_t *context) {
    if (! context->currentFieldIsList) {
        PRINTF("Invalid type for RLP STAKING SLOT PUBKEYS \n");
        THROW(EXCEPTION);
    }

    context->stakeCurrentField = STAKE_RLP_BLSPUBKEY;
    context->content->blsPubKeySize = context->currentFieldLength / (MAX_BLS_ADDRESS + 1);
    context->currentBlsKeyIndex = 0;
    context->processingField = false;
}

static void processDecimal(txContext_t *context) {
    if (! context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_DECIMAL\n");
        THROW(EXCEPTION);
    }

    context->stakeCurrentField++;
    context->processingField = false;
}

static void processBlsPubKey(txContext_t *context, uint8_t **address) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_BLSPUBKEY\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_BLS_ADDRESS) {
        PRINTF("Invalid length for RLP_BLSPUBKEY\n");
        THROW(EXCEPTION);
    }

    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   address + context->currentFieldPos,
                   copySize);
    }

    if (context->currentFieldPos == context->currentFieldLength) {
        context->txCurrentField++;
        context->stakeCurrentField++;
        context->processingField = false;
    }
}

static void processString(txContext_t *context, uint8_t *address, uint32_t length) {
    if (context->currentFieldIsList) {
        PRINTF("Invalid type for RLP_STRING\n");
        THROW(EXCEPTION);
    }
    if ((address != NULL) && (context->currentFieldLength > length)) {
        PRINTF("Invalid length for RLP STRING\n");
        THROW(EXCEPTION);
    }

    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);

        if (address != NULL) {
            copyTxData(context,
                       address + context->currentFieldPos,
                       copySize);
        } else {
            copyTxData(context,
                       NULL,
                       copySize);
        }
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        context->txCurrentField++;
        context->stakeCurrentField++;
        context->processingField = false;
    }
}

int processTx(txContext_t *context) {
    for (;;) {
        if (context->txCurrentField == TX_RLP_DONE) {
            return 0;
        }

        if (context->commandLength == 0) {
            return 1;
        }

        if (!context->processingField) {
            bool canDecode = false;
            uint32_t offset;
            while (context->commandLength != 0) {
                bool valid;
                // Feed the RLP buffer until the length can be decoded
                if (context->commandLength < 1) {
                    return -1;
                }
                context->rlpBuffer[context->rlpBufferPos++] =
                        readTxByte(context);
                if (rlpCanDecode(context->rlpBuffer, context->rlpBufferPos,
                                 &valid)) {
                    // Can decode now, if valid
                    if (!valid) {
                        return -1;
                    }
                    canDecode = true;
                    break;
                }
                // Cannot decode yet
                // Sanity check
                if (context->rlpBufferPos == sizeof(context->rlpBuffer)) {
                    return -1;
                }
            }
            if (!canDecode) {
                return 1;
            }
            // Ready to process this field
            if (!rlpDecodeLength(context->rlpBuffer, context->rlpBufferPos,
                                 &context->currentFieldLength, &offset,
                                 &context->currentFieldIsList)) {
                return -1;
            }
            if (offset == 0) {
                // Hack for single byte, self encoded
                context->workBuffer--;
                context->commandLength++;
                context->fieldSingleByte = true;
            } else {
                context->fieldSingleByte = false;
            }
            context->currentFieldPos = 0;
            context->rlpBufferPos = 0;
            context->processingField = true;
        }


        switch (context->txCurrentField) {
            case TX_RLP_CONTENT:
                processContent(context);
                break;
            case TX_RLP_NONCE:
                processNonce(context);
                break;
            case TX_RLP_GASPRICE:
                processGasprice(context);
                break;
            case TX_RLP_GASLIMIT:
                processGasLimit(context);
                break;
            case TX_RLP_FROMSHARD:
                processShard(context, (uint8_t *)&context->content->fromShard);
                break;
            case TX_RLP_TOSHARD:
                processShard(context, (uint8_t *)&context->content->toShard);
                break;
            case TX_RLP_TO:
                processAddress(context, context->content->destination);
                break;
            case TX_RLP_AMOUNT:
                processValue(context, &context->content->value);
                return 0;
            default:
                return -1;
        }
    }
}

int processStaking(struct txContext_t *context) {
    for (;;) {
        if (context->stakeCurrentField == STAKE_RLP_DONE) {
            return 0;
        }

        if (context->commandLength == 0) {
            return 1;
        }

        if (!context->processingField) {
            bool canDecode = false;
            uint32_t offset;
            while (context->commandLength != 0) {
                bool valid;
                // Feed the RLP buffer until the length can be decoded
                if (context->commandLength < 1) {
                    return -1;
                }
                context->rlpBuffer[context->rlpBufferPos++] =
                        readTxByte(context);
                if (rlpCanDecode(context->rlpBuffer, context->rlpBufferPos,
                                 &valid)) {
                    // Can decode now, if valid
                    if (!valid) {
                        return -1;
                    }
                    canDecode = true;
                    break;
                }
                // Cannot decode yet
                // Sanity check
                if (context->rlpBufferPos == sizeof(context->rlpBuffer)) {
                    return -1;
                }
            }
            if (!canDecode) {
                return 1;
            }
            // Ready to process this field
            if (!rlpDecodeLength(context->rlpBuffer, context->rlpBufferPos,
                                 &context->currentFieldLength, &offset,
                                 &context->currentFieldIsList)) {
                return -1;
            }
            if (offset == 0) {
                // Hack for single byte, self encoded
                context->workBuffer--;
                context->commandLength++;
                context->fieldSingleByte = true;
            } else {
                context->fieldSingleByte = false;
            }
            context->currentFieldPos = 0;
            context->rlpBufferPos = 0;
            context->processingField = true;
        }

        switch (context->stakeCurrentField) {
            case STAKE_RLP_CONTENT:
                processContent(context);
                break;
            case STAKE_RLP_DIRECTIVE:
                processDirective(context);
                break;
            case STAKE_RLP_STAKEMESSAGE:
                processStakingMessage(context);
                break;
            case STAKE_RLP_DELEGATORADDR:
                processAddress(context, context->content->destination);
                if (context->content->directive == DirectiveCollectRewards) {
                    context->stakeCurrentField = STAKE_RLP_DONE;
                }
                break;
            case STAKE_RLP_VALIDATORADDR:
                processAddress(context, context->content->validatorAddress);
                if ((context->content->directive == DirectiveDelegate)
                    || (context->content->directive == DirectiveUndelegate)) {
                    context->stakeCurrentField = STAKE_RLP_AMOUNT;
                }
                else  {
                    context->stakeCurrentField = STAKE_RLP_DESCRIPTION;
                }
                break;
            case STAKE_RLP_AMOUNT:
                processValue(context, &context->content->value);
                if ((context->content->directive == DirectiveDelegate)
                    || (context->content->directive == DirectiveUndelegate)
                    || (context->content->directive == DirectiveCreateValidator)) {
                    context->stakeCurrentField = STAKE_RLP_DONE;
                } else {
                    return  -1;
                }
                break;
            case STAKE_RLP_NONCE:
                context->stakeCurrentField = STAKE_RLP_DONE;
                break;
            case STAKE_RLP_DESCRIPTION:
                processDescription(context);
                break;
            case STAKE_RLP_NAME:
                os_memset(context->content->name, 0, MAX_NAME_LEN);
                processString(context, context->content->name, MAX_NAME_LEN);
                break;
            case STAKE_RLP_IDENTITY:
                processString(context, NULL, 0);
                break;
            case STAKE_RLP_WEBSITE:
                processString(context, NULL, 0);
                break;
            case STAKE_RLP_SECURITYCONTACT:
                processString(context, NULL, 0);
                break;
            case STAKE_RLP_DETAILS:
                processString(context, NULL, 0);
                if (context->content->directive == DirectiveEditValidator) {
                    context->stakeCurrentField = STAKE_RLP_RATE;
                }
                break;
            case STAKE_RLP_COMMISSIONRATES:
                processCommissionRates(context);
                break;
            case STAKE_RLP_RATE:
                processDecimal(context);
                break;
            case STAKE_RLP_RATE_VALUE:
                processValue(context, &context->content->rate);
                if (context->content->directive == DirectiveEditValidator) {
                    context->stakeCurrentField = STAKE_RLP_MINSELFDELEGATION;
                }
                break;
            case STAKE_RLP_MAXRATE:
                processDecimal(context);
                break;
            case STAKE_RLP_MAXRATE_VALUE:
                processValue(context, &context->content->maxRate);
                break;
            case STAKE_RLP_MAXCHANGERATE:
                processDecimal(context);
                break;
            case STAKE_RLP_MAXCHANGERATE_VALUE:
                processValue(context, &context->content->maxChangeRate);
                break;
            case STAKE_RLP_MINSELFDELEGATION:
                processValue(context, &context->content->minSelfDelegation);
                break;
            case STAKE_RLP_MAXTOTALDELEGATION:
                processValue(context, &context->content->maxTotalDelegation);
                if (context->content->directive == DirectiveCreateValidator) {
                    context->stakeCurrentField = STAKE_RLP_SLOTPUBKEYS;
                }
                else if (context->content->directive == DirectiveEditValidator) {
                    context->stakeCurrentField = STAKE_RLP_SLOTKEYTOREMOVE;
                } else {
                    return  -1;
                }
                break;
            case STAKE_RLP_SLOTPUBKEYS:
                processSlotPubKeys(context);
                context->stakeCurrentField = STAKE_RLP_BLSPUBKEY;
                break;
            case STAKE_RLP_BLSPUBKEY:
                processBlsPubKey(context, (uint8_t **)&context->content->blsPubKey[context->currentBlsKeyIndex++]);
                if (context->currentBlsKeyIndex == context->content->blsPubKeySize) {
                    context->stakeCurrentField = STAKE_RLP_AMOUNT;
                }
                else {
                    context->stakeCurrentField = STAKE_RLP_BLSPUBKEY;
                }
                break;
            case STAKE_RLP_SLOTKEYTOREMOVE:
                processBlsPubKey(context, (uint8_t **)&context->content->slotKeyToRemove);
                break;
            case STAKE_RLP_SLOTKEYTOADD:
                processBlsPubKey(context, (uint8_t **)&context->content->slotKeyToAdd);
                if (context->content->directive == DirectiveEditValidator) {
                    context->stakeCurrentField = STAKE_RLP_DONE;
                } else {
                    return -1;
                }
                break;
            default:
                return -1;
        }
    }
}
