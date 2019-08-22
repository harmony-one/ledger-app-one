/*
 * Copyright (c) 2017 Brian Barto
 * 
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GPL License. See LICENSE for more details.
 */

#include <stddef.h>
#include <string.h>
#include <stdint.h>
#include "bech32.h"
#include "base32.h"

#define BECH32_PREFIX_MAINNET         "one"
#define BECH32_PREFIX_TESTNET         "tone"
#define BECH32_SEPARATOR              '1'
#define BECH32_CHECKSUM_LENGTH         6

static uint32_t bech32_polymod_step(uint8_t value, uint32_t chk);

int bech32_get_address(char *output, unsigned char *data, size_t data_len)
{
	int i, l, c, r;
	char *hrp;
	uint32_t chk;

	chk = 1;

	hrp = BECH32_PREFIX_MAINNET;

	// hrp
	l = strlen(hrp);
	for (i = 0; i < l; ++i)
	{
		*(output++) = hrp[i];
		chk = bech32_polymod_step((hrp[i] >> 5), chk);
	}
	chk = bech32_polymod_step(0, chk);
	for (i = 0; i < l; ++i)
	{
		chk = bech32_polymod_step((hrp[i] & 31), chk);
	}

	// separator
	*(output++) = BECH32_SEPARATOR;

	// data
	r = base32_encode(output, data, data_len);
	if (r < 0)
	{
		return -1;
	}
	l = strlen(output);
	for (i = 0; i < l; ++i)
	{
		r = base32_get_raw(*output);
		if (r < 0)
		{
			return -1;
		}
		chk = bech32_polymod_step(r, chk);
		output++;
	}

	// trailing zeros needed for checksum
	for (i = 0; i < 6; ++i)
	{
		chk = bech32_polymod_step(0, chk);
	}

	chk ^= 1;

	// get/append checksum
	for (i = 0; i < BECH32_CHECKSUM_LENGTH; ++i)
	{
		c = base32_get_char((chk >> (5 * (5 - i))) & 31);
		if (c < 0)
		{
			return -1;
		}
		*(output++) = (char)c;
	}

	*output = '\0';

	return 1;
	
}


static uint32_t bech32_polymod_step(uint8_t value, uint32_t chk)
{
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
	{
		chk ^= ((b >> i) & 1) ? gen[i] : 0;
	}

	return chk;
}
