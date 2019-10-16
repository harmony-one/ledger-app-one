#ifndef _RLP_H
#define _RLP_H

#include <stdint.h>
#include "os.h"
#include "cx.h"

#define MAX_INT256 32
#define MAX_ADDRESS 20
#define MAX_INT32  4

typedef enum rlpTxField_e {
    TX_RLP_NONE = 0,
    TX_RLP_CONTENT,
    TX_RLP_NONCE,
    TX_RLP_GASPRICE,
    TX_RLP_GASLIMIT,
    TX_RLP_FROMSHARD,
    TX_RLP_TOSHARD,
    TX_RLP_TO,
    TX_RLP_AMOUNT,
    TX_RLP_DONE
} rlpTxField_e;

typedef enum rlpStakingField_e {
    STAKE_RLP_NONE = 0,
    STAKE_RLP_CONTENT,
    STAKE_RLP_DIRECTIVE,
    STAKE_RLP_STAKEMESSAGE,
    STAKE_RLP_DELEGATORADDR,
    STAKE_RLP_VALIDATORADDR,
    STAKE_RLP_VALIDATORSRCADDR,
    STAKE_RLP_VALIDATORDESTADDR,
    STAKE_RLP_AMOUNT,
    STAKE_RLP_NONCE,
    STAKE_RLP_GASPRICE,
    STAKE_RLP_GASLIMIT,
    STAKE_RLP_DONE
} rlpStakingField_e;

typedef enum stakingDirective_e {
    DirectiveNewValidator = 0,
    DirectiveEditValidator,
    DirectiveDelegate,
    DirectiveRedelegate,
    DirectiveUndelegate
} stakingDirective_e;

typedef struct txInt256_t {
    uint8_t value[32];
    uint8_t length;
} txInt256_t;

typedef struct txContent_t {
    txInt256_t gasprice;
    txInt256_t startgas;
    txInt256_t value;
    txInt256_t minSelfDelegation;
    uint32_t   fromShard;
    uint32_t   toShard;
    uint32_t   directive;
    uint8_t    destination[20];
    uint8_t    destinationLength;
    uint8_t    validatorAddress[20];
    uint8_t    validatorAddressLength;
    uint8_t    validatorDstAddress[20];
    uint8_t    validatorDstAddressLength;
} txContent_t;

typedef struct txContext_t {
    rlpTxField_e       txCurrentField;
    rlpStakingField_e  stakeCurrentField;
    uint32_t currentFieldLength;
    uint32_t currentFieldPos;
    bool currentFieldIsList;
    bool processingField;
    bool fieldSingleByte;
    uint32_t dataLength;
    uint8_t rlpBuffer[5];
    uint32_t rlpBufferPos;
    uint8_t *workBuffer;
    uint32_t commandLength;
    uint32_t processingFlags;
    txContent_t *content;
} txContext_t;

int processTx(txContext_t *context);
int processStaking(txContext_t *context);

#endif //_RLP_H
