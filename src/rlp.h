#ifndef _RLP_H
#define _RLP_H

#include <stdint.h>
#include "os.h"
#include "cx.h"

#define MAX_INT256 32
#define MAX_ECC_ADDRESS 20
#define MAX_BLS_ADDRESS 48
#define MAX_INT32  4

//max length of staking validator description fields
#define MAX_NAME_LEN            30
#define MAX_IDENTITY_LEN        30
#define MAX_WEBSITE_LEN         20
#define MAX_SECURITYCONTACT_LEN 20
#define MAX_DETAIL_LEN          20
#define MAX_BLS_PUB_KEYS        4

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
    STAKE_RLP_AMOUNT,
    STAKE_RLP_NONCE,
    STAKE_RLP_GASPRICE,
    STAKE_RLP_GASLIMIT,
    STAKE_RLP_DESCRIPTION,
    STAKE_RLP_NAME,
    STAKE_RLP_IDENTITY,
    STAKE_RLP_WEBSITE,
    STAKE_RLP_SECURITYCONTACT,
    STAKE_RLP_DETAILS,
    STAKE_RLP_COMMISSIONRATES,
    STAKE_RLP_RATE,
    STAKE_RLP_RATE_VALUE,
    STAKE_RLP_MAXRATE,
    STAKE_RLP_MAXRATE_VALUE,
    STAKE_RLP_MAXCHANGERATE,
    STAKE_RLP_MAXCHANGERATE_VALUE,
    STAKE_RLP_MINSELFDELEGATION,
    STAKE_RLP_MAXTOTALDELEGATION,
    STAKE_RLP_SLOTPUBKEYS,
    STAKE_RLP_BLSPUBKEY,
    STAKE_RLP_SLOTKEYTOREMOVE,
    STAKE_RLP_SLOTKEYTOADD,
    STAKE_RLP_DONE
} rlpStakingField_e;

typedef enum stakingDirective_e {
    DirectiveCreateValidator = 0,
    DirectiveEditValidator,
    DirectiveDelegate,
    DirectiveUndelegate,
    DirectiveCollectRewards
} stakingDirective_e;

typedef struct txInt256_t {
    uint8_t value[32];
    uint8_t length;
} txInt256_t;

typedef struct txContent_t {
    txInt256_t gasprice;
    txInt256_t startgas;
    txInt256_t value;
    txInt256_t rate;
    txInt256_t maxRate;
    txInt256_t maxChangeRate;
    txInt256_t minSelfDelegation;
    txInt256_t maxTotalDelegation;
    uint32_t   fromShard;
    uint32_t   toShard;
    uint32_t   directive;
    uint8_t    destination[MAX_ECC_ADDRESS];
    uint8_t    validatorAddress[MAX_ECC_ADDRESS];
    uint8_t    blsPubKey[MAX_BLS_PUB_KEYS][MAX_BLS_ADDRESS];
    uint32_t   blsPubKeySize;
    uint8_t    slotKeyToRemove[MAX_BLS_ADDRESS];
    uint8_t    slotKeyToAdd[MAX_BLS_ADDRESS];
    uint8_t    name[MAX_NAME_LEN];
    uint8_t    identity[MAX_IDENTITY_LEN];
    uint8_t    website[MAX_WEBSITE_LEN];
    uint8_t    securityContact[MAX_SECURITYCONTACT_LEN];
    uint8_t    details[MAX_DETAIL_LEN];
} txContent_t;

typedef struct txContext_t {
    rlpTxField_e       txCurrentField;
    rlpStakingField_e  stakeCurrentField;
    uint32_t currentFieldLength;
    uint32_t currentFieldPos;
    uint32_t currentBlsKeyIndex;
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
