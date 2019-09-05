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
    TX_RLP_STARTGAS,
    TX_RLP_FROMSHARD,
    TX_RLP_TOSHARD,
    TX_RLP_TO,
    TX_RLP_AMOUNT,
    TX_RLP_DONE
} rlpTxField_e;

typedef struct txInt256_t {
    uint8_t value[32];
    uint8_t length;
} txInt256_t;

typedef struct txContent_t {
    txInt256_t gasprice;
    txInt256_t startgas;
    txInt256_t value;
    uint32_t   fromShard;
    uint32_t   toShard;
    uint8_t destination[20];
    uint8_t destinationLength;
} txContent_t;

typedef struct txContext_t {
    rlpTxField_e currentField;
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

#endif //_RLP_H
