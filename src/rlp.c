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
#include <stddef.h>

#include "rlp.h"
#include "uint256.h"

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
    context->dataLength = context->currentFieldLength;
    context->txCurrentField++;
    context->stakeCurrentField++;
    context->processingField = false;
}

void copyTxData(txContext_t *context, uint8_t *out, uint32_t length) {
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
    if ( (context->content->directive == DirectiveCreateValidator) ||
         (context->content->directive == DirectiveEditValidator)) {
        context->stakeCurrentField = STAKE_RLP_VALIDATORADDR;
    }
    else {
        context->stakeCurrentField = STAKE_RLP_DELEGATORADDR;
    }
    context->processingField = false;
}

static void processGas(txContext_t *context, txInt256_t *gas) {
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   gas->value + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        gas->length = context->currentFieldLength;
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


static void processShard(txContext_t *context, uint32_t *shard) {
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
        uint8_t *shardIdArray = (uint8_t *) shard;
        for(uint32_t i = 0 ; i < copySize;  i++ ) {
            shardId <<= 8;
            shardId |= shardIdArray[i];
        }

        *shard = shardId;
    }
    if (context->currentFieldPos == context->currentFieldLength) {
        context->txCurrentField++;
        context->processingField = false;
    }
}

static void processAddress(txContext_t *context, uint8_t *address) {
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

static void processDecimal(txContext_t *context) {
    context->stakeCurrentField++;
    context->processingField = false;
}

static void processBlsData(txContext_t *context, uint8_t *address) {
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        if (address != NULL ) {
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
        context->stakeCurrentField++;
        context->processingField = false;
    }
}

static void processString(txContext_t *context, uint8_t *address, uint32_t length) {
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
                processGas(context, &context->content->gasprice);
                break;
            case TX_RLP_GASLIMIT:
                processGas(context, &context->content->startgas);
                break;
            case TX_RLP_FROMSHARD:
                processShard(context, &context->content->fromShard);
                break;
            case TX_RLP_TOSHARD:
                processShard(context, &context->content->toShard);
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
                context->stakeCurrentField = STAKE_RLP_NAME;
                context->processingField = false;
                break;
            case STAKE_RLP_NAME:
                os_memset(context->content->name, 0, MAX_NAME_LEN);
                processString(context, (uint8_t *)context->content->name, MAX_NAME_LEN);
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
                context->stakeCurrentField = STAKE_RLP_RATE;
                context->processingField = false;
                break;
            case STAKE_RLP_RATE:
                processDecimal(context);
		if (context->content->directive == DirectiveEditValidator &&  context->currentFieldLength == 0) {
                    context->stakeCurrentField = STAKE_RLP_MINSELFDELEGATION;
                }
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
                context->stakeCurrentField = STAKE_RLP_BLSPUBKEY;
                context->content->blsPubKeySize = context->currentFieldLength / (MAX_BLS_ADDRESS + 1);
                context->currentBlsKeyIndex = 0;
                context->processingField = false;
                break;
            case STAKE_RLP_BLSPUBKEY:
                processBlsData(context,  (uint8_t *)context->content->blsPubKey);
                if (context->currentBlsKeyIndex * 13 < BLS_KEY_STR_LEN) {
                    char *blsPtr = (char *)context->content->blsKeyStr + context->currentBlsKeyIndex * 13;
                    to_hex(blsPtr, (unsigned char *)context->content->blsPubKey, 10);
                    blsPtr[10] = '.';
                    blsPtr[11] = '.';
                    blsPtr[12] = '.';
                }
                if (++context->currentBlsKeyIndex == context->content->blsPubKeySize) {
                    context->stakeCurrentField = STAKE_RLP_BLSSIGS;
                }
                else {
                    context->stakeCurrentField = STAKE_RLP_BLSPUBKEY;
                }
                break;
            case STAKE_RLP_BLSSIGS:
                context->content->blsPubKeySize = context->currentFieldLength / (MAX_SIG_ADDRESS + 2);
                context->currentBlsKeyIndex = 0;
                context->processingField = false;
                context->stakeCurrentField = STAKE_RLP_BLSSIGNATURE;
                break;
            case STAKE_RLP_BLSSIGNATURE:
                processBlsData(context, NULL);
                if (++context->currentBlsKeyIndex == context->content->blsPubKeySize) {
                    context->stakeCurrentField = STAKE_RLP_AMOUNT;
                }
                else {
                    context->stakeCurrentField = STAKE_RLP_BLSSIGNATURE;
                }
                break;
            case STAKE_RLP_SLOTKEYTOREMOVE:
                os_memmove(context->content->blsKeyStr, "remove:", 7);
                processBlsData(context,  (uint8_t *)context->content->blsPubKey);
                to_hex((char *)context->content->blsKeyStr + 7, (unsigned char *)context->content->blsPubKey, 10);
                context->content->blsKeyStr[17] = '.';
                context->content->blsKeyStr[18] = '.';
                context->content->blsKeyStr[19] = '.';
                break;
            case STAKE_RLP_SLOTKEYTOADD:
                os_memmove(context->content->blsKeyStr + 20, ",add:", 5);
                processBlsData(context,  (uint8_t *)context->content->blsPubKey);
                to_hex((char *)context->content->blsKeyStr + 25, (unsigned char *)context->content->blsPubKey, 10);
                context->content->blsKeyStr[35] = '.';
                context->content->blsKeyStr[36] = '.';
                context->content->blsKeyStr[37] = '.';
                if (context->content->directive == DirectiveEditValidator) {
                    context->stakeCurrentField = STAKE_RLP_SLOTKEYTOADDSIGNATURE;
                } else {
                    return -1;
                }
                break;
            case STAKE_RLP_SLOTKEYTOADDSIGNATURE:
                processBlsData(context, NULL);
                context->stakeCurrentField = STAKE_RLP_EDITACTIVE;
                break;
	    case STAKE_RLP_EDITACTIVE:
                processShard(context, &context->content->fromShard);
		if (context->content->fromShard == 0) {
                    os_memmove(context->content->destination, "Status:Same", 11);
                } else if (context->content->fromShard == 1) {
                    os_memmove(context->content->destination, "Status:Active", 13);
                } else {
                    os_memmove(context->content->destination, "Status:Inactive", 15);
                }
                context->stakeCurrentField = STAKE_RLP_DONE;
                break;
            default:
                return -1;
        }
    }
}
