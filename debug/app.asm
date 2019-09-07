
bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0d00000 <main>:
		}
	}
	END_TRY_L(exit);
}

__attribute__((section(".boot"))) int main(void) {
c0d00000:	b5b0      	push	{r4, r5, r7, lr}
c0d00002:	b08c      	sub	sp, #48	; 0x30
	// exit critical section
	__asm volatile("cpsie i");
c0d00004:	b662      	cpsie	i
c0d00006:	4c13      	ldr	r4, [pc, #76]	; (c0d00054 <main+0x54>)
c0d00008:	2100      	movs	r1, #0

	for (;;) {
		UX_INIT();
c0d0000a:	22b0      	movs	r2, #176	; 0xb0
c0d0000c:	4620      	mov	r0, r4
c0d0000e:	f001 fdfb 	bl	c0d01c08 <os_memset>
		os_boot();
c0d00012:	f001 fd49 	bl	c0d01aa8 <os_boot>
c0d00016:	ad01      	add	r5, sp, #4
		BEGIN_TRY {
			TRY {
c0d00018:	4628      	mov	r0, r5
c0d0001a:	f004 ff89 	bl	c0d04f30 <setjmp>
c0d0001e:	8528      	strh	r0, [r5, #40]	; 0x28
c0d00020:	b280      	uxth	r0, r0
c0d00022:	2800      	cmp	r0, #0
c0d00024:	d006      	beq.n	c0d00034 <main+0x34>
c0d00026:	2810      	cmp	r0, #16
c0d00028:	d0ee      	beq.n	c0d00008 <main+0x8>
			FINALLY {
			}
		}
		END_TRY;
	}
	app_exit();
c0d0002a:	f001 fd19 	bl	c0d01a60 <app_exit>
	return 0;
c0d0002e:	2000      	movs	r0, #0
c0d00030:	b00c      	add	sp, #48	; 0x30
c0d00032:	bdb0      	pop	{r4, r5, r7, pc}
c0d00034:	a801      	add	r0, sp, #4

	for (;;) {
		UX_INIT();
		os_boot();
		BEGIN_TRY {
			TRY {
c0d00036:	f001 fd3a 	bl	c0d01aae <try_context_set>
				io_seproxyhal_init();
c0d0003a:	f001 ffd9 	bl	c0d01ff0 <io_seproxyhal_init>
				USB_power(0);
c0d0003e:	2000      	movs	r0, #0
c0d00040:	f004 fd0e 	bl	c0d04a60 <USB_power>
				USB_power(1);
c0d00044:	2001      	movs	r0, #1
c0d00046:	f004 fd0b 	bl	c0d04a60 <USB_power>
				ui_idle();
c0d0004a:	f001 f941 	bl	c0d012d0 <ui_idle>
				one_main();
c0d0004e:	f001 fc79 	bl	c0d01944 <one_main>
c0d00052:	46c0      	nop			; (mov r8, r8)
c0d00054:	20001880 	.word	0x20001880

c0d00058 <base32_encode>:
#define BASE32_CODE_STRING_LENGTH 32

static char *code_string = "qpzry9x8gf2tvdw0s3jn54khce6mua7l";

int base32_encode(char *output, unsigned char *data, size_t data_len)
{
c0d00058:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0005a:	b081      	sub	sp, #4
c0d0005c:	4604      	mov	r4, r0
	int i, c, output_len;

	output_len = base32_encode_raw((unsigned char*)output, data, data_len);
c0d0005e:	f000 f819 	bl	c0d00094 <base32_encode_raw>

	for (i = 0; i < output_len; ++i)
c0d00062:	2801      	cmp	r0, #1
c0d00064:	db0e      	blt.n	c0d00084 <base32_encode+0x2c>
c0d00066:	2200      	movs	r2, #0
c0d00068:	4d09      	ldr	r5, [pc, #36]	; (c0d00090 <base32_encode+0x38>)
c0d0006a:	447d      	add	r5, pc
c0d0006c:	4613      	mov	r3, r2
	{
		c = base32_get_char((int)output[i]);
c0d0006e:	5ce7      	ldrb	r7, [r4, r3]
c0d00070:	18e6      	adds	r6, r4, r3
c0d00072:	43d1      	mvns	r1, r2
	return r;
}

int base32_get_char(int c)
{
	if (c < 0 || c >= BASE32_CODE_STRING_LENGTH)
c0d00074:	2f1f      	cmp	r7, #31
c0d00076:	d808      	bhi.n	c0d0008a <base32_encode+0x32>
	{
		return -1;
	}
	return (int)code_string[c];
c0d00078:	5de9      	ldrb	r1, [r5, r7]
		c = base32_get_char((int)output[i]);
		if (c < 0)
		{
			return -1;
		}
		output[i] = (char)c;
c0d0007a:	7031      	strb	r1, [r6, #0]
{
	int i, c, output_len;

	output_len = base32_encode_raw((unsigned char*)output, data, data_len);

	for (i = 0; i < output_len; ++i)
c0d0007c:	1c5b      	adds	r3, r3, #1
c0d0007e:	4283      	cmp	r3, r0
c0d00080:	dbf5      	blt.n	c0d0006e <base32_encode+0x16>
		{
			return -1;
		}
		output[i] = (char)c;
	}
	output[i] = '\0';
c0d00082:	18e4      	adds	r4, r4, r3
c0d00084:	2000      	movs	r0, #0
c0d00086:	7020      	strb	r0, [r4, #0]
c0d00088:	2101      	movs	r1, #1

	return 1;
}
c0d0008a:	4608      	mov	r0, r1
c0d0008c:	b001      	add	sp, #4
c0d0008e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00090:	00004f5e 	.word	0x00004f5e

c0d00094 <base32_encode_raw>:

int base32_encode_raw(unsigned char *output, unsigned char *data, size_t data_len)
{
c0d00094:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00096:	b087      	sub	sp, #28
c0d00098:	9102      	str	r1, [sp, #8]
c0d0009a:	4606      	mov	r6, r0
c0d0009c:	2000      	movs	r0, #0
	size_t i, j, k;
	int r;

	*output = 0;
c0d0009e:	7030      	strb	r0, [r6, #0]
c0d000a0:	9203      	str	r2, [sp, #12]
	for (i = 0, k = 0; i < data_len; ++i)
c0d000a2:	2a00      	cmp	r2, #0
c0d000a4:	d032      	beq.n	c0d0010c <base32_encode_raw+0x78>
c0d000a6:	2000      	movs	r0, #0
c0d000a8:	4604      	mov	r4, r0
c0d000aa:	9006      	str	r0, [sp, #24]
c0d000ac:	9001      	str	r0, [sp, #4]
c0d000ae:	4601      	mov	r1, r0
c0d000b0:	9802      	ldr	r0, [sp, #8]
c0d000b2:	9104      	str	r1, [sp, #16]
c0d000b4:	1840      	adds	r0, r0, r1
c0d000b6:	9005      	str	r0, [sp, #20]
c0d000b8:	9f01      	ldr	r7, [sp, #4]
	{
		for (j = 0; j < 8; ++j)
		{
			*output <<= 1;
c0d000ba:	20ff      	movs	r0, #255	; 0xff
c0d000bc:	0040      	lsls	r0, r0, #1
c0d000be:	0061      	lsls	r1, r4, #1
c0d000c0:	4001      	ands	r1, r0
c0d000c2:	7031      	strb	r1, [r6, #0]
			*output += ((data[i] << j) & 0x80) >> 7;
c0d000c4:	9805      	ldr	r0, [sp, #20]
c0d000c6:	7800      	ldrb	r0, [r0, #0]
c0d000c8:	40b8      	lsls	r0, r7
c0d000ca:	09c4      	lsrs	r4, r0, #7
c0d000cc:	2501      	movs	r5, #1
c0d000ce:	402c      	ands	r4, r5
c0d000d0:	430c      	orrs	r4, r1
c0d000d2:	7034      	strb	r4, [r6, #0]
			if ((++k % 5) == 0)
c0d000d4:	9806      	ldr	r0, [sp, #24]
c0d000d6:	19c0      	adds	r0, r0, r7
c0d000d8:	1c40      	adds	r0, r0, #1
c0d000da:	2105      	movs	r1, #5
c0d000dc:	f004 fdc4 	bl	c0d04c68 <__aeabi_uidivmod>
c0d000e0:	2900      	cmp	r1, #0
c0d000e2:	d102      	bne.n	c0d000ea <base32_encode_raw+0x56>
c0d000e4:	2400      	movs	r4, #0
			{
				output++;
				*output = 0;
c0d000e6:	7074      	strb	r4, [r6, #1]
		{
			*output <<= 1;
			*output += ((data[i] << j) & 0x80) >> 7;
			if ((++k % 5) == 0)
			{
				output++;
c0d000e8:	1c76      	adds	r6, r6, #1
	int r;

	*output = 0;
	for (i = 0, k = 0; i < data_len; ++i)
	{
		for (j = 0; j < 8; ++j)
c0d000ea:	1c7f      	adds	r7, r7, #1
c0d000ec:	2f08      	cmp	r7, #8
c0d000ee:	d1e4      	bne.n	c0d000ba <base32_encode_raw+0x26>
c0d000f0:	9904      	ldr	r1, [sp, #16]
{
	size_t i, j, k;
	int r;

	*output = 0;
	for (i = 0, k = 0; i < data_len; ++i)
c0d000f2:	1c49      	adds	r1, r1, #1
	{
		for (j = 0; j < 8; ++j)
c0d000f4:	9806      	ldr	r0, [sp, #24]
c0d000f6:	3008      	adds	r0, #8
{
	size_t i, j, k;
	int r;

	*output = 0;
	for (i = 0, k = 0; i < data_len; ++i)
c0d000f8:	9006      	str	r0, [sp, #24]
c0d000fa:	9803      	ldr	r0, [sp, #12]
c0d000fc:	4281      	cmp	r1, r0
c0d000fe:	d1d7      	bne.n	c0d000b0 <base32_encode_raw+0x1c>
	output[i] = '\0';

	return 1;
}

int base32_encode_raw(unsigned char *output, unsigned char *data, size_t data_len)
c0d00100:	9803      	ldr	r0, [sp, #12]
c0d00102:	00c0      	lsls	r0, r0, #3
				output++;
				*output = 0;
			}
		}
	}
	r = ++k / 5;
c0d00104:	4328      	orrs	r0, r5
c0d00106:	2105      	movs	r1, #5
c0d00108:	f004 fd28 	bl	c0d04b5c <__aeabi_uidiv>

	return r;
c0d0010c:	b007      	add	sp, #28
c0d0010e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00110 <base32_get_char>:
}

int base32_get_char(int c)
{
c0d00110:	2100      	movs	r1, #0
c0d00112:	43c9      	mvns	r1, r1
	if (c < 0 || c >= BASE32_CODE_STRING_LENGTH)
c0d00114:	281f      	cmp	r0, #31
c0d00116:	d802      	bhi.n	c0d0011e <base32_get_char+0xe>
	{
		return -1;
	}
	return (int)code_string[c];
c0d00118:	4902      	ldr	r1, [pc, #8]	; (c0d00124 <base32_get_char+0x14>)
c0d0011a:	4479      	add	r1, pc
c0d0011c:	5c09      	ldrb	r1, [r1, r0]
}
c0d0011e:	4608      	mov	r0, r1
c0d00120:	4770      	bx	lr
c0d00122:	46c0      	nop			; (mov r8, r8)
c0d00124:	00004eae 	.word	0x00004eae

c0d00128 <base32_get_raw>:

int base32_get_raw(char c)
{
c0d00128:	2200      	movs	r2, #0
c0d0012a:	4b07      	ldr	r3, [pc, #28]	; (c0d00148 <base32_get_raw+0x20>)
c0d0012c:	447b      	add	r3, pc
	int i;

	for (i = 0; i < BASE32_CODE_STRING_LENGTH; ++i)
	{
		if (c == code_string[i])
c0d0012e:	5c99      	ldrb	r1, [r3, r2]
c0d00130:	4281      	cmp	r1, r0
c0d00132:	d005      	beq.n	c0d00140 <base32_get_raw+0x18>
c0d00134:	2100      	movs	r1, #0
c0d00136:	43c9      	mvns	r1, r1

int base32_get_raw(char c)
{
	int i;

	for (i = 0; i < BASE32_CODE_STRING_LENGTH; ++i)
c0d00138:	1c52      	adds	r2, r2, #1
c0d0013a:	2a20      	cmp	r2, #32
c0d0013c:	dbf7      	blt.n	c0d0012e <base32_get_raw+0x6>
c0d0013e:	e000      	b.n	c0d00142 <base32_get_raw+0x1a>
c0d00140:	4611      	mov	r1, r2
		{
			return i;
		}
	}
	return -1;
c0d00142:	4608      	mov	r0, r1
c0d00144:	4770      	bx	lr
c0d00146:	46c0      	nop			; (mov r8, r8)
c0d00148:	00004e9c 	.word	0x00004e9c

c0d0014c <bech32_get_address>:
#define BECH32_CHECKSUM_LENGTH         6

static uint32_t bech32_polymod_step(uint8_t value, uint32_t chk);

int bech32_get_address(char *output, unsigned char *data, size_t data_len)
{
c0d0014c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0014e:	b087      	sub	sp, #28
c0d00150:	9204      	str	r2, [sp, #16]
c0d00152:	9103      	str	r1, [sp, #12]
c0d00154:	2700      	movs	r7, #0
c0d00156:	2201      	movs	r2, #1
c0d00158:	4961      	ldr	r1, [pc, #388]	; (c0d002e0 <bech32_get_address+0x194>)
c0d0015a:	9106      	str	r1, [sp, #24]
c0d0015c:	9002      	str	r0, [sp, #8]
c0d0015e:	4605      	mov	r5, r0
c0d00160:	4638      	mov	r0, r7

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
	{
		chk ^= ((b >> i) & 1) ? gen[i] : 0;
c0d00162:	a661      	add	r6, pc, #388	; (adr r6, c0d002e8 <bech32_get_address+0x19c>)

	// hrp
	l = strlen(hrp);
	for (i = 0; i < l; ++i)
	{
		*(output++) = hrp[i];
c0d00164:	a15f      	add	r1, pc, #380	; (adr r1, c0d002e4 <bech32_get_address+0x198>)
c0d00166:	5c09      	ldrb	r1, [r1, r0]
c0d00168:	9505      	str	r5, [sp, #20]
c0d0016a:	7029      	strb	r1, [r5, #0]
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
c0d0016c:	0154      	lsls	r4, r2, #5
c0d0016e:	9b06      	ldr	r3, [sp, #24]
c0d00170:	401c      	ands	r4, r3
	// hrp
	l = strlen(hrp);
	for (i = 0; i < l; ++i)
	{
		*(output++) = hrp[i];
		chk = bech32_polymod_step((hrp[i] >> 5), chk);
c0d00172:	094b      	lsrs	r3, r1, #5
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
c0d00174:	4323      	orrs	r3, r4
{
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
c0d00176:	0e52      	lsrs	r2, r2, #25
c0d00178:	463d      	mov	r5, r7
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
	{
		chk ^= ((b >> i) & 1) ? gen[i] : 0;
c0d0017a:	2401      	movs	r4, #1
c0d0017c:	4621      	mov	r1, r4
c0d0017e:	40a9      	lsls	r1, r5
c0d00180:	4211      	tst	r1, r2
c0d00182:	4639      	mov	r1, r7
c0d00184:	d001      	beq.n	c0d0018a <bech32_get_address+0x3e>
c0d00186:	00a9      	lsls	r1, r5, #2
c0d00188:	5871      	ldr	r1, [r6, r1]
c0d0018a:	404b      	eors	r3, r1
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
c0d0018c:	1c6d      	adds	r5, r5, #1
c0d0018e:	2d05      	cmp	r5, #5
c0d00190:	d1f3      	bne.n	c0d0017a <bech32_get_address+0x2e>

	hrp = BECH32_PREFIX_MAINNET;

	// hrp
	l = strlen(hrp);
	for (i = 0; i < l; ++i)
c0d00192:	1c40      	adds	r0, r0, #1
c0d00194:	9d05      	ldr	r5, [sp, #20]
	{
		*(output++) = hrp[i];
c0d00196:	1c6d      	adds	r5, r5, #1

	hrp = BECH32_PREFIX_MAINNET;

	// hrp
	l = strlen(hrp);
	for (i = 0; i < l; ++i)
c0d00198:	2803      	cmp	r0, #3
c0d0019a:	461a      	mov	r2, r3
c0d0019c:	d1e2      	bne.n	c0d00164 <bech32_get_address+0x18>
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
c0d0019e:	015d      	lsls	r5, r3, #5
c0d001a0:	9806      	ldr	r0, [sp, #24]
c0d001a2:	4005      	ands	r5, r0
{
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
c0d001a4:	0e5a      	lsrs	r2, r3, #25
c0d001a6:	2300      	movs	r3, #0
c0d001a8:	4619      	mov	r1, r3
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
	{
		chk ^= ((b >> i) & 1) ? gen[i] : 0;
c0d001aa:	a64f      	add	r6, pc, #316	; (adr r6, c0d002e8 <bech32_get_address+0x19c>)
c0d001ac:	4620      	mov	r0, r4
c0d001ae:	4088      	lsls	r0, r1
c0d001b0:	4210      	tst	r0, r2
c0d001b2:	4618      	mov	r0, r3
c0d001b4:	d001      	beq.n	c0d001ba <bech32_get_address+0x6e>
c0d001b6:	0088      	lsls	r0, r1, #2
c0d001b8:	5830      	ldr	r0, [r6, r0]
c0d001ba:	4045      	eors	r5, r0
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
c0d001bc:	1c49      	adds	r1, r1, #1
c0d001be:	2905      	cmp	r1, #5
c0d001c0:	d1f4      	bne.n	c0d001ac <bech32_get_address+0x60>
c0d001c2:	2600      	movs	r6, #0
c0d001c4:	4633      	mov	r3, r6
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
c0d001c6:	0168      	lsls	r0, r5, #5
c0d001c8:	9906      	ldr	r1, [sp, #24]
c0d001ca:	4008      	ands	r0, r1
		chk = bech32_polymod_step((hrp[i] >> 5), chk);
	}
	chk = bech32_polymod_step(0, chk);
	for (i = 0; i < l; ++i)
	{
		chk = bech32_polymod_step((hrp[i] & 31), chk);
c0d001cc:	a145      	add	r1, pc, #276	; (adr r1, c0d002e4 <bech32_get_address+0x198>)
c0d001ce:	5ccf      	ldrb	r7, [r1, r3]
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
c0d001d0:	211f      	movs	r1, #31
c0d001d2:	9105      	str	r1, [sp, #20]
c0d001d4:	400f      	ands	r7, r1
c0d001d6:	4307      	orrs	r7, r0
{
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
c0d001d8:	0e6a      	lsrs	r2, r5, #25
c0d001da:	4631      	mov	r1, r6
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
	{
		chk ^= ((b >> i) & 1) ? gen[i] : 0;
c0d001dc:	4620      	mov	r0, r4
c0d001de:	4088      	lsls	r0, r1
c0d001e0:	4210      	tst	r0, r2
c0d001e2:	4635      	mov	r5, r6
c0d001e4:	d002      	beq.n	c0d001ec <bech32_get_address+0xa0>
c0d001e6:	0088      	lsls	r0, r1, #2
c0d001e8:	a53f      	add	r5, pc, #252	; (adr r5, c0d002e8 <bech32_get_address+0x19c>)
c0d001ea:	582d      	ldr	r5, [r5, r0]
c0d001ec:	406f      	eors	r7, r5
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
c0d001ee:	1c49      	adds	r1, r1, #1
c0d001f0:	2905      	cmp	r1, #5
c0d001f2:	d1f3      	bne.n	c0d001dc <bech32_get_address+0x90>
	{
		*(output++) = hrp[i];
		chk = bech32_polymod_step((hrp[i] >> 5), chk);
	}
	chk = bech32_polymod_step(0, chk);
	for (i = 0; i < l; ++i)
c0d001f4:	1c5b      	adds	r3, r3, #1
c0d001f6:	2b03      	cmp	r3, #3
c0d001f8:	463d      	mov	r5, r7
c0d001fa:	d1e4      	bne.n	c0d001c6 <bech32_get_address+0x7a>
	{
		chk = bech32_polymod_step((hrp[i] & 31), chk);
	}

	// separator
	*(output++) = BECH32_SEPARATOR;
c0d001fc:	2031      	movs	r0, #49	; 0x31
c0d001fe:	9902      	ldr	r1, [sp, #8]
c0d00200:	70c8      	strb	r0, [r1, #3]
c0d00202:	1d0e      	adds	r6, r1, #4

	// data
	r = base32_encode(output, data, data_len);
c0d00204:	4630      	mov	r0, r6
c0d00206:	9903      	ldr	r1, [sp, #12]
c0d00208:	9a04      	ldr	r2, [sp, #16]
c0d0020a:	f7ff ff25 	bl	c0d00058 <base32_encode>
c0d0020e:	2500      	movs	r5, #0
c0d00210:	43e9      	mvns	r1, r5
	if (r < 0)
c0d00212:	2800      	cmp	r0, #0
c0d00214:	db2d      	blt.n	c0d00272 <bech32_get_address+0x126>
c0d00216:	9101      	str	r1, [sp, #4]
c0d00218:	9604      	str	r6, [sp, #16]
	{
		return -1;
	}
	l = strlen(output);
c0d0021a:	4630      	mov	r0, r6
c0d0021c:	f004 fea2 	bl	c0d04f64 <strlen>
c0d00220:	9002      	str	r0, [sp, #8]
	for (i = 0; i < l; ++i)
c0d00222:	2801      	cmp	r0, #1
c0d00224:	db27      	blt.n	c0d00276 <bech32_get_address+0x12a>
c0d00226:	2200      	movs	r2, #0
c0d00228:	9804      	ldr	r0, [sp, #16]

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
	{
		chk ^= ((b >> i) & 1) ? gen[i] : 0;
c0d0022a:	a62f      	add	r6, pc, #188	; (adr r6, c0d002e8 <bech32_get_address+0x19c>)
c0d0022c:	9203      	str	r2, [sp, #12]
c0d0022e:	9004      	str	r0, [sp, #16]
		return -1;
	}
	l = strlen(output);
	for (i = 0; i < l; ++i)
	{
		r = base32_get_raw(*output);
c0d00230:	7800      	ldrb	r0, [r0, #0]
c0d00232:	f7ff ff79 	bl	c0d00128 <base32_get_raw>
		if (r < 0)
c0d00236:	2800      	cmp	r0, #0
c0d00238:	db4d      	blt.n	c0d002d6 <bech32_get_address+0x18a>
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
c0d0023a:	0179      	lsls	r1, r7, #5
c0d0023c:	9a06      	ldr	r2, [sp, #24]
c0d0023e:	4011      	ands	r1, r2
c0d00240:	b2c2      	uxtb	r2, r0
c0d00242:	404a      	eors	r2, r1
{
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
c0d00244:	0e78      	lsrs	r0, r7, #25
c0d00246:	2100      	movs	r1, #0
c0d00248:	4617      	mov	r7, r2
c0d0024a:	460a      	mov	r2, r1
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
	{
		chk ^= ((b >> i) & 1) ? gen[i] : 0;
c0d0024c:	2301      	movs	r3, #1
c0d0024e:	4093      	lsls	r3, r2
c0d00250:	4203      	tst	r3, r0
c0d00252:	460b      	mov	r3, r1
c0d00254:	d001      	beq.n	c0d0025a <bech32_get_address+0x10e>
c0d00256:	0093      	lsls	r3, r2, #2
c0d00258:	58f3      	ldr	r3, [r6, r3]
c0d0025a:	405f      	eors	r7, r3
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
c0d0025c:	1c52      	adds	r2, r2, #1
c0d0025e:	2a05      	cmp	r2, #5
c0d00260:	d1f4      	bne.n	c0d0024c <bech32_get_address+0x100>
c0d00262:	9a03      	ldr	r2, [sp, #12]
	if (r < 0)
	{
		return -1;
	}
	l = strlen(output);
	for (i = 0; i < l; ++i)
c0d00264:	1c52      	adds	r2, r2, #1
c0d00266:	9804      	ldr	r0, [sp, #16]
		if (r < 0)
		{
			return -1;
		}
		chk = bech32_polymod_step(r, chk);
		output++;
c0d00268:	1c40      	adds	r0, r0, #1
	if (r < 0)
	{
		return -1;
	}
	l = strlen(output);
	for (i = 0; i < l; ++i)
c0d0026a:	9902      	ldr	r1, [sp, #8]
c0d0026c:	428a      	cmp	r2, r1
c0d0026e:	dbdd      	blt.n	c0d0022c <bech32_get_address+0xe0>
c0d00270:	e002      	b.n	c0d00278 <bech32_get_address+0x12c>
c0d00272:	460c      	mov	r4, r1
c0d00274:	e030      	b.n	c0d002d8 <bech32_get_address+0x18c>
c0d00276:	9804      	ldr	r0, [sp, #16]
c0d00278:	9004      	str	r0, [sp, #16]
c0d0027a:	4628      	mov	r0, r5
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
c0d0027c:	017e      	lsls	r6, r7, #5
c0d0027e:	9906      	ldr	r1, [sp, #24]
c0d00280:	400e      	ands	r6, r1
{
	size_t i;
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
c0d00282:	0e79      	lsrs	r1, r7, #25
c0d00284:	462a      	mov	r2, r5
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
	{
		chk ^= ((b >> i) & 1) ? gen[i] : 0;
c0d00286:	4623      	mov	r3, r4
c0d00288:	4093      	lsls	r3, r2
c0d0028a:	420b      	tst	r3, r1
c0d0028c:	462b      	mov	r3, r5
c0d0028e:	d002      	beq.n	c0d00296 <bech32_get_address+0x14a>
c0d00290:	0093      	lsls	r3, r2, #2
c0d00292:	a715      	add	r7, pc, #84	; (adr r7, c0d002e8 <bech32_get_address+0x19c>)
c0d00294:	58fb      	ldr	r3, [r7, r3]
c0d00296:	405e      	eors	r6, r3
	uint8_t b;
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};

	b = (chk >> 25);
	chk = (chk & 0x1ffffff) << 5 ^ value;
	for (i = 0; i < 5; ++i)
c0d00298:	1c52      	adds	r2, r2, #1
c0d0029a:	2a05      	cmp	r2, #5
c0d0029c:	d1f3      	bne.n	c0d00286 <bech32_get_address+0x13a>
		chk = bech32_polymod_step(r, chk);
		output++;
	}

	// trailing zeros needed for checksum
	for (i = 0; i < 6; ++i)
c0d0029e:	1c40      	adds	r0, r0, #1
c0d002a0:	2806      	cmp	r0, #6
c0d002a2:	4637      	mov	r7, r6
c0d002a4:	d1ea      	bne.n	c0d0027c <bech32_get_address+0x130>
	{
		chk = bech32_polymod_step(0, chk);
	}

	chk ^= 1;
c0d002a6:	4066      	eors	r6, r4
c0d002a8:	2500      	movs	r5, #0
c0d002aa:	2719      	movs	r7, #25

	// get/append checksum
	for (i = 0; i < BECH32_CHECKSUM_LENGTH; ++i)
	{
		c = base32_get_char((chk >> (5 * (5 - i))) & 31);
c0d002ac:	9804      	ldr	r0, [sp, #16]
c0d002ae:	1940      	adds	r0, r0, r5
c0d002b0:	9006      	str	r0, [sp, #24]
c0d002b2:	4630      	mov	r0, r6
c0d002b4:	40f8      	lsrs	r0, r7
c0d002b6:	9905      	ldr	r1, [sp, #20]
c0d002b8:	4008      	ands	r0, r1
c0d002ba:	f7ff ff29 	bl	c0d00110 <base32_get_char>
		if (c < 0)
c0d002be:	2800      	cmp	r0, #0
c0d002c0:	db09      	blt.n	c0d002d6 <bech32_get_address+0x18a>
		{
			return -1;
		}
		*(output++) = (char)c;
c0d002c2:	9906      	ldr	r1, [sp, #24]
c0d002c4:	7008      	strb	r0, [r1, #0]
	}

	chk ^= 1;

	// get/append checksum
	for (i = 0; i < BECH32_CHECKSUM_LENGTH; ++i)
c0d002c6:	1f7f      	subs	r7, r7, #5
c0d002c8:	1c6d      	adds	r5, r5, #1
c0d002ca:	2d06      	cmp	r5, #6
c0d002cc:	dbee      	blt.n	c0d002ac <bech32_get_address+0x160>
			return -1;
		}
		*(output++) = (char)c;
	}

	*output = '\0';
c0d002ce:	2000      	movs	r0, #0
c0d002d0:	9904      	ldr	r1, [sp, #16]
c0d002d2:	5548      	strb	r0, [r1, r5]
c0d002d4:	e000      	b.n	c0d002d8 <bech32_get_address+0x18c>
c0d002d6:	9c01      	ldr	r4, [sp, #4]

	return 1;
	
}
c0d002d8:	4620      	mov	r0, r4
c0d002da:	b007      	add	sp, #28
c0d002dc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d002de:	46c0      	nop			; (mov r8, r8)
c0d002e0:	3fffffe0 	.word	0x3fffffe0
c0d002e4:	00656e6f 	.word	0x00656e6f
c0d002e8:	3b6a57b2 	.word	0x3b6a57b2
c0d002ec:	26508e6d 	.word	0x26508e6d
c0d002f0:	1ea119fa 	.word	0x1ea119fa
c0d002f4:	3d4233dd 	.word	0x3d4233dd
c0d002f8:	2a1462b3 	.word	0x2a1462b3

c0d002fc <handleGetPublicKey>:
// These are APDU parameters that control the behavior of the getPublicKey
// command.
#define P2_DISPLAY_ADDRESS 0x00
#define P2_DISPLAY_PUBKEY  0x01

void handleGetPublicKey(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
c0d002fc:	b570      	push	{r4, r5, r6, lr}
c0d002fe:	460e      	mov	r6, r1
    os_memset(ctx, 0, sizeof(getPublicKeyContext_t));
c0d00300:	4d2f      	ldr	r5, [pc, #188]	; (c0d003c0 <handleGetPublicKey+0xc4>)
c0d00302:	2400      	movs	r4, #0
c0d00304:	22ac      	movs	r2, #172	; 0xac
c0d00306:	4628      	mov	r0, r5
c0d00308:	4621      	mov	r1, r4
c0d0030a:	f001 fc7d 	bl	c0d01c08 <os_memset>

	// Sanity-check the command parameters.
	if ((p2 != P2_DISPLAY_ADDRESS) && (p2 != P2_DISPLAY_PUBKEY)) {
c0d0030e:	2e02      	cmp	r6, #2
c0d00310:	d252      	bcs.n	c0d003b8 <handleGetPublicKey+0xbc>
c0d00312:	2001      	movs	r0, #1
		THROW(SW_INVALID_PARAM);
	}

	ctx->genAddr = (p2 == P2_DISPLAY_ADDRESS);
c0d00314:	2e00      	cmp	r6, #0
c0d00316:	d000      	beq.n	c0d0031a <handleGetPublicKey+0x1e>
c0d00318:	4620      	mov	r0, r4
c0d0031a:	9e04      	ldr	r6, [sp, #16]
c0d0031c:	7028      	strb	r0, [r5, #0]
	// Prepare the approval screen, filling in the header and body text.
	os_memmove(ctx->typeStr, "Display Address?", 17);
c0d0031e:	1ca8      	adds	r0, r5, #2
c0d00320:	a129      	add	r1, pc, #164	; (adr r1, c0d003c8 <handleGetPublicKey+0xcc>)
c0d00322:	2211      	movs	r2, #17
c0d00324:	f001 fc79 	bl	c0d01c1a <os_memmove>
	UX_DISPLAY(ui_getPublicKey_approve, NULL);
c0d00328:	4d2c      	ldr	r5, [pc, #176]	; (c0d003dc <handleGetPublicKey+0xe0>)
c0d0032a:	482e      	ldr	r0, [pc, #184]	; (c0d003e4 <handleGetPublicKey+0xe8>)
c0d0032c:	4478      	add	r0, pc
c0d0032e:	6028      	str	r0, [r5, #0]
c0d00330:	2004      	movs	r0, #4
c0d00332:	6068      	str	r0, [r5, #4]
c0d00334:	482c      	ldr	r0, [pc, #176]	; (c0d003e8 <handleGetPublicKey+0xec>)
c0d00336:	4478      	add	r0, pc
c0d00338:	6128      	str	r0, [r5, #16]
c0d0033a:	60ec      	str	r4, [r5, #12]
c0d0033c:	2003      	movs	r0, #3
c0d0033e:	7628      	strb	r0, [r5, #24]
c0d00340:	61ec      	str	r4, [r5, #28]
c0d00342:	4628      	mov	r0, r5
c0d00344:	3018      	adds	r0, #24
c0d00346:	f002 fe9d 	bl	c0d03084 <os_ux>
c0d0034a:	61e8      	str	r0, [r5, #28]
c0d0034c:	f002 fb1e 	bl	c0d0298c <ux_check_status_default>
c0d00350:	f001 fe6e 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00354:	f001 fe72 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00358:	60ac      	str	r4, [r5, #8]
c0d0035a:	6828      	ldr	r0, [r5, #0]
c0d0035c:	2800      	cmp	r0, #0
c0d0035e:	d026      	beq.n	c0d003ae <handleGetPublicKey+0xb2>
c0d00360:	69e8      	ldr	r0, [r5, #28]
c0d00362:	491f      	ldr	r1, [pc, #124]	; (c0d003e0 <handleGetPublicKey+0xe4>)
c0d00364:	4288      	cmp	r0, r1
c0d00366:	d022      	beq.n	c0d003ae <handleGetPublicKey+0xb2>
c0d00368:	2800      	cmp	r0, #0
c0d0036a:	d020      	beq.n	c0d003ae <handleGetPublicKey+0xb2>
c0d0036c:	2000      	movs	r0, #0
c0d0036e:	6869      	ldr	r1, [r5, #4]
c0d00370:	4288      	cmp	r0, r1
c0d00372:	d21c      	bcs.n	c0d003ae <handleGetPublicKey+0xb2>
c0d00374:	f002 fee0 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00378:	2800      	cmp	r0, #0
c0d0037a:	d118      	bne.n	c0d003ae <handleGetPublicKey+0xb2>
c0d0037c:	68a8      	ldr	r0, [r5, #8]
c0d0037e:	68e9      	ldr	r1, [r5, #12]
c0d00380:	2438      	movs	r4, #56	; 0x38
c0d00382:	4360      	muls	r0, r4
c0d00384:	682a      	ldr	r2, [r5, #0]
c0d00386:	1810      	adds	r0, r2, r0
c0d00388:	2900      	cmp	r1, #0
c0d0038a:	d002      	beq.n	c0d00392 <handleGetPublicKey+0x96>
c0d0038c:	4788      	blx	r1
c0d0038e:	2800      	cmp	r0, #0
c0d00390:	d007      	beq.n	c0d003a2 <handleGetPublicKey+0xa6>
c0d00392:	2801      	cmp	r0, #1
c0d00394:	d103      	bne.n	c0d0039e <handleGetPublicKey+0xa2>
c0d00396:	68a8      	ldr	r0, [r5, #8]
c0d00398:	4344      	muls	r4, r0
c0d0039a:	6828      	ldr	r0, [r5, #0]
c0d0039c:	1900      	adds	r0, r0, r4
c0d0039e:	f000 ffb1 	bl	c0d01304 <io_seproxyhal_display>
c0d003a2:	68a8      	ldr	r0, [r5, #8]
c0d003a4:	1c40      	adds	r0, r0, #1
c0d003a6:	60a8      	str	r0, [r5, #8]
c0d003a8:	6829      	ldr	r1, [r5, #0]
c0d003aa:	2900      	cmp	r1, #0
c0d003ac:	d1df      	bne.n	c0d0036e <handleGetPublicKey+0x72>
	
	*flags |= IO_ASYNCH_REPLY;
c0d003ae:	6830      	ldr	r0, [r6, #0]
c0d003b0:	2110      	movs	r1, #16
c0d003b2:	4301      	orrs	r1, r0
c0d003b4:	6031      	str	r1, [r6, #0]
}
c0d003b6:	bd70      	pop	{r4, r5, r6, pc}
void handleGetPublicKey(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
    os_memset(ctx, 0, sizeof(getPublicKeyContext_t));

	// Sanity-check the command parameters.
	if ((p2 != P2_DISPLAY_ADDRESS) && (p2 != P2_DISPLAY_PUBKEY)) {
		THROW(SW_INVALID_PARAM);
c0d003b8:	4802      	ldr	r0, [pc, #8]	; (c0d003c4 <handleGetPublicKey+0xc8>)
c0d003ba:	f001 fce2 	bl	c0d01d82 <os_longjmp>
c0d003be:	46c0      	nop			; (mov r8, r8)
c0d003c0:	20001930 	.word	0x20001930
c0d003c4:	00006b01 	.word	0x00006b01
c0d003c8:	70736944 	.word	0x70736944
c0d003cc:	2079616c 	.word	0x2079616c
c0d003d0:	72646441 	.word	0x72646441
c0d003d4:	3f737365 	.word	0x3f737365
c0d003d8:	00000000 	.word	0x00000000
c0d003dc:	20001880 	.word	0x20001880
c0d003e0:	b0105044 	.word	0xb0105044
c0d003e4:	00004cc0 	.word	0x00004cc0
c0d003e8:	000000b3 	.word	0x000000b3

c0d003ec <ui_getPublicKey_approve_button>:
	UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

	UI_TEXT(0x00, 0, 12, 128, global.getPublicKeyContext.typeStr),
};

static unsigned int ui_getPublicKey_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d003ec:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d003ee:	b093      	sub	sp, #76	; 0x4c
	uint16_t tx = 0;
	cx_ecfp_public_key_t publicKey;
	switch (button_mask) {
c0d003f0:	493d      	ldr	r1, [pc, #244]	; (c0d004e8 <ui_getPublicKey_approve_button+0xfc>)
c0d003f2:	4288      	cmp	r0, r1
c0d003f4:	d009      	beq.n	c0d0040a <ui_getPublicKey_approve_button+0x1e>
c0d003f6:	493d      	ldr	r1, [pc, #244]	; (c0d004ec <ui_getPublicKey_approve_button+0x100>)
c0d003f8:	4288      	cmp	r0, r1
c0d003fa:	d172      	bne.n	c0d004e2 <ui_getPublicKey_approve_button+0xf6>
	case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
		io_exchange_with_code(SW_USER_REJECTED, 0);
c0d003fc:	4840      	ldr	r0, [pc, #256]	; (c0d00500 <ui_getPublicKey_approve_button+0x114>)
c0d003fe:	2100      	movs	r1, #0
c0d00400:	f000 ff70 	bl	c0d012e4 <io_exchange_with_code>
		ui_idle();
c0d00404:	f000 ff64 	bl	c0d012d0 <ui_idle>
c0d00408:	e06b      	b.n	c0d004e2 <ui_getPublicKey_approve_button+0xf6>
c0d0040a:	2400      	movs	r4, #0
c0d0040c:	466e      	mov	r6, sp
	case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
		// Derive the public key and address and store them in the APDU
		// buffer. Even though we know that tx starts at 0, it's best to
		// always add it explicitly; this prevents a bug if we reorder the
		// statements later.
		deriveOneKeypair(NULL, &publicKey);
c0d0040e:	4620      	mov	r0, r4
c0d00410:	4631      	mov	r1, r6
c0d00412:	f000 fe61 	bl	c0d010d8 <deriveOneKeypair>

		pubkeyToOneAddress(G_io_apdu_buffer + tx, &publicKey);
c0d00416:	4836      	ldr	r0, [pc, #216]	; (c0d004f0 <ui_getPublicKey_approve_button+0x104>)
c0d00418:	4631      	mov	r1, r6
c0d0041a:	f000 ff0d 	bl	c0d01238 <pubkeyToOneAddress>
		tx += 42;
		// Flush the APDU buffer, sending the response.
		io_exchange_with_code(SW_OK, tx);

		// Prepare the comparison screen, filling in the header and body text.
		os_memmove(ctx->typeStr, "Compare:", 9);
c0d0041e:	2709      	movs	r7, #9
		deriveOneKeypair(NULL, &publicKey);

		pubkeyToOneAddress(G_io_apdu_buffer + tx, &publicKey);
		tx += 42;
		// Flush the APDU buffer, sending the response.
		io_exchange_with_code(SW_OK, tx);
c0d00420:	0338      	lsls	r0, r7, #12
c0d00422:	262a      	movs	r6, #42	; 0x2a
c0d00424:	4631      	mov	r1, r6
c0d00426:	f000 ff5d 	bl	c0d012e4 <io_exchange_with_code>

		// Prepare the comparison screen, filling in the header and body text.
		os_memmove(ctx->typeStr, "Compare:", 9);
c0d0042a:	4d32      	ldr	r5, [pc, #200]	; (c0d004f4 <ui_getPublicKey_approve_button+0x108>)
c0d0042c:	1ca8      	adds	r0, r5, #2
c0d0042e:	4935      	ldr	r1, [pc, #212]	; (c0d00504 <ui_getPublicKey_approve_button+0x118>)
c0d00430:	4479      	add	r1, pc
c0d00432:	463a      	mov	r2, r7
c0d00434:	f001 fbf1 	bl	c0d01c1a <os_memmove>
		os_memmove(ctx->fullStr, G_io_apdu_buffer, 42);
c0d00438:	462f      	mov	r7, r5
c0d0043a:	3752      	adds	r7, #82	; 0x52
c0d0043c:	4638      	mov	r0, r7
c0d0043e:	492c      	ldr	r1, [pc, #176]	; (c0d004f0 <ui_getPublicKey_approve_button+0x104>)
c0d00440:	4632      	mov	r2, r6
c0d00442:	f001 fbea 	bl	c0d01c1a <os_memmove>
		ctx->fullStr[42] = '\0';
c0d00446:	207c      	movs	r0, #124	; 0x7c
c0d00448:	542c      	strb	r4, [r5, r0]

		os_memmove(ctx->partialStr, ctx->fullStr, 12);
c0d0044a:	4628      	mov	r0, r5
c0d0044c:	309f      	adds	r0, #159	; 0x9f
c0d0044e:	220c      	movs	r2, #12
c0d00450:	4639      	mov	r1, r7
c0d00452:	f001 fbe2 	bl	c0d01c1a <os_memmove>
		ctx->partialStr[12] = '\0';
c0d00456:	20ab      	movs	r0, #171	; 0xab
c0d00458:	542c      	strb	r4, [r5, r0]
		ctx->displayIndex = 0;
c0d0045a:	706c      	strb	r4, [r5, #1]

		// Display the comparison screen.
		UX_DISPLAY(ui_getPublicKey_compare, ui_prepro_getPublicKey_compare);
c0d0045c:	4d26      	ldr	r5, [pc, #152]	; (c0d004f8 <ui_getPublicKey_approve_button+0x10c>)
c0d0045e:	482a      	ldr	r0, [pc, #168]	; (c0d00508 <ui_getPublicKey_approve_button+0x11c>)
c0d00460:	4478      	add	r0, pc
c0d00462:	6028      	str	r0, [r5, #0]
c0d00464:	2005      	movs	r0, #5
c0d00466:	6068      	str	r0, [r5, #4]
c0d00468:	4828      	ldr	r0, [pc, #160]	; (c0d0050c <ui_getPublicKey_approve_button+0x120>)
c0d0046a:	4478      	add	r0, pc
c0d0046c:	6128      	str	r0, [r5, #16]
c0d0046e:	4828      	ldr	r0, [pc, #160]	; (c0d00510 <ui_getPublicKey_approve_button+0x124>)
c0d00470:	4478      	add	r0, pc
c0d00472:	60e8      	str	r0, [r5, #12]
c0d00474:	2003      	movs	r0, #3
c0d00476:	7628      	strb	r0, [r5, #24]
c0d00478:	61ec      	str	r4, [r5, #28]
c0d0047a:	4628      	mov	r0, r5
c0d0047c:	3018      	adds	r0, #24
c0d0047e:	f002 fe01 	bl	c0d03084 <os_ux>
c0d00482:	61e8      	str	r0, [r5, #28]
c0d00484:	f002 fa82 	bl	c0d0298c <ux_check_status_default>
c0d00488:	f001 fdd2 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d0048c:	f001 fdd6 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00490:	60ac      	str	r4, [r5, #8]
c0d00492:	6828      	ldr	r0, [r5, #0]
c0d00494:	2800      	cmp	r0, #0
c0d00496:	d024      	beq.n	c0d004e2 <ui_getPublicKey_approve_button+0xf6>
c0d00498:	69e8      	ldr	r0, [r5, #28]
c0d0049a:	4918      	ldr	r1, [pc, #96]	; (c0d004fc <ui_getPublicKey_approve_button+0x110>)
c0d0049c:	4288      	cmp	r0, r1
c0d0049e:	d11e      	bne.n	c0d004de <ui_getPublicKey_approve_button+0xf2>
c0d004a0:	e01f      	b.n	c0d004e2 <ui_getPublicKey_approve_button+0xf6>
c0d004a2:	6868      	ldr	r0, [r5, #4]
c0d004a4:	4284      	cmp	r4, r0
c0d004a6:	d21c      	bcs.n	c0d004e2 <ui_getPublicKey_approve_button+0xf6>
c0d004a8:	f002 fe46 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d004ac:	2800      	cmp	r0, #0
c0d004ae:	d118      	bne.n	c0d004e2 <ui_getPublicKey_approve_button+0xf6>
c0d004b0:	68a8      	ldr	r0, [r5, #8]
c0d004b2:	68e9      	ldr	r1, [r5, #12]
c0d004b4:	2438      	movs	r4, #56	; 0x38
c0d004b6:	4360      	muls	r0, r4
c0d004b8:	682a      	ldr	r2, [r5, #0]
c0d004ba:	1810      	adds	r0, r2, r0
c0d004bc:	2900      	cmp	r1, #0
c0d004be:	d002      	beq.n	c0d004c6 <ui_getPublicKey_approve_button+0xda>
c0d004c0:	4788      	blx	r1
c0d004c2:	2800      	cmp	r0, #0
c0d004c4:	d007      	beq.n	c0d004d6 <ui_getPublicKey_approve_button+0xea>
c0d004c6:	2801      	cmp	r0, #1
c0d004c8:	d103      	bne.n	c0d004d2 <ui_getPublicKey_approve_button+0xe6>
c0d004ca:	68a8      	ldr	r0, [r5, #8]
c0d004cc:	4344      	muls	r4, r0
c0d004ce:	6828      	ldr	r0, [r5, #0]
c0d004d0:	1900      	adds	r0, r0, r4
c0d004d2:	f000 ff17 	bl	c0d01304 <io_seproxyhal_display>
c0d004d6:	68a8      	ldr	r0, [r5, #8]
c0d004d8:	1c44      	adds	r4, r0, #1
c0d004da:	60ac      	str	r4, [r5, #8]
c0d004dc:	6828      	ldr	r0, [r5, #0]
c0d004de:	2800      	cmp	r0, #0
c0d004e0:	d1df      	bne.n	c0d004a2 <ui_getPublicKey_approve_button+0xb6>
		break;
	}
	return 0;
c0d004e2:	2000      	movs	r0, #0
c0d004e4:	b013      	add	sp, #76	; 0x4c
c0d004e6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d004e8:	80000002 	.word	0x80000002
c0d004ec:	80000001 	.word	0x80000001
c0d004f0:	20001d70 	.word	0x20001d70
c0d004f4:	20001930 	.word	0x20001930
c0d004f8:	20001880 	.word	0x20001880
c0d004fc:	b0105044 	.word	0xb0105044
c0d00500:	00006985 	.word	0x00006985
c0d00504:	00004c9c 	.word	0x00004c9c
c0d00508:	00004c78 	.word	0x00004c78
c0d0050c:	000000a7 	.word	0x000000a7
c0d00510:	000001dd 	.word	0x000001dd

c0d00514 <ui_getPublicKey_compare_button>:
    }
}

// Define the button handler for the comparison screen. Again, this is nearly
// identical to the signHash comparison button handler.
static unsigned int ui_getPublicKey_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d00514:	b5b0      	push	{r4, r5, r7, lr}
	switch (button_mask) {
c0d00516:	2801      	cmp	r0, #1
c0d00518:	dd08      	ble.n	c0d0052c <ui_getPublicKey_compare_button+0x18>
c0d0051a:	2802      	cmp	r0, #2
c0d0051c:	d04b      	beq.n	c0d005b6 <ui_getPublicKey_compare_button+0xa2>
c0d0051e:	4946      	ldr	r1, [pc, #280]	; (c0d00638 <ui_getPublicKey_compare_button+0x124>)
c0d00520:	4288      	cmp	r0, r1
c0d00522:	d048      	beq.n	c0d005b6 <ui_getPublicKey_compare_button+0xa2>
c0d00524:	4945      	ldr	r1, [pc, #276]	; (c0d0063c <ui_getPublicKey_compare_button+0x128>)
c0d00526:	4288      	cmp	r0, r1
c0d00528:	d005      	beq.n	c0d00536 <ui_getPublicKey_compare_button+0x22>
c0d0052a:	e083      	b.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d0052c:	4944      	ldr	r1, [pc, #272]	; (c0d00640 <ui_getPublicKey_compare_button+0x12c>)
c0d0052e:	4288      	cmp	r0, r1
c0d00530:	d07e      	beq.n	c0d00630 <ui_getPublicKey_compare_button+0x11c>
c0d00532:	2801      	cmp	r0, #1
c0d00534:	d17e      	bne.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
	case BUTTON_LEFT:
	case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
		if (ctx->displayIndex > 0) {
c0d00536:	4843      	ldr	r0, [pc, #268]	; (c0d00644 <ui_getPublicKey_compare_button+0x130>)
c0d00538:	7842      	ldrb	r2, [r0, #1]
c0d0053a:	2500      	movs	r5, #0
c0d0053c:	2a00      	cmp	r2, #0
			ctx->displayIndex--;
		}
		os_memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
c0d0053e:	4629      	mov	r1, r5
c0d00540:	d001      	beq.n	c0d00546 <ui_getPublicKey_compare_button+0x32>
static unsigned int ui_getPublicKey_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
	switch (button_mask) {
	case BUTTON_LEFT:
	case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
		if (ctx->displayIndex > 0) {
			ctx->displayIndex--;
c0d00542:	1e51      	subs	r1, r2, #1
c0d00544:	7041      	strb	r1, [r0, #1]
		}
		os_memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
c0d00546:	b2c9      	uxtb	r1, r1
c0d00548:	1841      	adds	r1, r0, r1
c0d0054a:	3152      	adds	r1, #82	; 0x52
c0d0054c:	309f      	adds	r0, #159	; 0x9f
c0d0054e:	220c      	movs	r2, #12
c0d00550:	f001 fb63 	bl	c0d01c1a <os_memmove>
		UX_REDISPLAY();
c0d00554:	f001 fd6c 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00558:	f001 fd70 	bl	c0d0203c <io_seproxyhal_init_button>
c0d0055c:	4c3a      	ldr	r4, [pc, #232]	; (c0d00648 <ui_getPublicKey_compare_button+0x134>)
c0d0055e:	60a5      	str	r5, [r4, #8]
c0d00560:	6820      	ldr	r0, [r4, #0]
c0d00562:	2800      	cmp	r0, #0
c0d00564:	d066      	beq.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d00566:	69e0      	ldr	r0, [r4, #28]
c0d00568:	4938      	ldr	r1, [pc, #224]	; (c0d0064c <ui_getPublicKey_compare_button+0x138>)
c0d0056a:	4288      	cmp	r0, r1
c0d0056c:	d062      	beq.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d0056e:	2800      	cmp	r0, #0
c0d00570:	d060      	beq.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d00572:	2000      	movs	r0, #0
c0d00574:	6861      	ldr	r1, [r4, #4]
c0d00576:	4288      	cmp	r0, r1
c0d00578:	d25c      	bcs.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d0057a:	f002 fddd 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d0057e:	2800      	cmp	r0, #0
c0d00580:	d158      	bne.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d00582:	68a0      	ldr	r0, [r4, #8]
c0d00584:	68e1      	ldr	r1, [r4, #12]
c0d00586:	2538      	movs	r5, #56	; 0x38
c0d00588:	4368      	muls	r0, r5
c0d0058a:	6822      	ldr	r2, [r4, #0]
c0d0058c:	1810      	adds	r0, r2, r0
c0d0058e:	2900      	cmp	r1, #0
c0d00590:	d002      	beq.n	c0d00598 <ui_getPublicKey_compare_button+0x84>
c0d00592:	4788      	blx	r1
c0d00594:	2800      	cmp	r0, #0
c0d00596:	d007      	beq.n	c0d005a8 <ui_getPublicKey_compare_button+0x94>
c0d00598:	2801      	cmp	r0, #1
c0d0059a:	d103      	bne.n	c0d005a4 <ui_getPublicKey_compare_button+0x90>
c0d0059c:	68a0      	ldr	r0, [r4, #8]
c0d0059e:	4345      	muls	r5, r0
c0d005a0:	6820      	ldr	r0, [r4, #0]
c0d005a2:	1940      	adds	r0, r0, r5
c0d005a4:	f000 feae 	bl	c0d01304 <io_seproxyhal_display>
c0d005a8:	68a0      	ldr	r0, [r4, #8]
c0d005aa:	1c40      	adds	r0, r0, #1
c0d005ac:	60a0      	str	r0, [r4, #8]
c0d005ae:	6821      	ldr	r1, [r4, #0]
c0d005b0:	2900      	cmp	r1, #0
c0d005b2:	d1df      	bne.n	c0d00574 <ui_getPublicKey_compare_button+0x60>
c0d005b4:	e03e      	b.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
		break;

	case BUTTON_RIGHT:
	case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
		if (ctx->displayIndex < 42 - 12) {
c0d005b6:	4823      	ldr	r0, [pc, #140]	; (c0d00644 <ui_getPublicKey_compare_button+0x130>)
c0d005b8:	7841      	ldrb	r1, [r0, #1]
c0d005ba:	291d      	cmp	r1, #29
c0d005bc:	d801      	bhi.n	c0d005c2 <ui_getPublicKey_compare_button+0xae>
			ctx->displayIndex++;
c0d005be:	1c49      	adds	r1, r1, #1
c0d005c0:	7041      	strb	r1, [r0, #1]
		}
		os_memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
c0d005c2:	b2c9      	uxtb	r1, r1
c0d005c4:	1841      	adds	r1, r0, r1
c0d005c6:	3152      	adds	r1, #82	; 0x52
c0d005c8:	309f      	adds	r0, #159	; 0x9f
c0d005ca:	220c      	movs	r2, #12
c0d005cc:	f001 fb25 	bl	c0d01c1a <os_memmove>
		UX_REDISPLAY();
c0d005d0:	f001 fd2e 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d005d4:	f001 fd32 	bl	c0d0203c <io_seproxyhal_init_button>
c0d005d8:	4c1b      	ldr	r4, [pc, #108]	; (c0d00648 <ui_getPublicKey_compare_button+0x134>)
c0d005da:	2000      	movs	r0, #0
c0d005dc:	60a0      	str	r0, [r4, #8]
c0d005de:	6821      	ldr	r1, [r4, #0]
c0d005e0:	2900      	cmp	r1, #0
c0d005e2:	d027      	beq.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d005e4:	69e1      	ldr	r1, [r4, #28]
c0d005e6:	4a19      	ldr	r2, [pc, #100]	; (c0d0064c <ui_getPublicKey_compare_button+0x138>)
c0d005e8:	4291      	cmp	r1, r2
c0d005ea:	d11e      	bne.n	c0d0062a <ui_getPublicKey_compare_button+0x116>
c0d005ec:	e022      	b.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d005ee:	6861      	ldr	r1, [r4, #4]
c0d005f0:	4288      	cmp	r0, r1
c0d005f2:	d21f      	bcs.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d005f4:	f002 fda0 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d005f8:	2800      	cmp	r0, #0
c0d005fa:	d11b      	bne.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
c0d005fc:	68a0      	ldr	r0, [r4, #8]
c0d005fe:	68e1      	ldr	r1, [r4, #12]
c0d00600:	2538      	movs	r5, #56	; 0x38
c0d00602:	4368      	muls	r0, r5
c0d00604:	6822      	ldr	r2, [r4, #0]
c0d00606:	1810      	adds	r0, r2, r0
c0d00608:	2900      	cmp	r1, #0
c0d0060a:	d002      	beq.n	c0d00612 <ui_getPublicKey_compare_button+0xfe>
c0d0060c:	4788      	blx	r1
c0d0060e:	2800      	cmp	r0, #0
c0d00610:	d007      	beq.n	c0d00622 <ui_getPublicKey_compare_button+0x10e>
c0d00612:	2801      	cmp	r0, #1
c0d00614:	d103      	bne.n	c0d0061e <ui_getPublicKey_compare_button+0x10a>
c0d00616:	68a0      	ldr	r0, [r4, #8]
c0d00618:	4345      	muls	r5, r0
c0d0061a:	6820      	ldr	r0, [r4, #0]
c0d0061c:	1940      	adds	r0, r0, r5
c0d0061e:	f000 fe71 	bl	c0d01304 <io_seproxyhal_display>
c0d00622:	68a0      	ldr	r0, [r4, #8]
c0d00624:	1c40      	adds	r0, r0, #1
c0d00626:	60a0      	str	r0, [r4, #8]
c0d00628:	6821      	ldr	r1, [r4, #0]
c0d0062a:	2900      	cmp	r1, #0
c0d0062c:	d1df      	bne.n	c0d005ee <ui_getPublicKey_compare_button+0xda>
c0d0062e:	e001      	b.n	c0d00634 <ui_getPublicKey_compare_button+0x120>
		break;

	case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
		// The user has finished comparing, so return to the main screen.
		ui_idle();
c0d00630:	f000 fe4e 	bl	c0d012d0 <ui_idle>
		break;
	}
	return 0;
c0d00634:	2000      	movs	r0, #0
c0d00636:	bdb0      	pop	{r4, r5, r7, pc}
c0d00638:	40000002 	.word	0x40000002
c0d0063c:	40000001 	.word	0x40000001
c0d00640:	80000003 	.word	0x80000003
c0d00644:	20001930 	.word	0x20001930
c0d00648:	20001880 	.word	0x20001880
c0d0064c:	b0105044 	.word	0xb0105044

c0d00650 <ui_prepro_getPublicKey_compare>:
	// The visible portion of the public key or address.
	UI_TEXT(0x00, 0, 26, 128, global.getPublicKeyContext.partialStr),
};

static const bagl_element_t* ui_prepro_getPublicKey_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
c0d00650:	7841      	ldrb	r1, [r0, #1]
c0d00652:	2902      	cmp	r1, #2
c0d00654:	d006      	beq.n	c0d00664 <ui_prepro_getPublicKey_compare+0x14>
c0d00656:	2901      	cmp	r1, #1
c0d00658:	d10b      	bne.n	c0d00672 <ui_prepro_getPublicKey_compare+0x22>
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
c0d0065a:	4906      	ldr	r1, [pc, #24]	; (c0d00674 <ui_prepro_getPublicKey_compare+0x24>)
c0d0065c:	7849      	ldrb	r1, [r1, #1]
c0d0065e:	2900      	cmp	r1, #0
c0d00660:	d006      	beq.n	c0d00670 <ui_prepro_getPublicKey_compare+0x20>
c0d00662:	e006      	b.n	c0d00672 <ui_prepro_getPublicKey_compare+0x22>
        case 2:
            return (ctx->displayIndex >= 42 - 12) ? NULL : element;
c0d00664:	4903      	ldr	r1, [pc, #12]	; (c0d00674 <ui_prepro_getPublicKey_compare+0x24>)
c0d00666:	784a      	ldrb	r2, [r1, #1]
c0d00668:	2100      	movs	r1, #0
c0d0066a:	2a1d      	cmp	r2, #29
c0d0066c:	d800      	bhi.n	c0d00670 <ui_prepro_getPublicKey_compare+0x20>
c0d0066e:	4601      	mov	r1, r0
c0d00670:	4608      	mov	r0, r1
        default:
            return element;
    }
}
c0d00672:	4770      	bx	lr
c0d00674:	20001930 	.word	0x20001930

c0d00678 <handleSignTx>:
            break;
    }
    return 0;
}

void handleSignTx(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
c0d00678:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0067a:	b083      	sub	sp, #12
c0d0067c:	461f      	mov	r7, r3
c0d0067e:	9202      	str	r2, [sp, #8]
    os_memset(ctx, 0, sizeof(signTxnContext_t));
c0d00680:	4d3b      	ldr	r5, [pc, #236]	; (c0d00770 <handleSignTx+0xf8>)
c0d00682:	2400      	movs	r4, #0
c0d00684:	4a3b      	ldr	r2, [pc, #236]	; (c0d00774 <handleSignTx+0xfc>)
c0d00686:	4628      	mov	r0, r5
c0d00688:	4621      	mov	r1, r4
c0d0068a:	f001 fabd 	bl	c0d01c08 <os_memset>
c0d0068e:	2081      	movs	r0, #129	; 0x81
c0d00690:	0080      	lsls	r0, r0, #2

    //txContext_t txContext;
    os_memset(& ctx->txContext, 0, sizeof(ctx->txContext));
c0d00692:	9001      	str	r0, [sp, #4]
c0d00694:	1828      	adds	r0, r5, r0
c0d00696:	2230      	movs	r2, #48	; 0x30
c0d00698:	4621      	mov	r1, r4
c0d0069a:	f001 fab5 	bl	c0d01c08 <os_memset>
c0d0069e:	2001      	movs	r0, #1

    ctx->length = dataLength;
c0d006a0:	9000      	str	r0, [sp, #0]
c0d006a2:	0246      	lsls	r6, r0, #9
c0d006a4:	463a      	mov	r2, r7
c0d006a6:	53aa      	strh	r2, [r5, r6]
    os_memmove(ctx->buf, dataBuffer, dataLength);
c0d006a8:	1c6f      	adds	r7, r5, #1
c0d006aa:	4638      	mov	r0, r7
c0d006ac:	9902      	ldr	r1, [sp, #8]
c0d006ae:	f001 fab4 	bl	c0d01c1a <os_memmove>

    ctx->txContext.workBuffer = ctx->buf;
c0d006b2:	2089      	movs	r0, #137	; 0x89
c0d006b4:	0080      	lsls	r0, r0, #2
c0d006b6:	502f      	str	r7, [r5, r0]
    ctx->txContext.commandLength = ctx->length;
c0d006b8:	5ba8      	ldrh	r0, [r5, r6]
c0d006ba:	2145      	movs	r1, #69	; 0x45
c0d006bc:	00c9      	lsls	r1, r1, #3
c0d006be:	5068      	str	r0, [r5, r1]

    ctx->txContext.currentField = TX_RLP_CONTENT;
c0d006c0:	9801      	ldr	r0, [sp, #4]
c0d006c2:	9900      	ldr	r1, [sp, #0]
c0d006c4:	5429      	strb	r1, [r5, r0]
    ctx->txContext.content = &ctx->txContent;
c0d006c6:	208d      	movs	r0, #141	; 0x8d
c0d006c8:	0080      	lsls	r0, r0, #2
c0d006ca:	1828      	adds	r0, r5, r0
c0d006cc:	2123      	movs	r1, #35	; 0x23
c0d006ce:	0109      	lsls	r1, r1, #4
c0d006d0:	5068      	str	r0, [r5, r1]

    os_memmove(ctx->typeStr, "Sign Transaction?", 19);
c0d006d2:	4829      	ldr	r0, [pc, #164]	; (c0d00778 <handleSignTx+0x100>)
c0d006d4:	1828      	adds	r0, r5, r0
c0d006d6:	a129      	add	r1, pc, #164	; (adr r1, c0d0077c <handleSignTx+0x104>)
c0d006d8:	2213      	movs	r2, #19
c0d006da:	f001 fa9e 	bl	c0d01c1a <os_memmove>
    UX_DISPLAY(ui_signTx_approve, NULL);
c0d006de:	4d2c      	ldr	r5, [pc, #176]	; (c0d00790 <handleSignTx+0x118>)
c0d006e0:	482d      	ldr	r0, [pc, #180]	; (c0d00798 <handleSignTx+0x120>)
c0d006e2:	4478      	add	r0, pc
c0d006e4:	6028      	str	r0, [r5, #0]
c0d006e6:	2004      	movs	r0, #4
c0d006e8:	6068      	str	r0, [r5, #4]
c0d006ea:	482c      	ldr	r0, [pc, #176]	; (c0d0079c <handleSignTx+0x124>)
c0d006ec:	4478      	add	r0, pc
c0d006ee:	6128      	str	r0, [r5, #16]
c0d006f0:	60ec      	str	r4, [r5, #12]
c0d006f2:	2003      	movs	r0, #3
c0d006f4:	7628      	strb	r0, [r5, #24]
c0d006f6:	61ec      	str	r4, [r5, #28]
c0d006f8:	4628      	mov	r0, r5
c0d006fa:	3018      	adds	r0, #24
c0d006fc:	f002 fcc2 	bl	c0d03084 <os_ux>
c0d00700:	61e8      	str	r0, [r5, #28]
c0d00702:	f002 f943 	bl	c0d0298c <ux_check_status_default>
c0d00706:	f001 fc93 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d0070a:	f001 fc97 	bl	c0d0203c <io_seproxyhal_init_button>
c0d0070e:	60ac      	str	r4, [r5, #8]
c0d00710:	6828      	ldr	r0, [r5, #0]
c0d00712:	9e08      	ldr	r6, [sp, #32]
c0d00714:	2800      	cmp	r0, #0
c0d00716:	d024      	beq.n	c0d00762 <handleSignTx+0xea>
c0d00718:	69e8      	ldr	r0, [r5, #28]
c0d0071a:	491e      	ldr	r1, [pc, #120]	; (c0d00794 <handleSignTx+0x11c>)
c0d0071c:	4288      	cmp	r0, r1
c0d0071e:	d11e      	bne.n	c0d0075e <handleSignTx+0xe6>
c0d00720:	e01f      	b.n	c0d00762 <handleSignTx+0xea>
c0d00722:	6868      	ldr	r0, [r5, #4]
c0d00724:	4284      	cmp	r4, r0
c0d00726:	d21c      	bcs.n	c0d00762 <handleSignTx+0xea>
c0d00728:	f002 fd06 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d0072c:	2800      	cmp	r0, #0
c0d0072e:	d118      	bne.n	c0d00762 <handleSignTx+0xea>
c0d00730:	68a8      	ldr	r0, [r5, #8]
c0d00732:	68e9      	ldr	r1, [r5, #12]
c0d00734:	2438      	movs	r4, #56	; 0x38
c0d00736:	4360      	muls	r0, r4
c0d00738:	682a      	ldr	r2, [r5, #0]
c0d0073a:	1810      	adds	r0, r2, r0
c0d0073c:	2900      	cmp	r1, #0
c0d0073e:	d002      	beq.n	c0d00746 <handleSignTx+0xce>
c0d00740:	4788      	blx	r1
c0d00742:	2800      	cmp	r0, #0
c0d00744:	d007      	beq.n	c0d00756 <handleSignTx+0xde>
c0d00746:	2801      	cmp	r0, #1
c0d00748:	d103      	bne.n	c0d00752 <handleSignTx+0xda>
c0d0074a:	68a8      	ldr	r0, [r5, #8]
c0d0074c:	4344      	muls	r4, r0
c0d0074e:	6828      	ldr	r0, [r5, #0]
c0d00750:	1900      	adds	r0, r0, r4
c0d00752:	f000 fdd7 	bl	c0d01304 <io_seproxyhal_display>
c0d00756:	68a8      	ldr	r0, [r5, #8]
c0d00758:	1c44      	adds	r4, r0, #1
c0d0075a:	60ac      	str	r4, [r5, #8]
c0d0075c:	6828      	ldr	r0, [r5, #0]
c0d0075e:	2800      	cmp	r0, #0
c0d00760:	d1df      	bne.n	c0d00722 <handleSignTx+0xaa>

    *flags |= IO_ASYNCH_REPLY;
c0d00762:	6830      	ldr	r0, [r6, #0]
c0d00764:	2110      	movs	r1, #16
c0d00766:	4301      	orrs	r1, r0
c0d00768:	6031      	str	r1, [r6, #0]
c0d0076a:	b003      	add	sp, #12
c0d0076c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0076e:	46c0      	nop			; (mov r8, r8)
c0d00770:	20001930 	.word	0x20001930
c0d00774:	00000434 	.word	0x00000434
c0d00778:	0000040b 	.word	0x0000040b
c0d0077c:	6e676953 	.word	0x6e676953
c0d00780:	61725420 	.word	0x61725420
c0d00784:	6361736e 	.word	0x6361736e
c0d00788:	6e6f6974 	.word	0x6e6f6974
c0d0078c:	0000003f 	.word	0x0000003f
c0d00790:	20001880 	.word	0x20001880
c0d00794:	b0105044 	.word	0xb0105044
c0d00798:	00004b0e 	.word	0x00004b0e
c0d0079c:	000000b1 	.word	0x000000b1

c0d007a0 <ui_signTx_approve_button>:
        UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

        UI_TEXT(0x00, 0, 12, 128, global.signTxnContext.typeStr),
};

static unsigned int ui_signTx_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d007a0:	b570      	push	{r4, r5, r6, lr}
    switch (button_mask) {
c0d007a2:	4936      	ldr	r1, [pc, #216]	; (c0d0087c <ui_signTx_approve_button+0xdc>)
c0d007a4:	4288      	cmp	r0, r1
c0d007a6:	d009      	beq.n	c0d007bc <ui_signTx_approve_button+0x1c>
c0d007a8:	4935      	ldr	r1, [pc, #212]	; (c0d00880 <ui_signTx_approve_button+0xe0>)
c0d007aa:	4288      	cmp	r0, r1
c0d007ac:	d163      	bne.n	c0d00876 <ui_signTx_approve_button+0xd6>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
c0d007ae:	483a      	ldr	r0, [pc, #232]	; (c0d00898 <ui_signTx_approve_button+0xf8>)
c0d007b0:	2100      	movs	r1, #0
c0d007b2:	f000 fd97 	bl	c0d012e4 <io_exchange_with_code>
            ui_idle();
c0d007b6:	f000 fd8b 	bl	c0d012d0 <ui_idle>
c0d007ba:	e05c      	b.n	c0d00876 <ui_signTx_approve_button+0xd6>
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            processTx(& ctx->txContext);
c0d007bc:	2081      	movs	r0, #129	; 0x81
c0d007be:	0080      	lsls	r0, r0, #2
c0d007c0:	4e30      	ldr	r6, [pc, #192]	; (c0d00884 <ui_signTx_approve_button+0xe4>)
c0d007c2:	1830      	adds	r0, r6, r0
c0d007c4:	f002 f9b0 	bl	c0d02b28 <processTx>
            bech32_get_address((char *)ctx->toAddr, ctx->txContent.destination, 20);
c0d007c8:	2057      	movs	r0, #87	; 0x57
c0d007ca:	00c0      	lsls	r0, r0, #3
c0d007cc:	1834      	adds	r4, r6, r0
c0d007ce:	2015      	movs	r0, #21
c0d007d0:	0140      	lsls	r0, r0, #5
c0d007d2:	1831      	adds	r1, r6, r0
c0d007d4:	2214      	movs	r2, #20
c0d007d6:	4620      	mov	r0, r4
c0d007d8:	f7ff fcb8 	bl	c0d0014c <bech32_get_address>
c0d007dc:	482a      	ldr	r0, [pc, #168]	; (c0d00888 <ui_signTx_approve_button+0xe8>)
            os_memmove(ctx->partialAddrStr, ctx->toAddr, 12);
c0d007de:	1830      	adds	r0, r6, r0
c0d007e0:	220c      	movs	r2, #12
c0d007e2:	4621      	mov	r1, r4
c0d007e4:	f001 fa19 	bl	c0d01c1a <os_memmove>
            ctx->partialAddrStr[12] = '\0';
c0d007e8:	4828      	ldr	r0, [pc, #160]	; (c0d0088c <ui_signTx_approve_button+0xec>)
c0d007ea:	2500      	movs	r5, #0
c0d007ec:	5435      	strb	r5, [r6, r0]
            ctx->displayIndex = 0;
c0d007ee:	7035      	strb	r5, [r6, #0]
            UX_DISPLAY(ui_address_compare, ui_prepro_address_compare);
c0d007f0:	4c27      	ldr	r4, [pc, #156]	; (c0d00890 <ui_signTx_approve_button+0xf0>)
c0d007f2:	482a      	ldr	r0, [pc, #168]	; (c0d0089c <ui_signTx_approve_button+0xfc>)
c0d007f4:	4478      	add	r0, pc
c0d007f6:	6020      	str	r0, [r4, #0]
c0d007f8:	2005      	movs	r0, #5
c0d007fa:	6060      	str	r0, [r4, #4]
c0d007fc:	4828      	ldr	r0, [pc, #160]	; (c0d008a0 <ui_signTx_approve_button+0x100>)
c0d007fe:	4478      	add	r0, pc
c0d00800:	6120      	str	r0, [r4, #16]
c0d00802:	4828      	ldr	r0, [pc, #160]	; (c0d008a4 <ui_signTx_approve_button+0x104>)
c0d00804:	4478      	add	r0, pc
c0d00806:	60e0      	str	r0, [r4, #12]
c0d00808:	2003      	movs	r0, #3
c0d0080a:	7620      	strb	r0, [r4, #24]
c0d0080c:	61e5      	str	r5, [r4, #28]
c0d0080e:	4620      	mov	r0, r4
c0d00810:	3018      	adds	r0, #24
c0d00812:	f002 fc37 	bl	c0d03084 <os_ux>
c0d00816:	61e0      	str	r0, [r4, #28]
c0d00818:	f002 f8b8 	bl	c0d0298c <ux_check_status_default>
c0d0081c:	f001 fc08 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00820:	f001 fc0c 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00824:	60a5      	str	r5, [r4, #8]
c0d00826:	6820      	ldr	r0, [r4, #0]
c0d00828:	2800      	cmp	r0, #0
c0d0082a:	d024      	beq.n	c0d00876 <ui_signTx_approve_button+0xd6>
c0d0082c:	69e0      	ldr	r0, [r4, #28]
c0d0082e:	4919      	ldr	r1, [pc, #100]	; (c0d00894 <ui_signTx_approve_button+0xf4>)
c0d00830:	4288      	cmp	r0, r1
c0d00832:	d11e      	bne.n	c0d00872 <ui_signTx_approve_button+0xd2>
c0d00834:	e01f      	b.n	c0d00876 <ui_signTx_approve_button+0xd6>
c0d00836:	6860      	ldr	r0, [r4, #4]
c0d00838:	4285      	cmp	r5, r0
c0d0083a:	d21c      	bcs.n	c0d00876 <ui_signTx_approve_button+0xd6>
c0d0083c:	f002 fc7c 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00840:	2800      	cmp	r0, #0
c0d00842:	d118      	bne.n	c0d00876 <ui_signTx_approve_button+0xd6>
c0d00844:	68a0      	ldr	r0, [r4, #8]
c0d00846:	68e1      	ldr	r1, [r4, #12]
c0d00848:	2538      	movs	r5, #56	; 0x38
c0d0084a:	4368      	muls	r0, r5
c0d0084c:	6822      	ldr	r2, [r4, #0]
c0d0084e:	1810      	adds	r0, r2, r0
c0d00850:	2900      	cmp	r1, #0
c0d00852:	d002      	beq.n	c0d0085a <ui_signTx_approve_button+0xba>
c0d00854:	4788      	blx	r1
c0d00856:	2800      	cmp	r0, #0
c0d00858:	d007      	beq.n	c0d0086a <ui_signTx_approve_button+0xca>
c0d0085a:	2801      	cmp	r0, #1
c0d0085c:	d103      	bne.n	c0d00866 <ui_signTx_approve_button+0xc6>
c0d0085e:	68a0      	ldr	r0, [r4, #8]
c0d00860:	4345      	muls	r5, r0
c0d00862:	6820      	ldr	r0, [r4, #0]
c0d00864:	1940      	adds	r0, r0, r5
c0d00866:	f000 fd4d 	bl	c0d01304 <io_seproxyhal_display>
c0d0086a:	68a0      	ldr	r0, [r4, #8]
c0d0086c:	1c45      	adds	r5, r0, #1
c0d0086e:	60a5      	str	r5, [r4, #8]
c0d00870:	6820      	ldr	r0, [r4, #0]
c0d00872:	2800      	cmp	r0, #0
c0d00874:	d1df      	bne.n	c0d00836 <ui_signTx_approve_button+0x96>
            break;
    }
    return 0;
c0d00876:	2000      	movs	r0, #0
c0d00878:	bd70      	pop	{r4, r5, r6, pc}
c0d0087a:	46c0      	nop			; (mov r8, r8)
c0d0087c:	80000002 	.word	0x80000002
c0d00880:	80000001 	.word	0x80000001
c0d00884:	20001930 	.word	0x20001930
c0d00888:	000002e2 	.word	0x000002e2
c0d0088c:	000002ee 	.word	0x000002ee
c0d00890:	20001880 	.word	0x20001880
c0d00894:	b0105044 	.word	0xb0105044
c0d00898:	00006985 	.word	0x00006985
c0d0089c:	00004adc 	.word	0x00004adc
c0d008a0:	000000a7 	.word	0x000000a7
c0d008a4:	0000040d 	.word	0x0000040d

c0d008a8 <ui_address_compare_button>:
        default:
            return element;
    }
}

static unsigned int ui_address_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d008a8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d008aa:	b0b5      	sub	sp, #212	; 0xd4
    uint8_t numberBuf[32];

    switch (button_mask) {
c0d008ac:	2801      	cmp	r0, #1
c0d008ae:	dd08      	ble.n	c0d008c2 <ui_address_compare_button+0x1a>
c0d008b0:	2802      	cmp	r0, #2
c0d008b2:	d055      	beq.n	c0d00960 <ui_address_compare_button+0xb8>
c0d008b4:	49c7      	ldr	r1, [pc, #796]	; (c0d00bd4 <ui_address_compare_button+0x32c>)
c0d008b6:	4288      	cmp	r0, r1
c0d008b8:	d052      	beq.n	c0d00960 <ui_address_compare_button+0xb8>
c0d008ba:	49c7      	ldr	r1, [pc, #796]	; (c0d00bd8 <ui_address_compare_button+0x330>)
c0d008bc:	4288      	cmp	r0, r1
c0d008be:	d007      	beq.n	c0d008d0 <ui_address_compare_button+0x28>
c0d008c0:	e184      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d008c2:	49c6      	ldr	r1, [pc, #792]	; (c0d00bdc <ui_address_compare_button+0x334>)
c0d008c4:	4288      	cmp	r0, r1
c0d008c6:	d100      	bne.n	c0d008ca <ui_address_compare_button+0x22>
c0d008c8:	e08d      	b.n	c0d009e6 <ui_address_compare_button+0x13e>
c0d008ca:	2801      	cmp	r0, #1
c0d008cc:	d000      	beq.n	c0d008d0 <ui_address_compare_button+0x28>
c0d008ce:	e17d      	b.n	c0d00bcc <ui_address_compare_button+0x324>
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
c0d008d0:	49c4      	ldr	r1, [pc, #784]	; (c0d00be4 <ui_address_compare_button+0x33c>)
c0d008d2:	7808      	ldrb	r0, [r1, #0]
c0d008d4:	2500      	movs	r5, #0
c0d008d6:	2800      	cmp	r0, #0
                ctx->displayIndex--;
            }

            os_memmove(ctx->partialAddrStr, ctx->toAddr+ctx->displayIndex, 12);
c0d008d8:	462a      	mov	r2, r5
c0d008da:	d001      	beq.n	c0d008e0 <ui_address_compare_button+0x38>
    switch (button_mask) {
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
                ctx->displayIndex--;
c0d008dc:	1e42      	subs	r2, r0, #1
c0d008de:	700a      	strb	r2, [r1, #0]
            }

            os_memmove(ctx->partialAddrStr, ctx->toAddr+ctx->displayIndex, 12);
c0d008e0:	48c6      	ldr	r0, [pc, #792]	; (c0d00bfc <ui_address_compare_button+0x354>)
c0d008e2:	1808      	adds	r0, r1, r0
c0d008e4:	b2d2      	uxtb	r2, r2
c0d008e6:	1889      	adds	r1, r1, r2
c0d008e8:	2257      	movs	r2, #87	; 0x57
c0d008ea:	00d2      	lsls	r2, r2, #3
c0d008ec:	1889      	adds	r1, r1, r2
c0d008ee:	220c      	movs	r2, #12
c0d008f0:	f001 f993 	bl	c0d01c1a <os_memmove>
            // Re-render the screen.
            UX_REDISPLAY();
c0d008f4:	f001 fb9c 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d008f8:	f001 fba0 	bl	c0d0203c <io_seproxyhal_init_button>
c0d008fc:	4cbd      	ldr	r4, [pc, #756]	; (c0d00bf4 <ui_address_compare_button+0x34c>)
c0d008fe:	60a5      	str	r5, [r4, #8]
c0d00900:	6820      	ldr	r0, [r4, #0]
c0d00902:	2800      	cmp	r0, #0
c0d00904:	d100      	bne.n	c0d00908 <ui_address_compare_button+0x60>
c0d00906:	e161      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00908:	69e0      	ldr	r0, [r4, #28]
c0d0090a:	49bb      	ldr	r1, [pc, #748]	; (c0d00bf8 <ui_address_compare_button+0x350>)
c0d0090c:	4288      	cmp	r0, r1
c0d0090e:	d100      	bne.n	c0d00912 <ui_address_compare_button+0x6a>
c0d00910:	e15c      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00912:	2800      	cmp	r0, #0
c0d00914:	d100      	bne.n	c0d00918 <ui_address_compare_button+0x70>
c0d00916:	e159      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00918:	2000      	movs	r0, #0
c0d0091a:	6861      	ldr	r1, [r4, #4]
c0d0091c:	4288      	cmp	r0, r1
c0d0091e:	d300      	bcc.n	c0d00922 <ui_address_compare_button+0x7a>
c0d00920:	e154      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00922:	f002 fc09 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00926:	2800      	cmp	r0, #0
c0d00928:	d000      	beq.n	c0d0092c <ui_address_compare_button+0x84>
c0d0092a:	e14f      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d0092c:	68a0      	ldr	r0, [r4, #8]
c0d0092e:	68e1      	ldr	r1, [r4, #12]
c0d00930:	2538      	movs	r5, #56	; 0x38
c0d00932:	4368      	muls	r0, r5
c0d00934:	6822      	ldr	r2, [r4, #0]
c0d00936:	1810      	adds	r0, r2, r0
c0d00938:	2900      	cmp	r1, #0
c0d0093a:	d002      	beq.n	c0d00942 <ui_address_compare_button+0x9a>
c0d0093c:	4788      	blx	r1
c0d0093e:	2800      	cmp	r0, #0
c0d00940:	d007      	beq.n	c0d00952 <ui_address_compare_button+0xaa>
c0d00942:	2801      	cmp	r0, #1
c0d00944:	d103      	bne.n	c0d0094e <ui_address_compare_button+0xa6>
c0d00946:	68a0      	ldr	r0, [r4, #8]
c0d00948:	4345      	muls	r5, r0
c0d0094a:	6820      	ldr	r0, [r4, #0]
c0d0094c:	1940      	adds	r0, r0, r5
c0d0094e:	f000 fcd9 	bl	c0d01304 <io_seproxyhal_display>
c0d00952:	68a0      	ldr	r0, [r4, #8]
c0d00954:	1c40      	adds	r0, r0, #1
c0d00956:	60a0      	str	r0, [r4, #8]
c0d00958:	6821      	ldr	r1, [r4, #0]
c0d0095a:	2900      	cmp	r1, #0
c0d0095c:	d1dd      	bne.n	c0d0091a <ui_address_compare_button+0x72>
c0d0095e:	e135      	b.n	c0d00bcc <ui_address_compare_button+0x324>
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < sizeof(ctx->toAddr)-12) {
c0d00960:	49a0      	ldr	r1, [pc, #640]	; (c0d00be4 <ui_address_compare_button+0x33c>)
c0d00962:	780a      	ldrb	r2, [r1, #0]
c0d00964:	2a1d      	cmp	r2, #29
c0d00966:	d801      	bhi.n	c0d0096c <ui_address_compare_button+0xc4>
                ctx->displayIndex++;
c0d00968:	1c52      	adds	r2, r2, #1
c0d0096a:	700a      	strb	r2, [r1, #0]
            }
            os_memmove(ctx->partialAddrStr, ctx->toAddr+ctx->displayIndex, 12);
c0d0096c:	48a3      	ldr	r0, [pc, #652]	; (c0d00bfc <ui_address_compare_button+0x354>)
c0d0096e:	1808      	adds	r0, r1, r0
c0d00970:	b2d2      	uxtb	r2, r2
c0d00972:	1889      	adds	r1, r1, r2
c0d00974:	2257      	movs	r2, #87	; 0x57
c0d00976:	00d2      	lsls	r2, r2, #3
c0d00978:	1889      	adds	r1, r1, r2
c0d0097a:	220c      	movs	r2, #12
c0d0097c:	f001 f94d 	bl	c0d01c1a <os_memmove>
            UX_REDISPLAY();
c0d00980:	f001 fb56 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00984:	f001 fb5a 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00988:	4c9a      	ldr	r4, [pc, #616]	; (c0d00bf4 <ui_address_compare_button+0x34c>)
c0d0098a:	2000      	movs	r0, #0
c0d0098c:	60a0      	str	r0, [r4, #8]
c0d0098e:	6821      	ldr	r1, [r4, #0]
c0d00990:	2900      	cmp	r1, #0
c0d00992:	d100      	bne.n	c0d00996 <ui_address_compare_button+0xee>
c0d00994:	e11a      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00996:	69e1      	ldr	r1, [r4, #28]
c0d00998:	4a97      	ldr	r2, [pc, #604]	; (c0d00bf8 <ui_address_compare_button+0x350>)
c0d0099a:	4291      	cmp	r1, r2
c0d0099c:	d120      	bne.n	c0d009e0 <ui_address_compare_button+0x138>
c0d0099e:	e115      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d009a0:	6861      	ldr	r1, [r4, #4]
c0d009a2:	4288      	cmp	r0, r1
c0d009a4:	d300      	bcc.n	c0d009a8 <ui_address_compare_button+0x100>
c0d009a6:	e111      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d009a8:	f002 fbc6 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d009ac:	2800      	cmp	r0, #0
c0d009ae:	d000      	beq.n	c0d009b2 <ui_address_compare_button+0x10a>
c0d009b0:	e10c      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d009b2:	68a0      	ldr	r0, [r4, #8]
c0d009b4:	68e1      	ldr	r1, [r4, #12]
c0d009b6:	2538      	movs	r5, #56	; 0x38
c0d009b8:	4368      	muls	r0, r5
c0d009ba:	6822      	ldr	r2, [r4, #0]
c0d009bc:	1810      	adds	r0, r2, r0
c0d009be:	2900      	cmp	r1, #0
c0d009c0:	d002      	beq.n	c0d009c8 <ui_address_compare_button+0x120>
c0d009c2:	4788      	blx	r1
c0d009c4:	2800      	cmp	r0, #0
c0d009c6:	d007      	beq.n	c0d009d8 <ui_address_compare_button+0x130>
c0d009c8:	2801      	cmp	r0, #1
c0d009ca:	d103      	bne.n	c0d009d4 <ui_address_compare_button+0x12c>
c0d009cc:	68a0      	ldr	r0, [r4, #8]
c0d009ce:	4345      	muls	r5, r0
c0d009d0:	6820      	ldr	r0, [r4, #0]
c0d009d2:	1940      	adds	r0, r0, r5
c0d009d4:	f000 fc96 	bl	c0d01304 <io_seproxyhal_display>
c0d009d8:	68a0      	ldr	r0, [r4, #8]
c0d009da:	1c40      	adds	r0, r0, #1
c0d009dc:	60a0      	str	r0, [r4, #8]
c0d009de:	6821      	ldr	r1, [r4, #0]
c0d009e0:	2900      	cmp	r1, #0
c0d009e2:	d1dd      	bne.n	c0d009a0 <ui_address_compare_button+0xf8>
c0d009e4:	e0f2      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d009e6:	a804      	add	r0, sp, #16
c0d009e8:	2400      	movs	r4, #0
c0d009ea:	2520      	movs	r5, #32
c0d009ec:	4606      	mov	r6, r0
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            os_memset(numberBuf, 0, 32);
c0d009ee:	4621      	mov	r1, r4
c0d009f0:	462a      	mov	r2, r5
c0d009f2:	f001 f909 	bl	c0d01c08 <os_memset>
            os_memcpy(&numberBuf[32- ctx->txContent.value.length], ctx->txContent.value.value, ctx->txContent.value.length);
c0d009f6:	487a      	ldr	r0, [pc, #488]	; (c0d00be0 <ui_address_compare_button+0x338>)
c0d009f8:	4a7a      	ldr	r2, [pc, #488]	; (c0d00be4 <ui_address_compare_button+0x33c>)
c0d009fa:	1811      	adds	r1, r2, r0
c0d009fc:	487a      	ldr	r0, [pc, #488]	; (c0d00be8 <ui_address_compare_button+0x340>)
c0d009fe:	5c12      	ldrb	r2, [r2, r0]
c0d00a00:	1aa8      	subs	r0, r5, r2
c0d00a02:	1830      	adds	r0, r6, r0
c0d00a04:	4635      	mov	r5, r6
c0d00a06:	f001 f908 	bl	c0d01c1a <os_memmove>
c0d00a0a:	a82c      	add	r0, sp, #176	; 0xb0
    uint256_t amount;
    uint256_t nanoAmount;
    uint256_t rMod;
    uint256_t nano;

    clear256(&target);
c0d00a0c:	9001      	str	r0, [sp, #4]
c0d00a0e:	f002 fbf2 	bl	c0d031f6 <clear256>
c0d00a12:	a824      	add	r0, sp, #144	; 0x90
    clear256(&amount);
c0d00a14:	9003      	str	r0, [sp, #12]
c0d00a16:	f002 fbee 	bl	c0d031f6 <clear256>
c0d00a1a:	a81c      	add	r0, sp, #112	; 0x70
    clear256(&nanoAmount);
c0d00a1c:	9002      	str	r0, [sp, #8]
c0d00a1e:	f002 fbea 	bl	c0d031f6 <clear256>
c0d00a22:	ae14      	add	r6, sp, #80	; 0x50
    clear256(&rMod);
c0d00a24:	4630      	mov	r0, r6
c0d00a26:	f002 fbe6 	bl	c0d031f6 <clear256>
c0d00a2a:	af0c      	add	r7, sp, #48	; 0x30
    clear256(&nano);
c0d00a2c:	4638      	mov	r0, r7
c0d00a2e:	f002 fbe2 	bl	c0d031f6 <clear256>

    readu256BE(buffer, &target);
c0d00a32:	4628      	mov	r0, r5
c0d00a34:	9d01      	ldr	r5, [sp, #4]
c0d00a36:	4629      	mov	r1, r5
c0d00a38:	f002 fbc3 	bl	c0d031c2 <readu256BE>

    UPPER(LOWER(nano)) = 0;
c0d00a3c:	9411      	str	r4, [sp, #68]	; 0x44
c0d00a3e:	9410      	str	r4, [sp, #64]	; 0x40
    LOWER(LOWER(nano)) = 1000000000;
c0d00a40:	9413      	str	r4, [sp, #76]	; 0x4c
c0d00a42:	486a      	ldr	r0, [pc, #424]	; (c0d00bec <ui_address_compare_button+0x344>)
c0d00a44:	9012      	str	r0, [sp, #72]	; 0x48

    //convert to nano
    divmod256(&target, &nano, &nanoAmount, &rMod);
c0d00a46:	4628      	mov	r0, r5
c0d00a48:	4639      	mov	r1, r7
c0d00a4a:	9d02      	ldr	r5, [sp, #8]
c0d00a4c:	462a      	mov	r2, r5
c0d00a4e:	4633      	mov	r3, r6
c0d00a50:	f002 ffb5 	bl	c0d039be <divmod256>

    //convert to one
    divmod256(&nanoAmount, &nano, &amount, &rMod);
c0d00a54:	4628      	mov	r0, r5
c0d00a56:	4639      	mov	r1, r7
c0d00a58:	9a03      	ldr	r2, [sp, #12]
c0d00a5a:	4633      	mov	r3, r6
c0d00a5c:	f002 ffaf 	bl	c0d039be <divmod256>

    os_memset(ctx->amountStr, 0, 78);
c0d00a60:	4863      	ldr	r0, [pc, #396]	; (c0d00bf0 <ui_address_compare_button+0x348>)
c0d00a62:	4960      	ldr	r1, [pc, #384]	; (c0d00be4 <ui_address_compare_button+0x33c>)
c0d00a64:	180d      	adds	r5, r1, r0
c0d00a66:	264e      	movs	r6, #78	; 0x4e
c0d00a68:	4628      	mov	r0, r5
c0d00a6a:	4621      	mov	r1, r4
c0d00a6c:	4632      	mov	r2, r6
c0d00a6e:	f001 f8cb 	bl	c0d01c08 <os_memset>
    tostring256(&amount, 10, (char *)ctx->amountStr, 78, outLength);
c0d00a72:	200d      	movs	r0, #13
c0d00a74:	0187      	lsls	r7, r0, #6
c0d00a76:	495b      	ldr	r1, [pc, #364]	; (c0d00be4 <ui_address_compare_button+0x33c>)
c0d00a78:	4608      	mov	r0, r1
c0d00a7a:	19c0      	adds	r0, r0, r7
c0d00a7c:	4669      	mov	r1, sp
c0d00a7e:	6008      	str	r0, [r1, #0]
c0d00a80:	210a      	movs	r1, #10
c0d00a82:	9803      	ldr	r0, [sp, #12]
c0d00a84:	462a      	mov	r2, r5
c0d00a86:	4633      	mov	r3, r6
c0d00a88:	4e56      	ldr	r6, [pc, #344]	; (c0d00be4 <ui_address_compare_button+0x33c>)
c0d00a8a:	f003 f8ef 	bl	c0d03c6c <tostring256>

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            os_memset(numberBuf, 0, 32);
            os_memcpy(&numberBuf[32- ctx->txContent.value.length], ctx->txContent.value.value, ctx->txContent.value.length);
            convertU256ToString(numberBuf, &ctx->amountLength);
            ctx->displayIndex = 0;
c0d00a8e:	7034      	strb	r4, [r6, #0]
            if (ctx->amountLength > 12) {
c0d00a90:	59f2      	ldr	r2, [r6, r7]
c0d00a92:	2a0d      	cmp	r2, #13
c0d00a94:	d34f      	bcc.n	c0d00b36 <ui_address_compare_button+0x28e>
                os_memmove(ctx->partialAmountStr, ctx->amountStr, 12);
c0d00a96:	4856      	ldr	r0, [pc, #344]	; (c0d00bf0 <ui_address_compare_button+0x348>)
c0d00a98:	1831      	adds	r1, r6, r0
c0d00a9a:	20d1      	movs	r0, #209	; 0xd1
c0d00a9c:	0080      	lsls	r0, r0, #2
c0d00a9e:	1830      	adds	r0, r6, r0
c0d00aa0:	220c      	movs	r2, #12
c0d00aa2:	f001 f8ba 	bl	c0d01c1a <os_memmove>
                ctx->partialAmountStr[12] = 0;
c0d00aa6:	2035      	movs	r0, #53	; 0x35
c0d00aa8:	0100      	lsls	r0, r0, #4
c0d00aaa:	2500      	movs	r5, #0
c0d00aac:	5435      	strb	r5, [r6, r0]
                UX_DISPLAY(ui_amount_compare_large, ui_prepro_amount_compare);
c0d00aae:	4c51      	ldr	r4, [pc, #324]	; (c0d00bf4 <ui_address_compare_button+0x34c>)
c0d00ab0:	4853      	ldr	r0, [pc, #332]	; (c0d00c00 <ui_address_compare_button+0x358>)
c0d00ab2:	4478      	add	r0, pc
c0d00ab4:	6020      	str	r0, [r4, #0]
c0d00ab6:	2005      	movs	r0, #5
c0d00ab8:	6060      	str	r0, [r4, #4]
c0d00aba:	4852      	ldr	r0, [pc, #328]	; (c0d00c04 <ui_address_compare_button+0x35c>)
c0d00abc:	4478      	add	r0, pc
c0d00abe:	6120      	str	r0, [r4, #16]
c0d00ac0:	4851      	ldr	r0, [pc, #324]	; (c0d00c08 <ui_address_compare_button+0x360>)
c0d00ac2:	4478      	add	r0, pc
c0d00ac4:	60e0      	str	r0, [r4, #12]
c0d00ac6:	2003      	movs	r0, #3
c0d00ac8:	7620      	strb	r0, [r4, #24]
c0d00aca:	61e5      	str	r5, [r4, #28]
c0d00acc:	4620      	mov	r0, r4
c0d00ace:	3018      	adds	r0, #24
c0d00ad0:	f002 fad8 	bl	c0d03084 <os_ux>
c0d00ad4:	61e0      	str	r0, [r4, #28]
c0d00ad6:	f001 ff59 	bl	c0d0298c <ux_check_status_default>
c0d00ada:	f001 faa9 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00ade:	f001 faad 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00ae2:	60a5      	str	r5, [r4, #8]
c0d00ae4:	6820      	ldr	r0, [r4, #0]
c0d00ae6:	2800      	cmp	r0, #0
c0d00ae8:	d070      	beq.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00aea:	69e0      	ldr	r0, [r4, #28]
c0d00aec:	4942      	ldr	r1, [pc, #264]	; (c0d00bf8 <ui_address_compare_button+0x350>)
c0d00aee:	4288      	cmp	r0, r1
c0d00af0:	d11e      	bne.n	c0d00b30 <ui_address_compare_button+0x288>
c0d00af2:	e06b      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00af4:	6860      	ldr	r0, [r4, #4]
c0d00af6:	4285      	cmp	r5, r0
c0d00af8:	d268      	bcs.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00afa:	f002 fb1d 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00afe:	2800      	cmp	r0, #0
c0d00b00:	d164      	bne.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00b02:	68a0      	ldr	r0, [r4, #8]
c0d00b04:	68e1      	ldr	r1, [r4, #12]
c0d00b06:	2538      	movs	r5, #56	; 0x38
c0d00b08:	4368      	muls	r0, r5
c0d00b0a:	6822      	ldr	r2, [r4, #0]
c0d00b0c:	1810      	adds	r0, r2, r0
c0d00b0e:	2900      	cmp	r1, #0
c0d00b10:	d002      	beq.n	c0d00b18 <ui_address_compare_button+0x270>
c0d00b12:	4788      	blx	r1
c0d00b14:	2800      	cmp	r0, #0
c0d00b16:	d007      	beq.n	c0d00b28 <ui_address_compare_button+0x280>
c0d00b18:	2801      	cmp	r0, #1
c0d00b1a:	d103      	bne.n	c0d00b24 <ui_address_compare_button+0x27c>
c0d00b1c:	68a0      	ldr	r0, [r4, #8]
c0d00b1e:	4345      	muls	r5, r0
c0d00b20:	6820      	ldr	r0, [r4, #0]
c0d00b22:	1940      	adds	r0, r0, r5
c0d00b24:	f000 fbee 	bl	c0d01304 <io_seproxyhal_display>
c0d00b28:	68a0      	ldr	r0, [r4, #8]
c0d00b2a:	1c45      	adds	r5, r0, #1
c0d00b2c:	60a5      	str	r5, [r4, #8]
c0d00b2e:	6820      	ldr	r0, [r4, #0]
c0d00b30:	2800      	cmp	r0, #0
c0d00b32:	d1df      	bne.n	c0d00af4 <ui_address_compare_button+0x24c>
c0d00b34:	e04a      	b.n	c0d00bcc <ui_address_compare_button+0x324>
            }
            else {
                os_memmove(ctx->partialAmountStr, ctx->amountStr, ctx->amountLength);
c0d00b36:	482e      	ldr	r0, [pc, #184]	; (c0d00bf0 <ui_address_compare_button+0x348>)
c0d00b38:	1831      	adds	r1, r6, r0
c0d00b3a:	20d1      	movs	r0, #209	; 0xd1
c0d00b3c:	0080      	lsls	r0, r0, #2
c0d00b3e:	1835      	adds	r5, r6, r0
c0d00b40:	4628      	mov	r0, r5
c0d00b42:	f001 f86a 	bl	c0d01c1a <os_memmove>
                ctx->partialAmountStr[ctx->amountLength] = 0;
c0d00b46:	59f0      	ldr	r0, [r6, r7]
c0d00b48:	542c      	strb	r4, [r5, r0]
                UX_DISPLAY(ui_amount_compare, NULL);
c0d00b4a:	4d2a      	ldr	r5, [pc, #168]	; (c0d00bf4 <ui_address_compare_button+0x34c>)
c0d00b4c:	482f      	ldr	r0, [pc, #188]	; (c0d00c0c <ui_address_compare_button+0x364>)
c0d00b4e:	4478      	add	r0, pc
c0d00b50:	6028      	str	r0, [r5, #0]
c0d00b52:	2005      	movs	r0, #5
c0d00b54:	6068      	str	r0, [r5, #4]
c0d00b56:	482e      	ldr	r0, [pc, #184]	; (c0d00c10 <ui_address_compare_button+0x368>)
c0d00b58:	4478      	add	r0, pc
c0d00b5a:	6128      	str	r0, [r5, #16]
c0d00b5c:	60ec      	str	r4, [r5, #12]
c0d00b5e:	2003      	movs	r0, #3
c0d00b60:	7628      	strb	r0, [r5, #24]
c0d00b62:	61ec      	str	r4, [r5, #28]
c0d00b64:	4628      	mov	r0, r5
c0d00b66:	3018      	adds	r0, #24
c0d00b68:	f002 fa8c 	bl	c0d03084 <os_ux>
c0d00b6c:	61e8      	str	r0, [r5, #28]
c0d00b6e:	f001 ff0d 	bl	c0d0298c <ux_check_status_default>
c0d00b72:	f001 fa5d 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00b76:	f001 fa61 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00b7a:	60ac      	str	r4, [r5, #8]
c0d00b7c:	6828      	ldr	r0, [r5, #0]
c0d00b7e:	2800      	cmp	r0, #0
c0d00b80:	d024      	beq.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00b82:	69e8      	ldr	r0, [r5, #28]
c0d00b84:	491c      	ldr	r1, [pc, #112]	; (c0d00bf8 <ui_address_compare_button+0x350>)
c0d00b86:	4288      	cmp	r0, r1
c0d00b88:	d11e      	bne.n	c0d00bc8 <ui_address_compare_button+0x320>
c0d00b8a:	e01f      	b.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00b8c:	6868      	ldr	r0, [r5, #4]
c0d00b8e:	4284      	cmp	r4, r0
c0d00b90:	d21c      	bcs.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00b92:	f002 fad1 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00b96:	2800      	cmp	r0, #0
c0d00b98:	d118      	bne.n	c0d00bcc <ui_address_compare_button+0x324>
c0d00b9a:	68a8      	ldr	r0, [r5, #8]
c0d00b9c:	68e9      	ldr	r1, [r5, #12]
c0d00b9e:	2438      	movs	r4, #56	; 0x38
c0d00ba0:	4360      	muls	r0, r4
c0d00ba2:	682a      	ldr	r2, [r5, #0]
c0d00ba4:	1810      	adds	r0, r2, r0
c0d00ba6:	2900      	cmp	r1, #0
c0d00ba8:	d002      	beq.n	c0d00bb0 <ui_address_compare_button+0x308>
c0d00baa:	4788      	blx	r1
c0d00bac:	2800      	cmp	r0, #0
c0d00bae:	d007      	beq.n	c0d00bc0 <ui_address_compare_button+0x318>
c0d00bb0:	2801      	cmp	r0, #1
c0d00bb2:	d103      	bne.n	c0d00bbc <ui_address_compare_button+0x314>
c0d00bb4:	68a8      	ldr	r0, [r5, #8]
c0d00bb6:	4344      	muls	r4, r0
c0d00bb8:	6828      	ldr	r0, [r5, #0]
c0d00bba:	1900      	adds	r0, r0, r4
c0d00bbc:	f000 fba2 	bl	c0d01304 <io_seproxyhal_display>
c0d00bc0:	68a8      	ldr	r0, [r5, #8]
c0d00bc2:	1c44      	adds	r4, r0, #1
c0d00bc4:	60ac      	str	r4, [r5, #8]
c0d00bc6:	6828      	ldr	r0, [r5, #0]
c0d00bc8:	2800      	cmp	r0, #0
c0d00bca:	d1df      	bne.n	c0d00b8c <ui_address_compare_button+0x2e4>

            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
c0d00bcc:	2000      	movs	r0, #0
c0d00bce:	b035      	add	sp, #212	; 0xd4
c0d00bd0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00bd2:	46c0      	nop			; (mov r8, r8)
c0d00bd4:	40000002 	.word	0x40000002
c0d00bd8:	40000001 	.word	0x40000001
c0d00bdc:	80000003 	.word	0x80000003
c0d00be0:	00000276 	.word	0x00000276
c0d00be4:	20001930 	.word	0x20001930
c0d00be8:	00000296 	.word	0x00000296
c0d00bec:	3b9aca00 	.word	0x3b9aca00
c0d00bf0:	000002ef 	.word	0x000002ef
c0d00bf4:	20001880 	.word	0x20001880
c0d00bf8:	b0105044 	.word	0xb0105044
c0d00bfc:	000002e2 	.word	0x000002e2
c0d00c00:	00004962 	.word	0x00004962
c0d00c04:	0000017d 	.word	0x0000017d
c0d00c08:	000003a3 	.word	0x000003a3
c0d00c0c:	000049de 	.word	0x000049de
c0d00c10:	0000033d 	.word	0x0000033d

c0d00c14 <ui_prepro_address_compare>:
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.partialAddrStr),
};


static const bagl_element_t* ui_prepro_address_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
c0d00c14:	7841      	ldrb	r1, [r0, #1]
c0d00c16:	2902      	cmp	r1, #2
c0d00c18:	d006      	beq.n	c0d00c28 <ui_prepro_address_compare+0x14>
c0d00c1a:	2901      	cmp	r1, #1
c0d00c1c:	d10b      	bne.n	c0d00c36 <ui_prepro_address_compare+0x22>
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
c0d00c1e:	4906      	ldr	r1, [pc, #24]	; (c0d00c38 <ui_prepro_address_compare+0x24>)
c0d00c20:	7809      	ldrb	r1, [r1, #0]
c0d00c22:	2900      	cmp	r1, #0
c0d00c24:	d006      	beq.n	c0d00c34 <ui_prepro_address_compare+0x20>
c0d00c26:	e006      	b.n	c0d00c36 <ui_prepro_address_compare+0x22>
        case 2:
            return (ctx->displayIndex == sizeof(ctx->toAddr)-12) ? NULL : element;
c0d00c28:	4903      	ldr	r1, [pc, #12]	; (c0d00c38 <ui_prepro_address_compare+0x24>)
c0d00c2a:	780a      	ldrb	r2, [r1, #0]
c0d00c2c:	2100      	movs	r1, #0
c0d00c2e:	2a1e      	cmp	r2, #30
c0d00c30:	d000      	beq.n	c0d00c34 <ui_prepro_address_compare+0x20>
c0d00c32:	4601      	mov	r1, r0
c0d00c34:	4608      	mov	r0, r1
        default:
            return element;
    }
}
c0d00c36:	4770      	bx	lr
c0d00c38:	20001930 	.word	0x20001930

c0d00c3c <ui_amount_compare_large_button>:
    }
}

// This is the button handler for the comparison screen. Unlike the approval
// button handler, this handler doesn't send any data to the computer.
static unsigned int ui_amount_compare_large_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d00c3c:	b5b0      	push	{r4, r5, r7, lr}
    switch (button_mask) {
c0d00c3e:	2801      	cmp	r0, #1
c0d00c40:	dd08      	ble.n	c0d00c54 <ui_amount_compare_large_button+0x18>
c0d00c42:	2802      	cmp	r0, #2
c0d00c44:	d021      	beq.n	c0d00c8a <ui_amount_compare_large_button+0x4e>
c0d00c46:	497d      	ldr	r1, [pc, #500]	; (c0d00e3c <ui_amount_compare_large_button+0x200>)
c0d00c48:	4288      	cmp	r0, r1
c0d00c4a:	d01e      	beq.n	c0d00c8a <ui_amount_compare_large_button+0x4e>
c0d00c4c:	497c      	ldr	r1, [pc, #496]	; (c0d00e40 <ui_amount_compare_large_button+0x204>)
c0d00c4e:	4288      	cmp	r0, r1
c0d00c50:	d006      	beq.n	c0d00c60 <ui_amount_compare_large_button+0x24>
c0d00c52:	e0f1      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00c54:	497b      	ldr	r1, [pc, #492]	; (c0d00e44 <ui_amount_compare_large_button+0x208>)
c0d00c56:	4288      	cmp	r0, r1
c0d00c58:	d02e      	beq.n	c0d00cb8 <ui_amount_compare_large_button+0x7c>
c0d00c5a:	2801      	cmp	r0, #1
c0d00c5c:	d000      	beq.n	c0d00c60 <ui_amount_compare_large_button+0x24>
c0d00c5e:	e0eb      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
        case BUTTON_LEFT:
        case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
            // Decrement the displayIndex when the left button is pressed (or held).
            if (ctx->displayIndex > 0) {
c0d00c60:	4879      	ldr	r0, [pc, #484]	; (c0d00e48 <ui_amount_compare_large_button+0x20c>)
c0d00c62:	7802      	ldrb	r2, [r0, #0]
c0d00c64:	2100      	movs	r1, #0
c0d00c66:	2a00      	cmp	r2, #0
c0d00c68:	d001      	beq.n	c0d00c6e <ui_amount_compare_large_button+0x32>
                ctx->displayIndex--;
c0d00c6a:	1e51      	subs	r1, r2, #1
c0d00c6c:	7001      	strb	r1, [r0, #0]
            }
            if (ctx->amountLength > 12) {
c0d00c6e:	220d      	movs	r2, #13
c0d00c70:	0192      	lsls	r2, r2, #6
c0d00c72:	5882      	ldr	r2, [r0, r2]
c0d00c74:	b2c9      	uxtb	r1, r1
c0d00c76:	1841      	adds	r1, r0, r1
c0d00c78:	4b78      	ldr	r3, [pc, #480]	; (c0d00e5c <ui_amount_compare_large_button+0x220>)
c0d00c7a:	18c9      	adds	r1, r1, r3
c0d00c7c:	2a0d      	cmp	r2, #13
c0d00c7e:	d372      	bcc.n	c0d00d66 <ui_amount_compare_large_button+0x12a>
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, 12);
c0d00c80:	22d1      	movs	r2, #209	; 0xd1
c0d00c82:	0092      	lsls	r2, r2, #2
c0d00c84:	1880      	adds	r0, r0, r2
c0d00c86:	220c      	movs	r2, #12
c0d00c88:	e070      	b.n	c0d00d6c <ui_amount_compare_large_button+0x130>
            UX_REDISPLAY();
            break;

        case BUTTON_RIGHT:
        case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
            if (ctx->displayIndex < ctx->amountLength-12) {
c0d00c8a:	200d      	movs	r0, #13
c0d00c8c:	0181      	lsls	r1, r0, #6
c0d00c8e:	486e      	ldr	r0, [pc, #440]	; (c0d00e48 <ui_amount_compare_large_button+0x20c>)
c0d00c90:	5842      	ldr	r2, [r0, r1]
c0d00c92:	4613      	mov	r3, r2
c0d00c94:	3b0c      	subs	r3, #12
c0d00c96:	7801      	ldrb	r1, [r0, #0]
c0d00c98:	4299      	cmp	r1, r3
c0d00c9a:	d201      	bcs.n	c0d00ca0 <ui_amount_compare_large_button+0x64>
                ctx->displayIndex++;
c0d00c9c:	1c49      	adds	r1, r1, #1
c0d00c9e:	7001      	strb	r1, [r0, #0]
c0d00ca0:	b2c9      	uxtb	r1, r1
c0d00ca2:	1841      	adds	r1, r0, r1
c0d00ca4:	4b6d      	ldr	r3, [pc, #436]	; (c0d00e5c <ui_amount_compare_large_button+0x220>)
c0d00ca6:	18c9      	adds	r1, r1, r3
            }
            if (ctx->amountLength > 12) {
c0d00ca8:	2a0d      	cmp	r2, #13
c0d00caa:	d200      	bcs.n	c0d00cae <ui_amount_compare_large_button+0x72>
c0d00cac:	e090      	b.n	c0d00dd0 <ui_amount_compare_large_button+0x194>
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, 12);
c0d00cae:	22d1      	movs	r2, #209	; 0xd1
c0d00cb0:	0092      	lsls	r2, r2, #2
c0d00cb2:	1880      	adds	r0, r0, r2
c0d00cb4:	220c      	movs	r2, #12
c0d00cb6:	e08e      	b.n	c0d00dd6 <ui_amount_compare_large_button+0x19a>
            }
            UX_REDISPLAY();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
            bin2dec(ctx->fromShardStr, ctx->txContent.fromShard);
c0d00cb8:	2053      	movs	r0, #83	; 0x53
c0d00cba:	00c0      	lsls	r0, r0, #3
c0d00cbc:	4d62      	ldr	r5, [pc, #392]	; (c0d00e48 <ui_amount_compare_large_button+0x20c>)
c0d00cbe:	582a      	ldr	r2, [r5, r0]
c0d00cc0:	4862      	ldr	r0, [pc, #392]	; (c0d00e4c <ui_amount_compare_large_button+0x210>)
c0d00cc2:	1828      	adds	r0, r5, r0
c0d00cc4:	2400      	movs	r4, #0
c0d00cc6:	4623      	mov	r3, r4
c0d00cc8:	f000 fac5 	bl	c0d01256 <bin2dec>
            bin2dec(ctx->toShardStr, ctx->txContent.toShard);
c0d00ccc:	20a7      	movs	r0, #167	; 0xa7
c0d00cce:	0080      	lsls	r0, r0, #2
c0d00cd0:	582a      	ldr	r2, [r5, r0]
c0d00cd2:	485f      	ldr	r0, [pc, #380]	; (c0d00e50 <ui_amount_compare_large_button+0x214>)
c0d00cd4:	1828      	adds	r0, r5, r0
c0d00cd6:	4623      	mov	r3, r4
c0d00cd8:	f000 fabd 	bl	c0d01256 <bin2dec>
            UX_DISPLAY(ui_fromshard_approve, NULL);
c0d00cdc:	4d5d      	ldr	r5, [pc, #372]	; (c0d00e54 <ui_amount_compare_large_button+0x218>)
c0d00cde:	4860      	ldr	r0, [pc, #384]	; (c0d00e60 <ui_amount_compare_large_button+0x224>)
c0d00ce0:	4478      	add	r0, pc
c0d00ce2:	6028      	str	r0, [r5, #0]
c0d00ce4:	2005      	movs	r0, #5
c0d00ce6:	6068      	str	r0, [r5, #4]
c0d00ce8:	485e      	ldr	r0, [pc, #376]	; (c0d00e64 <ui_amount_compare_large_button+0x228>)
c0d00cea:	4478      	add	r0, pc
c0d00cec:	6128      	str	r0, [r5, #16]
c0d00cee:	60ec      	str	r4, [r5, #12]
c0d00cf0:	2003      	movs	r0, #3
c0d00cf2:	7628      	strb	r0, [r5, #24]
c0d00cf4:	61ec      	str	r4, [r5, #28]
c0d00cf6:	4628      	mov	r0, r5
c0d00cf8:	3018      	adds	r0, #24
c0d00cfa:	f002 f9c3 	bl	c0d03084 <os_ux>
c0d00cfe:	61e8      	str	r0, [r5, #28]
c0d00d00:	f001 fe44 	bl	c0d0298c <ux_check_status_default>
c0d00d04:	f001 f994 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00d08:	f001 f998 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00d0c:	60ac      	str	r4, [r5, #8]
c0d00d0e:	6828      	ldr	r0, [r5, #0]
c0d00d10:	2800      	cmp	r0, #0
c0d00d12:	d100      	bne.n	c0d00d16 <ui_amount_compare_large_button+0xda>
c0d00d14:	e090      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00d16:	69e8      	ldr	r0, [r5, #28]
c0d00d18:	494f      	ldr	r1, [pc, #316]	; (c0d00e58 <ui_amount_compare_large_button+0x21c>)
c0d00d1a:	4288      	cmp	r0, r1
c0d00d1c:	d120      	bne.n	c0d00d60 <ui_amount_compare_large_button+0x124>
c0d00d1e:	e08b      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00d20:	6868      	ldr	r0, [r5, #4]
c0d00d22:	4284      	cmp	r4, r0
c0d00d24:	d300      	bcc.n	c0d00d28 <ui_amount_compare_large_button+0xec>
c0d00d26:	e087      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00d28:	f002 fa06 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00d2c:	2800      	cmp	r0, #0
c0d00d2e:	d000      	beq.n	c0d00d32 <ui_amount_compare_large_button+0xf6>
c0d00d30:	e082      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00d32:	68a8      	ldr	r0, [r5, #8]
c0d00d34:	68e9      	ldr	r1, [r5, #12]
c0d00d36:	2438      	movs	r4, #56	; 0x38
c0d00d38:	4360      	muls	r0, r4
c0d00d3a:	682a      	ldr	r2, [r5, #0]
c0d00d3c:	1810      	adds	r0, r2, r0
c0d00d3e:	2900      	cmp	r1, #0
c0d00d40:	d002      	beq.n	c0d00d48 <ui_amount_compare_large_button+0x10c>
c0d00d42:	4788      	blx	r1
c0d00d44:	2800      	cmp	r0, #0
c0d00d46:	d007      	beq.n	c0d00d58 <ui_amount_compare_large_button+0x11c>
c0d00d48:	2801      	cmp	r0, #1
c0d00d4a:	d103      	bne.n	c0d00d54 <ui_amount_compare_large_button+0x118>
c0d00d4c:	68a8      	ldr	r0, [r5, #8]
c0d00d4e:	4344      	muls	r4, r0
c0d00d50:	6828      	ldr	r0, [r5, #0]
c0d00d52:	1900      	adds	r0, r0, r4
c0d00d54:	f000 fad6 	bl	c0d01304 <io_seproxyhal_display>
c0d00d58:	68a8      	ldr	r0, [r5, #8]
c0d00d5a:	1c44      	adds	r4, r0, #1
c0d00d5c:	60ac      	str	r4, [r5, #8]
c0d00d5e:	6828      	ldr	r0, [r5, #0]
c0d00d60:	2800      	cmp	r0, #0
c0d00d62:	d1dd      	bne.n	c0d00d20 <ui_amount_compare_large_button+0xe4>
c0d00d64:	e068      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
            }
            if (ctx->amountLength > 12) {
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, 12);
            }
            else {
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, ctx->amountLength);
c0d00d66:	23d1      	movs	r3, #209	; 0xd1
c0d00d68:	009b      	lsls	r3, r3, #2
c0d00d6a:	18c0      	adds	r0, r0, r3
c0d00d6c:	f000 ff55 	bl	c0d01c1a <os_memmove>
            }
            // Re-render the screen.
            UX_REDISPLAY();
c0d00d70:	f001 f95e 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00d74:	f001 f962 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00d78:	4c36      	ldr	r4, [pc, #216]	; (c0d00e54 <ui_amount_compare_large_button+0x218>)
c0d00d7a:	2000      	movs	r0, #0
c0d00d7c:	60a0      	str	r0, [r4, #8]
c0d00d7e:	6821      	ldr	r1, [r4, #0]
c0d00d80:	2900      	cmp	r1, #0
c0d00d82:	d059      	beq.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00d84:	69e1      	ldr	r1, [r4, #28]
c0d00d86:	4a34      	ldr	r2, [pc, #208]	; (c0d00e58 <ui_amount_compare_large_button+0x21c>)
c0d00d88:	4291      	cmp	r1, r2
c0d00d8a:	d11e      	bne.n	c0d00dca <ui_amount_compare_large_button+0x18e>
c0d00d8c:	e054      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00d8e:	6861      	ldr	r1, [r4, #4]
c0d00d90:	4288      	cmp	r0, r1
c0d00d92:	d251      	bcs.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00d94:	f002 f9d0 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00d98:	2800      	cmp	r0, #0
c0d00d9a:	d14d      	bne.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00d9c:	68a0      	ldr	r0, [r4, #8]
c0d00d9e:	68e1      	ldr	r1, [r4, #12]
c0d00da0:	2538      	movs	r5, #56	; 0x38
c0d00da2:	4368      	muls	r0, r5
c0d00da4:	6822      	ldr	r2, [r4, #0]
c0d00da6:	1810      	adds	r0, r2, r0
c0d00da8:	2900      	cmp	r1, #0
c0d00daa:	d002      	beq.n	c0d00db2 <ui_amount_compare_large_button+0x176>
c0d00dac:	4788      	blx	r1
c0d00dae:	2800      	cmp	r0, #0
c0d00db0:	d007      	beq.n	c0d00dc2 <ui_amount_compare_large_button+0x186>
c0d00db2:	2801      	cmp	r0, #1
c0d00db4:	d103      	bne.n	c0d00dbe <ui_amount_compare_large_button+0x182>
c0d00db6:	68a0      	ldr	r0, [r4, #8]
c0d00db8:	4345      	muls	r5, r0
c0d00dba:	6820      	ldr	r0, [r4, #0]
c0d00dbc:	1940      	adds	r0, r0, r5
c0d00dbe:	f000 faa1 	bl	c0d01304 <io_seproxyhal_display>
c0d00dc2:	68a0      	ldr	r0, [r4, #8]
c0d00dc4:	1c40      	adds	r0, r0, #1
c0d00dc6:	60a0      	str	r0, [r4, #8]
c0d00dc8:	6821      	ldr	r1, [r4, #0]
c0d00dca:	2900      	cmp	r1, #0
c0d00dcc:	d1df      	bne.n	c0d00d8e <ui_amount_compare_large_button+0x152>
c0d00dce:	e033      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
            }
            if (ctx->amountLength > 12) {
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, 12);
            }
            else {
                os_memmove(ctx->partialAmountStr, ctx->amountStr + ctx->displayIndex, ctx->amountLength);
c0d00dd0:	23d1      	movs	r3, #209	; 0xd1
c0d00dd2:	009b      	lsls	r3, r3, #2
c0d00dd4:	18c0      	adds	r0, r0, r3
c0d00dd6:	f000 ff20 	bl	c0d01c1a <os_memmove>
            }
            UX_REDISPLAY();
c0d00dda:	f001 f929 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00dde:	f001 f92d 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00de2:	4c1c      	ldr	r4, [pc, #112]	; (c0d00e54 <ui_amount_compare_large_button+0x218>)
c0d00de4:	2000      	movs	r0, #0
c0d00de6:	60a0      	str	r0, [r4, #8]
c0d00de8:	6821      	ldr	r1, [r4, #0]
c0d00dea:	2900      	cmp	r1, #0
c0d00dec:	d024      	beq.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00dee:	69e1      	ldr	r1, [r4, #28]
c0d00df0:	4a19      	ldr	r2, [pc, #100]	; (c0d00e58 <ui_amount_compare_large_button+0x21c>)
c0d00df2:	4291      	cmp	r1, r2
c0d00df4:	d11e      	bne.n	c0d00e34 <ui_amount_compare_large_button+0x1f8>
c0d00df6:	e01f      	b.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00df8:	6861      	ldr	r1, [r4, #4]
c0d00dfa:	4288      	cmp	r0, r1
c0d00dfc:	d21c      	bcs.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00dfe:	f002 f99b 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00e02:	2800      	cmp	r0, #0
c0d00e04:	d118      	bne.n	c0d00e38 <ui_amount_compare_large_button+0x1fc>
c0d00e06:	68a0      	ldr	r0, [r4, #8]
c0d00e08:	68e1      	ldr	r1, [r4, #12]
c0d00e0a:	2538      	movs	r5, #56	; 0x38
c0d00e0c:	4368      	muls	r0, r5
c0d00e0e:	6822      	ldr	r2, [r4, #0]
c0d00e10:	1810      	adds	r0, r2, r0
c0d00e12:	2900      	cmp	r1, #0
c0d00e14:	d002      	beq.n	c0d00e1c <ui_amount_compare_large_button+0x1e0>
c0d00e16:	4788      	blx	r1
c0d00e18:	2800      	cmp	r0, #0
c0d00e1a:	d007      	beq.n	c0d00e2c <ui_amount_compare_large_button+0x1f0>
c0d00e1c:	2801      	cmp	r0, #1
c0d00e1e:	d103      	bne.n	c0d00e28 <ui_amount_compare_large_button+0x1ec>
c0d00e20:	68a0      	ldr	r0, [r4, #8]
c0d00e22:	4345      	muls	r5, r0
c0d00e24:	6820      	ldr	r0, [r4, #0]
c0d00e26:	1940      	adds	r0, r0, r5
c0d00e28:	f000 fa6c 	bl	c0d01304 <io_seproxyhal_display>
c0d00e2c:	68a0      	ldr	r0, [r4, #8]
c0d00e2e:	1c40      	adds	r0, r0, #1
c0d00e30:	60a0      	str	r0, [r4, #8]
c0d00e32:	6821      	ldr	r1, [r4, #0]
c0d00e34:	2900      	cmp	r1, #0
c0d00e36:	d1df      	bne.n	c0d00df8 <ui_amount_compare_large_button+0x1bc>
            UX_DISPLAY(ui_fromshard_approve, NULL);
            break;
    }
    // (The return value of a button handler is irrelevant; it is never
    // checked.)
    return 0;
c0d00e38:	2000      	movs	r0, #0
c0d00e3a:	bdb0      	pop	{r4, r5, r7, pc}
c0d00e3c:	40000002 	.word	0x40000002
c0d00e40:	40000001 	.word	0x40000001
c0d00e44:	80000003 	.word	0x80000003
c0d00e48:	20001930 	.word	0x20001930
c0d00e4c:	00000351 	.word	0x00000351
c0d00e50:	0000035e 	.word	0x0000035e
c0d00e54:	20001880 	.word	0x20001880
c0d00e58:	b0105044 	.word	0xb0105044
c0d00e5c:	000002ef 	.word	0x000002ef
c0d00e60:	00004964 	.word	0x00004964
c0d00e64:	0000029b 	.word	0x0000029b

c0d00e68 <ui_prepro_amount_compare>:
};



static const bagl_element_t* ui_prepro_amount_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
c0d00e68:	7841      	ldrb	r1, [r0, #1]
c0d00e6a:	2902      	cmp	r1, #2
c0d00e6c:	d006      	beq.n	c0d00e7c <ui_prepro_amount_compare+0x14>
c0d00e6e:	2901      	cmp	r1, #1
c0d00e70:	d10f      	bne.n	c0d00e92 <ui_prepro_amount_compare+0x2a>
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
c0d00e72:	4908      	ldr	r1, [pc, #32]	; (c0d00e94 <ui_prepro_amount_compare+0x2c>)
c0d00e74:	7809      	ldrb	r1, [r1, #0]
c0d00e76:	2900      	cmp	r1, #0
c0d00e78:	d00a      	beq.n	c0d00e90 <ui_prepro_amount_compare+0x28>
c0d00e7a:	e00a      	b.n	c0d00e92 <ui_prepro_amount_compare+0x2a>
        case 2:
            return (ctx->displayIndex >= ctx->amountLength-12) ? NULL : element;
c0d00e7c:	210d      	movs	r1, #13
c0d00e7e:	0189      	lsls	r1, r1, #6
c0d00e80:	4a04      	ldr	r2, [pc, #16]	; (c0d00e94 <ui_prepro_amount_compare+0x2c>)
c0d00e82:	5853      	ldr	r3, [r2, r1]
c0d00e84:	3b0c      	subs	r3, #12
c0d00e86:	7812      	ldrb	r2, [r2, #0]
c0d00e88:	2100      	movs	r1, #0
c0d00e8a:	429a      	cmp	r2, r3
c0d00e8c:	d200      	bcs.n	c0d00e90 <ui_prepro_amount_compare+0x28>
c0d00e8e:	4601      	mov	r1, r0
c0d00e90:	4608      	mov	r0, r1
        default:
            return element;
    }
}
c0d00e92:	4770      	bx	lr
c0d00e94:	20001930 	.word	0x20001930

c0d00e98 <ui_amount_compare_button>:

        UI_TEXT(0x00, 0, 12, 128, "Amount:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.partialAmountStr),
};

static unsigned int ui_amount_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d00e98:	b5b0      	push	{r4, r5, r7, lr}
    switch (button_mask) {
c0d00e9a:	4931      	ldr	r1, [pc, #196]	; (c0d00f60 <ui_amount_compare_button+0xc8>)
c0d00e9c:	4288      	cmp	r0, r1
c0d00e9e:	d009      	beq.n	c0d00eb4 <ui_amount_compare_button+0x1c>
c0d00ea0:	4930      	ldr	r1, [pc, #192]	; (c0d00f64 <ui_amount_compare_button+0xcc>)
c0d00ea2:	4288      	cmp	r0, r1
c0d00ea4:	d159      	bne.n	c0d00f5a <ui_amount_compare_button+0xc2>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
c0d00ea6:	4835      	ldr	r0, [pc, #212]	; (c0d00f7c <ui_amount_compare_button+0xe4>)
c0d00ea8:	2100      	movs	r1, #0
c0d00eaa:	f000 fa1b 	bl	c0d012e4 <io_exchange_with_code>
            // Return to the main screen.
            ui_idle();
c0d00eae:	f000 fa0f 	bl	c0d012d0 <ui_idle>
c0d00eb2:	e052      	b.n	c0d00f5a <ui_amount_compare_button+0xc2>
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            bin2dec(ctx->fromShardStr, ctx->txContent.fromShard);
c0d00eb4:	2053      	movs	r0, #83	; 0x53
c0d00eb6:	00c0      	lsls	r0, r0, #3
c0d00eb8:	4d2b      	ldr	r5, [pc, #172]	; (c0d00f68 <ui_amount_compare_button+0xd0>)
c0d00eba:	582a      	ldr	r2, [r5, r0]
c0d00ebc:	482b      	ldr	r0, [pc, #172]	; (c0d00f6c <ui_amount_compare_button+0xd4>)
c0d00ebe:	1828      	adds	r0, r5, r0
c0d00ec0:	2400      	movs	r4, #0
c0d00ec2:	4623      	mov	r3, r4
c0d00ec4:	f000 f9c7 	bl	c0d01256 <bin2dec>
            bin2dec(ctx->toShardStr, ctx->txContent.toShard);
c0d00ec8:	20a7      	movs	r0, #167	; 0xa7
c0d00eca:	0080      	lsls	r0, r0, #2
c0d00ecc:	582a      	ldr	r2, [r5, r0]
c0d00ece:	4828      	ldr	r0, [pc, #160]	; (c0d00f70 <ui_amount_compare_button+0xd8>)
c0d00ed0:	1828      	adds	r0, r5, r0
c0d00ed2:	4623      	mov	r3, r4
c0d00ed4:	f000 f9bf 	bl	c0d01256 <bin2dec>
            UX_DISPLAY(ui_fromshard_approve, NULL);
c0d00ed8:	4d26      	ldr	r5, [pc, #152]	; (c0d00f74 <ui_amount_compare_button+0xdc>)
c0d00eda:	4829      	ldr	r0, [pc, #164]	; (c0d00f80 <ui_amount_compare_button+0xe8>)
c0d00edc:	4478      	add	r0, pc
c0d00ede:	6028      	str	r0, [r5, #0]
c0d00ee0:	2005      	movs	r0, #5
c0d00ee2:	6068      	str	r0, [r5, #4]
c0d00ee4:	4827      	ldr	r0, [pc, #156]	; (c0d00f84 <ui_amount_compare_button+0xec>)
c0d00ee6:	4478      	add	r0, pc
c0d00ee8:	6128      	str	r0, [r5, #16]
c0d00eea:	60ec      	str	r4, [r5, #12]
c0d00eec:	2003      	movs	r0, #3
c0d00eee:	7628      	strb	r0, [r5, #24]
c0d00ef0:	61ec      	str	r4, [r5, #28]
c0d00ef2:	4628      	mov	r0, r5
c0d00ef4:	3018      	adds	r0, #24
c0d00ef6:	f002 f8c5 	bl	c0d03084 <os_ux>
c0d00efa:	61e8      	str	r0, [r5, #28]
c0d00efc:	f001 fd46 	bl	c0d0298c <ux_check_status_default>
c0d00f00:	f001 f896 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00f04:	f001 f89a 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00f08:	60ac      	str	r4, [r5, #8]
c0d00f0a:	6828      	ldr	r0, [r5, #0]
c0d00f0c:	2800      	cmp	r0, #0
c0d00f0e:	d024      	beq.n	c0d00f5a <ui_amount_compare_button+0xc2>
c0d00f10:	69e8      	ldr	r0, [r5, #28]
c0d00f12:	4919      	ldr	r1, [pc, #100]	; (c0d00f78 <ui_amount_compare_button+0xe0>)
c0d00f14:	4288      	cmp	r0, r1
c0d00f16:	d11e      	bne.n	c0d00f56 <ui_amount_compare_button+0xbe>
c0d00f18:	e01f      	b.n	c0d00f5a <ui_amount_compare_button+0xc2>
c0d00f1a:	6868      	ldr	r0, [r5, #4]
c0d00f1c:	4284      	cmp	r4, r0
c0d00f1e:	d21c      	bcs.n	c0d00f5a <ui_amount_compare_button+0xc2>
c0d00f20:	f002 f90a 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00f24:	2800      	cmp	r0, #0
c0d00f26:	d118      	bne.n	c0d00f5a <ui_amount_compare_button+0xc2>
c0d00f28:	68a8      	ldr	r0, [r5, #8]
c0d00f2a:	68e9      	ldr	r1, [r5, #12]
c0d00f2c:	2438      	movs	r4, #56	; 0x38
c0d00f2e:	4360      	muls	r0, r4
c0d00f30:	682a      	ldr	r2, [r5, #0]
c0d00f32:	1810      	adds	r0, r2, r0
c0d00f34:	2900      	cmp	r1, #0
c0d00f36:	d002      	beq.n	c0d00f3e <ui_amount_compare_button+0xa6>
c0d00f38:	4788      	blx	r1
c0d00f3a:	2800      	cmp	r0, #0
c0d00f3c:	d007      	beq.n	c0d00f4e <ui_amount_compare_button+0xb6>
c0d00f3e:	2801      	cmp	r0, #1
c0d00f40:	d103      	bne.n	c0d00f4a <ui_amount_compare_button+0xb2>
c0d00f42:	68a8      	ldr	r0, [r5, #8]
c0d00f44:	4344      	muls	r4, r0
c0d00f46:	6828      	ldr	r0, [r5, #0]
c0d00f48:	1900      	adds	r0, r0, r4
c0d00f4a:	f000 f9db 	bl	c0d01304 <io_seproxyhal_display>
c0d00f4e:	68a8      	ldr	r0, [r5, #8]
c0d00f50:	1c44      	adds	r4, r0, #1
c0d00f52:	60ac      	str	r4, [r5, #8]
c0d00f54:	6828      	ldr	r0, [r5, #0]
c0d00f56:	2800      	cmp	r0, #0
c0d00f58:	d1df      	bne.n	c0d00f1a <ui_amount_compare_button+0x82>
            break;
    }
    return 0;
c0d00f5a:	2000      	movs	r0, #0
c0d00f5c:	bdb0      	pop	{r4, r5, r7, pc}
c0d00f5e:	46c0      	nop			; (mov r8, r8)
c0d00f60:	80000002 	.word	0x80000002
c0d00f64:	80000001 	.word	0x80000001
c0d00f68:	20001930 	.word	0x20001930
c0d00f6c:	00000351 	.word	0x00000351
c0d00f70:	0000035e 	.word	0x0000035e
c0d00f74:	20001880 	.word	0x20001880
c0d00f78:	b0105044 	.word	0xb0105044
c0d00f7c:	00006985 	.word	0x00006985
c0d00f80:	00004768 	.word	0x00004768
c0d00f84:	0000009f 	.word	0x0000009f

c0d00f88 <ui_fromshard_approve_button>:

        UI_TEXT(0x00, 0, 12, 128, "From Shard:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.fromShardStr),
};

static unsigned int ui_fromshard_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d00f88:	b5b0      	push	{r4, r5, r7, lr}
    switch (button_mask) {
c0d00f8a:	4928      	ldr	r1, [pc, #160]	; (c0d0102c <ui_fromshard_approve_button+0xa4>)
c0d00f8c:	4288      	cmp	r0, r1
c0d00f8e:	d009      	beq.n	c0d00fa4 <ui_fromshard_approve_button+0x1c>
c0d00f90:	4927      	ldr	r1, [pc, #156]	; (c0d01030 <ui_fromshard_approve_button+0xa8>)
c0d00f92:	4288      	cmp	r0, r1
c0d00f94:	d148      	bne.n	c0d01028 <ui_fromshard_approve_button+0xa0>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
c0d00f96:	4829      	ldr	r0, [pc, #164]	; (c0d0103c <ui_fromshard_approve_button+0xb4>)
c0d00f98:	2100      	movs	r1, #0
c0d00f9a:	f000 f9a3 	bl	c0d012e4 <io_exchange_with_code>
            // Return to the main screen.
            ui_idle();
c0d00f9e:	f000 f997 	bl	c0d012d0 <ui_idle>
c0d00fa2:	e041      	b.n	c0d01028 <ui_fromshard_approve_button+0xa0>
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            UX_DISPLAY(ui_toshard_approve, NULL);
c0d00fa4:	4c23      	ldr	r4, [pc, #140]	; (c0d01034 <ui_fromshard_approve_button+0xac>)
c0d00fa6:	4826      	ldr	r0, [pc, #152]	; (c0d01040 <ui_fromshard_approve_button+0xb8>)
c0d00fa8:	4478      	add	r0, pc
c0d00faa:	6020      	str	r0, [r4, #0]
c0d00fac:	2005      	movs	r0, #5
c0d00fae:	6060      	str	r0, [r4, #4]
c0d00fb0:	4824      	ldr	r0, [pc, #144]	; (c0d01044 <ui_fromshard_approve_button+0xbc>)
c0d00fb2:	4478      	add	r0, pc
c0d00fb4:	6120      	str	r0, [r4, #16]
c0d00fb6:	2500      	movs	r5, #0
c0d00fb8:	60e5      	str	r5, [r4, #12]
c0d00fba:	2003      	movs	r0, #3
c0d00fbc:	7620      	strb	r0, [r4, #24]
c0d00fbe:	61e5      	str	r5, [r4, #28]
c0d00fc0:	4620      	mov	r0, r4
c0d00fc2:	3018      	adds	r0, #24
c0d00fc4:	f002 f85e 	bl	c0d03084 <os_ux>
c0d00fc8:	61e0      	str	r0, [r4, #28]
c0d00fca:	f001 fcdf 	bl	c0d0298c <ux_check_status_default>
c0d00fce:	f001 f82f 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d00fd2:	f001 f833 	bl	c0d0203c <io_seproxyhal_init_button>
c0d00fd6:	60a5      	str	r5, [r4, #8]
c0d00fd8:	6820      	ldr	r0, [r4, #0]
c0d00fda:	2800      	cmp	r0, #0
c0d00fdc:	d024      	beq.n	c0d01028 <ui_fromshard_approve_button+0xa0>
c0d00fde:	69e0      	ldr	r0, [r4, #28]
c0d00fe0:	4915      	ldr	r1, [pc, #84]	; (c0d01038 <ui_fromshard_approve_button+0xb0>)
c0d00fe2:	4288      	cmp	r0, r1
c0d00fe4:	d11e      	bne.n	c0d01024 <ui_fromshard_approve_button+0x9c>
c0d00fe6:	e01f      	b.n	c0d01028 <ui_fromshard_approve_button+0xa0>
c0d00fe8:	6860      	ldr	r0, [r4, #4]
c0d00fea:	4285      	cmp	r5, r0
c0d00fec:	d21c      	bcs.n	c0d01028 <ui_fromshard_approve_button+0xa0>
c0d00fee:	f002 f8a3 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d00ff2:	2800      	cmp	r0, #0
c0d00ff4:	d118      	bne.n	c0d01028 <ui_fromshard_approve_button+0xa0>
c0d00ff6:	68a0      	ldr	r0, [r4, #8]
c0d00ff8:	68e1      	ldr	r1, [r4, #12]
c0d00ffa:	2538      	movs	r5, #56	; 0x38
c0d00ffc:	4368      	muls	r0, r5
c0d00ffe:	6822      	ldr	r2, [r4, #0]
c0d01000:	1810      	adds	r0, r2, r0
c0d01002:	2900      	cmp	r1, #0
c0d01004:	d002      	beq.n	c0d0100c <ui_fromshard_approve_button+0x84>
c0d01006:	4788      	blx	r1
c0d01008:	2800      	cmp	r0, #0
c0d0100a:	d007      	beq.n	c0d0101c <ui_fromshard_approve_button+0x94>
c0d0100c:	2801      	cmp	r0, #1
c0d0100e:	d103      	bne.n	c0d01018 <ui_fromshard_approve_button+0x90>
c0d01010:	68a0      	ldr	r0, [r4, #8]
c0d01012:	4345      	muls	r5, r0
c0d01014:	6820      	ldr	r0, [r4, #0]
c0d01016:	1940      	adds	r0, r0, r5
c0d01018:	f000 f974 	bl	c0d01304 <io_seproxyhal_display>
c0d0101c:	68a0      	ldr	r0, [r4, #8]
c0d0101e:	1c45      	adds	r5, r0, #1
c0d01020:	60a5      	str	r5, [r4, #8]
c0d01022:	6820      	ldr	r0, [r4, #0]
c0d01024:	2800      	cmp	r0, #0
c0d01026:	d1df      	bne.n	c0d00fe8 <ui_fromshard_approve_button+0x60>
            break;
    }
    return 0;
c0d01028:	2000      	movs	r0, #0
c0d0102a:	bdb0      	pop	{r4, r5, r7, pc}
c0d0102c:	80000002 	.word	0x80000002
c0d01030:	80000001 	.word	0x80000001
c0d01034:	20001880 	.word	0x20001880
c0d01038:	b0105044 	.word	0xb0105044
c0d0103c:	00006985 	.word	0x00006985
c0d01040:	000047b4 	.word	0x000047b4
c0d01044:	00000093 	.word	0x00000093

c0d01048 <ui_toshard_approve_button>:

        UI_TEXT(0x00, 0, 12, 128, "To Shard:"),
        UI_TEXT(0x00, 0, 26, 128, global.signTxnContext.toShardStr),
};

static unsigned int ui_toshard_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d01048:	b570      	push	{r4, r5, r6, lr}
c0d0104a:	b0ec      	sub	sp, #432	; 0x1b0
    cx_sha3_t sha3;

    switch (button_mask) {
c0d0104c:	4915      	ldr	r1, [pc, #84]	; (c0d010a4 <ui_toshard_approve_button+0x5c>)
c0d0104e:	4288      	cmp	r0, r1
c0d01050:	d005      	beq.n	c0d0105e <ui_toshard_approve_button+0x16>
c0d01052:	4915      	ldr	r1, [pc, #84]	; (c0d010a8 <ui_toshard_approve_button+0x60>)
c0d01054:	4288      	cmp	r0, r1
c0d01056:	d121      	bne.n	c0d0109c <ui_toshard_approve_button+0x54>
        case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
            io_exchange_with_code(SW_USER_REJECTED, 0);
c0d01058:	4817      	ldr	r0, [pc, #92]	; (c0d010b8 <ui_toshard_approve_button+0x70>)
c0d0105a:	2100      	movs	r1, #0
c0d0105c:	e01a      	b.n	c0d01094 <ui_toshard_approve_button+0x4c>
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            cx_keccak_init(&sha3, 256);
            cx_hash((cx_hash_t *)&sha3, CX_LAST, ctx->buf, ctx->length, ctx->hash, 32);
c0d0105e:	2401      	movs	r4, #1
            // Return to the main screen.
            ui_idle();
            break;

        case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
            cx_keccak_init(&sha3, 256);
c0d01060:	0221      	lsls	r1, r4, #8
c0d01062:	ad02      	add	r5, sp, #8
c0d01064:	4628      	mov	r0, r5
c0d01066:	f001 ff5f 	bl	c0d02f28 <cx_keccak_init>
            cx_hash((cx_hash_t *)&sha3, CX_LAST, ctx->buf, ctx->length, ctx->hash, 32);
c0d0106a:	0260      	lsls	r0, r4, #9
c0d0106c:	490f      	ldr	r1, [pc, #60]	; (c0d010ac <ui_toshard_approve_button+0x64>)
c0d0106e:	5a0b      	ldrh	r3, [r1, r0]
c0d01070:	2020      	movs	r0, #32
c0d01072:	466a      	mov	r2, sp
c0d01074:	6050      	str	r0, [r2, #4]
c0d01076:	480e      	ldr	r0, [pc, #56]	; (c0d010b0 <ui_toshard_approve_button+0x68>)
c0d01078:	180e      	adds	r6, r1, r0
c0d0107a:	6016      	str	r6, [r2, #0]
c0d0107c:	1c4a      	adds	r2, r1, #1
c0d0107e:	4628      	mov	r0, r5
c0d01080:	4621      	mov	r1, r4
c0d01082:	f001 ff35 	bl	c0d02ef0 <cx_hash>
            //debug the hash
            //os_memmove(G_io_apdu_buffer, ctx->hash, 32);
            //io_exchange_with_code(SW_OK, 32);
            deriveAndSign(G_io_apdu_buffer, ctx->hash);
c0d01086:	480b      	ldr	r0, [pc, #44]	; (c0d010b4 <ui_toshard_approve_button+0x6c>)
c0d01088:	4631      	mov	r1, r6
c0d0108a:	f000 f889 	bl	c0d011a0 <deriveAndSign>
            io_exchange_with_code(SW_OK, 65);
c0d0108e:	2009      	movs	r0, #9
c0d01090:	0300      	lsls	r0, r0, #12
c0d01092:	2141      	movs	r1, #65	; 0x41
c0d01094:	f000 f926 	bl	c0d012e4 <io_exchange_with_code>
c0d01098:	f000 f91a 	bl	c0d012d0 <ui_idle>

            // Return to the main screen.
            ui_idle();
            break;
    }
    return 0;
c0d0109c:	2000      	movs	r0, #0
c0d0109e:	b06c      	add	sp, #432	; 0x1b0
c0d010a0:	bd70      	pop	{r4, r5, r6, pc}
c0d010a2:	46c0      	nop			; (mov r8, r8)
c0d010a4:	80000002 	.word	0x80000002
c0d010a8:	80000001 	.word	0x80000001
c0d010ac:	20001930 	.word	0x20001930
c0d010b0:	0000036b 	.word	0x0000036b
c0d010b4:	20001d70 	.word	0x20001d70
c0d010b8:	00006985 	.word	0x00006985

c0d010bc <handleGetVersion>:
#include "harmony.h"
#include "ux.h"

// handleGetVersion is the entry point for the getVersion command. It
// unconditionally sends the app version.
void handleGetVersion(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
c0d010bc:	b580      	push	{r7, lr}
	G_io_apdu_buffer[0] = APPVERSION[0] - '1';
c0d010be:	4805      	ldr	r0, [pc, #20]	; (c0d010d4 <handleGetVersion+0x18>)
c0d010c0:	2100      	movs	r1, #0
c0d010c2:	7001      	strb	r1, [r0, #0]
	G_io_apdu_buffer[1] = APPVERSION[2] - '0';
c0d010c4:	7041      	strb	r1, [r0, #1]
	G_io_apdu_buffer[2] = APPVERSION[4] - '0';
c0d010c6:	7081      	strb	r1, [r0, #2]
	io_exchange_with_code(SW_OK, 3);
c0d010c8:	2009      	movs	r0, #9
c0d010ca:	0300      	lsls	r0, r0, #12
c0d010cc:	2103      	movs	r1, #3
c0d010ce:	f000 f909 	bl	c0d012e4 <io_exchange_with_code>
}
c0d010d2:	bd80      	pop	{r7, pc}
c0d010d4:	20001d70 	.word	0x20001d70

c0d010d8 <deriveOneKeypair>:
#include <cx.h>
#include "harmony.h"
#include "bech32.h"


void deriveOneKeypair(cx_ecfp_private_key_t *privateKey, cx_ecfp_public_key_t *publicKey) {
c0d010d8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d010da:	b099      	sub	sp, #100	; 0x64
c0d010dc:	460d      	mov	r5, r1
c0d010de:	4604      	mov	r4, r0
    // bip32 path for ONE is 44'/1023'/0'/0/0
    uint32_t bip32Path[] = {44 | 0x80000000, 1023 | 0x80000000,  0x80000000, 0, 0};
c0d010e0:	a01f      	add	r0, pc, #124	; (adr r0, c0d01160 <deriveOneKeypair+0x88>)
c0d010e2:	a914      	add	r1, sp, #80	; 0x50
c0d010e4:	c80c      	ldmia	r0!, {r2, r3}
c0d010e6:	c10c      	stmia	r1!, {r2, r3}
c0d010e8:	c84c      	ldmia	r0!, {r2, r3, r6}
c0d010ea:	c14c      	stmia	r1!, {r2, r3, r6}
	uint8_t keySeed[32];
	cx_ecfp_private_key_t pk;

    if (privateKey || publicKey) {
c0d010ec:	2c00      	cmp	r4, #0
c0d010ee:	d101      	bne.n	c0d010f4 <deriveOneKeypair+0x1c>
c0d010f0:	2d00      	cmp	r5, #0
c0d010f2:	d010      	beq.n	c0d01116 <deriveOneKeypair+0x3e>
        os_perso_derive_node_bip32(CX_CURVE_256K1, bip32Path, 5, keySeed, NULL);
c0d010f4:	2000      	movs	r0, #0
c0d010f6:	4669      	mov	r1, sp
c0d010f8:	6008      	str	r0, [r1, #0]
c0d010fa:	2621      	movs	r6, #33	; 0x21
c0d010fc:	a914      	add	r1, sp, #80	; 0x50
c0d010fe:	2205      	movs	r2, #5
c0d01100:	af0c      	add	r7, sp, #48	; 0x30
c0d01102:	4630      	mov	r0, r6
c0d01104:	463b      	mov	r3, r7
c0d01106:	f001 ff8f 	bl	c0d03028 <os_perso_derive_node_bip32>
        cx_ecfp_init_private_key(CX_CURVE_256K1, keySeed, 32, &pk);
c0d0110a:	2220      	movs	r2, #32
c0d0110c:	ab02      	add	r3, sp, #8
c0d0110e:	4630      	mov	r0, r6
c0d01110:	4639      	mov	r1, r7
c0d01112:	f001 ff39 	bl	c0d02f88 <cx_ecfp_init_private_key>
    }

    if (publicKey) {
c0d01116:	2d00      	cmp	r5, #0
c0d01118:	d00c      	beq.n	c0d01134 <deriveOneKeypair+0x5c>
c0d0111a:	2621      	movs	r6, #33	; 0x21
        cx_ecfp_init_public_key(CX_CURVE_256K1, NULL, 0, publicKey);
c0d0111c:	2100      	movs	r1, #0
c0d0111e:	4630      	mov	r0, r6
c0d01120:	460a      	mov	r2, r1
c0d01122:	462b      	mov	r3, r5
c0d01124:	f001 ff18 	bl	c0d02f58 <cx_ecfp_init_public_key>
c0d01128:	aa02      	add	r2, sp, #8
        cx_ecfp_generate_pair(CX_CURVE_256K1, publicKey, &pk, 1);
c0d0112a:	2301      	movs	r3, #1
c0d0112c:	4630      	mov	r0, r6
c0d0112e:	4629      	mov	r1, r5
c0d01130:	f001 ff42 	bl	c0d02fb8 <cx_ecfp_generate_pair>
	}
	if (privateKey) {
c0d01134:	2c00      	cmp	r4, #0
c0d01136:	d006      	beq.n	c0d01146 <deriveOneKeypair+0x6e>
c0d01138:	a802      	add	r0, sp, #8
		*privateKey = pk;
c0d0113a:	c80e      	ldmia	r0!, {r1, r2, r3}
c0d0113c:	c40e      	stmia	r4!, {r1, r2, r3}
c0d0113e:	c80e      	ldmia	r0!, {r1, r2, r3}
c0d01140:	c40e      	stmia	r4!, {r1, r2, r3}
c0d01142:	c82e      	ldmia	r0!, {r1, r2, r3, r5}
c0d01144:	c42e      	stmia	r4!, {r1, r2, r3, r5}
c0d01146:	a80c      	add	r0, sp, #48	; 0x30
c0d01148:	2400      	movs	r4, #0
	}
	os_memset(keySeed, 0, sizeof(keySeed));
c0d0114a:	2220      	movs	r2, #32
c0d0114c:	4621      	mov	r1, r4
c0d0114e:	f000 fd5b 	bl	c0d01c08 <os_memset>
c0d01152:	a802      	add	r0, sp, #8
	os_memset(&pk, 0, sizeof(pk));
c0d01154:	2228      	movs	r2, #40	; 0x28
c0d01156:	4621      	mov	r1, r4
c0d01158:	f000 fd56 	bl	c0d01c08 <os_memset>
}
c0d0115c:	b019      	add	sp, #100	; 0x64
c0d0115e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01160:	8000002c 	.word	0x8000002c
c0d01164:	800003ff 	.word	0x800003ff
c0d01168:	80000000 	.word	0x80000000
	...

c0d01174 <convert_signature_to_RSV>:
void extractPubkeyBytes(unsigned char *dst, cx_ecfp_public_key_t *publicKey) {
    os_memmove(dst, publicKey->W, 65);
}


void convert_signature_to_RSV(const unsigned char *tlv_signature, unsigned char *dst) {
c0d01174:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01176:	b081      	sub	sp, #4
c0d01178:	460c      	mov	r4, r1
    int r_size = tlv_signature[3];
c0d0117a:	78c1      	ldrb	r1, [r0, #3]
c0d0117c:	1846      	adds	r6, r0, r1
    int s_size = tlv_signature[3 + r_size + 2];
c0d0117e:	7977      	ldrb	r7, [r6, #5]
    int s_offset = s_size - 32;

    const int offset_before_R = 4;
    const int offset_before_S = 2;

    os_memmove(dst, tlv_signature + offset_before_R + r_offset, 32); // skip first bytes and store the `R` part
c0d01180:	4631      	mov	r1, r6
c0d01182:	391c      	subs	r1, #28
c0d01184:	2520      	movs	r5, #32
c0d01186:	4620      	mov	r0, r4
c0d01188:	462a      	mov	r2, r5
c0d0118a:	f000 fd46 	bl	c0d01c1a <os_memmove>
c0d0118e:	19f1      	adds	r1, r6, r7
    os_memmove(dst + 32, tlv_signature + offset_before_R + 32 + offset_before_S + r_offset + s_offset,
c0d01190:	391a      	subs	r1, #26
c0d01192:	3420      	adds	r4, #32
c0d01194:	4620      	mov	r0, r4
c0d01196:	462a      	mov	r2, r5
c0d01198:	f000 fd3f 	bl	c0d01c1a <os_memmove>
               32); // skip unused bytes and store the `S` part
}
c0d0119c:	b001      	add	sp, #4
c0d0119e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d011a0 <deriveAndSign>:


void deriveAndSign(uint8_t *dst, const uint8_t *hash) {
c0d011a0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d011a2:	b0a5      	sub	sp, #148	; 0x94
c0d011a4:	9104      	str	r1, [sp, #16]
c0d011a6:	9005      	str	r0, [sp, #20]
c0d011a8:	2500      	movs	r5, #0
    unsigned char tlv_sig[80];
    unsigned int info = 0;
c0d011aa:	9510      	str	r5, [sp, #64]	; 0x40
c0d011ac:	af06      	add	r7, sp, #24
    unsigned int recovery_id = 0;

	cx_ecfp_private_key_t privateKey;

	//generate private key
	deriveOneKeypair(&privateKey, NULL);
c0d011ae:	4638      	mov	r0, r7
c0d011b0:	4629      	mov	r1, r5
c0d011b2:	f7ff ff91 	bl	c0d010d8 <deriveOneKeypair>
c0d011b6:	a810      	add	r0, sp, #64	; 0x40

    //uint8_t data[32] = {1};
    cx_ecdsa_sign(&privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, hash, 32, tlv_sig, sizeof(tlv_sig),  &info);
c0d011b8:	4669      	mov	r1, sp
c0d011ba:	60c8      	str	r0, [r1, #12]
c0d011bc:	2050      	movs	r0, #80	; 0x50
c0d011be:	6088      	str	r0, [r1, #8]
c0d011c0:	ae11      	add	r6, sp, #68	; 0x44
c0d011c2:	604e      	str	r6, [r1, #4]
c0d011c4:	2020      	movs	r0, #32
c0d011c6:	6008      	str	r0, [r1, #0]
c0d011c8:	490b      	ldr	r1, [pc, #44]	; (c0d011f8 <deriveAndSign+0x58>)
c0d011ca:	2403      	movs	r4, #3
c0d011cc:	4638      	mov	r0, r7
c0d011ce:	4622      	mov	r2, r4
c0d011d0:	9b04      	ldr	r3, [sp, #16]
c0d011d2:	f001 ff09 	bl	c0d02fe8 <cx_ecdsa_sign>

	//clear private key ASAP
    os_memset(&privateKey, 0, sizeof(privateKey));
c0d011d6:	2228      	movs	r2, #40	; 0x28
c0d011d8:	4638      	mov	r0, r7
c0d011da:	4629      	mov	r1, r5
c0d011dc:	f000 fd14 	bl	c0d01c08 <os_memset>

    if (info & CX_ECCINFO_PARITY_ODD)
c0d011e0:	9d10      	ldr	r5, [sp, #64]	; 0x40
        recovery_id++;

    if (info & CX_ECCINFO_xGTn)
        recovery_id += 2;

    convert_signature_to_RSV(tlv_sig, dst);
c0d011e2:	4630      	mov	r0, r6
c0d011e4:	9e05      	ldr	r6, [sp, #20]
c0d011e6:	4631      	mov	r1, r6
c0d011e8:	f7ff ffc4 	bl	c0d01174 <convert_signature_to_RSV>
    os_memset(&privateKey, 0, sizeof(privateKey));

    if (info & CX_ECCINFO_PARITY_ODD)
        recovery_id++;

    if (info & CX_ECCINFO_xGTn)
c0d011ec:	4025      	ands	r5, r4
        recovery_id += 2;

    convert_signature_to_RSV(tlv_sig, dst);

    dst[64] = recovery_id;
c0d011ee:	2040      	movs	r0, #64	; 0x40
c0d011f0:	5435      	strb	r5, [r6, r0]
}
c0d011f2:	b025      	add	sp, #148	; 0x94
c0d011f4:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d011f6:	46c0      	nop			; (mov r8, r8)
c0d011f8:	00000601 	.word	0x00000601

c0d011fc <getEthAddressFromKey>:
		dst[2*i+1] = hex[(data[i]>>0) & 0x0F];
	}
	dst[2*inlen] = '\0';
}

void getEthAddressFromKey(cx_ecfp_public_key_t *publicKey, uint8_t *out) {
c0d011fc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d011fe:	b0f7      	sub	sp, #476	; 0x1dc
c0d01200:	9103      	str	r1, [sp, #12]
c0d01202:	4605      	mov	r5, r0
c0d01204:	2601      	movs	r6, #1
    cx_sha3_t sha3Context;
    uint8_t hashAddress[32];
    cx_keccak_init(&sha3Context, 256);
c0d01206:	0231      	lsls	r1, r6, #8
c0d01208:	af0c      	add	r7, sp, #48	; 0x30
c0d0120a:	4638      	mov	r0, r7
c0d0120c:	f001 fe8c 	bl	c0d02f28 <cx_keccak_init>
    cx_hash((cx_hash_t*)&sha3Context, CX_LAST, publicKey->W + 1, 64, hashAddress, 32);
c0d01210:	2020      	movs	r0, #32
c0d01212:	4669      	mov	r1, sp
c0d01214:	6048      	str	r0, [r1, #4]
c0d01216:	ac04      	add	r4, sp, #16
c0d01218:	600c      	str	r4, [r1, #0]
c0d0121a:	3509      	adds	r5, #9
c0d0121c:	2340      	movs	r3, #64	; 0x40
c0d0121e:	4638      	mov	r0, r7
c0d01220:	4631      	mov	r1, r6
c0d01222:	462a      	mov	r2, r5
c0d01224:	f001 fe64 	bl	c0d02ef0 <cx_hash>
    os_memmove(out, hashAddress + 12, 20);
c0d01228:	340c      	adds	r4, #12
c0d0122a:	2214      	movs	r2, #20
c0d0122c:	9803      	ldr	r0, [sp, #12]
c0d0122e:	4621      	mov	r1, r4
c0d01230:	f000 fcf3 	bl	c0d01c1a <os_memmove>
}
c0d01234:	b077      	add	sp, #476	; 0x1dc
c0d01236:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01238 <pubkeyToOneAddress>:

void pubkeyToOneAddress(uint8_t *dst, cx_ecfp_public_key_t *publicKey) {
c0d01238:	b5b0      	push	{r4, r5, r7, lr}
c0d0123a:	b086      	sub	sp, #24
c0d0123c:	4604      	mov	r4, r0
c0d0123e:	ad01      	add	r5, sp, #4
    unsigned char etherAddr[20];
    getEthAddressFromKey(publicKey, etherAddr);
c0d01240:	4608      	mov	r0, r1
c0d01242:	4629      	mov	r1, r5
c0d01244:	f7ff ffda 	bl	c0d011fc <getEthAddressFromKey>
    bech32_get_address((char *)dst, etherAddr, 20);
c0d01248:	2214      	movs	r2, #20
c0d0124a:	4620      	mov	r0, r4
c0d0124c:	4629      	mov	r1, r5
c0d0124e:	f7fe ff7d 	bl	c0d0014c <bech32_get_address>
}
c0d01252:	b006      	add	sp, #24
c0d01254:	bdb0      	pop	{r4, r5, r7, pc}

c0d01256 <bin2dec>:

int bin2dec(uint8_t *dst, uint64_t n) {
c0d01256:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01258:	b083      	sub	sp, #12
	if (n == 0) {
c0d0125a:	4611      	mov	r1, r2
c0d0125c:	4319      	orrs	r1, r3
c0d0125e:	2900      	cmp	r1, #0
c0d01260:	d02e      	beq.n	c0d012c0 <bin2dec+0x6a>
c0d01262:	9002      	str	r0, [sp, #8]
c0d01264:	2400      	movs	r4, #0
c0d01266:	9200      	str	r2, [sp, #0]
c0d01268:	4617      	mov	r7, r2
c0d0126a:	9301      	str	r3, [sp, #4]
c0d0126c:	461e      	mov	r6, r3
c0d0126e:	4625      	mov	r5, r4
		dst[1] = '\0';
		return 1;
	}
	// determine final length
	int len = 0;
	for (uint64_t nn = n; nn != 0; nn /= 10) {
c0d01270:	220a      	movs	r2, #10
c0d01272:	4638      	mov	r0, r7
c0d01274:	4631      	mov	r1, r6
c0d01276:	4623      	mov	r3, r4
c0d01278:	f003 fcfc 	bl	c0d04c74 <__aeabi_uldivmod>
c0d0127c:	2201      	movs	r2, #1
c0d0127e:	2f0a      	cmp	r7, #10
c0d01280:	d300      	bcc.n	c0d01284 <bin2dec+0x2e>
c0d01282:	4622      	mov	r2, r4
c0d01284:	2e00      	cmp	r6, #0
c0d01286:	d000      	beq.n	c0d0128a <bin2dec+0x34>
c0d01288:	4622      	mov	r2, r4
		len++;
c0d0128a:	1c6d      	adds	r5, r5, #1
		dst[1] = '\0';
		return 1;
	}
	// determine final length
	int len = 0;
	for (uint64_t nn = n; nn != 0; nn /= 10) {
c0d0128c:	2a00      	cmp	r2, #0
c0d0128e:	4607      	mov	r7, r0
c0d01290:	460e      	mov	r6, r1
c0d01292:	d0ed      	beq.n	c0d01270 <bin2dec+0x1a>
		len++;
	}
	// write digits in big-endian order
	for (int i = len-1; i >= 0; i--) {
c0d01294:	1e68      	subs	r0, r5, #1
c0d01296:	2800      	cmp	r0, #0
c0d01298:	db10      	blt.n	c0d012bc <bin2dec+0x66>
		dst[i] = (n % 10) + '0';
c0d0129a:	9802      	ldr	r0, [sp, #8]
c0d0129c:	1e44      	subs	r4, r0, #1
c0d0129e:	462e      	mov	r6, r5
c0d012a0:	9901      	ldr	r1, [sp, #4]
c0d012a2:	9f00      	ldr	r7, [sp, #0]
c0d012a4:	220a      	movs	r2, #10
c0d012a6:	2300      	movs	r3, #0
c0d012a8:	4638      	mov	r0, r7
c0d012aa:	f003 fce3 	bl	c0d04c74 <__aeabi_uldivmod>
c0d012ae:	4607      	mov	r7, r0
c0d012b0:	2030      	movs	r0, #48	; 0x30
c0d012b2:	4310      	orrs	r0, r2
c0d012b4:	55a0      	strb	r0, [r4, r6]
	int len = 0;
	for (uint64_t nn = n; nn != 0; nn /= 10) {
		len++;
	}
	// write digits in big-endian order
	for (int i = len-1; i >= 0; i--) {
c0d012b6:	1e76      	subs	r6, r6, #1
c0d012b8:	2e00      	cmp	r6, #0
c0d012ba:	dcf3      	bgt.n	c0d012a4 <bin2dec+0x4e>
c0d012bc:	9802      	ldr	r0, [sp, #8]
c0d012be:	e002      	b.n	c0d012c6 <bin2dec+0x70>
    bech32_get_address((char *)dst, etherAddr, 20);
}

int bin2dec(uint8_t *dst, uint64_t n) {
	if (n == 0) {
		dst[0] = '0';
c0d012c0:	2130      	movs	r1, #48	; 0x30
c0d012c2:	7001      	strb	r1, [r0, #0]
c0d012c4:	2501      	movs	r5, #1
c0d012c6:	2100      	movs	r1, #0
c0d012c8:	5541      	strb	r1, [r0, r5]
		dst[i] = (n % 10) + '0';
		n /= 10;
	}
	dst[len] = '\0';
	return len;
c0d012ca:	4628      	mov	r0, r5
c0d012cc:	b003      	add	sp, #12
c0d012ce:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d012d0 <ui_idle>:
	{NULL, os_sched_exit, 0, &C_icon_dashboard, "Quit app", NULL, 50, 29},
	UX_MENU_END,
};


void ui_idle(void) {
c0d012d0:	b580      	push	{r7, lr}
	UX_MENU_DISPLAY(0, menu_main, NULL);
c0d012d2:	4903      	ldr	r1, [pc, #12]	; (c0d012e0 <ui_idle+0x10>)
c0d012d4:	4479      	add	r1, pc
c0d012d6:	2000      	movs	r0, #0
c0d012d8:	4602      	mov	r2, r0
c0d012da:	f001 fac9 	bl	c0d02870 <ux_menu_display>
}
c0d012de:	bd80      	pop	{r7, pc}
c0d012e0:	00004610 	.word	0x00004610

c0d012e4 <io_exchange_with_code>:

// io_exchange_with_code is a helper function for sending response APDUs from
// button handlers. Note that the IO_RETURN_AFTER_TX flag is set. 'tx' is the
// conventional name for the size of the response APDU, i.e. the write-offset
// within G_io_apdu_buffer.
void io_exchange_with_code(uint16_t code, uint16_t tx) {
c0d012e4:	b580      	push	{r7, lr}
	G_io_apdu_buffer[tx++] = code >> 8;
c0d012e6:	0a02      	lsrs	r2, r0, #8
c0d012e8:	4b05      	ldr	r3, [pc, #20]	; (c0d01300 <io_exchange_with_code+0x1c>)
c0d012ea:	545a      	strb	r2, [r3, r1]
c0d012ec:	1c4a      	adds	r2, r1, #1
	G_io_apdu_buffer[tx++] = code & 0xFF;
c0d012ee:	b292      	uxth	r2, r2
c0d012f0:	5498      	strb	r0, [r3, r2]
c0d012f2:	1c88      	adds	r0, r1, #2
	io_exchange(CHANNEL_APDU | IO_RETURN_AFTER_TX, tx);
c0d012f4:	b281      	uxth	r1, r0
c0d012f6:	2020      	movs	r0, #32
c0d012f8:	f001 f88e 	bl	c0d02418 <io_exchange>
}
c0d012fc:	bd80      	pop	{r7, pc}
c0d012fe:	46c0      	nop			; (mov r8, r8)
c0d01300:	20001d70 	.word	0x20001d70

c0d01304 <io_seproxyhal_display>:
		END_TRY;
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
c0d01304:	b580      	push	{r7, lr}
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d01306:	f000 ffe7 	bl	c0d022d8 <io_seproxyhal_display_default>
}
c0d0130a:	bd80      	pop	{r7, pc}

c0d0130c <io_event>:

unsigned char G_io_seproxyhal_spi_buffer[IO_SEPROXYHAL_BUFFER_SIZE_B];

unsigned char io_event(unsigned char channel) {
c0d0130c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0130e:	b085      	sub	sp, #20
	// can't have more than one tag in the reply, not supported yet.
	switch (G_io_seproxyhal_spi_buffer[0]) {
c0d01310:	4df5      	ldr	r5, [pc, #980]	; (c0d016e8 <io_event+0x3dc>)
c0d01312:	7828      	ldrb	r0, [r5, #0]
c0d01314:	4ef5      	ldr	r6, [pc, #980]	; (c0d016ec <io_event+0x3e0>)
c0d01316:	280c      	cmp	r0, #12
c0d01318:	dd2d      	ble.n	c0d01376 <io_event+0x6a>
c0d0131a:	280d      	cmp	r0, #13
c0d0131c:	d07b      	beq.n	c0d01416 <io_event+0x10a>
c0d0131e:	280e      	cmp	r0, #14
c0d01320:	d100      	bne.n	c0d01324 <io_event+0x18>
c0d01322:	e0b8      	b.n	c0d01496 <io_event+0x18a>
c0d01324:	2815      	cmp	r0, #21
c0d01326:	d000      	beq.n	c0d0132a <io_event+0x1e>
c0d01328:	e11d      	b.n	c0d01566 <io_event+0x25a>
	case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
		UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
		break;

	case SEPROXYHAL_TAG_STATUS_EVENT:
		if (G_io_apdu_media == IO_APDU_MEDIA_USB_HID &&
c0d0132a:	48f1      	ldr	r0, [pc, #964]	; (c0d016f0 <io_event+0x3e4>)
c0d0132c:	7800      	ldrb	r0, [r0, #0]
c0d0132e:	2801      	cmp	r0, #1
c0d01330:	d103      	bne.n	c0d0133a <io_event+0x2e>
			!(U4BE(G_io_seproxyhal_spi_buffer, 3) &
c0d01332:	79a8      	ldrb	r0, [r5, #6]
	case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
		UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
		break;

	case SEPROXYHAL_TAG_STATUS_EVENT:
		if (G_io_apdu_media == IO_APDU_MEDIA_USB_HID &&
c0d01334:	0700      	lsls	r0, r0, #28
c0d01336:	d400      	bmi.n	c0d0133a <io_event+0x2e>
c0d01338:	e2d9      	b.n	c0d018ee <io_event+0x5e2>
			!(U4BE(G_io_seproxyhal_spi_buffer, 3) &
			  SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
			THROW(EXCEPTION_IO_RESET);
		}
		UX_DEFAULT_EVENT();
c0d0133a:	4cee      	ldr	r4, [pc, #952]	; (c0d016f4 <io_event+0x3e8>)
c0d0133c:	2001      	movs	r0, #1
c0d0133e:	7620      	strb	r0, [r4, #24]
c0d01340:	2500      	movs	r5, #0
c0d01342:	61e5      	str	r5, [r4, #28]
c0d01344:	4620      	mov	r0, r4
c0d01346:	3018      	adds	r0, #24
c0d01348:	f001 fe9c 	bl	c0d03084 <os_ux>
c0d0134c:	61e0      	str	r0, [r4, #28]
c0d0134e:	f001 fb1d 	bl	c0d0298c <ux_check_status_default>
c0d01352:	69e0      	ldr	r0, [r4, #28]
c0d01354:	42b0      	cmp	r0, r6
c0d01356:	d000      	beq.n	c0d0135a <io_event+0x4e>
c0d01358:	e1fc      	b.n	c0d01754 <io_event+0x448>
c0d0135a:	f000 fe69 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d0135e:	f000 fe6d 	bl	c0d0203c <io_seproxyhal_init_button>
c0d01362:	60a5      	str	r5, [r4, #8]
c0d01364:	6820      	ldr	r0, [r4, #0]
c0d01366:	2800      	cmp	r0, #0
c0d01368:	d100      	bne.n	c0d0136c <io_event+0x60>
c0d0136a:	e2b7      	b.n	c0d018dc <io_event+0x5d0>
c0d0136c:	69e0      	ldr	r0, [r4, #28]
c0d0136e:	49f8      	ldr	r1, [pc, #992]	; (c0d01750 <io_event+0x444>)
c0d01370:	4288      	cmp	r0, r1
c0d01372:	d14d      	bne.n	c0d01410 <io_event+0x104>
c0d01374:	e2b2      	b.n	c0d018dc <io_event+0x5d0>
c0d01376:	2805      	cmp	r0, #5
c0d01378:	d100      	bne.n	c0d0137c <io_event+0x70>
c0d0137a:	e0cd      	b.n	c0d01518 <io_event+0x20c>
c0d0137c:	280c      	cmp	r0, #12
c0d0137e:	d000      	beq.n	c0d01382 <io_event+0x76>
c0d01380:	e0f1      	b.n	c0d01566 <io_event+0x25a>

unsigned char io_event(unsigned char channel) {
	// can't have more than one tag in the reply, not supported yet.
	switch (G_io_seproxyhal_spi_buffer[0]) {
	case SEPROXYHAL_TAG_FINGER_EVENT:
		UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d01382:	4cf2      	ldr	r4, [pc, #968]	; (c0d0174c <io_event+0x440>)
c0d01384:	2001      	movs	r0, #1
c0d01386:	7620      	strb	r0, [r4, #24]
c0d01388:	2600      	movs	r6, #0
c0d0138a:	61e6      	str	r6, [r4, #28]
c0d0138c:	4620      	mov	r0, r4
c0d0138e:	3018      	adds	r0, #24
c0d01390:	f001 fe78 	bl	c0d03084 <os_ux>
c0d01394:	61e0      	str	r0, [r4, #28]
c0d01396:	f001 faf9 	bl	c0d0298c <ux_check_status_default>
c0d0139a:	69e0      	ldr	r0, [r4, #28]
c0d0139c:	49ec      	ldr	r1, [pc, #944]	; (c0d01750 <io_event+0x444>)
c0d0139e:	4288      	cmp	r0, r1
c0d013a0:	d100      	bne.n	c0d013a4 <io_event+0x98>
c0d013a2:	e29b      	b.n	c0d018dc <io_event+0x5d0>
c0d013a4:	2800      	cmp	r0, #0
c0d013a6:	d100      	bne.n	c0d013aa <io_event+0x9e>
c0d013a8:	e298      	b.n	c0d018dc <io_event+0x5d0>
c0d013aa:	49e7      	ldr	r1, [pc, #924]	; (c0d01748 <io_event+0x43c>)
c0d013ac:	4288      	cmp	r0, r1
c0d013ae:	d000      	beq.n	c0d013b2 <io_event+0xa6>
c0d013b0:	e229      	b.n	c0d01806 <io_event+0x4fa>
c0d013b2:	f000 fe3d 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d013b6:	f000 fe41 	bl	c0d0203c <io_seproxyhal_init_button>
c0d013ba:	60a6      	str	r6, [r4, #8]
c0d013bc:	6820      	ldr	r0, [r4, #0]
c0d013be:	2800      	cmp	r0, #0
c0d013c0:	d100      	bne.n	c0d013c4 <io_event+0xb8>
c0d013c2:	e28b      	b.n	c0d018dc <io_event+0x5d0>
c0d013c4:	69e0      	ldr	r0, [r4, #28]
c0d013c6:	49e2      	ldr	r1, [pc, #904]	; (c0d01750 <io_event+0x444>)
c0d013c8:	4288      	cmp	r0, r1
c0d013ca:	d000      	beq.n	c0d013ce <io_event+0xc2>
c0d013cc:	e12c      	b.n	c0d01628 <io_event+0x31c>
c0d013ce:	e285      	b.n	c0d018dc <io_event+0x5d0>
		if (G_io_apdu_media == IO_APDU_MEDIA_USB_HID &&
			!(U4BE(G_io_seproxyhal_spi_buffer, 3) &
			  SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
			THROW(EXCEPTION_IO_RESET);
		}
		UX_DEFAULT_EVENT();
c0d013d0:	6860      	ldr	r0, [r4, #4]
c0d013d2:	4285      	cmp	r5, r0
c0d013d4:	d300      	bcc.n	c0d013d8 <io_event+0xcc>
c0d013d6:	e281      	b.n	c0d018dc <io_event+0x5d0>
c0d013d8:	f001 feae 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d013dc:	2800      	cmp	r0, #0
c0d013de:	d000      	beq.n	c0d013e2 <io_event+0xd6>
c0d013e0:	e27c      	b.n	c0d018dc <io_event+0x5d0>
c0d013e2:	68a0      	ldr	r0, [r4, #8]
c0d013e4:	68e1      	ldr	r1, [r4, #12]
c0d013e6:	2538      	movs	r5, #56	; 0x38
c0d013e8:	4368      	muls	r0, r5
c0d013ea:	6822      	ldr	r2, [r4, #0]
c0d013ec:	1810      	adds	r0, r2, r0
c0d013ee:	2900      	cmp	r1, #0
c0d013f0:	d002      	beq.n	c0d013f8 <io_event+0xec>
c0d013f2:	4788      	blx	r1
c0d013f4:	2800      	cmp	r0, #0
c0d013f6:	d007      	beq.n	c0d01408 <io_event+0xfc>
c0d013f8:	2801      	cmp	r0, #1
c0d013fa:	d103      	bne.n	c0d01404 <io_event+0xf8>
c0d013fc:	68a0      	ldr	r0, [r4, #8]
c0d013fe:	4345      	muls	r5, r0
c0d01400:	6820      	ldr	r0, [r4, #0]
c0d01402:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d01404:	f000 ff68 	bl	c0d022d8 <io_seproxyhal_display_default>
		if (G_io_apdu_media == IO_APDU_MEDIA_USB_HID &&
			!(U4BE(G_io_seproxyhal_spi_buffer, 3) &
			  SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
			THROW(EXCEPTION_IO_RESET);
		}
		UX_DEFAULT_EVENT();
c0d01408:	68a0      	ldr	r0, [r4, #8]
c0d0140a:	1c45      	adds	r5, r0, #1
c0d0140c:	60a5      	str	r5, [r4, #8]
c0d0140e:	6820      	ldr	r0, [r4, #0]
c0d01410:	2800      	cmp	r0, #0
c0d01412:	d1dd      	bne.n	c0d013d0 <io_event+0xc4>
c0d01414:	e262      	b.n	c0d018dc <io_event+0x5d0>
		break;

	case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
		UX_DISPLAYED_EVENT({});
c0d01416:	4ccd      	ldr	r4, [pc, #820]	; (c0d0174c <io_event+0x440>)
c0d01418:	2001      	movs	r0, #1
c0d0141a:	7620      	strb	r0, [r4, #24]
c0d0141c:	2500      	movs	r5, #0
c0d0141e:	61e5      	str	r5, [r4, #28]
c0d01420:	4620      	mov	r0, r4
c0d01422:	3018      	adds	r0, #24
c0d01424:	f001 fe2e 	bl	c0d03084 <os_ux>
c0d01428:	61e0      	str	r0, [r4, #28]
c0d0142a:	f001 faaf 	bl	c0d0298c <ux_check_status_default>
c0d0142e:	69e0      	ldr	r0, [r4, #28]
c0d01430:	49c7      	ldr	r1, [pc, #796]	; (c0d01750 <io_event+0x444>)
c0d01432:	4288      	cmp	r0, r1
c0d01434:	d100      	bne.n	c0d01438 <io_event+0x12c>
c0d01436:	e251      	b.n	c0d018dc <io_event+0x5d0>
c0d01438:	49c3      	ldr	r1, [pc, #780]	; (c0d01748 <io_event+0x43c>)
c0d0143a:	4288      	cmp	r0, r1
c0d0143c:	d100      	bne.n	c0d01440 <io_event+0x134>
c0d0143e:	e1b1      	b.n	c0d017a4 <io_event+0x498>
c0d01440:	2800      	cmp	r0, #0
c0d01442:	d100      	bne.n	c0d01446 <io_event+0x13a>
c0d01444:	e24a      	b.n	c0d018dc <io_event+0x5d0>
c0d01446:	6820      	ldr	r0, [r4, #0]
c0d01448:	2800      	cmp	r0, #0
c0d0144a:	d100      	bne.n	c0d0144e <io_event+0x142>
c0d0144c:	e240      	b.n	c0d018d0 <io_event+0x5c4>
c0d0144e:	68a0      	ldr	r0, [r4, #8]
c0d01450:	6861      	ldr	r1, [r4, #4]
c0d01452:	4288      	cmp	r0, r1
c0d01454:	d300      	bcc.n	c0d01458 <io_event+0x14c>
c0d01456:	e23b      	b.n	c0d018d0 <io_event+0x5c4>
c0d01458:	f001 fe6e 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d0145c:	2800      	cmp	r0, #0
c0d0145e:	d000      	beq.n	c0d01462 <io_event+0x156>
c0d01460:	e236      	b.n	c0d018d0 <io_event+0x5c4>
c0d01462:	68a0      	ldr	r0, [r4, #8]
c0d01464:	68e1      	ldr	r1, [r4, #12]
c0d01466:	2538      	movs	r5, #56	; 0x38
c0d01468:	4368      	muls	r0, r5
c0d0146a:	6822      	ldr	r2, [r4, #0]
c0d0146c:	1810      	adds	r0, r2, r0
c0d0146e:	2900      	cmp	r1, #0
c0d01470:	d002      	beq.n	c0d01478 <io_event+0x16c>
c0d01472:	4788      	blx	r1
c0d01474:	2800      	cmp	r0, #0
c0d01476:	d007      	beq.n	c0d01488 <io_event+0x17c>
c0d01478:	2801      	cmp	r0, #1
c0d0147a:	d103      	bne.n	c0d01484 <io_event+0x178>
c0d0147c:	68a0      	ldr	r0, [r4, #8]
c0d0147e:	4345      	muls	r5, r0
c0d01480:	6820      	ldr	r0, [r4, #0]
c0d01482:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d01484:	f000 ff28 	bl	c0d022d8 <io_seproxyhal_display_default>
		}
		UX_DEFAULT_EVENT();
		break;

	case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
		UX_DISPLAYED_EVENT({});
c0d01488:	68a0      	ldr	r0, [r4, #8]
c0d0148a:	1c40      	adds	r0, r0, #1
c0d0148c:	60a0      	str	r0, [r4, #8]
c0d0148e:	6821      	ldr	r1, [r4, #0]
c0d01490:	2900      	cmp	r1, #0
c0d01492:	d1dd      	bne.n	c0d01450 <io_event+0x144>
c0d01494:	e21c      	b.n	c0d018d0 <io_event+0x5c4>
		break;

	case SEPROXYHAL_TAG_TICKER_EVENT:
		UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
c0d01496:	4cad      	ldr	r4, [pc, #692]	; (c0d0174c <io_event+0x440>)
c0d01498:	2001      	movs	r0, #1
c0d0149a:	7620      	strb	r0, [r4, #24]
c0d0149c:	2500      	movs	r5, #0
c0d0149e:	61e5      	str	r5, [r4, #28]
c0d014a0:	4620      	mov	r0, r4
c0d014a2:	3018      	adds	r0, #24
c0d014a4:	f001 fdee 	bl	c0d03084 <os_ux>
c0d014a8:	61e0      	str	r0, [r4, #28]
c0d014aa:	f001 fa6f 	bl	c0d0298c <ux_check_status_default>
c0d014ae:	69e0      	ldr	r0, [r4, #28]
c0d014b0:	42b0      	cmp	r0, r6
c0d014b2:	d000      	beq.n	c0d014b6 <io_event+0x1aa>
c0d014b4:	e0de      	b.n	c0d01674 <io_event+0x368>
c0d014b6:	f000 fdbb 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d014ba:	f000 fdbf 	bl	c0d0203c <io_seproxyhal_init_button>
c0d014be:	60a5      	str	r5, [r4, #8]
c0d014c0:	6820      	ldr	r0, [r4, #0]
c0d014c2:	2800      	cmp	r0, #0
c0d014c4:	d100      	bne.n	c0d014c8 <io_event+0x1bc>
c0d014c6:	e209      	b.n	c0d018dc <io_event+0x5d0>
c0d014c8:	69e0      	ldr	r0, [r4, #28]
c0d014ca:	49a1      	ldr	r1, [pc, #644]	; (c0d01750 <io_event+0x444>)
c0d014cc:	4288      	cmp	r0, r1
c0d014ce:	d120      	bne.n	c0d01512 <io_event+0x206>
c0d014d0:	e204      	b.n	c0d018dc <io_event+0x5d0>
c0d014d2:	6860      	ldr	r0, [r4, #4]
c0d014d4:	4285      	cmp	r5, r0
c0d014d6:	d300      	bcc.n	c0d014da <io_event+0x1ce>
c0d014d8:	e200      	b.n	c0d018dc <io_event+0x5d0>
c0d014da:	f001 fe2d 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d014de:	2800      	cmp	r0, #0
c0d014e0:	d000      	beq.n	c0d014e4 <io_event+0x1d8>
c0d014e2:	e1fb      	b.n	c0d018dc <io_event+0x5d0>
c0d014e4:	68a0      	ldr	r0, [r4, #8]
c0d014e6:	68e1      	ldr	r1, [r4, #12]
c0d014e8:	2538      	movs	r5, #56	; 0x38
c0d014ea:	4368      	muls	r0, r5
c0d014ec:	6822      	ldr	r2, [r4, #0]
c0d014ee:	1810      	adds	r0, r2, r0
c0d014f0:	2900      	cmp	r1, #0
c0d014f2:	d002      	beq.n	c0d014fa <io_event+0x1ee>
c0d014f4:	4788      	blx	r1
c0d014f6:	2800      	cmp	r0, #0
c0d014f8:	d007      	beq.n	c0d0150a <io_event+0x1fe>
c0d014fa:	2801      	cmp	r0, #1
c0d014fc:	d103      	bne.n	c0d01506 <io_event+0x1fa>
c0d014fe:	68a0      	ldr	r0, [r4, #8]
c0d01500:	4345      	muls	r5, r0
c0d01502:	6820      	ldr	r0, [r4, #0]
c0d01504:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d01506:	f000 fee7 	bl	c0d022d8 <io_seproxyhal_display_default>
	case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
		UX_DISPLAYED_EVENT({});
		break;

	case SEPROXYHAL_TAG_TICKER_EVENT:
		UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
c0d0150a:	68a0      	ldr	r0, [r4, #8]
c0d0150c:	1c45      	adds	r5, r0, #1
c0d0150e:	60a5      	str	r5, [r4, #8]
c0d01510:	6820      	ldr	r0, [r4, #0]
c0d01512:	2800      	cmp	r0, #0
c0d01514:	d1dd      	bne.n	c0d014d2 <io_event+0x1c6>
c0d01516:	e1e1      	b.n	c0d018dc <io_event+0x5d0>
	case SEPROXYHAL_TAG_FINGER_EVENT:
		UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
		break;

	case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
		UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d01518:	4cf7      	ldr	r4, [pc, #988]	; (c0d018f8 <io_event+0x5ec>)
c0d0151a:	2001      	movs	r0, #1
c0d0151c:	7620      	strb	r0, [r4, #24]
c0d0151e:	2600      	movs	r6, #0
c0d01520:	61e6      	str	r6, [r4, #28]
c0d01522:	4620      	mov	r0, r4
c0d01524:	3018      	adds	r0, #24
c0d01526:	f001 fdad 	bl	c0d03084 <os_ux>
c0d0152a:	61e0      	str	r0, [r4, #28]
c0d0152c:	f001 fa2e 	bl	c0d0298c <ux_check_status_default>
c0d01530:	69e0      	ldr	r0, [r4, #28]
c0d01532:	49f2      	ldr	r1, [pc, #968]	; (c0d018fc <io_event+0x5f0>)
c0d01534:	4288      	cmp	r0, r1
c0d01536:	d100      	bne.n	c0d0153a <io_event+0x22e>
c0d01538:	e1d0      	b.n	c0d018dc <io_event+0x5d0>
c0d0153a:	2800      	cmp	r0, #0
c0d0153c:	d100      	bne.n	c0d01540 <io_event+0x234>
c0d0153e:	e1cd      	b.n	c0d018dc <io_event+0x5d0>
c0d01540:	49ec      	ldr	r1, [pc, #944]	; (c0d018f4 <io_event+0x5e8>)
c0d01542:	4288      	cmp	r0, r1
c0d01544:	d000      	beq.n	c0d01548 <io_event+0x23c>
c0d01546:	e198      	b.n	c0d0187a <io_event+0x56e>
c0d01548:	f000 fd72 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d0154c:	f000 fd76 	bl	c0d0203c <io_seproxyhal_init_button>
c0d01550:	60a6      	str	r6, [r4, #8]
c0d01552:	6820      	ldr	r0, [r4, #0]
c0d01554:	2800      	cmp	r0, #0
c0d01556:	d100      	bne.n	c0d0155a <io_event+0x24e>
c0d01558:	e1c0      	b.n	c0d018dc <io_event+0x5d0>
c0d0155a:	69e0      	ldr	r0, [r4, #28]
c0d0155c:	49e7      	ldr	r1, [pc, #924]	; (c0d018fc <io_event+0x5f0>)
c0d0155e:	4288      	cmp	r0, r1
c0d01560:	d000      	beq.n	c0d01564 <io_event+0x258>
c0d01562:	e084      	b.n	c0d0166e <io_event+0x362>
c0d01564:	e1ba      	b.n	c0d018dc <io_event+0x5d0>
	case SEPROXYHAL_TAG_TICKER_EVENT:
		UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
		break;

	default:
		UX_DEFAULT_EVENT();
c0d01566:	4ce4      	ldr	r4, [pc, #912]	; (c0d018f8 <io_event+0x5ec>)
c0d01568:	2001      	movs	r0, #1
c0d0156a:	7620      	strb	r0, [r4, #24]
c0d0156c:	2500      	movs	r5, #0
c0d0156e:	61e5      	str	r5, [r4, #28]
c0d01570:	4620      	mov	r0, r4
c0d01572:	3018      	adds	r0, #24
c0d01574:	f001 fd86 	bl	c0d03084 <os_ux>
c0d01578:	61e0      	str	r0, [r4, #28]
c0d0157a:	f001 fa07 	bl	c0d0298c <ux_check_status_default>
c0d0157e:	69e0      	ldr	r0, [r4, #28]
c0d01580:	42b0      	cmp	r0, r6
c0d01582:	d000      	beq.n	c0d01586 <io_event+0x27a>
c0d01584:	e0b8      	b.n	c0d016f8 <io_event+0x3ec>
c0d01586:	f000 fd53 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d0158a:	f000 fd57 	bl	c0d0203c <io_seproxyhal_init_button>
c0d0158e:	60a5      	str	r5, [r4, #8]
c0d01590:	6820      	ldr	r0, [r4, #0]
c0d01592:	2800      	cmp	r0, #0
c0d01594:	d100      	bne.n	c0d01598 <io_event+0x28c>
c0d01596:	e1a1      	b.n	c0d018dc <io_event+0x5d0>
c0d01598:	69e0      	ldr	r0, [r4, #28]
c0d0159a:	49d8      	ldr	r1, [pc, #864]	; (c0d018fc <io_event+0x5f0>)
c0d0159c:	4288      	cmp	r0, r1
c0d0159e:	d120      	bne.n	c0d015e2 <io_event+0x2d6>
c0d015a0:	e19c      	b.n	c0d018dc <io_event+0x5d0>
c0d015a2:	6860      	ldr	r0, [r4, #4]
c0d015a4:	4285      	cmp	r5, r0
c0d015a6:	d300      	bcc.n	c0d015aa <io_event+0x29e>
c0d015a8:	e198      	b.n	c0d018dc <io_event+0x5d0>
c0d015aa:	f001 fdc5 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d015ae:	2800      	cmp	r0, #0
c0d015b0:	d000      	beq.n	c0d015b4 <io_event+0x2a8>
c0d015b2:	e193      	b.n	c0d018dc <io_event+0x5d0>
c0d015b4:	68a0      	ldr	r0, [r4, #8]
c0d015b6:	68e1      	ldr	r1, [r4, #12]
c0d015b8:	2538      	movs	r5, #56	; 0x38
c0d015ba:	4368      	muls	r0, r5
c0d015bc:	6822      	ldr	r2, [r4, #0]
c0d015be:	1810      	adds	r0, r2, r0
c0d015c0:	2900      	cmp	r1, #0
c0d015c2:	d002      	beq.n	c0d015ca <io_event+0x2be>
c0d015c4:	4788      	blx	r1
c0d015c6:	2800      	cmp	r0, #0
c0d015c8:	d007      	beq.n	c0d015da <io_event+0x2ce>
c0d015ca:	2801      	cmp	r0, #1
c0d015cc:	d103      	bne.n	c0d015d6 <io_event+0x2ca>
c0d015ce:	68a0      	ldr	r0, [r4, #8]
c0d015d0:	4345      	muls	r5, r0
c0d015d2:	6820      	ldr	r0, [r4, #0]
c0d015d4:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d015d6:	f000 fe7f 	bl	c0d022d8 <io_seproxyhal_display_default>
	case SEPROXYHAL_TAG_TICKER_EVENT:
		UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
		break;

	default:
		UX_DEFAULT_EVENT();
c0d015da:	68a0      	ldr	r0, [r4, #8]
c0d015dc:	1c45      	adds	r5, r0, #1
c0d015de:	60a5      	str	r5, [r4, #8]
c0d015e0:	6820      	ldr	r0, [r4, #0]
c0d015e2:	2800      	cmp	r0, #0
c0d015e4:	d1dd      	bne.n	c0d015a2 <io_event+0x296>
c0d015e6:	e179      	b.n	c0d018dc <io_event+0x5d0>

unsigned char io_event(unsigned char channel) {
	// can't have more than one tag in the reply, not supported yet.
	switch (G_io_seproxyhal_spi_buffer[0]) {
	case SEPROXYHAL_TAG_FINGER_EVENT:
		UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d015e8:	6860      	ldr	r0, [r4, #4]
c0d015ea:	4286      	cmp	r6, r0
c0d015ec:	d300      	bcc.n	c0d015f0 <io_event+0x2e4>
c0d015ee:	e175      	b.n	c0d018dc <io_event+0x5d0>
c0d015f0:	f001 fda2 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d015f4:	2800      	cmp	r0, #0
c0d015f6:	d000      	beq.n	c0d015fa <io_event+0x2ee>
c0d015f8:	e170      	b.n	c0d018dc <io_event+0x5d0>
c0d015fa:	68a0      	ldr	r0, [r4, #8]
c0d015fc:	68e1      	ldr	r1, [r4, #12]
c0d015fe:	2538      	movs	r5, #56	; 0x38
c0d01600:	4368      	muls	r0, r5
c0d01602:	6822      	ldr	r2, [r4, #0]
c0d01604:	1810      	adds	r0, r2, r0
c0d01606:	2900      	cmp	r1, #0
c0d01608:	d002      	beq.n	c0d01610 <io_event+0x304>
c0d0160a:	4788      	blx	r1
c0d0160c:	2800      	cmp	r0, #0
c0d0160e:	d007      	beq.n	c0d01620 <io_event+0x314>
c0d01610:	2801      	cmp	r0, #1
c0d01612:	d103      	bne.n	c0d0161c <io_event+0x310>
c0d01614:	68a0      	ldr	r0, [r4, #8]
c0d01616:	4345      	muls	r5, r0
c0d01618:	6820      	ldr	r0, [r4, #0]
c0d0161a:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d0161c:	f000 fe5c 	bl	c0d022d8 <io_seproxyhal_display_default>

unsigned char io_event(unsigned char channel) {
	// can't have more than one tag in the reply, not supported yet.
	switch (G_io_seproxyhal_spi_buffer[0]) {
	case SEPROXYHAL_TAG_FINGER_EVENT:
		UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d01620:	68a0      	ldr	r0, [r4, #8]
c0d01622:	1c46      	adds	r6, r0, #1
c0d01624:	60a6      	str	r6, [r4, #8]
c0d01626:	6820      	ldr	r0, [r4, #0]
c0d01628:	2800      	cmp	r0, #0
c0d0162a:	d1dd      	bne.n	c0d015e8 <io_event+0x2dc>
c0d0162c:	e156      	b.n	c0d018dc <io_event+0x5d0>
		break;

	case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
		UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d0162e:	6860      	ldr	r0, [r4, #4]
c0d01630:	4286      	cmp	r6, r0
c0d01632:	d300      	bcc.n	c0d01636 <io_event+0x32a>
c0d01634:	e152      	b.n	c0d018dc <io_event+0x5d0>
c0d01636:	f001 fd7f 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d0163a:	2800      	cmp	r0, #0
c0d0163c:	d000      	beq.n	c0d01640 <io_event+0x334>
c0d0163e:	e14d      	b.n	c0d018dc <io_event+0x5d0>
c0d01640:	68a0      	ldr	r0, [r4, #8]
c0d01642:	68e1      	ldr	r1, [r4, #12]
c0d01644:	2538      	movs	r5, #56	; 0x38
c0d01646:	4368      	muls	r0, r5
c0d01648:	6822      	ldr	r2, [r4, #0]
c0d0164a:	1810      	adds	r0, r2, r0
c0d0164c:	2900      	cmp	r1, #0
c0d0164e:	d002      	beq.n	c0d01656 <io_event+0x34a>
c0d01650:	4788      	blx	r1
c0d01652:	2800      	cmp	r0, #0
c0d01654:	d007      	beq.n	c0d01666 <io_event+0x35a>
c0d01656:	2801      	cmp	r0, #1
c0d01658:	d103      	bne.n	c0d01662 <io_event+0x356>
c0d0165a:	68a0      	ldr	r0, [r4, #8]
c0d0165c:	4345      	muls	r5, r0
c0d0165e:	6820      	ldr	r0, [r4, #0]
c0d01660:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d01662:	f000 fe39 	bl	c0d022d8 <io_seproxyhal_display_default>
	case SEPROXYHAL_TAG_FINGER_EVENT:
		UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
		break;

	case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
		UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d01666:	68a0      	ldr	r0, [r4, #8]
c0d01668:	1c46      	adds	r6, r0, #1
c0d0166a:	60a6      	str	r6, [r4, #8]
c0d0166c:	6820      	ldr	r0, [r4, #0]
c0d0166e:	2800      	cmp	r0, #0
c0d01670:	d1dd      	bne.n	c0d0162e <io_event+0x322>
c0d01672:	e133      	b.n	c0d018dc <io_event+0x5d0>
	case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
		UX_DISPLAYED_EVENT({});
		break;

	case SEPROXYHAL_TAG_TICKER_EVENT:
		UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
c0d01674:	6961      	ldr	r1, [r4, #20]
c0d01676:	2900      	cmp	r1, #0
c0d01678:	d006      	beq.n	c0d01688 <io_event+0x37c>
c0d0167a:	2264      	movs	r2, #100	; 0x64
c0d0167c:	2964      	cmp	r1, #100	; 0x64
c0d0167e:	460b      	mov	r3, r1
c0d01680:	d300      	bcc.n	c0d01684 <io_event+0x378>
c0d01682:	4613      	mov	r3, r2
c0d01684:	1ac9      	subs	r1, r1, r3
c0d01686:	6161      	str	r1, [r4, #20]
c0d01688:	499c      	ldr	r1, [pc, #624]	; (c0d018fc <io_event+0x5f0>)
c0d0168a:	4288      	cmp	r0, r1
c0d0168c:	d100      	bne.n	c0d01690 <io_event+0x384>
c0d0168e:	e125      	b.n	c0d018dc <io_event+0x5d0>
c0d01690:	2800      	cmp	r0, #0
c0d01692:	d100      	bne.n	c0d01696 <io_event+0x38a>
c0d01694:	e122      	b.n	c0d018dc <io_event+0x5d0>
c0d01696:	6820      	ldr	r0, [r4, #0]
c0d01698:	2800      	cmp	r0, #0
c0d0169a:	d100      	bne.n	c0d0169e <io_event+0x392>
c0d0169c:	e118      	b.n	c0d018d0 <io_event+0x5c4>
c0d0169e:	68a0      	ldr	r0, [r4, #8]
c0d016a0:	6861      	ldr	r1, [r4, #4]
c0d016a2:	4288      	cmp	r0, r1
c0d016a4:	d300      	bcc.n	c0d016a8 <io_event+0x39c>
c0d016a6:	e113      	b.n	c0d018d0 <io_event+0x5c4>
c0d016a8:	f001 fd46 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d016ac:	2800      	cmp	r0, #0
c0d016ae:	d000      	beq.n	c0d016b2 <io_event+0x3a6>
c0d016b0:	e10e      	b.n	c0d018d0 <io_event+0x5c4>
c0d016b2:	68a0      	ldr	r0, [r4, #8]
c0d016b4:	68e1      	ldr	r1, [r4, #12]
c0d016b6:	2538      	movs	r5, #56	; 0x38
c0d016b8:	4368      	muls	r0, r5
c0d016ba:	6822      	ldr	r2, [r4, #0]
c0d016bc:	1810      	adds	r0, r2, r0
c0d016be:	2900      	cmp	r1, #0
c0d016c0:	d002      	beq.n	c0d016c8 <io_event+0x3bc>
c0d016c2:	4788      	blx	r1
c0d016c4:	2800      	cmp	r0, #0
c0d016c6:	d007      	beq.n	c0d016d8 <io_event+0x3cc>
c0d016c8:	2801      	cmp	r0, #1
c0d016ca:	d103      	bne.n	c0d016d4 <io_event+0x3c8>
c0d016cc:	68a0      	ldr	r0, [r4, #8]
c0d016ce:	4345      	muls	r5, r0
c0d016d0:	6820      	ldr	r0, [r4, #0]
c0d016d2:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d016d4:	f000 fe00 	bl	c0d022d8 <io_seproxyhal_display_default>
	case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
		UX_DISPLAYED_EVENT({});
		break;

	case SEPROXYHAL_TAG_TICKER_EVENT:
		UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
c0d016d8:	68a0      	ldr	r0, [r4, #8]
c0d016da:	1c40      	adds	r0, r0, #1
c0d016dc:	60a0      	str	r0, [r4, #8]
c0d016de:	6821      	ldr	r1, [r4, #0]
c0d016e0:	2900      	cmp	r1, #0
c0d016e2:	d1dd      	bne.n	c0d016a0 <io_event+0x394>
c0d016e4:	e0f4      	b.n	c0d018d0 <io_event+0x5c4>
c0d016e6:	46c0      	nop			; (mov r8, r8)
c0d016e8:	20001800 	.word	0x20001800
c0d016ec:	b0105055 	.word	0xb0105055
c0d016f0:	20001e7c 	.word	0x20001e7c
c0d016f4:	20001880 	.word	0x20001880
		break;

	default:
		UX_DEFAULT_EVENT();
c0d016f8:	6820      	ldr	r0, [r4, #0]
c0d016fa:	2800      	cmp	r0, #0
c0d016fc:	d100      	bne.n	c0d01700 <io_event+0x3f4>
c0d016fe:	e0e7      	b.n	c0d018d0 <io_event+0x5c4>
c0d01700:	68a0      	ldr	r0, [r4, #8]
c0d01702:	6861      	ldr	r1, [r4, #4]
c0d01704:	4288      	cmp	r0, r1
c0d01706:	d300      	bcc.n	c0d0170a <io_event+0x3fe>
c0d01708:	e0e2      	b.n	c0d018d0 <io_event+0x5c4>
c0d0170a:	f001 fd15 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d0170e:	2800      	cmp	r0, #0
c0d01710:	d000      	beq.n	c0d01714 <io_event+0x408>
c0d01712:	e0dd      	b.n	c0d018d0 <io_event+0x5c4>
c0d01714:	68a0      	ldr	r0, [r4, #8]
c0d01716:	68e1      	ldr	r1, [r4, #12]
c0d01718:	2538      	movs	r5, #56	; 0x38
c0d0171a:	4368      	muls	r0, r5
c0d0171c:	6822      	ldr	r2, [r4, #0]
c0d0171e:	1810      	adds	r0, r2, r0
c0d01720:	2900      	cmp	r1, #0
c0d01722:	d002      	beq.n	c0d0172a <io_event+0x41e>
c0d01724:	4788      	blx	r1
c0d01726:	2800      	cmp	r0, #0
c0d01728:	d007      	beq.n	c0d0173a <io_event+0x42e>
c0d0172a:	2801      	cmp	r0, #1
c0d0172c:	d103      	bne.n	c0d01736 <io_event+0x42a>
c0d0172e:	68a0      	ldr	r0, [r4, #8]
c0d01730:	4345      	muls	r5, r0
c0d01732:	6820      	ldr	r0, [r4, #0]
c0d01734:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d01736:	f000 fdcf 	bl	c0d022d8 <io_seproxyhal_display_default>
	case SEPROXYHAL_TAG_TICKER_EVENT:
		UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
		break;

	default:
		UX_DEFAULT_EVENT();
c0d0173a:	68a0      	ldr	r0, [r4, #8]
c0d0173c:	1c40      	adds	r0, r0, #1
c0d0173e:	60a0      	str	r0, [r4, #8]
c0d01740:	6821      	ldr	r1, [r4, #0]
c0d01742:	2900      	cmp	r1, #0
c0d01744:	d1dd      	bne.n	c0d01702 <io_event+0x3f6>
c0d01746:	e0c3      	b.n	c0d018d0 <io_event+0x5c4>
c0d01748:	b0105055 	.word	0xb0105055
c0d0174c:	20001880 	.word	0x20001880
c0d01750:	b0105044 	.word	0xb0105044
		if (G_io_apdu_media == IO_APDU_MEDIA_USB_HID &&
			!(U4BE(G_io_seproxyhal_spi_buffer, 3) &
			  SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
			THROW(EXCEPTION_IO_RESET);
		}
		UX_DEFAULT_EVENT();
c0d01754:	6820      	ldr	r0, [r4, #0]
c0d01756:	2800      	cmp	r0, #0
c0d01758:	d100      	bne.n	c0d0175c <io_event+0x450>
c0d0175a:	e0b9      	b.n	c0d018d0 <io_event+0x5c4>
c0d0175c:	68a0      	ldr	r0, [r4, #8]
c0d0175e:	6861      	ldr	r1, [r4, #4]
c0d01760:	4288      	cmp	r0, r1
c0d01762:	d300      	bcc.n	c0d01766 <io_event+0x45a>
c0d01764:	e0b4      	b.n	c0d018d0 <io_event+0x5c4>
c0d01766:	f001 fce7 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d0176a:	2800      	cmp	r0, #0
c0d0176c:	d000      	beq.n	c0d01770 <io_event+0x464>
c0d0176e:	e0af      	b.n	c0d018d0 <io_event+0x5c4>
c0d01770:	68a0      	ldr	r0, [r4, #8]
c0d01772:	68e1      	ldr	r1, [r4, #12]
c0d01774:	2538      	movs	r5, #56	; 0x38
c0d01776:	4368      	muls	r0, r5
c0d01778:	6822      	ldr	r2, [r4, #0]
c0d0177a:	1810      	adds	r0, r2, r0
c0d0177c:	2900      	cmp	r1, #0
c0d0177e:	d002      	beq.n	c0d01786 <io_event+0x47a>
c0d01780:	4788      	blx	r1
c0d01782:	2800      	cmp	r0, #0
c0d01784:	d007      	beq.n	c0d01796 <io_event+0x48a>
c0d01786:	2801      	cmp	r0, #1
c0d01788:	d103      	bne.n	c0d01792 <io_event+0x486>
c0d0178a:	68a0      	ldr	r0, [r4, #8]
c0d0178c:	4345      	muls	r5, r0
c0d0178e:	6820      	ldr	r0, [r4, #0]
c0d01790:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d01792:	f000 fda1 	bl	c0d022d8 <io_seproxyhal_display_default>
		if (G_io_apdu_media == IO_APDU_MEDIA_USB_HID &&
			!(U4BE(G_io_seproxyhal_spi_buffer, 3) &
			  SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
			THROW(EXCEPTION_IO_RESET);
		}
		UX_DEFAULT_EVENT();
c0d01796:	68a0      	ldr	r0, [r4, #8]
c0d01798:	1c40      	adds	r0, r0, #1
c0d0179a:	60a0      	str	r0, [r4, #8]
c0d0179c:	6821      	ldr	r1, [r4, #0]
c0d0179e:	2900      	cmp	r1, #0
c0d017a0:	d1dd      	bne.n	c0d0175e <io_event+0x452>
c0d017a2:	e095      	b.n	c0d018d0 <io_event+0x5c4>
		break;

	case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
		UX_DISPLAYED_EVENT({});
c0d017a4:	f000 fc44 	bl	c0d02030 <io_seproxyhal_init_ux>
c0d017a8:	f000 fc48 	bl	c0d0203c <io_seproxyhal_init_button>
c0d017ac:	60a5      	str	r5, [r4, #8]
c0d017ae:	6820      	ldr	r0, [r4, #0]
c0d017b0:	2800      	cmp	r0, #0
c0d017b2:	d100      	bne.n	c0d017b6 <io_event+0x4aa>
c0d017b4:	e092      	b.n	c0d018dc <io_event+0x5d0>
c0d017b6:	69e0      	ldr	r0, [r4, #28]
c0d017b8:	4950      	ldr	r1, [pc, #320]	; (c0d018fc <io_event+0x5f0>)
c0d017ba:	4288      	cmp	r0, r1
c0d017bc:	d120      	bne.n	c0d01800 <io_event+0x4f4>
c0d017be:	e08d      	b.n	c0d018dc <io_event+0x5d0>
c0d017c0:	6860      	ldr	r0, [r4, #4]
c0d017c2:	4285      	cmp	r5, r0
c0d017c4:	d300      	bcc.n	c0d017c8 <io_event+0x4bc>
c0d017c6:	e089      	b.n	c0d018dc <io_event+0x5d0>
c0d017c8:	f001 fcb6 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d017cc:	2800      	cmp	r0, #0
c0d017ce:	d000      	beq.n	c0d017d2 <io_event+0x4c6>
c0d017d0:	e084      	b.n	c0d018dc <io_event+0x5d0>
c0d017d2:	68a0      	ldr	r0, [r4, #8]
c0d017d4:	68e1      	ldr	r1, [r4, #12]
c0d017d6:	2538      	movs	r5, #56	; 0x38
c0d017d8:	4368      	muls	r0, r5
c0d017da:	6822      	ldr	r2, [r4, #0]
c0d017dc:	1810      	adds	r0, r2, r0
c0d017de:	2900      	cmp	r1, #0
c0d017e0:	d002      	beq.n	c0d017e8 <io_event+0x4dc>
c0d017e2:	4788      	blx	r1
c0d017e4:	2800      	cmp	r0, #0
c0d017e6:	d007      	beq.n	c0d017f8 <io_event+0x4ec>
c0d017e8:	2801      	cmp	r0, #1
c0d017ea:	d103      	bne.n	c0d017f4 <io_event+0x4e8>
c0d017ec:	68a0      	ldr	r0, [r4, #8]
c0d017ee:	4345      	muls	r5, r0
c0d017f0:	6820      	ldr	r0, [r4, #0]
c0d017f2:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d017f4:	f000 fd70 	bl	c0d022d8 <io_seproxyhal_display_default>
		}
		UX_DEFAULT_EVENT();
		break;

	case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
		UX_DISPLAYED_EVENT({});
c0d017f8:	68a0      	ldr	r0, [r4, #8]
c0d017fa:	1c45      	adds	r5, r0, #1
c0d017fc:	60a5      	str	r5, [r4, #8]
c0d017fe:	6820      	ldr	r0, [r4, #0]
c0d01800:	2800      	cmp	r0, #0
c0d01802:	d1dd      	bne.n	c0d017c0 <io_event+0x4b4>
c0d01804:	e06a      	b.n	c0d018dc <io_event+0x5d0>

unsigned char io_event(unsigned char channel) {
	// can't have more than one tag in the reply, not supported yet.
	switch (G_io_seproxyhal_spi_buffer[0]) {
	case SEPROXYHAL_TAG_FINGER_EVENT:
		UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d01806:	88a0      	ldrh	r0, [r4, #4]
c0d01808:	9004      	str	r0, [sp, #16]
c0d0180a:	6820      	ldr	r0, [r4, #0]
c0d0180c:	9003      	str	r0, [sp, #12]
c0d0180e:	79ee      	ldrb	r6, [r5, #7]
c0d01810:	79ab      	ldrb	r3, [r5, #6]
c0d01812:	796f      	ldrb	r7, [r5, #5]
c0d01814:	792a      	ldrb	r2, [r5, #4]
c0d01816:	78ed      	ldrb	r5, [r5, #3]
c0d01818:	68e1      	ldr	r1, [r4, #12]
c0d0181a:	4668      	mov	r0, sp
c0d0181c:	6005      	str	r5, [r0, #0]
c0d0181e:	6041      	str	r1, [r0, #4]
c0d01820:	0212      	lsls	r2, r2, #8
c0d01822:	433a      	orrs	r2, r7
c0d01824:	021b      	lsls	r3, r3, #8
c0d01826:	4333      	orrs	r3, r6
c0d01828:	9803      	ldr	r0, [sp, #12]
c0d0182a:	9904      	ldr	r1, [sp, #16]
c0d0182c:	f000 fc86 	bl	c0d0213c <io_seproxyhal_touch_element_callback>
c0d01830:	6820      	ldr	r0, [r4, #0]
c0d01832:	2800      	cmp	r0, #0
c0d01834:	d04c      	beq.n	c0d018d0 <io_event+0x5c4>
c0d01836:	68a0      	ldr	r0, [r4, #8]
c0d01838:	6861      	ldr	r1, [r4, #4]
c0d0183a:	4288      	cmp	r0, r1
c0d0183c:	d248      	bcs.n	c0d018d0 <io_event+0x5c4>
c0d0183e:	f001 fc7b 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d01842:	2800      	cmp	r0, #0
c0d01844:	d144      	bne.n	c0d018d0 <io_event+0x5c4>
c0d01846:	68a0      	ldr	r0, [r4, #8]
c0d01848:	68e1      	ldr	r1, [r4, #12]
c0d0184a:	2538      	movs	r5, #56	; 0x38
c0d0184c:	4368      	muls	r0, r5
c0d0184e:	6822      	ldr	r2, [r4, #0]
c0d01850:	1810      	adds	r0, r2, r0
c0d01852:	2900      	cmp	r1, #0
c0d01854:	d002      	beq.n	c0d0185c <io_event+0x550>
c0d01856:	4788      	blx	r1
c0d01858:	2800      	cmp	r0, #0
c0d0185a:	d007      	beq.n	c0d0186c <io_event+0x560>
c0d0185c:	2801      	cmp	r0, #1
c0d0185e:	d103      	bne.n	c0d01868 <io_event+0x55c>
c0d01860:	68a0      	ldr	r0, [r4, #8]
c0d01862:	4345      	muls	r5, r0
c0d01864:	6820      	ldr	r0, [r4, #0]
c0d01866:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d01868:	f000 fd36 	bl	c0d022d8 <io_seproxyhal_display_default>

unsigned char io_event(unsigned char channel) {
	// can't have more than one tag in the reply, not supported yet.
	switch (G_io_seproxyhal_spi_buffer[0]) {
	case SEPROXYHAL_TAG_FINGER_EVENT:
		UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d0186c:	68a0      	ldr	r0, [r4, #8]
c0d0186e:	1c40      	adds	r0, r0, #1
c0d01870:	60a0      	str	r0, [r4, #8]
c0d01872:	6821      	ldr	r1, [r4, #0]
c0d01874:	2900      	cmp	r1, #0
c0d01876:	d1df      	bne.n	c0d01838 <io_event+0x52c>
c0d01878:	e02a      	b.n	c0d018d0 <io_event+0x5c4>
		break;

	case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
		UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d0187a:	6920      	ldr	r0, [r4, #16]
c0d0187c:	2800      	cmp	r0, #0
c0d0187e:	d003      	beq.n	c0d01888 <io_event+0x57c>
c0d01880:	78e9      	ldrb	r1, [r5, #3]
c0d01882:	0849      	lsrs	r1, r1, #1
c0d01884:	f000 fd6a 	bl	c0d0235c <io_seproxyhal_button_push>
c0d01888:	6820      	ldr	r0, [r4, #0]
c0d0188a:	2800      	cmp	r0, #0
c0d0188c:	d020      	beq.n	c0d018d0 <io_event+0x5c4>
c0d0188e:	68a0      	ldr	r0, [r4, #8]
c0d01890:	6861      	ldr	r1, [r4, #4]
c0d01892:	4288      	cmp	r0, r1
c0d01894:	d21c      	bcs.n	c0d018d0 <io_event+0x5c4>
c0d01896:	f001 fc4f 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d0189a:	2800      	cmp	r0, #0
c0d0189c:	d118      	bne.n	c0d018d0 <io_event+0x5c4>
c0d0189e:	68a0      	ldr	r0, [r4, #8]
c0d018a0:	68e1      	ldr	r1, [r4, #12]
c0d018a2:	2538      	movs	r5, #56	; 0x38
c0d018a4:	4368      	muls	r0, r5
c0d018a6:	6822      	ldr	r2, [r4, #0]
c0d018a8:	1810      	adds	r0, r2, r0
c0d018aa:	2900      	cmp	r1, #0
c0d018ac:	d002      	beq.n	c0d018b4 <io_event+0x5a8>
c0d018ae:	4788      	blx	r1
c0d018b0:	2800      	cmp	r0, #0
c0d018b2:	d007      	beq.n	c0d018c4 <io_event+0x5b8>
c0d018b4:	2801      	cmp	r0, #1
c0d018b6:	d103      	bne.n	c0d018c0 <io_event+0x5b4>
c0d018b8:	68a0      	ldr	r0, [r4, #8]
c0d018ba:	4345      	muls	r5, r0
c0d018bc:	6820      	ldr	r0, [r4, #0]
c0d018be:	1940      	adds	r0, r0, r5
	}
}


void io_seproxyhal_display(const bagl_element_t *element) {
	io_seproxyhal_display_default((bagl_element_t *)element);
c0d018c0:	f000 fd0a 	bl	c0d022d8 <io_seproxyhal_display_default>
	case SEPROXYHAL_TAG_FINGER_EVENT:
		UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
		break;

	case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
		UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d018c4:	68a0      	ldr	r0, [r4, #8]
c0d018c6:	1c40      	adds	r0, r0, #1
c0d018c8:	60a0      	str	r0, [r4, #8]
c0d018ca:	6821      	ldr	r1, [r4, #0]
c0d018cc:	2900      	cmp	r1, #0
c0d018ce:	d1df      	bne.n	c0d01890 <io_event+0x584>
c0d018d0:	6860      	ldr	r0, [r4, #4]
c0d018d2:	68a1      	ldr	r1, [r4, #8]
c0d018d4:	4281      	cmp	r1, r0
c0d018d6:	d301      	bcc.n	c0d018dc <io_event+0x5d0>
c0d018d8:	f001 fc2e 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
		UX_DEFAULT_EVENT();
		break;
	}

	// close the event if not done previously (by a display or whatever)
	if (!io_seproxyhal_spi_is_status_sent()) {
c0d018dc:	f001 fc2c 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d018e0:	2800      	cmp	r0, #0
c0d018e2:	d101      	bne.n	c0d018e8 <io_event+0x5dc>
		io_seproxyhal_general_status();
c0d018e4:	f000 fa5a 	bl	c0d01d9c <io_seproxyhal_general_status>
	}

	// command has been processed, DO NOT reset the current APDU transport
	return 1;
c0d018e8:	2001      	movs	r0, #1
c0d018ea:	b005      	add	sp, #20
c0d018ec:	bdf0      	pop	{r4, r5, r6, r7, pc}

	case SEPROXYHAL_TAG_STATUS_EVENT:
		if (G_io_apdu_media == IO_APDU_MEDIA_USB_HID &&
			!(U4BE(G_io_seproxyhal_spi_buffer, 3) &
			  SEPROXYHAL_TAG_STATUS_EVENT_FLAG_USB_POWERED)) {
			THROW(EXCEPTION_IO_RESET);
c0d018ee:	2010      	movs	r0, #16
c0d018f0:	f000 fa47 	bl	c0d01d82 <os_longjmp>
c0d018f4:	b0105055 	.word	0xb0105055
c0d018f8:	20001880 	.word	0x20001880
c0d018fc:	b0105044 	.word	0xb0105044

c0d01900 <io_exchange_al>:

	// command has been processed, DO NOT reset the current APDU transport
	return 1;
}

unsigned short io_exchange_al(unsigned char channel, unsigned short tx_len) {
c0d01900:	b5b0      	push	{r4, r5, r7, lr}
c0d01902:	4605      	mov	r5, r0
c0d01904:	2007      	movs	r0, #7
	switch (channel & ~(IO_FLAGS)) {
c0d01906:	4028      	ands	r0, r5
c0d01908:	2400      	movs	r4, #0
c0d0190a:	2801      	cmp	r0, #1
c0d0190c:	d013      	beq.n	c0d01936 <io_exchange_al+0x36>
c0d0190e:	2802      	cmp	r0, #2
c0d01910:	d113      	bne.n	c0d0193a <io_exchange_al+0x3a>
	case CHANNEL_KEYBOARD:
		break;
	// multiplexed io exchange over a SPI channel and TLV encapsulated protocol
	case CHANNEL_SPI:
		if (tx_len) {
c0d01912:	2900      	cmp	r1, #0
c0d01914:	d008      	beq.n	c0d01928 <io_exchange_al+0x28>
			io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d01916:	480a      	ldr	r0, [pc, #40]	; (c0d01940 <io_exchange_al+0x40>)
c0d01918:	f001 fbf8 	bl	c0d0310c <io_seproxyhal_spi_send>
			if (channel & IO_RESET_AFTER_REPLIED) {
c0d0191c:	b268      	sxtb	r0, r5
c0d0191e:	2800      	cmp	r0, #0
c0d01920:	da09      	bge.n	c0d01936 <io_exchange_al+0x36>
				reset();
c0d01922:	f001 fab9 	bl	c0d02e98 <reset>
c0d01926:	e006      	b.n	c0d01936 <io_exchange_al+0x36>
			}
			return 0; // nothing received from the master so far (it's a tx transaction)
		} else {
			return io_seproxyhal_spi_recv(G_io_apdu_buffer, sizeof(G_io_apdu_buffer), 0);
c0d01928:	2041      	movs	r0, #65	; 0x41
c0d0192a:	0081      	lsls	r1, r0, #2
c0d0192c:	4804      	ldr	r0, [pc, #16]	; (c0d01940 <io_exchange_al+0x40>)
c0d0192e:	2200      	movs	r2, #0
c0d01930:	f001 fc18 	bl	c0d03164 <io_seproxyhal_spi_recv>
c0d01934:	4604      	mov	r4, r0
		}
	default:
		THROW(INVALID_PARAMETER);
	}
	return 0;
}
c0d01936:	4620      	mov	r0, r4
c0d01938:	bdb0      	pop	{r4, r5, r7, pc}
			return 0; // nothing received from the master so far (it's a tx transaction)
		} else {
			return io_seproxyhal_spi_recv(G_io_apdu_buffer, sizeof(G_io_apdu_buffer), 0);
		}
	default:
		THROW(INVALID_PARAMETER);
c0d0193a:	2002      	movs	r0, #2
c0d0193c:	f000 fa21 	bl	c0d01d82 <os_longjmp>
c0d01940:	20001d70 	.word	0x20001d70

c0d01944 <one_main>:
#define OFFSET_P2    0x03
#define OFFSET_LC    0x04
#define OFFSET_CDATA 0x05


static void one_main(void) {
c0d01944:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01946:	b093      	sub	sp, #76	; 0x4c
c0d01948:	2500      	movs	r5, #0
	volatile unsigned int rx = 0;
c0d0194a:	9512      	str	r5, [sp, #72]	; 0x48
	volatile unsigned int tx = 0;
c0d0194c:	9511      	str	r5, [sp, #68]	; 0x44
	volatile unsigned int flags = 0;
c0d0194e:	9510      	str	r5, [sp, #64]	; 0x40
c0d01950:	4e3e      	ldr	r6, [pc, #248]	; (c0d01a4c <one_main+0x108>)
c0d01952:	4840      	ldr	r0, [pc, #256]	; (c0d01a54 <one_main+0x110>)
c0d01954:	4478      	add	r0, pc
c0d01956:	9003      	str	r0, [sp, #12]
c0d01958:	483f      	ldr	r0, [pc, #252]	; (c0d01a58 <one_main+0x114>)
c0d0195a:	4478      	add	r0, pc
c0d0195c:	9002      	str	r0, [sp, #8]
c0d0195e:	a80f      	add	r0, sp, #60	; 0x3c

	// Exchange APDUs until EXCEPTION_IO_RESET is thrown.
	for (;;) {
		volatile unsigned short sw = 0;
c0d01960:	8005      	strh	r5, [r0, #0]
c0d01962:	ac04      	add	r4, sp, #16
		// In one_main, this TRY block serves to catch any thrown exceptions
		// and convert them to response codes, which are then sent in APDUs.
		// However, EXCEPTION_IO_RESET will be re-thrown and caught by the
		// "true" main function defined at the bottom of this file.
		BEGIN_TRY {
			TRY {
c0d01964:	4620      	mov	r0, r4
c0d01966:	f003 fae3 	bl	c0d04f30 <setjmp>
c0d0196a:	8520      	strh	r0, [r4, #40]	; 0x28
c0d0196c:	b281      	uxth	r1, r0
c0d0196e:	2900      	cmp	r1, #0
c0d01970:	d011      	beq.n	c0d01996 <one_main+0x52>
c0d01972:	2910      	cmp	r1, #16
c0d01974:	d05c      	beq.n	c0d01a30 <one_main+0xec>
c0d01976:	a904      	add	r1, sp, #16
				          G_io_apdu_buffer + OFFSET_CDATA, G_io_apdu_buffer[OFFSET_LC], &flags, &tx);
			}
			CATCH(EXCEPTION_IO_RESET) {
				THROW(EXCEPTION_IO_RESET);
			}
			CATCH_OTHER(e) {
c0d01978:	850d      	strh	r5, [r1, #40]	; 0x28
c0d0197a:	210f      	movs	r1, #15
c0d0197c:	0309      	lsls	r1, r1, #12
				//
				// If the first byte is not a 6, mask it with 0x6800 to
				// convert it to a proper error code. I'm not totally sure why
				// this is done; perhaps to handle single-byte exception
				// codes?
				switch (e & 0xF000) {
c0d0197e:	4001      	ands	r1, r0
c0d01980:	2209      	movs	r2, #9
c0d01982:	0312      	lsls	r2, r2, #12
c0d01984:	4291      	cmp	r1, r2
c0d01986:	d003      	beq.n	c0d01990 <one_main+0x4c>
c0d01988:	2203      	movs	r2, #3
c0d0198a:	0352      	lsls	r2, r2, #13
c0d0198c:	4291      	cmp	r1, r2
c0d0198e:	d122      	bne.n	c0d019d6 <one_main+0x92>
c0d01990:	a90f      	add	r1, sp, #60	; 0x3c
				case 0x6000:
				case 0x9000:
					sw = e;
c0d01992:	8008      	strh	r0, [r1, #0]
c0d01994:	e026      	b.n	c0d019e4 <one_main+0xa0>
c0d01996:	a804      	add	r0, sp, #16
		// In one_main, this TRY block serves to catch any thrown exceptions
		// and convert them to response codes, which are then sent in APDUs.
		// However, EXCEPTION_IO_RESET will be re-thrown and caught by the
		// "true" main function defined at the bottom of this file.
		BEGIN_TRY {
			TRY {
c0d01998:	f000 f889 	bl	c0d01aae <try_context_set>
				rx = tx;
c0d0199c:	9811      	ldr	r0, [sp, #68]	; 0x44
c0d0199e:	9012      	str	r0, [sp, #72]	; 0x48
c0d019a0:	2400      	movs	r4, #0
				tx = 0; // ensure no race in CATCH_OTHER if io_exchange throws an error
c0d019a2:	9411      	str	r4, [sp, #68]	; 0x44
				rx = io_exchange(CHANNEL_APDU | flags, rx);
c0d019a4:	9810      	ldr	r0, [sp, #64]	; 0x40
c0d019a6:	9912      	ldr	r1, [sp, #72]	; 0x48
c0d019a8:	b2c0      	uxtb	r0, r0
c0d019aa:	b289      	uxth	r1, r1
c0d019ac:	f000 fd34 	bl	c0d02418 <io_exchange>
c0d019b0:	9012      	str	r0, [sp, #72]	; 0x48
				flags = 0;
c0d019b2:	9410      	str	r4, [sp, #64]	; 0x40

				// No APDU received; trigger a reset.
				if (rx == 0) {
c0d019b4:	9812      	ldr	r0, [sp, #72]	; 0x48
c0d019b6:	2800      	cmp	r0, #0
c0d019b8:	d03c      	beq.n	c0d01a34 <one_main+0xf0>
					THROW(EXCEPTION_IO_RESET);
				}
				// Malformed APDU.
				if (G_io_apdu_buffer[OFFSET_CLA] != CLA) {
c0d019ba:	7830      	ldrb	r0, [r6, #0]
c0d019bc:	28e0      	cmp	r0, #224	; 0xe0
c0d019be:	d13c      	bne.n	c0d01a3a <one_main+0xf6>
					THROW(0x6E00);
				}
				// Lookup and call the requested command handler.
				handler_fn_t *handlerFn = lookupHandler(G_io_apdu_buffer[OFFSET_INS]);
c0d019c0:	7870      	ldrb	r0, [r6, #1]
handler_fn_t handleGetPublicKey;
//handler_fn_t handleSignHash;
handler_fn_t handleSignTx;

static handler_fn_t* lookupHandler(uint8_t ins) {
	switch (ins) {
c0d019c2:	2801      	cmp	r0, #1
c0d019c4:	9c03      	ldr	r4, [sp, #12]
c0d019c6:	d01a      	beq.n	c0d019fe <one_main+0xba>
c0d019c8:	2808      	cmp	r0, #8
c0d019ca:	d017      	beq.n	c0d019fc <one_main+0xb8>
c0d019cc:	2802      	cmp	r0, #2
c0d019ce:	d138      	bne.n	c0d01a42 <one_main+0xfe>
c0d019d0:	4c22      	ldr	r4, [pc, #136]	; (c0d01a5c <one_main+0x118>)
c0d019d2:	447c      	add	r4, pc
c0d019d4:	e013      	b.n	c0d019fe <one_main+0xba>
				case 0x6000:
				case 0x9000:
					sw = e;
					break;
				default:
					sw = 0x6800 | (e & 0x7FF);
c0d019d6:	491e      	ldr	r1, [pc, #120]	; (c0d01a50 <one_main+0x10c>)
c0d019d8:	4008      	ands	r0, r1
c0d019da:	210d      	movs	r1, #13
c0d019dc:	02c9      	lsls	r1, r1, #11
c0d019de:	4301      	orrs	r1, r0
c0d019e0:	a80f      	add	r0, sp, #60	; 0x3c
c0d019e2:	8001      	strh	r1, [r0, #0]
					break;
				}
				G_io_apdu_buffer[tx++] = sw >> 8;
c0d019e4:	980f      	ldr	r0, [sp, #60]	; 0x3c
c0d019e6:	9911      	ldr	r1, [sp, #68]	; 0x44
c0d019e8:	1c4a      	adds	r2, r1, #1
c0d019ea:	9211      	str	r2, [sp, #68]	; 0x44
c0d019ec:	0a00      	lsrs	r0, r0, #8
c0d019ee:	5470      	strb	r0, [r6, r1]
				G_io_apdu_buffer[tx++] = sw & 0xFF;
c0d019f0:	980f      	ldr	r0, [sp, #60]	; 0x3c
c0d019f2:	9911      	ldr	r1, [sp, #68]	; 0x44
c0d019f4:	1c4a      	adds	r2, r1, #1
c0d019f6:	9211      	str	r2, [sp, #68]	; 0x44
c0d019f8:	5470      	strb	r0, [r6, r1]
c0d019fa:	e00a      	b.n	c0d01a12 <one_main+0xce>
c0d019fc:	9c02      	ldr	r4, [sp, #8]
				handler_fn_t *handlerFn = lookupHandler(G_io_apdu_buffer[OFFSET_INS]);
				if (!handlerFn) {
					THROW(0x6D00);
				}
				handlerFn(G_io_apdu_buffer[OFFSET_P1], G_io_apdu_buffer[OFFSET_P2],
				          G_io_apdu_buffer + OFFSET_CDATA, G_io_apdu_buffer[OFFSET_LC], &flags, &tx);
c0d019fe:	7933      	ldrb	r3, [r6, #4]
				// Lookup and call the requested command handler.
				handler_fn_t *handlerFn = lookupHandler(G_io_apdu_buffer[OFFSET_INS]);
				if (!handlerFn) {
					THROW(0x6D00);
				}
				handlerFn(G_io_apdu_buffer[OFFSET_P1], G_io_apdu_buffer[OFFSET_P2],
c0d01a00:	78f1      	ldrb	r1, [r6, #3]
c0d01a02:	78b0      	ldrb	r0, [r6, #2]
c0d01a04:	aa11      	add	r2, sp, #68	; 0x44
c0d01a06:	466f      	mov	r7, sp
c0d01a08:	607a      	str	r2, [r7, #4]
c0d01a0a:	aa10      	add	r2, sp, #64	; 0x40
c0d01a0c:	603a      	str	r2, [r7, #0]
c0d01a0e:	1d72      	adds	r2, r6, #5
c0d01a10:	47a0      	blx	r4
					break;
				}
				G_io_apdu_buffer[tx++] = sw >> 8;
				G_io_apdu_buffer[tx++] = sw & 0xFF;
			}
			FINALLY {
c0d01a12:	f000 f9bb 	bl	c0d01d8c <try_context_get>
c0d01a16:	a904      	add	r1, sp, #16
c0d01a18:	4288      	cmp	r0, r1
c0d01a1a:	d103      	bne.n	c0d01a24 <one_main+0xe0>
c0d01a1c:	f000 f9b8 	bl	c0d01d90 <try_context_get_previous>
c0d01a20:	f000 f845 	bl	c0d01aae <try_context_set>
c0d01a24:	a804      	add	r0, sp, #16
			}
		}
		END_TRY;
c0d01a26:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d01a28:	2800      	cmp	r0, #0
c0d01a2a:	d098      	beq.n	c0d0195e <one_main+0x1a>
c0d01a2c:	f000 f9a9 	bl	c0d01d82 <os_longjmp>
c0d01a30:	a804      	add	r0, sp, #16
					THROW(0x6D00);
				}
				handlerFn(G_io_apdu_buffer[OFFSET_P1], G_io_apdu_buffer[OFFSET_P2],
				          G_io_apdu_buffer + OFFSET_CDATA, G_io_apdu_buffer[OFFSET_LC], &flags, &tx);
			}
			CATCH(EXCEPTION_IO_RESET) {
c0d01a32:	8505      	strh	r5, [r0, #40]	; 0x28
c0d01a34:	2010      	movs	r0, #16
c0d01a36:	f000 f9a4 	bl	c0d01d82 <os_longjmp>
				if (rx == 0) {
					THROW(EXCEPTION_IO_RESET);
				}
				// Malformed APDU.
				if (G_io_apdu_buffer[OFFSET_CLA] != CLA) {
					THROW(0x6E00);
c0d01a3a:	2037      	movs	r0, #55	; 0x37
c0d01a3c:	0240      	lsls	r0, r0, #9
c0d01a3e:	f000 f9a0 	bl	c0d01d82 <os_longjmp>
				}
				// Lookup and call the requested command handler.
				handler_fn_t *handlerFn = lookupHandler(G_io_apdu_buffer[OFFSET_INS]);
				if (!handlerFn) {
					THROW(0x6D00);
c0d01a42:	206d      	movs	r0, #109	; 0x6d
c0d01a44:	0200      	lsls	r0, r0, #8
c0d01a46:	f000 f99c 	bl	c0d01d82 <os_longjmp>
c0d01a4a:	46c0      	nop			; (mov r8, r8)
c0d01a4c:	20001d70 	.word	0x20001d70
c0d01a50:	000007ff 	.word	0x000007ff
c0d01a54:	fffff765 	.word	0xfffff765
c0d01a58:	ffffed1b 	.word	0xffffed1b
c0d01a5c:	ffffe927 	.word	0xffffe927

c0d01a60 <app_exit>:
		THROW(INVALID_PARAMETER);
	}
	return 0;
}

static void app_exit(void) {
c0d01a60:	b510      	push	{r4, lr}
c0d01a62:	b08c      	sub	sp, #48	; 0x30
c0d01a64:	ac01      	add	r4, sp, #4
	BEGIN_TRY_L(exit) {
		TRY_L(exit) {
c0d01a66:	4620      	mov	r0, r4
c0d01a68:	f003 fa62 	bl	c0d04f30 <setjmp>
c0d01a6c:	8520      	strh	r0, [r4, #40]	; 0x28
c0d01a6e:	490d      	ldr	r1, [pc, #52]	; (c0d01aa4 <app_exit+0x44>)
c0d01a70:	4208      	tst	r0, r1
c0d01a72:	d106      	bne.n	c0d01a82 <app_exit+0x22>
c0d01a74:	a801      	add	r0, sp, #4
c0d01a76:	f000 f81a 	bl	c0d01aae <try_context_set>
			os_sched_exit(-1);
c0d01a7a:	2000      	movs	r0, #0
c0d01a7c:	43c0      	mvns	r0, r0
c0d01a7e:	f001 faeb 	bl	c0d03058 <os_sched_exit>
		}
		FINALLY_L(exit) {
c0d01a82:	f000 f983 	bl	c0d01d8c <try_context_get>
c0d01a86:	a901      	add	r1, sp, #4
c0d01a88:	4288      	cmp	r0, r1
c0d01a8a:	d103      	bne.n	c0d01a94 <app_exit+0x34>
c0d01a8c:	f000 f980 	bl	c0d01d90 <try_context_get_previous>
c0d01a90:	f000 f80d 	bl	c0d01aae <try_context_set>
c0d01a94:	a801      	add	r0, sp, #4
		}
	}
	END_TRY_L(exit);
c0d01a96:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d01a98:	2800      	cmp	r0, #0
c0d01a9a:	d101      	bne.n	c0d01aa0 <app_exit+0x40>
}
c0d01a9c:	b00c      	add	sp, #48	; 0x30
c0d01a9e:	bd10      	pop	{r4, pc}
			os_sched_exit(-1);
		}
		FINALLY_L(exit) {
		}
	}
	END_TRY_L(exit);
c0d01aa0:	f000 f96f 	bl	c0d01d82 <os_longjmp>
c0d01aa4:	0000ffff 	.word	0x0000ffff

c0d01aa8 <os_boot>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d01aa8:	2000      	movs	r0, #0
c0d01aaa:	4681      	mov	r9, r0

void os_boot(void) {
  // TODO patch entry point when romming (f)
  // set the default try context to nothing
  try_context_set(NULL);
}
c0d01aac:	4770      	bx	lr

c0d01aae <try_context_set>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d01aae:	4681      	mov	r9, r0
}
c0d01ab0:	4770      	bx	lr
	...

c0d01ab4 <io_usb_hid_receive>:
volatile unsigned int   G_io_usb_hid_channel;
volatile unsigned int   G_io_usb_hid_remaining_length;
volatile unsigned int   G_io_usb_hid_sequence_number;
volatile unsigned char* G_io_usb_hid_current_buffer;

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
c0d01ab4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01ab6:	b081      	sub	sp, #4
c0d01ab8:	9200      	str	r2, [sp, #0]
c0d01aba:	460f      	mov	r7, r1
c0d01abc:	4605      	mov	r5, r0
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
c0d01abe:	4b49      	ldr	r3, [pc, #292]	; (c0d01be4 <io_usb_hid_receive+0x130>)
c0d01ac0:	429f      	cmp	r7, r3
c0d01ac2:	d00f      	beq.n	c0d01ae4 <io_usb_hid_receive+0x30>
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d01ac4:	4c47      	ldr	r4, [pc, #284]	; (c0d01be4 <io_usb_hid_receive+0x130>)
c0d01ac6:	2640      	movs	r6, #64	; 0x40
c0d01ac8:	4620      	mov	r0, r4
c0d01aca:	4631      	mov	r1, r6
c0d01acc:	f003 f9dc 	bl	c0d04e88 <__aeabi_memclr>
c0d01ad0:	9800      	ldr	r0, [sp, #0]

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
c0d01ad2:	2840      	cmp	r0, #64	; 0x40
c0d01ad4:	4602      	mov	r2, r0
c0d01ad6:	d300      	bcc.n	c0d01ada <io_usb_hid_receive+0x26>
c0d01ad8:	4632      	mov	r2, r6
c0d01ada:	4620      	mov	r0, r4
c0d01adc:	4639      	mov	r1, r7
c0d01ade:	f000 f89c 	bl	c0d01c1a <os_memmove>
c0d01ae2:	4b40      	ldr	r3, [pc, #256]	; (c0d01be4 <io_usb_hid_receive+0x130>)
c0d01ae4:	7898      	ldrb	r0, [r3, #2]
  }

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
c0d01ae6:	2801      	cmp	r0, #1
c0d01ae8:	dc0b      	bgt.n	c0d01b02 <io_usb_hid_receive+0x4e>
c0d01aea:	2800      	cmp	r0, #0
c0d01aec:	d02a      	beq.n	c0d01b44 <io_usb_hid_receive+0x90>
c0d01aee:	2801      	cmp	r0, #1
c0d01af0:	d16a      	bne.n	c0d01bc8 <io_usb_hid_receive+0x114>
    // await for the next chunk
    goto apdu_reset;

  case 0x01: // ALLOCATE CHANNEL
    // do not reset the current apdu reception if any
    cx_rng(G_io_usb_ep_buffer+3, 4);
c0d01af2:	1cd8      	adds	r0, r3, #3
c0d01af4:	2104      	movs	r1, #4
c0d01af6:	461c      	mov	r4, r3
c0d01af8:	f001 f9e2 	bl	c0d02ec0 <cx_rng>
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d01afc:	2140      	movs	r1, #64	; 0x40
c0d01afe:	4620      	mov	r0, r4
c0d01b00:	e02b      	b.n	c0d01b5a <io_usb_hid_receive+0xa6>
c0d01b02:	2802      	cmp	r0, #2
c0d01b04:	d027      	beq.n	c0d01b56 <io_usb_hid_receive+0xa2>
c0d01b06:	2805      	cmp	r0, #5
c0d01b08:	d15e      	bne.n	c0d01bc8 <io_usb_hid_receive+0x114>

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
  case 0x05:
    // ensure sequence idx is 0 for the first chunk ! 
    if ((unsigned int)U2BE(G_io_usb_ep_buffer, 3) != (unsigned int)G_io_usb_hid_sequence_number) {
c0d01b0a:	7918      	ldrb	r0, [r3, #4]
c0d01b0c:	78d9      	ldrb	r1, [r3, #3]
c0d01b0e:	0209      	lsls	r1, r1, #8
c0d01b10:	4301      	orrs	r1, r0
c0d01b12:	4a35      	ldr	r2, [pc, #212]	; (c0d01be8 <io_usb_hid_receive+0x134>)
c0d01b14:	6810      	ldr	r0, [r2, #0]
c0d01b16:	2400      	movs	r4, #0
c0d01b18:	4281      	cmp	r1, r0
c0d01b1a:	d15b      	bne.n	c0d01bd4 <io_usb_hid_receive+0x120>
c0d01b1c:	4e33      	ldr	r6, [pc, #204]	; (c0d01bec <io_usb_hid_receive+0x138>)
      // ignore packet
      goto apdu_reset;
    }
    // cid, tag, seq
    l -= 2+1+2;
c0d01b1e:	9800      	ldr	r0, [sp, #0]
c0d01b20:	1980      	adds	r0, r0, r6
c0d01b22:	1f07      	subs	r7, r0, #4
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
c0d01b24:	6810      	ldr	r0, [r2, #0]
c0d01b26:	2800      	cmp	r0, #0
c0d01b28:	d01a      	beq.n	c0d01b60 <io_usb_hid_receive+0xac>
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
    }
    else {
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (l > G_io_usb_hid_remaining_length) {
c0d01b2a:	4639      	mov	r1, r7
c0d01b2c:	4031      	ands	r1, r6
c0d01b2e:	4830      	ldr	r0, [pc, #192]	; (c0d01bf0 <io_usb_hid_receive+0x13c>)
c0d01b30:	6802      	ldr	r2, [r0, #0]
c0d01b32:	4291      	cmp	r1, r2
c0d01b34:	d900      	bls.n	c0d01b38 <io_usb_hid_receive+0x84>
        l = G_io_usb_hid_remaining_length;
c0d01b36:	6807      	ldr	r7, [r0, #0]
      }

      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
c0d01b38:	463a      	mov	r2, r7
c0d01b3a:	4032      	ands	r2, r6
c0d01b3c:	482d      	ldr	r0, [pc, #180]	; (c0d01bf4 <io_usb_hid_receive+0x140>)
c0d01b3e:	6800      	ldr	r0, [r0, #0]
c0d01b40:	1d59      	adds	r1, r3, #5
c0d01b42:	e031      	b.n	c0d01ba8 <io_usb_hid_receive+0xf4>
c0d01b44:	2400      	movs	r4, #0
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d01b46:	719c      	strb	r4, [r3, #6]
c0d01b48:	715c      	strb	r4, [r3, #5]
c0d01b4a:	711c      	strb	r4, [r3, #4]
c0d01b4c:	70dc      	strb	r4, [r3, #3]

  case 0x00: // get version ID
    // do not reset the current apdu reception if any
    os_memset(G_io_usb_ep_buffer+3, 0, 4); // PROTOCOL VERSION is 0
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d01b4e:	2140      	movs	r1, #64	; 0x40
c0d01b50:	4618      	mov	r0, r3
c0d01b52:	47a8      	blx	r5
c0d01b54:	e03e      	b.n	c0d01bd4 <io_usb_hid_receive+0x120>
    goto apdu_reset;

  case 0x02: // ECHO|PING
    // do not reset the current apdu reception if any
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d01b56:	4823      	ldr	r0, [pc, #140]	; (c0d01be4 <io_usb_hid_receive+0x130>)
c0d01b58:	2140      	movs	r1, #64	; 0x40
c0d01b5a:	47a8      	blx	r5
c0d01b5c:	2400      	movs	r4, #0
c0d01b5e:	e039      	b.n	c0d01bd4 <io_usb_hid_receive+0x120>
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
      /// This is the apdu first chunk
      // total apdu size to receive
      G_io_usb_hid_total_length = U2BE(G_io_usb_ep_buffer, 5); //(G_io_usb_ep_buffer[5]<<8)+(G_io_usb_ep_buffer[6]&0xFF);
c0d01b60:	7998      	ldrb	r0, [r3, #6]
c0d01b62:	7959      	ldrb	r1, [r3, #5]
c0d01b64:	0209      	lsls	r1, r1, #8
c0d01b66:	4301      	orrs	r1, r0
c0d01b68:	4823      	ldr	r0, [pc, #140]	; (c0d01bf8 <io_usb_hid_receive+0x144>)
c0d01b6a:	6001      	str	r1, [r0, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
c0d01b6c:	6801      	ldr	r1, [r0, #0]
c0d01b6e:	2241      	movs	r2, #65	; 0x41
c0d01b70:	0092      	lsls	r2, r2, #2
c0d01b72:	4291      	cmp	r1, r2
c0d01b74:	d82e      	bhi.n	c0d01bd4 <io_usb_hid_receive+0x120>
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
      // compute remaining size to receive
      G_io_usb_hid_remaining_length = G_io_usb_hid_total_length;
c0d01b76:	6801      	ldr	r1, [r0, #0]
c0d01b78:	481d      	ldr	r0, [pc, #116]	; (c0d01bf0 <io_usb_hid_receive+0x13c>)
c0d01b7a:	6001      	str	r1, [r0, #0]
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d01b7c:	491d      	ldr	r1, [pc, #116]	; (c0d01bf4 <io_usb_hid_receive+0x140>)
c0d01b7e:	4a1f      	ldr	r2, [pc, #124]	; (c0d01bfc <io_usb_hid_receive+0x148>)
c0d01b80:	600a      	str	r2, [r1, #0]

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);
c0d01b82:	7859      	ldrb	r1, [r3, #1]
c0d01b84:	781a      	ldrb	r2, [r3, #0]
c0d01b86:	0212      	lsls	r2, r2, #8
c0d01b88:	430a      	orrs	r2, r1
c0d01b8a:	491d      	ldr	r1, [pc, #116]	; (c0d01c00 <io_usb_hid_receive+0x14c>)
c0d01b8c:	600a      	str	r2, [r1, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
c0d01b8e:	491d      	ldr	r1, [pc, #116]	; (c0d01c04 <io_usb_hid_receive+0x150>)
c0d01b90:	9a00      	ldr	r2, [sp, #0]
c0d01b92:	1857      	adds	r7, r2, r1
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);

      if (l > G_io_usb_hid_remaining_length) {
c0d01b94:	4639      	mov	r1, r7
c0d01b96:	4031      	ands	r1, r6
c0d01b98:	6802      	ldr	r2, [r0, #0]
c0d01b9a:	4291      	cmp	r1, r2
c0d01b9c:	d900      	bls.n	c0d01ba0 <io_usb_hid_receive+0xec>
        l = G_io_usb_hid_remaining_length;
c0d01b9e:	6807      	ldr	r7, [r0, #0]
      }
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
c0d01ba0:	463a      	mov	r2, r7
c0d01ba2:	4032      	ands	r2, r6
c0d01ba4:	1dd9      	adds	r1, r3, #7
c0d01ba6:	4815      	ldr	r0, [pc, #84]	; (c0d01bfc <io_usb_hid_receive+0x148>)
c0d01ba8:	f000 f837 	bl	c0d01c1a <os_memmove>
      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
    }
    // factorize (f)
    G_io_usb_hid_current_buffer += l;
c0d01bac:	4037      	ands	r7, r6
c0d01bae:	4811      	ldr	r0, [pc, #68]	; (c0d01bf4 <io_usb_hid_receive+0x140>)
c0d01bb0:	6801      	ldr	r1, [r0, #0]
c0d01bb2:	19c9      	adds	r1, r1, r7
c0d01bb4:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_remaining_length -= l;
c0d01bb6:	480e      	ldr	r0, [pc, #56]	; (c0d01bf0 <io_usb_hid_receive+0x13c>)
c0d01bb8:	6801      	ldr	r1, [r0, #0]
c0d01bba:	1bc9      	subs	r1, r1, r7
c0d01bbc:	6001      	str	r1, [r0, #0]
c0d01bbe:	480a      	ldr	r0, [pc, #40]	; (c0d01be8 <io_usb_hid_receive+0x134>)
c0d01bc0:	4601      	mov	r1, r0
    G_io_usb_hid_sequence_number++;
c0d01bc2:	6808      	ldr	r0, [r1, #0]
c0d01bc4:	1c40      	adds	r0, r0, #1
c0d01bc6:	6008      	str	r0, [r1, #0]
    // await for the next chunk
    goto apdu_reset;
  }

  // if more data to be received, notify it
  if (G_io_usb_hid_remaining_length) {
c0d01bc8:	4809      	ldr	r0, [pc, #36]	; (c0d01bf0 <io_usb_hid_receive+0x13c>)
c0d01bca:	6801      	ldr	r1, [r0, #0]
c0d01bcc:	2001      	movs	r0, #1
c0d01bce:	2402      	movs	r4, #2
c0d01bd0:	2900      	cmp	r1, #0
c0d01bd2:	d103      	bne.n	c0d01bdc <io_usb_hid_receive+0x128>
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d01bd4:	4804      	ldr	r0, [pc, #16]	; (c0d01be8 <io_usb_hid_receive+0x134>)
c0d01bd6:	2100      	movs	r1, #0
c0d01bd8:	6001      	str	r1, [r0, #0]
c0d01bda:	4620      	mov	r0, r4
  return IO_USB_APDU_RECEIVED;

apdu_reset:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}
c0d01bdc:	b2c0      	uxtb	r0, r0
c0d01bde:	b001      	add	sp, #4
c0d01be0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01be2:	46c0      	nop			; (mov r8, r8)
c0d01be4:	20001ef0 	.word	0x20001ef0
c0d01be8:	20001d64 	.word	0x20001d64
c0d01bec:	0000ffff 	.word	0x0000ffff
c0d01bf0:	20001d6c 	.word	0x20001d6c
c0d01bf4:	20001e74 	.word	0x20001e74
c0d01bf8:	20001d68 	.word	0x20001d68
c0d01bfc:	20001d70 	.word	0x20001d70
c0d01c00:	20001e78 	.word	0x20001e78
c0d01c04:	0001fff9 	.word	0x0001fff9

c0d01c08 <os_memset>:
    }
  }
#undef DSTCHAR
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
c0d01c08:	b580      	push	{r7, lr}
c0d01c0a:	460b      	mov	r3, r1
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
c0d01c0c:	2a00      	cmp	r2, #0
c0d01c0e:	d003      	beq.n	c0d01c18 <os_memset+0x10>
    DSTCHAR[length] = c;
c0d01c10:	4611      	mov	r1, r2
c0d01c12:	461a      	mov	r2, r3
c0d01c14:	f003 f93e 	bl	c0d04e94 <__aeabi_memset>
  }
#undef DSTCHAR
}
c0d01c18:	bd80      	pop	{r7, pc}

c0d01c1a <os_memmove>:
  }
}

#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
c0d01c1a:	b5b0      	push	{r4, r5, r7, lr}
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d01c1c:	4288      	cmp	r0, r1
c0d01c1e:	d90d      	bls.n	c0d01c3c <os_memmove+0x22>
    while(length--) {
c0d01c20:	2a00      	cmp	r2, #0
c0d01c22:	d014      	beq.n	c0d01c4e <os_memmove+0x34>
c0d01c24:	1e49      	subs	r1, r1, #1
c0d01c26:	4252      	negs	r2, r2
c0d01c28:	1e40      	subs	r0, r0, #1
c0d01c2a:	2300      	movs	r3, #0
c0d01c2c:	43db      	mvns	r3, r3
      DSTCHAR[length] = SRCCHAR[length];
c0d01c2e:	461c      	mov	r4, r3
c0d01c30:	4354      	muls	r4, r2
c0d01c32:	5d0d      	ldrb	r5, [r1, r4]
c0d01c34:	5505      	strb	r5, [r0, r4]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d01c36:	1c52      	adds	r2, r2, #1
c0d01c38:	d1f9      	bne.n	c0d01c2e <os_memmove+0x14>
c0d01c3a:	e008      	b.n	c0d01c4e <os_memmove+0x34>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d01c3c:	2a00      	cmp	r2, #0
c0d01c3e:	d006      	beq.n	c0d01c4e <os_memmove+0x34>
c0d01c40:	2300      	movs	r3, #0
      DSTCHAR[l] = SRCCHAR[l];
c0d01c42:	b29c      	uxth	r4, r3
c0d01c44:	5d0d      	ldrb	r5, [r1, r4]
c0d01c46:	5505      	strb	r5, [r0, r4]
      l++;
c0d01c48:	1c5b      	adds	r3, r3, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d01c4a:	1e52      	subs	r2, r2, #1
c0d01c4c:	d1f9      	bne.n	c0d01c42 <os_memmove+0x28>
      DSTCHAR[l] = SRCCHAR[l];
      l++;
    }
  }
#undef DSTCHAR
}
c0d01c4e:	bdb0      	pop	{r4, r5, r7, pc}

c0d01c50 <io_usb_hid_init>:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d01c50:	4801      	ldr	r0, [pc, #4]	; (c0d01c58 <io_usb_hid_init+0x8>)
c0d01c52:	2100      	movs	r1, #0
c0d01c54:	6001      	str	r1, [r0, #0]
  //G_io_usb_hid_remaining_length = 0; // not really needed
  //G_io_usb_hid_total_length = 0; // not really needed
  //G_io_usb_hid_current_buffer = G_io_apdu_buffer; // not really needed
}
c0d01c56:	4770      	bx	lr
c0d01c58:	20001d64 	.word	0x20001d64

c0d01c5c <io_usb_hid_sent>:

/**
 * sent the next io_usb_hid transport chunk (rx on the host, tx on the device)
 */
void io_usb_hid_sent(io_send_t sndfct) {
c0d01c5c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01c5e:	b081      	sub	sp, #4
  unsigned int l;

  // only prepare next chunk if some data to be sent remain
  if (G_io_usb_hid_remaining_length) {
c0d01c60:	4f29      	ldr	r7, [pc, #164]	; (c0d01d08 <io_usb_hid_sent+0xac>)
c0d01c62:	6839      	ldr	r1, [r7, #0]
c0d01c64:	2900      	cmp	r1, #0
c0d01c66:	d026      	beq.n	c0d01cb6 <io_usb_hid_sent+0x5a>
c0d01c68:	9000      	str	r0, [sp, #0]
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d01c6a:	4c28      	ldr	r4, [pc, #160]	; (c0d01d0c <io_usb_hid_sent+0xb0>)
c0d01c6c:	1d66      	adds	r6, r4, #5
c0d01c6e:	2539      	movs	r5, #57	; 0x39
c0d01c70:	4630      	mov	r0, r6
c0d01c72:	4629      	mov	r1, r5
c0d01c74:	f003 f908 	bl	c0d04e88 <__aeabi_memclr>
  if (G_io_usb_hid_remaining_length) {
    // fill the chunk
    os_memset(G_io_usb_ep_buffer, 0, IO_HID_EP_LENGTH-2);

    // keep the channel identifier
    G_io_usb_ep_buffer[0] = (G_io_usb_hid_channel>>8)&0xFF;
c0d01c78:	4825      	ldr	r0, [pc, #148]	; (c0d01d10 <io_usb_hid_sent+0xb4>)
c0d01c7a:	6801      	ldr	r1, [r0, #0]
c0d01c7c:	0a09      	lsrs	r1, r1, #8
c0d01c7e:	7021      	strb	r1, [r4, #0]
    G_io_usb_ep_buffer[1] = G_io_usb_hid_channel&0xFF;
c0d01c80:	6800      	ldr	r0, [r0, #0]
c0d01c82:	7060      	strb	r0, [r4, #1]
c0d01c84:	2005      	movs	r0, #5
    G_io_usb_ep_buffer[2] = 0x05;
c0d01c86:	70a0      	strb	r0, [r4, #2]
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
c0d01c88:	4a22      	ldr	r2, [pc, #136]	; (c0d01d14 <io_usb_hid_sent+0xb8>)
c0d01c8a:	6810      	ldr	r0, [r2, #0]
c0d01c8c:	0a00      	lsrs	r0, r0, #8
c0d01c8e:	70e0      	strb	r0, [r4, #3]
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;
c0d01c90:	6810      	ldr	r0, [r2, #0]
c0d01c92:	7120      	strb	r0, [r4, #4]

    if (G_io_usb_hid_sequence_number == 0) {
c0d01c94:	6811      	ldr	r1, [r2, #0]
c0d01c96:	6838      	ldr	r0, [r7, #0]
c0d01c98:	2900      	cmp	r1, #0
c0d01c9a:	d014      	beq.n	c0d01cc6 <io_usb_hid_sent+0x6a>
c0d01c9c:	4614      	mov	r4, r2
c0d01c9e:	253b      	movs	r5, #59	; 0x3b
      G_io_usb_hid_current_buffer += l;
      G_io_usb_hid_remaining_length -= l;
      l += 7;
    }
    else {
      l = ((G_io_usb_hid_remaining_length>IO_HID_EP_LENGTH-5) ? IO_HID_EP_LENGTH-5 : G_io_usb_hid_remaining_length);
c0d01ca0:	283b      	cmp	r0, #59	; 0x3b
c0d01ca2:	d800      	bhi.n	c0d01ca6 <io_usb_hid_sent+0x4a>
c0d01ca4:	683d      	ldr	r5, [r7, #0]
      os_memmove(G_io_usb_ep_buffer+5, (const void*)G_io_usb_hid_current_buffer, l);
c0d01ca6:	481c      	ldr	r0, [pc, #112]	; (c0d01d18 <io_usb_hid_sent+0xbc>)
c0d01ca8:	6801      	ldr	r1, [r0, #0]
c0d01caa:	4630      	mov	r0, r6
c0d01cac:	462a      	mov	r2, r5
c0d01cae:	f7ff ffb4 	bl	c0d01c1a <os_memmove>
c0d01cb2:	9a00      	ldr	r2, [sp, #0]
c0d01cb4:	e018      	b.n	c0d01ce8 <io_usb_hid_sent+0x8c>
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
  }
  // cleanup when everything has been sent (ack for the last sent usb in packet)
  else {
    G_io_usb_hid_sequence_number = 0; 
c0d01cb6:	4817      	ldr	r0, [pc, #92]	; (c0d01d14 <io_usb_hid_sent+0xb8>)
c0d01cb8:	2100      	movs	r1, #0
c0d01cba:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_current_buffer = NULL;
c0d01cbc:	4816      	ldr	r0, [pc, #88]	; (c0d01d18 <io_usb_hid_sent+0xbc>)
c0d01cbe:	6001      	str	r1, [r0, #0]

    // we sent the whole response
    G_io_apdu_state = APDU_IDLE;
c0d01cc0:	4816      	ldr	r0, [pc, #88]	; (c0d01d1c <io_usb_hid_sent+0xc0>)
c0d01cc2:	7001      	strb	r1, [r0, #0]
c0d01cc4:	e01d      	b.n	c0d01d02 <io_usb_hid_sent+0xa6>
c0d01cc6:	4616      	mov	r6, r2
    G_io_usb_ep_buffer[2] = 0x05;
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;

    if (G_io_usb_hid_sequence_number == 0) {
      l = ((G_io_usb_hid_remaining_length>IO_HID_EP_LENGTH-7) ? IO_HID_EP_LENGTH-7 : G_io_usb_hid_remaining_length);
c0d01cc8:	2839      	cmp	r0, #57	; 0x39
c0d01cca:	d800      	bhi.n	c0d01cce <io_usb_hid_sent+0x72>
c0d01ccc:	683d      	ldr	r5, [r7, #0]
      G_io_usb_ep_buffer[5] = G_io_usb_hid_remaining_length>>8;
c0d01cce:	6838      	ldr	r0, [r7, #0]
c0d01cd0:	0a00      	lsrs	r0, r0, #8
c0d01cd2:	7160      	strb	r0, [r4, #5]
      G_io_usb_ep_buffer[6] = G_io_usb_hid_remaining_length;
c0d01cd4:	6838      	ldr	r0, [r7, #0]
c0d01cd6:	71a0      	strb	r0, [r4, #6]
      os_memmove(G_io_usb_ep_buffer+7, (const void*)G_io_usb_hid_current_buffer, l);
c0d01cd8:	480f      	ldr	r0, [pc, #60]	; (c0d01d18 <io_usb_hid_sent+0xbc>)
c0d01cda:	6801      	ldr	r1, [r0, #0]
c0d01cdc:	1de0      	adds	r0, r4, #7
c0d01cde:	462a      	mov	r2, r5
c0d01ce0:	f7ff ff9b 	bl	c0d01c1a <os_memmove>
c0d01ce4:	9a00      	ldr	r2, [sp, #0]
c0d01ce6:	4634      	mov	r4, r6
c0d01ce8:	480b      	ldr	r0, [pc, #44]	; (c0d01d18 <io_usb_hid_sent+0xbc>)
c0d01cea:	6801      	ldr	r1, [r0, #0]
c0d01cec:	1949      	adds	r1, r1, r5
c0d01cee:	6001      	str	r1, [r0, #0]
c0d01cf0:	6838      	ldr	r0, [r7, #0]
c0d01cf2:	1b40      	subs	r0, r0, r5
c0d01cf4:	6038      	str	r0, [r7, #0]
      G_io_usb_hid_current_buffer += l;
      G_io_usb_hid_remaining_length -= l;
      l += 5;
    }
    // prepare next chunk numbering
    G_io_usb_hid_sequence_number++;
c0d01cf6:	6820      	ldr	r0, [r4, #0]
c0d01cf8:	1c40      	adds	r0, r0, #1
c0d01cfa:	6020      	str	r0, [r4, #0]
    // send the chunk
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
c0d01cfc:	4803      	ldr	r0, [pc, #12]	; (c0d01d0c <io_usb_hid_sent+0xb0>)
c0d01cfe:	2140      	movs	r1, #64	; 0x40
c0d01d00:	4790      	blx	r2
    G_io_usb_hid_current_buffer = NULL;

    // we sent the whole response
    G_io_apdu_state = APDU_IDLE;
  }
}
c0d01d02:	b001      	add	sp, #4
c0d01d04:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01d06:	46c0      	nop			; (mov r8, r8)
c0d01d08:	20001d6c 	.word	0x20001d6c
c0d01d0c:	20001ef0 	.word	0x20001ef0
c0d01d10:	20001e78 	.word	0x20001e78
c0d01d14:	20001d64 	.word	0x20001d64
c0d01d18:	20001e74 	.word	0x20001e74
c0d01d1c:	20001e92 	.word	0x20001e92

c0d01d20 <io_usb_hid_send>:

void io_usb_hid_send(io_send_t sndfct, unsigned short sndlength) {
c0d01d20:	b580      	push	{r7, lr}
  // perform send
  if (sndlength) {
c0d01d22:	2900      	cmp	r1, #0
c0d01d24:	d00b      	beq.n	c0d01d3e <io_usb_hid_send+0x1e>
    G_io_usb_hid_sequence_number = 0; 
c0d01d26:	4a06      	ldr	r2, [pc, #24]	; (c0d01d40 <io_usb_hid_send+0x20>)
c0d01d28:	2300      	movs	r3, #0
c0d01d2a:	6013      	str	r3, [r2, #0]
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d01d2c:	4a05      	ldr	r2, [pc, #20]	; (c0d01d44 <io_usb_hid_send+0x24>)
c0d01d2e:	4b06      	ldr	r3, [pc, #24]	; (c0d01d48 <io_usb_hid_send+0x28>)
c0d01d30:	6013      	str	r3, [r2, #0]
    G_io_usb_hid_remaining_length = sndlength;
c0d01d32:	4a06      	ldr	r2, [pc, #24]	; (c0d01d4c <io_usb_hid_send+0x2c>)
c0d01d34:	6011      	str	r1, [r2, #0]
    G_io_usb_hid_total_length = sndlength;
c0d01d36:	4a06      	ldr	r2, [pc, #24]	; (c0d01d50 <io_usb_hid_send+0x30>)
c0d01d38:	6011      	str	r1, [r2, #0]
    io_usb_hid_sent(sndfct);
c0d01d3a:	f7ff ff8f 	bl	c0d01c5c <io_usb_hid_sent>
  }
}
c0d01d3e:	bd80      	pop	{r7, pc}
c0d01d40:	20001d64 	.word	0x20001d64
c0d01d44:	20001e74 	.word	0x20001e74
c0d01d48:	20001d70 	.word	0x20001d70
c0d01d4c:	20001d6c 	.word	0x20001d6c
c0d01d50:	20001d68 	.word	0x20001d68

c0d01d54 <os_memcmp>:
    DSTCHAR[length] = c;
  }
#undef DSTCHAR
}

char os_memcmp(const void WIDE * buf1, const void WIDE * buf2, unsigned int length) {
c0d01d54:	b570      	push	{r4, r5, r6, lr}
#define BUF1 ((unsigned char const WIDE *)buf1)
#define BUF2 ((unsigned char const WIDE *)buf2)
  while(length--) {
c0d01d56:	1e43      	subs	r3, r0, #1
c0d01d58:	1e49      	subs	r1, r1, #1
c0d01d5a:	4252      	negs	r2, r2
c0d01d5c:	2000      	movs	r0, #0
c0d01d5e:	43c4      	mvns	r4, r0
c0d01d60:	2a00      	cmp	r2, #0
c0d01d62:	d00c      	beq.n	c0d01d7e <os_memcmp+0x2a>
    if (BUF1[length] != BUF2[length]) {
c0d01d64:	4626      	mov	r6, r4
c0d01d66:	4356      	muls	r6, r2
c0d01d68:	5d8d      	ldrb	r5, [r1, r6]
c0d01d6a:	5d9e      	ldrb	r6, [r3, r6]
c0d01d6c:	1c52      	adds	r2, r2, #1
c0d01d6e:	42ae      	cmp	r6, r5
c0d01d70:	d0f6      	beq.n	c0d01d60 <os_memcmp+0xc>
      return (BUF1[length] > BUF2[length])? 1:-1;
c0d01d72:	2000      	movs	r0, #0
c0d01d74:	43c1      	mvns	r1, r0
c0d01d76:	2001      	movs	r0, #1
c0d01d78:	42ae      	cmp	r6, r5
c0d01d7a:	d800      	bhi.n	c0d01d7e <os_memcmp+0x2a>
c0d01d7c:	4608      	mov	r0, r1
  }
  return 0;
#undef BUF1
#undef BUF2

}
c0d01d7e:	b2c0      	uxtb	r0, r0
c0d01d80:	bd70      	pop	{r4, r5, r6, pc}

c0d01d82 <os_longjmp>:
void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0d01d82:	b580      	push	{r7, lr}
c0d01d84:	4601      	mov	r1, r0
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d01d86:	4648      	mov	r0, r9
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
  longjmp(try_context_get()->jmp_buf, exception);
c0d01d88:	f003 f8de 	bl	c0d04f48 <longjmp>

c0d01d8c <try_context_get>:
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d01d8c:	4648      	mov	r0, r9
  return current_ctx;
c0d01d8e:	4770      	bx	lr

c0d01d90 <try_context_get_previous>:
}

try_context_t* try_context_get_previous(void) {
c0d01d90:	2000      	movs	r0, #0
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d01d92:	4649      	mov	r1, r9

  // first context reached ?
  if (current_ctx == NULL) {
c0d01d94:	2900      	cmp	r1, #0
c0d01d96:	d000      	beq.n	c0d01d9a <try_context_get_previous+0xa>
  }

  // return r9 content saved on the current context. It links to the previous context.
  // r4 r5 r6 r7 r8 r9 r10 r11 sp lr
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
c0d01d98:	6948      	ldr	r0, [r1, #20]
}
c0d01d9a:	4770      	bx	lr

c0d01d9c <io_seproxyhal_general_status>:

#ifndef IO_RAPDU_TRANSMIT_TIMEOUT_MS 
#define IO_RAPDU_TRANSMIT_TIMEOUT_MS 2000UL
#endif // IO_RAPDU_TRANSMIT_TIMEOUT_MS

void io_seproxyhal_general_status(void) {
c0d01d9c:	b580      	push	{r7, lr}
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
c0d01d9e:	f001 f9cb 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d01da2:	2800      	cmp	r0, #0
c0d01da4:	d10b      	bne.n	c0d01dbe <io_seproxyhal_general_status+0x22>
    return;
  }
  // send the general status
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_GENERAL_STATUS;
c0d01da6:	4806      	ldr	r0, [pc, #24]	; (c0d01dc0 <io_seproxyhal_general_status+0x24>)
c0d01da8:	2160      	movs	r1, #96	; 0x60
c0d01daa:	7001      	strb	r1, [r0, #0]
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d01dac:	2100      	movs	r1, #0
c0d01dae:	7041      	strb	r1, [r0, #1]
  G_io_seproxyhal_spi_buffer[2] = 2;
c0d01db0:	2202      	movs	r2, #2
c0d01db2:	7082      	strb	r2, [r0, #2]
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND>>8;
c0d01db4:	70c1      	strb	r1, [r0, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND;
c0d01db6:	7101      	strb	r1, [r0, #4]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
c0d01db8:	2105      	movs	r1, #5
c0d01dba:	f001 f9a7 	bl	c0d0310c <io_seproxyhal_spi_send>
}
c0d01dbe:	bd80      	pop	{r7, pc}
c0d01dc0:	20001800 	.word	0x20001800

c0d01dc4 <io_seproxyhal_handle_usb_event>:
} G_io_usb_ep_timeouts[IO_USB_MAX_ENDPOINTS];
#include "usbd_def.h"
#include "usbd_core.h"
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
c0d01dc4:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[3]) {
c0d01dc6:	4819      	ldr	r0, [pc, #100]	; (c0d01e2c <io_seproxyhal_handle_usb_event+0x68>)
c0d01dc8:	78c0      	ldrb	r0, [r0, #3]
c0d01dca:	2803      	cmp	r0, #3
c0d01dcc:	dc07      	bgt.n	c0d01dde <io_seproxyhal_handle_usb_event+0x1a>
c0d01dce:	2801      	cmp	r0, #1
c0d01dd0:	d00d      	beq.n	c0d01dee <io_seproxyhal_handle_usb_event+0x2a>
c0d01dd2:	2802      	cmp	r0, #2
c0d01dd4:	d126      	bne.n	c0d01e24 <io_seproxyhal_handle_usb_event+0x60>
      }
      os_memset(G_io_usb_ep_xfer_len, 0, sizeof(G_io_usb_ep_xfer_len));
      os_memset(G_io_usb_ep_timeouts, 0, sizeof(G_io_usb_ep_timeouts));
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
c0d01dd6:	4816      	ldr	r0, [pc, #88]	; (c0d01e30 <io_seproxyhal_handle_usb_event+0x6c>)
c0d01dd8:	f002 faa5 	bl	c0d04326 <USBD_LL_SOF>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d01ddc:	bd10      	pop	{r4, pc}
c0d01dde:	2804      	cmp	r0, #4
c0d01de0:	d01d      	beq.n	c0d01e1e <io_seproxyhal_handle_usb_event+0x5a>
c0d01de2:	2808      	cmp	r0, #8
c0d01de4:	d11e      	bne.n	c0d01e24 <io_seproxyhal_handle_usb_event+0x60>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
c0d01de6:	4812      	ldr	r0, [pc, #72]	; (c0d01e30 <io_seproxyhal_handle_usb_event+0x6c>)
c0d01de8:	f002 fa9b 	bl	c0d04322 <USBD_LL_Resume>
      break;
  }
}
c0d01dec:	bd10      	pop	{r4, pc}
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
  switch(G_io_seproxyhal_spi_buffer[3]) {
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
c0d01dee:	4c10      	ldr	r4, [pc, #64]	; (c0d01e30 <io_seproxyhal_handle_usb_event+0x6c>)
c0d01df0:	2101      	movs	r1, #1
c0d01df2:	4620      	mov	r0, r4
c0d01df4:	f002 fa90 	bl	c0d04318 <USBD_LL_SetSpeed>
      USBD_LL_Reset(&USBD_Device);
c0d01df8:	4620      	mov	r0, r4
c0d01dfa:	f002 fa6c 	bl	c0d042d6 <USBD_LL_Reset>
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
c0d01dfe:	480d      	ldr	r0, [pc, #52]	; (c0d01e34 <io_seproxyhal_handle_usb_event+0x70>)
c0d01e00:	7800      	ldrb	r0, [r0, #0]
c0d01e02:	2800      	cmp	r0, #0
c0d01e04:	d10f      	bne.n	c0d01e26 <io_seproxyhal_handle_usb_event+0x62>
        THROW(EXCEPTION_IO_RESET);
      }
      os_memset(G_io_usb_ep_xfer_len, 0, sizeof(G_io_usb_ep_xfer_len));
c0d01e06:	480c      	ldr	r0, [pc, #48]	; (c0d01e38 <io_seproxyhal_handle_usb_event+0x74>)
c0d01e08:	2400      	movs	r4, #0
c0d01e0a:	2207      	movs	r2, #7
c0d01e0c:	4621      	mov	r1, r4
c0d01e0e:	f7ff fefb 	bl	c0d01c08 <os_memset>
      os_memset(G_io_usb_ep_timeouts, 0, sizeof(G_io_usb_ep_timeouts));
c0d01e12:	480a      	ldr	r0, [pc, #40]	; (c0d01e3c <io_seproxyhal_handle_usb_event+0x78>)
c0d01e14:	220e      	movs	r2, #14
c0d01e16:	4621      	mov	r1, r4
c0d01e18:	f7ff fef6 	bl	c0d01c08 <os_memset>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d01e1c:	bd10      	pop	{r4, pc}
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
c0d01e1e:	4804      	ldr	r0, [pc, #16]	; (c0d01e30 <io_seproxyhal_handle_usb_event+0x6c>)
c0d01e20:	f002 fa7d 	bl	c0d0431e <USBD_LL_Suspend>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d01e24:	bd10      	pop	{r4, pc}
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
      USBD_LL_Reset(&USBD_Device);
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
        THROW(EXCEPTION_IO_RESET);
c0d01e26:	2010      	movs	r0, #16
c0d01e28:	f7ff ffab 	bl	c0d01d82 <os_longjmp>
c0d01e2c:	20001800 	.word	0x20001800
c0d01e30:	20001f38 	.word	0x20001f38
c0d01e34:	20001e7c 	.word	0x20001e7c
c0d01e38:	20001e7d 	.word	0x20001e7d
c0d01e3c:	20001e84 	.word	0x20001e84

c0d01e40 <io_seproxyhal_get_ep_rx_size>:
      break;
  }
}

uint16_t io_seproxyhal_get_ep_rx_size(uint8_t epnum) {
  return G_io_usb_ep_xfer_len[epnum&0x7F];
c0d01e40:	217f      	movs	r1, #127	; 0x7f
c0d01e42:	4001      	ands	r1, r0
c0d01e44:	4801      	ldr	r0, [pc, #4]	; (c0d01e4c <io_seproxyhal_get_ep_rx_size+0xc>)
c0d01e46:	5c40      	ldrb	r0, [r0, r1]
c0d01e48:	4770      	bx	lr
c0d01e4a:	46c0      	nop			; (mov r8, r8)
c0d01e4c:	20001e7d 	.word	0x20001e7d

c0d01e50 <io_seproxyhal_handle_usb_ep_xfer_event>:
}

void io_seproxyhal_handle_usb_ep_xfer_event(void) {
c0d01e50:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[4]) {
c0d01e52:	4815      	ldr	r0, [pc, #84]	; (c0d01ea8 <io_seproxyhal_handle_usb_ep_xfer_event+0x58>)
c0d01e54:	7901      	ldrb	r1, [r0, #4]
c0d01e56:	2904      	cmp	r1, #4
c0d01e58:	d017      	beq.n	c0d01e8a <io_seproxyhal_handle_usb_ep_xfer_event+0x3a>
c0d01e5a:	2902      	cmp	r1, #2
c0d01e5c:	d006      	beq.n	c0d01e6c <io_seproxyhal_handle_usb_ep_xfer_event+0x1c>
c0d01e5e:	2901      	cmp	r1, #1
c0d01e60:	d120      	bne.n	c0d01ea4 <io_seproxyhal_handle_usb_ep_xfer_event+0x54>
    /* This event is received when a new SETUP token had been received on a control endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_SETUP:
      // assume length of setup packet, and that it is on endpoint 0
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
c0d01e62:	1d81      	adds	r1, r0, #6
c0d01e64:	4812      	ldr	r0, [pc, #72]	; (c0d01eb0 <io_seproxyhal_handle_usb_ep_xfer_event+0x60>)
c0d01e66:	f002 f92f 	bl	c0d040c8 <USBD_LL_SetupStage>
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      }
      break;
  }
}
c0d01e6a:	bd10      	pop	{r4, pc}
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
      break;

    /* This event is received after the prepare data packet has been flushed to the usb host */
    case SEPROXYHAL_TAG_USB_EP_XFER_IN:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d01e6c:	78c2      	ldrb	r2, [r0, #3]
c0d01e6e:	217f      	movs	r1, #127	; 0x7f
c0d01e70:	4011      	ands	r1, r2
c0d01e72:	2906      	cmp	r1, #6
c0d01e74:	d816      	bhi.n	c0d01ea4 <io_seproxyhal_handle_usb_ep_xfer_event+0x54>
c0d01e76:	b2c9      	uxtb	r1, r1
        // discard ep timeout as we received the sent packet confirmation
        G_io_usb_ep_timeouts[G_io_seproxyhal_spi_buffer[3]&0x7F].timeout = 0;
c0d01e78:	004a      	lsls	r2, r1, #1
c0d01e7a:	4b0e      	ldr	r3, [pc, #56]	; (c0d01eb4 <io_seproxyhal_handle_usb_ep_xfer_event+0x64>)
c0d01e7c:	2400      	movs	r4, #0
c0d01e7e:	529c      	strh	r4, [r3, r2]
        // propagate sending ack of the data
        USBD_LL_DataInStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d01e80:	1d82      	adds	r2, r0, #6
c0d01e82:	480b      	ldr	r0, [pc, #44]	; (c0d01eb0 <io_seproxyhal_handle_usb_ep_xfer_event+0x60>)
c0d01e84:	f002 f9ae 	bl	c0d041e4 <USBD_LL_DataInStage>
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      }
      break;
  }
}
c0d01e88:	bd10      	pop	{r4, pc}
      }
      break;

    /* This event is received when a new DATA token is received on an endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_OUT:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d01e8a:	78c2      	ldrb	r2, [r0, #3]
c0d01e8c:	217f      	movs	r1, #127	; 0x7f
c0d01e8e:	4011      	ands	r1, r2
c0d01e90:	2906      	cmp	r1, #6
c0d01e92:	d807      	bhi.n	c0d01ea4 <io_seproxyhal_handle_usb_ep_xfer_event+0x54>
        // saved just in case it is needed ...
        G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
c0d01e94:	7942      	ldrb	r2, [r0, #5]
      }
      break;

    /* This event is received when a new DATA token is received on an endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_OUT:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d01e96:	b2c9      	uxtb	r1, r1
        // saved just in case it is needed ...
        G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
c0d01e98:	4b04      	ldr	r3, [pc, #16]	; (c0d01eac <io_seproxyhal_handle_usb_ep_xfer_event+0x5c>)
c0d01e9a:	545a      	strb	r2, [r3, r1]
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d01e9c:	1d82      	adds	r2, r0, #6
c0d01e9e:	4804      	ldr	r0, [pc, #16]	; (c0d01eb0 <io_seproxyhal_handle_usb_ep_xfer_event+0x60>)
c0d01ea0:	f002 f941 	bl	c0d04126 <USBD_LL_DataOutStage>
      }
      break;
  }
}
c0d01ea4:	bd10      	pop	{r4, pc}
c0d01ea6:	46c0      	nop			; (mov r8, r8)
c0d01ea8:	20001800 	.word	0x20001800
c0d01eac:	20001e7d 	.word	0x20001e7d
c0d01eb0:	20001f38 	.word	0x20001f38
c0d01eb4:	20001e84 	.word	0x20001e84

c0d01eb8 <io_usb_send_ep>:
#endif // HAVE_L4_USBLIB

// TODO, refactor this using the USB DataIn event like for the U2F tunnel
// TODO add a blocking parameter, for HID KBD sending, or use a USB busy flag per channel to know if 
// the transfer has been processed or not. and move on to the next transfer on the same endpoint
void io_usb_send_ep(unsigned int ep, unsigned char* buffer, unsigned short length, unsigned int timeout) {
c0d01eb8:	b570      	push	{r4, r5, r6, lr}
c0d01eba:	4615      	mov	r5, r2
c0d01ebc:	460e      	mov	r6, r1
c0d01ebe:	4604      	mov	r4, r0
  if (timeout) {
    timeout++;
  }

  // won't send if overflowing seproxyhal buffer format
  if (length > 255) {
c0d01ec0:	2dff      	cmp	r5, #255	; 0xff
c0d01ec2:	d81a      	bhi.n	c0d01efa <io_usb_send_ep+0x42>
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d01ec4:	480d      	ldr	r0, [pc, #52]	; (c0d01efc <io_usb_send_ep+0x44>)
c0d01ec6:	2150      	movs	r1, #80	; 0x50
c0d01ec8:	7001      	strb	r1, [r0, #0]
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
c0d01eca:	1ce9      	adds	r1, r5, #3
c0d01ecc:	0a0a      	lsrs	r2, r1, #8
c0d01ece:	7042      	strb	r2, [r0, #1]
  G_io_seproxyhal_spi_buffer[2] = (3+length);
c0d01ed0:	7081      	strb	r1, [r0, #2]
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
c0d01ed2:	2180      	movs	r1, #128	; 0x80
c0d01ed4:	4321      	orrs	r1, r4
c0d01ed6:	70c1      	strb	r1, [r0, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d01ed8:	2120      	movs	r1, #32
c0d01eda:	7101      	strb	r1, [r0, #4]
  G_io_seproxyhal_spi_buffer[5] = length;
c0d01edc:	7145      	strb	r5, [r0, #5]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 6);
c0d01ede:	2106      	movs	r1, #6
c0d01ee0:	f001 f914 	bl	c0d0310c <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(buffer, length);
c0d01ee4:	4630      	mov	r0, r6
c0d01ee6:	4629      	mov	r1, r5
c0d01ee8:	f001 f910 	bl	c0d0310c <io_seproxyhal_spi_send>
  // setup timeout of the endpoint
  G_io_usb_ep_timeouts[ep&0x7F].timeout = IO_RAPDU_TRANSMIT_TIMEOUT_MS;
c0d01eec:	207f      	movs	r0, #127	; 0x7f
c0d01eee:	4020      	ands	r0, r4
c0d01ef0:	0040      	lsls	r0, r0, #1
c0d01ef2:	217d      	movs	r1, #125	; 0x7d
c0d01ef4:	0109      	lsls	r1, r1, #4
c0d01ef6:	4a02      	ldr	r2, [pc, #8]	; (c0d01f00 <io_usb_send_ep+0x48>)
c0d01ef8:	5211      	strh	r1, [r2, r0]

}
c0d01efa:	bd70      	pop	{r4, r5, r6, pc}
c0d01efc:	20001800 	.word	0x20001800
c0d01f00:	20001e84 	.word	0x20001e84

c0d01f04 <io_usb_send_apdu_data>:

void io_usb_send_apdu_data(unsigned char* buffer, unsigned short length) {
c0d01f04:	b580      	push	{r7, lr}
c0d01f06:	460a      	mov	r2, r1
c0d01f08:	4601      	mov	r1, r0
  // wait for 20 events before hanging up and timeout (~2 seconds of timeout)
  io_usb_send_ep(0x82, buffer, length, 20);
c0d01f0a:	2082      	movs	r0, #130	; 0x82
c0d01f0c:	2314      	movs	r3, #20
c0d01f0e:	f7ff ffd3 	bl	c0d01eb8 <io_usb_send_ep>
}
c0d01f12:	bd80      	pop	{r7, pc}

c0d01f14 <io_seproxyhal_handle_capdu_event>:

}
#endif


void io_seproxyhal_handle_capdu_event(void) {
c0d01f14:	b580      	push	{r7, lr}
  if(G_io_apdu_state == APDU_IDLE) 
c0d01f16:	480e      	ldr	r0, [pc, #56]	; (c0d01f50 <io_seproxyhal_handle_capdu_event+0x3c>)
c0d01f18:	7801      	ldrb	r1, [r0, #0]
c0d01f1a:	2900      	cmp	r1, #0
c0d01f1c:	d116      	bne.n	c0d01f4c <io_seproxyhal_handle_capdu_event+0x38>
  {
    G_io_apdu_media = IO_APDU_MEDIA_RAW; // for application code
c0d01f1e:	490d      	ldr	r1, [pc, #52]	; (c0d01f54 <io_seproxyhal_handle_capdu_event+0x40>)
c0d01f20:	2206      	movs	r2, #6
c0d01f22:	700a      	strb	r2, [r1, #0]
    G_io_apdu_state = APDU_RAW; // for next call to io_exchange
c0d01f24:	210a      	movs	r1, #10
c0d01f26:	7001      	strb	r1, [r0, #0]
    G_io_apdu_length = MIN(U2BE(G_io_seproxyhal_spi_buffer, 1), sizeof(G_io_apdu_buffer)); 
c0d01f28:	480b      	ldr	r0, [pc, #44]	; (c0d01f58 <io_seproxyhal_handle_capdu_event+0x44>)
c0d01f2a:	7882      	ldrb	r2, [r0, #2]
c0d01f2c:	7841      	ldrb	r1, [r0, #1]
c0d01f2e:	0209      	lsls	r1, r1, #8
c0d01f30:	4311      	orrs	r1, r2
c0d01f32:	088b      	lsrs	r3, r1, #2
c0d01f34:	2241      	movs	r2, #65	; 0x41
c0d01f36:	0092      	lsls	r2, r2, #2
c0d01f38:	2b41      	cmp	r3, #65	; 0x41
c0d01f3a:	d300      	bcc.n	c0d01f3e <io_seproxyhal_handle_capdu_event+0x2a>
c0d01f3c:	4611      	mov	r1, r2
c0d01f3e:	4a07      	ldr	r2, [pc, #28]	; (c0d01f5c <io_seproxyhal_handle_capdu_event+0x48>)
c0d01f40:	8011      	strh	r1, [r2, #0]
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
c0d01f42:	8812      	ldrh	r2, [r2, #0]
c0d01f44:	1cc1      	adds	r1, r0, #3
c0d01f46:	4806      	ldr	r0, [pc, #24]	; (c0d01f60 <io_seproxyhal_handle_capdu_event+0x4c>)
c0d01f48:	f7ff fe67 	bl	c0d01c1a <os_memmove>
  }
}
c0d01f4c:	bd80      	pop	{r7, pc}
c0d01f4e:	46c0      	nop			; (mov r8, r8)
c0d01f50:	20001e92 	.word	0x20001e92
c0d01f54:	20001e7c 	.word	0x20001e7c
c0d01f58:	20001800 	.word	0x20001800
c0d01f5c:	20001e94 	.word	0x20001e94
c0d01f60:	20001d70 	.word	0x20001d70

c0d01f64 <io_seproxyhal_handle_event>:

unsigned int io_seproxyhal_handle_event(void) {
c0d01f64:	b5b0      	push	{r4, r5, r7, lr}
  unsigned int rx_len = U2BE(G_io_seproxyhal_spi_buffer, 1);
c0d01f66:	481e      	ldr	r0, [pc, #120]	; (c0d01fe0 <io_seproxyhal_handle_event+0x7c>)
c0d01f68:	7882      	ldrb	r2, [r0, #2]
c0d01f6a:	7841      	ldrb	r1, [r0, #1]
c0d01f6c:	0209      	lsls	r1, r1, #8
c0d01f6e:	4311      	orrs	r1, r2
c0d01f70:	7800      	ldrb	r0, [r0, #0]

  switch(G_io_seproxyhal_spi_buffer[0]) {
c0d01f72:	280f      	cmp	r0, #15
c0d01f74:	dc09      	bgt.n	c0d01f8a <io_seproxyhal_handle_event+0x26>
c0d01f76:	280e      	cmp	r0, #14
c0d01f78:	d00e      	beq.n	c0d01f98 <io_seproxyhal_handle_event+0x34>
c0d01f7a:	280f      	cmp	r0, #15
c0d01f7c:	d11f      	bne.n	c0d01fbe <io_seproxyhal_handle_event+0x5a>
c0d01f7e:	2000      	movs	r0, #0
  #ifdef HAVE_IO_USB
    case SEPROXYHAL_TAG_USB_EVENT:
      if (rx_len != 1) {
c0d01f80:	2901      	cmp	r1, #1
c0d01f82:	d126      	bne.n	c0d01fd2 <io_seproxyhal_handle_event+0x6e>
        return 0;
      }
      io_seproxyhal_handle_usb_event();
c0d01f84:	f7ff ff1e 	bl	c0d01dc4 <io_seproxyhal_handle_usb_event>
c0d01f88:	e022      	b.n	c0d01fd0 <io_seproxyhal_handle_event+0x6c>
c0d01f8a:	2810      	cmp	r0, #16
c0d01f8c:	d01b      	beq.n	c0d01fc6 <io_seproxyhal_handle_event+0x62>
c0d01f8e:	2816      	cmp	r0, #22
c0d01f90:	d115      	bne.n	c0d01fbe <io_seproxyhal_handle_event+0x5a>
      }
      return 1;
  #endif // HAVE_BLE

    case SEPROXYHAL_TAG_CAPDU_EVENT:
      io_seproxyhal_handle_capdu_event();
c0d01f92:	f7ff ffbf 	bl	c0d01f14 <io_seproxyhal_handle_capdu_event>
c0d01f96:	e01b      	b.n	c0d01fd0 <io_seproxyhal_handle_event+0x6c>
c0d01f98:	2000      	movs	r0, #0
c0d01f9a:	4912      	ldr	r1, [pc, #72]	; (c0d01fe4 <io_seproxyhal_handle_event+0x80>)
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
#ifdef HAVE_IO_USB
      {
        unsigned int i = IO_USB_MAX_ENDPOINTS;
        while(i--) {
          if (G_io_usb_ep_timeouts[i].timeout) {
c0d01f9c:	1a0a      	subs	r2, r1, r0
c0d01f9e:	8993      	ldrh	r3, [r2, #12]
c0d01fa0:	2b00      	cmp	r3, #0
c0d01fa2:	d009      	beq.n	c0d01fb8 <io_seproxyhal_handle_event+0x54>
            G_io_usb_ep_timeouts[i].timeout-=MIN(G_io_usb_ep_timeouts[i].timeout, 100);
c0d01fa4:	2464      	movs	r4, #100	; 0x64
c0d01fa6:	2b64      	cmp	r3, #100	; 0x64
c0d01fa8:	461d      	mov	r5, r3
c0d01faa:	d300      	bcc.n	c0d01fae <io_seproxyhal_handle_event+0x4a>
c0d01fac:	4625      	mov	r5, r4
c0d01fae:	1b5b      	subs	r3, r3, r5
c0d01fb0:	8193      	strh	r3, [r2, #12]
c0d01fb2:	4a0d      	ldr	r2, [pc, #52]	; (c0d01fe8 <io_seproxyhal_handle_event+0x84>)
            if (!G_io_usb_ep_timeouts[i].timeout) {
c0d01fb4:	4213      	tst	r3, r2
c0d01fb6:	d00d      	beq.n	c0d01fd4 <io_seproxyhal_handle_event+0x70>
    case SEPROXYHAL_TAG_TICKER_EVENT:
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
#ifdef HAVE_IO_USB
      {
        unsigned int i = IO_USB_MAX_ENDPOINTS;
        while(i--) {
c0d01fb8:	1c80      	adds	r0, r0, #2
c0d01fba:	280e      	cmp	r0, #14
c0d01fbc:	d1ee      	bne.n	c0d01f9c <io_seproxyhal_handle_event+0x38>
        }
      }
#endif // HAVE_IO_USB
      // no break is intentional
    default:
      return io_event(CHANNEL_SPI);
c0d01fbe:	2002      	movs	r0, #2
c0d01fc0:	f7ff f9a4 	bl	c0d0130c <io_event>
  }
  // defaultly return as not processed
  return 0;
}
c0d01fc4:	bdb0      	pop	{r4, r5, r7, pc}
c0d01fc6:	2000      	movs	r0, #0
      }
      io_seproxyhal_handle_usb_event();
      return 1;

    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3) {
c0d01fc8:	2903      	cmp	r1, #3
c0d01fca:	d302      	bcc.n	c0d01fd2 <io_seproxyhal_handle_event+0x6e>
        // error !
        return 0;
      }
      io_seproxyhal_handle_usb_ep_xfer_event();
c0d01fcc:	f7ff ff40 	bl	c0d01e50 <io_seproxyhal_handle_usb_ep_xfer_event>
c0d01fd0:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d01fd2:	bdb0      	pop	{r4, r5, r7, pc}
        while(i--) {
          if (G_io_usb_ep_timeouts[i].timeout) {
            G_io_usb_ep_timeouts[i].timeout-=MIN(G_io_usb_ep_timeouts[i].timeout, 100);
            if (!G_io_usb_ep_timeouts[i].timeout) {
              // timeout !
              G_io_apdu_state = APDU_IDLE;
c0d01fd4:	4805      	ldr	r0, [pc, #20]	; (c0d01fec <io_seproxyhal_handle_event+0x88>)
c0d01fd6:	2100      	movs	r1, #0
c0d01fd8:	7001      	strb	r1, [r0, #0]
              THROW(EXCEPTION_IO_RESET);
c0d01fda:	2010      	movs	r0, #16
c0d01fdc:	f7ff fed1 	bl	c0d01d82 <os_longjmp>
c0d01fe0:	20001800 	.word	0x20001800
c0d01fe4:	20001e84 	.word	0x20001e84
c0d01fe8:	0000ffff 	.word	0x0000ffff
c0d01fec:	20001e92 	.word	0x20001e92

c0d01ff0 <io_seproxyhal_init>:
#ifdef HAVE_BOLOS_APP_STACK_CANARY
#define APP_STACK_CANARY_MAGIC 0xDEAD0031
extern unsigned int app_stack_canary;
#endif // HAVE_BOLOS_APP_STACK_CANARY

void io_seproxyhal_init(void) {
c0d01ff0:	b510      	push	{r4, lr}
  // Enforce OS compatibility
  check_api_level(CX_COMPAT_APILEVEL);
c0d01ff2:	2009      	movs	r0, #9
c0d01ff4:	f000 ff3a 	bl	c0d02e6c <check_api_level>

#ifdef HAVE_BOLOS_APP_STACK_CANARY
  app_stack_canary = APP_STACK_CANARY_MAGIC;
#endif // HAVE_BOLOS_APP_STACK_CANARY  

  G_io_apdu_state = APDU_IDLE;
c0d01ff8:	4807      	ldr	r0, [pc, #28]	; (c0d02018 <io_seproxyhal_init+0x28>)
c0d01ffa:	2400      	movs	r4, #0
c0d01ffc:	7004      	strb	r4, [r0, #0]
  G_io_apdu_length = 0;
c0d01ffe:	4807      	ldr	r0, [pc, #28]	; (c0d0201c <io_seproxyhal_init+0x2c>)
c0d02000:	8004      	strh	r4, [r0, #0]
  G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d02002:	4807      	ldr	r0, [pc, #28]	; (c0d02020 <io_seproxyhal_init+0x30>)
c0d02004:	7004      	strb	r4, [r0, #0]
  debug_apdus_offset = 0;
  #endif // DEBUG_APDU


  #ifdef HAVE_USB_APDU
  io_usb_hid_init();
c0d02006:	f7ff fe23 	bl	c0d01c50 <io_usb_hid_init>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d0200a:	4806      	ldr	r0, [pc, #24]	; (c0d02024 <io_seproxyhal_init+0x34>)
c0d0200c:	6004      	str	r4, [r0, #0]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d0200e:	4806      	ldr	r0, [pc, #24]	; (c0d02028 <io_seproxyhal_init+0x38>)
c0d02010:	6004      	str	r4, [r0, #0]
  G_button_same_mask_counter = 0;
c0d02012:	4806      	ldr	r0, [pc, #24]	; (c0d0202c <io_seproxyhal_init+0x3c>)
c0d02014:	6004      	str	r4, [r0, #0]
  io_usb_hid_init();
  #endif // HAVE_USB_APDU

  io_seproxyhal_init_ux();
  io_seproxyhal_init_button();
}
c0d02016:	bd10      	pop	{r4, pc}
c0d02018:	20001e92 	.word	0x20001e92
c0d0201c:	20001e94 	.word	0x20001e94
c0d02020:	20001e7c 	.word	0x20001e7c
c0d02024:	20001e98 	.word	0x20001e98
c0d02028:	20001e9c 	.word	0x20001e9c
c0d0202c:	20001ea0 	.word	0x20001ea0

c0d02030 <io_seproxyhal_init_ux>:

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d02030:	4801      	ldr	r0, [pc, #4]	; (c0d02038 <io_seproxyhal_init_ux+0x8>)
c0d02032:	2100      	movs	r1, #0
c0d02034:	6001      	str	r1, [r0, #0]
}
c0d02036:	4770      	bx	lr
c0d02038:	20001e98 	.word	0x20001e98

c0d0203c <io_seproxyhal_init_button>:

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d0203c:	4802      	ldr	r0, [pc, #8]	; (c0d02048 <io_seproxyhal_init_button+0xc>)
c0d0203e:	2100      	movs	r1, #0
c0d02040:	6001      	str	r1, [r0, #0]
  G_button_same_mask_counter = 0;
c0d02042:	4802      	ldr	r0, [pc, #8]	; (c0d0204c <io_seproxyhal_init_button+0x10>)
c0d02044:	6001      	str	r1, [r0, #0]
}
c0d02046:	4770      	bx	lr
c0d02048:	20001e9c 	.word	0x20001e9c
c0d0204c:	20001ea0 	.word	0x20001ea0

c0d02050 <io_seproxyhal_touch_out>:

#ifdef HAVE_BAGL

unsigned int io_seproxyhal_touch_out(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d02050:	b5b0      	push	{r4, r5, r7, lr}
c0d02052:	460d      	mov	r5, r1
c0d02054:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->out != NULL) {
c0d02056:	6b20      	ldr	r0, [r4, #48]	; 0x30
c0d02058:	2800      	cmp	r0, #0
c0d0205a:	d00c      	beq.n	c0d02076 <io_seproxyhal_touch_out+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->out))(element));
c0d0205c:	f000 fc98 	bl	c0d02990 <pic>
c0d02060:	4601      	mov	r1, r0
c0d02062:	4620      	mov	r0, r4
c0d02064:	4788      	blx	r1
c0d02066:	f000 fc93 	bl	c0d02990 <pic>
c0d0206a:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (! el) {
c0d0206c:	2800      	cmp	r0, #0
c0d0206e:	d010      	beq.n	c0d02092 <io_seproxyhal_touch_out+0x42>
c0d02070:	2801      	cmp	r0, #1
c0d02072:	d000      	beq.n	c0d02076 <io_seproxyhal_touch_out+0x26>
c0d02074:	4604      	mov	r4, r0
      element = el;
    }
  }

  // out function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d02076:	2d00      	cmp	r5, #0
c0d02078:	d007      	beq.n	c0d0208a <io_seproxyhal_touch_out+0x3a>
    el = before_display(element);
c0d0207a:	4620      	mov	r0, r4
c0d0207c:	47a8      	blx	r5
c0d0207e:	2100      	movs	r1, #0
    if (!el) {
c0d02080:	2800      	cmp	r0, #0
c0d02082:	d006      	beq.n	c0d02092 <io_seproxyhal_touch_out+0x42>
c0d02084:	2801      	cmp	r0, #1
c0d02086:	d000      	beq.n	c0d0208a <io_seproxyhal_touch_out+0x3a>
c0d02088:	4604      	mov	r4, r0
    if ((unsigned int)el != 1) {
      element = el;
    }
  }

  io_seproxyhal_display(element);
c0d0208a:	4620      	mov	r0, r4
c0d0208c:	f7ff f93a 	bl	c0d01304 <io_seproxyhal_display>
c0d02090:	2101      	movs	r1, #1
  return 1;
}
c0d02092:	4608      	mov	r0, r1
c0d02094:	bdb0      	pop	{r4, r5, r7, pc}

c0d02096 <io_seproxyhal_touch_over>:

unsigned int io_seproxyhal_touch_over(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d02096:	b5b0      	push	{r4, r5, r7, lr}
c0d02098:	b08e      	sub	sp, #56	; 0x38
c0d0209a:	460d      	mov	r5, r1
c0d0209c:	4604      	mov	r4, r0
  bagl_element_t e;
  const bagl_element_t* el;
  if (element->over != NULL) {
c0d0209e:	6b60      	ldr	r0, [r4, #52]	; 0x34
c0d020a0:	2800      	cmp	r0, #0
c0d020a2:	d00c      	beq.n	c0d020be <io_seproxyhal_touch_over+0x28>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->over))(element));
c0d020a4:	f000 fc74 	bl	c0d02990 <pic>
c0d020a8:	4601      	mov	r1, r0
c0d020aa:	4620      	mov	r0, r4
c0d020ac:	4788      	blx	r1
c0d020ae:	f000 fc6f 	bl	c0d02990 <pic>
c0d020b2:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (!el) {
c0d020b4:	2800      	cmp	r0, #0
c0d020b6:	d01b      	beq.n	c0d020f0 <io_seproxyhal_touch_over+0x5a>
c0d020b8:	2801      	cmp	r0, #1
c0d020ba:	d000      	beq.n	c0d020be <io_seproxyhal_touch_over+0x28>
c0d020bc:	4604      	mov	r4, r0
      element = el;
    }
  }

  // over function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d020be:	2d00      	cmp	r5, #0
c0d020c0:	d008      	beq.n	c0d020d4 <io_seproxyhal_touch_over+0x3e>
    el = before_display(element);
c0d020c2:	4620      	mov	r0, r4
c0d020c4:	47a8      	blx	r5
c0d020c6:	466c      	mov	r4, sp
c0d020c8:	2100      	movs	r1, #0
    element = &e;
    if (!el) {
c0d020ca:	2800      	cmp	r0, #0
c0d020cc:	d010      	beq.n	c0d020f0 <io_seproxyhal_touch_over+0x5a>
c0d020ce:	2801      	cmp	r0, #1
c0d020d0:	d000      	beq.n	c0d020d4 <io_seproxyhal_touch_over+0x3e>
c0d020d2:	4604      	mov	r4, r0
c0d020d4:	466d      	mov	r5, sp
      element = el;
    }
  }

  // swap colors
  os_memmove(&e, (void*)element, sizeof(bagl_element_t));
c0d020d6:	2238      	movs	r2, #56	; 0x38
c0d020d8:	4628      	mov	r0, r5
c0d020da:	4621      	mov	r1, r4
c0d020dc:	f7ff fd9d 	bl	c0d01c1a <os_memmove>
  e.component.fgcolor = element->overfgcolor;
c0d020e0:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0d020e2:	9004      	str	r0, [sp, #16]
  e.component.bgcolor = element->overbgcolor;
c0d020e4:	6aa0      	ldr	r0, [r4, #40]	; 0x28
c0d020e6:	9005      	str	r0, [sp, #20]

  io_seproxyhal_display(&e);
c0d020e8:	4628      	mov	r0, r5
c0d020ea:	f7ff f90b 	bl	c0d01304 <io_seproxyhal_display>
c0d020ee:	2101      	movs	r1, #1
  return 1;
}
c0d020f0:	4608      	mov	r0, r1
c0d020f2:	b00e      	add	sp, #56	; 0x38
c0d020f4:	bdb0      	pop	{r4, r5, r7, pc}

c0d020f6 <io_seproxyhal_touch_tap>:

unsigned int io_seproxyhal_touch_tap(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d020f6:	b5b0      	push	{r4, r5, r7, lr}
c0d020f8:	460d      	mov	r5, r1
c0d020fa:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->tap != NULL) {
c0d020fc:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d020fe:	2800      	cmp	r0, #0
c0d02100:	d00c      	beq.n	c0d0211c <io_seproxyhal_touch_tap+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->tap))(element));
c0d02102:	f000 fc45 	bl	c0d02990 <pic>
c0d02106:	4601      	mov	r1, r0
c0d02108:	4620      	mov	r0, r4
c0d0210a:	4788      	blx	r1
c0d0210c:	f000 fc40 	bl	c0d02990 <pic>
c0d02110:	2100      	movs	r1, #0
    // backward compatible with samples and such
    if (!el) {
c0d02112:	2800      	cmp	r0, #0
c0d02114:	d010      	beq.n	c0d02138 <io_seproxyhal_touch_tap+0x42>
c0d02116:	2801      	cmp	r0, #1
c0d02118:	d000      	beq.n	c0d0211c <io_seproxyhal_touch_tap+0x26>
c0d0211a:	4604      	mov	r4, r0
      element = el;
    }
  }

  // tap function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d0211c:	2d00      	cmp	r5, #0
c0d0211e:	d007      	beq.n	c0d02130 <io_seproxyhal_touch_tap+0x3a>
    el = before_display(element);
c0d02120:	4620      	mov	r0, r4
c0d02122:	47a8      	blx	r5
c0d02124:	2100      	movs	r1, #0
    if (!el) {
c0d02126:	2800      	cmp	r0, #0
c0d02128:	d006      	beq.n	c0d02138 <io_seproxyhal_touch_tap+0x42>
c0d0212a:	2801      	cmp	r0, #1
c0d0212c:	d000      	beq.n	c0d02130 <io_seproxyhal_touch_tap+0x3a>
c0d0212e:	4604      	mov	r4, r0
    }
    if ((unsigned int)el != 1) {
      element = el;
    }
  }
  io_seproxyhal_display(element);
c0d02130:	4620      	mov	r0, r4
c0d02132:	f7ff f8e7 	bl	c0d01304 <io_seproxyhal_display>
c0d02136:	2101      	movs	r1, #1
  return 1;
}
c0d02138:	4608      	mov	r0, r1
c0d0213a:	bdb0      	pop	{r4, r5, r7, pc}

c0d0213c <io_seproxyhal_touch_element_callback>:
  io_seproxyhal_touch_element_callback(elements, element_count, x, y, event_kind, NULL);  
}

// browse all elements and until an element has changed state, continue browsing
// return if processed or not
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
c0d0213c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0213e:	b087      	sub	sp, #28
c0d02140:	9302      	str	r3, [sp, #8]
c0d02142:	9203      	str	r2, [sp, #12]
c0d02144:	9105      	str	r1, [sp, #20]
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d02146:	2900      	cmp	r1, #0
c0d02148:	d077      	beq.n	c0d0223a <io_seproxyhal_touch_element_callback+0xfe>
c0d0214a:	9004      	str	r0, [sp, #16]
c0d0214c:	980d      	ldr	r0, [sp, #52]	; 0x34
c0d0214e:	9001      	str	r0, [sp, #4]
c0d02150:	980c      	ldr	r0, [sp, #48]	; 0x30
c0d02152:	9000      	str	r0, [sp, #0]
c0d02154:	2500      	movs	r5, #0
c0d02156:	4b3c      	ldr	r3, [pc, #240]	; (c0d02248 <io_seproxyhal_touch_element_callback+0x10c>)
c0d02158:	9506      	str	r5, [sp, #24]
c0d0215a:	462f      	mov	r7, r5
c0d0215c:	461e      	mov	r6, r3
    // process all components matching the x/y/w/h (no break) => fishy for the released out of zone
    // continue processing only if a status has not been sent
    if (io_seproxyhal_spi_is_status_sent()) {
c0d0215e:	f000 ffeb 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d02162:	2800      	cmp	r0, #0
c0d02164:	d155      	bne.n	c0d02212 <io_seproxyhal_touch_element_callback+0xd6>
      // continue instead of return to process all elemnts and therefore discard last touched element
      break;
    }

    // only perform out callback when element was in the current array, else, leave it be
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
c0d02166:	2038      	movs	r0, #56	; 0x38
c0d02168:	4368      	muls	r0, r5
c0d0216a:	9c04      	ldr	r4, [sp, #16]
c0d0216c:	1825      	adds	r5, r4, r0
c0d0216e:	4633      	mov	r3, r6
c0d02170:	681a      	ldr	r2, [r3, #0]
c0d02172:	2101      	movs	r1, #1
c0d02174:	4295      	cmp	r5, r2
c0d02176:	d000      	beq.n	c0d0217a <io_seproxyhal_touch_element_callback+0x3e>
c0d02178:	9906      	ldr	r1, [sp, #24]
c0d0217a:	9106      	str	r1, [sp, #24]
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d0217c:	5620      	ldrsb	r0, [r4, r0]
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
c0d0217e:	2800      	cmp	r0, #0
c0d02180:	da41      	bge.n	c0d02206 <io_seproxyhal_touch_element_callback+0xca>
c0d02182:	2020      	movs	r0, #32
c0d02184:	5c28      	ldrb	r0, [r5, r0]
c0d02186:	2102      	movs	r1, #2
c0d02188:	5e69      	ldrsh	r1, [r5, r1]
c0d0218a:	1a0a      	subs	r2, r1, r0
c0d0218c:	9c03      	ldr	r4, [sp, #12]
c0d0218e:	42a2      	cmp	r2, r4
c0d02190:	dc39      	bgt.n	c0d02206 <io_seproxyhal_touch_element_callback+0xca>
c0d02192:	1841      	adds	r1, r0, r1
c0d02194:	88ea      	ldrh	r2, [r5, #6]
c0d02196:	1889      	adds	r1, r1, r2
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {
c0d02198:	9a03      	ldr	r2, [sp, #12]
c0d0219a:	428a      	cmp	r2, r1
c0d0219c:	da33      	bge.n	c0d02206 <io_seproxyhal_touch_element_callback+0xca>
c0d0219e:	2104      	movs	r1, #4
c0d021a0:	5e6c      	ldrsh	r4, [r5, r1]
c0d021a2:	1a22      	subs	r2, r4, r0
c0d021a4:	9902      	ldr	r1, [sp, #8]
c0d021a6:	428a      	cmp	r2, r1
c0d021a8:	dc2d      	bgt.n	c0d02206 <io_seproxyhal_touch_element_callback+0xca>
c0d021aa:	1820      	adds	r0, r4, r0
c0d021ac:	8929      	ldrh	r1, [r5, #8]
c0d021ae:	1840      	adds	r0, r0, r1
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d021b0:	9902      	ldr	r1, [sp, #8]
c0d021b2:	4281      	cmp	r1, r0
c0d021b4:	da27      	bge.n	c0d02206 <io_seproxyhal_touch_element_callback+0xca>
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d021b6:	6818      	ldr	r0, [r3, #0]
              && G_bagl_last_touched_not_released_component != NULL) {
c0d021b8:	4285      	cmp	r5, r0
c0d021ba:	d010      	beq.n	c0d021de <io_seproxyhal_touch_element_callback+0xa2>
c0d021bc:	6818      	ldr	r0, [r3, #0]
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d021be:	2800      	cmp	r0, #0
c0d021c0:	d00d      	beq.n	c0d021de <io_seproxyhal_touch_element_callback+0xa2>
              && G_bagl_last_touched_not_released_component != NULL) {
        // only out the previous element if the newly matching will be displayed 
        if (!before_display || before_display(&elements[comp_idx])) {
c0d021c2:	9801      	ldr	r0, [sp, #4]
c0d021c4:	2800      	cmp	r0, #0
c0d021c6:	d005      	beq.n	c0d021d4 <io_seproxyhal_touch_element_callback+0x98>
c0d021c8:	4628      	mov	r0, r5
c0d021ca:	9901      	ldr	r1, [sp, #4]
c0d021cc:	4788      	blx	r1
c0d021ce:	4633      	mov	r3, r6
c0d021d0:	2800      	cmp	r0, #0
c0d021d2:	d018      	beq.n	c0d02206 <io_seproxyhal_touch_element_callback+0xca>
          if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d021d4:	6818      	ldr	r0, [r3, #0]
c0d021d6:	9901      	ldr	r1, [sp, #4]
c0d021d8:	f7ff ff3a 	bl	c0d02050 <io_seproxyhal_touch_out>
c0d021dc:	e008      	b.n	c0d021f0 <io_seproxyhal_touch_element_callback+0xb4>
c0d021de:	9800      	ldr	r0, [sp, #0]
        continue;
      }
      */
      
      // callback the hal to notify the component impacted by the user input
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_RELEASE) {
c0d021e0:	2801      	cmp	r0, #1
c0d021e2:	d009      	beq.n	c0d021f8 <io_seproxyhal_touch_element_callback+0xbc>
c0d021e4:	2802      	cmp	r0, #2
c0d021e6:	d10e      	bne.n	c0d02206 <io_seproxyhal_touch_element_callback+0xca>
        if (io_seproxyhal_touch_tap(&elements[comp_idx], before_display)) {
c0d021e8:	4628      	mov	r0, r5
c0d021ea:	9901      	ldr	r1, [sp, #4]
c0d021ec:	f7ff ff83 	bl	c0d020f6 <io_seproxyhal_touch_tap>
c0d021f0:	4633      	mov	r3, r6
c0d021f2:	2800      	cmp	r0, #0
c0d021f4:	d007      	beq.n	c0d02206 <io_seproxyhal_touch_element_callback+0xca>
c0d021f6:	e022      	b.n	c0d0223e <io_seproxyhal_touch_element_callback+0x102>
          return;
        }
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
c0d021f8:	4628      	mov	r0, r5
c0d021fa:	9901      	ldr	r1, [sp, #4]
c0d021fc:	f7ff ff4b 	bl	c0d02096 <io_seproxyhal_touch_over>
c0d02200:	4633      	mov	r3, r6
c0d02202:	2800      	cmp	r0, #0
c0d02204:	d11e      	bne.n	c0d02244 <io_seproxyhal_touch_element_callback+0x108>
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d02206:	1c7f      	adds	r7, r7, #1
c0d02208:	b2fd      	uxtb	r5, r7
c0d0220a:	9805      	ldr	r0, [sp, #20]
c0d0220c:	4285      	cmp	r5, r0
c0d0220e:	d3a5      	bcc.n	c0d0215c <io_seproxyhal_touch_element_callback+0x20>
c0d02210:	e000      	b.n	c0d02214 <io_seproxyhal_touch_element_callback+0xd8>
c0d02212:	4633      	mov	r3, r6
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
    && G_bagl_last_touched_not_released_component != NULL) {
c0d02214:	9806      	ldr	r0, [sp, #24]
c0d02216:	0600      	lsls	r0, r0, #24
c0d02218:	d00f      	beq.n	c0d0223a <io_seproxyhal_touch_element_callback+0xfe>
c0d0221a:	6818      	ldr	r0, [r3, #0]
      }
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
c0d0221c:	2800      	cmp	r0, #0
c0d0221e:	d00c      	beq.n	c0d0223a <io_seproxyhal_touch_element_callback+0xfe>
    && G_bagl_last_touched_not_released_component != NULL) {

    // we won't be able to notify the out, don't do it, in case a diplay refused the dra of the relased element and the position matched another element of the array (in autocomplete for example)
    if (io_seproxyhal_spi_is_status_sent()) {
c0d02220:	f000 ff8a 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d02224:	4631      	mov	r1, r6
c0d02226:	2800      	cmp	r0, #0
c0d02228:	d107      	bne.n	c0d0223a <io_seproxyhal_touch_element_callback+0xfe>
      return;
    }
    
    if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d0222a:	6808      	ldr	r0, [r1, #0]
c0d0222c:	9901      	ldr	r1, [sp, #4]
c0d0222e:	f7ff ff0f 	bl	c0d02050 <io_seproxyhal_touch_out>
c0d02232:	2800      	cmp	r0, #0
c0d02234:	d001      	beq.n	c0d0223a <io_seproxyhal_touch_element_callback+0xfe>
      // ok component out has been emitted
      G_bagl_last_touched_not_released_component = NULL;
c0d02236:	2000      	movs	r0, #0
c0d02238:	6030      	str	r0, [r6, #0]
    }
  }

  // not processed
}
c0d0223a:	b007      	add	sp, #28
c0d0223c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0223e:	2000      	movs	r0, #0
c0d02240:	6018      	str	r0, [r3, #0]
c0d02242:	e7fa      	b.n	c0d0223a <io_seproxyhal_touch_element_callback+0xfe>
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
          // remember the last touched component
          G_bagl_last_touched_not_released_component = (bagl_element_t*)&elements[comp_idx];
c0d02244:	601d      	str	r5, [r3, #0]
c0d02246:	e7f8      	b.n	c0d0223a <io_seproxyhal_touch_element_callback+0xfe>
c0d02248:	20001e98 	.word	0x20001e98

c0d0224c <io_seproxyhal_display_icon>:
  // remaining length of bitmap bits to be displayed
  return len;
}
#endif // SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
c0d0224c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0224e:	b089      	sub	sp, #36	; 0x24
c0d02250:	460c      	mov	r4, r1
c0d02252:	4601      	mov	r1, r0
c0d02254:	ad02      	add	r5, sp, #8
c0d02256:	221c      	movs	r2, #28
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
c0d02258:	4628      	mov	r0, r5
c0d0225a:	9201      	str	r2, [sp, #4]
c0d0225c:	f7ff fcdd 	bl	c0d01c1a <os_memmove>
  icon_component_mod.width = icon_details->width;
c0d02260:	6821      	ldr	r1, [r4, #0]
c0d02262:	80e9      	strh	r1, [r5, #6]
  icon_component_mod.height = icon_details->height;
c0d02264:	6862      	ldr	r2, [r4, #4]
c0d02266:	812a      	strh	r2, [r5, #8]
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d02268:	68a0      	ldr	r0, [r4, #8]
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
                          +w; /* image bitmap size */
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d0226a:	4f1a      	ldr	r7, [pc, #104]	; (c0d022d4 <io_seproxyhal_display_icon+0x88>)
c0d0226c:	2365      	movs	r3, #101	; 0x65
c0d0226e:	703b      	strb	r3, [r7, #0]


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
c0d02270:	b292      	uxth	r2, r2
c0d02272:	4342      	muls	r2, r0
c0d02274:	b28b      	uxth	r3, r1
c0d02276:	4353      	muls	r3, r2
c0d02278:	08d9      	lsrs	r1, r3, #3
c0d0227a:	1c4e      	adds	r6, r1, #1
c0d0227c:	2207      	movs	r2, #7
c0d0227e:	4213      	tst	r3, r2
c0d02280:	d100      	bne.n	c0d02284 <io_seproxyhal_display_icon+0x38>
c0d02282:	460e      	mov	r6, r1
c0d02284:	4631      	mov	r1, r6
c0d02286:	9100      	str	r1, [sp, #0]
c0d02288:	2604      	movs	r6, #4
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d0228a:	4086      	lsls	r6, r0
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
c0d0228c:	1870      	adds	r0, r6, r1
                          +w; /* image bitmap size */
c0d0228e:	301d      	adds	r0, #29
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
  G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d02290:	0a01      	lsrs	r1, r0, #8
c0d02292:	7079      	strb	r1, [r7, #1]
  G_io_seproxyhal_spi_buffer[2] = length;
c0d02294:	70b8      	strb	r0, [r7, #2]
c0d02296:	2103      	movs	r1, #3
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d02298:	4638      	mov	r0, r7
c0d0229a:	f000 ff37 	bl	c0d0310c <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)icon_component, sizeof(bagl_component_t));
c0d0229e:	4628      	mov	r0, r5
c0d022a0:	9901      	ldr	r1, [sp, #4]
c0d022a2:	f000 ff33 	bl	c0d0310c <io_seproxyhal_spi_send>
  G_io_seproxyhal_spi_buffer[0] = icon_details->bpp;
c0d022a6:	68a0      	ldr	r0, [r4, #8]
c0d022a8:	7038      	strb	r0, [r7, #0]
c0d022aa:	2101      	movs	r1, #1
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 1);
c0d022ac:	4638      	mov	r0, r7
c0d022ae:	f000 ff2d 	bl	c0d0310c <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->colors), h);
c0d022b2:	68e0      	ldr	r0, [r4, #12]
c0d022b4:	f000 fb6c 	bl	c0d02990 <pic>
c0d022b8:	b2b1      	uxth	r1, r6
c0d022ba:	f000 ff27 	bl	c0d0310c <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->bitmap), w);
c0d022be:	9800      	ldr	r0, [sp, #0]
c0d022c0:	b285      	uxth	r5, r0
c0d022c2:	6920      	ldr	r0, [r4, #16]
c0d022c4:	f000 fb64 	bl	c0d02990 <pic>
c0d022c8:	4629      	mov	r1, r5
c0d022ca:	f000 ff1f 	bl	c0d0310c <io_seproxyhal_spi_send>
#endif // !SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS
}
c0d022ce:	b009      	add	sp, #36	; 0x24
c0d022d0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d022d2:	46c0      	nop			; (mov r8, r8)
c0d022d4:	20001800 	.word	0x20001800

c0d022d8 <io_seproxyhal_display_default>:

void io_seproxyhal_display_default(const bagl_element_t * element) {
c0d022d8:	b570      	push	{r4, r5, r6, lr}
c0d022da:	4604      	mov	r4, r0
  // process automagically address from rom and from ram
  unsigned int type = (element->component.type & ~(BAGL_FLAG_TOUCHABLE));
c0d022dc:	7820      	ldrb	r0, [r4, #0]
c0d022de:	267f      	movs	r6, #127	; 0x7f
c0d022e0:	4006      	ands	r6, r0

  // avoid sending another status :), fixes a lot of bugs in the end
  if (io_seproxyhal_spi_is_status_sent()) {
c0d022e2:	f000 ff29 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d022e6:	2800      	cmp	r0, #0
c0d022e8:	d130      	bne.n	c0d0234c <io_seproxyhal_display_default+0x74>
c0d022ea:	2e00      	cmp	r6, #0
c0d022ec:	d02e      	beq.n	c0d0234c <io_seproxyhal_display_default+0x74>
    return;
  }

  if (type != BAGL_NONE) {
    if (element->text != NULL) {
c0d022ee:	69e0      	ldr	r0, [r4, #28]
c0d022f0:	2800      	cmp	r0, #0
c0d022f2:	d01d      	beq.n	c0d02330 <io_seproxyhal_display_default+0x58>
      unsigned int text_adr = PIC((unsigned int)element->text);
c0d022f4:	f000 fb4c 	bl	c0d02990 <pic>
c0d022f8:	4605      	mov	r5, r0
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
c0d022fa:	2e05      	cmp	r6, #5
c0d022fc:	d102      	bne.n	c0d02304 <io_seproxyhal_display_default+0x2c>
c0d022fe:	7ea0      	ldrb	r0, [r4, #26]
c0d02300:	2800      	cmp	r0, #0
c0d02302:	d024      	beq.n	c0d0234e <io_seproxyhal_display_default+0x76>
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d02304:	4628      	mov	r0, r5
c0d02306:	f002 fe2d 	bl	c0d04f64 <strlen>
c0d0230a:	4606      	mov	r6, r0
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d0230c:	4812      	ldr	r0, [pc, #72]	; (c0d02358 <io_seproxyhal_display_default+0x80>)
c0d0230e:	2165      	movs	r1, #101	; 0x65
c0d02310:	7001      	strb	r1, [r0, #0]
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d02312:	4631      	mov	r1, r6
c0d02314:	311c      	adds	r1, #28
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
        G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d02316:	0a0a      	lsrs	r2, r1, #8
c0d02318:	7042      	strb	r2, [r0, #1]
        G_io_seproxyhal_spi_buffer[2] = length;
c0d0231a:	7081      	strb	r1, [r0, #2]
        io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d0231c:	2103      	movs	r1, #3
c0d0231e:	f000 fef5 	bl	c0d0310c <io_seproxyhal_spi_send>
c0d02322:	211c      	movs	r1, #28
        io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d02324:	4620      	mov	r0, r4
c0d02326:	f000 fef1 	bl	c0d0310c <io_seproxyhal_spi_send>
        io_seproxyhal_spi_send((unsigned char*)text_adr, length-sizeof(bagl_component_t));
c0d0232a:	b2b1      	uxth	r1, r6
c0d0232c:	4628      	mov	r0, r5
c0d0232e:	e00b      	b.n	c0d02348 <io_seproxyhal_display_default+0x70>
      }
    }
    else {
      unsigned short length = sizeof(bagl_component_t);
      G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d02330:	4809      	ldr	r0, [pc, #36]	; (c0d02358 <io_seproxyhal_display_default+0x80>)
c0d02332:	2165      	movs	r1, #101	; 0x65
c0d02334:	7001      	strb	r1, [r0, #0]
      G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d02336:	2100      	movs	r1, #0
c0d02338:	7041      	strb	r1, [r0, #1]
c0d0233a:	251c      	movs	r5, #28
      G_io_seproxyhal_spi_buffer[2] = length;
c0d0233c:	7085      	strb	r5, [r0, #2]
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d0233e:	2103      	movs	r1, #3
c0d02340:	f000 fee4 	bl	c0d0310c <io_seproxyhal_spi_send>
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d02344:	4620      	mov	r0, r4
c0d02346:	4629      	mov	r1, r5
c0d02348:	f000 fee0 	bl	c0d0310c <io_seproxyhal_spi_send>
    }
  }
}
c0d0234c:	bd70      	pop	{r4, r5, r6, pc}
  if (type != BAGL_NONE) {
    if (element->text != NULL) {
      unsigned int text_adr = PIC((unsigned int)element->text);
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
c0d0234e:	4620      	mov	r0, r4
c0d02350:	4629      	mov	r1, r5
c0d02352:	f7ff ff7b 	bl	c0d0224c <io_seproxyhal_display_icon>
      G_io_seproxyhal_spi_buffer[2] = length;
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
    }
  }
}
c0d02356:	bd70      	pop	{r4, r5, r6, pc}
c0d02358:	20001800 	.word	0x20001800

c0d0235c <io_seproxyhal_button_push>:
  G_io_seproxyhal_spi_buffer[3] = (backlight_percentage?0x80:0)|(flags & 0x7F); // power on
  G_io_seproxyhal_spi_buffer[4] = backlight_percentage;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
}

void io_seproxyhal_button_push(button_push_callback_t button_callback, unsigned int new_button_mask) {
c0d0235c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0235e:	b081      	sub	sp, #4
c0d02360:	4604      	mov	r4, r0
  if (button_callback) {
c0d02362:	2c00      	cmp	r4, #0
c0d02364:	d02b      	beq.n	c0d023be <io_seproxyhal_button_push+0x62>
    unsigned int button_mask;
    unsigned int button_same_mask_counter;
    // enable speeded up long push
    if (new_button_mask == G_button_mask) {
c0d02366:	4817      	ldr	r0, [pc, #92]	; (c0d023c4 <io_seproxyhal_button_push+0x68>)
c0d02368:	6802      	ldr	r2, [r0, #0]
c0d0236a:	428a      	cmp	r2, r1
c0d0236c:	d103      	bne.n	c0d02376 <io_seproxyhal_button_push+0x1a>
      // each 100ms ~
      G_button_same_mask_counter++;
c0d0236e:	4a16      	ldr	r2, [pc, #88]	; (c0d023c8 <io_seproxyhal_button_push+0x6c>)
c0d02370:	6813      	ldr	r3, [r2, #0]
c0d02372:	1c5b      	adds	r3, r3, #1
c0d02374:	6013      	str	r3, [r2, #0]
    }

    // append the button mask
    button_mask = G_button_mask | new_button_mask;
c0d02376:	6806      	ldr	r6, [r0, #0]
c0d02378:	430e      	orrs	r6, r1

    // pre reset variable due to os_sched_exit
    button_same_mask_counter = G_button_same_mask_counter;
c0d0237a:	4a13      	ldr	r2, [pc, #76]	; (c0d023c8 <io_seproxyhal_button_push+0x6c>)
c0d0237c:	6815      	ldr	r5, [r2, #0]
c0d0237e:	4f13      	ldr	r7, [pc, #76]	; (c0d023cc <io_seproxyhal_button_push+0x70>)

    // reset button mask
    if (new_button_mask == 0) {
c0d02380:	2900      	cmp	r1, #0
c0d02382:	d001      	beq.n	c0d02388 <io_seproxyhal_button_push+0x2c>

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
    }
    else {
      G_button_mask = button_mask;
c0d02384:	6006      	str	r6, [r0, #0]
c0d02386:	e004      	b.n	c0d02392 <io_seproxyhal_button_push+0x36>
c0d02388:	2300      	movs	r3, #0
    button_same_mask_counter = G_button_same_mask_counter;

    // reset button mask
    if (new_button_mask == 0) {
      // reset next state when button are released
      G_button_mask = 0;
c0d0238a:	6003      	str	r3, [r0, #0]
      G_button_same_mask_counter=0;
c0d0238c:	6013      	str	r3, [r2, #0]

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
c0d0238e:	1c7b      	adds	r3, r7, #1
c0d02390:	431e      	orrs	r6, r3
    else {
      G_button_mask = button_mask;
    }

    // reset counter when button mask changes
    if (new_button_mask != G_button_mask) {
c0d02392:	6800      	ldr	r0, [r0, #0]
c0d02394:	4288      	cmp	r0, r1
c0d02396:	d001      	beq.n	c0d0239c <io_seproxyhal_button_push+0x40>
      G_button_same_mask_counter=0;
c0d02398:	2000      	movs	r0, #0
c0d0239a:	6010      	str	r0, [r2, #0]
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
c0d0239c:	2d08      	cmp	r5, #8
c0d0239e:	d30b      	bcc.n	c0d023b8 <io_seproxyhal_button_push+0x5c>
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d023a0:	2103      	movs	r1, #3
c0d023a2:	4628      	mov	r0, r5
c0d023a4:	f002 fc60 	bl	c0d04c68 <__aeabi_uidivmod>
        button_mask |= BUTTON_EVT_FAST;
c0d023a8:	2001      	movs	r0, #1
c0d023aa:	0780      	lsls	r0, r0, #30
c0d023ac:	4330      	orrs	r0, r6
      G_button_same_mask_counter=0;
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d023ae:	2900      	cmp	r1, #0
c0d023b0:	d000      	beq.n	c0d023b4 <io_seproxyhal_button_push+0x58>
c0d023b2:	4630      	mov	r0, r6
      }
      */

      // discard the release event after a fastskip has been detected, to avoid strange at release behavior
      // and also to enable user to cancel an operation by starting triggering the fast skip
      button_mask &= ~BUTTON_EVT_RELEASED;
c0d023b4:	4038      	ands	r0, r7
c0d023b6:	e000      	b.n	c0d023ba <io_seproxyhal_button_push+0x5e>
c0d023b8:	4630      	mov	r0, r6
    }

    // indicate if button have been released
    button_callback(button_mask, button_same_mask_counter);
c0d023ba:	4629      	mov	r1, r5
c0d023bc:	47a0      	blx	r4
  }
}
c0d023be:	b001      	add	sp, #4
c0d023c0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d023c2:	46c0      	nop			; (mov r8, r8)
c0d023c4:	20001e9c 	.word	0x20001e9c
c0d023c8:	20001ea0 	.word	0x20001ea0
c0d023cc:	7fffffff 	.word	0x7fffffff

c0d023d0 <os_io_seproxyhal_get_app_name_and_version>:
#ifdef HAVE_IO_U2F
u2f_service_t G_io_u2f;
#endif // HAVE_IO_U2F

unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
c0d023d0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d023d2:	b081      	sub	sp, #4
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d023d4:	4e0f      	ldr	r6, [pc, #60]	; (c0d02414 <os_io_seproxyhal_get_app_name_and_version+0x44>)
c0d023d6:	2401      	movs	r4, #1
c0d023d8:	7034      	strb	r4, [r6, #0]

  // append app name
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d023da:	1cb1      	adds	r1, r6, #2
c0d023dc:	2081      	movs	r0, #129	; 0x81
c0d023de:	0047      	lsls	r7, r0, #1
c0d023e0:	1c7a      	adds	r2, r7, #1
c0d023e2:	4620      	mov	r0, r4
c0d023e4:	f000 fe7a 	bl	c0d030dc <os_registry_get_current_app_tag>
c0d023e8:	4605      	mov	r5, r0
  G_io_apdu_buffer[tx_len++] = len;
c0d023ea:	7075      	strb	r5, [r6, #1]
  tx_len += len;
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d023ec:	1b7a      	subs	r2, r7, r5
unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d023ee:	1977      	adds	r7, r6, r5
  // append app name
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
  G_io_apdu_buffer[tx_len++] = len;
  tx_len += len;
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d023f0:	1cf9      	adds	r1, r7, #3
c0d023f2:	2002      	movs	r0, #2
c0d023f4:	f000 fe72 	bl	c0d030dc <os_registry_get_current_app_tag>
  G_io_apdu_buffer[tx_len++] = len;
c0d023f8:	70b8      	strb	r0, [r7, #2]
c0d023fa:	182d      	adds	r5, r5, r0
unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d023fc:	1976      	adds	r6, r6, r5
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
  G_io_apdu_buffer[tx_len++] = len;
  tx_len += len;
  // return OS flags to notify of platform's global state (pin lock etc)
  G_io_apdu_buffer[tx_len++] = 1; // flags length
c0d023fe:	70f4      	strb	r4, [r6, #3]
  G_io_apdu_buffer[tx_len++] = os_flags();
c0d02400:	f000 fe56 	bl	c0d030b0 <os_flags>
c0d02404:	7130      	strb	r0, [r6, #4]

  // status words
  G_io_apdu_buffer[tx_len++] = 0x90;
c0d02406:	2090      	movs	r0, #144	; 0x90
c0d02408:	7170      	strb	r0, [r6, #5]
  G_io_apdu_buffer[tx_len++] = 0x00;
c0d0240a:	2000      	movs	r0, #0
c0d0240c:	71b0      	strb	r0, [r6, #6]
c0d0240e:	1de8      	adds	r0, r5, #7
  return tx_len;
c0d02410:	b001      	add	sp, #4
c0d02412:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02414:	20001d70 	.word	0x20001d70

c0d02418 <io_exchange>:
}


unsigned short io_exchange(unsigned char channel, unsigned short tx_len) {
c0d02418:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0241a:	b083      	sub	sp, #12
  }
  after_debug:
#endif // DEBUG_APDU

reply_apdu:
  switch(channel&~(IO_FLAGS)) {
c0d0241c:	2207      	movs	r2, #7
c0d0241e:	4210      	tst	r0, r2
c0d02420:	d006      	beq.n	c0d02430 <io_exchange+0x18>
c0d02422:	4607      	mov	r7, r0
      }
    }
    break;

  default:
    return io_exchange_al(channel, tx_len);
c0d02424:	b2f8      	uxtb	r0, r7
c0d02426:	f7ff fa6b 	bl	c0d01900 <io_exchange_al>
  }
}
c0d0242a:	b280      	uxth	r0, r0
c0d0242c:	b003      	add	sp, #12
c0d0242e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02430:	9201      	str	r2, [sp, #4]
c0d02432:	4c58      	ldr	r4, [pc, #352]	; (c0d02594 <io_exchange+0x17c>)
c0d02434:	4d58      	ldr	r5, [pc, #352]	; (c0d02598 <io_exchange+0x180>)
c0d02436:	4607      	mov	r7, r0
c0d02438:	e010      	b.n	c0d0245c <io_exchange+0x44>
          goto reply_apdu; 
        }
        // exit app after replied
        else if (os_memcmp(G_io_apdu_buffer, "\xB0\xA7\x00\x00", 4) == 0) {
          tx_len = 0;
          G_io_apdu_buffer[tx_len++] = 0x90;
c0d0243a:	2090      	movs	r0, #144	; 0x90
c0d0243c:	4957      	ldr	r1, [pc, #348]	; (c0d0259c <io_exchange+0x184>)
c0d0243e:	7008      	strb	r0, [r1, #0]
          G_io_apdu_buffer[tx_len++] = 0x00;
c0d02440:	704e      	strb	r6, [r1, #1]
c0d02442:	9a02      	ldr	r2, [sp, #8]
          // exit app after replied
          channel |= IO_RESET_AFTER_REPLIED;
c0d02444:	4317      	orrs	r7, r2
c0d02446:	2102      	movs	r1, #2
  }
  after_debug:
#endif // DEBUG_APDU

reply_apdu:
  switch(channel&~(IO_FLAGS)) {
c0d02448:	9801      	ldr	r0, [sp, #4]
c0d0244a:	4202      	tst	r2, r0
c0d0244c:	4638      	mov	r0, r7
c0d0244e:	d005      	beq.n	c0d0245c <io_exchange+0x44>
c0d02450:	e7e8      	b.n	c0d02424 <io_exchange+0xc>
      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
        // handle reserved apdus
        // get name and version
        if (os_memcmp(G_io_apdu_buffer, "\xB0\x01\x00\x00", 4) == 0) {
          tx_len = os_io_seproxyhal_get_app_name_and_version();
c0d02452:	f7ff ffbd 	bl	c0d023d0 <os_io_seproxyhal_get_app_name_and_version>
c0d02456:	4601      	mov	r1, r0
c0d02458:	4630      	mov	r0, r6
c0d0245a:	4637      	mov	r7, r6
reply_apdu:
  switch(channel&~(IO_FLAGS)) {
  case CHANNEL_APDU:
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
c0d0245c:	2610      	movs	r6, #16
c0d0245e:	4006      	ands	r6, r0
c0d02460:	040a      	lsls	r2, r1, #16
c0d02462:	9002      	str	r0, [sp, #8]
c0d02464:	d049      	beq.n	c0d024fa <io_exchange+0xe2>
c0d02466:	2e00      	cmp	r6, #0
c0d02468:	d147      	bne.n	c0d024fa <io_exchange+0xe2>
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d0246a:	7820      	ldrb	r0, [r4, #0]
c0d0246c:	2807      	cmp	r0, #7
c0d0246e:	d00b      	beq.n	c0d02488 <io_exchange+0x70>
c0d02470:	280a      	cmp	r0, #10
c0d02472:	d00f      	beq.n	c0d02494 <io_exchange+0x7c>
c0d02474:	2800      	cmp	r0, #0
c0d02476:	d100      	bne.n	c0d0247a <io_exchange+0x62>
c0d02478:	e085      	b.n	c0d02586 <io_exchange+0x16e>
          default: 
            // delegate to the hal in case of not generic transport mode (or asynch)
            if (io_exchange_al(channel, tx_len) == 0) {
c0d0247a:	b2f8      	uxtb	r0, r7
c0d0247c:	b289      	uxth	r1, r1
c0d0247e:	f7ff fa3f 	bl	c0d01900 <io_exchange_al>
c0d02482:	2800      	cmp	r0, #0
c0d02484:	d024      	beq.n	c0d024d0 <io_exchange+0xb8>
c0d02486:	e07e      	b.n	c0d02586 <io_exchange+0x16e>
            goto break_send;

#ifdef HAVE_USB_APDU
          case APDU_USB_HID:
            // only send, don't perform synchronous reception of the next command (will be done later by the seproxyhal packet processing)
            io_usb_hid_send(io_usb_send_apdu_data, tx_len);
c0d02488:	b289      	uxth	r1, r1
c0d0248a:	484c      	ldr	r0, [pc, #304]	; (c0d025bc <io_exchange+0x1a4>)
c0d0248c:	4478      	add	r0, pc
c0d0248e:	f7ff fc47 	bl	c0d01d20 <io_usb_hid_send>
c0d02492:	e01d      	b.n	c0d024d0 <io_exchange+0xb8>
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
            break;

          case APDU_RAW:
            if (tx_len > sizeof(G_io_apdu_buffer)) {
c0d02494:	20ff      	movs	r0, #255	; 0xff
c0d02496:	3006      	adds	r0, #6
c0d02498:	b28f      	uxth	r7, r1
c0d0249a:	4287      	cmp	r7, r0
c0d0249c:	d276      	bcs.n	c0d0258c <io_exchange+0x174>
              THROW(INVALID_PARAMETER);
            }
            // reply the RAW APDU over SEPROXYHAL protocol
            G_io_seproxyhal_spi_buffer[0]  = SEPROXYHAL_TAG_RAPDU;
c0d0249e:	2053      	movs	r0, #83	; 0x53
c0d024a0:	7028      	strb	r0, [r5, #0]
            G_io_seproxyhal_spi_buffer[1]  = (tx_len)>>8;
c0d024a2:	0a38      	lsrs	r0, r7, #8
c0d024a4:	7068      	strb	r0, [r5, #1]
            G_io_seproxyhal_spi_buffer[2]  = (tx_len);
c0d024a6:	70a9      	strb	r1, [r5, #2]
            io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d024a8:	2103      	movs	r1, #3
c0d024aa:	4628      	mov	r0, r5
c0d024ac:	f000 fe2e 	bl	c0d0310c <io_seproxyhal_spi_send>
            io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d024b0:	483a      	ldr	r0, [pc, #232]	; (c0d0259c <io_exchange+0x184>)
c0d024b2:	4639      	mov	r1, r7
c0d024b4:	f000 fe2a 	bl	c0d0310c <io_seproxyhal_spi_send>

            // isngle packet reply, mark immediate idle
            G_io_apdu_state = APDU_IDLE;
c0d024b8:	2000      	movs	r0, #0
c0d024ba:	7020      	strb	r0, [r4, #0]
c0d024bc:	e008      	b.n	c0d024d0 <io_exchange+0xb8>
        // wait end of reply transmission
        while (G_io_apdu_state != APDU_IDLE) {
#ifdef HAVE_TINY_COROUTINE
          tcr_yield();
#else // HAVE_TINY_COROUTINE
          io_seproxyhal_general_status();
c0d024be:	f7ff fc6d 	bl	c0d01d9c <io_seproxyhal_general_status>
          io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d024c2:	2180      	movs	r1, #128	; 0x80
c0d024c4:	2200      	movs	r2, #0
c0d024c6:	4628      	mov	r0, r5
c0d024c8:	f000 fe4c 	bl	c0d03164 <io_seproxyhal_spi_recv>
          // if packet is not well formed, then too bad ...
          io_seproxyhal_handle_event();
c0d024cc:	f7ff fd4a 	bl	c0d01f64 <io_seproxyhal_handle_event>
c0d024d0:	7820      	ldrb	r0, [r4, #0]
c0d024d2:	2800      	cmp	r0, #0
c0d024d4:	d1f3      	bne.n	c0d024be <io_exchange+0xa6>
c0d024d6:	2000      	movs	r0, #0
#endif // HAVE_TINY_COROUTINE
        }

        // reset apdu state
        G_io_apdu_state = APDU_IDLE;
c0d024d8:	7020      	strb	r0, [r4, #0]
        G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d024da:	4931      	ldr	r1, [pc, #196]	; (c0d025a0 <io_exchange+0x188>)
c0d024dc:	7008      	strb	r0, [r1, #0]

        G_io_apdu_length = 0;
c0d024de:	4931      	ldr	r1, [pc, #196]	; (c0d025a4 <io_exchange+0x18c>)
c0d024e0:	8008      	strh	r0, [r1, #0]

        // continue sending commands, don't issue status yet
        if (channel & IO_RETURN_AFTER_TX) {
c0d024e2:	9902      	ldr	r1, [sp, #8]
c0d024e4:	0689      	lsls	r1, r1, #26
c0d024e6:	d4a0      	bmi.n	c0d0242a <io_exchange+0x12>
          return 0;
        }
        // acknowledge the write request (general status OK) and no more command to follow (wait until another APDU container is received to continue unwrapping)
        io_seproxyhal_general_status();
c0d024e8:	f7ff fc58 	bl	c0d01d9c <io_seproxyhal_general_status>
c0d024ec:	9802      	ldr	r0, [sp, #8]
        break;
      }

      // perform reset after io exchange
      if (channel & IO_RESET_AFTER_REPLIED) {
c0d024ee:	0601      	lsls	r1, r0, #24
c0d024f0:	d503      	bpl.n	c0d024fa <io_exchange+0xe2>
        os_sched_exit(1);
c0d024f2:	2001      	movs	r0, #1
c0d024f4:	f000 fdb0 	bl	c0d03058 <os_sched_exit>
c0d024f8:	9802      	ldr	r0, [sp, #8]
        //reset();
      }
    }

#ifndef HAVE_TINY_COROUTINE
    if (!(channel&IO_ASYNCH_REPLY)) {
c0d024fa:	2e00      	cmp	r6, #0
c0d024fc:	d105      	bne.n	c0d0250a <io_exchange+0xf2>
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
c0d024fe:	0640      	lsls	r0, r0, #25
c0d02500:	d43c      	bmi.n	c0d0257c <io_exchange+0x164>
        // return apdu data - header
        return G_io_apdu_length-5;
      }

      // reply has ended, proceed to next apdu reception (reset status only after asynch reply)
      G_io_apdu_state = APDU_IDLE;
c0d02502:	2000      	movs	r0, #0
c0d02504:	7020      	strb	r0, [r4, #0]
      G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d02506:	4926      	ldr	r1, [pc, #152]	; (c0d025a0 <io_exchange+0x188>)
c0d02508:	7008      	strb	r0, [r1, #0]
    }
#endif // HAVE_TINY_COROUTINE

    // reset the received apdu length
    G_io_apdu_length = 0;
c0d0250a:	2000      	movs	r0, #0
c0d0250c:	4925      	ldr	r1, [pc, #148]	; (c0d025a4 <io_exchange+0x18c>)
c0d0250e:	8008      	strh	r0, [r1, #0]
#ifdef HAVE_TINY_COROUTINE
      // give back hand to the seph task which interprets all incoming events first
      tcr_yield();
#else // HAVE_TINY_COROUTINE

      if (!io_seproxyhal_spi_is_status_sent()) {
c0d02510:	f000 fe12 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d02514:	2800      	cmp	r0, #0
c0d02516:	d101      	bne.n	c0d0251c <io_exchange+0x104>
        io_seproxyhal_general_status();
c0d02518:	f7ff fc40 	bl	c0d01d9c <io_seproxyhal_general_status>
      }
      // wait until a SPI packet is available
      // NOTE: on ST31, dual wait ISO & RF (ISO instead of SPI)
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d0251c:	2780      	movs	r7, #128	; 0x80
c0d0251e:	2600      	movs	r6, #0
c0d02520:	4628      	mov	r0, r5
c0d02522:	4639      	mov	r1, r7
c0d02524:	4632      	mov	r2, r6
c0d02526:	f000 fe1d 	bl	c0d03164 <io_seproxyhal_spi_recv>

      // can't process split TLV, continue
      if (rx_len < 3 && rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
c0d0252a:	2802      	cmp	r0, #2
c0d0252c:	d806      	bhi.n	c0d0253c <io_exchange+0x124>
c0d0252e:	78a9      	ldrb	r1, [r5, #2]
c0d02530:	786a      	ldrb	r2, [r5, #1]
c0d02532:	0212      	lsls	r2, r2, #8
c0d02534:	430a      	orrs	r2, r1
c0d02536:	1ec0      	subs	r0, r0, #3
c0d02538:	4290      	cmp	r0, r2
c0d0253a:	d109      	bne.n	c0d02550 <io_exchange+0x138>
        G_io_apdu_state = APDU_IDLE;
        G_io_apdu_length = 0;
        continue;
      }

        io_seproxyhal_handle_event();
c0d0253c:	f7ff fd12 	bl	c0d01f64 <io_seproxyhal_handle_event>
#endif // HAVE_TINY_COROUTINE

      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
c0d02540:	7820      	ldrb	r0, [r4, #0]
c0d02542:	2800      	cmp	r0, #0
c0d02544:	d0e4      	beq.n	c0d02510 <io_exchange+0xf8>
c0d02546:	4817      	ldr	r0, [pc, #92]	; (c0d025a4 <io_exchange+0x18c>)
c0d02548:	8800      	ldrh	r0, [r0, #0]
c0d0254a:	2800      	cmp	r0, #0
c0d0254c:	d0e0      	beq.n	c0d02510 <io_exchange+0xf8>
c0d0254e:	e002      	b.n	c0d02556 <io_exchange+0x13e>
c0d02550:	2000      	movs	r0, #0
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);

      // can't process split TLV, continue
      if (rx_len < 3 && rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
        LOG("invalid TLV format\n");
        G_io_apdu_state = APDU_IDLE;
c0d02552:	7020      	strb	r0, [r4, #0]
c0d02554:	e7da      	b.n	c0d0250c <io_exchange+0xf4>

      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
        // handle reserved apdus
        // get name and version
        if (os_memcmp(G_io_apdu_buffer, "\xB0\x01\x00\x00", 4) == 0) {
c0d02556:	2204      	movs	r2, #4
c0d02558:	4810      	ldr	r0, [pc, #64]	; (c0d0259c <io_exchange+0x184>)
c0d0255a:	a114      	add	r1, pc, #80	; (adr r1, c0d025ac <io_exchange+0x194>)
c0d0255c:	f7ff fbfa 	bl	c0d01d54 <os_memcmp>
c0d02560:	2800      	cmp	r0, #0
c0d02562:	d100      	bne.n	c0d02566 <io_exchange+0x14e>
c0d02564:	e775      	b.n	c0d02452 <io_exchange+0x3a>
          // disable 'return after tx' and 'asynch reply' flags
          channel &= ~IO_FLAGS;
          goto reply_apdu; 
        }
        // exit app after replied
        else if (os_memcmp(G_io_apdu_buffer, "\xB0\xA7\x00\x00", 4) == 0) {
c0d02566:	2204      	movs	r2, #4
c0d02568:	480c      	ldr	r0, [pc, #48]	; (c0d0259c <io_exchange+0x184>)
c0d0256a:	a112      	add	r1, pc, #72	; (adr r1, c0d025b4 <io_exchange+0x19c>)
c0d0256c:	f7ff fbf2 	bl	c0d01d54 <os_memcmp>
c0d02570:	2800      	cmp	r0, #0
c0d02572:	d100      	bne.n	c0d02576 <io_exchange+0x15e>
c0d02574:	e761      	b.n	c0d0243a <io_exchange+0x22>
          // disable 'return after tx' and 'asynch reply' flags
          channel &= ~IO_FLAGS;
          goto reply_apdu; 
        }
#endif // HAVE_BOLOS_WITH_VIRGIN_ATTESTATION
        return G_io_apdu_length;
c0d02576:	480b      	ldr	r0, [pc, #44]	; (c0d025a4 <io_exchange+0x18c>)
c0d02578:	8800      	ldrh	r0, [r0, #0]
c0d0257a:	e756      	b.n	c0d0242a <io_exchange+0x12>
    if (!(channel&IO_ASYNCH_REPLY)) {
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
        // return apdu data - header
        return G_io_apdu_length-5;
c0d0257c:	4809      	ldr	r0, [pc, #36]	; (c0d025a4 <io_exchange+0x18c>)
c0d0257e:	8800      	ldrh	r0, [r0, #0]
c0d02580:	4909      	ldr	r1, [pc, #36]	; (c0d025a8 <io_exchange+0x190>)
c0d02582:	1840      	adds	r0, r0, r1
c0d02584:	e751      	b.n	c0d0242a <io_exchange+0x12>
            if (io_exchange_al(channel, tx_len) == 0) {
              goto break_send;
            }
          case APDU_IDLE:
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
c0d02586:	2009      	movs	r0, #9
c0d02588:	f7ff fbfb 	bl	c0d01d82 <os_longjmp>
            break;

          case APDU_RAW:
            if (tx_len > sizeof(G_io_apdu_buffer)) {
              THROW(INVALID_PARAMETER);
c0d0258c:	2002      	movs	r0, #2
c0d0258e:	f7ff fbf8 	bl	c0d01d82 <os_longjmp>
c0d02592:	46c0      	nop			; (mov r8, r8)
c0d02594:	20001e92 	.word	0x20001e92
c0d02598:	20001800 	.word	0x20001800
c0d0259c:	20001d70 	.word	0x20001d70
c0d025a0:	20001e7c 	.word	0x20001e7c
c0d025a4:	20001e94 	.word	0x20001e94
c0d025a8:	0000fffb 	.word	0x0000fffb
c0d025ac:	000001b0 	.word	0x000001b0
c0d025b0:	00000000 	.word	0x00000000
c0d025b4:	0000a7b0 	.word	0x0000a7b0
c0d025b8:	00000000 	.word	0x00000000
c0d025bc:	fffffa75 	.word	0xfffffa75

c0d025c0 <ux_menu_element_preprocessor>:
    return ux_menu.menu_iterator(entry_idx);
  } 
  return &ux_menu.menu_entries[entry_idx];
} 

const bagl_element_t* ux_menu_element_preprocessor(const bagl_element_t* element) {
c0d025c0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d025c2:	b081      	sub	sp, #4
c0d025c4:	4607      	mov	r7, r0
  //todo avoid center alignment when text_x or icon_x AND text_x are not 0
  os_memmove(&ux_menu.tmp_element, element, sizeof(bagl_element_t));
c0d025c6:	4c5f      	ldr	r4, [pc, #380]	; (c0d02744 <ux_menu_element_preprocessor+0x184>)
c0d025c8:	4625      	mov	r5, r4
c0d025ca:	3514      	adds	r5, #20
c0d025cc:	2238      	movs	r2, #56	; 0x38
c0d025ce:	4628      	mov	r0, r5
c0d025d0:	4639      	mov	r1, r7
c0d025d2:	f7ff fb22 	bl	c0d01c1a <os_memmove>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d025d6:	6921      	ldr	r1, [r4, #16]
const bagl_element_t* ux_menu_element_preprocessor(const bagl_element_t* element) {
  //todo avoid center alignment when text_x or icon_x AND text_x are not 0
  os_memmove(&ux_menu.tmp_element, element, sizeof(bagl_element_t));

  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d025d8:	68a0      	ldr	r0, [r4, #8]
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d025da:	2900      	cmp	r1, #0
c0d025dc:	d003      	beq.n	c0d025e6 <ux_menu_element_preprocessor+0x26>
    return ux_menu.menu_iterator(entry_idx);
c0d025de:	4788      	blx	r1
c0d025e0:	4603      	mov	r3, r0
c0d025e2:	68a0      	ldr	r0, [r4, #8]
c0d025e4:	e003      	b.n	c0d025ee <ux_menu_element_preprocessor+0x2e>
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d025e6:	211c      	movs	r1, #28
c0d025e8:	4341      	muls	r1, r0
c0d025ea:	6822      	ldr	r2, [r4, #0]
c0d025ec:	1853      	adds	r3, r2, r1
c0d025ee:	2600      	movs	r6, #0

  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
c0d025f0:	2800      	cmp	r0, #0
c0d025f2:	d010      	beq.n	c0d02616 <ux_menu_element_preprocessor+0x56>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d025f4:	6922      	ldr	r2, [r4, #16]
  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
c0d025f6:	1e41      	subs	r1, r0, #1
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d025f8:	2a00      	cmp	r2, #0
c0d025fa:	d00f      	beq.n	c0d0261c <ux_menu_element_preprocessor+0x5c>
    return ux_menu.menu_iterator(entry_idx);
c0d025fc:	4608      	mov	r0, r1
c0d025fe:	9700      	str	r7, [sp, #0]
c0d02600:	4637      	mov	r7, r6
c0d02602:	462e      	mov	r6, r5
c0d02604:	461d      	mov	r5, r3
c0d02606:	4790      	blx	r2
c0d02608:	462b      	mov	r3, r5
c0d0260a:	4635      	mov	r5, r6
c0d0260c:	463e      	mov	r6, r7
c0d0260e:	9f00      	ldr	r7, [sp, #0]
c0d02610:	4602      	mov	r2, r0
c0d02612:	68a0      	ldr	r0, [r4, #8]
c0d02614:	e006      	b.n	c0d02624 <ux_menu_element_preprocessor+0x64>
  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
c0d02616:	4630      	mov	r0, r6
c0d02618:	4632      	mov	r2, r6
c0d0261a:	e003      	b.n	c0d02624 <ux_menu_element_preprocessor+0x64>

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
    return ux_menu.menu_iterator(entry_idx);
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d0261c:	221c      	movs	r2, #28
c0d0261e:	434a      	muls	r2, r1
c0d02620:	6821      	ldr	r1, [r4, #0]
c0d02622:	188a      	adds	r2, r1, r2
  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
c0d02624:	6861      	ldr	r1, [r4, #4]
c0d02626:	1e49      	subs	r1, r1, #1
c0d02628:	4288      	cmp	r0, r1
c0d0262a:	d210      	bcs.n	c0d0264e <ux_menu_element_preprocessor+0x8e>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d0262c:	6921      	ldr	r1, [r4, #16]
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
c0d0262e:	1c40      	adds	r0, r0, #1
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d02630:	2900      	cmp	r1, #0
c0d02632:	d008      	beq.n	c0d02646 <ux_menu_element_preprocessor+0x86>
c0d02634:	9500      	str	r5, [sp, #0]
c0d02636:	461d      	mov	r5, r3
c0d02638:	4616      	mov	r6, r2
    return ux_menu.menu_iterator(entry_idx);
c0d0263a:	4788      	blx	r1
c0d0263c:	4632      	mov	r2, r6
c0d0263e:	462b      	mov	r3, r5
c0d02640:	9d00      	ldr	r5, [sp, #0]
c0d02642:	4606      	mov	r6, r0
c0d02644:	e003      	b.n	c0d0264e <ux_menu_element_preprocessor+0x8e>
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d02646:	211c      	movs	r1, #28
c0d02648:	4341      	muls	r1, r0
c0d0264a:	6820      	ldr	r0, [r4, #0]
c0d0264c:	1846      	adds	r6, r0, r1
c0d0264e:	7878      	ldrb	r0, [r7, #1]
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d02650:	2840      	cmp	r0, #64	; 0x40
c0d02652:	dc0a      	bgt.n	c0d0266a <ux_menu_element_preprocessor+0xaa>
c0d02654:	2820      	cmp	r0, #32
c0d02656:	dc22      	bgt.n	c0d0269e <ux_menu_element_preprocessor+0xde>
c0d02658:	2810      	cmp	r0, #16
c0d0265a:	d034      	beq.n	c0d026c6 <ux_menu_element_preprocessor+0x106>
c0d0265c:	2820      	cmp	r0, #32
c0d0265e:	d167      	bne.n	c0d02730 <ux_menu_element_preprocessor+0x170>
      if (current_entry->icon_x) {
        ux_menu.tmp_element.component.x = current_entry->icon_x;
      }
      break;
    case 0x20:
      if (current_entry->line2 != NULL) {
c0d02660:	6959      	ldr	r1, [r3, #20]
c0d02662:	2000      	movs	r0, #0
c0d02664:	2900      	cmp	r1, #0
c0d02666:	d16b      	bne.n	c0d02740 <ux_menu_element_preprocessor+0x180>
c0d02668:	e051      	b.n	c0d0270e <ux_menu_element_preprocessor+0x14e>
c0d0266a:	2880      	cmp	r0, #128	; 0x80
c0d0266c:	dc22      	bgt.n	c0d026b4 <ux_menu_element_preprocessor+0xf4>
c0d0266e:	2841      	cmp	r0, #65	; 0x41
c0d02670:	d033      	beq.n	c0d026da <ux_menu_element_preprocessor+0x11a>
c0d02672:	2842      	cmp	r0, #66	; 0x42
c0d02674:	d15c      	bne.n	c0d02730 <ux_menu_element_preprocessor+0x170>
      }
      ux_menu.tmp_element.text = previous_entry->line1;
      break;
    // next setting name
    case 0x42:
      if (current_entry->line2 != NULL 
c0d02676:	6959      	ldr	r1, [r3, #20]
c0d02678:	2000      	movs	r0, #0
        || current_entry->icon != NULL
c0d0267a:	2900      	cmp	r1, #0
c0d0267c:	d160      	bne.n	c0d02740 <ux_menu_element_preprocessor+0x180>
c0d0267e:	68d9      	ldr	r1, [r3, #12]
        || ux_menu.current_entry == ux_menu.menu_entries_count-1
c0d02680:	2900      	cmp	r1, #0
c0d02682:	d15d      	bne.n	c0d02740 <ux_menu_element_preprocessor+0x180>
c0d02684:	6862      	ldr	r2, [r4, #4]
c0d02686:	1e51      	subs	r1, r2, #1
        || ux_menu.menu_entries_count == 1
c0d02688:	2a01      	cmp	r2, #1
c0d0268a:	d059      	beq.n	c0d02740 <ux_menu_element_preprocessor+0x180>
      break;
    // next setting name
    case 0x42:
      if (current_entry->line2 != NULL 
        || current_entry->icon != NULL
        || ux_menu.current_entry == ux_menu.menu_entries_count-1
c0d0268c:	68a2      	ldr	r2, [r4, #8]
c0d0268e:	428a      	cmp	r2, r1
c0d02690:	d056      	beq.n	c0d02740 <ux_menu_element_preprocessor+0x180>
        || ux_menu.menu_entries_count == 1
        || next_entry->icon != NULL) {
c0d02692:	68f1      	ldr	r1, [r6, #12]
      }
      ux_menu.tmp_element.text = previous_entry->line1;
      break;
    // next setting name
    case 0x42:
      if (current_entry->line2 != NULL 
c0d02694:	2900      	cmp	r1, #0
c0d02696:	d153      	bne.n	c0d02740 <ux_menu_element_preprocessor+0x180>
        || ux_menu.current_entry == ux_menu.menu_entries_count-1
        || ux_menu.menu_entries_count == 1
        || next_entry->icon != NULL) {
        return NULL;
      }
      ux_menu.tmp_element.text = next_entry->line1;
c0d02698:	6930      	ldr	r0, [r6, #16]
c0d0269a:	6320      	str	r0, [r4, #48]	; 0x30
c0d0269c:	e048      	b.n	c0d02730 <ux_menu_element_preprocessor+0x170>
c0d0269e:	2821      	cmp	r0, #33	; 0x21
c0d026a0:	d031      	beq.n	c0d02706 <ux_menu_element_preprocessor+0x146>
c0d026a2:	2822      	cmp	r0, #34	; 0x22
c0d026a4:	d144      	bne.n	c0d02730 <ux_menu_element_preprocessor+0x170>
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line1;
      goto adjust_text_x;
    case 0x22:
      if (current_entry->line2 == NULL) {
c0d026a6:	4619      	mov	r1, r3
c0d026a8:	3114      	adds	r1, #20
c0d026aa:	695a      	ldr	r2, [r3, #20]
c0d026ac:	2000      	movs	r0, #0
c0d026ae:	2a00      	cmp	r2, #0
c0d026b0:	d12f      	bne.n	c0d02712 <ux_menu_element_preprocessor+0x152>
c0d026b2:	e045      	b.n	c0d02740 <ux_menu_element_preprocessor+0x180>
c0d026b4:	2882      	cmp	r0, #130	; 0x82
c0d026b6:	d035      	beq.n	c0d02724 <ux_menu_element_preprocessor+0x164>
c0d026b8:	2881      	cmp	r0, #129	; 0x81
c0d026ba:	d139      	bne.n	c0d02730 <ux_menu_element_preprocessor+0x170>
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
    case 0x81:
      if (ux_menu.current_entry == 0) {
c0d026bc:	68a1      	ldr	r1, [r4, #8]
c0d026be:	2000      	movs	r0, #0
c0d026c0:	2900      	cmp	r1, #0
c0d026c2:	d135      	bne.n	c0d02730 <ux_menu_element_preprocessor+0x170>
c0d026c4:	e03c      	b.n	c0d02740 <ux_menu_element_preprocessor+0x180>
        return NULL;
      }
      ux_menu.tmp_element.text = next_entry->line1;
      break;
    case 0x10:
      if (current_entry->icon == NULL) {
c0d026c6:	68d9      	ldr	r1, [r3, #12]
c0d026c8:	2000      	movs	r0, #0
c0d026ca:	2900      	cmp	r1, #0
c0d026cc:	d038      	beq.n	c0d02740 <ux_menu_element_preprocessor+0x180>
        return NULL;
      }
      ux_menu.tmp_element.text = (const char*)current_entry->icon;
c0d026ce:	6321      	str	r1, [r4, #48]	; 0x30
      if (current_entry->icon_x) {
c0d026d0:	7e58      	ldrb	r0, [r3, #25]
c0d026d2:	2800      	cmp	r0, #0
c0d026d4:	d02c      	beq.n	c0d02730 <ux_menu_element_preprocessor+0x170>
        ux_menu.tmp_element.component.x = current_entry->icon_x;
c0d026d6:	82e0      	strh	r0, [r4, #22]
c0d026d8:	e02a      	b.n	c0d02730 <ux_menu_element_preprocessor+0x170>
        return NULL;
      }
      break;
    // previous setting name
    case 0x41:
      if (current_entry->line2 != NULL 
c0d026da:	6959      	ldr	r1, [r3, #20]
c0d026dc:	2000      	movs	r0, #0
        || current_entry->icon != NULL
c0d026de:	2900      	cmp	r1, #0
c0d026e0:	d12e      	bne.n	c0d02740 <ux_menu_element_preprocessor+0x180>
c0d026e2:	68d9      	ldr	r1, [r3, #12]
        || ux_menu.current_entry == 0
c0d026e4:	2900      	cmp	r1, #0
c0d026e6:	d12b      	bne.n	c0d02740 <ux_menu_element_preprocessor+0x180>
c0d026e8:	68a1      	ldr	r1, [r4, #8]
c0d026ea:	2900      	cmp	r1, #0
c0d026ec:	d028      	beq.n	c0d02740 <ux_menu_element_preprocessor+0x180>
        || ux_menu.menu_entries_count == 1 
c0d026ee:	6861      	ldr	r1, [r4, #4]
c0d026f0:	2901      	cmp	r1, #1
c0d026f2:	d025      	beq.n	c0d02740 <ux_menu_element_preprocessor+0x180>
        || previous_entry->icon != NULL
c0d026f4:	68d1      	ldr	r1, [r2, #12]
        || previous_entry->line2 != NULL) {
c0d026f6:	2900      	cmp	r1, #0
c0d026f8:	d122      	bne.n	c0d02740 <ux_menu_element_preprocessor+0x180>
c0d026fa:	6951      	ldr	r1, [r2, #20]
        return NULL;
      }
      break;
    // previous setting name
    case 0x41:
      if (current_entry->line2 != NULL 
c0d026fc:	2900      	cmp	r1, #0
c0d026fe:	d11f      	bne.n	c0d02740 <ux_menu_element_preprocessor+0x180>
        || ux_menu.menu_entries_count == 1 
        || previous_entry->icon != NULL
        || previous_entry->line2 != NULL) {
        return 0;
      }
      ux_menu.tmp_element.text = previous_entry->line1;
c0d02700:	6910      	ldr	r0, [r2, #16]
c0d02702:	6320      	str	r0, [r4, #48]	; 0x30
c0d02704:	e014      	b.n	c0d02730 <ux_menu_element_preprocessor+0x170>
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line1;
      goto adjust_text_x;
    case 0x21:
      if (current_entry->line2 == NULL) {
c0d02706:	6959      	ldr	r1, [r3, #20]
c0d02708:	2000      	movs	r0, #0
c0d0270a:	2900      	cmp	r1, #0
c0d0270c:	d018      	beq.n	c0d02740 <ux_menu_element_preprocessor+0x180>
c0d0270e:	4619      	mov	r1, r3
c0d02710:	3110      	adds	r1, #16
c0d02712:	6808      	ldr	r0, [r1, #0]
c0d02714:	6320      	str	r0, [r4, #48]	; 0x30
      if (current_entry->line2 == NULL) {
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line2;
    adjust_text_x:
      if (current_entry->text_x) {
c0d02716:	7e18      	ldrb	r0, [r3, #24]
c0d02718:	2800      	cmp	r0, #0
c0d0271a:	d009      	beq.n	c0d02730 <ux_menu_element_preprocessor+0x170>
        ux_menu.tmp_element.component.x = current_entry->text_x;
c0d0271c:	82e0      	strh	r0, [r4, #22]
        // discard the 'center' flag
        ux_menu.tmp_element.component.font_id = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px;
c0d0271e:	2008      	movs	r0, #8
c0d02720:	85a0      	strh	r0, [r4, #44]	; 0x2c
c0d02722:	e005      	b.n	c0d02730 <ux_menu_element_preprocessor+0x170>
      if (ux_menu.current_entry == 0) {
        return NULL;
      }
      break;
    case 0x82:
      if (ux_menu.current_entry == ux_menu.menu_entries_count-1) {
c0d02724:	6860      	ldr	r0, [r4, #4]
c0d02726:	68a1      	ldr	r1, [r4, #8]
c0d02728:	1e42      	subs	r2, r0, #1
c0d0272a:	2000      	movs	r0, #0
c0d0272c:	4291      	cmp	r1, r2
c0d0272e:	d007      	beq.n	c0d02740 <ux_menu_element_preprocessor+0x180>
        ux_menu.tmp_element.component.font_id = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px;
      }
      break;
  }
  // ensure prepro agrees to the element to be displayed
  if (ux_menu.menu_entry_preprocessor) {
c0d02730:	68e2      	ldr	r2, [r4, #12]
c0d02732:	2a00      	cmp	r2, #0
c0d02734:	4628      	mov	r0, r5
c0d02736:	d003      	beq.n	c0d02740 <ux_menu_element_preprocessor+0x180>
    // menu is denied by the menu entry preprocessor
    return ux_menu.menu_entry_preprocessor(current_entry, &ux_menu.tmp_element);
c0d02738:	3414      	adds	r4, #20
c0d0273a:	4618      	mov	r0, r3
c0d0273c:	4621      	mov	r1, r4
c0d0273e:	4790      	blx	r2
  }

  return &ux_menu.tmp_element;
}
c0d02740:	b001      	add	sp, #4
c0d02742:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02744:	20001ea4 	.word	0x20001ea4

c0d02748 <ux_menu_elements_button>:

unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
c0d02748:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0274a:	b081      	sub	sp, #4
c0d0274c:	4605      	mov	r5, r0
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d0274e:	4f3d      	ldr	r7, [pc, #244]	; (c0d02844 <ux_menu_elements_button+0xfc>)
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d02750:	6939      	ldr	r1, [r7, #16]
}

unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d02752:	68b8      	ldr	r0, [r7, #8]
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d02754:	2900      	cmp	r1, #0
c0d02756:	d002      	beq.n	c0d0275e <ux_menu_elements_button+0x16>
    return ux_menu.menu_iterator(entry_idx);
c0d02758:	4788      	blx	r1
c0d0275a:	4606      	mov	r6, r0
c0d0275c:	e003      	b.n	c0d02766 <ux_menu_elements_button+0x1e>
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d0275e:	211c      	movs	r1, #28
c0d02760:	4341      	muls	r1, r0
c0d02762:	6838      	ldr	r0, [r7, #0]
c0d02764:	1846      	adds	r6, r0, r1
c0d02766:	2401      	movs	r4, #1
unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  switch (button_mask) {
c0d02768:	4837      	ldr	r0, [pc, #220]	; (c0d02848 <ux_menu_elements_button+0x100>)
c0d0276a:	4285      	cmp	r5, r0
c0d0276c:	dd14      	ble.n	c0d02798 <ux_menu_elements_button+0x50>
c0d0276e:	4837      	ldr	r0, [pc, #220]	; (c0d0284c <ux_menu_elements_button+0x104>)
c0d02770:	4285      	cmp	r5, r0
c0d02772:	d017      	beq.n	c0d027a4 <ux_menu_elements_button+0x5c>
c0d02774:	4836      	ldr	r0, [pc, #216]	; (c0d02850 <ux_menu_elements_button+0x108>)
c0d02776:	4285      	cmp	r5, r0
c0d02778:	d01c      	beq.n	c0d027b4 <ux_menu_elements_button+0x6c>
c0d0277a:	4836      	ldr	r0, [pc, #216]	; (c0d02854 <ux_menu_elements_button+0x10c>)
c0d0277c:	4285      	cmp	r5, r0
c0d0277e:	d15e      	bne.n	c0d0283e <ux_menu_elements_button+0xf6>
    // enter menu or exit menu
    case BUTTON_EVT_RELEASED|BUTTON_LEFT|BUTTON_RIGHT:
      // menu is priority 1
      if (current_entry->menu) {
c0d02780:	6830      	ldr	r0, [r6, #0]
c0d02782:	2800      	cmp	r0, #0
c0d02784:	d052      	beq.n	c0d0282c <ux_menu_elements_button+0xe4>
        // use userid as the pointer to current entry in the parent menu
        UX_MENU_DISPLAY(current_entry->userid, (const ux_menu_entry_t*)PIC(current_entry->menu), ux_menu.menu_entry_preprocessor);
c0d02786:	68b4      	ldr	r4, [r6, #8]
c0d02788:	f000 f902 	bl	c0d02990 <pic>
c0d0278c:	4601      	mov	r1, r0
c0d0278e:	68fa      	ldr	r2, [r7, #12]
c0d02790:	4620      	mov	r0, r4
c0d02792:	f000 f86d 	bl	c0d02870 <ux_menu_display>
c0d02796:	e051      	b.n	c0d0283c <ux_menu_elements_button+0xf4>
c0d02798:	482f      	ldr	r0, [pc, #188]	; (c0d02858 <ux_menu_elements_button+0x110>)
c0d0279a:	4285      	cmp	r5, r0
c0d0279c:	d00a      	beq.n	c0d027b4 <ux_menu_elements_button+0x6c>
c0d0279e:	482a      	ldr	r0, [pc, #168]	; (c0d02848 <ux_menu_elements_button+0x100>)
c0d027a0:	4285      	cmp	r5, r0
c0d027a2:	d14c      	bne.n	c0d0283e <ux_menu_elements_button+0xf6>
      goto redraw;

    case BUTTON_EVT_FAST|BUTTON_RIGHT:
    case BUTTON_EVT_RELEASED|BUTTON_RIGHT:
      // entry 0 is the number of entries in the menu list
      if (ux_menu.current_entry >= ux_menu.menu_entries_count-1) {
c0d027a4:	6879      	ldr	r1, [r7, #4]
c0d027a6:	68b8      	ldr	r0, [r7, #8]
c0d027a8:	1e4a      	subs	r2, r1, #1
c0d027aa:	2400      	movs	r4, #0
c0d027ac:	2101      	movs	r1, #1
c0d027ae:	4290      	cmp	r0, r2
c0d027b0:	d305      	bcc.n	c0d027be <ux_menu_elements_button+0x76>
c0d027b2:	e044      	b.n	c0d0283e <ux_menu_elements_button+0xf6>
c0d027b4:	2400      	movs	r4, #0
c0d027b6:	43e1      	mvns	r1, r4
      break;

    case BUTTON_EVT_FAST|BUTTON_LEFT:
    case BUTTON_EVT_RELEASED|BUTTON_LEFT:
      // entry 0 is the number of entries in the menu list
      if (ux_menu.current_entry == 0) {
c0d027b8:	68b8      	ldr	r0, [r7, #8]
c0d027ba:	2800      	cmp	r0, #0
c0d027bc:	d03f      	beq.n	c0d0283e <ux_menu_elements_button+0xf6>
c0d027be:	1840      	adds	r0, r0, r1
c0d027c0:	60b8      	str	r0, [r7, #8]
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d027c2:	4826      	ldr	r0, [pc, #152]	; (c0d0285c <ux_menu_elements_button+0x114>)
c0d027c4:	2400      	movs	r4, #0
c0d027c6:	6004      	str	r4, [r0, #0]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d027c8:	4825      	ldr	r0, [pc, #148]	; (c0d02860 <ux_menu_elements_button+0x118>)
c0d027ca:	6004      	str	r4, [r0, #0]
  G_button_same_mask_counter = 0;
c0d027cc:	4825      	ldr	r0, [pc, #148]	; (c0d02864 <ux_menu_elements_button+0x11c>)
c0d027ce:	6004      	str	r4, [r0, #0]
      ux_menu.current_entry++;
    redraw:
#ifdef HAVE_BOLOS_UX
      screen_display_init(0);
#else
      UX_REDISPLAY();
c0d027d0:	4d25      	ldr	r5, [pc, #148]	; (c0d02868 <ux_menu_elements_button+0x120>)
c0d027d2:	60ac      	str	r4, [r5, #8]
c0d027d4:	6828      	ldr	r0, [r5, #0]
c0d027d6:	2800      	cmp	r0, #0
c0d027d8:	d031      	beq.n	c0d0283e <ux_menu_elements_button+0xf6>
c0d027da:	69e8      	ldr	r0, [r5, #28]
c0d027dc:	4923      	ldr	r1, [pc, #140]	; (c0d0286c <ux_menu_elements_button+0x124>)
c0d027de:	4288      	cmp	r0, r1
c0d027e0:	d02d      	beq.n	c0d0283e <ux_menu_elements_button+0xf6>
c0d027e2:	2800      	cmp	r0, #0
c0d027e4:	d02b      	beq.n	c0d0283e <ux_menu_elements_button+0xf6>
c0d027e6:	2400      	movs	r4, #0
c0d027e8:	4620      	mov	r0, r4
c0d027ea:	6869      	ldr	r1, [r5, #4]
c0d027ec:	4288      	cmp	r0, r1
c0d027ee:	d226      	bcs.n	c0d0283e <ux_menu_elements_button+0xf6>
c0d027f0:	f000 fca2 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d027f4:	2800      	cmp	r0, #0
c0d027f6:	d122      	bne.n	c0d0283e <ux_menu_elements_button+0xf6>
c0d027f8:	68a8      	ldr	r0, [r5, #8]
c0d027fa:	68e9      	ldr	r1, [r5, #12]
c0d027fc:	2638      	movs	r6, #56	; 0x38
c0d027fe:	4370      	muls	r0, r6
c0d02800:	682a      	ldr	r2, [r5, #0]
c0d02802:	1810      	adds	r0, r2, r0
c0d02804:	2900      	cmp	r1, #0
c0d02806:	d002      	beq.n	c0d0280e <ux_menu_elements_button+0xc6>
c0d02808:	4788      	blx	r1
c0d0280a:	2800      	cmp	r0, #0
c0d0280c:	d007      	beq.n	c0d0281e <ux_menu_elements_button+0xd6>
c0d0280e:	2801      	cmp	r0, #1
c0d02810:	d103      	bne.n	c0d0281a <ux_menu_elements_button+0xd2>
c0d02812:	68a8      	ldr	r0, [r5, #8]
c0d02814:	4346      	muls	r6, r0
c0d02816:	6828      	ldr	r0, [r5, #0]
c0d02818:	1980      	adds	r0, r0, r6
c0d0281a:	f7fe fd73 	bl	c0d01304 <io_seproxyhal_display>
c0d0281e:	68a8      	ldr	r0, [r5, #8]
c0d02820:	1c40      	adds	r0, r0, #1
c0d02822:	60a8      	str	r0, [r5, #8]
c0d02824:	6829      	ldr	r1, [r5, #0]
c0d02826:	2900      	cmp	r1, #0
c0d02828:	d1df      	bne.n	c0d027ea <ux_menu_elements_button+0xa2>
c0d0282a:	e008      	b.n	c0d0283e <ux_menu_elements_button+0xf6>
        // use userid as the pointer to current entry in the parent menu
        UX_MENU_DISPLAY(current_entry->userid, (const ux_menu_entry_t*)PIC(current_entry->menu), ux_menu.menu_entry_preprocessor);
        return 0;
      }
      // else callback
      else if (current_entry->callback) {
c0d0282c:	6870      	ldr	r0, [r6, #4]
c0d0282e:	2800      	cmp	r0, #0
c0d02830:	d005      	beq.n	c0d0283e <ux_menu_elements_button+0xf6>
        ((ux_menu_callback_t)PIC(current_entry->callback))(current_entry->userid);
c0d02832:	f000 f8ad 	bl	c0d02990 <pic>
c0d02836:	4601      	mov	r1, r0
c0d02838:	68b0      	ldr	r0, [r6, #8]
c0d0283a:	4788      	blx	r1
c0d0283c:	2400      	movs	r4, #0
      UX_REDISPLAY();
#endif
      return 0;
  }
  return 1;
}
c0d0283e:	4620      	mov	r0, r4
c0d02840:	b001      	add	sp, #4
c0d02842:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02844:	20001ea4 	.word	0x20001ea4
c0d02848:	80000002 	.word	0x80000002
c0d0284c:	40000002 	.word	0x40000002
c0d02850:	40000001 	.word	0x40000001
c0d02854:	80000003 	.word	0x80000003
c0d02858:	80000001 	.word	0x80000001
c0d0285c:	20001e98 	.word	0x20001e98
c0d02860:	20001e9c 	.word	0x20001e9c
c0d02864:	20001ea0 	.word	0x20001ea0
c0d02868:	20001880 	.word	0x20001880
c0d0286c:	b0105044 	.word	0xb0105044

c0d02870 <ux_menu_display>:

const ux_menu_entry_t UX_MENU_END_ENTRY = UX_MENU_END;

void ux_menu_display(unsigned int current_entry, 
                     const ux_menu_entry_t* menu_entries,
                     ux_menu_preprocessor_t menu_entry_preprocessor) {
c0d02870:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02872:	b083      	sub	sp, #12
c0d02874:	9202      	str	r2, [sp, #8]
c0d02876:	460d      	mov	r5, r1
c0d02878:	9001      	str	r0, [sp, #4]
  // reset to first entry
  ux_menu.menu_entries_count = 0;
c0d0287a:	4e39      	ldr	r6, [pc, #228]	; (c0d02960 <ux_menu_display+0xf0>)
c0d0287c:	2000      	movs	r0, #0
c0d0287e:	9000      	str	r0, [sp, #0]
c0d02880:	6070      	str	r0, [r6, #4]

  // count entries
  if (menu_entries) {
c0d02882:	2d00      	cmp	r5, #0
c0d02884:	d015      	beq.n	c0d028b2 <ux_menu_display+0x42>
    for(;;) {
      if (os_memcmp(&menu_entries[ux_menu.menu_entries_count], &UX_MENU_END_ENTRY, sizeof(ux_menu_entry_t)) == 0) {
c0d02886:	493c      	ldr	r1, [pc, #240]	; (c0d02978 <ux_menu_display+0x108>)
c0d02888:	4479      	add	r1, pc
c0d0288a:	271c      	movs	r7, #28
c0d0288c:	4628      	mov	r0, r5
c0d0288e:	463a      	mov	r2, r7
c0d02890:	f7ff fa60 	bl	c0d01d54 <os_memcmp>
c0d02894:	2800      	cmp	r0, #0
c0d02896:	d00c      	beq.n	c0d028b2 <ux_menu_display+0x42>
c0d02898:	4c38      	ldr	r4, [pc, #224]	; (c0d0297c <ux_menu_display+0x10c>)
c0d0289a:	447c      	add	r4, pc
        break;
      }
      ux_menu.menu_entries_count++;
c0d0289c:	6870      	ldr	r0, [r6, #4]
c0d0289e:	1c40      	adds	r0, r0, #1
c0d028a0:	6070      	str	r0, [r6, #4]
  ux_menu.menu_entries_count = 0;

  // count entries
  if (menu_entries) {
    for(;;) {
      if (os_memcmp(&menu_entries[ux_menu.menu_entries_count], &UX_MENU_END_ENTRY, sizeof(ux_menu_entry_t)) == 0) {
c0d028a2:	4378      	muls	r0, r7
c0d028a4:	1828      	adds	r0, r5, r0
c0d028a6:	4621      	mov	r1, r4
c0d028a8:	463a      	mov	r2, r7
c0d028aa:	f7ff fa53 	bl	c0d01d54 <os_memcmp>
c0d028ae:	2800      	cmp	r0, #0
c0d028b0:	d1f4      	bne.n	c0d0289c <ux_menu_display+0x2c>
c0d028b2:	9901      	ldr	r1, [sp, #4]
      }
      ux_menu.menu_entries_count++;
    }
  }

  if (current_entry != UX_MENU_UNCHANGED_ENTRY) {
c0d028b4:	4608      	mov	r0, r1
c0d028b6:	3001      	adds	r0, #1
c0d028b8:	d005      	beq.n	c0d028c6 <ux_menu_display+0x56>
    ux_menu.current_entry = current_entry;
    if (ux_menu.current_entry > ux_menu.menu_entries_count) {
c0d028ba:	6870      	ldr	r0, [r6, #4]
c0d028bc:	4288      	cmp	r0, r1
c0d028be:	9800      	ldr	r0, [sp, #0]
c0d028c0:	d300      	bcc.n	c0d028c4 <ux_menu_display+0x54>
c0d028c2:	4608      	mov	r0, r1
      ux_menu.current_entry = 0;
c0d028c4:	60b0      	str	r0, [r6, #8]
    }
  }
  ux_menu.menu_entries = menu_entries;
c0d028c6:	6035      	str	r5, [r6, #0]
c0d028c8:	2500      	movs	r5, #0
  ux_menu.menu_entry_preprocessor = menu_entry_preprocessor;
c0d028ca:	9802      	ldr	r0, [sp, #8]
c0d028cc:	60f0      	str	r0, [r6, #12]
  ux_menu.menu_iterator = NULL;
c0d028ce:	6135      	str	r5, [r6, #16]
  G_bolos_ux_context.screen_stack[0].button_push_callback = ux_menu_elements_button;

  screen_display_init(0);
#else
  // display the menu current entry
  UX_DISPLAY(ux_menu_elements, ux_menu_element_preprocessor);
c0d028d0:	4c24      	ldr	r4, [pc, #144]	; (c0d02964 <ux_menu_display+0xf4>)
c0d028d2:	482b      	ldr	r0, [pc, #172]	; (c0d02980 <ux_menu_display+0x110>)
c0d028d4:	4478      	add	r0, pc
c0d028d6:	6020      	str	r0, [r4, #0]
c0d028d8:	2009      	movs	r0, #9
c0d028da:	6060      	str	r0, [r4, #4]
c0d028dc:	4829      	ldr	r0, [pc, #164]	; (c0d02984 <ux_menu_display+0x114>)
c0d028de:	4478      	add	r0, pc
c0d028e0:	6120      	str	r0, [r4, #16]
c0d028e2:	4829      	ldr	r0, [pc, #164]	; (c0d02988 <ux_menu_display+0x118>)
c0d028e4:	4478      	add	r0, pc
c0d028e6:	60e0      	str	r0, [r4, #12]
c0d028e8:	2003      	movs	r0, #3
c0d028ea:	7620      	strb	r0, [r4, #24]
c0d028ec:	61e5      	str	r5, [r4, #28]
c0d028ee:	4620      	mov	r0, r4
c0d028f0:	3018      	adds	r0, #24
c0d028f2:	f000 fbc7 	bl	c0d03084 <os_ux>
c0d028f6:	61e0      	str	r0, [r4, #28]
c0d028f8:	f000 f848 	bl	c0d0298c <ux_check_status_default>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d028fc:	481a      	ldr	r0, [pc, #104]	; (c0d02968 <ux_menu_display+0xf8>)
c0d028fe:	6005      	str	r5, [r0, #0]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d02900:	481a      	ldr	r0, [pc, #104]	; (c0d0296c <ux_menu_display+0xfc>)
c0d02902:	6005      	str	r5, [r0, #0]
  G_button_same_mask_counter = 0;
c0d02904:	481a      	ldr	r0, [pc, #104]	; (c0d02970 <ux_menu_display+0x100>)
c0d02906:	6005      	str	r5, [r0, #0]
  G_bolos_ux_context.screen_stack[0].button_push_callback = ux_menu_elements_button;

  screen_display_init(0);
#else
  // display the menu current entry
  UX_DISPLAY(ux_menu_elements, ux_menu_element_preprocessor);
c0d02908:	60a5      	str	r5, [r4, #8]
c0d0290a:	6820      	ldr	r0, [r4, #0]
c0d0290c:	2800      	cmp	r0, #0
c0d0290e:	d024      	beq.n	c0d0295a <ux_menu_display+0xea>
c0d02910:	69e0      	ldr	r0, [r4, #28]
c0d02912:	4918      	ldr	r1, [pc, #96]	; (c0d02974 <ux_menu_display+0x104>)
c0d02914:	4288      	cmp	r0, r1
c0d02916:	d11e      	bne.n	c0d02956 <ux_menu_display+0xe6>
c0d02918:	e01f      	b.n	c0d0295a <ux_menu_display+0xea>
c0d0291a:	6860      	ldr	r0, [r4, #4]
c0d0291c:	4285      	cmp	r5, r0
c0d0291e:	d21c      	bcs.n	c0d0295a <ux_menu_display+0xea>
c0d02920:	f000 fc0a 	bl	c0d03138 <io_seproxyhal_spi_is_status_sent>
c0d02924:	2800      	cmp	r0, #0
c0d02926:	d118      	bne.n	c0d0295a <ux_menu_display+0xea>
c0d02928:	68a0      	ldr	r0, [r4, #8]
c0d0292a:	68e1      	ldr	r1, [r4, #12]
c0d0292c:	2538      	movs	r5, #56	; 0x38
c0d0292e:	4368      	muls	r0, r5
c0d02930:	6822      	ldr	r2, [r4, #0]
c0d02932:	1810      	adds	r0, r2, r0
c0d02934:	2900      	cmp	r1, #0
c0d02936:	d002      	beq.n	c0d0293e <ux_menu_display+0xce>
c0d02938:	4788      	blx	r1
c0d0293a:	2800      	cmp	r0, #0
c0d0293c:	d007      	beq.n	c0d0294e <ux_menu_display+0xde>
c0d0293e:	2801      	cmp	r0, #1
c0d02940:	d103      	bne.n	c0d0294a <ux_menu_display+0xda>
c0d02942:	68a0      	ldr	r0, [r4, #8]
c0d02944:	4345      	muls	r5, r0
c0d02946:	6820      	ldr	r0, [r4, #0]
c0d02948:	1940      	adds	r0, r0, r5
c0d0294a:	f7fe fcdb 	bl	c0d01304 <io_seproxyhal_display>
c0d0294e:	68a0      	ldr	r0, [r4, #8]
c0d02950:	1c45      	adds	r5, r0, #1
c0d02952:	60a5      	str	r5, [r4, #8]
c0d02954:	6820      	ldr	r0, [r4, #0]
c0d02956:	2800      	cmp	r0, #0
c0d02958:	d1df      	bne.n	c0d0291a <ux_menu_display+0xaa>
#endif
}
c0d0295a:	b003      	add	sp, #12
c0d0295c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0295e:	46c0      	nop			; (mov r8, r8)
c0d02960:	20001ea4 	.word	0x20001ea4
c0d02964:	20001880 	.word	0x20001880
c0d02968:	20001e98 	.word	0x20001e98
c0d0296c:	20001e9c 	.word	0x20001e9c
c0d02970:	20001ea0 	.word	0x20001ea0
c0d02974:	b0105044 	.word	0xb0105044
c0d02978:	00003354 	.word	0x00003354
c0d0297c:	00003342 	.word	0x00003342
c0d02980:	00003110 	.word	0x00003110
c0d02984:	fffffe67 	.word	0xfffffe67
c0d02988:	fffffcd9 	.word	0xfffffcd9

c0d0298c <ux_check_status_default>:
}

void ux_check_status_default(unsigned int status) {
  // nothing to be done here by default.
  UNUSED(status);
}
c0d0298c:	4770      	bx	lr
	...

c0d02990 <pic>:

// only apply PIC conversion if link_address is in linked code (over 0xC0D00000 in our example)
// this way, PIC call are armless if the address is not meant to be converted
extern unsigned int _nvram;
extern unsigned int _envram;
unsigned int pic(unsigned int link_address) {
c0d02990:	b580      	push	{r7, lr}
//  screen_printf(" %08X", link_address);
	if (link_address >= ((unsigned int)&_nvram) && link_address < ((unsigned int)&_envram)) {
c0d02992:	4904      	ldr	r1, [pc, #16]	; (c0d029a4 <pic+0x14>)
c0d02994:	4288      	cmp	r0, r1
c0d02996:	d304      	bcc.n	c0d029a2 <pic+0x12>
c0d02998:	4903      	ldr	r1, [pc, #12]	; (c0d029a8 <pic+0x18>)
c0d0299a:	4288      	cmp	r0, r1
c0d0299c:	d201      	bcs.n	c0d029a2 <pic+0x12>
		link_address = pic_internal(link_address);
c0d0299e:	f000 f805 	bl	c0d029ac <pic_internal>
//    screen_printf(" -> %08X\n", link_address);
  }
	return link_address;
c0d029a2:	bd80      	pop	{r7, pc}
c0d029a4:	c0d00000 	.word	0xc0d00000
c0d029a8:	c0d05d40 	.word	0xc0d05d40

c0d029ac <pic_internal>:

unsigned int pic_internal(unsigned int link_address) __attribute__((naked));
unsigned int pic_internal(unsigned int link_address) 
{
  // compute the delta offset between LinkMemAddr & ExecMemAddr
  __asm volatile ("mov r2, pc\n");          // r2 = 0x109004
c0d029ac:	467a      	mov	r2, pc
  __asm volatile ("ldr r1, =pic_internal\n");        // r1 = 0xC0D00001
c0d029ae:	4902      	ldr	r1, [pc, #8]	; (c0d029b8 <pic_internal+0xc>)
  __asm volatile ("adds r1, r1, #3\n");     // r1 = 0xC0D00004
c0d029b0:	1cc9      	adds	r1, r1, #3
  __asm volatile ("subs r1, r1, r2\n");     // r1 = 0xC0BF7000 (delta between load and exec address)
c0d029b2:	1a89      	subs	r1, r1, r2

  // adjust value of the given parameter
  __asm volatile ("subs r0, r0, r1\n");     // r0 = 0xC0D0C244 => r0 = 0x115244
c0d029b4:	1a40      	subs	r0, r0, r1
  __asm volatile ("bx lr\n");
c0d029b6:	4770      	bx	lr
c0d029b8:	c0d029ad 	.word	0xc0d029ad

c0d029bc <rlpCanDecode>:
#include <stdint.h>

#include "rlp.h"
#define PRINTF(x, ...) {}

bool rlpCanDecode(uint8_t *buffer, uint32_t bufferLength, bool *valid) {
c0d029bc:	b570      	push	{r4, r5, r6, lr}
    if (*buffer <= 0x7f) {
c0d029be:	7800      	ldrb	r0, [r0, #0]
c0d029c0:	b240      	sxtb	r0, r0
c0d029c2:	2347      	movs	r3, #71	; 0x47
c0d029c4:	43db      	mvns	r3, r3
c0d029c6:	3347      	adds	r3, #71	; 0x47
c0d029c8:	b25d      	sxtb	r5, r3
c0d029ca:	2301      	movs	r3, #1
c0d029cc:	24b8      	movs	r4, #184	; 0xb8
c0d029ce:	42a8      	cmp	r0, r5
c0d029d0:	dc1f      	bgt.n	c0d02a12 <rlpCanDecode+0x56>
c0d029d2:	b2c5      	uxtb	r5, r0
c0d029d4:	42a5      	cmp	r5, r4
c0d029d6:	d31c      	bcc.n	c0d02a12 <rlpCanDecode+0x56>
    } else if (*buffer <= 0xb7) {
    } else if (*buffer <= 0xbf) {
c0d029d8:	4620      	mov	r0, r4
c0d029da:	3008      	adds	r0, #8
c0d029dc:	b2c0      	uxtb	r0, r0
c0d029de:	4285      	cmp	r5, r0
c0d029e0:	d207      	bcs.n	c0d029f2 <rlpCanDecode+0x36>
        if (bufferLength < (1 + (*buffer - 0xb7))) {
c0d029e2:	462e      	mov	r6, r5
c0d029e4:	3eb6      	subs	r6, #182	; 0xb6
c0d029e6:	2000      	movs	r0, #0
c0d029e8:	428e      	cmp	r6, r1
c0d029ea:	d815      	bhi.n	c0d02a18 <rlpCanDecode+0x5c>
            return false;
        }
        if (*buffer > 0xbb) {
c0d029ec:	1ce0      	adds	r0, r4, #3
c0d029ee:	b2c0      	uxtb	r0, r0
c0d029f0:	e00b      	b.n	c0d02a0a <rlpCanDecode+0x4e>
            *valid = false; // arbitrary 32 bits length limitation
            return true;
        }
    } else if (*buffer <= 0xf7) {
c0d029f2:	4620      	mov	r0, r4
c0d029f4:	3040      	adds	r0, #64	; 0x40
c0d029f6:	b2c0      	uxtb	r0, r0
c0d029f8:	4285      	cmp	r5, r0
c0d029fa:	d30a      	bcc.n	c0d02a12 <rlpCanDecode+0x56>
    } else {
        if (bufferLength < (1 + (*buffer - 0xf7))) {
c0d029fc:	462e      	mov	r6, r5
c0d029fe:	3ef6      	subs	r6, #246	; 0xf6
c0d02a00:	2000      	movs	r0, #0
c0d02a02:	428e      	cmp	r6, r1
c0d02a04:	d808      	bhi.n	c0d02a18 <rlpCanDecode+0x5c>
            return false;
        }
        if (*buffer > 0xfb) {
c0d02a06:	3443      	adds	r4, #67	; 0x43
c0d02a08:	b2e0      	uxtb	r0, r4
c0d02a0a:	4285      	cmp	r5, r0
c0d02a0c:	d901      	bls.n	c0d02a12 <rlpCanDecode+0x56>
c0d02a0e:	2000      	movs	r0, #0
c0d02a10:	e000      	b.n	c0d02a14 <rlpCanDecode+0x58>
            *valid = false; // arbitrary 32 bits length limitation
            return true;
        }
    }
    *valid = true;
c0d02a12:	2001      	movs	r0, #1
c0d02a14:	7010      	strb	r0, [r2, #0]
c0d02a16:	4618      	mov	r0, r3
    return true;
}
c0d02a18:	bd70      	pop	{r4, r5, r6, pc}

c0d02a1a <copyTxData>:
    context->dataLength = context->currentFieldLength;
    context->currentField++;
    context->processingField = false;
}

void copyTxData(txContext_t *context, uint8_t *out, uint32_t length) {
c0d02a1a:	b5b0      	push	{r4, r5, r7, lr}
c0d02a1c:	4614      	mov	r4, r2
c0d02a1e:	4605      	mov	r5, r0
    if (context->commandLength < length) {
c0d02a20:	6a68      	ldr	r0, [r5, #36]	; 0x24
c0d02a22:	42a0      	cmp	r0, r4
c0d02a24:	d314      	bcc.n	c0d02a50 <copyTxData+0x36>
        PRINTF("copyTxData Underflow\n");
        THROW(EXCEPTION);
    }
    if (out != NULL) {
c0d02a26:	2900      	cmp	r1, #0
c0d02a28:	d006      	beq.n	c0d02a38 <copyTxData+0x1e>
        os_memmove(out, context->workBuffer, length);
c0d02a2a:	6a2a      	ldr	r2, [r5, #32]
c0d02a2c:	4608      	mov	r0, r1
c0d02a2e:	4611      	mov	r1, r2
c0d02a30:	4622      	mov	r2, r4
c0d02a32:	f7ff f8f2 	bl	c0d01c1a <os_memmove>
c0d02a36:	6a68      	ldr	r0, [r5, #36]	; 0x24
    }
    context->workBuffer += length;
c0d02a38:	6a29      	ldr	r1, [r5, #32]
c0d02a3a:	1909      	adds	r1, r1, r4
    context->commandLength -= length;
c0d02a3c:	1b00      	subs	r0, r0, r4
        THROW(EXCEPTION);
    }
    if (out != NULL) {
        os_memmove(out, context->workBuffer, length);
    }
    context->workBuffer += length;
c0d02a3e:	6229      	str	r1, [r5, #32]
    context->commandLength -= length;
c0d02a40:	6268      	str	r0, [r5, #36]	; 0x24
    if (context->processingField) {
c0d02a42:	7b68      	ldrb	r0, [r5, #13]
c0d02a44:	2800      	cmp	r0, #0
c0d02a46:	d002      	beq.n	c0d02a4e <copyTxData+0x34>
        context->currentFieldPos += length;
c0d02a48:	68a8      	ldr	r0, [r5, #8]
c0d02a4a:	1900      	adds	r0, r0, r4
c0d02a4c:	60a8      	str	r0, [r5, #8]
    }
}
c0d02a4e:	bdb0      	pop	{r4, r5, r7, pc}
}

void copyTxData(txContext_t *context, uint8_t *out, uint32_t length) {
    if (context->commandLength < length) {
        PRINTF("copyTxData Underflow\n");
        THROW(EXCEPTION);
c0d02a50:	2001      	movs	r0, #1
c0d02a52:	f7ff f996 	bl	c0d01d82 <os_longjmp>

c0d02a56 <rlpDecodeLength>:
        context->processingField = false;
    }
}

bool rlpDecodeLength(uint8_t *buffer, uint32_t bufferLength,
                     uint32_t *fieldLength, uint32_t *offset, bool *list) {
c0d02a56:	b5f0      	push	{r4, r5, r6, r7, lr}
    if (*buffer <= 0x7f) {
c0d02a58:	7801      	ldrb	r1, [r0, #0]
c0d02a5a:	b249      	sxtb	r1, r1
c0d02a5c:	2447      	movs	r4, #71	; 0x47
c0d02a5e:	43e4      	mvns	r4, r4
c0d02a60:	3447      	adds	r4, #71	; 0x47
c0d02a62:	b267      	sxtb	r7, r4
c0d02a64:	2401      	movs	r4, #1
c0d02a66:	26b8      	movs	r6, #184	; 0xb8
c0d02a68:	9d05      	ldr	r5, [sp, #20]
c0d02a6a:	42b9      	cmp	r1, r7
c0d02a6c:	dd04      	ble.n	c0d02a78 <rlpDecodeLength+0x22>
c0d02a6e:	2000      	movs	r0, #0
        *offset = 0;
c0d02a70:	6018      	str	r0, [r3, #0]
        *fieldLength = 1;
c0d02a72:	2101      	movs	r1, #1
c0d02a74:	6011      	str	r1, [r2, #0]
c0d02a76:	e008      	b.n	c0d02a8a <rlpDecodeLength+0x34>
    }
}

bool rlpDecodeLength(uint8_t *buffer, uint32_t bufferLength,
                     uint32_t *fieldLength, uint32_t *offset, bool *list) {
    if (*buffer <= 0x7f) {
c0d02a78:	b2c9      	uxtb	r1, r1
        *offset = 0;
        *fieldLength = 1;
        *list = false;
    } else if (*buffer <= 0xb7) {
c0d02a7a:	42b1      	cmp	r1, r6
c0d02a7c:	d209      	bcs.n	c0d02a92 <rlpDecodeLength+0x3c>
        *offset = 1;
c0d02a7e:	2101      	movs	r1, #1
c0d02a80:	6019      	str	r1, [r3, #0]
        *fieldLength = *buffer - 0x80;
c0d02a82:	7800      	ldrb	r0, [r0, #0]
c0d02a84:	3880      	subs	r0, #128	; 0x80
c0d02a86:	6010      	str	r0, [r2, #0]
        *list = false;
c0d02a88:	2000      	movs	r0, #0
c0d02a8a:	7028      	strb	r0, [r5, #0]
c0d02a8c:	4621      	mov	r1, r4
                return false; // arbitrary 32 bits length limitation
        }
    }

    return true;
}
c0d02a8e:	4608      	mov	r0, r1
c0d02a90:	bdf0      	pop	{r4, r5, r6, r7, pc}
        *list = false;
    } else if (*buffer <= 0xb7) {
        *offset = 1;
        *fieldLength = *buffer - 0x80;
        *list = false;
    } else if (*buffer <= 0xbf) {
c0d02a92:	4637      	mov	r7, r6
c0d02a94:	3708      	adds	r7, #8
c0d02a96:	b2ff      	uxtb	r7, r7
c0d02a98:	42b9      	cmp	r1, r7
c0d02a9a:	d20b      	bcs.n	c0d02ab4 <rlpDecodeLength+0x5e>
        *offset = 1 + (*buffer - 0xb7);
c0d02a9c:	39b6      	subs	r1, #182	; 0xb6
c0d02a9e:	6019      	str	r1, [r3, #0]
c0d02aa0:	2100      	movs	r1, #0
        *list = false;
c0d02aa2:	7029      	strb	r1, [r5, #0]
c0d02aa4:	7803      	ldrb	r3, [r0, #0]
        switch (*buffer) {
c0d02aa6:	2bb9      	cmp	r3, #185	; 0xb9
c0d02aa8:	dc0f      	bgt.n	c0d02aca <rlpDecodeLength+0x74>
c0d02aaa:	2bb8      	cmp	r3, #184	; 0xb8
c0d02aac:	d022      	beq.n	c0d02af4 <rlpDecodeLength+0x9e>
c0d02aae:	2bb9      	cmp	r3, #185	; 0xb9
c0d02ab0:	d01c      	beq.n	c0d02aec <rlpDecodeLength+0x96>
c0d02ab2:	e7ec      	b.n	c0d02a8e <rlpDecodeLength+0x38>
                               (*(buffer + 3) << 8) + *(buffer + 4);
                break;
            default:
                return false; // arbitrary 32 bits length limitation
        }
    } else if (*buffer <= 0xf7) {
c0d02ab4:	3640      	adds	r6, #64	; 0x40
c0d02ab6:	b2f6      	uxtb	r6, r6
c0d02ab8:	42b1      	cmp	r1, r6
c0d02aba:	d20b      	bcs.n	c0d02ad4 <rlpDecodeLength+0x7e>
c0d02abc:	2101      	movs	r1, #1
        *offset = 1;
c0d02abe:	6019      	str	r1, [r3, #0]
        *fieldLength = *buffer - 0xc0;
c0d02ac0:	7800      	ldrb	r0, [r0, #0]
c0d02ac2:	38c0      	subs	r0, #192	; 0xc0
c0d02ac4:	6010      	str	r0, [r2, #0]
        *list = true;
c0d02ac6:	7029      	strb	r1, [r5, #0]
c0d02ac8:	e7e0      	b.n	c0d02a8c <rlpDecodeLength+0x36>
c0d02aca:	2bba      	cmp	r3, #186	; 0xba
c0d02acc:	d023      	beq.n	c0d02b16 <rlpDecodeLength+0xc0>
c0d02ace:	2bbb      	cmp	r3, #187	; 0xbb
c0d02ad0:	d016      	beq.n	c0d02b00 <rlpDecodeLength+0xaa>
c0d02ad2:	e7dc      	b.n	c0d02a8e <rlpDecodeLength+0x38>
    } else {
        *offset = 1 + (*buffer - 0xf7);
c0d02ad4:	39f6      	subs	r1, #246	; 0xf6
c0d02ad6:	6019      	str	r1, [r3, #0]
        *list = true;
c0d02ad8:	2101      	movs	r1, #1
c0d02ada:	7029      	strb	r1, [r5, #0]
c0d02adc:	7803      	ldrb	r3, [r0, #0]
c0d02ade:	2100      	movs	r1, #0
        switch (*buffer) {
c0d02ae0:	2bf9      	cmp	r3, #249	; 0xf9
c0d02ae2:	dc09      	bgt.n	c0d02af8 <rlpDecodeLength+0xa2>
c0d02ae4:	2bf8      	cmp	r3, #248	; 0xf8
c0d02ae6:	d005      	beq.n	c0d02af4 <rlpDecodeLength+0x9e>
c0d02ae8:	2bf9      	cmp	r3, #249	; 0xf9
c0d02aea:	d1d0      	bne.n	c0d02a8e <rlpDecodeLength+0x38>
c0d02aec:	7881      	ldrb	r1, [r0, #2]
c0d02aee:	7840      	ldrb	r0, [r0, #1]
c0d02af0:	0200      	lsls	r0, r0, #8
c0d02af2:	e00e      	b.n	c0d02b12 <rlpDecodeLength+0xbc>
c0d02af4:	7840      	ldrb	r0, [r0, #1]
c0d02af6:	e015      	b.n	c0d02b24 <rlpDecodeLength+0xce>
c0d02af8:	2bfa      	cmp	r3, #250	; 0xfa
c0d02afa:	d00c      	beq.n	c0d02b16 <rlpDecodeLength+0xc0>
c0d02afc:	2bfb      	cmp	r3, #251	; 0xfb
c0d02afe:	d1c6      	bne.n	c0d02a8e <rlpDecodeLength+0x38>
c0d02b00:	7841      	ldrb	r1, [r0, #1]
c0d02b02:	0609      	lsls	r1, r1, #24
c0d02b04:	7883      	ldrb	r3, [r0, #2]
c0d02b06:	041b      	lsls	r3, r3, #16
c0d02b08:	430b      	orrs	r3, r1
c0d02b0a:	78c1      	ldrb	r1, [r0, #3]
c0d02b0c:	0209      	lsls	r1, r1, #8
c0d02b0e:	4319      	orrs	r1, r3
c0d02b10:	7900      	ldrb	r0, [r0, #4]
c0d02b12:	4308      	orrs	r0, r1
c0d02b14:	e006      	b.n	c0d02b24 <rlpDecodeLength+0xce>
c0d02b16:	7841      	ldrb	r1, [r0, #1]
c0d02b18:	0409      	lsls	r1, r1, #16
c0d02b1a:	7883      	ldrb	r3, [r0, #2]
c0d02b1c:	021b      	lsls	r3, r3, #8
c0d02b1e:	430b      	orrs	r3, r1
c0d02b20:	78c0      	ldrb	r0, [r0, #3]
c0d02b22:	4318      	orrs	r0, r3
c0d02b24:	6010      	str	r0, [r2, #0]
c0d02b26:	e7b1      	b.n	c0d02a8c <rlpDecodeLength+0x36>

c0d02b28 <processTx>:
        context->processingField = false;
    }
}


int processTx(txContext_t *context) {
c0d02b28:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02b2a:	b087      	sub	sp, #28
c0d02b2c:	4604      	mov	r4, r0
    for (;;) {
        if (context->currentField == TX_RLP_DONE) {
c0d02b2e:	7820      	ldrb	r0, [r4, #0]
c0d02b30:	2700      	movs	r7, #0
c0d02b32:	2809      	cmp	r0, #9
c0d02b34:	d100      	bne.n	c0d02b38 <processTx+0x10>
c0d02b36:	e190      	b.n	c0d02e5a <processTx+0x332>
c0d02b38:	4620      	mov	r0, r4
c0d02b3a:	300c      	adds	r0, #12
c0d02b3c:	9004      	str	r0, [sp, #16]
c0d02b3e:	1d20      	adds	r0, r4, #4
c0d02b40:	9003      	str	r0, [sp, #12]
c0d02b42:	4626      	mov	r6, r4
c0d02b44:	3614      	adds	r6, #20
            return 0;
        }

        if (context->commandLength == 0) {
c0d02b46:	6a60      	ldr	r0, [r4, #36]	; 0x24
c0d02b48:	2701      	movs	r7, #1
c0d02b4a:	2800      	cmp	r0, #0
c0d02b4c:	d100      	bne.n	c0d02b50 <processTx+0x28>
c0d02b4e:	e184      	b.n	c0d02e5a <processTx+0x332>
c0d02b50:	2500      	movs	r5, #0
c0d02b52:	43ef      	mvns	r7, r5
            return 1;
        }

        if (!context->processingField) {
c0d02b54:	7b61      	ldrb	r1, [r4, #13]
c0d02b56:	2900      	cmp	r1, #0
c0d02b58:	d160      	bne.n	c0d02c1c <processTx+0xf4>
c0d02b5a:	2101      	movs	r1, #1
            bool canDecode = false;
            uint32_t offset;
            while (context->commandLength != 0) {
c0d02b5c:	9101      	str	r1, [sp, #4]
c0d02b5e:	2800      	cmp	r0, #0
c0d02b60:	d100      	bne.n	c0d02b64 <processTx+0x3c>
c0d02b62:	e179      	b.n	c0d02e58 <processTx+0x330>
c0d02b64:	9502      	str	r5, [sp, #8]
c0d02b66:	2500      	movs	r5, #0
    return true;
}

uint8_t readTxByte(txContext_t *context) {
    uint8_t data;
    data = *context->workBuffer;
c0d02b68:	6a22      	ldr	r2, [r4, #32]
c0d02b6a:	7811      	ldrb	r1, [r2, #0]
    context->workBuffer++;
c0d02b6c:	1c52      	adds	r2, r2, #1
    context->commandLength--;
c0d02b6e:	1e40      	subs	r0, r0, #1
}

uint8_t readTxByte(txContext_t *context) {
    uint8_t data;
    data = *context->workBuffer;
    context->workBuffer++;
c0d02b70:	6222      	str	r2, [r4, #32]
    context->commandLength--;
c0d02b72:	6260      	str	r0, [r4, #36]	; 0x24
    if (context->processingField) {
c0d02b74:	7b60      	ldrb	r0, [r4, #13]
c0d02b76:	2800      	cmp	r0, #0
c0d02b78:	d002      	beq.n	c0d02b80 <processTx+0x58>
        context->currentFieldPos++;
c0d02b7a:	68a0      	ldr	r0, [r4, #8]
c0d02b7c:	1c40      	adds	r0, r0, #1
c0d02b7e:	60a0      	str	r0, [r4, #8]
                bool valid;
                // Feed the RLP buffer until the length can be decoded
                if (context->commandLength < 1) {
                    return -1;
                }
                context->rlpBuffer[context->rlpBufferPos++] =
c0d02b80:	69e0      	ldr	r0, [r4, #28]
c0d02b82:	1c42      	adds	r2, r0, #1
c0d02b84:	61e2      	str	r2, [r4, #28]
c0d02b86:	1820      	adds	r0, r4, r0
c0d02b88:	7501      	strb	r1, [r0, #20]
                        readTxByte(context);
                if (rlpCanDecode(context->rlpBuffer, context->rlpBufferPos,
c0d02b8a:	69e1      	ldr	r1, [r4, #28]
c0d02b8c:	aa05      	add	r2, sp, #20
c0d02b8e:	4630      	mov	r0, r6
c0d02b90:	f7ff ff14 	bl	c0d029bc <rlpCanDecode>
c0d02b94:	2801      	cmp	r0, #1
c0d02b96:	d10c      	bne.n	c0d02bb2 <processTx+0x8a>
c0d02b98:	a805      	add	r0, sp, #20
                                 &valid)) {
                    // Can decode now, if valid
                    if (!valid) {
c0d02b9a:	7802      	ldrb	r2, [r0, #0]
                        return -1;
c0d02b9c:	2101      	movs	r1, #1
c0d02b9e:	2305      	movs	r3, #5
c0d02ba0:	2a00      	cmp	r2, #0
c0d02ba2:	4608      	mov	r0, r1
c0d02ba4:	d000      	beq.n	c0d02ba8 <processTx+0x80>
c0d02ba6:	4618      	mov	r0, r3
c0d02ba8:	2a00      	cmp	r2, #0
c0d02baa:	d100      	bne.n	c0d02bae <processTx+0x86>
c0d02bac:	4611      	mov	r1, r2
c0d02bae:	430d      	orrs	r5, r1
c0d02bb0:	e005      	b.n	c0d02bbe <processTx+0x96>
                    canDecode = true;
                    break;
                }
                // Cannot decode yet
                // Sanity check
                if (context->rlpBufferPos == sizeof(context->rlpBuffer)) {
c0d02bb2:	69e2      	ldr	r2, [r4, #28]
c0d02bb4:	2001      	movs	r0, #1
c0d02bb6:	2100      	movs	r1, #0
c0d02bb8:	2a05      	cmp	r2, #5
c0d02bba:	d000      	beq.n	c0d02bbe <processTx+0x96>
c0d02bbc:	4608      	mov	r0, r1
c0d02bbe:	2107      	movs	r1, #7
c0d02bc0:	4001      	ands	r1, r0
c0d02bc2:	2900      	cmp	r1, #0
c0d02bc4:	d103      	bne.n	c0d02bce <processTx+0xa6>
c0d02bc6:	6a60      	ldr	r0, [r4, #36]	; 0x24
        }

        if (!context->processingField) {
            bool canDecode = false;
            uint32_t offset;
            while (context->commandLength != 0) {
c0d02bc8:	2800      	cmp	r0, #0
c0d02bca:	d1cd      	bne.n	c0d02b68 <processTx+0x40>
c0d02bcc:	e001      	b.n	c0d02bd2 <processTx+0xaa>
c0d02bce:	2905      	cmp	r1, #5
c0d02bd0:	d120      	bne.n	c0d02c14 <processTx+0xec>
                // Sanity check
                if (context->rlpBufferPos == sizeof(context->rlpBuffer)) {
                    return -1;
                }
            }
            if (!canDecode) {
c0d02bd2:	07e8      	lsls	r0, r5, #31
c0d02bd4:	d100      	bne.n	c0d02bd8 <processTx+0xb0>
c0d02bd6:	e13f      	b.n	c0d02e58 <processTx+0x330>
                return 1;
            }
            // Ready to process this field
            if (!rlpDecodeLength(context->rlpBuffer, context->rlpBufferPos,
c0d02bd8:	4668      	mov	r0, sp
c0d02bda:	9904      	ldr	r1, [sp, #16]
c0d02bdc:	6001      	str	r1, [r0, #0]
c0d02bde:	ab06      	add	r3, sp, #24
c0d02be0:	4630      	mov	r0, r6
c0d02be2:	9a03      	ldr	r2, [sp, #12]
c0d02be4:	f7ff ff37 	bl	c0d02a56 <rlpDecodeLength>
c0d02be8:	2801      	cmp	r0, #1
c0d02bea:	d000      	beq.n	c0d02bee <processTx+0xc6>
c0d02bec:	e133      	b.n	c0d02e56 <processTx+0x32e>
c0d02bee:	2000      	movs	r0, #0
                                 &context->currentFieldLength, &offset,
                                 &context->currentFieldIsList)) {
                return -1;
            }
            if (offset == 0) {
c0d02bf0:	9906      	ldr	r1, [sp, #24]
c0d02bf2:	2900      	cmp	r1, #0
c0d02bf4:	4601      	mov	r1, r0
c0d02bf6:	d106      	bne.n	c0d02c06 <processTx+0xde>
                // Hack for single byte, self encoded
                context->workBuffer--;
c0d02bf8:	6a21      	ldr	r1, [r4, #32]
c0d02bfa:	19c9      	adds	r1, r1, r7
c0d02bfc:	6221      	str	r1, [r4, #32]
                context->commandLength++;
c0d02bfe:	6a61      	ldr	r1, [r4, #36]	; 0x24
c0d02c00:	1c49      	adds	r1, r1, #1
c0d02c02:	6261      	str	r1, [r4, #36]	; 0x24
c0d02c04:	2101      	movs	r1, #1
c0d02c06:	73a1      	strb	r1, [r4, #14]
                context->fieldSingleByte = true;
            } else {
                context->fieldSingleByte = false;
            }
            context->currentFieldPos = 0;
c0d02c08:	60a0      	str	r0, [r4, #8]
            context->rlpBufferPos = 0;
c0d02c0a:	61e0      	str	r0, [r4, #28]
            context->processingField = true;
c0d02c0c:	2001      	movs	r0, #1
c0d02c0e:	7360      	strb	r0, [r4, #13]
c0d02c10:	9d02      	ldr	r5, [sp, #8]
c0d02c12:	e003      	b.n	c0d02c1c <processTx+0xf4>
c0d02c14:	2800      	cmp	r0, #0
c0d02c16:	9d02      	ldr	r5, [sp, #8]
c0d02c18:	d000      	beq.n	c0d02c1c <processTx+0xf4>
c0d02c1a:	e11e      	b.n	c0d02e5a <processTx+0x332>
c0d02c1c:	7820      	ldrb	r0, [r4, #0]
        }


        switch (context->currentField) {
c0d02c1e:	2804      	cmp	r0, #4
c0d02c20:	dc23      	bgt.n	c0d02c6a <processTx+0x142>
c0d02c22:	2802      	cmp	r0, #2
c0d02c24:	dc53      	bgt.n	c0d02cce <processTx+0x1a6>
c0d02c26:	2801      	cmp	r0, #1
c0d02c28:	d100      	bne.n	c0d02c2c <processTx+0x104>
c0d02c2a:	e091      	b.n	c0d02d50 <processTx+0x228>
c0d02c2c:	2802      	cmp	r0, #2
c0d02c2e:	d000      	beq.n	c0d02c32 <processTx+0x10a>
c0d02c30:	e113      	b.n	c0d02e5a <processTx+0x332>
        context->currentFieldPos += length;
    }
}

static void processNonce(txContext_t *context) {
    if (context->currentFieldIsList) {
c0d02c32:	9804      	ldr	r0, [sp, #16]
c0d02c34:	7800      	ldrb	r0, [r0, #0]
c0d02c36:	2800      	cmp	r0, #0
c0d02c38:	d000      	beq.n	c0d02c3c <processTx+0x114>
c0d02c3a:	e111      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid type for RLP_NONCE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT256) {
c0d02c3c:	9803      	ldr	r0, [sp, #12]
c0d02c3e:	6800      	ldr	r0, [r0, #0]
c0d02c40:	2821      	cmp	r0, #33	; 0x21
c0d02c42:	d300      	bcc.n	c0d02c46 <processTx+0x11e>
c0d02c44:	e10c      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid length for RLP_NONCE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
c0d02c46:	68a1      	ldr	r1, [r4, #8]
c0d02c48:	4288      	cmp	r0, r1
c0d02c4a:	d90a      	bls.n	c0d02c62 <processTx+0x13a>
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
c0d02c4c:	1a40      	subs	r0, r0, r1
        PRINTF("Invalid length for RLP_NONCE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
c0d02c4e:	6a62      	ldr	r2, [r4, #36]	; 0x24
c0d02c50:	4282      	cmp	r2, r0
c0d02c52:	d300      	bcc.n	c0d02c56 <processTx+0x12e>
c0d02c54:	4602      	mov	r2, r0
c0d02c56:	2100      	movs	r1, #0
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context, NULL, copySize);
c0d02c58:	4620      	mov	r0, r4
c0d02c5a:	f7ff fede 	bl	c0d02a1a <copyTxData>
c0d02c5e:	6860      	ldr	r0, [r4, #4]
c0d02c60:	68a1      	ldr	r1, [r4, #8]
    }
    if (context->currentFieldPos == context->currentFieldLength) {
c0d02c62:	4281      	cmp	r1, r0
c0d02c64:	d100      	bne.n	c0d02c68 <processTx+0x140>
c0d02c66:	e0c6      	b.n	c0d02df6 <processTx+0x2ce>
c0d02c68:	e0ca      	b.n	c0d02e00 <processTx+0x2d8>
c0d02c6a:	2806      	cmp	r0, #6
c0d02c6c:	dc53      	bgt.n	c0d02d16 <processTx+0x1ee>
c0d02c6e:	2805      	cmp	r0, #5
c0d02c70:	d077      	beq.n	c0d02d62 <processTx+0x23a>
c0d02c72:	2806      	cmp	r0, #6
c0d02c74:	d000      	beq.n	c0d02c78 <processTx+0x150>
c0d02c76:	e0f0      	b.n	c0d02e5a <processTx+0x332>
        context->processingField = false;
    }
}

static void processToShard(txContext_t *context) {
    if (context->currentFieldIsList) {
c0d02c78:	9804      	ldr	r0, [sp, #16]
c0d02c7a:	7800      	ldrb	r0, [r0, #0]
c0d02c7c:	2800      	cmp	r0, #0
c0d02c7e:	d000      	beq.n	c0d02c82 <processTx+0x15a>
c0d02c80:	e0ee      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid type for TO SHARD \n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT32) {
c0d02c82:	9803      	ldr	r0, [sp, #12]
c0d02c84:	6800      	ldr	r0, [r0, #0]
c0d02c86:	2805      	cmp	r0, #5
c0d02c88:	d300      	bcc.n	c0d02c8c <processTx+0x164>
c0d02c8a:	e0e9      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid length for TO SHARD %d\n",
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
c0d02c8c:	68a1      	ldr	r1, [r4, #8]
c0d02c8e:	4288      	cmp	r0, r1
c0d02c90:	d800      	bhi.n	c0d02c94 <processTx+0x16c>
c0d02c92:	e08f      	b.n	c0d02db4 <processTx+0x28c>
c0d02c94:	9502      	str	r5, [sp, #8]
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
c0d02c96:	1a40      	subs	r0, r0, r1
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
c0d02c98:	6a62      	ldr	r2, [r4, #36]	; 0x24
c0d02c9a:	4282      	cmp	r2, r0
c0d02c9c:	d300      	bcc.n	c0d02ca0 <processTx+0x178>
c0d02c9e:	4602      	mov	r2, r0
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   (uint8_t *)&context->content->toShard + context->currentFieldPos,
c0d02ca0:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d02ca2:	1841      	adds	r1, r0, r1
c0d02ca4:	3168      	adds	r1, #104	; 0x68
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
c0d02ca6:	4620      	mov	r0, r4
c0d02ca8:	f7ff feb7 	bl	c0d02a1a <copyTxData>
                   copySize);

        //adjust from big endian to little endian
        uint32_t shardId = 0;
        uint8_t *shardIdArray = (uint8_t *) &context->content->toShard;
        for(uint32_t i = 0 ; i < context->currentFieldLength;  i++ ) {
c0d02cac:	6860      	ldr	r0, [r4, #4]
                   (uint8_t *)&context->content->toShard + context->currentFieldPos,
                   copySize);

        //adjust from big endian to little endian
        uint32_t shardId = 0;
        uint8_t *shardIdArray = (uint8_t *) &context->content->toShard;
c0d02cae:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0d02cb0:	2200      	movs	r2, #0
        for(uint32_t i = 0 ; i < context->currentFieldLength;  i++ ) {
c0d02cb2:	2800      	cmp	r0, #0
c0d02cb4:	d009      	beq.n	c0d02cca <processTx+0x1a2>
            shardId <<= 8;
c0d02cb6:	460b      	mov	r3, r1
c0d02cb8:	3368      	adds	r3, #104	; 0x68
c0d02cba:	2200      	movs	r2, #0
c0d02cbc:	4605      	mov	r5, r0
c0d02cbe:	0217      	lsls	r7, r2, #8
            shardId |= shardIdArray[i];
c0d02cc0:	781a      	ldrb	r2, [r3, #0]
c0d02cc2:	433a      	orrs	r2, r7
                   copySize);

        //adjust from big endian to little endian
        uint32_t shardId = 0;
        uint8_t *shardIdArray = (uint8_t *) &context->content->toShard;
        for(uint32_t i = 0 ; i < context->currentFieldLength;  i++ ) {
c0d02cc4:	1c5b      	adds	r3, r3, #1
c0d02cc6:	1e6d      	subs	r5, r5, #1
c0d02cc8:	d1f9      	bne.n	c0d02cbe <processTx+0x196>
            shardId <<= 8;
            shardId |= shardIdArray[i];
        }
        context->content->toShard = shardId;
c0d02cca:	668a      	str	r2, [r1, #104]	; 0x68
c0d02ccc:	e070      	b.n	c0d02db0 <processTx+0x288>
c0d02cce:	2803      	cmp	r0, #3
c0d02cd0:	d075      	beq.n	c0d02dbe <processTx+0x296>
c0d02cd2:	2804      	cmp	r0, #4
c0d02cd4:	d000      	beq.n	c0d02cd8 <processTx+0x1b0>
c0d02cd6:	e0c0      	b.n	c0d02e5a <processTx+0x332>
        context->processingField = false;
    }
}

static void processStartGas(txContext_t *context) {
    if (context->currentFieldIsList) {
c0d02cd8:	9804      	ldr	r0, [sp, #16]
c0d02cda:	7800      	ldrb	r0, [r0, #0]
c0d02cdc:	2800      	cmp	r0, #0
c0d02cde:	d000      	beq.n	c0d02ce2 <processTx+0x1ba>
c0d02ce0:	e0be      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid type for RLP_STARTGAS\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT256) {
c0d02ce2:	9803      	ldr	r0, [sp, #12]
c0d02ce4:	6800      	ldr	r0, [r0, #0]
c0d02ce6:	2821      	cmp	r0, #33	; 0x21
c0d02ce8:	d300      	bcc.n	c0d02cec <processTx+0x1c4>
c0d02cea:	e0b9      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid length for RLP_STARTGAS %d\n",
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
c0d02cec:	68a1      	ldr	r1, [r4, #8]
c0d02cee:	4288      	cmp	r0, r1
c0d02cf0:	d90c      	bls.n	c0d02d0c <processTx+0x1e4>
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
c0d02cf2:	1a40      	subs	r0, r0, r1
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
c0d02cf4:	6a62      	ldr	r2, [r4, #36]	; 0x24
c0d02cf6:	4282      	cmp	r2, r0
c0d02cf8:	d300      	bcc.n	c0d02cfc <processTx+0x1d4>
c0d02cfa:	4602      	mov	r2, r0
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   context->content->startgas.value + context->currentFieldPos,
c0d02cfc:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d02cfe:	1841      	adds	r1, r0, r1
c0d02d00:	3121      	adds	r1, #33	; 0x21
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
c0d02d02:	4620      	mov	r0, r4
c0d02d04:	f7ff fe89 	bl	c0d02a1a <copyTxData>
c0d02d08:	6860      	ldr	r0, [r4, #4]
c0d02d0a:	68a1      	ldr	r1, [r4, #8]
                   context->content->startgas.value + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
c0d02d0c:	4281      	cmp	r1, r0
c0d02d0e:	d177      	bne.n	c0d02e00 <processTx+0x2d8>
        context->content->startgas.length = context->currentFieldLength;
c0d02d10:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0d02d12:	2241      	movs	r2, #65	; 0x41
c0d02d14:	e06e      	b.n	c0d02df4 <processTx+0x2cc>
c0d02d16:	2807      	cmp	r0, #7
c0d02d18:	d177      	bne.n	c0d02e0a <processTx+0x2e2>
        context->processingField = false;
    }
}

static void processTo(txContext_t *context) {
    if (context->currentFieldIsList) {
c0d02d1a:	9804      	ldr	r0, [sp, #16]
c0d02d1c:	7800      	ldrb	r0, [r0, #0]
c0d02d1e:	2800      	cmp	r0, #0
c0d02d20:	d000      	beq.n	c0d02d24 <processTx+0x1fc>
c0d02d22:	e09d      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid type for RLP_TO\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_ADDRESS) {
c0d02d24:	9803      	ldr	r0, [sp, #12]
c0d02d26:	6800      	ldr	r0, [r0, #0]
c0d02d28:	2815      	cmp	r0, #21
c0d02d2a:	d300      	bcc.n	c0d02d2e <processTx+0x206>
c0d02d2c:	e098      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid length for RLP_TO\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
c0d02d2e:	68a1      	ldr	r1, [r4, #8]
c0d02d30:	4288      	cmp	r0, r1
c0d02d32:	d93f      	bls.n	c0d02db4 <processTx+0x28c>
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
c0d02d34:	1a40      	subs	r0, r0, r1
        PRINTF("Invalid length for RLP_TO\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
c0d02d36:	6a62      	ldr	r2, [r4, #36]	; 0x24
c0d02d38:	4282      	cmp	r2, r0
c0d02d3a:	d300      	bcc.n	c0d02d3e <processTx+0x216>
c0d02d3c:	4602      	mov	r2, r0
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   context->content->destination + context->currentFieldPos,
c0d02d3e:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d02d40:	1841      	adds	r1, r0, r1
c0d02d42:	316c      	adds	r1, #108	; 0x6c
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
c0d02d44:	4620      	mov	r0, r4
c0d02d46:	f7ff fe68 	bl	c0d02a1a <copyTxData>
c0d02d4a:	6860      	ldr	r0, [r4, #4]
c0d02d4c:	68a1      	ldr	r1, [r4, #8]
c0d02d4e:	e031      	b.n	c0d02db4 <processTx+0x28c>
    return true;
}

static void processContent(txContext_t *context) {
    // Keep the full length for sanity checks, move to the next field
    if (!context->currentFieldIsList) {
c0d02d50:	9804      	ldr	r0, [sp, #16]
c0d02d52:	7800      	ldrb	r0, [r0, #0]
c0d02d54:	2800      	cmp	r0, #0
c0d02d56:	d100      	bne.n	c0d02d5a <processTx+0x232>
c0d02d58:	e082      	b.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid type for RLP_CONTENT\n");
        THROW(EXCEPTION);
    }
    context->dataLength = context->currentFieldLength;
c0d02d5a:	6860      	ldr	r0, [r4, #4]
c0d02d5c:	6120      	str	r0, [r4, #16]
    context->currentField++;
c0d02d5e:	2002      	movs	r0, #2
c0d02d60:	e04b      	b.n	c0d02dfa <processTx+0x2d2>
        context->processingField = false;
    }
}

static void processFromShard(txContext_t *context) {
    if (context->currentFieldIsList) {
c0d02d62:	9804      	ldr	r0, [sp, #16]
c0d02d64:	7800      	ldrb	r0, [r0, #0]
c0d02d66:	2800      	cmp	r0, #0
c0d02d68:	d17a      	bne.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid type for FROM SHARD \n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > 4) {
c0d02d6a:	9803      	ldr	r0, [sp, #12]
c0d02d6c:	6800      	ldr	r0, [r0, #0]
c0d02d6e:	2805      	cmp	r0, #5
c0d02d70:	d276      	bcs.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid length for FROM SHARD %d\n",
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
c0d02d72:	68a1      	ldr	r1, [r4, #8]
c0d02d74:	4288      	cmp	r0, r1
c0d02d76:	d91d      	bls.n	c0d02db4 <processTx+0x28c>
c0d02d78:	9502      	str	r5, [sp, #8]
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
c0d02d7a:	1a40      	subs	r0, r0, r1
               context->currentFieldLength);
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
c0d02d7c:	6a62      	ldr	r2, [r4, #36]	; 0x24
c0d02d7e:	4282      	cmp	r2, r0
c0d02d80:	d300      	bcc.n	c0d02d84 <processTx+0x25c>
c0d02d82:	4602      	mov	r2, r0
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   (uint8_t *)&context->content->fromShard + context->currentFieldPos,
c0d02d84:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d02d86:	1841      	adds	r1, r0, r1
c0d02d88:	3164      	adds	r1, #100	; 0x64
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
c0d02d8a:	4620      	mov	r0, r4
c0d02d8c:	f7ff fe45 	bl	c0d02a1a <copyTxData>
                   copySize);

        //adjust from big endian to little endian
        uint32_t shardId = 0;
        uint8_t *shardIdArray = (uint8_t *) &context->content->fromShard;
        for(uint32_t i = 0 ; i < context->currentFieldLength;  i++ ) {
c0d02d90:	6860      	ldr	r0, [r4, #4]
                   (uint8_t *)&context->content->fromShard + context->currentFieldPos,
                   copySize);

        //adjust from big endian to little endian
        uint32_t shardId = 0;
        uint8_t *shardIdArray = (uint8_t *) &context->content->fromShard;
c0d02d92:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0d02d94:	2200      	movs	r2, #0
        for(uint32_t i = 0 ; i < context->currentFieldLength;  i++ ) {
c0d02d96:	2800      	cmp	r0, #0
c0d02d98:	d009      	beq.n	c0d02dae <processTx+0x286>
            shardId <<= 8;
c0d02d9a:	460b      	mov	r3, r1
c0d02d9c:	3364      	adds	r3, #100	; 0x64
c0d02d9e:	2200      	movs	r2, #0
c0d02da0:	4605      	mov	r5, r0
c0d02da2:	0217      	lsls	r7, r2, #8
            shardId |= shardIdArray[i];
c0d02da4:	781a      	ldrb	r2, [r3, #0]
c0d02da6:	433a      	orrs	r2, r7
                   copySize);

        //adjust from big endian to little endian
        uint32_t shardId = 0;
        uint8_t *shardIdArray = (uint8_t *) &context->content->fromShard;
        for(uint32_t i = 0 ; i < context->currentFieldLength;  i++ ) {
c0d02da8:	1c5b      	adds	r3, r3, #1
c0d02daa:	1e6d      	subs	r5, r5, #1
c0d02dac:	d1f9      	bne.n	c0d02da2 <processTx+0x27a>
            shardId <<= 8;
            shardId |= shardIdArray[i];
        }
        context->content->fromShard = shardId;
c0d02dae:	664a      	str	r2, [r1, #100]	; 0x64
c0d02db0:	68a1      	ldr	r1, [r4, #8]
c0d02db2:	9d02      	ldr	r5, [sp, #8]
c0d02db4:	4281      	cmp	r1, r0
c0d02db6:	d123      	bne.n	c0d02e00 <processTx+0x2d8>
c0d02db8:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0d02dba:	2280      	movs	r2, #128	; 0x80
c0d02dbc:	e01a      	b.n	c0d02df4 <processTx+0x2cc>
        context->processingField = false;
    }
}

static void processGasprice(txContext_t *context) {
    if (context->currentFieldIsList) {
c0d02dbe:	9804      	ldr	r0, [sp, #16]
c0d02dc0:	7800      	ldrb	r0, [r0, #0]
c0d02dc2:	2800      	cmp	r0, #0
c0d02dc4:	d14c      	bne.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid type for RLP_GASPRICE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT256) {
c0d02dc6:	9803      	ldr	r0, [sp, #12]
c0d02dc8:	6800      	ldr	r0, [r0, #0]
c0d02dca:	2821      	cmp	r0, #33	; 0x21
c0d02dcc:	d248      	bcs.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid length for RLP_GASPRICE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
c0d02dce:	68a2      	ldr	r2, [r4, #8]
c0d02dd0:	4290      	cmp	r0, r2
c0d02dd2:	d90b      	bls.n	c0d02dec <processTx+0x2c4>
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   context->content->gasprice.value + context->currentFieldPos,
c0d02dd4:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0d02dd6:	1889      	adds	r1, r1, r2
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
c0d02dd8:	1a80      	subs	r0, r0, r2
        PRINTF("Invalid length for RLP_GASPRICE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
c0d02dda:	6a62      	ldr	r2, [r4, #36]	; 0x24
c0d02ddc:	4282      	cmp	r2, r0
c0d02dde:	d300      	bcc.n	c0d02de2 <processTx+0x2ba>
c0d02de0:	4602      	mov	r2, r0
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
c0d02de2:	4620      	mov	r0, r4
c0d02de4:	f7ff fe19 	bl	c0d02a1a <copyTxData>
c0d02de8:	6860      	ldr	r0, [r4, #4]
c0d02dea:	68a2      	ldr	r2, [r4, #8]
                   context->content->gasprice.value + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
c0d02dec:	4282      	cmp	r2, r0
c0d02dee:	d107      	bne.n	c0d02e00 <processTx+0x2d8>
        context->content->gasprice.length = context->currentFieldLength;
c0d02df0:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0d02df2:	2220      	movs	r2, #32
c0d02df4:	5488      	strb	r0, [r1, r2]
c0d02df6:	7820      	ldrb	r0, [r4, #0]
c0d02df8:	1c40      	adds	r0, r0, #1
c0d02dfa:	7020      	strb	r0, [r4, #0]
c0d02dfc:	2000      	movs	r0, #0
c0d02dfe:	7360      	strb	r0, [r4, #13]
}


int processTx(txContext_t *context) {
    for (;;) {
        if (context->currentField == TX_RLP_DONE) {
c0d02e00:	7820      	ldrb	r0, [r4, #0]
c0d02e02:	2809      	cmp	r0, #9
c0d02e04:	462f      	mov	r7, r5
c0d02e06:	d028      	beq.n	c0d02e5a <processTx+0x332>
c0d02e08:	e69d      	b.n	c0d02b46 <processTx+0x1e>
c0d02e0a:	2808      	cmp	r0, #8
c0d02e0c:	d125      	bne.n	c0d02e5a <processTx+0x332>

    return data;
}

static void processValue(txContext_t *context) {
    if (context->currentFieldIsList) {
c0d02e0e:	9804      	ldr	r0, [sp, #16]
c0d02e10:	7800      	ldrb	r0, [r0, #0]
c0d02e12:	2800      	cmp	r0, #0
c0d02e14:	d124      	bne.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid type for RLP_VALUE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldLength > MAX_INT256) {
c0d02e16:	9803      	ldr	r0, [sp, #12]
c0d02e18:	6800      	ldr	r0, [r0, #0]
c0d02e1a:	2821      	cmp	r0, #33	; 0x21
c0d02e1c:	d220      	bcs.n	c0d02e60 <processTx+0x338>
        PRINTF("Invalid length for RLP_VALUE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
c0d02e1e:	68a1      	ldr	r1, [r4, #8]
c0d02e20:	4288      	cmp	r0, r1
c0d02e22:	d90c      	bls.n	c0d02e3e <processTx+0x316>
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
c0d02e24:	1a40      	subs	r0, r0, r1
        PRINTF("Invalid length for RLP_VALUE\n");
        THROW(EXCEPTION);
    }
    if (context->currentFieldPos < context->currentFieldLength) {
        uint32_t copySize =
                (context->commandLength <
c0d02e26:	6a62      	ldr	r2, [r4, #36]	; 0x24
c0d02e28:	4282      	cmp	r2, r0
c0d02e2a:	d300      	bcc.n	c0d02e2e <processTx+0x306>
c0d02e2c:	4602      	mov	r2, r0
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
                   context->content->value.value + context->currentFieldPos,
c0d02e2e:	6ae0      	ldr	r0, [r4, #44]	; 0x2c
c0d02e30:	1841      	adds	r1, r0, r1
c0d02e32:	3142      	adds	r1, #66	; 0x42
        uint32_t copySize =
                (context->commandLength <
                 ((context->currentFieldLength - context->currentFieldPos))
                 ? context->commandLength
                 : context->currentFieldLength - context->currentFieldPos);
        copyTxData(context,
c0d02e34:	4620      	mov	r0, r4
c0d02e36:	f7ff fdf0 	bl	c0d02a1a <copyTxData>
c0d02e3a:	6860      	ldr	r0, [r4, #4]
c0d02e3c:	68a1      	ldr	r1, [r4, #8]
                   context->content->value.value + context->currentFieldPos,
                   copySize);
    }
    if (context->currentFieldPos == context->currentFieldLength) {
c0d02e3e:	4281      	cmp	r1, r0
c0d02e40:	462f      	mov	r7, r5
c0d02e42:	d10a      	bne.n	c0d02e5a <processTx+0x332>
        context->content->value.length = context->currentFieldLength;
c0d02e44:	6ae1      	ldr	r1, [r4, #44]	; 0x2c
c0d02e46:	2262      	movs	r2, #98	; 0x62
c0d02e48:	5488      	strb	r0, [r1, r2]
        context->currentField++;
c0d02e4a:	7820      	ldrb	r0, [r4, #0]
c0d02e4c:	1c40      	adds	r0, r0, #1
c0d02e4e:	7020      	strb	r0, [r4, #0]
c0d02e50:	2700      	movs	r7, #0
        context->processingField = false;
c0d02e52:	7367      	strb	r7, [r4, #13]
c0d02e54:	e001      	b.n	c0d02e5a <processTx+0x332>
c0d02e56:	9701      	str	r7, [sp, #4]
c0d02e58:	9f01      	ldr	r7, [sp, #4]
                return 0;
            default:
                return -1;
        }
    }
c0d02e5a:	4638      	mov	r0, r7
c0d02e5c:	b007      	add	sp, #28
c0d02e5e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02e60:	2001      	movs	r0, #1
c0d02e62:	f7fe ff8e 	bl	c0d01d82 <os_longjmp>

c0d02e66 <SVC_Call>:
  // avoid a separate asm file, but avoid any intrusion from the compiler
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) __attribute__ ((naked));
  //                    r0                       r1
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) {
    // delegate svc
    asm volatile("svc #1":::"r0","r1");
c0d02e66:	df01      	svc	1
    // directly return R0 value
    asm volatile("bx  lr");
c0d02e68:	4770      	bx	lr
	...

c0d02e6c <check_api_level>:
  }
  void check_api_level ( unsigned int apiLevel ) 
{
c0d02e6c:	b580      	push	{r7, lr}
c0d02e6e:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
c0d02e70:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
c0d02e72:	4807      	ldr	r0, [pc, #28]	; (c0d02e90 <check_api_level+0x24>)
c0d02e74:	4669      	mov	r1, sp
c0d02e76:	f7ff fff6 	bl	c0d02e66 <SVC_Call>
c0d02e7a:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02e7c:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_check_api_level_ID_OUT) {
c0d02e7e:	4905      	ldr	r1, [pc, #20]	; (c0d02e94 <check_api_level+0x28>)
c0d02e80:	4288      	cmp	r0, r1
c0d02e82:	d101      	bne.n	c0d02e88 <check_api_level+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d02e84:	b002      	add	sp, #8
c0d02e86:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_check_api_level_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02e88:	2004      	movs	r0, #4
c0d02e8a:	f7fe ff7a 	bl	c0d01d82 <os_longjmp>
c0d02e8e:	46c0      	nop			; (mov r8, r8)
c0d02e90:	60000137 	.word	0x60000137
c0d02e94:	900001c6 	.word	0x900001c6

c0d02e98 <reset>:
  }
}

void reset ( void ) 
{
c0d02e98:	b580      	push	{r7, lr}
c0d02e9a:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
c0d02e9c:	4806      	ldr	r0, [pc, #24]	; (c0d02eb8 <reset+0x20>)
c0d02e9e:	a901      	add	r1, sp, #4
c0d02ea0:	f7ff ffe1 	bl	c0d02e66 <SVC_Call>
c0d02ea4:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02ea6:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_reset_ID_OUT) {
c0d02ea8:	4904      	ldr	r1, [pc, #16]	; (c0d02ebc <reset+0x24>)
c0d02eaa:	4288      	cmp	r0, r1
c0d02eac:	d101      	bne.n	c0d02eb2 <reset+0x1a>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d02eae:	b002      	add	sp, #8
c0d02eb0:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_reset_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02eb2:	2004      	movs	r0, #4
c0d02eb4:	f7fe ff65 	bl	c0d01d82 <os_longjmp>
c0d02eb8:	60000200 	.word	0x60000200
c0d02ebc:	900002f1 	.word	0x900002f1

c0d02ec0 <cx_rng>:
  }
  return (unsigned char)ret;
}

unsigned char * cx_rng ( unsigned char * buffer, unsigned int len ) 
{
c0d02ec0:	b580      	push	{r7, lr}
c0d02ec2:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d02ec4:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)len;
c0d02ec6:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
c0d02ec8:	4807      	ldr	r0, [pc, #28]	; (c0d02ee8 <cx_rng+0x28>)
c0d02eca:	a901      	add	r1, sp, #4
c0d02ecc:	f7ff ffcb 	bl	c0d02e66 <SVC_Call>
c0d02ed0:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02ed2:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_rng_ID_OUT) {
c0d02ed4:	4905      	ldr	r1, [pc, #20]	; (c0d02eec <cx_rng+0x2c>)
c0d02ed6:	4288      	cmp	r0, r1
c0d02ed8:	d102      	bne.n	c0d02ee0 <cx_rng+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned char *)ret;
c0d02eda:	9803      	ldr	r0, [sp, #12]
c0d02edc:	b004      	add	sp, #16
c0d02ede:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_rng_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02ee0:	2004      	movs	r0, #4
c0d02ee2:	f7fe ff4e 	bl	c0d01d82 <os_longjmp>
c0d02ee6:	46c0      	nop			; (mov r8, r8)
c0d02ee8:	6000052c 	.word	0x6000052c
c0d02eec:	90000567 	.word	0x90000567

c0d02ef0 <cx_hash>:
  }
  return (int)ret;
}

int cx_hash ( cx_hash_t * hash, int mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len ) 
{
c0d02ef0:	b580      	push	{r7, lr}
c0d02ef2:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)hash;
c0d02ef4:	af01      	add	r7, sp, #4
c0d02ef6:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d02ef8:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)in;
  parameters[3] = (unsigned int)len;
  parameters[4] = (unsigned int)out;
c0d02efa:	9005      	str	r0, [sp, #20]
c0d02efc:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)out_len;
c0d02efe:	9006      	str	r0, [sp, #24]
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
c0d02f00:	4807      	ldr	r0, [pc, #28]	; (c0d02f20 <cx_hash+0x30>)
c0d02f02:	a901      	add	r1, sp, #4
c0d02f04:	f7ff ffaf 	bl	c0d02e66 <SVC_Call>
c0d02f08:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02f0a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_hash_ID_OUT) {
c0d02f0c:	4905      	ldr	r1, [pc, #20]	; (c0d02f24 <cx_hash+0x34>)
c0d02f0e:	4288      	cmp	r0, r1
c0d02f10:	d102      	bne.n	c0d02f18 <cx_hash+0x28>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d02f12:	9807      	ldr	r0, [sp, #28]
c0d02f14:	b008      	add	sp, #32
c0d02f16:	bd80      	pop	{r7, pc}
  parameters[4] = (unsigned int)out;
  parameters[5] = (unsigned int)out_len;
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_hash_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02f18:	2004      	movs	r0, #4
c0d02f1a:	f7fe ff32 	bl	c0d01d82 <os_longjmp>
c0d02f1e:	46c0      	nop			; (mov r8, r8)
c0d02f20:	6000073b 	.word	0x6000073b
c0d02f24:	900007ad 	.word	0x900007ad

c0d02f28 <cx_keccak_init>:
  }
  return (int)ret;
}

int cx_keccak_init ( cx_sha3_t * hash, unsigned int size ) 
{
c0d02f28:	b580      	push	{r7, lr}
c0d02f2a:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)hash;
c0d02f2c:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)size;
c0d02f2e:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_cx_keccak_init_ID_IN, parameters);
c0d02f30:	4807      	ldr	r0, [pc, #28]	; (c0d02f50 <cx_keccak_init+0x28>)
c0d02f32:	a901      	add	r1, sp, #4
c0d02f34:	f7ff ff97 	bl	c0d02e66 <SVC_Call>
c0d02f38:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02f3a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_keccak_init_ID_OUT) {
c0d02f3c:	4905      	ldr	r1, [pc, #20]	; (c0d02f54 <cx_keccak_init+0x2c>)
c0d02f3e:	4288      	cmp	r0, r1
c0d02f40:	d102      	bne.n	c0d02f48 <cx_keccak_init+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d02f42:	9803      	ldr	r0, [sp, #12]
c0d02f44:	b004      	add	sp, #16
c0d02f46:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)hash;
  parameters[1] = (unsigned int)size;
  retid = SVC_Call(SYSCALL_cx_keccak_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_keccak_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02f48:	2004      	movs	r0, #4
c0d02f4a:	f7fe ff1a 	bl	c0d01d82 <os_longjmp>
c0d02f4e:	46c0      	nop			; (mov r8, r8)
c0d02f50:	600010cf 	.word	0x600010cf
c0d02f54:	900010d8 	.word	0x900010d8

c0d02f58 <cx_ecfp_init_public_key>:
  }
  return (int)ret;
}

int cx_ecfp_init_public_key ( cx_curve_t curve, const unsigned char * rawkey, unsigned int key_len, cx_ecfp_public_key_t * key ) 
{
c0d02f58:	b580      	push	{r7, lr}
c0d02f5a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d02f5c:	af01      	add	r7, sp, #4
c0d02f5e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)rawkey;
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_public_key_ID_IN, parameters);
c0d02f60:	4807      	ldr	r0, [pc, #28]	; (c0d02f80 <cx_ecfp_init_public_key+0x28>)
c0d02f62:	a901      	add	r1, sp, #4
c0d02f64:	f7ff ff7f 	bl	c0d02e66 <SVC_Call>
c0d02f68:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02f6a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_init_public_key_ID_OUT) {
c0d02f6c:	4905      	ldr	r1, [pc, #20]	; (c0d02f84 <cx_ecfp_init_public_key+0x2c>)
c0d02f6e:	4288      	cmp	r0, r1
c0d02f70:	d102      	bne.n	c0d02f78 <cx_ecfp_init_public_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d02f72:	9805      	ldr	r0, [sp, #20]
c0d02f74:	b006      	add	sp, #24
c0d02f76:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_public_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_init_public_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02f78:	2004      	movs	r0, #4
c0d02f7a:	f7fe ff02 	bl	c0d01d82 <os_longjmp>
c0d02f7e:	46c0      	nop			; (mov r8, r8)
c0d02f80:	60002ded 	.word	0x60002ded
c0d02f84:	90002d49 	.word	0x90002d49

c0d02f88 <cx_ecfp_init_private_key>:
  }
  return (int)ret;
}

int cx_ecfp_init_private_key ( cx_curve_t curve, const unsigned char * rawkey, unsigned int key_len, cx_ecfp_private_key_t * pvkey ) 
{
c0d02f88:	b580      	push	{r7, lr}
c0d02f8a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d02f8c:	af01      	add	r7, sp, #4
c0d02f8e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)rawkey;
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)pvkey;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_private_key_ID_IN, parameters);
c0d02f90:	4807      	ldr	r0, [pc, #28]	; (c0d02fb0 <cx_ecfp_init_private_key+0x28>)
c0d02f92:	a901      	add	r1, sp, #4
c0d02f94:	f7ff ff67 	bl	c0d02e66 <SVC_Call>
c0d02f98:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02f9a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_init_private_key_ID_OUT) {
c0d02f9c:	4905      	ldr	r1, [pc, #20]	; (c0d02fb4 <cx_ecfp_init_private_key+0x2c>)
c0d02f9e:	4288      	cmp	r0, r1
c0d02fa0:	d102      	bne.n	c0d02fa8 <cx_ecfp_init_private_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d02fa2:	9805      	ldr	r0, [sp, #20]
c0d02fa4:	b006      	add	sp, #24
c0d02fa6:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)key_len;
  parameters[3] = (unsigned int)pvkey;
  retid = SVC_Call(SYSCALL_cx_ecfp_init_private_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_init_private_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02fa8:	2004      	movs	r0, #4
c0d02faa:	f7fe feea 	bl	c0d01d82 <os_longjmp>
c0d02fae:	46c0      	nop			; (mov r8, r8)
c0d02fb0:	60002eea 	.word	0x60002eea
c0d02fb4:	90002e63 	.word	0x90002e63

c0d02fb8 <cx_ecfp_generate_pair>:
  }
  return (int)ret;
}

int cx_ecfp_generate_pair ( cx_curve_t curve, cx_ecfp_public_key_t * pubkey, cx_ecfp_private_key_t * privkey, int keepprivate ) 
{
c0d02fb8:	b580      	push	{r7, lr}
c0d02fba:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)curve;
c0d02fbc:	af01      	add	r7, sp, #4
c0d02fbe:	c70f      	stmia	r7!, {r0, r1, r2, r3}
  parameters[1] = (unsigned int)pubkey;
  parameters[2] = (unsigned int)privkey;
  parameters[3] = (unsigned int)keepprivate;
  retid = SVC_Call(SYSCALL_cx_ecfp_generate_pair_ID_IN, parameters);
c0d02fc0:	4807      	ldr	r0, [pc, #28]	; (c0d02fe0 <cx_ecfp_generate_pair+0x28>)
c0d02fc2:	a901      	add	r1, sp, #4
c0d02fc4:	f7ff ff4f 	bl	c0d02e66 <SVC_Call>
c0d02fc8:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d02fca:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecfp_generate_pair_ID_OUT) {
c0d02fcc:	4905      	ldr	r1, [pc, #20]	; (c0d02fe4 <cx_ecfp_generate_pair+0x2c>)
c0d02fce:	4288      	cmp	r0, r1
c0d02fd0:	d102      	bne.n	c0d02fd8 <cx_ecfp_generate_pair+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d02fd2:	9805      	ldr	r0, [sp, #20]
c0d02fd4:	b006      	add	sp, #24
c0d02fd6:	bd80      	pop	{r7, pc}
  parameters[2] = (unsigned int)privkey;
  parameters[3] = (unsigned int)keepprivate;
  retid = SVC_Call(SYSCALL_cx_ecfp_generate_pair_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_generate_pair_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d02fd8:	2004      	movs	r0, #4
c0d02fda:	f7fe fed2 	bl	c0d01d82 <os_longjmp>
c0d02fde:	46c0      	nop			; (mov r8, r8)
c0d02fe0:	60002f2e 	.word	0x60002f2e
c0d02fe4:	90002f74 	.word	0x90002f74

c0d02fe8 <cx_ecdsa_sign>:
  }
  return (int)ret;
}

int cx_ecdsa_sign ( const cx_ecfp_private_key_t * pvkey, int mode, cx_md_t hashID, const unsigned char * hash, unsigned int hash_len, unsigned char * sig, unsigned int sig_len, unsigned int * info ) 
{
c0d02fe8:	b580      	push	{r7, lr}
c0d02fea:	b08a      	sub	sp, #40	; 0x28
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+8];
  parameters[0] = (unsigned int)pvkey;
c0d02fec:	af01      	add	r7, sp, #4
c0d02fee:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d02ff0:	980c      	ldr	r0, [sp, #48]	; 0x30
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)hashID;
  parameters[3] = (unsigned int)hash;
  parameters[4] = (unsigned int)hash_len;
c0d02ff2:	9005      	str	r0, [sp, #20]
c0d02ff4:	980d      	ldr	r0, [sp, #52]	; 0x34
  parameters[5] = (unsigned int)sig;
c0d02ff6:	9006      	str	r0, [sp, #24]
c0d02ff8:	980e      	ldr	r0, [sp, #56]	; 0x38
  parameters[6] = (unsigned int)sig_len;
c0d02ffa:	9007      	str	r0, [sp, #28]
c0d02ffc:	980f      	ldr	r0, [sp, #60]	; 0x3c
  parameters[7] = (unsigned int)info;
c0d02ffe:	9008      	str	r0, [sp, #32]
  retid = SVC_Call(SYSCALL_cx_ecdsa_sign_ID_IN, parameters);
c0d03000:	4807      	ldr	r0, [pc, #28]	; (c0d03020 <cx_ecdsa_sign+0x38>)
c0d03002:	a901      	add	r1, sp, #4
c0d03004:	f7ff ff2f 	bl	c0d02e66 <SVC_Call>
c0d03008:	aa09      	add	r2, sp, #36	; 0x24
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0300a:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_cx_ecdsa_sign_ID_OUT) {
c0d0300c:	4905      	ldr	r1, [pc, #20]	; (c0d03024 <cx_ecdsa_sign+0x3c>)
c0d0300e:	4288      	cmp	r0, r1
c0d03010:	d102      	bne.n	c0d03018 <cx_ecdsa_sign+0x30>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d03012:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d03014:	b00a      	add	sp, #40	; 0x28
c0d03016:	bd80      	pop	{r7, pc}
  parameters[6] = (unsigned int)sig_len;
  parameters[7] = (unsigned int)info;
  retid = SVC_Call(SYSCALL_cx_ecdsa_sign_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecdsa_sign_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d03018:	2004      	movs	r0, #4
c0d0301a:	f7fe feb2 	bl	c0d01d82 <os_longjmp>
c0d0301e:	46c0      	nop			; (mov r8, r8)
c0d03020:	600038f3 	.word	0x600038f3
c0d03024:	90003876 	.word	0x90003876

c0d03028 <os_perso_derive_node_bip32>:
  }
  return (unsigned int)ret;
}

void os_perso_derive_node_bip32 ( cx_curve_t curve, const unsigned int * path, unsigned int pathLength, unsigned char * privateKey, unsigned char * chain ) 
{
c0d03028:	b580      	push	{r7, lr}
c0d0302a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d0302c:	af00      	add	r7, sp, #0
c0d0302e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d03030:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)path;
  parameters[2] = (unsigned int)pathLength;
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
c0d03032:	9004      	str	r0, [sp, #16]
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
c0d03034:	4806      	ldr	r0, [pc, #24]	; (c0d03050 <os_perso_derive_node_bip32+0x28>)
c0d03036:	4669      	mov	r1, sp
c0d03038:	f7ff ff15 	bl	c0d02e66 <SVC_Call>
c0d0303c:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0303e:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
c0d03040:	4904      	ldr	r1, [pc, #16]	; (c0d03054 <os_perso_derive_node_bip32+0x2c>)
c0d03042:	4288      	cmp	r0, r1
c0d03044:	d101      	bne.n	c0d0304a <os_perso_derive_node_bip32+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d03046:	b006      	add	sp, #24
c0d03048:	bd80      	pop	{r7, pc}
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0304a:	2004      	movs	r0, #4
c0d0304c:	f7fe fe99 	bl	c0d01d82 <os_longjmp>
c0d03050:	600053ba 	.word	0x600053ba
c0d03054:	9000531e 	.word	0x9000531e

c0d03058 <os_sched_exit>:
  }
  return (unsigned int)ret;
}

void os_sched_exit ( unsigned int exit_code ) 
{
c0d03058:	b580      	push	{r7, lr}
c0d0305a:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
c0d0305c:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
c0d0305e:	4807      	ldr	r0, [pc, #28]	; (c0d0307c <os_sched_exit+0x24>)
c0d03060:	4669      	mov	r1, sp
c0d03062:	f7ff ff00 	bl	c0d02e66 <SVC_Call>
c0d03066:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d03068:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
c0d0306a:	4905      	ldr	r1, [pc, #20]	; (c0d03080 <os_sched_exit+0x28>)
c0d0306c:	4288      	cmp	r0, r1
c0d0306e:	d101      	bne.n	c0d03074 <os_sched_exit+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d03070:	b002      	add	sp, #8
c0d03072:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d03074:	2004      	movs	r0, #4
c0d03076:	f7fe fe84 	bl	c0d01d82 <os_longjmp>
c0d0307a:	46c0      	nop			; (mov r8, r8)
c0d0307c:	600062e1 	.word	0x600062e1
c0d03080:	9000626f 	.word	0x9000626f

c0d03084 <os_ux>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_ux ( bolos_ux_params_t * params ) 
{
c0d03084:	b580      	push	{r7, lr}
c0d03086:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
c0d03088:	9000      	str	r0, [sp, #0]
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
c0d0308a:	4807      	ldr	r0, [pc, #28]	; (c0d030a8 <os_ux+0x24>)
c0d0308c:	4669      	mov	r1, sp
c0d0308e:	f7ff feea 	bl	c0d02e66 <SVC_Call>
c0d03092:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d03094:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_ux_ID_OUT) {
c0d03096:	4905      	ldr	r1, [pc, #20]	; (c0d030ac <os_ux+0x28>)
c0d03098:	4288      	cmp	r0, r1
c0d0309a:	d102      	bne.n	c0d030a2 <os_ux+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d0309c:	9801      	ldr	r0, [sp, #4]
c0d0309e:	b002      	add	sp, #8
c0d030a0:	bd80      	pop	{r7, pc}
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_ux_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d030a2:	2004      	movs	r0, #4
c0d030a4:	f7fe fe6d 	bl	c0d01d82 <os_longjmp>
c0d030a8:	60006458 	.word	0x60006458
c0d030ac:	9000641f 	.word	0x9000641f

c0d030b0 <os_flags>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_flags ( void ) 
{
c0d030b0:	b580      	push	{r7, lr}
c0d030b2:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_flags_ID_IN, parameters);
c0d030b4:	4807      	ldr	r0, [pc, #28]	; (c0d030d4 <os_flags+0x24>)
c0d030b6:	a901      	add	r1, sp, #4
c0d030b8:	f7ff fed5 	bl	c0d02e66 <SVC_Call>
c0d030bc:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d030be:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_flags_ID_OUT) {
c0d030c0:	4905      	ldr	r1, [pc, #20]	; (c0d030d8 <os_flags+0x28>)
c0d030c2:	4288      	cmp	r0, r1
c0d030c4:	d102      	bne.n	c0d030cc <os_flags+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d030c6:	9800      	ldr	r0, [sp, #0]
c0d030c8:	b002      	add	sp, #8
c0d030ca:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_flags_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_flags_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d030cc:	2004      	movs	r0, #4
c0d030ce:	f7fe fe58 	bl	c0d01d82 <os_longjmp>
c0d030d2:	46c0      	nop			; (mov r8, r8)
c0d030d4:	6000686e 	.word	0x6000686e
c0d030d8:	9000687f 	.word	0x9000687f

c0d030dc <os_registry_get_current_app_tag>:
  }
  return (unsigned int)ret;
}

unsigned int os_registry_get_current_app_tag ( unsigned int tag, unsigned char * buffer, unsigned int maxlen ) 
{
c0d030dc:	b580      	push	{r7, lr}
c0d030de:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)tag;
c0d030e0:	ab00      	add	r3, sp, #0
c0d030e2:	c307      	stmia	r3!, {r0, r1, r2}
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)maxlen;
  retid = SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID_IN, parameters);
c0d030e4:	4807      	ldr	r0, [pc, #28]	; (c0d03104 <os_registry_get_current_app_tag+0x28>)
c0d030e6:	4669      	mov	r1, sp
c0d030e8:	f7ff febd 	bl	c0d02e66 <SVC_Call>
c0d030ec:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d030ee:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_os_registry_get_current_app_tag_ID_OUT) {
c0d030f0:	4905      	ldr	r1, [pc, #20]	; (c0d03108 <os_registry_get_current_app_tag+0x2c>)
c0d030f2:	4288      	cmp	r0, r1
c0d030f4:	d102      	bne.n	c0d030fc <os_registry_get_current_app_tag+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d030f6:	9803      	ldr	r0, [sp, #12]
c0d030f8:	b004      	add	sp, #16
c0d030fa:	bd80      	pop	{r7, pc}
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)maxlen;
  retid = SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_registry_get_current_app_tag_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d030fc:	2004      	movs	r0, #4
c0d030fe:	f7fe fe40 	bl	c0d01d82 <os_longjmp>
c0d03102:	46c0      	nop			; (mov r8, r8)
c0d03104:	600070d4 	.word	0x600070d4
c0d03108:	90007087 	.word	0x90007087

c0d0310c <io_seproxyhal_spi_send>:
  }
  return (unsigned int)ret;
}

void io_seproxyhal_spi_send ( const unsigned char * buffer, unsigned short length ) 
{
c0d0310c:	b580      	push	{r7, lr}
c0d0310e:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d03110:	9001      	str	r0, [sp, #4]
  parameters[1] = (unsigned int)length;
c0d03112:	9102      	str	r1, [sp, #8]
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
c0d03114:	4806      	ldr	r0, [pc, #24]	; (c0d03130 <io_seproxyhal_spi_send+0x24>)
c0d03116:	a901      	add	r1, sp, #4
c0d03118:	f7ff fea5 	bl	c0d02e66 <SVC_Call>
c0d0311c:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0311e:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
c0d03120:	4904      	ldr	r1, [pc, #16]	; (c0d03134 <io_seproxyhal_spi_send+0x28>)
c0d03122:	4288      	cmp	r0, r1
c0d03124:	d101      	bne.n	c0d0312a <io_seproxyhal_spi_send+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d03126:	b004      	add	sp, #16
c0d03128:	bd80      	pop	{r7, pc}
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0312a:	2004      	movs	r0, #4
c0d0312c:	f7fe fe29 	bl	c0d01d82 <os_longjmp>
c0d03130:	6000721c 	.word	0x6000721c
c0d03134:	900072f3 	.word	0x900072f3

c0d03138 <io_seproxyhal_spi_is_status_sent>:
  }
}

unsigned int io_seproxyhal_spi_is_status_sent ( void ) 
{
c0d03138:	b580      	push	{r7, lr}
c0d0313a:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
c0d0313c:	4807      	ldr	r0, [pc, #28]	; (c0d0315c <io_seproxyhal_spi_is_status_sent+0x24>)
c0d0313e:	a901      	add	r1, sp, #4
c0d03140:	f7ff fe91 	bl	c0d02e66 <SVC_Call>
c0d03144:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d03146:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
c0d03148:	4905      	ldr	r1, [pc, #20]	; (c0d03160 <io_seproxyhal_spi_is_status_sent+0x28>)
c0d0314a:	4288      	cmp	r0, r1
c0d0314c:	d102      	bne.n	c0d03154 <io_seproxyhal_spi_is_status_sent+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d0314e:	9800      	ldr	r0, [sp, #0]
c0d03150:	b002      	add	sp, #8
c0d03152:	bd80      	pop	{r7, pc}
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d03154:	2004      	movs	r0, #4
c0d03156:	f7fe fe14 	bl	c0d01d82 <os_longjmp>
c0d0315a:	46c0      	nop			; (mov r8, r8)
c0d0315c:	600073cf 	.word	0x600073cf
c0d03160:	9000737f 	.word	0x9000737f

c0d03164 <io_seproxyhal_spi_recv>:
  }
  return (unsigned int)ret;
}

unsigned short io_seproxyhal_spi_recv ( unsigned char * buffer, unsigned short maxlength, unsigned int flags ) 
{
c0d03164:	b580      	push	{r7, lr}
c0d03166:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)buffer;
c0d03168:	ab00      	add	r3, sp, #0
c0d0316a:	c307      	stmia	r3!, {r0, r1, r2}
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
c0d0316c:	4807      	ldr	r0, [pc, #28]	; (c0d0318c <io_seproxyhal_spi_recv+0x28>)
c0d0316e:	4669      	mov	r1, sp
c0d03170:	f7ff fe79 	bl	c0d02e66 <SVC_Call>
c0d03174:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d03176:	6011      	str	r1, [r2, #0]
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
c0d03178:	4905      	ldr	r1, [pc, #20]	; (c0d03190 <io_seproxyhal_spi_recv+0x2c>)
c0d0317a:	4288      	cmp	r0, r1
c0d0317c:	d103      	bne.n	c0d03186 <io_seproxyhal_spi_recv+0x22>
c0d0317e:	a803      	add	r0, sp, #12
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned short)ret;
c0d03180:	8800      	ldrh	r0, [r0, #0]
c0d03182:	b004      	add	sp, #16
c0d03184:	bd80      	pop	{r7, pc}
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d03186:	2004      	movs	r0, #4
c0d03188:	f7fe fdfb 	bl	c0d01d82 <os_longjmp>
c0d0318c:	600074d1 	.word	0x600074d1
c0d03190:	9000742b 	.word	0x9000742b

c0d03194 <readUint64BE>:

#include "uint256.h"

static const char HEXDIGITS[] = "0123456789abcdef";

static uint64_t readUint64BE(uint8_t *buffer) {
c0d03194:	b510      	push	{r4, lr}
    return (((uint64_t)buffer[0]) << 56) | (((uint64_t)buffer[1]) << 48) |
           (((uint64_t)buffer[2]) << 40) | (((uint64_t)buffer[3]) << 32) |
           (((uint64_t)buffer[4]) << 24) | (((uint64_t)buffer[5]) << 16) |
c0d03196:	7941      	ldrb	r1, [r0, #5]
c0d03198:	0409      	lsls	r1, r1, #16
c0d0319a:	7902      	ldrb	r2, [r0, #4]
c0d0319c:	0612      	lsls	r2, r2, #24
c0d0319e:	430a      	orrs	r2, r1
           (((uint64_t)buffer[6]) << 8) | (((uint64_t)buffer[7]));
c0d031a0:	7981      	ldrb	r1, [r0, #6]
c0d031a2:	0209      	lsls	r1, r1, #8
static const char HEXDIGITS[] = "0123456789abcdef";

static uint64_t readUint64BE(uint8_t *buffer) {
    return (((uint64_t)buffer[0]) << 56) | (((uint64_t)buffer[1]) << 48) |
           (((uint64_t)buffer[2]) << 40) | (((uint64_t)buffer[3]) << 32) |
           (((uint64_t)buffer[4]) << 24) | (((uint64_t)buffer[5]) << 16) |
c0d031a4:	4311      	orrs	r1, r2
           (((uint64_t)buffer[6]) << 8) | (((uint64_t)buffer[7]));
c0d031a6:	79c2      	ldrb	r2, [r0, #7]
c0d031a8:	430a      	orrs	r2, r1
#include "uint256.h"

static const char HEXDIGITS[] = "0123456789abcdef";

static uint64_t readUint64BE(uint8_t *buffer) {
    return (((uint64_t)buffer[0]) << 56) | (((uint64_t)buffer[1]) << 48) |
c0d031aa:	7801      	ldrb	r1, [r0, #0]
c0d031ac:	0609      	lsls	r1, r1, #24
c0d031ae:	7843      	ldrb	r3, [r0, #1]
c0d031b0:	041b      	lsls	r3, r3, #16
c0d031b2:	430b      	orrs	r3, r1
           (((uint64_t)buffer[2]) << 40) | (((uint64_t)buffer[3]) << 32) |
c0d031b4:	7881      	ldrb	r1, [r0, #2]
c0d031b6:	020c      	lsls	r4, r1, #8
#include "uint256.h"

static const char HEXDIGITS[] = "0123456789abcdef";

static uint64_t readUint64BE(uint8_t *buffer) {
    return (((uint64_t)buffer[0]) << 56) | (((uint64_t)buffer[1]) << 48) |
c0d031b8:	431c      	orrs	r4, r3
           (((uint64_t)buffer[2]) << 40) | (((uint64_t)buffer[3]) << 32) |
c0d031ba:	78c1      	ldrb	r1, [r0, #3]
c0d031bc:	4321      	orrs	r1, r4
#include "uint256.h"

static const char HEXDIGITS[] = "0123456789abcdef";

static uint64_t readUint64BE(uint8_t *buffer) {
    return (((uint64_t)buffer[0]) << 56) | (((uint64_t)buffer[1]) << 48) |
c0d031be:	4610      	mov	r0, r2
c0d031c0:	bd10      	pop	{r4, pc}

c0d031c2 <readu256BE>:
void readu128BE(uint8_t *buffer, uint128_t *target) {
    UPPER_P(target) = readUint64BE(buffer);
    LOWER_P(target) = readUint64BE(buffer + 8);
}

void readu256BE(uint8_t *buffer, uint256_t *target) {
c0d031c2:	b5b0      	push	{r4, r5, r7, lr}
c0d031c4:	460c      	mov	r4, r1
c0d031c6:	4605      	mov	r5, r0
           (((uint64_t)buffer[4]) << 24) | (((uint64_t)buffer[5]) << 16) |
           (((uint64_t)buffer[6]) << 8) | (((uint64_t)buffer[7]));
}

void readu128BE(uint8_t *buffer, uint128_t *target) {
    UPPER_P(target) = readUint64BE(buffer);
c0d031c8:	f7ff ffe4 	bl	c0d03194 <readUint64BE>
c0d031cc:	c403      	stmia	r4!, {r0, r1}
    LOWER_P(target) = readUint64BE(buffer + 8);
c0d031ce:	4628      	mov	r0, r5
c0d031d0:	3008      	adds	r0, #8
           (((uint64_t)buffer[4]) << 24) | (((uint64_t)buffer[5]) << 16) |
           (((uint64_t)buffer[6]) << 8) | (((uint64_t)buffer[7]));
}

void readu128BE(uint8_t *buffer, uint128_t *target) {
    UPPER_P(target) = readUint64BE(buffer);
c0d031d2:	3c08      	subs	r4, #8
    LOWER_P(target) = readUint64BE(buffer + 8);
c0d031d4:	f7ff ffde 	bl	c0d03194 <readUint64BE>
c0d031d8:	60a0      	str	r0, [r4, #8]
c0d031da:	60e1      	str	r1, [r4, #12]
}

void readu256BE(uint8_t *buffer, uint256_t *target) {
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
c0d031dc:	4628      	mov	r0, r5
c0d031de:	3010      	adds	r0, #16
           (((uint64_t)buffer[4]) << 24) | (((uint64_t)buffer[5]) << 16) |
           (((uint64_t)buffer[6]) << 8) | (((uint64_t)buffer[7]));
}

void readu128BE(uint8_t *buffer, uint128_t *target) {
    UPPER_P(target) = readUint64BE(buffer);
c0d031e0:	f7ff ffd8 	bl	c0d03194 <readUint64BE>
c0d031e4:	6120      	str	r0, [r4, #16]
c0d031e6:	6161      	str	r1, [r4, #20]
    LOWER_P(target) = readUint64BE(buffer + 8);
c0d031e8:	3518      	adds	r5, #24
c0d031ea:	4628      	mov	r0, r5
c0d031ec:	f7ff ffd2 	bl	c0d03194 <readUint64BE>
c0d031f0:	61a0      	str	r0, [r4, #24]
c0d031f2:	61e1      	str	r1, [r4, #28]
}

void readu256BE(uint8_t *buffer, uint256_t *target) {
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}
c0d031f4:	bdb0      	pop	{r4, r5, r7, pc}

c0d031f6 <clear256>:
void clear128(uint128_t *target) {
    UPPER_P(target) = 0;
    LOWER_P(target) = 0;
}

void clear256(uint256_t *target) {
c0d031f6:	b580      	push	{r7, lr}
    copy128(&LOWER_P(target), &LOWER_P(number));
}

void clear128(uint128_t *target) {
    UPPER_P(target) = 0;
    LOWER_P(target) = 0;
c0d031f8:	2120      	movs	r1, #32
c0d031fa:	f001 fe45 	bl	c0d04e88 <__aeabi_memclr>
}

void clear256(uint256_t *target) {
    clear128(&UPPER_P(target));
    clear128(&LOWER_P(target));
}
c0d031fe:	bd80      	pop	{r7, pc}

c0d03200 <shiftl128>:

void shiftl128(uint128_t *number, uint32_t value, uint128_t *target) {
c0d03200:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03202:	b088      	sub	sp, #32
    if (value >= 128) {
c0d03204:	2980      	cmp	r1, #128	; 0x80
c0d03206:	d305      	bcc.n	c0d03214 <shiftl128+0x14>
c0d03208:	2000      	movs	r0, #0
c0d0320a:	6010      	str	r0, [r2, #0]
c0d0320c:	6050      	str	r0, [r2, #4]
c0d0320e:	6090      	str	r0, [r2, #8]
c0d03210:	60d0      	str	r0, [r2, #12]
c0d03212:	e061      	b.n	c0d032d8 <shiftl128+0xd8>
        clear128(target);
    } else if (value == 64) {
c0d03214:	2900      	cmp	r1, #0
c0d03216:	d008      	beq.n	c0d0322a <shiftl128+0x2a>
c0d03218:	2940      	cmp	r1, #64	; 0x40
c0d0321a:	d10d      	bne.n	c0d03238 <shiftl128+0x38>
        UPPER_P(target) = LOWER_P(number);
c0d0321c:	6881      	ldr	r1, [r0, #8]
c0d0321e:	68c0      	ldr	r0, [r0, #12]
        LOWER_P(target) = 0;
c0d03220:	2300      	movs	r3, #0

void shiftl128(uint128_t *number, uint32_t value, uint128_t *target) {
    if (value >= 128) {
        clear128(target);
    } else if (value == 64) {
        UPPER_P(target) = LOWER_P(number);
c0d03222:	6011      	str	r1, [r2, #0]
c0d03224:	6050      	str	r0, [r2, #4]
        LOWER_P(target) = 0;
c0d03226:	6093      	str	r3, [r2, #8]
c0d03228:	e055      	b.n	c0d032d6 <shiftl128+0xd6>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d0322a:	c80a      	ldmia	r0!, {r1, r3}
c0d0322c:	c20a      	stmia	r2!, {r1, r3}
    LOWER_P(target) = LOWER_P(number);
c0d0322e:	6801      	ldr	r1, [r0, #0]
c0d03230:	6840      	ldr	r0, [r0, #4]
c0d03232:	6050      	str	r0, [r2, #4]
c0d03234:	6011      	str	r1, [r2, #0]
c0d03236:	e04f      	b.n	c0d032d8 <shiftl128+0xd8>
    } else if (value == 64) {
        UPPER_P(target) = LOWER_P(number);
        LOWER_P(target) = 0;
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
c0d03238:	293f      	cmp	r1, #63	; 0x3f
c0d0323a:	d84f      	bhi.n	c0d032dc <shiftl128+0xdc>
c0d0323c:	2320      	movs	r3, #32
c0d0323e:	9304      	str	r3, [sp, #16]
        UPPER_P(target) =
            (UPPER_P(number) << value) + (LOWER_P(number) >> (64 - value));
c0d03240:	1a5f      	subs	r7, r3, r1
c0d03242:	2340      	movs	r3, #64	; 0x40
c0d03244:	1a5c      	subs	r4, r3, r1
c0d03246:	68c5      	ldr	r5, [r0, #12]
c0d03248:	462b      	mov	r3, r5
c0d0324a:	9402      	str	r4, [sp, #8]
c0d0324c:	40e3      	lsrs	r3, r4
c0d0324e:	2400      	movs	r4, #0
c0d03250:	2f00      	cmp	r7, #0
c0d03252:	9407      	str	r4, [sp, #28]
c0d03254:	da00      	bge.n	c0d03258 <shiftl128+0x58>
c0d03256:	461c      	mov	r4, r3
c0d03258:	9501      	str	r5, [sp, #4]
c0d0325a:	9405      	str	r4, [sp, #20]
c0d0325c:	c828      	ldmia	r0!, {r3, r5}
c0d0325e:	408d      	lsls	r5, r1
c0d03260:	461c      	mov	r4, r3
c0d03262:	9706      	str	r7, [sp, #24]
c0d03264:	40fc      	lsrs	r4, r7
c0d03266:	432c      	orrs	r4, r5
c0d03268:	460d      	mov	r5, r1
c0d0326a:	3d20      	subs	r5, #32
c0d0326c:	9300      	str	r3, [sp, #0]
c0d0326e:	461f      	mov	r7, r3
c0d03270:	40af      	lsls	r7, r5
c0d03272:	3808      	subs	r0, #8
c0d03274:	2d00      	cmp	r5, #0
c0d03276:	da00      	bge.n	c0d0327a <shiftl128+0x7a>
c0d03278:	4627      	mov	r7, r4
c0d0327a:	9703      	str	r7, [sp, #12]
c0d0327c:	6887      	ldr	r7, [r0, #8]
c0d0327e:	9e02      	ldr	r6, [sp, #8]
c0d03280:	40f7      	lsrs	r7, r6
c0d03282:	9c04      	ldr	r4, [sp, #16]
c0d03284:	1ba3      	subs	r3, r4, r6
c0d03286:	9304      	str	r3, [sp, #16]
c0d03288:	9e01      	ldr	r6, [sp, #4]
c0d0328a:	4634      	mov	r4, r6
c0d0328c:	9b04      	ldr	r3, [sp, #16]
c0d0328e:	409c      	lsls	r4, r3
c0d03290:	433c      	orrs	r4, r7
c0d03292:	9f06      	ldr	r7, [sp, #24]
c0d03294:	40fe      	lsrs	r6, r7
c0d03296:	2f00      	cmp	r7, #0
c0d03298:	da00      	bge.n	c0d0329c <shiftl128+0x9c>
c0d0329a:	4626      	mov	r6, r4
c0d0329c:	9b00      	ldr	r3, [sp, #0]
c0d0329e:	408b      	lsls	r3, r1
c0d032a0:	2d00      	cmp	r5, #0
c0d032a2:	9c07      	ldr	r4, [sp, #28]
c0d032a4:	da00      	bge.n	c0d032a8 <shiftl128+0xa8>
c0d032a6:	461c      	mov	r4, r3
c0d032a8:	1933      	adds	r3, r6, r4
c0d032aa:	9c05      	ldr	r4, [sp, #20]
c0d032ac:	9e03      	ldr	r6, [sp, #12]
c0d032ae:	4174      	adcs	r4, r6
        UPPER_P(target) = LOWER_P(number);
        LOWER_P(target) = 0;
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
        UPPER_P(target) =
c0d032b0:	c218      	stmia	r2!, {r3, r4}
            (UPPER_P(number) << value) + (LOWER_P(number) >> (64 - value));
        LOWER_P(target) = (LOWER_P(number) << value);
c0d032b2:	6883      	ldr	r3, [r0, #8]
c0d032b4:	461c      	mov	r4, r3
c0d032b6:	408c      	lsls	r4, r1
        UPPER_P(target) = LOWER_P(number);
        LOWER_P(target) = 0;
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
        UPPER_P(target) =
c0d032b8:	3a08      	subs	r2, #8
            (UPPER_P(number) << value) + (LOWER_P(number) >> (64 - value));
        LOWER_P(target) = (LOWER_P(number) << value);
c0d032ba:	2d00      	cmp	r5, #0
c0d032bc:	da00      	bge.n	c0d032c0 <shiftl128+0xc0>
c0d032be:	9407      	str	r4, [sp, #28]
c0d032c0:	68c4      	ldr	r4, [r0, #12]
c0d032c2:	9807      	ldr	r0, [sp, #28]
c0d032c4:	6090      	str	r0, [r2, #8]
c0d032c6:	408c      	lsls	r4, r1
c0d032c8:	4618      	mov	r0, r3
c0d032ca:	40f8      	lsrs	r0, r7
c0d032cc:	4320      	orrs	r0, r4
c0d032ce:	40ab      	lsls	r3, r5
c0d032d0:	2d00      	cmp	r5, #0
c0d032d2:	da00      	bge.n	c0d032d6 <shiftl128+0xd6>
c0d032d4:	4603      	mov	r3, r0
c0d032d6:	60d3      	str	r3, [r2, #12]
        UPPER_P(target) = LOWER_P(number) << (value - 64);
        LOWER_P(target) = 0;
    } else {
        clear128(target);
    }
}
c0d032d8:	b008      	add	sp, #32
c0d032da:	bdf0      	pop	{r4, r5, r6, r7, pc}
        copy128(target, number);
    } else if (value < 64) {
        UPPER_P(target) =
            (UPPER_P(number) << value) + (LOWER_P(number) >> (64 - value));
        LOWER_P(target) = (LOWER_P(number) << value);
    } else if ((128 > value) && (value > 64)) {
c0d032dc:	2940      	cmp	r1, #64	; 0x40
c0d032de:	d093      	beq.n	c0d03208 <shiftl128+0x8>
        UPPER_P(target) = LOWER_P(number) << (value - 64);
c0d032e0:	460e      	mov	r6, r1
c0d032e2:	3e40      	subs	r6, #64	; 0x40
c0d032e4:	6883      	ldr	r3, [r0, #8]
c0d032e6:	461f      	mov	r7, r3
c0d032e8:	40b7      	lsls	r7, r6
c0d032ea:	460d      	mov	r5, r1
c0d032ec:	3d60      	subs	r5, #96	; 0x60
c0d032ee:	2400      	movs	r4, #0
c0d032f0:	2d00      	cmp	r5, #0
c0d032f2:	9407      	str	r4, [sp, #28]
c0d032f4:	da00      	bge.n	c0d032f8 <shiftl128+0xf8>
c0d032f6:	463c      	mov	r4, r7
c0d032f8:	68c7      	ldr	r7, [r0, #12]
c0d032fa:	6014      	str	r4, [r2, #0]
c0d032fc:	40b7      	lsls	r7, r6
c0d032fe:	2060      	movs	r0, #96	; 0x60
c0d03300:	1a41      	subs	r1, r0, r1
c0d03302:	4618      	mov	r0, r3
c0d03304:	40c8      	lsrs	r0, r1
c0d03306:	4338      	orrs	r0, r7
c0d03308:	40ab      	lsls	r3, r5
c0d0330a:	2d00      	cmp	r5, #0
c0d0330c:	da00      	bge.n	c0d03310 <shiftl128+0x110>
c0d0330e:	4603      	mov	r3, r0
c0d03310:	6053      	str	r3, [r2, #4]
c0d03312:	9807      	ldr	r0, [sp, #28]
c0d03314:	e77b      	b.n	c0d0320e <shiftl128+0xe>

c0d03316 <shiftl256>:
    } else {
        clear128(target);
    }
}

void shiftl256(uint256_t *number, uint32_t value, uint256_t *target) {
c0d03316:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03318:	b095      	sub	sp, #84	; 0x54
c0d0331a:	4614      	mov	r4, r2
c0d0331c:	460e      	mov	r6, r1
c0d0331e:	4605      	mov	r5, r0
    if (value >= 256) {
c0d03320:	0a30      	lsrs	r0, r6, #8
c0d03322:	d004      	beq.n	c0d0332e <shiftl256+0x18>
c0d03324:	2120      	movs	r1, #32
c0d03326:	4620      	mov	r0, r4
c0d03328:	f001 fdae 	bl	c0d04e88 <__aeabi_memclr>
c0d0332c:	e06e      	b.n	c0d0340c <shiftl256+0xf6>
        clear256(target);
    } else if (value == 128) {
c0d0332e:	2e00      	cmp	r6, #0
c0d03330:	d00e      	beq.n	c0d03350 <shiftl256+0x3a>
c0d03332:	2e80      	cmp	r6, #128	; 0x80
c0d03334:	d119      	bne.n	c0d0336a <shiftl256+0x54>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03336:	6928      	ldr	r0, [r5, #16]
c0d03338:	6969      	ldr	r1, [r5, #20]
c0d0333a:	c403      	stmia	r4!, {r0, r1}
    LOWER_P(target) = LOWER_P(number);
c0d0333c:	69a8      	ldr	r0, [r5, #24]
c0d0333e:	69e9      	ldr	r1, [r5, #28]
c0d03340:	6061      	str	r1, [r4, #4]
c0d03342:	6020      	str	r0, [r4, #0]
c0d03344:	2000      	movs	r0, #0
    copy128(&LOWER_P(target), &LOWER_P(number));
}

void clear128(uint128_t *target) {
    UPPER_P(target) = 0;
    LOWER_P(target) = 0;
c0d03346:	6160      	str	r0, [r4, #20]
c0d03348:	6120      	str	r0, [r4, #16]
c0d0334a:	60e0      	str	r0, [r4, #12]
c0d0334c:	60a0      	str	r0, [r4, #8]
c0d0334e:	e05d      	b.n	c0d0340c <shiftl256+0xf6>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03350:	cd03      	ldmia	r5!, {r0, r1}
c0d03352:	c403      	stmia	r4!, {r0, r1}
    LOWER_P(target) = LOWER_P(number);
c0d03354:	6828      	ldr	r0, [r5, #0]
c0d03356:	6869      	ldr	r1, [r5, #4]
c0d03358:	6061      	str	r1, [r4, #4]
c0d0335a:	6020      	str	r0, [r4, #0]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d0335c:	68a8      	ldr	r0, [r5, #8]
c0d0335e:	68e9      	ldr	r1, [r5, #12]
c0d03360:	60e1      	str	r1, [r4, #12]
c0d03362:	60a0      	str	r0, [r4, #8]
    LOWER_P(target) = LOWER_P(number);
c0d03364:	6928      	ldr	r0, [r5, #16]
c0d03366:	6969      	ldr	r1, [r5, #20]
c0d03368:	e04d      	b.n	c0d03406 <shiftl256+0xf0>
    } else if (value == 128) {
        copy128(&UPPER_P(target), &LOWER_P(number));
        clear128(&LOWER_P(target));
    } else if (value == 0) {
        copy256(target, number);
    } else if (value < 128) {
c0d0336a:	2e7f      	cmp	r6, #127	; 0x7f
c0d0336c:	d850      	bhi.n	c0d03410 <shiftl256+0xfa>
c0d0336e:	aa10      	add	r2, sp, #64	; 0x40
        uint128_t tmp1;
        uint128_t tmp2;
        uint256_t result;
        shiftl128(&UPPER_P(number), value, &tmp1);
c0d03370:	4628      	mov	r0, r5
c0d03372:	4631      	mov	r1, r6
c0d03374:	f7ff ff44 	bl	c0d03200 <shiftl128>
        shiftr128(&LOWER_P(number), (128 - value), &tmp2);
c0d03378:	2080      	movs	r0, #128	; 0x80
c0d0337a:	1b81      	subs	r1, r0, r6
c0d0337c:	3510      	adds	r5, #16
c0d0337e:	aa0c      	add	r2, sp, #48	; 0x30
c0d03380:	4628      	mov	r0, r5
c0d03382:	f000 f854 	bl	c0d0342e <shiftr128>
}

void add128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) + UPPER_P(number2) +
        ((LOWER_P(number1) + LOWER_P(number2)) < LOWER_P(number1));
c0d03386:	9912      	ldr	r1, [sp, #72]	; 0x48
c0d03388:	9a0e      	ldr	r2, [sp, #56]	; 0x38
c0d0338a:	9813      	ldr	r0, [sp, #76]	; 0x4c
c0d0338c:	9f0f      	ldr	r7, [sp, #60]	; 0x3c
c0d0338e:	1853      	adds	r3, r2, r1
c0d03390:	4178      	adcs	r0, r7
c0d03392:	2101      	movs	r1, #1
c0d03394:	9101      	str	r1, [sp, #4]
c0d03396:	2100      	movs	r1, #0
c0d03398:	9302      	str	r3, [sp, #8]
c0d0339a:	4293      	cmp	r3, r2
c0d0339c:	9a01      	ldr	r2, [sp, #4]
c0d0339e:	9203      	str	r2, [sp, #12]
c0d033a0:	d300      	bcc.n	c0d033a4 <shiftl256+0x8e>
c0d033a2:	9103      	str	r1, [sp, #12]
c0d033a4:	42b8      	cmp	r0, r7
c0d033a6:	d300      	bcc.n	c0d033aa <shiftl256+0x94>
c0d033a8:	460a      	mov	r2, r1
c0d033aa:	42b8      	cmp	r0, r7
c0d033ac:	d000      	beq.n	c0d033b0 <shiftl256+0x9a>
c0d033ae:	9203      	str	r2, [sp, #12]
    return gt256(number1, number2) || equal256(number1, number2);
}

void add128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) + UPPER_P(number2) +
c0d033b0:	9b10      	ldr	r3, [sp, #64]	; 0x40
c0d033b2:	9f0c      	ldr	r7, [sp, #48]	; 0x30
c0d033b4:	9a11      	ldr	r2, [sp, #68]	; 0x44
c0d033b6:	9201      	str	r2, [sp, #4]
c0d033b8:	9a0d      	ldr	r2, [sp, #52]	; 0x34
c0d033ba:	18fb      	adds	r3, r7, r3
c0d033bc:	9f01      	ldr	r7, [sp, #4]
c0d033be:	417a      	adcs	r2, r7
c0d033c0:	9301      	str	r3, [sp, #4]
c0d033c2:	1c5f      	adds	r7, r3, #1
c0d033c4:	4151      	adcs	r1, r2
c0d033c6:	9b03      	ldr	r3, [sp, #12]
c0d033c8:	2b00      	cmp	r3, #0
c0d033ca:	d100      	bne.n	c0d033ce <shiftl256+0xb8>
c0d033cc:	4611      	mov	r1, r2
bool gte256(uint256_t *number1, uint256_t *number2) {
    return gt256(number1, number2) || equal256(number1, number2);
}

void add128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d033ce:	9105      	str	r1, [sp, #20]
        UPPER_P(number1) + UPPER_P(number2) +
c0d033d0:	9903      	ldr	r1, [sp, #12]
c0d033d2:	2900      	cmp	r1, #0
c0d033d4:	d100      	bne.n	c0d033d8 <shiftl256+0xc2>
c0d033d6:	9f01      	ldr	r7, [sp, #4]
bool gte256(uint256_t *number1, uint256_t *number2) {
    return gt256(number1, number2) || equal256(number1, number2);
}

void add128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d033d8:	9704      	str	r7, [sp, #16]
        UPPER_P(number1) + UPPER_P(number2) +
        ((LOWER_P(number1) + LOWER_P(number2)) < LOWER_P(number1));
    LOWER_P(target) = LOWER_P(number1) + LOWER_P(number2);
c0d033da:	9007      	str	r0, [sp, #28]
c0d033dc:	9802      	ldr	r0, [sp, #8]
c0d033de:	9006      	str	r0, [sp, #24]
c0d033e0:	aa04      	add	r2, sp, #16
        uint128_t tmp2;
        uint256_t result;
        shiftl128(&UPPER_P(number), value, &tmp1);
        shiftr128(&LOWER_P(number), (128 - value), &tmp2);
        add128(&tmp1, &tmp2, &UPPER(result));
        shiftl128(&LOWER_P(number), value, &LOWER(result));
c0d033e2:	3210      	adds	r2, #16
c0d033e4:	4628      	mov	r0, r5
c0d033e6:	4631      	mov	r1, r6
c0d033e8:	f7ff ff0a 	bl	c0d03200 <shiftl128>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d033ec:	9804      	ldr	r0, [sp, #16]
c0d033ee:	9905      	ldr	r1, [sp, #20]
c0d033f0:	c403      	stmia	r4!, {r0, r1}
    LOWER_P(target) = LOWER_P(number);
c0d033f2:	9806      	ldr	r0, [sp, #24]
c0d033f4:	9907      	ldr	r1, [sp, #28]
c0d033f6:	6061      	str	r1, [r4, #4]
c0d033f8:	6020      	str	r0, [r4, #0]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d033fa:	9808      	ldr	r0, [sp, #32]
c0d033fc:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d033fe:	60e1      	str	r1, [r4, #12]
c0d03400:	60a0      	str	r0, [r4, #8]
    LOWER_P(target) = LOWER_P(number);
c0d03402:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d03404:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d03406:	3c08      	subs	r4, #8
c0d03408:	61e1      	str	r1, [r4, #28]
c0d0340a:	61a0      	str	r0, [r4, #24]
        shiftl128(&LOWER_P(number), (value - 128), &UPPER_P(target));
        clear128(&LOWER_P(target));
    } else {
        clear256(target);
    }
}
c0d0340c:	b015      	add	sp, #84	; 0x54
c0d0340e:	bdf0      	pop	{r4, r5, r6, r7, pc}
        shiftl128(&UPPER_P(number), value, &tmp1);
        shiftr128(&LOWER_P(number), (128 - value), &tmp2);
        add128(&tmp1, &tmp2, &UPPER(result));
        shiftl128(&LOWER_P(number), value, &LOWER(result));
        copy256(target, &result);
    } else if ((256 > value) && (value > 128)) {
c0d03410:	2e80      	cmp	r6, #128	; 0x80
c0d03412:	d087      	beq.n	c0d03324 <shiftl256+0xe>
        shiftl128(&LOWER_P(number), (value - 128), &UPPER_P(target));
c0d03414:	3510      	adds	r5, #16
c0d03416:	3e80      	subs	r6, #128	; 0x80
c0d03418:	4628      	mov	r0, r5
c0d0341a:	4631      	mov	r1, r6
c0d0341c:	4622      	mov	r2, r4
c0d0341e:	f7ff feef 	bl	c0d03200 <shiftl128>
    copy128(&LOWER_P(target), &LOWER_P(number));
}

void clear128(uint128_t *target) {
    UPPER_P(target) = 0;
    LOWER_P(target) = 0;
c0d03422:	2000      	movs	r0, #0
c0d03424:	6120      	str	r0, [r4, #16]
c0d03426:	6160      	str	r0, [r4, #20]
c0d03428:	61a0      	str	r0, [r4, #24]
c0d0342a:	61e0      	str	r0, [r4, #28]
c0d0342c:	e7ee      	b.n	c0d0340c <shiftl256+0xf6>

c0d0342e <shiftr128>:
    } else {
        clear256(target);
    }
}

void shiftr128(uint128_t *number, uint32_t value, uint128_t *target) {
c0d0342e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03430:	b087      	sub	sp, #28
    if (value >= 128) {
c0d03432:	2980      	cmp	r1, #128	; 0x80
c0d03434:	d305      	bcc.n	c0d03442 <shiftr128+0x14>
c0d03436:	2000      	movs	r0, #0
c0d03438:	6010      	str	r0, [r2, #0]
c0d0343a:	6050      	str	r0, [r2, #4]
c0d0343c:	6090      	str	r0, [r2, #8]
c0d0343e:	60d0      	str	r0, [r2, #12]
c0d03440:	e07f      	b.n	c0d03542 <shiftr128+0x114>
        clear128(target);
    } else if (value == 64) {
c0d03442:	2900      	cmp	r1, #0
c0d03444:	d007      	beq.n	c0d03456 <shiftr128+0x28>
c0d03446:	2940      	cmp	r1, #64	; 0x40
c0d03448:	d10d      	bne.n	c0d03466 <shiftr128+0x38>
        UPPER_P(target) = 0;
c0d0344a:	2100      	movs	r1, #0
c0d0344c:	6051      	str	r1, [r2, #4]
c0d0344e:	6011      	str	r1, [r2, #0]
        LOWER_P(target) = UPPER_P(number);
c0d03450:	6801      	ldr	r1, [r0, #0]
c0d03452:	6840      	ldr	r0, [r0, #4]
c0d03454:	e004      	b.n	c0d03460 <shiftr128+0x32>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03456:	c80a      	ldmia	r0!, {r1, r3}
c0d03458:	c20a      	stmia	r2!, {r1, r3}
    LOWER_P(target) = LOWER_P(number);
c0d0345a:	6801      	ldr	r1, [r0, #0]
c0d0345c:	6840      	ldr	r0, [r0, #4]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d0345e:	3a08      	subs	r2, #8
c0d03460:	60d0      	str	r0, [r2, #12]
c0d03462:	6091      	str	r1, [r2, #8]
c0d03464:	e06d      	b.n	c0d03542 <shiftr128+0x114>
    } else if (value == 64) {
        UPPER_P(target) = 0;
        LOWER_P(target) = UPPER_P(number);
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
c0d03466:	293f      	cmp	r1, #63	; 0x3f
c0d03468:	d84d      	bhi.n	c0d03506 <shiftr128+0xd8>
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
c0d0346a:	6843      	ldr	r3, [r0, #4]
c0d0346c:	9303      	str	r3, [sp, #12]
c0d0346e:	40cb      	lsrs	r3, r1
c0d03470:	460c      	mov	r4, r1
c0d03472:	3c20      	subs	r4, #32
c0d03474:	2600      	movs	r6, #0
c0d03476:	2c00      	cmp	r4, #0
c0d03478:	9605      	str	r6, [sp, #20]
c0d0347a:	da00      	bge.n	c0d0347e <shiftr128+0x50>
c0d0347c:	461e      	mov	r6, r3
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
c0d0347e:	6885      	ldr	r5, [r0, #8]
c0d03480:	68c3      	ldr	r3, [r0, #12]
        LOWER_P(target) = UPPER_P(number);
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
c0d03482:	9304      	str	r3, [sp, #16]
c0d03484:	6800      	ldr	r0, [r0, #0]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03486:	6056      	str	r6, [r2, #4]
c0d03488:	2320      	movs	r3, #32
c0d0348a:	9302      	str	r3, [sp, #8]
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
c0d0348c:	1a5b      	subs	r3, r3, r1
c0d0348e:	9f03      	ldr	r7, [sp, #12]
        LOWER_P(target) = UPPER_P(number);
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
c0d03490:	463e      	mov	r6, r7
c0d03492:	9306      	str	r3, [sp, #24]
c0d03494:	409e      	lsls	r6, r3
c0d03496:	4603      	mov	r3, r0
c0d03498:	40cb      	lsrs	r3, r1
c0d0349a:	4333      	orrs	r3, r6
c0d0349c:	40e7      	lsrs	r7, r4
c0d0349e:	2c00      	cmp	r4, #0
c0d034a0:	da00      	bge.n	c0d034a4 <shiftr128+0x76>
c0d034a2:	461f      	mov	r7, r3
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d034a4:	6017      	str	r7, [r2, #0]
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
c0d034a6:	2340      	movs	r3, #64	; 0x40
c0d034a8:	1a5e      	subs	r6, r3, r1
c0d034aa:	4603      	mov	r3, r0
c0d034ac:	9600      	str	r6, [sp, #0]
c0d034ae:	40b3      	lsls	r3, r6
c0d034b0:	9e06      	ldr	r6, [sp, #24]
c0d034b2:	2e00      	cmp	r6, #0
c0d034b4:	9e05      	ldr	r6, [sp, #20]
c0d034b6:	da00      	bge.n	c0d034ba <shiftr128+0x8c>
c0d034b8:	461e      	mov	r6, r3
c0d034ba:	9601      	str	r6, [sp, #4]
c0d034bc:	9e04      	ldr	r6, [sp, #16]
c0d034be:	4633      	mov	r3, r6
c0d034c0:	9f06      	ldr	r7, [sp, #24]
c0d034c2:	40bb      	lsls	r3, r7
c0d034c4:	40cd      	lsrs	r5, r1
c0d034c6:	431d      	orrs	r5, r3
c0d034c8:	4633      	mov	r3, r6
c0d034ca:	40e3      	lsrs	r3, r4
c0d034cc:	2c00      	cmp	r4, #0
c0d034ce:	da00      	bge.n	c0d034d2 <shiftr128+0xa4>
c0d034d0:	462b      	mov	r3, r5
c0d034d2:	9f03      	ldr	r7, [sp, #12]
c0d034d4:	9e00      	ldr	r6, [sp, #0]
c0d034d6:	40b7      	lsls	r7, r6
c0d034d8:	9d02      	ldr	r5, [sp, #8]
c0d034da:	1bae      	subs	r6, r5, r6
c0d034dc:	4605      	mov	r5, r0
c0d034de:	40f5      	lsrs	r5, r6
c0d034e0:	433d      	orrs	r5, r7
c0d034e2:	9e06      	ldr	r6, [sp, #24]
c0d034e4:	40b0      	lsls	r0, r6
c0d034e6:	2e00      	cmp	r6, #0
c0d034e8:	da00      	bge.n	c0d034ec <shiftr128+0xbe>
c0d034ea:	4628      	mov	r0, r5
c0d034ec:	9d04      	ldr	r5, [sp, #16]
c0d034ee:	40cd      	lsrs	r5, r1
c0d034f0:	4629      	mov	r1, r5
c0d034f2:	2c00      	cmp	r4, #0
c0d034f4:	9c01      	ldr	r4, [sp, #4]
c0d034f6:	da00      	bge.n	c0d034fa <shiftr128+0xcc>
c0d034f8:	9105      	str	r1, [sp, #20]
c0d034fa:	1919      	adds	r1, r3, r4
c0d034fc:	9b05      	ldr	r3, [sp, #20]
c0d034fe:	4143      	adcs	r3, r0
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
    LOWER_P(target) = LOWER_P(number);
c0d03500:	6091      	str	r1, [r2, #8]
c0d03502:	60d3      	str	r3, [r2, #12]
c0d03504:	e01d      	b.n	c0d03542 <shiftr128+0x114>
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
        copy128(target, &result);
    } else if ((128 > value) && (value > 64)) {
c0d03506:	2940      	cmp	r1, #64	; 0x40
c0d03508:	d095      	beq.n	c0d03436 <shiftr128+0x8>
        LOWER_P(target) = UPPER_P(number) >> (value - 64);
c0d0350a:	460d      	mov	r5, r1
c0d0350c:	3d40      	subs	r5, #64	; 0x40
c0d0350e:	6843      	ldr	r3, [r0, #4]
c0d03510:	461f      	mov	r7, r3
c0d03512:	40ef      	lsrs	r7, r5
c0d03514:	460e      	mov	r6, r1
c0d03516:	3e60      	subs	r6, #96	; 0x60
c0d03518:	2400      	movs	r4, #0
c0d0351a:	2e00      	cmp	r6, #0
c0d0351c:	9406      	str	r4, [sp, #24]
c0d0351e:	da00      	bge.n	c0d03522 <shiftr128+0xf4>
c0d03520:	463c      	mov	r4, r7
c0d03522:	6800      	ldr	r0, [r0, #0]
c0d03524:	60d4      	str	r4, [r2, #12]
c0d03526:	2460      	movs	r4, #96	; 0x60
c0d03528:	1a61      	subs	r1, r4, r1
c0d0352a:	461c      	mov	r4, r3
c0d0352c:	408c      	lsls	r4, r1
c0d0352e:	40e8      	lsrs	r0, r5
c0d03530:	4320      	orrs	r0, r4
c0d03532:	40f3      	lsrs	r3, r6
c0d03534:	2e00      	cmp	r6, #0
c0d03536:	da00      	bge.n	c0d0353a <shiftr128+0x10c>
c0d03538:	4603      	mov	r3, r0
c0d0353a:	9806      	ldr	r0, [sp, #24]
        UPPER_P(target) = 0;
c0d0353c:	6010      	str	r0, [r2, #0]
c0d0353e:	6050      	str	r0, [r2, #4]
        UPPER(result) = UPPER_P(number) >> value;
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
        copy128(target, &result);
    } else if ((128 > value) && (value > 64)) {
        LOWER_P(target) = UPPER_P(number) >> (value - 64);
c0d03540:	6093      	str	r3, [r2, #8]
        UPPER_P(target) = 0;
    } else {
        clear128(target);
    }
}
c0d03542:	b007      	add	sp, #28
c0d03544:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03546 <shiftr256>:

void shiftr256(uint256_t *number, uint32_t value, uint256_t *target) {
c0d03546:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03548:	b093      	sub	sp, #76	; 0x4c
c0d0354a:	4614      	mov	r4, r2
c0d0354c:	460e      	mov	r6, r1
c0d0354e:	4605      	mov	r5, r0
    if (value >= 256) {
c0d03550:	0a30      	lsrs	r0, r6, #8
c0d03552:	d004      	beq.n	c0d0355e <shiftr256+0x18>
c0d03554:	2120      	movs	r1, #32
c0d03556:	4620      	mov	r0, r4
c0d03558:	f001 fc96 	bl	c0d04e88 <__aeabi_memclr>
c0d0355c:	e073      	b.n	c0d03646 <shiftr256+0x100>
        clear256(target);
    } else if (value == 128) {
c0d0355e:	2e00      	cmp	r6, #0
c0d03560:	d00e      	beq.n	c0d03580 <shiftr256+0x3a>
c0d03562:	2e80      	cmp	r6, #128	; 0x80
c0d03564:	d11b      	bne.n	c0d0359e <shiftr256+0x58>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03566:	cd03      	ldmia	r5!, {r0, r1}
c0d03568:	6161      	str	r1, [r4, #20]
c0d0356a:	6120      	str	r0, [r4, #16]
    LOWER_P(target) = LOWER_P(number);
c0d0356c:	6828      	ldr	r0, [r5, #0]
c0d0356e:	6869      	ldr	r1, [r5, #4]
c0d03570:	61e1      	str	r1, [r4, #28]
c0d03572:	61a0      	str	r0, [r4, #24]
c0d03574:	2000      	movs	r0, #0
    copy128(&LOWER_P(target), &LOWER_P(number));
}

void clear128(uint128_t *target) {
    UPPER_P(target) = 0;
    LOWER_P(target) = 0;
c0d03576:	60e0      	str	r0, [r4, #12]
c0d03578:	60a0      	str	r0, [r4, #8]
c0d0357a:	6060      	str	r0, [r4, #4]
c0d0357c:	6020      	str	r0, [r4, #0]
c0d0357e:	e062      	b.n	c0d03646 <shiftr256+0x100>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03580:	cd03      	ldmia	r5!, {r0, r1}
c0d03582:	c403      	stmia	r4!, {r0, r1}
    LOWER_P(target) = LOWER_P(number);
c0d03584:	6828      	ldr	r0, [r5, #0]
c0d03586:	6869      	ldr	r1, [r5, #4]
c0d03588:	6061      	str	r1, [r4, #4]
c0d0358a:	6020      	str	r0, [r4, #0]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d0358c:	68a8      	ldr	r0, [r5, #8]
c0d0358e:	68e9      	ldr	r1, [r5, #12]
c0d03590:	60e1      	str	r1, [r4, #12]
c0d03592:	60a0      	str	r0, [r4, #8]
    LOWER_P(target) = LOWER_P(number);
c0d03594:	6928      	ldr	r0, [r5, #16]
c0d03596:	6969      	ldr	r1, [r5, #20]
c0d03598:	6161      	str	r1, [r4, #20]
c0d0359a:	6120      	str	r0, [r4, #16]
c0d0359c:	e053      	b.n	c0d03646 <shiftr256+0x100>
    } else if (value == 128) {
        copy128(&LOWER_P(target), &UPPER_P(number));
        clear128(&UPPER_P(target));
    } else if (value == 0) {
        copy256(target, number);
    } else if (value < 128) {
c0d0359e:	2e7f      	cmp	r6, #127	; 0x7f
c0d035a0:	d843      	bhi.n	c0d0362a <shiftr256+0xe4>
c0d035a2:	aa02      	add	r2, sp, #8
        uint128_t tmp1;
        uint128_t tmp2;
        uint256_t result;
        shiftr128(&UPPER_P(number), value, &UPPER(result));
c0d035a4:	4628      	mov	r0, r5
c0d035a6:	4631      	mov	r1, r6
c0d035a8:	f7ff ff41 	bl	c0d0342e <shiftr128>
        shiftr128(&LOWER_P(number), value, &tmp1);
c0d035ac:	4628      	mov	r0, r5
c0d035ae:	3010      	adds	r0, #16
c0d035b0:	aa0e      	add	r2, sp, #56	; 0x38
c0d035b2:	4631      	mov	r1, r6
c0d035b4:	f7ff ff3b 	bl	c0d0342e <shiftr128>
        shiftl128(&UPPER_P(number), (128 - value), &tmp2);
c0d035b8:	2080      	movs	r0, #128	; 0x80
c0d035ba:	1b81      	subs	r1, r0, r6
c0d035bc:	aa0a      	add	r2, sp, #40	; 0x28
c0d035be:	4628      	mov	r0, r5
c0d035c0:	f7ff fe1e 	bl	c0d03200 <shiftl128>
}

void add128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) + UPPER_P(number2) +
        ((LOWER_P(number1) + LOWER_P(number2)) < LOWER_P(number1));
c0d035c4:	9910      	ldr	r1, [sp, #64]	; 0x40
c0d035c6:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0d035c8:	9811      	ldr	r0, [sp, #68]	; 0x44
c0d035ca:	9d0d      	ldr	r5, [sp, #52]	; 0x34
c0d035cc:	1859      	adds	r1, r3, r1
c0d035ce:	4168      	adcs	r0, r5
c0d035d0:	2601      	movs	r6, #1
c0d035d2:	2200      	movs	r2, #0
c0d035d4:	9101      	str	r1, [sp, #4]
c0d035d6:	4299      	cmp	r1, r3
c0d035d8:	4633      	mov	r3, r6
c0d035da:	d300      	bcc.n	c0d035de <shiftr256+0x98>
c0d035dc:	4613      	mov	r3, r2
c0d035de:	42a8      	cmp	r0, r5
c0d035e0:	d300      	bcc.n	c0d035e4 <shiftr256+0x9e>
c0d035e2:	4616      	mov	r6, r2
c0d035e4:	42a8      	cmp	r0, r5
c0d035e6:	d000      	beq.n	c0d035ea <shiftr256+0xa4>
c0d035e8:	4633      	mov	r3, r6
    return gt256(number1, number2) || equal256(number1, number2);
}

void add128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) + UPPER_P(number2) +
c0d035ea:	9d0e      	ldr	r5, [sp, #56]	; 0x38
c0d035ec:	9e0a      	ldr	r6, [sp, #40]	; 0x28
c0d035ee:	990f      	ldr	r1, [sp, #60]	; 0x3c
c0d035f0:	9f0b      	ldr	r7, [sp, #44]	; 0x2c
c0d035f2:	1976      	adds	r6, r6, r5
c0d035f4:	414f      	adcs	r7, r1
c0d035f6:	1c75      	adds	r5, r6, #1
c0d035f8:	417a      	adcs	r2, r7
c0d035fa:	2b00      	cmp	r3, #0
c0d035fc:	d100      	bne.n	c0d03600 <shiftr256+0xba>
c0d035fe:	463a      	mov	r2, r7
bool gte256(uint256_t *number1, uint256_t *number2) {
    return gt256(number1, number2) || equal256(number1, number2);
}

void add128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d03600:	9207      	str	r2, [sp, #28]
        UPPER_P(number1) + UPPER_P(number2) +
c0d03602:	2b00      	cmp	r3, #0
c0d03604:	d100      	bne.n	c0d03608 <shiftr256+0xc2>
c0d03606:	4635      	mov	r5, r6
bool gte256(uint256_t *number1, uint256_t *number2) {
    return gt256(number1, number2) || equal256(number1, number2);
}

void add128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d03608:	9506      	str	r5, [sp, #24]
        UPPER_P(number1) + UPPER_P(number2) +
        ((LOWER_P(number1) + LOWER_P(number2)) < LOWER_P(number1));
    LOWER_P(target) = LOWER_P(number1) + LOWER_P(number2);
c0d0360a:	9009      	str	r0, [sp, #36]	; 0x24
c0d0360c:	9e01      	ldr	r6, [sp, #4]
c0d0360e:	9608      	str	r6, [sp, #32]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03610:	9902      	ldr	r1, [sp, #8]
c0d03612:	9b03      	ldr	r3, [sp, #12]
c0d03614:	c40a      	stmia	r4!, {r1, r3}
    LOWER_P(target) = LOWER_P(number);
c0d03616:	9904      	ldr	r1, [sp, #16]
c0d03618:	9b05      	ldr	r3, [sp, #20]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d0361a:	60e2      	str	r2, [r4, #12]
c0d0361c:	3c08      	subs	r4, #8
    LOWER_P(target) = LOWER_P(number);
c0d0361e:	4622      	mov	r2, r4
c0d03620:	3208      	adds	r2, #8
c0d03622:	c22a      	stmia	r2!, {r1, r3, r5}
c0d03624:	61e0      	str	r0, [r4, #28]
c0d03626:	61a6      	str	r6, [r4, #24]
c0d03628:	e00d      	b.n	c0d03646 <shiftr256+0x100>
        shiftr128(&UPPER_P(number), value, &UPPER(result));
        shiftr128(&LOWER_P(number), value, &tmp1);
        shiftl128(&UPPER_P(number), (128 - value), &tmp2);
        add128(&tmp1, &tmp2, &LOWER(result));
        copy256(target, &result);
    } else if ((256 > value) && (value > 128)) {
c0d0362a:	2e80      	cmp	r6, #128	; 0x80
c0d0362c:	d092      	beq.n	c0d03554 <shiftr256+0xe>
        shiftr128(&UPPER_P(number), (value - 128), &LOWER_P(target));
c0d0362e:	3e80      	subs	r6, #128	; 0x80
c0d03630:	4622      	mov	r2, r4
c0d03632:	3210      	adds	r2, #16
c0d03634:	4628      	mov	r0, r5
c0d03636:	4631      	mov	r1, r6
c0d03638:	f7ff fef9 	bl	c0d0342e <shiftr128>
    copy128(&LOWER_P(target), &LOWER_P(number));
}

void clear128(uint128_t *target) {
    UPPER_P(target) = 0;
    LOWER_P(target) = 0;
c0d0363c:	2000      	movs	r0, #0
c0d0363e:	6020      	str	r0, [r4, #0]
c0d03640:	6060      	str	r0, [r4, #4]
c0d03642:	60a0      	str	r0, [r4, #8]
c0d03644:	60e0      	str	r0, [r4, #12]
        shiftr128(&UPPER_P(number), (value - 128), &LOWER_P(target));
        clear128(&UPPER_P(target));
    } else {
        clear256(target);
    }
}
c0d03646:	b013      	add	sp, #76	; 0x4c
c0d03648:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0364a <bits256>:
        }
    }
    return result;
}

uint32_t bits256(uint256_t *number) {
c0d0364a:	b570      	push	{r4, r5, r6, lr}
c0d0364c:	6804      	ldr	r4, [r0, #0]
c0d0364e:	1d03      	adds	r3, r0, #4
c0d03650:	cb0e      	ldmia	r3, {r1, r2, r3}
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d03652:	461e      	mov	r6, r3
c0d03654:	430e      	orrs	r6, r1
c0d03656:	4615      	mov	r5, r2
c0d03658:	4325      	orrs	r5, r4
c0d0365a:	4335      	orrs	r5, r6
c0d0365c:	2d00      	cmp	r5, #0
c0d0365e:	d017      	beq.n	c0d03690 <bits256+0x46>
c0d03660:	2080      	movs	r0, #128	; 0x80
c0d03662:	2d00      	cmp	r5, #0
c0d03664:	d034      	beq.n	c0d036d0 <bits256+0x86>
c0d03666:	2080      	movs	r0, #128	; 0x80
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
c0d03668:	0855      	lsrs	r5, r2, #1
c0d0366a:	07da      	lsls	r2, r3, #31
c0d0366c:	432a      	orrs	r2, r5
        LOWER_P(target) = UPPER_P(number);
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
c0d0366e:	0866      	lsrs	r6, r4, #1
c0d03670:	07cd      	lsls	r5, r1, #31
c0d03672:	4335      	orrs	r5, r6
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d03674:	462e      	mov	r6, r5
c0d03676:	4316      	orrs	r6, r2
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
c0d03678:	07e4      	lsls	r4, r4, #31
c0d0367a:	085b      	lsrs	r3, r3, #1
c0d0367c:	4323      	orrs	r3, r4
        LOWER_P(target) = UPPER_P(number);
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
c0d0367e:	0849      	lsrs	r1, r1, #1
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d03680:	460c      	mov	r4, r1
c0d03682:	431c      	orrs	r4, r3
c0d03684:	4334      	orrs	r4, r6
        result = 128;
        uint128_t up;
        copy128(&up, &UPPER_P(number));
        while (!zero128(&up)) {
            shiftr128(&up, 1, &up);
            result++;
c0d03686:	1c40      	adds	r0, r0, #1
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d03688:	2c00      	cmp	r4, #0
c0d0368a:	462c      	mov	r4, r5
c0d0368c:	d1ec      	bne.n	c0d03668 <bits256+0x1e>
c0d0368e:	e01f      	b.n	c0d036d0 <bits256+0x86>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03690:	6904      	ldr	r4, [r0, #16]
c0d03692:	4603      	mov	r3, r0
c0d03694:	3314      	adds	r3, #20
c0d03696:	cb0e      	ldmia	r3, {r1, r2, r3}
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d03698:	4608      	mov	r0, r1
c0d0369a:	4318      	orrs	r0, r3
c0d0369c:	4625      	mov	r5, r4
c0d0369e:	4315      	orrs	r5, r2
c0d036a0:	4305      	orrs	r5, r0
c0d036a2:	2000      	movs	r0, #0
c0d036a4:	2d00      	cmp	r5, #0
c0d036a6:	d013      	beq.n	c0d036d0 <bits256+0x86>
c0d036a8:	2000      	movs	r0, #0
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
c0d036aa:	0855      	lsrs	r5, r2, #1
c0d036ac:	07da      	lsls	r2, r3, #31
c0d036ae:	432a      	orrs	r2, r5
        LOWER_P(target) = UPPER_P(number);
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
c0d036b0:	0866      	lsrs	r6, r4, #1
c0d036b2:	07cd      	lsls	r5, r1, #31
c0d036b4:	4335      	orrs	r5, r6
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d036b6:	462e      	mov	r6, r5
c0d036b8:	4316      	orrs	r6, r2
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
        LOWER(result) =
            (UPPER_P(number) << (64 - value)) + (LOWER_P(number) >> value);
c0d036ba:	07e4      	lsls	r4, r4, #31
c0d036bc:	085b      	lsrs	r3, r3, #1
c0d036be:	4323      	orrs	r3, r4
        LOWER_P(target) = UPPER_P(number);
    } else if (value == 0) {
        copy128(target, number);
    } else if (value < 64) {
        uint128_t result;
        UPPER(result) = UPPER_P(number) >> value;
c0d036c0:	0849      	lsrs	r1, r1, #1
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d036c2:	460c      	mov	r4, r1
c0d036c4:	431c      	orrs	r4, r3
c0d036c6:	4334      	orrs	r4, r6
    } else {
        uint128_t low;
        copy128(&low, &LOWER_P(number));
        while (!zero128(&low)) {
            shiftr128(&low, 1, &low);
            result++;
c0d036c8:	1c40      	adds	r0, r0, #1
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d036ca:	2c00      	cmp	r4, #0
c0d036cc:	462c      	mov	r4, r5
c0d036ce:	d1ec      	bne.n	c0d036aa <bits256+0x60>
        while (!zero128(&low)) {
            shiftr128(&low, 1, &low);
            result++;
        }
    }
    return result;
c0d036d0:	bd70      	pop	{r4, r5, r6, pc}

c0d036d2 <gt256>:
        return (LOWER_P(number1) > LOWER_P(number2));
    }
    return (UPPER_P(number1) > UPPER_P(number2));
}

bool gt256(uint256_t *number1, uint256_t *number2) {
c0d036d2:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d036d4:	4602      	mov	r2, r0
    }
    return result;
}

bool equal128(uint128_t *number1, uint128_t *number2) {
    return (UPPER_P(number1) == UPPER_P(number2)) &&
c0d036d6:	c909      	ldmia	r1!, {r0, r3}
c0d036d8:	6815      	ldr	r5, [r2, #0]
c0d036da:	6854      	ldr	r4, [r2, #4]
c0d036dc:	4626      	mov	r6, r4
c0d036de:	405e      	eors	r6, r3
c0d036e0:	462f      	mov	r7, r5
c0d036e2:	4047      	eors	r7, r0
c0d036e4:	4337      	orrs	r7, r6
c0d036e6:	3908      	subs	r1, #8
c0d036e8:	2f00      	cmp	r7, #0
c0d036ea:	d11e      	bne.n	c0d0372a <gt256+0x58>
           (LOWER_P(number1) == LOWER_P(number2));
c0d036ec:	6888      	ldr	r0, [r1, #8]
c0d036ee:	68cb      	ldr	r3, [r1, #12]
c0d036f0:	6894      	ldr	r4, [r2, #8]
c0d036f2:	68d5      	ldr	r5, [r2, #12]
    }
    return (UPPER_P(number1) > UPPER_P(number2));
}

bool gt256(uint256_t *number1, uint256_t *number2) {
    if (equal128(&UPPER_P(number1), &UPPER_P(number2))) {
c0d036f4:	405d      	eors	r5, r3
c0d036f6:	4044      	eors	r4, r0
c0d036f8:	432c      	orrs	r4, r5
c0d036fa:	2c00      	cmp	r4, #0
c0d036fc:	d122      	bne.n	c0d03744 <gt256+0x72>
    return (equal128(&UPPER_P(number1), &UPPER_P(number2)) &&
            equal128(&LOWER_P(number1), &LOWER_P(number2)));
}

bool gt128(uint128_t *number1, uint128_t *number2) {
    if (UPPER_P(number1) == UPPER_P(number2)) {
c0d036fe:	6908      	ldr	r0, [r1, #16]
c0d03700:	694b      	ldr	r3, [r1, #20]
c0d03702:	6915      	ldr	r5, [r2, #16]
c0d03704:	6954      	ldr	r4, [r2, #20]
c0d03706:	4626      	mov	r6, r4
c0d03708:	405e      	eors	r6, r3
c0d0370a:	462f      	mov	r7, r5
c0d0370c:	4047      	eors	r7, r0
c0d0370e:	4337      	orrs	r7, r6
c0d03710:	2f00      	cmp	r7, #0
c0d03712:	d10a      	bne.n	c0d0372a <gt256+0x58>
        return (LOWER_P(number1) > LOWER_P(number2));
c0d03714:	6988      	ldr	r0, [r1, #24]
c0d03716:	6995      	ldr	r5, [r2, #24]
c0d03718:	2301      	movs	r3, #1
c0d0371a:	2400      	movs	r4, #0
c0d0371c:	4285      	cmp	r5, r0
c0d0371e:	4618      	mov	r0, r3
c0d03720:	d800      	bhi.n	c0d03724 <gt256+0x52>
c0d03722:	4620      	mov	r0, r4
c0d03724:	69c9      	ldr	r1, [r1, #28]
c0d03726:	69d2      	ldr	r2, [r2, #28]
c0d03728:	e016      	b.n	c0d03758 <gt256+0x86>
c0d0372a:	2101      	movs	r1, #1
c0d0372c:	2200      	movs	r2, #0
c0d0372e:	4285      	cmp	r5, r0
c0d03730:	4608      	mov	r0, r1
c0d03732:	d800      	bhi.n	c0d03736 <gt256+0x64>
c0d03734:	4610      	mov	r0, r2
c0d03736:	429c      	cmp	r4, r3
c0d03738:	d800      	bhi.n	c0d0373c <gt256+0x6a>
c0d0373a:	4611      	mov	r1, r2
c0d0373c:	429c      	cmp	r4, r3
c0d0373e:	d012      	beq.n	c0d03766 <gt256+0x94>
c0d03740:	4608      	mov	r0, r1
bool gt256(uint256_t *number1, uint256_t *number2) {
    if (equal128(&UPPER_P(number1), &UPPER_P(number2))) {
        return gt128(&LOWER_P(number1), &LOWER_P(number2));
    }
    return gt128(&UPPER_P(number1), &UPPER_P(number2));
}
c0d03742:	bdf0      	pop	{r4, r5, r6, r7, pc}
            equal128(&LOWER_P(number1), &LOWER_P(number2)));
}

bool gt128(uint128_t *number1, uint128_t *number2) {
    if (UPPER_P(number1) == UPPER_P(number2)) {
        return (LOWER_P(number1) > LOWER_P(number2));
c0d03744:	6888      	ldr	r0, [r1, #8]
c0d03746:	6895      	ldr	r5, [r2, #8]
c0d03748:	2301      	movs	r3, #1
c0d0374a:	2400      	movs	r4, #0
c0d0374c:	4285      	cmp	r5, r0
c0d0374e:	4618      	mov	r0, r3
c0d03750:	d800      	bhi.n	c0d03754 <gt256+0x82>
c0d03752:	4620      	mov	r0, r4
c0d03754:	68c9      	ldr	r1, [r1, #12]
c0d03756:	68d2      	ldr	r2, [r2, #12]
c0d03758:	428a      	cmp	r2, r1
c0d0375a:	d800      	bhi.n	c0d0375e <gt256+0x8c>
c0d0375c:	4623      	mov	r3, r4
c0d0375e:	428a      	cmp	r2, r1
c0d03760:	d001      	beq.n	c0d03766 <gt256+0x94>
c0d03762:	4618      	mov	r0, r3
bool gt256(uint256_t *number1, uint256_t *number2) {
    if (equal128(&UPPER_P(number1), &UPPER_P(number2))) {
        return gt128(&LOWER_P(number1), &LOWER_P(number2));
    }
    return gt128(&UPPER_P(number1), &UPPER_P(number2));
}
c0d03764:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03766:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03768 <gte256>:

bool gte128(uint128_t *number1, uint128_t *number2) {
    return gt128(number1, number2) || equal128(number1, number2);
}

bool gte256(uint256_t *number1, uint256_t *number2) {
c0d03768:	b570      	push	{r4, r5, r6, lr}
c0d0376a:	460d      	mov	r5, r1
c0d0376c:	4604      	mov	r4, r0
    return gt256(number1, number2) || equal256(number1, number2);
c0d0376e:	f7ff ffb0 	bl	c0d036d2 <gt256>
c0d03772:	4601      	mov	r1, r0
c0d03774:	2001      	movs	r0, #1
c0d03776:	2900      	cmp	r1, #0
c0d03778:	d127      	bne.n	c0d037ca <gte256+0x62>
    }
    return result;
}

bool equal128(uint128_t *number1, uint128_t *number2) {
    return (UPPER_P(number1) == UPPER_P(number2)) &&
c0d0377a:	cd03      	ldmia	r5!, {r0, r1}
c0d0377c:	cc0c      	ldmia	r4!, {r2, r3}
c0d0377e:	404b      	eors	r3, r1
c0d03780:	4042      	eors	r2, r0
c0d03782:	431a      	orrs	r2, r3
c0d03784:	2000      	movs	r0, #0
c0d03786:	3c08      	subs	r4, #8
c0d03788:	3d08      	subs	r5, #8
c0d0378a:	2a00      	cmp	r2, #0
c0d0378c:	d11d      	bne.n	c0d037ca <gte256+0x62>
           (LOWER_P(number1) == LOWER_P(number2));
c0d0378e:	68a9      	ldr	r1, [r5, #8]
c0d03790:	68ea      	ldr	r2, [r5, #12]
c0d03792:	68a3      	ldr	r3, [r4, #8]
c0d03794:	68e6      	ldr	r6, [r4, #12]
}

bool equal256(uint256_t *number1, uint256_t *number2) {
    return (equal128(&UPPER_P(number1), &UPPER_P(number2)) &&
c0d03796:	4056      	eors	r6, r2
c0d03798:	404b      	eors	r3, r1
c0d0379a:	4333      	orrs	r3, r6
c0d0379c:	2b00      	cmp	r3, #0
c0d0379e:	d114      	bne.n	c0d037ca <gte256+0x62>
    }
    return result;
}

bool equal128(uint128_t *number1, uint128_t *number2) {
    return (UPPER_P(number1) == UPPER_P(number2)) &&
c0d037a0:	6929      	ldr	r1, [r5, #16]
c0d037a2:	696a      	ldr	r2, [r5, #20]
c0d037a4:	6923      	ldr	r3, [r4, #16]
c0d037a6:	6966      	ldr	r6, [r4, #20]
c0d037a8:	4056      	eors	r6, r2
c0d037aa:	404b      	eors	r3, r1
c0d037ac:	4333      	orrs	r3, r6
c0d037ae:	2b00      	cmp	r3, #0
c0d037b0:	d10b      	bne.n	c0d037ca <gte256+0x62>
           (LOWER_P(number1) == LOWER_P(number2));
c0d037b2:	69a8      	ldr	r0, [r5, #24]
c0d037b4:	69e9      	ldr	r1, [r5, #28]
c0d037b6:	69a2      	ldr	r2, [r4, #24]
c0d037b8:	69e3      	ldr	r3, [r4, #28]
c0d037ba:	404b      	eors	r3, r1
c0d037bc:	4042      	eors	r2, r0
c0d037be:	431a      	orrs	r2, r3
c0d037c0:	2001      	movs	r0, #1
c0d037c2:	2100      	movs	r1, #0
c0d037c4:	2a00      	cmp	r2, #0
c0d037c6:	d000      	beq.n	c0d037ca <gte256+0x62>
c0d037c8:	4608      	mov	r0, r1
bool gte128(uint128_t *number1, uint128_t *number2) {
    return gt128(number1, number2) || equal128(number1, number2);
}

bool gte256(uint256_t *number1, uint256_t *number2) {
    return gt256(number1, number2) || equal256(number1, number2);
c0d037ca:	bd70      	pop	{r4, r5, r6, pc}

c0d037cc <minus256>:
        UPPER_P(number1) - UPPER_P(number2) -
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
    LOWER_P(target) = LOWER_P(number1) - LOWER_P(number2);
}

void minus256(uint256_t *number1, uint256_t *number2, uint256_t *target) {
c0d037cc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d037ce:	b092      	sub	sp, #72	; 0x48
c0d037d0:	9211      	str	r2, [sp, #68]	; 0x44
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
c0d037d2:	688a      	ldr	r2, [r1, #8]
c0d037d4:	68cc      	ldr	r4, [r1, #12]
c0d037d6:	6886      	ldr	r6, [r0, #8]
c0d037d8:	68c3      	ldr	r3, [r0, #12]
c0d037da:	1ab7      	subs	r7, r6, r2
c0d037dc:	461d      	mov	r5, r3
c0d037de:	41a5      	sbcs	r5, r4
c0d037e0:	2201      	movs	r2, #1
c0d037e2:	2400      	movs	r4, #0
c0d037e4:	42b7      	cmp	r7, r6
c0d037e6:	4616      	mov	r6, r2
c0d037e8:	d800      	bhi.n	c0d037ec <minus256+0x20>
c0d037ea:	4626      	mov	r6, r4
c0d037ec:	429d      	cmp	r5, r3
c0d037ee:	4617      	mov	r7, r2
c0d037f0:	d800      	bhi.n	c0d037f4 <minus256+0x28>
c0d037f2:	4627      	mov	r7, r4
c0d037f4:	9210      	str	r2, [sp, #64]	; 0x40
c0d037f6:	429d      	cmp	r5, r3
c0d037f8:	d000      	beq.n	c0d037fc <minus256+0x30>
c0d037fa:	463e      	mov	r6, r7
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
c0d037fc:	c928      	ldmia	r1!, {r3, r5}
c0d037fe:	c884      	ldmia	r0!, {r2, r7}
c0d03800:	3808      	subs	r0, #8
c0d03802:	3908      	subs	r1, #8
c0d03804:	1ad3      	subs	r3, r2, r3
c0d03806:	41af      	sbcs	r7, r5
c0d03808:	940f      	str	r4, [sp, #60]	; 0x3c
c0d0380a:	43e4      	mvns	r4, r4
c0d0380c:	1e5a      	subs	r2, r3, #1
c0d0380e:	463d      	mov	r5, r7
c0d03810:	940e      	str	r4, [sp, #56]	; 0x38
c0d03812:	4165      	adcs	r5, r4
c0d03814:	2e00      	cmp	r6, #0
c0d03816:	d100      	bne.n	c0d0381a <minus256+0x4e>
c0d03818:	463d      	mov	r5, r7
c0d0381a:	9f11      	ldr	r7, [sp, #68]	; 0x44
c0d0381c:	9507      	str	r5, [sp, #28]
    }
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d0381e:	607d      	str	r5, [r7, #4]
        UPPER_P(number1) - UPPER_P(number2) -
c0d03820:	2e00      	cmp	r6, #0
c0d03822:	9c10      	ldr	r4, [sp, #64]	; 0x40
c0d03824:	d100      	bne.n	c0d03828 <minus256+0x5c>
c0d03826:	461a      	mov	r2, r3
c0d03828:	9202      	str	r2, [sp, #8]
    }
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d0382a:	603a      	str	r2, [r7, #0]
        UPPER_P(number1) - UPPER_P(number2) -
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
    LOWER_P(target) = LOWER_P(number1) - LOWER_P(number2);
c0d0382c:	688a      	ldr	r2, [r1, #8]
c0d0382e:	6883      	ldr	r3, [r0, #8]
c0d03830:	68cd      	ldr	r5, [r1, #12]
c0d03832:	68c6      	ldr	r6, [r0, #12]
c0d03834:	1a9a      	subs	r2, r3, r2
c0d03836:	41ae      	sbcs	r6, r5
c0d03838:	9205      	str	r2, [sp, #20]
c0d0383a:	60ba      	str	r2, [r7, #8]
c0d0383c:	9606      	str	r6, [sp, #24]
c0d0383e:	60fe      	str	r6, [r7, #12]
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
c0d03840:	698d      	ldr	r5, [r1, #24]
c0d03842:	69ce      	ldr	r6, [r1, #28]
c0d03844:	6983      	ldr	r3, [r0, #24]
c0d03846:	69c2      	ldr	r2, [r0, #28]
c0d03848:	9504      	str	r5, [sp, #16]
c0d0384a:	1b5d      	subs	r5, r3, r5
c0d0384c:	4617      	mov	r7, r2
c0d0384e:	960a      	str	r6, [sp, #40]	; 0x28
c0d03850:	41b7      	sbcs	r7, r6
c0d03852:	930d      	str	r3, [sp, #52]	; 0x34
c0d03854:	9500      	str	r5, [sp, #0]
c0d03856:	429d      	cmp	r5, r3
c0d03858:	4623      	mov	r3, r4
c0d0385a:	d800      	bhi.n	c0d0385e <minus256+0x92>
c0d0385c:	9b0f      	ldr	r3, [sp, #60]	; 0x3c
c0d0385e:	4297      	cmp	r7, r2
c0d03860:	d800      	bhi.n	c0d03864 <minus256+0x98>
c0d03862:	9c0f      	ldr	r4, [sp, #60]	; 0x3c
c0d03864:	9210      	str	r2, [sp, #64]	; 0x40
c0d03866:	4297      	cmp	r7, r2
c0d03868:	d000      	beq.n	c0d0386c <minus256+0xa0>
c0d0386a:	4623      	mov	r3, r4
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
c0d0386c:	690a      	ldr	r2, [r1, #16]
c0d0386e:	694e      	ldr	r6, [r1, #20]
c0d03870:	6904      	ldr	r4, [r0, #16]
c0d03872:	6945      	ldr	r5, [r0, #20]
c0d03874:	9209      	str	r2, [sp, #36]	; 0x24
c0d03876:	940f      	str	r4, [sp, #60]	; 0x3c
c0d03878:	1aa2      	subs	r2, r4, r2
c0d0387a:	462c      	mov	r4, r5
c0d0387c:	9608      	str	r6, [sp, #32]
c0d0387e:	41b5      	sbcs	r5, r6
c0d03880:	1e56      	subs	r6, r2, #1
c0d03882:	960c      	str	r6, [sp, #48]	; 0x30
c0d03884:	9e0e      	ldr	r6, [sp, #56]	; 0x38
c0d03886:	416e      	adcs	r6, r5
c0d03888:	2b00      	cmp	r3, #0
c0d0388a:	d100      	bne.n	c0d0388e <minus256+0xc2>
c0d0388c:	462e      	mov	r6, r5
c0d0388e:	960e      	str	r6, [sp, #56]	; 0x38
    return (equal128(&UPPER_P(number1), &UPPER_P(number2)) &&
            equal128(&LOWER_P(number1), &LOWER_P(number2)));
}

bool gt128(uint128_t *number1, uint128_t *number2) {
    if (UPPER_P(number1) == UPPER_P(number2)) {
c0d03890:	4635      	mov	r5, r6
c0d03892:	9403      	str	r4, [sp, #12]
c0d03894:	4065      	eors	r5, r4
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
c0d03896:	2b00      	cmp	r3, #0
c0d03898:	9e0c      	ldr	r6, [sp, #48]	; 0x30
c0d0389a:	d100      	bne.n	c0d0389e <minus256+0xd2>
c0d0389c:	4616      	mov	r6, r2
    return (equal128(&UPPER_P(number1), &UPPER_P(number2)) &&
            equal128(&LOWER_P(number1), &LOWER_P(number2)));
}

bool gt128(uint128_t *number1, uint128_t *number2) {
    if (UPPER_P(number1) == UPPER_P(number2)) {
c0d0389e:	4632      	mov	r2, r6
c0d038a0:	9c0f      	ldr	r4, [sp, #60]	; 0x3c
c0d038a2:	4062      	eors	r2, r4
c0d038a4:	432a      	orrs	r2, r5
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
c0d038a6:	460b      	mov	r3, r1
c0d038a8:	3318      	adds	r3, #24
c0d038aa:	930b      	str	r3, [sp, #44]	; 0x2c
c0d038ac:	4603      	mov	r3, r0
c0d038ae:	3318      	adds	r3, #24
c0d038b0:	930c      	str	r3, [sp, #48]	; 0x30
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
c0d038b2:	3110      	adds	r1, #16
c0d038b4:	3010      	adds	r0, #16
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
    LOWER_P(target) = LOWER_P(number1) - LOWER_P(number2);
c0d038b6:	9b11      	ldr	r3, [sp, #68]	; 0x44
c0d038b8:	3308      	adds	r3, #8
c0d038ba:	9301      	str	r3, [sp, #4]
    return (equal128(&UPPER_P(number1), &UPPER_P(number2)) &&
            equal128(&LOWER_P(number1), &LOWER_P(number2)));
}

bool gt128(uint128_t *number1, uint128_t *number2) {
    if (UPPER_P(number1) == UPPER_P(number2)) {
c0d038bc:	2a00      	cmp	r2, #0
c0d038be:	d116      	bne.n	c0d038ee <minus256+0x122>

void minus256(uint256_t *number1, uint256_t *number2, uint256_t *target) {
    uint128_t tmp;
    minus128(&UPPER_P(number1), &UPPER_P(number2), &UPPER_P(target));
    minus128(&LOWER_P(number1), &LOWER_P(number2), &tmp);
    if (gt128(&tmp, &LOWER_P(number1))) {
c0d038c0:	2201      	movs	r2, #1
c0d038c2:	2500      	movs	r5, #0
c0d038c4:	9b0d      	ldr	r3, [sp, #52]	; 0x34
c0d038c6:	9c00      	ldr	r4, [sp, #0]
c0d038c8:	429c      	cmp	r4, r3
c0d038ca:	4613      	mov	r3, r2
c0d038cc:	d900      	bls.n	c0d038d0 <minus256+0x104>
c0d038ce:	462b      	mov	r3, r5
c0d038d0:	9e10      	ldr	r6, [sp, #64]	; 0x40
c0d038d2:	42b7      	cmp	r7, r6
c0d038d4:	9c03      	ldr	r4, [sp, #12]
c0d038d6:	d900      	bls.n	c0d038da <minus256+0x10e>
c0d038d8:	462a      	mov	r2, r5
c0d038da:	9d10      	ldr	r5, [sp, #64]	; 0x40
c0d038dc:	42af      	cmp	r7, r5
c0d038de:	d000      	beq.n	c0d038e2 <minus256+0x116>
c0d038e0:	4613      	mov	r3, r2
c0d038e2:	2b00      	cmp	r3, #0
c0d038e4:	9e11      	ldr	r6, [sp, #68]	; 0x44
c0d038e6:	9f07      	ldr	r7, [sp, #28]
c0d038e8:	9b04      	ldr	r3, [sp, #16]
c0d038ea:	d013      	beq.n	c0d03914 <minus256+0x148>
c0d038ec:	e03b      	b.n	c0d03966 <minus256+0x19a>
c0d038ee:	2201      	movs	r2, #1
c0d038f0:	2500      	movs	r5, #0

bool gt128(uint128_t *number1, uint128_t *number2) {
    if (UPPER_P(number1) == UPPER_P(number2)) {
        return (LOWER_P(number1) > LOWER_P(number2));
    }
    return (UPPER_P(number1) > UPPER_P(number2));
c0d038f2:	42a6      	cmp	r6, r4
c0d038f4:	4613      	mov	r3, r2
c0d038f6:	d800      	bhi.n	c0d038fa <minus256+0x12e>
c0d038f8:	462b      	mov	r3, r5
c0d038fa:	9c03      	ldr	r4, [sp, #12]
c0d038fc:	9f0e      	ldr	r7, [sp, #56]	; 0x38
c0d038fe:	42a7      	cmp	r7, r4
c0d03900:	9e11      	ldr	r6, [sp, #68]	; 0x44
c0d03902:	d800      	bhi.n	c0d03906 <minus256+0x13a>
c0d03904:	462a      	mov	r2, r5
c0d03906:	42a7      	cmp	r7, r4
c0d03908:	d000      	beq.n	c0d0390c <minus256+0x140>
c0d0390a:	4613      	mov	r3, r2

void minus256(uint256_t *number1, uint256_t *number2, uint256_t *target) {
    uint128_t tmp;
    minus128(&UPPER_P(number1), &UPPER_P(number2), &UPPER_P(target));
    minus128(&LOWER_P(number1), &LOWER_P(number2), &tmp);
    if (gt128(&tmp, &LOWER_P(number1))) {
c0d0390c:	2b00      	cmp	r3, #0
c0d0390e:	9f07      	ldr	r7, [sp, #28]
c0d03910:	9b04      	ldr	r3, [sp, #16]
c0d03912:	d028      	beq.n	c0d03966 <minus256+0x19a>
c0d03914:	2200      	movs	r2, #0
c0d03916:	43d2      	mvns	r2, r2
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
c0d03918:	9b02      	ldr	r3, [sp, #8]
c0d0391a:	1e5b      	subs	r3, r3, #1
c0d0391c:	9311      	str	r3, [sp, #68]	; 0x44
c0d0391e:	463d      	mov	r5, r7
c0d03920:	4155      	adcs	r5, r2
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
c0d03922:	9c05      	ldr	r4, [sp, #20]
c0d03924:	9b06      	ldr	r3, [sp, #24]
c0d03926:	431c      	orrs	r4, r3
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
c0d03928:	2c00      	cmp	r4, #0
c0d0392a:	d000      	beq.n	c0d0392e <minus256+0x162>
c0d0392c:	463d      	mov	r5, r7
    }
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d0392e:	6075      	str	r5, [r6, #4]
        UPPER_P(number1) - UPPER_P(number2) -
c0d03930:	2c00      	cmp	r4, #0
c0d03932:	9b11      	ldr	r3, [sp, #68]	; 0x44
c0d03934:	d000      	beq.n	c0d03938 <minus256+0x16c>
c0d03936:	9b02      	ldr	r3, [sp, #8]
    }
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d03938:	6033      	str	r3, [r6, #0]
        UPPER_P(number1) - UPPER_P(number2) -
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
    LOWER_P(target) = LOWER_P(number1) - LOWER_P(number2);
c0d0393a:	9b05      	ldr	r3, [sp, #20]
c0d0393c:	1e5b      	subs	r3, r3, #1
c0d0393e:	9c06      	ldr	r4, [sp, #24]
c0d03940:	4154      	adcs	r4, r2
c0d03942:	9a01      	ldr	r2, [sp, #4]
c0d03944:	c218      	stmia	r2!, {r3, r4}
c0d03946:	9a0b      	ldr	r2, [sp, #44]	; 0x2c
c0d03948:	6813      	ldr	r3, [r2, #0]
c0d0394a:	6852      	ldr	r2, [r2, #4]
c0d0394c:	920a      	str	r2, [sp, #40]	; 0x28
c0d0394e:	9c0c      	ldr	r4, [sp, #48]	; 0x30
c0d03950:	6822      	ldr	r2, [r4, #0]
c0d03952:	920d      	str	r2, [sp, #52]	; 0x34
c0d03954:	6862      	ldr	r2, [r4, #4]
c0d03956:	9210      	str	r2, [sp, #64]	; 0x40
c0d03958:	680a      	ldr	r2, [r1, #0]
c0d0395a:	9209      	str	r2, [sp, #36]	; 0x24
c0d0395c:	6849      	ldr	r1, [r1, #4]
c0d0395e:	9108      	str	r1, [sp, #32]
c0d03960:	6801      	ldr	r1, [r0, #0]
c0d03962:	910f      	str	r1, [sp, #60]	; 0x3c
c0d03964:	6844      	ldr	r4, [r0, #4]
c0d03966:	9f0d      	ldr	r7, [sp, #52]	; 0x34
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
c0d03968:	1af8      	subs	r0, r7, r3
c0d0396a:	9d10      	ldr	r5, [sp, #64]	; 0x40
c0d0396c:	462b      	mov	r3, r5
c0d0396e:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d03970:	418b      	sbcs	r3, r1
c0d03972:	2201      	movs	r2, #1
c0d03974:	2100      	movs	r1, #0
c0d03976:	42b8      	cmp	r0, r7
c0d03978:	4610      	mov	r0, r2
c0d0397a:	d800      	bhi.n	c0d0397e <minus256+0x1b2>
c0d0397c:	4608      	mov	r0, r1
c0d0397e:	42ab      	cmp	r3, r5
c0d03980:	d800      	bhi.n	c0d03984 <minus256+0x1b8>
c0d03982:	460a      	mov	r2, r1
c0d03984:	42ab      	cmp	r3, r5
c0d03986:	9b0f      	ldr	r3, [sp, #60]	; 0x3c
c0d03988:	d000      	beq.n	c0d0398c <minus256+0x1c0>
c0d0398a:	4610      	mov	r0, r2
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
        UPPER_P(number1) - UPPER_P(number2) -
c0d0398c:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d0398e:	1a9a      	subs	r2, r3, r2
c0d03990:	9b08      	ldr	r3, [sp, #32]
c0d03992:	419c      	sbcs	r4, r3
c0d03994:	43cb      	mvns	r3, r1
c0d03996:	1e51      	subs	r1, r2, #1
c0d03998:	4163      	adcs	r3, r4
c0d0399a:	2800      	cmp	r0, #0
c0d0399c:	d100      	bne.n	c0d039a0 <minus256+0x1d4>
c0d0399e:	4623      	mov	r3, r4
    }
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d039a0:	6173      	str	r3, [r6, #20]
        UPPER_P(number1) - UPPER_P(number2) -
c0d039a2:	2800      	cmp	r0, #0
c0d039a4:	d100      	bne.n	c0d039a8 <minus256+0x1dc>
c0d039a6:	4611      	mov	r1, r2
    }
    add128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void minus128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) =
c0d039a8:	6131      	str	r1, [r6, #16]
c0d039aa:	990b      	ldr	r1, [sp, #44]	; 0x2c
        UPPER_P(number1) - UPPER_P(number2) -
        ((LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1));
    LOWER_P(target) = LOWER_P(number1) - LOWER_P(number2);
c0d039ac:	c903      	ldmia	r1, {r0, r1}
c0d039ae:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0d039b0:	cb0c      	ldmia	r3, {r2, r3}
c0d039b2:	1a10      	subs	r0, r2, r0
c0d039b4:	418b      	sbcs	r3, r1
c0d039b6:	61b0      	str	r0, [r6, #24]
c0d039b8:	61f3      	str	r3, [r6, #28]
        UPPER(one) = 0;
        LOWER(one) = 1;
        minus128(&UPPER_P(target), &one, &UPPER_P(target));
    }
    minus128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}
c0d039ba:	b012      	add	sp, #72	; 0x48
c0d039bc:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d039be <divmod256>:
        copy128(retMod, &resMod);
    }
}

void divmod256(uint256_t *l, uint256_t *r, uint256_t *retDiv,
               uint256_t *retMod) {
c0d039be:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d039c0:	b0b7      	sub	sp, #220	; 0xdc
c0d039c2:	461e      	mov	r6, r3
c0d039c4:	9209      	str	r2, [sp, #36]	; 0x24
c0d039c6:	460c      	mov	r4, r1
c0d039c8:	4607      	mov	r7, r0
c0d039ca:	a816      	add	r0, sp, #88	; 0x58
c0d039cc:	2118      	movs	r1, #24
    uint256_t copyd, adder, resDiv, resMod;
    uint256_t one;
    clear256(&one);
    UPPER(LOWER(one)) = 0;
c0d039ce:	f001 fa5b 	bl	c0d04e88 <__aeabi_memclr>
c0d039d2:	2000      	movs	r0, #0
c0d039d4:	9010      	str	r0, [sp, #64]	; 0x40
    LOWER(LOWER(one)) = 1;
c0d039d6:	901d      	str	r0, [sp, #116]	; 0x74
c0d039d8:	2001      	movs	r0, #1
c0d039da:	9013      	str	r0, [sp, #76]	; 0x4c
c0d039dc:	901c      	str	r0, [sp, #112]	; 0x70
    uint32_t diffBits = bits256(l) - bits256(r);
c0d039de:	4638      	mov	r0, r7
c0d039e0:	f7ff fe33 	bl	c0d0364a <bits256>
c0d039e4:	4605      	mov	r5, r0
c0d039e6:	4620      	mov	r0, r4
c0d039e8:	f7ff fe2f 	bl	c0d0364a <bits256>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d039ec:	cf06      	ldmia	r7!, {r1, r2}
c0d039ee:	920a      	str	r2, [sp, #40]	; 0x28
c0d039f0:	921f      	str	r2, [sp, #124]	; 0x7c
c0d039f2:	910b      	str	r1, [sp, #44]	; 0x2c
c0d039f4:	911e      	str	r1, [sp, #120]	; 0x78
    LOWER_P(target) = LOWER_P(number);
c0d039f6:	6839      	ldr	r1, [r7, #0]
c0d039f8:	687a      	ldr	r2, [r7, #4]
c0d039fa:	9207      	str	r2, [sp, #28]
c0d039fc:	9221      	str	r2, [sp, #132]	; 0x84
c0d039fe:	9108      	str	r1, [sp, #32]
c0d03a00:	9120      	str	r1, [sp, #128]	; 0x80
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03a02:	68b9      	ldr	r1, [r7, #8]
c0d03a04:	68fa      	ldr	r2, [r7, #12]
c0d03a06:	9205      	str	r2, [sp, #20]
c0d03a08:	9223      	str	r2, [sp, #140]	; 0x8c
c0d03a0a:	9106      	str	r1, [sp, #24]
c0d03a0c:	9122      	str	r1, [sp, #136]	; 0x88
    LOWER_P(target) = LOWER_P(number);
c0d03a0e:	6939      	ldr	r1, [r7, #16]
c0d03a10:	697a      	ldr	r2, [r7, #20]
c0d03a12:	9203      	str	r2, [sp, #12]
c0d03a14:	9225      	str	r2, [sp, #148]	; 0x94
c0d03a16:	9104      	str	r1, [sp, #16]
c0d03a18:	9124      	str	r1, [sp, #144]	; 0x90
    uint256_t copyd, adder, resDiv, resMod;
    uint256_t one;
    clear256(&one);
    UPPER(LOWER(one)) = 0;
    LOWER(LOWER(one)) = 1;
    uint32_t diffBits = bits256(l) - bits256(r);
c0d03a1a:	1a28      	subs	r0, r5, r0
    clear256(&resDiv);
    copy256(&resMod, l);
    if (gt256(r, l)) {
c0d03a1c:	9014      	str	r0, [sp, #80]	; 0x50
c0d03a1e:	9415      	str	r4, [sp, #84]	; 0x54
c0d03a20:	4620      	mov	r0, r4
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03a22:	3f08      	subs	r7, #8
    UPPER(LOWER(one)) = 0;
    LOWER(LOWER(one)) = 1;
    uint32_t diffBits = bits256(l) - bits256(r);
    clear256(&resDiv);
    copy256(&resMod, l);
    if (gt256(r, l)) {
c0d03a24:	4639      	mov	r1, r7
c0d03a26:	f7ff fe54 	bl	c0d036d2 <gt256>
c0d03a2a:	ab1e      	add	r3, sp, #120	; 0x78
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
    LOWER_P(target) = LOWER_P(number);
c0d03a2c:	461d      	mov	r5, r3
c0d03a2e:	3518      	adds	r5, #24
c0d03a30:	4639      	mov	r1, r7
c0d03a32:	3118      	adds	r1, #24
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03a34:	461c      	mov	r4, r3
c0d03a36:	3410      	adds	r4, #16
c0d03a38:	463a      	mov	r2, r7
c0d03a3a:	3210      	adds	r2, #16
    LOWER_P(target) = LOWER_P(number);
c0d03a3c:	3308      	adds	r3, #8
c0d03a3e:	3708      	adds	r7, #8
    UPPER(LOWER(one)) = 0;
    LOWER(LOWER(one)) = 1;
    uint32_t diffBits = bits256(l) - bits256(r);
    clear256(&resDiv);
    copy256(&resMod, l);
    if (gt256(r, l)) {
c0d03a40:	2801      	cmp	r0, #1
c0d03a42:	d111      	bne.n	c0d03a68 <divmod256+0xaa>
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03a44:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d03a46:	6030      	str	r0, [r6, #0]
c0d03a48:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d03a4a:	6070      	str	r0, [r6, #4]
    LOWER_P(target) = LOWER_P(number);
c0d03a4c:	cf09      	ldmia	r7!, {r0, r3}
c0d03a4e:	60f3      	str	r3, [r6, #12]
c0d03a50:	60b0      	str	r0, [r6, #8]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03a52:	ca05      	ldmia	r2, {r0, r2}
c0d03a54:	6172      	str	r2, [r6, #20]
c0d03a56:	6130      	str	r0, [r6, #16]
    LOWER_P(target) = LOWER_P(number);
c0d03a58:	c903      	ldmia	r1, {r0, r1}
c0d03a5a:	61f1      	str	r1, [r6, #28]
c0d03a5c:	61b0      	str	r0, [r6, #24]
    copy128(&LOWER_P(target), &LOWER_P(number));
}

void clear128(uint128_t *target) {
    UPPER_P(target) = 0;
    LOWER_P(target) = 0;
c0d03a5e:	2120      	movs	r1, #32
c0d03a60:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d03a62:	f001 fa11 	bl	c0d04e88 <__aeabi_memclr>
c0d03a66:	e0ff      	b.n	c0d03c68 <divmod256+0x2aa>
c0d03a68:	9411      	str	r4, [sp, #68]	; 0x44
c0d03a6a:	9512      	str	r5, [sp, #72]	; 0x48
c0d03a6c:	9301      	str	r3, [sp, #4]
c0d03a6e:	9602      	str	r6, [sp, #8]
c0d03a70:	aa2e      	add	r2, sp, #184	; 0xb8
c0d03a72:	9f15      	ldr	r7, [sp, #84]	; 0x54
    copy256(&resMod, l);
    if (gt256(r, l)) {
        copy256(retMod, l);
        clear256(retDiv);
    } else {
        shiftl256(r, diffBits, &copyd);
c0d03a74:	4638      	mov	r0, r7
c0d03a76:	9d14      	ldr	r5, [sp, #80]	; 0x50
c0d03a78:	4629      	mov	r1, r5
c0d03a7a:	f7ff fc4c 	bl	c0d03316 <shiftl256>
c0d03a7e:	a816      	add	r0, sp, #88	; 0x58
c0d03a80:	aa26      	add	r2, sp, #152	; 0x98
        shiftl256(&one, diffBits, &adder);
c0d03a82:	4629      	mov	r1, r5
c0d03a84:	f7ff fc47 	bl	c0d03316 <shiftl256>
    }
    return result;
}

bool equal128(uint128_t *number1, uint128_t *number2) {
    return (UPPER_P(number1) == UPPER_P(number2)) &&
c0d03a88:	982f      	ldr	r0, [sp, #188]	; 0xbc
c0d03a8a:	4602      	mov	r2, r0
c0d03a8c:	9d0a      	ldr	r5, [sp, #40]	; 0x28
c0d03a8e:	406a      	eors	r2, r5
c0d03a90:	992e      	ldr	r1, [sp, #184]	; 0xb8
c0d03a92:	460b      	mov	r3, r1
c0d03a94:	9e0b      	ldr	r6, [sp, #44]	; 0x2c
c0d03a96:	4073      	eors	r3, r6
c0d03a98:	4313      	orrs	r3, r2
c0d03a9a:	2b00      	cmp	r3, #0
c0d03a9c:	4632      	mov	r2, r6
c0d03a9e:	d129      	bne.n	c0d03af4 <divmod256+0x136>
           (LOWER_P(number1) == LOWER_P(number2));
c0d03aa0:	9a30      	ldr	r2, [sp, #192]	; 0xc0
    }
    return (UPPER_P(number1) > UPPER_P(number2));
}

bool gt256(uint256_t *number1, uint256_t *number2) {
    if (equal128(&UPPER_P(number1), &UPPER_P(number2))) {
c0d03aa2:	4611      	mov	r1, r2
c0d03aa4:	9e08      	ldr	r6, [sp, #32]
c0d03aa6:	4071      	eors	r1, r6
    return result;
}

bool equal128(uint128_t *number1, uint128_t *number2) {
    return (UPPER_P(number1) == UPPER_P(number2)) &&
           (LOWER_P(number1) == LOWER_P(number2));
c0d03aa8:	9831      	ldr	r0, [sp, #196]	; 0xc4
    }
    return (UPPER_P(number1) > UPPER_P(number2));
}

bool gt256(uint256_t *number1, uint256_t *number2) {
    if (equal128(&UPPER_P(number1), &UPPER_P(number2))) {
c0d03aaa:	4603      	mov	r3, r0
c0d03aac:	9f07      	ldr	r7, [sp, #28]
c0d03aae:	407b      	eors	r3, r7
c0d03ab0:	430b      	orrs	r3, r1
c0d03ab2:	2b00      	cmp	r3, #0
c0d03ab4:	d12f      	bne.n	c0d03b16 <divmod256+0x158>
    return (equal128(&UPPER_P(number1), &UPPER_P(number2)) &&
            equal128(&LOWER_P(number1), &LOWER_P(number2)));
}

bool gt128(uint128_t *number1, uint128_t *number2) {
    if (UPPER_P(number1) == UPPER_P(number2)) {
c0d03ab6:	9a32      	ldr	r2, [sp, #200]	; 0xc8
c0d03ab8:	4611      	mov	r1, r2
c0d03aba:	9e06      	ldr	r6, [sp, #24]
c0d03abc:	4071      	eors	r1, r6
c0d03abe:	9833      	ldr	r0, [sp, #204]	; 0xcc
c0d03ac0:	4603      	mov	r3, r0
c0d03ac2:	9f05      	ldr	r7, [sp, #20]
c0d03ac4:	407b      	eors	r3, r7
c0d03ac6:	430b      	orrs	r3, r1
c0d03ac8:	2b00      	cmp	r3, #0
c0d03aca:	d124      	bne.n	c0d03b16 <divmod256+0x158>
        return (LOWER_P(number1) > LOWER_P(number2));
c0d03acc:	9934      	ldr	r1, [sp, #208]	; 0xd0
c0d03ace:	2001      	movs	r0, #1
c0d03ad0:	2200      	movs	r2, #0
c0d03ad2:	9b04      	ldr	r3, [sp, #16]
c0d03ad4:	4299      	cmp	r1, r3
c0d03ad6:	4601      	mov	r1, r0
c0d03ad8:	d800      	bhi.n	c0d03adc <divmod256+0x11e>
c0d03ada:	4611      	mov	r1, r2
c0d03adc:	9b35      	ldr	r3, [sp, #212]	; 0xd4
c0d03ade:	9f03      	ldr	r7, [sp, #12]
c0d03ae0:	42bb      	cmp	r3, r7
c0d03ae2:	9c02      	ldr	r4, [sp, #8]
c0d03ae4:	9e09      	ldr	r6, [sp, #36]	; 0x24
c0d03ae6:	d800      	bhi.n	c0d03aea <divmod256+0x12c>
c0d03ae8:	4610      	mov	r0, r2
c0d03aea:	42bb      	cmp	r3, r7
c0d03aec:	d000      	beq.n	c0d03af0 <divmod256+0x132>
c0d03aee:	4601      	mov	r1, r0
        copy256(retMod, l);
        clear256(retDiv);
    } else {
        shiftl256(r, diffBits, &copyd);
        shiftl256(&one, diffBits, &adder);
        if (gt256(&copyd, &resMod)) {
c0d03af0:	2900      	cmp	r1, #0
c0d03af2:	e01f      	b.n	c0d03b34 <divmod256+0x176>
c0d03af4:	4291      	cmp	r1, r2
c0d03af6:	9a13      	ldr	r2, [sp, #76]	; 0x4c
c0d03af8:	4611      	mov	r1, r2
c0d03afa:	9b10      	ldr	r3, [sp, #64]	; 0x40
c0d03afc:	d900      	bls.n	c0d03b00 <divmod256+0x142>
c0d03afe:	4619      	mov	r1, r3
c0d03b00:	42a8      	cmp	r0, r5
c0d03b02:	9e09      	ldr	r6, [sp, #36]	; 0x24
c0d03b04:	d900      	bls.n	c0d03b08 <divmod256+0x14a>
c0d03b06:	461a      	mov	r2, r3
c0d03b08:	42a8      	cmp	r0, r5
c0d03b0a:	d000      	beq.n	c0d03b0e <divmod256+0x150>
c0d03b0c:	4611      	mov	r1, r2
c0d03b0e:	2900      	cmp	r1, #0
c0d03b10:	9c02      	ldr	r4, [sp, #8]
c0d03b12:	d011      	beq.n	c0d03b38 <divmod256+0x17a>
c0d03b14:	e01c      	b.n	c0d03b50 <divmod256+0x192>
c0d03b16:	2101      	movs	r1, #1
c0d03b18:	2300      	movs	r3, #0
c0d03b1a:	42b2      	cmp	r2, r6
c0d03b1c:	460a      	mov	r2, r1
c0d03b1e:	d800      	bhi.n	c0d03b22 <divmod256+0x164>
c0d03b20:	461a      	mov	r2, r3
c0d03b22:	42b8      	cmp	r0, r7
c0d03b24:	9c02      	ldr	r4, [sp, #8]
c0d03b26:	9e09      	ldr	r6, [sp, #36]	; 0x24
c0d03b28:	d800      	bhi.n	c0d03b2c <divmod256+0x16e>
c0d03b2a:	4619      	mov	r1, r3
c0d03b2c:	42b8      	cmp	r0, r7
c0d03b2e:	d000      	beq.n	c0d03b32 <divmod256+0x174>
c0d03b30:	460a      	mov	r2, r1
c0d03b32:	2a00      	cmp	r2, #0
c0d03b34:	9f15      	ldr	r7, [sp, #84]	; 0x54
c0d03b36:	d00b      	beq.n	c0d03b50 <divmod256+0x192>
            shiftr256(&copyd, 1, &copyd);
c0d03b38:	2501      	movs	r5, #1
c0d03b3a:	a82e      	add	r0, sp, #184	; 0xb8
c0d03b3c:	4629      	mov	r1, r5
c0d03b3e:	4602      	mov	r2, r0
c0d03b40:	f7ff fd01 	bl	c0d03546 <shiftr256>
c0d03b44:	a826      	add	r0, sp, #152	; 0x98
            shiftr256(&adder, 1, &adder);
c0d03b46:	4629      	mov	r1, r5
c0d03b48:	9f15      	ldr	r7, [sp, #84]	; 0x54
c0d03b4a:	4602      	mov	r2, r0
c0d03b4c:	f7ff fcfb 	bl	c0d03546 <shiftr256>
c0d03b50:	a81e      	add	r0, sp, #120	; 0x78
        }
        while (gte256(&resMod, r)) {
c0d03b52:	4639      	mov	r1, r7
c0d03b54:	f7ff fe08 	bl	c0d03768 <gte256>
c0d03b58:	2700      	movs	r7, #0
c0d03b5a:	2801      	cmp	r0, #1
c0d03b5c:	463d      	mov	r5, r7
c0d03b5e:	463b      	mov	r3, r7
c0d03b60:	4638      	mov	r0, r7
c0d03b62:	463a      	mov	r2, r7
c0d03b64:	4639      	mov	r1, r7
c0d03b66:	9714      	str	r7, [sp, #80]	; 0x50
c0d03b68:	9713      	str	r7, [sp, #76]	; 0x4c
c0d03b6a:	d163      	bne.n	c0d03c34 <divmod256+0x276>
c0d03b6c:	ae26      	add	r6, sp, #152	; 0x98
c0d03b6e:	4630      	mov	r0, r6
c0d03b70:	3018      	adds	r0, #24
c0d03b72:	900b      	str	r0, [sp, #44]	; 0x2c
c0d03b74:	4634      	mov	r4, r6
c0d03b76:	3410      	adds	r4, #16
c0d03b78:	3608      	adds	r6, #8
c0d03b7a:	2000      	movs	r0, #0
c0d03b7c:	9013      	str	r0, [sp, #76]	; 0x4c
c0d03b7e:	9010      	str	r0, [sp, #64]	; 0x40
c0d03b80:	900f      	str	r0, [sp, #60]	; 0x3c
c0d03b82:	900e      	str	r0, [sp, #56]	; 0x38
c0d03b84:	900d      	str	r0, [sp, #52]	; 0x34
c0d03b86:	4607      	mov	r7, r0
c0d03b88:	9014      	str	r0, [sp, #80]	; 0x50
c0d03b8a:	900c      	str	r0, [sp, #48]	; 0x30
c0d03b8c:	a81e      	add	r0, sp, #120	; 0x78
c0d03b8e:	a92e      	add	r1, sp, #184	; 0xb8
            if (gte256(&resMod, &copyd)) {
c0d03b90:	f7ff fdea 	bl	c0d03768 <gte256>
c0d03b94:	2801      	cmp	r0, #1
c0d03b96:	d122      	bne.n	c0d03bde <divmod256+0x220>
c0d03b98:	a92e      	add	r1, sp, #184	; 0xb8
c0d03b9a:	a81e      	add	r0, sp, #120	; 0x78
                minus256(&resMod, &copyd, &resMod);
c0d03b9c:	4602      	mov	r2, r0
c0d03b9e:	f7ff fe15 	bl	c0d037cc <minus256>
c0d03ba2:	990b      	ldr	r1, [sp, #44]	; 0x2c
    minus128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void or128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) = UPPER_P(number1) | UPPER_P(number2);
    LOWER_P(target) = LOWER_P(number1) | LOWER_P(number2);
c0d03ba4:	c903      	ldmia	r1, {r0, r1}
c0d03ba6:	9a13      	ldr	r2, [sp, #76]	; 0x4c
c0d03ba8:	430a      	orrs	r2, r1
c0d03baa:	9213      	str	r2, [sp, #76]	; 0x4c
c0d03bac:	9914      	ldr	r1, [sp, #80]	; 0x50
c0d03bae:	4301      	orrs	r1, r0
    }
    minus128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void or128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) = UPPER_P(number1) | UPPER_P(number2);
c0d03bb0:	9114      	str	r1, [sp, #80]	; 0x50
c0d03bb2:	cc03      	ldmia	r4!, {r0, r1}
c0d03bb4:	9a0f      	ldr	r2, [sp, #60]	; 0x3c
c0d03bb6:	430a      	orrs	r2, r1
c0d03bb8:	920f      	str	r2, [sp, #60]	; 0x3c
c0d03bba:	9910      	ldr	r1, [sp, #64]	; 0x40
c0d03bbc:	4301      	orrs	r1, r0
    LOWER_P(target) = LOWER_P(number1) | LOWER_P(number2);
c0d03bbe:	9110      	str	r1, [sp, #64]	; 0x40
c0d03bc0:	ce03      	ldmia	r6!, {r0, r1}
c0d03bc2:	9a0d      	ldr	r2, [sp, #52]	; 0x34
c0d03bc4:	430a      	orrs	r2, r1
c0d03bc6:	920d      	str	r2, [sp, #52]	; 0x34
c0d03bc8:	990e      	ldr	r1, [sp, #56]	; 0x38
c0d03bca:	4301      	orrs	r1, r0
    }
    minus128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void or128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) = UPPER_P(number1) | UPPER_P(number2);
c0d03bcc:	910e      	str	r1, [sp, #56]	; 0x38
c0d03bce:	9827      	ldr	r0, [sp, #156]	; 0x9c
c0d03bd0:	990c      	ldr	r1, [sp, #48]	; 0x30
c0d03bd2:	4301      	orrs	r1, r0
c0d03bd4:	910c      	str	r1, [sp, #48]	; 0x30
c0d03bd6:	9826      	ldr	r0, [sp, #152]	; 0x98
c0d03bd8:	4307      	orrs	r7, r0
    LOWER_P(target) = LOWER_P(number1) | LOWER_P(number2);
c0d03bda:	3e08      	subs	r6, #8
    }
    minus128(&LOWER_P(number1), &LOWER_P(number2), &LOWER_P(target));
}

void or128(uint128_t *number1, uint128_t *number2, uint128_t *target) {
    UPPER_P(target) = UPPER_P(number1) | UPPER_P(number2);
c0d03bdc:	3c08      	subs	r4, #8
c0d03bde:	2501      	movs	r5, #1
c0d03be0:	a82e      	add	r0, sp, #184	; 0xb8
        while (gte256(&resMod, r)) {
            if (gte256(&resMod, &copyd)) {
                minus256(&resMod, &copyd, &resMod);
                or256(&resDiv, &adder, &resDiv);
            }
            shiftr256(&copyd, 1, &copyd);
c0d03be2:	4629      	mov	r1, r5
c0d03be4:	4602      	mov	r2, r0
c0d03be6:	f7ff fcae 	bl	c0d03546 <shiftr256>
c0d03bea:	a826      	add	r0, sp, #152	; 0x98
            shiftr256(&adder, 1, &adder);
c0d03bec:	4629      	mov	r1, r5
c0d03bee:	4602      	mov	r2, r0
c0d03bf0:	f7ff fca9 	bl	c0d03546 <shiftr256>
c0d03bf4:	a81e      	add	r0, sp, #120	; 0x78
        shiftl256(&one, diffBits, &adder);
        if (gt256(&copyd, &resMod)) {
            shiftr256(&copyd, 1, &copyd);
            shiftr256(&adder, 1, &adder);
        }
        while (gte256(&resMod, r)) {
c0d03bf6:	9915      	ldr	r1, [sp, #84]	; 0x54
c0d03bf8:	f7ff fdb6 	bl	c0d03768 <gte256>
c0d03bfc:	2800      	cmp	r0, #0
c0d03bfe:	9812      	ldr	r0, [sp, #72]	; 0x48
c0d03c00:	9911      	ldr	r1, [sp, #68]	; 0x44
c0d03c02:	d1c3      	bne.n	c0d03b8c <divmod256+0x1ce>
c0d03c04:	6802      	ldr	r2, [r0, #0]
c0d03c06:	9204      	str	r2, [sp, #16]
c0d03c08:	6840      	ldr	r0, [r0, #4]
c0d03c0a:	9003      	str	r0, [sp, #12]
c0d03c0c:	6808      	ldr	r0, [r1, #0]
c0d03c0e:	9006      	str	r0, [sp, #24]
c0d03c10:	6848      	ldr	r0, [r1, #4]
c0d03c12:	9005      	str	r0, [sp, #20]
c0d03c14:	9801      	ldr	r0, [sp, #4]
c0d03c16:	6801      	ldr	r1, [r0, #0]
c0d03c18:	9108      	str	r1, [sp, #32]
c0d03c1a:	6840      	ldr	r0, [r0, #4]
c0d03c1c:	9007      	str	r0, [sp, #28]
c0d03c1e:	981f      	ldr	r0, [sp, #124]	; 0x7c
c0d03c20:	900a      	str	r0, [sp, #40]	; 0x28
c0d03c22:	981e      	ldr	r0, [sp, #120]	; 0x78
c0d03c24:	900b      	str	r0, [sp, #44]	; 0x2c
c0d03c26:	9c02      	ldr	r4, [sp, #8]
c0d03c28:	9e09      	ldr	r6, [sp, #36]	; 0x24
c0d03c2a:	9a10      	ldr	r2, [sp, #64]	; 0x40
c0d03c2c:	990f      	ldr	r1, [sp, #60]	; 0x3c
c0d03c2e:	9b0e      	ldr	r3, [sp, #56]	; 0x38
c0d03c30:	980d      	ldr	r0, [sp, #52]	; 0x34
c0d03c32:	9d0c      	ldr	r5, [sp, #48]	; 0x30
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03c34:	6037      	str	r7, [r6, #0]
c0d03c36:	6075      	str	r5, [r6, #4]
    LOWER_P(target) = LOWER_P(number);
c0d03c38:	60b3      	str	r3, [r6, #8]
c0d03c3a:	60f0      	str	r0, [r6, #12]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03c3c:	6132      	str	r2, [r6, #16]
c0d03c3e:	6171      	str	r1, [r6, #20]
    LOWER_P(target) = LOWER_P(number);
c0d03c40:	9814      	ldr	r0, [sp, #80]	; 0x50
c0d03c42:	61b0      	str	r0, [r6, #24]
c0d03c44:	9813      	ldr	r0, [sp, #76]	; 0x4c
c0d03c46:	61f0      	str	r0, [r6, #28]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03c48:	980b      	ldr	r0, [sp, #44]	; 0x2c
c0d03c4a:	6020      	str	r0, [r4, #0]
c0d03c4c:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d03c4e:	6060      	str	r0, [r4, #4]
    LOWER_P(target) = LOWER_P(number);
c0d03c50:	9808      	ldr	r0, [sp, #32]
c0d03c52:	60a0      	str	r0, [r4, #8]
c0d03c54:	9807      	ldr	r0, [sp, #28]
c0d03c56:	60e0      	str	r0, [r4, #12]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03c58:	9806      	ldr	r0, [sp, #24]
c0d03c5a:	6120      	str	r0, [r4, #16]
c0d03c5c:	9805      	ldr	r0, [sp, #20]
c0d03c5e:	6160      	str	r0, [r4, #20]
    LOWER_P(target) = LOWER_P(number);
c0d03c60:	9804      	ldr	r0, [sp, #16]
c0d03c62:	61a0      	str	r0, [r4, #24]
c0d03c64:	9803      	ldr	r0, [sp, #12]
c0d03c66:	61e0      	str	r0, [r4, #28]
            shiftr256(&adder, 1, &adder);
        }
        copy256(retDiv, &resDiv);
        copy256(retMod, &resMod);
    }
}
c0d03c68:	b037      	add	sp, #220	; 0xdc
c0d03c6a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d03c6c <tostring256>:
    reverseString(out, offset);
    return true;
}

bool tostring256(uint256_t *number, uint32_t baseParam, char *out,
                 uint32_t outLength, uint32_t *realLength) {
c0d03c6c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03c6e:	b0a1      	sub	sp, #132	; 0x84
c0d03c70:	461c      	mov	r4, r3
c0d03c72:	4615      	mov	r5, r2
c0d03c74:	460e      	mov	r6, r1
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03c76:	c806      	ldmia	r0!, {r1, r2}
c0d03c78:	9219      	str	r2, [sp, #100]	; 0x64
c0d03c7a:	9118      	str	r1, [sp, #96]	; 0x60
    LOWER_P(target) = LOWER_P(number);
c0d03c7c:	6801      	ldr	r1, [r0, #0]
c0d03c7e:	6842      	ldr	r2, [r0, #4]
c0d03c80:	921b      	str	r2, [sp, #108]	; 0x6c
c0d03c82:	911a      	str	r1, [sp, #104]	; 0x68
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03c84:	6881      	ldr	r1, [r0, #8]
c0d03c86:	68c2      	ldr	r2, [r0, #12]
c0d03c88:	921d      	str	r2, [sp, #116]	; 0x74
c0d03c8a:	911c      	str	r1, [sp, #112]	; 0x70
    LOWER_P(target) = LOWER_P(number);
c0d03c8c:	6901      	ldr	r1, [r0, #16]
c0d03c8e:	6940      	ldr	r0, [r0, #20]
c0d03c90:	901f      	str	r0, [sp, #124]	; 0x7c
c0d03c92:	911e      	str	r1, [sp, #120]	; 0x78
c0d03c94:	a810      	add	r0, sp, #64	; 0x40
    copy128(&LOWER_P(target), &LOWER_P(number));
}

void clear128(uint128_t *target) {
    UPPER_P(target) = 0;
    LOWER_P(target) = 0;
c0d03c96:	2120      	movs	r1, #32
c0d03c98:	f001 f8f6 	bl	c0d04e88 <__aeabi_memclr>
c0d03c9c:	a808      	add	r0, sp, #32
c0d03c9e:	2118      	movs	r1, #24
    uint256_t rMod;
    uint256_t base;
    copy256(&rDiv, number);
    clear256(&rMod);
    clear256(&base);
    UPPER(LOWER(base)) = 0;
c0d03ca0:	f001 f8f2 	bl	c0d04e88 <__aeabi_memclr>
c0d03ca4:	2000      	movs	r0, #0
    LOWER(LOWER(base)) = baseParam;
c0d03ca6:	900f      	str	r0, [sp, #60]	; 0x3c
c0d03ca8:	a918      	add	r1, sp, #96	; 0x60
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
    LOWER_P(target) = LOWER_P(number);
c0d03caa:	460a      	mov	r2, r1
c0d03cac:	3218      	adds	r2, #24
c0d03cae:	9206      	str	r2, [sp, #24]
bool zero256(uint256_t *number) {
    return (zero128(&LOWER_P(number)) && zero128(&UPPER_P(number)));
}

void copy128(uint128_t *target, uint128_t *number) {
    UPPER_P(target) = UPPER_P(number);
c0d03cb0:	460a      	mov	r2, r1
c0d03cb2:	3210      	adds	r2, #16
c0d03cb4:	9205      	str	r2, [sp, #20]
    LOWER_P(target) = LOWER_P(number);
c0d03cb6:	3108      	adds	r1, #8
c0d03cb8:	9107      	str	r1, [sp, #28]
    uint256_t base;
    copy256(&rDiv, number);
    clear256(&rMod);
    clear256(&base);
    UPPER(LOWER(base)) = 0;
    LOWER(LOWER(base)) = baseParam;
c0d03cba:	960e      	str	r6, [sp, #56]	; 0x38
    uint32_t offset = 0;
    if ((baseParam < 2) || (baseParam > 16)) {
c0d03cbc:	1eb1      	subs	r1, r6, #2
c0d03cbe:	290e      	cmp	r1, #14
c0d03cc0:	d858      	bhi.n	c0d03d74 <tostring256+0x108>
c0d03cc2:	9826      	ldr	r0, [sp, #152]	; 0x98
c0d03cc4:	9001      	str	r0, [sp, #4]
c0d03cc6:	a810      	add	r0, sp, #64	; 0x40
c0d03cc8:	3018      	adds	r0, #24
c0d03cca:	9003      	str	r0, [sp, #12]
c0d03ccc:	1e60      	subs	r0, r4, #1
c0d03cce:	9004      	str	r0, [sp, #16]
c0d03cd0:	2000      	movs	r0, #0
c0d03cd2:	9002      	str	r0, [sp, #8]
c0d03cd4:	4604      	mov	r4, r0
        return false;
    }
    do {
        if (offset > (outLength - 1)) {
c0d03cd6:	9804      	ldr	r0, [sp, #16]
c0d03cd8:	4284      	cmp	r4, r0
c0d03cda:	d84a      	bhi.n	c0d03d72 <tostring256+0x106>
c0d03cdc:	a908      	add	r1, sp, #32
c0d03cde:	a818      	add	r0, sp, #96	; 0x60
c0d03ce0:	ab10      	add	r3, sp, #64	; 0x40
            return false;
        }
        divmod256(&rDiv, &base, &rDiv, &rMod);
c0d03ce2:	4602      	mov	r2, r0
c0d03ce4:	f7ff fe6b 	bl	c0d039be <divmod256>
        out[offset++] = HEXDIGITS[(uint8_t)LOWER(LOWER(rMod))];
c0d03ce8:	9803      	ldr	r0, [sp, #12]
c0d03cea:	7800      	ldrb	r0, [r0, #0]
c0d03cec:	4922      	ldr	r1, [pc, #136]	; (c0d03d78 <tostring256+0x10c>)
c0d03cee:	4479      	add	r1, pc
c0d03cf0:	5c09      	ldrb	r1, [r1, r0]
c0d03cf2:	5529      	strb	r1, [r5, r4]
c0d03cf4:	9806      	ldr	r0, [sp, #24]
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d03cf6:	c80c      	ldmia	r0!, {r2, r3}
c0d03cf8:	9f05      	ldr	r7, [sp, #20]
c0d03cfa:	6838      	ldr	r0, [r7, #0]
c0d03cfc:	462e      	mov	r6, r5
c0d03cfe:	687d      	ldr	r5, [r7, #4]
c0d03d00:	431d      	orrs	r5, r3
c0d03d02:	9f07      	ldr	r7, [sp, #28]
c0d03d04:	cf88      	ldmia	r7, {r3, r7}
c0d03d06:	432f      	orrs	r7, r5
c0d03d08:	9d19      	ldr	r5, [sp, #100]	; 0x64
c0d03d0a:	433d      	orrs	r5, r7
c0d03d0c:	4310      	orrs	r0, r2
c0d03d0e:	4318      	orrs	r0, r3
c0d03d10:	9a18      	ldr	r2, [sp, #96]	; 0x60
c0d03d12:	4302      	orrs	r2, r0
c0d03d14:	432a      	orrs	r2, r5
c0d03d16:	4635      	mov	r5, r6
    do {
        if (offset > (outLength - 1)) {
            return false;
        }
        divmod256(&rDiv, &base, &rDiv, &rMod);
        out[offset++] = HEXDIGITS[(uint8_t)LOWER(LOWER(rMod))];
c0d03d18:	1c60      	adds	r0, r4, #1
    readu128BE(buffer, &UPPER_P(target));
    readu128BE(buffer + 16, &LOWER_P(target));
}

bool zero128(uint128_t *number) {
    return ((LOWER_P(number) == 0) && (UPPER_P(number) == 0));
c0d03d1a:	2a00      	cmp	r2, #0
c0d03d1c:	d1da      	bne.n	c0d03cd4 <tostring256+0x68>
c0d03d1e:	2200      	movs	r2, #0
            return false;
        }
        divmod256(&rDiv, &base, &rDiv, &rMod);
        out[offset++] = HEXDIGITS[(uint8_t)LOWER(LOWER(rMod))];
    } while (!zero256(&rDiv));
    out[offset] = '\0';
c0d03d20:	542a      	strb	r2, [r5, r0]
    }
}

static void reverseString(char *str, uint32_t length) {
    uint32_t i, j;
    for (i = 0, j = length - 1; i < j; i++, j--) {
c0d03d22:	2c00      	cmp	r4, #0
c0d03d24:	9506      	str	r5, [sp, #24]
c0d03d26:	d020      	beq.n	c0d03d6a <tostring256+0xfe>
c0d03d28:	9d06      	ldr	r5, [sp, #24]
        uint8_t c;
        c = str[i];
c0d03d2a:	782b      	ldrb	r3, [r5, #0]
        str[i] = str[j];
c0d03d2c:	7029      	strb	r1, [r5, #0]
        str[j] = c;
c0d03d2e:	552b      	strb	r3, [r5, r4]
c0d03d30:	1e61      	subs	r1, r4, #1
    }
}

static void reverseString(char *str, uint32_t length) {
    uint32_t i, j;
    for (i = 0, j = length - 1; i < j; i++, j--) {
c0d03d32:	2902      	cmp	r1, #2
c0d03d34:	d319      	bcc.n	c0d03d6a <tostring256+0xfe>
c0d03d36:	9906      	ldr	r1, [sp, #24]
c0d03d38:	1809      	adds	r1, r1, r0
c0d03d3a:	9105      	str	r1, [sp, #20]
c0d03d3c:	43d3      	mvns	r3, r2
c0d03d3e:	2402      	movs	r4, #2
c0d03d40:	9304      	str	r3, [sp, #16]
c0d03d42:	9e06      	ldr	r6, [sp, #24]
c0d03d44:	9904      	ldr	r1, [sp, #16]
        uint8_t c;
        c = str[i];
c0d03d46:	460d      	mov	r5, r1
c0d03d48:	435d      	muls	r5, r3
c0d03d4a:	5d72      	ldrb	r2, [r6, r5]
c0d03d4c:	9207      	str	r2, [sp, #28]
c0d03d4e:	460f      	mov	r7, r1
c0d03d50:	4367      	muls	r7, r4
c0d03d52:	9a05      	ldr	r2, [sp, #20]
c0d03d54:	5dd1      	ldrb	r1, [r2, r7]
        str[i] = str[j];
c0d03d56:	5571      	strb	r1, [r6, r5]
        str[j] = c;
c0d03d58:	9907      	ldr	r1, [sp, #28]
c0d03d5a:	55d1      	strb	r1, [r2, r7]
    }
}

static void reverseString(char *str, uint32_t length) {
    uint32_t i, j;
    for (i = 0, j = length - 1; i < j; i++, j--) {
c0d03d5c:	1e5b      	subs	r3, r3, #1
c0d03d5e:	18c1      	adds	r1, r0, r3
c0d03d60:	1e49      	subs	r1, r1, #1
c0d03d62:	1c65      	adds	r5, r4, #1
c0d03d64:	428c      	cmp	r4, r1
c0d03d66:	462c      	mov	r4, r5
c0d03d68:	d3ec      	bcc.n	c0d03d44 <tostring256+0xd8>
        divmod256(&rDiv, &base, &rDiv, &rMod);
        out[offset++] = HEXDIGITS[(uint8_t)LOWER(LOWER(rMod))];
    } while (!zero256(&rDiv));
    out[offset] = '\0';
    reverseString(out, offset);
    *realLength = offset;
c0d03d6a:	9901      	ldr	r1, [sp, #4]
c0d03d6c:	6008      	str	r0, [r1, #0]
c0d03d6e:	2001      	movs	r0, #1
c0d03d70:	e000      	b.n	c0d03d74 <tostring256+0x108>
c0d03d72:	9802      	ldr	r0, [sp, #8]
    return true;
}
c0d03d74:	b021      	add	sp, #132	; 0x84
c0d03d76:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03d78:	00001f0a 	.word	0x00001f0a

c0d03d7c <USBD_LL_Init>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
  UNUSED(pdev);
  ep_in_stall = 0;
c0d03d7c:	4902      	ldr	r1, [pc, #8]	; (c0d03d88 <USBD_LL_Init+0xc>)
c0d03d7e:	2000      	movs	r0, #0
c0d03d80:	6008      	str	r0, [r1, #0]
  ep_out_stall = 0;
c0d03d82:	4902      	ldr	r1, [pc, #8]	; (c0d03d8c <USBD_LL_Init+0x10>)
c0d03d84:	6008      	str	r0, [r1, #0]
  return USBD_OK;
c0d03d86:	4770      	bx	lr
c0d03d88:	20001f30 	.word	0x20001f30
c0d03d8c:	20001f34 	.word	0x20001f34

c0d03d90 <USBD_LL_DeInit>:
  * @brief  De-Initializes the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
c0d03d90:	b510      	push	{r4, lr}
  UNUSED(pdev);
  // usb off
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03d92:	4807      	ldr	r0, [pc, #28]	; (c0d03db0 <USBD_LL_DeInit+0x20>)
c0d03d94:	214f      	movs	r1, #79	; 0x4f
c0d03d96:	7001      	strb	r1, [r0, #0]
c0d03d98:	2400      	movs	r4, #0
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d03d9a:	7044      	strb	r4, [r0, #1]
c0d03d9c:	2101      	movs	r1, #1
  G_io_seproxyhal_spi_buffer[2] = 1;
c0d03d9e:	7081      	strb	r1, [r0, #2]
c0d03da0:	2102      	movs	r1, #2
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d03da2:	70c1      	strb	r1, [r0, #3]
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 4);
c0d03da4:	2104      	movs	r1, #4
c0d03da6:	f7ff f9b1 	bl	c0d0310c <io_seproxyhal_spi_send>

  return USBD_OK; 
c0d03daa:	4620      	mov	r0, r4
c0d03dac:	bd10      	pop	{r4, pc}
c0d03dae:	46c0      	nop			; (mov r8, r8)
c0d03db0:	20001800 	.word	0x20001800

c0d03db4 <USBD_LL_Start>:
  * @brief  Starts the Low Level portion of the Device driver. 
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Start(USBD_HandleTypeDef *pdev)
{
c0d03db4:	b570      	push	{r4, r5, r6, lr}
c0d03db6:	b082      	sub	sp, #8
c0d03db8:	466d      	mov	r5, sp
  uint8_t buffer[5];
  UNUSED(pdev);

  // reset address
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03dba:	264f      	movs	r6, #79	; 0x4f
c0d03dbc:	702e      	strb	r6, [r5, #0]
c0d03dbe:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03dc0:	706c      	strb	r4, [r5, #1]
c0d03dc2:	2002      	movs	r0, #2
  buffer[2] = 2;
c0d03dc4:	70a8      	strb	r0, [r5, #2]
c0d03dc6:	2003      	movs	r0, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d03dc8:	70e8      	strb	r0, [r5, #3]
  buffer[4] = 0;
c0d03dca:	712c      	strb	r4, [r5, #4]
  io_seproxyhal_spi_send(buffer, 5);
c0d03dcc:	2105      	movs	r1, #5
c0d03dce:	4628      	mov	r0, r5
c0d03dd0:	f7ff f99c 	bl	c0d0310c <io_seproxyhal_spi_send>
  
  // start usb operation
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03dd4:	702e      	strb	r6, [r5, #0]
  buffer[1] = 0;
c0d03dd6:	706c      	strb	r4, [r5, #1]
c0d03dd8:	2001      	movs	r0, #1
  buffer[2] = 1;
c0d03dda:	70a8      	strb	r0, [r5, #2]
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_CONNECT;
c0d03ddc:	70e8      	strb	r0, [r5, #3]
c0d03dde:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(buffer, 4);
c0d03de0:	4628      	mov	r0, r5
c0d03de2:	f7ff f993 	bl	c0d0310c <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03de6:	4620      	mov	r0, r4
c0d03de8:	b002      	add	sp, #8
c0d03dea:	bd70      	pop	{r4, r5, r6, pc}

c0d03dec <USBD_LL_Stop>:
  * @brief  Stops the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
c0d03dec:	b510      	push	{r4, lr}
c0d03dee:	b082      	sub	sp, #8
c0d03df0:	a801      	add	r0, sp, #4
  UNUSED(pdev);
  uint8_t buffer[4];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03df2:	214f      	movs	r1, #79	; 0x4f
c0d03df4:	7001      	strb	r1, [r0, #0]
c0d03df6:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03df8:	7044      	strb	r4, [r0, #1]
c0d03dfa:	2101      	movs	r1, #1
  buffer[2] = 1;
c0d03dfc:	7081      	strb	r1, [r0, #2]
c0d03dfe:	2102      	movs	r1, #2
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d03e00:	70c1      	strb	r1, [r0, #3]
  io_seproxyhal_spi_send(buffer, 4);
c0d03e02:	2104      	movs	r1, #4
c0d03e04:	f7ff f982 	bl	c0d0310c <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03e08:	4620      	mov	r0, r4
c0d03e0a:	b002      	add	sp, #8
c0d03e0c:	bd10      	pop	{r4, pc}
	...

c0d03e10 <USBD_LL_OpenEP>:
  */
USBD_StatusTypeDef  USBD_LL_OpenEP  (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  ep_type,
                                      uint16_t ep_mps)
{
c0d03e10:	b5b0      	push	{r4, r5, r7, lr}
c0d03e12:	b082      	sub	sp, #8
  uint8_t buffer[8];
  UNUSED(pdev);

  ep_in_stall = 0;
c0d03e14:	480e      	ldr	r0, [pc, #56]	; (c0d03e50 <USBD_LL_OpenEP+0x40>)
c0d03e16:	2400      	movs	r4, #0
c0d03e18:	6004      	str	r4, [r0, #0]
  ep_out_stall = 0;
c0d03e1a:	480e      	ldr	r0, [pc, #56]	; (c0d03e54 <USBD_LL_OpenEP+0x44>)
c0d03e1c:	6004      	str	r4, [r0, #0]
c0d03e1e:	4668      	mov	r0, sp

  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03e20:	254f      	movs	r5, #79	; 0x4f
c0d03e22:	7005      	strb	r5, [r0, #0]
  buffer[1] = 0;
c0d03e24:	7044      	strb	r4, [r0, #1]
c0d03e26:	2505      	movs	r5, #5
  buffer[2] = 5;
c0d03e28:	7085      	strb	r5, [r0, #2]
c0d03e2a:	2504      	movs	r5, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d03e2c:	70c5      	strb	r5, [r0, #3]
c0d03e2e:	2501      	movs	r5, #1
  buffer[4] = 1;
c0d03e30:	7105      	strb	r5, [r0, #4]
  buffer[5] = ep_addr;
c0d03e32:	7141      	strb	r1, [r0, #5]
  buffer[6] = 0;
  switch(ep_type) {
c0d03e34:	2a03      	cmp	r2, #3
c0d03e36:	d802      	bhi.n	c0d03e3e <USBD_LL_OpenEP+0x2e>
c0d03e38:	00d0      	lsls	r0, r2, #3
c0d03e3a:	4c07      	ldr	r4, [pc, #28]	; (c0d03e58 <USBD_LL_OpenEP+0x48>)
c0d03e3c:	40c4      	lsrs	r4, r0
c0d03e3e:	4668      	mov	r0, sp
  buffer[1] = 0;
  buffer[2] = 5;
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
  buffer[4] = 1;
  buffer[5] = ep_addr;
  buffer[6] = 0;
c0d03e40:	7184      	strb	r4, [r0, #6]
      break;
    case USBD_EP_TYPE_INTR:
      buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_INTERRUPT;
      break;
  }
  buffer[7] = ep_mps;
c0d03e42:	71c3      	strb	r3, [r0, #7]
  io_seproxyhal_spi_send(buffer, 8);
c0d03e44:	2108      	movs	r1, #8
c0d03e46:	f7ff f961 	bl	c0d0310c <io_seproxyhal_spi_send>
c0d03e4a:	2000      	movs	r0, #0
  return USBD_OK; 
c0d03e4c:	b002      	add	sp, #8
c0d03e4e:	bdb0      	pop	{r4, r5, r7, pc}
c0d03e50:	20001f30 	.word	0x20001f30
c0d03e54:	20001f34 	.word	0x20001f34
c0d03e58:	02030401 	.word	0x02030401

c0d03e5c <USBD_LL_CloseEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d03e5c:	b510      	push	{r4, lr}
c0d03e5e:	b082      	sub	sp, #8
c0d03e60:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[8];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03e62:	224f      	movs	r2, #79	; 0x4f
c0d03e64:	7002      	strb	r2, [r0, #0]
c0d03e66:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03e68:	7044      	strb	r4, [r0, #1]
c0d03e6a:	2205      	movs	r2, #5
  buffer[2] = 5;
c0d03e6c:	7082      	strb	r2, [r0, #2]
c0d03e6e:	2204      	movs	r2, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d03e70:	70c2      	strb	r2, [r0, #3]
c0d03e72:	2201      	movs	r2, #1
  buffer[4] = 1;
c0d03e74:	7102      	strb	r2, [r0, #4]
  buffer[5] = ep_addr;
c0d03e76:	7141      	strb	r1, [r0, #5]
  buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_DISABLED;
c0d03e78:	7184      	strb	r4, [r0, #6]
  buffer[7] = 0;
c0d03e7a:	71c4      	strb	r4, [r0, #7]
  io_seproxyhal_spi_send(buffer, 8);
c0d03e7c:	2108      	movs	r1, #8
c0d03e7e:	f7ff f945 	bl	c0d0310c <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03e82:	4620      	mov	r0, r4
c0d03e84:	b002      	add	sp, #8
c0d03e86:	bd10      	pop	{r4, pc}

c0d03e88 <USBD_LL_StallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{ 
c0d03e88:	b5b0      	push	{r4, r5, r7, lr}
c0d03e8a:	b082      	sub	sp, #8
c0d03e8c:	460d      	mov	r5, r1
c0d03e8e:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03e90:	2150      	movs	r1, #80	; 0x50
c0d03e92:	7001      	strb	r1, [r0, #0]
c0d03e94:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03e96:	7044      	strb	r4, [r0, #1]
c0d03e98:	2103      	movs	r1, #3
  buffer[2] = 3;
c0d03e9a:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d03e9c:	70c5      	strb	r5, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_STALL;
c0d03e9e:	2140      	movs	r1, #64	; 0x40
c0d03ea0:	7101      	strb	r1, [r0, #4]
  buffer[5] = 0;
c0d03ea2:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03ea4:	2106      	movs	r1, #6
c0d03ea6:	f7ff f931 	bl	c0d0310c <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d03eaa:	2080      	movs	r0, #128	; 0x80
c0d03eac:	4205      	tst	r5, r0
c0d03eae:	d101      	bne.n	c0d03eb4 <USBD_LL_StallEP+0x2c>
c0d03eb0:	4807      	ldr	r0, [pc, #28]	; (c0d03ed0 <USBD_LL_StallEP+0x48>)
c0d03eb2:	e000      	b.n	c0d03eb6 <USBD_LL_StallEP+0x2e>
c0d03eb4:	4805      	ldr	r0, [pc, #20]	; (c0d03ecc <USBD_LL_StallEP+0x44>)
c0d03eb6:	6801      	ldr	r1, [r0, #0]
c0d03eb8:	227f      	movs	r2, #127	; 0x7f
c0d03eba:	4015      	ands	r5, r2
c0d03ebc:	2201      	movs	r2, #1
c0d03ebe:	40aa      	lsls	r2, r5
c0d03ec0:	430a      	orrs	r2, r1
c0d03ec2:	6002      	str	r2, [r0, #0]
    ep_in_stall |= (1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall |= (1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d03ec4:	4620      	mov	r0, r4
c0d03ec6:	b002      	add	sp, #8
c0d03ec8:	bdb0      	pop	{r4, r5, r7, pc}
c0d03eca:	46c0      	nop			; (mov r8, r8)
c0d03ecc:	20001f30 	.word	0x20001f30
c0d03ed0:	20001f34 	.word	0x20001f34

c0d03ed4 <USBD_LL_ClearStallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d03ed4:	b570      	push	{r4, r5, r6, lr}
c0d03ed6:	b082      	sub	sp, #8
c0d03ed8:	460d      	mov	r5, r1
c0d03eda:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03edc:	2150      	movs	r1, #80	; 0x50
c0d03ede:	7001      	strb	r1, [r0, #0]
c0d03ee0:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03ee2:	7044      	strb	r4, [r0, #1]
c0d03ee4:	2103      	movs	r1, #3
  buffer[2] = 3;
c0d03ee6:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d03ee8:	70c5      	strb	r5, [r0, #3]
c0d03eea:	2680      	movs	r6, #128	; 0x80
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_UNSTALL;
c0d03eec:	7106      	strb	r6, [r0, #4]
  buffer[5] = 0;
c0d03eee:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03ef0:	2106      	movs	r1, #6
c0d03ef2:	f7ff f90b 	bl	c0d0310c <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d03ef6:	4235      	tst	r5, r6
c0d03ef8:	d101      	bne.n	c0d03efe <USBD_LL_ClearStallEP+0x2a>
c0d03efa:	4807      	ldr	r0, [pc, #28]	; (c0d03f18 <USBD_LL_ClearStallEP+0x44>)
c0d03efc:	e000      	b.n	c0d03f00 <USBD_LL_ClearStallEP+0x2c>
c0d03efe:	4805      	ldr	r0, [pc, #20]	; (c0d03f14 <USBD_LL_ClearStallEP+0x40>)
c0d03f00:	6801      	ldr	r1, [r0, #0]
c0d03f02:	227f      	movs	r2, #127	; 0x7f
c0d03f04:	4015      	ands	r5, r2
c0d03f06:	2201      	movs	r2, #1
c0d03f08:	40aa      	lsls	r2, r5
c0d03f0a:	4391      	bics	r1, r2
c0d03f0c:	6001      	str	r1, [r0, #0]
    ep_in_stall &= ~(1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall &= ~(1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d03f0e:	4620      	mov	r0, r4
c0d03f10:	b002      	add	sp, #8
c0d03f12:	bd70      	pop	{r4, r5, r6, pc}
c0d03f14:	20001f30 	.word	0x20001f30
c0d03f18:	20001f34 	.word	0x20001f34

c0d03f1c <USBD_LL_IsStallEP>:
  * @retval Stall (1: Yes, 0: No)
  */
uint8_t USBD_LL_IsStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  UNUSED(pdev);
  if((ep_addr & 0x80) == 0x80)
c0d03f1c:	2080      	movs	r0, #128	; 0x80
c0d03f1e:	4201      	tst	r1, r0
c0d03f20:	d001      	beq.n	c0d03f26 <USBD_LL_IsStallEP+0xa>
c0d03f22:	4806      	ldr	r0, [pc, #24]	; (c0d03f3c <USBD_LL_IsStallEP+0x20>)
c0d03f24:	e000      	b.n	c0d03f28 <USBD_LL_IsStallEP+0xc>
c0d03f26:	4804      	ldr	r0, [pc, #16]	; (c0d03f38 <USBD_LL_IsStallEP+0x1c>)
c0d03f28:	6800      	ldr	r0, [r0, #0]
c0d03f2a:	227f      	movs	r2, #127	; 0x7f
c0d03f2c:	4011      	ands	r1, r2
c0d03f2e:	2201      	movs	r2, #1
c0d03f30:	408a      	lsls	r2, r1
c0d03f32:	4002      	ands	r2, r0
  }
  else
  {
    return ep_out_stall & (1<<(ep_addr&0x7F));
  }
}
c0d03f34:	b2d0      	uxtb	r0, r2
c0d03f36:	4770      	bx	lr
c0d03f38:	20001f34 	.word	0x20001f34
c0d03f3c:	20001f30 	.word	0x20001f30

c0d03f40 <USBD_LL_SetUSBAddress>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
c0d03f40:	b510      	push	{r4, lr}
c0d03f42:	b082      	sub	sp, #8
c0d03f44:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[5];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d03f46:	224f      	movs	r2, #79	; 0x4f
c0d03f48:	7002      	strb	r2, [r0, #0]
c0d03f4a:	2400      	movs	r4, #0
  buffer[1] = 0;
c0d03f4c:	7044      	strb	r4, [r0, #1]
c0d03f4e:	2202      	movs	r2, #2
  buffer[2] = 2;
c0d03f50:	7082      	strb	r2, [r0, #2]
c0d03f52:	2203      	movs	r2, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d03f54:	70c2      	strb	r2, [r0, #3]
  buffer[4] = dev_addr;
c0d03f56:	7101      	strb	r1, [r0, #4]
  io_seproxyhal_spi_send(buffer, 5);
c0d03f58:	2105      	movs	r1, #5
c0d03f5a:	f7ff f8d7 	bl	c0d0310c <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d03f5e:	4620      	mov	r0, r4
c0d03f60:	b002      	add	sp, #8
c0d03f62:	bd10      	pop	{r4, pc}

c0d03f64 <USBD_LL_Transmit>:
  */
USBD_StatusTypeDef  USBD_LL_Transmit (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  *pbuf,
                                      uint16_t  size)
{
c0d03f64:	b5b0      	push	{r4, r5, r7, lr}
c0d03f66:	b082      	sub	sp, #8
c0d03f68:	461c      	mov	r4, r3
c0d03f6a:	4615      	mov	r5, r2
c0d03f6c:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03f6e:	2250      	movs	r2, #80	; 0x50
c0d03f70:	7002      	strb	r2, [r0, #0]
  buffer[1] = (3+size)>>8;
c0d03f72:	1ce2      	adds	r2, r4, #3
c0d03f74:	0a13      	lsrs	r3, r2, #8
c0d03f76:	7043      	strb	r3, [r0, #1]
  buffer[2] = (3+size);
c0d03f78:	7082      	strb	r2, [r0, #2]
  buffer[3] = ep_addr;
c0d03f7a:	70c1      	strb	r1, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d03f7c:	2120      	movs	r1, #32
c0d03f7e:	7101      	strb	r1, [r0, #4]
  buffer[5] = size;
c0d03f80:	7144      	strb	r4, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03f82:	2106      	movs	r1, #6
c0d03f84:	f7ff f8c2 	bl	c0d0310c <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(pbuf, size);
c0d03f88:	4628      	mov	r0, r5
c0d03f8a:	4621      	mov	r1, r4
c0d03f8c:	f7ff f8be 	bl	c0d0310c <io_seproxyhal_spi_send>
c0d03f90:	2000      	movs	r0, #0
  return USBD_OK;   
c0d03f92:	b002      	add	sp, #8
c0d03f94:	bdb0      	pop	{r4, r5, r7, pc}

c0d03f96 <USBD_LL_PrepareReceive>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_PrepareReceive(USBD_HandleTypeDef *pdev, 
                                           uint8_t  ep_addr,
                                           uint16_t  size)
{
c0d03f96:	b510      	push	{r4, lr}
c0d03f98:	b082      	sub	sp, #8
c0d03f9a:	4668      	mov	r0, sp
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03f9c:	2350      	movs	r3, #80	; 0x50
c0d03f9e:	7003      	strb	r3, [r0, #0]
c0d03fa0:	2400      	movs	r4, #0
  buffer[1] = (3/*+size*/)>>8;
c0d03fa2:	7044      	strb	r4, [r0, #1]
c0d03fa4:	2303      	movs	r3, #3
  buffer[2] = (3/*+size*/);
c0d03fa6:	7083      	strb	r3, [r0, #2]
  buffer[3] = ep_addr;
c0d03fa8:	70c1      	strb	r1, [r0, #3]
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_OUT;
c0d03faa:	2130      	movs	r1, #48	; 0x30
c0d03fac:	7101      	strb	r1, [r0, #4]
  buffer[5] = size; // expected size, not transmitted here !
c0d03fae:	7142      	strb	r2, [r0, #5]
  io_seproxyhal_spi_send(buffer, 6);
c0d03fb0:	2106      	movs	r1, #6
c0d03fb2:	f7ff f8ab 	bl	c0d0310c <io_seproxyhal_spi_send>
  return USBD_OK;   
c0d03fb6:	4620      	mov	r0, r4
c0d03fb8:	b002      	add	sp, #8
c0d03fba:	bd10      	pop	{r4, pc}

c0d03fbc <USBD_Init>:
* @param  pdesc: Descriptor structure address
* @param  id: Low level core index
* @retval None
*/
USBD_StatusTypeDef USBD_Init(USBD_HandleTypeDef *pdev, USBD_DescriptorsTypeDef *pdesc, uint8_t id)
{
c0d03fbc:	b570      	push	{r4, r5, r6, lr}
c0d03fbe:	4615      	mov	r5, r2
c0d03fc0:	460e      	mov	r6, r1
c0d03fc2:	4604      	mov	r4, r0
c0d03fc4:	2002      	movs	r0, #2
  /* Check whether the USB Host handle is valid */
  if(pdev == NULL)
c0d03fc6:	2c00      	cmp	r4, #0
c0d03fc8:	d011      	beq.n	c0d03fee <USBD_Init+0x32>
  {
    USBD_ErrLog("Invalid Device handle");
    return USBD_FAIL; 
  }

  memset(pdev, 0, sizeof(USBD_HandleTypeDef));
c0d03fca:	204d      	movs	r0, #77	; 0x4d
c0d03fcc:	0081      	lsls	r1, r0, #2
c0d03fce:	4620      	mov	r0, r4
c0d03fd0:	f000 ff5a 	bl	c0d04e88 <__aeabi_memclr>
  
  /* Assign USBD Descriptors */
  if(pdesc != NULL)
c0d03fd4:	2e00      	cmp	r6, #0
c0d03fd6:	d002      	beq.n	c0d03fde <USBD_Init+0x22>
  {
    pdev->pDesc = pdesc;
c0d03fd8:	2011      	movs	r0, #17
c0d03fda:	0100      	lsls	r0, r0, #4
c0d03fdc:	5026      	str	r6, [r4, r0]
  }
  
  /* Set Device initial State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d03fde:	20fc      	movs	r0, #252	; 0xfc
c0d03fe0:	2101      	movs	r1, #1
c0d03fe2:	5421      	strb	r1, [r4, r0]
  pdev->id = id;
c0d03fe4:	7025      	strb	r5, [r4, #0]
  /* Initialize low level driver */
  USBD_LL_Init(pdev);
c0d03fe6:	4620      	mov	r0, r4
c0d03fe8:	f7ff fec8 	bl	c0d03d7c <USBD_LL_Init>
c0d03fec:	2000      	movs	r0, #0
  
  return USBD_OK; 
}
c0d03fee:	b2c0      	uxtb	r0, r0
c0d03ff0:	bd70      	pop	{r4, r5, r6, pc}

c0d03ff2 <USBD_DeInit>:
*         Re-Initialize th device library
* @param  pdev: device instance
* @retval status: status
*/
USBD_StatusTypeDef USBD_DeInit(USBD_HandleTypeDef *pdev)
{
c0d03ff2:	b570      	push	{r4, r5, r6, lr}
c0d03ff4:	4604      	mov	r4, r0
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d03ff6:	20fc      	movs	r0, #252	; 0xfc
c0d03ff8:	2101      	movs	r1, #1
c0d03ffa:	5421      	strb	r1, [r4, r0]
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d03ffc:	2045      	movs	r0, #69	; 0x45
c0d03ffe:	0080      	lsls	r0, r0, #2
c0d04000:	1825      	adds	r5, r4, r0
c0d04002:	2600      	movs	r6, #0
    if(pdev->interfacesClass[intf].pClass != NULL) {
c0d04004:	00f0      	lsls	r0, r6, #3
c0d04006:	5828      	ldr	r0, [r5, r0]
c0d04008:	2800      	cmp	r0, #0
c0d0400a:	d006      	beq.n	c0d0401a <USBD_DeInit+0x28>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
c0d0400c:	6840      	ldr	r0, [r0, #4]
c0d0400e:	f7fe fcbf 	bl	c0d02990 <pic>
c0d04012:	4602      	mov	r2, r0
c0d04014:	7921      	ldrb	r1, [r4, #4]
c0d04016:	4620      	mov	r0, r4
c0d04018:	4790      	blx	r2
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0401a:	1c76      	adds	r6, r6, #1
c0d0401c:	2e03      	cmp	r6, #3
c0d0401e:	d1f1      	bne.n	c0d04004 <USBD_DeInit+0x12>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
    }
  }
  
    /* Stop the low level driver  */
  USBD_LL_Stop(pdev); 
c0d04020:	4620      	mov	r0, r4
c0d04022:	f7ff fee3 	bl	c0d03dec <USBD_LL_Stop>
  
  /* Initialize low level driver */
  USBD_LL_DeInit(pdev);
c0d04026:	4620      	mov	r0, r4
c0d04028:	f7ff feb2 	bl	c0d03d90 <USBD_LL_DeInit>
  
  return USBD_OK;
c0d0402c:	2000      	movs	r0, #0
c0d0402e:	bd70      	pop	{r4, r5, r6, pc}

c0d04030 <USBD_RegisterClassForInterface>:
  * @param  pDevice : Device Handle
  * @param  pclass: Class handle
  * @retval USBD Status
  */
USBD_StatusTypeDef USBD_RegisterClassForInterface(uint8_t interfaceidx, USBD_HandleTypeDef *pdev, USBD_ClassTypeDef *pclass)
{
c0d04030:	2302      	movs	r3, #2
  USBD_StatusTypeDef   status = USBD_OK;
  if(pclass != 0)
c0d04032:	2a00      	cmp	r2, #0
c0d04034:	d007      	beq.n	c0d04046 <USBD_RegisterClassForInterface+0x16>
c0d04036:	2300      	movs	r3, #0
  {
    if (interfaceidx < USBD_MAX_NUM_INTERFACES) {
c0d04038:	2802      	cmp	r0, #2
c0d0403a:	d804      	bhi.n	c0d04046 <USBD_RegisterClassForInterface+0x16>
      /* link the class to the USB Device handle */
      pdev->interfacesClass[interfaceidx].pClass = pclass;
c0d0403c:	00c0      	lsls	r0, r0, #3
c0d0403e:	1808      	adds	r0, r1, r0
c0d04040:	2145      	movs	r1, #69	; 0x45
c0d04042:	0089      	lsls	r1, r1, #2
c0d04044:	5042      	str	r2, [r0, r1]
  {
    USBD_ErrLog("Invalid Class handle");
    status = USBD_FAIL; 
  }
  
  return status;
c0d04046:	b2d8      	uxtb	r0, r3
c0d04048:	4770      	bx	lr

c0d0404a <USBD_Start>:
  *         Start the USB Device Core.
  * @param  pdev: Device Handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_Start  (USBD_HandleTypeDef *pdev)
{
c0d0404a:	b580      	push	{r7, lr}
  
  /* Start the low level driver  */
  USBD_LL_Start(pdev); 
c0d0404c:	f7ff feb2 	bl	c0d03db4 <USBD_LL_Start>
  
  return USBD_OK;  
c0d04050:	2000      	movs	r0, #0
c0d04052:	bd80      	pop	{r7, pc}

c0d04054 <USBD_SetClassConfig>:
* @param  cfgidx: configuration index
* @retval status
*/

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d04054:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04056:	b081      	sub	sp, #4
c0d04058:	460c      	mov	r4, r1
c0d0405a:	4605      	mov	r5, r0
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0405c:	2045      	movs	r0, #69	; 0x45
c0d0405e:	0080      	lsls	r0, r0, #2
c0d04060:	182f      	adds	r7, r5, r0
c0d04062:	2600      	movs	r6, #0
    if(usbd_is_valid_intf(pdev, intf)) {
c0d04064:	4628      	mov	r0, r5
c0d04066:	4631      	mov	r1, r6
c0d04068:	f000 f97c 	bl	c0d04364 <usbd_is_valid_intf>
c0d0406c:	2800      	cmp	r0, #0
c0d0406e:	d008      	beq.n	c0d04082 <USBD_SetClassConfig+0x2e>
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
c0d04070:	00f0      	lsls	r0, r6, #3
c0d04072:	5838      	ldr	r0, [r7, r0]
c0d04074:	6800      	ldr	r0, [r0, #0]
c0d04076:	f7fe fc8b 	bl	c0d02990 <pic>
c0d0407a:	4602      	mov	r2, r0
c0d0407c:	4628      	mov	r0, r5
c0d0407e:	4621      	mov	r1, r4
c0d04080:	4790      	blx	r2

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d04082:	1c76      	adds	r6, r6, #1
c0d04084:	2e03      	cmp	r6, #3
c0d04086:	d1ed      	bne.n	c0d04064 <USBD_SetClassConfig+0x10>
    if(usbd_is_valid_intf(pdev, intf)) {
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
    }
  }

  return USBD_OK; 
c0d04088:	2000      	movs	r0, #0
c0d0408a:	b001      	add	sp, #4
c0d0408c:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0408e <USBD_ClrClassConfig>:
* @param  pdev: device instance
* @param  cfgidx: configuration index
* @retval status: USBD_StatusTypeDef
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d0408e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04090:	b081      	sub	sp, #4
c0d04092:	460c      	mov	r4, r1
c0d04094:	4605      	mov	r5, r0
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d04096:	2045      	movs	r0, #69	; 0x45
c0d04098:	0080      	lsls	r0, r0, #2
c0d0409a:	182f      	adds	r7, r5, r0
c0d0409c:	2600      	movs	r6, #0
    if(usbd_is_valid_intf(pdev, intf)) {
c0d0409e:	4628      	mov	r0, r5
c0d040a0:	4631      	mov	r1, r6
c0d040a2:	f000 f95f 	bl	c0d04364 <usbd_is_valid_intf>
c0d040a6:	2800      	cmp	r0, #0
c0d040a8:	d008      	beq.n	c0d040bc <USBD_ClrClassConfig+0x2e>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
c0d040aa:	00f0      	lsls	r0, r6, #3
c0d040ac:	5838      	ldr	r0, [r7, r0]
c0d040ae:	6840      	ldr	r0, [r0, #4]
c0d040b0:	f7fe fc6e 	bl	c0d02990 <pic>
c0d040b4:	4602      	mov	r2, r0
c0d040b6:	4628      	mov	r0, r5
c0d040b8:	4621      	mov	r1, r4
c0d040ba:	4790      	blx	r2
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d040bc:	1c76      	adds	r6, r6, #1
c0d040be:	2e03      	cmp	r6, #3
c0d040c0:	d1ed      	bne.n	c0d0409e <USBD_ClrClassConfig+0x10>
    if(usbd_is_valid_intf(pdev, intf)) {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
    }
  }
  return USBD_OK;
c0d040c2:	2000      	movs	r0, #0
c0d040c4:	b001      	add	sp, #4
c0d040c6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d040c8 <USBD_LL_SetupStage>:
*         Handle the setup stage
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetupStage(USBD_HandleTypeDef *pdev, uint8_t *psetup)
{
c0d040c8:	b570      	push	{r4, r5, r6, lr}
c0d040ca:	4604      	mov	r4, r0
c0d040cc:	2021      	movs	r0, #33	; 0x21
c0d040ce:	00c6      	lsls	r6, r0, #3
  USBD_ParseSetupRequest(&pdev->request, psetup);
c0d040d0:	19a5      	adds	r5, r4, r6
c0d040d2:	4628      	mov	r0, r5
c0d040d4:	f000 fba7 	bl	c0d04826 <USBD_ParseSetupRequest>
  
  pdev->ep0_state = USBD_EP0_SETUP;
c0d040d8:	20f4      	movs	r0, #244	; 0xf4
c0d040da:	2101      	movs	r1, #1
c0d040dc:	5021      	str	r1, [r4, r0]
  pdev->ep0_data_len = pdev->request.wLength;
c0d040de:	2087      	movs	r0, #135	; 0x87
c0d040e0:	0040      	lsls	r0, r0, #1
c0d040e2:	5a20      	ldrh	r0, [r4, r0]
c0d040e4:	21f8      	movs	r1, #248	; 0xf8
c0d040e6:	5060      	str	r0, [r4, r1]
  
  switch (pdev->request.bmRequest & 0x1F) 
c0d040e8:	5da1      	ldrb	r1, [r4, r6]
c0d040ea:	201f      	movs	r0, #31
c0d040ec:	4008      	ands	r0, r1
c0d040ee:	2802      	cmp	r0, #2
c0d040f0:	d008      	beq.n	c0d04104 <USBD_LL_SetupStage+0x3c>
c0d040f2:	2801      	cmp	r0, #1
c0d040f4:	d00b      	beq.n	c0d0410e <USBD_LL_SetupStage+0x46>
c0d040f6:	2800      	cmp	r0, #0
c0d040f8:	d10e      	bne.n	c0d04118 <USBD_LL_SetupStage+0x50>
  {
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
c0d040fa:	4620      	mov	r0, r4
c0d040fc:	4629      	mov	r1, r5
c0d040fe:	f000 f93f 	bl	c0d04380 <USBD_StdDevReq>
c0d04102:	e00e      	b.n	c0d04122 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
c0d04104:	4620      	mov	r0, r4
c0d04106:	4629      	mov	r1, r5
c0d04108:	f000 fb02 	bl	c0d04710 <USBD_StdEPReq>
c0d0410c:	e009      	b.n	c0d04122 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
c0d0410e:	4620      	mov	r0, r4
c0d04110:	4629      	mov	r1, r5
c0d04112:	f000 fad8 	bl	c0d046c6 <USBD_StdItfReq>
c0d04116:	e004      	b.n	c0d04122 <USBD_LL_SetupStage+0x5a>
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
    break;
    
  default:           
    USBD_LL_StallEP(pdev , pdev->request.bmRequest & 0x80);
c0d04118:	2080      	movs	r0, #128	; 0x80
c0d0411a:	4001      	ands	r1, r0
c0d0411c:	4620      	mov	r0, r4
c0d0411e:	f7ff feb3 	bl	c0d03e88 <USBD_LL_StallEP>
    break;
  }  
  return USBD_OK;  
c0d04122:	2000      	movs	r0, #0
c0d04124:	bd70      	pop	{r4, r5, r6, pc}

c0d04126 <USBD_LL_DataOutStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataOutStage(USBD_HandleTypeDef *pdev , uint8_t epnum, uint8_t *pdata)
{
c0d04126:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04128:	b083      	sub	sp, #12
c0d0412a:	9202      	str	r2, [sp, #8]
c0d0412c:	4604      	mov	r4, r0
c0d0412e:	9101      	str	r1, [sp, #4]
  USBD_EndpointTypeDef    *pep;
  
  if(epnum == 0) 
c0d04130:	2900      	cmp	r1, #0
c0d04132:	d01e      	beq.n	c0d04172 <USBD_LL_DataOutStage+0x4c>
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d04134:	2045      	movs	r0, #69	; 0x45
c0d04136:	0080      	lsls	r0, r0, #2
c0d04138:	1825      	adds	r5, r4, r0
c0d0413a:	4626      	mov	r6, r4
c0d0413c:	36fc      	adds	r6, #252	; 0xfc
c0d0413e:	2700      	movs	r7, #0
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d04140:	4620      	mov	r0, r4
c0d04142:	4639      	mov	r1, r7
c0d04144:	f000 f90e 	bl	c0d04364 <usbd_is_valid_intf>
c0d04148:	2800      	cmp	r0, #0
c0d0414a:	d00e      	beq.n	c0d0416a <USBD_LL_DataOutStage+0x44>
c0d0414c:	00f8      	lsls	r0, r7, #3
c0d0414e:	5828      	ldr	r0, [r5, r0]
c0d04150:	6980      	ldr	r0, [r0, #24]
c0d04152:	2800      	cmp	r0, #0
c0d04154:	d009      	beq.n	c0d0416a <USBD_LL_DataOutStage+0x44>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d04156:	7831      	ldrb	r1, [r6, #0]
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d04158:	2903      	cmp	r1, #3
c0d0415a:	d106      	bne.n	c0d0416a <USBD_LL_DataOutStage+0x44>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
c0d0415c:	f7fe fc18 	bl	c0d02990 <pic>
c0d04160:	4603      	mov	r3, r0
c0d04162:	4620      	mov	r0, r4
c0d04164:	9901      	ldr	r1, [sp, #4]
c0d04166:	9a02      	ldr	r2, [sp, #8]
c0d04168:	4798      	blx	r3
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0416a:	1c7f      	adds	r7, r7, #1
c0d0416c:	2f03      	cmp	r7, #3
c0d0416e:	d1e7      	bne.n	c0d04140 <USBD_LL_DataOutStage+0x1a>
c0d04170:	e035      	b.n	c0d041de <USBD_LL_DataOutStage+0xb8>
  
  if(epnum == 0) 
  {
    pep = &pdev->ep_out[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_OUT)
c0d04172:	20f4      	movs	r0, #244	; 0xf4
c0d04174:	5820      	ldr	r0, [r4, r0]
c0d04176:	2803      	cmp	r0, #3
c0d04178:	d131      	bne.n	c0d041de <USBD_LL_DataOutStage+0xb8>
    {
      if(pep->rem_length > pep->maxpacket)
c0d0417a:	2090      	movs	r0, #144	; 0x90
c0d0417c:	5820      	ldr	r0, [r4, r0]
c0d0417e:	218c      	movs	r1, #140	; 0x8c
c0d04180:	5861      	ldr	r1, [r4, r1]
c0d04182:	4622      	mov	r2, r4
c0d04184:	328c      	adds	r2, #140	; 0x8c
c0d04186:	4281      	cmp	r1, r0
c0d04188:	d90a      	bls.n	c0d041a0 <USBD_LL_DataOutStage+0x7a>
      {
        pep->rem_length -=  pep->maxpacket;
c0d0418a:	1a09      	subs	r1, r1, r0
c0d0418c:	6011      	str	r1, [r2, #0]
c0d0418e:	4281      	cmp	r1, r0
c0d04190:	d300      	bcc.n	c0d04194 <USBD_LL_DataOutStage+0x6e>
c0d04192:	4601      	mov	r1, r0
       
        USBD_CtlContinueRx (pdev, 
c0d04194:	b28a      	uxth	r2, r1
c0d04196:	4620      	mov	r0, r4
c0d04198:	9902      	ldr	r1, [sp, #8]
c0d0419a:	f000 fcc1 	bl	c0d04b20 <USBD_CtlContinueRx>
c0d0419e:	e01e      	b.n	c0d041de <USBD_LL_DataOutStage+0xb8>
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d041a0:	2045      	movs	r0, #69	; 0x45
c0d041a2:	0080      	lsls	r0, r0, #2
c0d041a4:	1826      	adds	r6, r4, r0
c0d041a6:	4627      	mov	r7, r4
c0d041a8:	37fc      	adds	r7, #252	; 0xfc
c0d041aa:	2500      	movs	r5, #0
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d041ac:	4620      	mov	r0, r4
c0d041ae:	4629      	mov	r1, r5
c0d041b0:	f000 f8d8 	bl	c0d04364 <usbd_is_valid_intf>
c0d041b4:	2800      	cmp	r0, #0
c0d041b6:	d00c      	beq.n	c0d041d2 <USBD_LL_DataOutStage+0xac>
c0d041b8:	00e8      	lsls	r0, r5, #3
c0d041ba:	5830      	ldr	r0, [r6, r0]
c0d041bc:	6900      	ldr	r0, [r0, #16]
c0d041be:	2800      	cmp	r0, #0
c0d041c0:	d007      	beq.n	c0d041d2 <USBD_LL_DataOutStage+0xac>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d041c2:	7839      	ldrb	r1, [r7, #0]
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d041c4:	2903      	cmp	r1, #3
c0d041c6:	d104      	bne.n	c0d041d2 <USBD_LL_DataOutStage+0xac>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
c0d041c8:	f7fe fbe2 	bl	c0d02990 <pic>
c0d041cc:	4601      	mov	r1, r0
c0d041ce:	4620      	mov	r0, r4
c0d041d0:	4788      	blx	r1
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d041d2:	1c6d      	adds	r5, r5, #1
c0d041d4:	2d03      	cmp	r5, #3
c0d041d6:	d1e9      	bne.n	c0d041ac <USBD_LL_DataOutStage+0x86>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
          }
        }
        USBD_CtlSendStatus(pdev);
c0d041d8:	4620      	mov	r0, r4
c0d041da:	f000 fca8 	bl	c0d04b2e <USBD_CtlSendStatus>
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
      }
    }
  }  
  return USBD_OK;
c0d041de:	2000      	movs	r0, #0
c0d041e0:	b003      	add	sp, #12
c0d041e2:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d041e4 <USBD_LL_DataInStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataInStage(USBD_HandleTypeDef *pdev ,uint8_t epnum, uint8_t *pdata)
{
c0d041e4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d041e6:	b081      	sub	sp, #4
c0d041e8:	4604      	mov	r4, r0
c0d041ea:	9100      	str	r1, [sp, #0]
  USBD_EndpointTypeDef    *pep;
  UNUSED(pdata);
    
  if(epnum == 0) 
c0d041ec:	2900      	cmp	r1, #0
c0d041ee:	d01d      	beq.n	c0d0422c <USBD_LL_DataInStage+0x48>
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d041f0:	2045      	movs	r0, #69	; 0x45
c0d041f2:	0080      	lsls	r0, r0, #2
c0d041f4:	1827      	adds	r7, r4, r0
c0d041f6:	4625      	mov	r5, r4
c0d041f8:	35fc      	adds	r5, #252	; 0xfc
c0d041fa:	2600      	movs	r6, #0
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d041fc:	4620      	mov	r0, r4
c0d041fe:	4631      	mov	r1, r6
c0d04200:	f000 f8b0 	bl	c0d04364 <usbd_is_valid_intf>
c0d04204:	2800      	cmp	r0, #0
c0d04206:	d00d      	beq.n	c0d04224 <USBD_LL_DataInStage+0x40>
c0d04208:	00f0      	lsls	r0, r6, #3
c0d0420a:	5838      	ldr	r0, [r7, r0]
c0d0420c:	6940      	ldr	r0, [r0, #20]
c0d0420e:	2800      	cmp	r0, #0
c0d04210:	d008      	beq.n	c0d04224 <USBD_LL_DataInStage+0x40>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d04212:	7829      	ldrb	r1, [r5, #0]
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d04214:	2903      	cmp	r1, #3
c0d04216:	d105      	bne.n	c0d04224 <USBD_LL_DataInStage+0x40>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
c0d04218:	f7fe fbba 	bl	c0d02990 <pic>
c0d0421c:	4602      	mov	r2, r0
c0d0421e:	4620      	mov	r0, r4
c0d04220:	9900      	ldr	r1, [sp, #0]
c0d04222:	4790      	blx	r2
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d04224:	1c76      	adds	r6, r6, #1
c0d04226:	2e03      	cmp	r6, #3
c0d04228:	d1e8      	bne.n	c0d041fc <USBD_LL_DataInStage+0x18>
c0d0422a:	e051      	b.n	c0d042d0 <USBD_LL_DataInStage+0xec>
    
  if(epnum == 0) 
  {
    pep = &pdev->ep_in[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_IN)
c0d0422c:	20f4      	movs	r0, #244	; 0xf4
c0d0422e:	5820      	ldr	r0, [r4, r0]
c0d04230:	2802      	cmp	r0, #2
c0d04232:	d145      	bne.n	c0d042c0 <USBD_LL_DataInStage+0xdc>
    {
      if(pep->rem_length > pep->maxpacket)
c0d04234:	69e0      	ldr	r0, [r4, #28]
c0d04236:	6a25      	ldr	r5, [r4, #32]
c0d04238:	42a8      	cmp	r0, r5
c0d0423a:	d90b      	bls.n	c0d04254 <USBD_LL_DataInStage+0x70>
      {
        pep->rem_length -=  pep->maxpacket;
c0d0423c:	1b40      	subs	r0, r0, r5
c0d0423e:	61e0      	str	r0, [r4, #28]
        pdev->pData += pep->maxpacket;
c0d04240:	2113      	movs	r1, #19
c0d04242:	010a      	lsls	r2, r1, #4
c0d04244:	58a1      	ldr	r1, [r4, r2]
c0d04246:	1949      	adds	r1, r1, r5
c0d04248:	50a1      	str	r1, [r4, r2]
        USBD_LL_PrepareReceive (pdev,
                                0,
                                0);  
        */
        
        USBD_CtlContinueSendData (pdev, 
c0d0424a:	b282      	uxth	r2, r0
c0d0424c:	4620      	mov	r0, r4
c0d0424e:	f000 fc59 	bl	c0d04b04 <USBD_CtlContinueSendData>
c0d04252:	e035      	b.n	c0d042c0 <USBD_LL_DataInStage+0xdc>
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d04254:	69a6      	ldr	r6, [r4, #24]
c0d04256:	4630      	mov	r0, r6
c0d04258:	4629      	mov	r1, r5
c0d0425a:	f000 fd05 	bl	c0d04c68 <__aeabi_uidivmod>
c0d0425e:	42ae      	cmp	r6, r5
c0d04260:	d30f      	bcc.n	c0d04282 <USBD_LL_DataInStage+0x9e>
c0d04262:	2900      	cmp	r1, #0
c0d04264:	d10d      	bne.n	c0d04282 <USBD_LL_DataInStage+0x9e>
           (pep->total_length >= pep->maxpacket) &&
             (pep->total_length < pdev->ep0_data_len ))
c0d04266:	20f8      	movs	r0, #248	; 0xf8
c0d04268:	5820      	ldr	r0, [r4, r0]
c0d0426a:	4627      	mov	r7, r4
c0d0426c:	37f8      	adds	r7, #248	; 0xf8
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d0426e:	4286      	cmp	r6, r0
c0d04270:	d207      	bcs.n	c0d04282 <USBD_LL_DataInStage+0x9e>
c0d04272:	2500      	movs	r5, #0
          USBD_LL_PrepareReceive (pdev,
                                  0,
                                  0);
          */

          USBD_CtlContinueSendData(pdev , NULL, 0);
c0d04274:	4620      	mov	r0, r4
c0d04276:	4629      	mov	r1, r5
c0d04278:	462a      	mov	r2, r5
c0d0427a:	f000 fc43 	bl	c0d04b04 <USBD_CtlContinueSendData>
          pdev->ep0_data_len = 0;
c0d0427e:	603d      	str	r5, [r7, #0]
c0d04280:	e01e      	b.n	c0d042c0 <USBD_LL_DataInStage+0xdc>
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d04282:	2045      	movs	r0, #69	; 0x45
c0d04284:	0080      	lsls	r0, r0, #2
c0d04286:	1826      	adds	r6, r4, r0
c0d04288:	4627      	mov	r7, r4
c0d0428a:	37fc      	adds	r7, #252	; 0xfc
c0d0428c:	2500      	movs	r5, #0
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d0428e:	4620      	mov	r0, r4
c0d04290:	4629      	mov	r1, r5
c0d04292:	f000 f867 	bl	c0d04364 <usbd_is_valid_intf>
c0d04296:	2800      	cmp	r0, #0
c0d04298:	d00c      	beq.n	c0d042b4 <USBD_LL_DataInStage+0xd0>
c0d0429a:	00e8      	lsls	r0, r5, #3
c0d0429c:	5830      	ldr	r0, [r6, r0]
c0d0429e:	68c0      	ldr	r0, [r0, #12]
c0d042a0:	2800      	cmp	r0, #0
c0d042a2:	d007      	beq.n	c0d042b4 <USBD_LL_DataInStage+0xd0>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d042a4:	7839      	ldrb	r1, [r7, #0]
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d042a6:	2903      	cmp	r1, #3
c0d042a8:	d104      	bne.n	c0d042b4 <USBD_LL_DataInStage+0xd0>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
c0d042aa:	f7fe fb71 	bl	c0d02990 <pic>
c0d042ae:	4601      	mov	r1, r0
c0d042b0:	4620      	mov	r0, r4
c0d042b2:	4788      	blx	r1
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d042b4:	1c6d      	adds	r5, r5, #1
c0d042b6:	2d03      	cmp	r5, #3
c0d042b8:	d1e9      	bne.n	c0d0428e <USBD_LL_DataInStage+0xaa>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
            }
          }
          USBD_CtlReceiveStatus(pdev);
c0d042ba:	4620      	mov	r0, r4
c0d042bc:	f000 fc43 	bl	c0d04b46 <USBD_CtlReceiveStatus>
        }
      }
    }
    if (pdev->dev_test_mode == 1)
c0d042c0:	2001      	movs	r0, #1
c0d042c2:	0201      	lsls	r1, r0, #8
c0d042c4:	1860      	adds	r0, r4, r1
c0d042c6:	5c61      	ldrb	r1, [r4, r1]
c0d042c8:	2901      	cmp	r1, #1
c0d042ca:	d101      	bne.n	c0d042d0 <USBD_LL_DataInStage+0xec>
    {
      USBD_RunTestMode(pdev); 
      pdev->dev_test_mode = 0;
c0d042cc:	2100      	movs	r1, #0
c0d042ce:	7001      	strb	r1, [r0, #0]
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
      }
    }
  }
  return USBD_OK;
c0d042d0:	2000      	movs	r0, #0
c0d042d2:	b001      	add	sp, #4
c0d042d4:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d042d6 <USBD_LL_Reset>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Reset(USBD_HandleTypeDef  *pdev)
{
c0d042d6:	b570      	push	{r4, r5, r6, lr}
c0d042d8:	4604      	mov	r4, r0
  pdev->ep_out[0].maxpacket = USB_MAX_EP0_SIZE;
c0d042da:	2090      	movs	r0, #144	; 0x90
c0d042dc:	2140      	movs	r1, #64	; 0x40
c0d042de:	5021      	str	r1, [r4, r0]
  

  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
c0d042e0:	6221      	str	r1, [r4, #32]
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
c0d042e2:	20fc      	movs	r0, #252	; 0xfc
c0d042e4:	2101      	movs	r1, #1
c0d042e6:	5421      	strb	r1, [r4, r0]
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d042e8:	2045      	movs	r0, #69	; 0x45
c0d042ea:	0080      	lsls	r0, r0, #2
c0d042ec:	1826      	adds	r6, r4, r0
c0d042ee:	2500      	movs	r5, #0
    if( usbd_is_valid_intf(pdev, intf))
c0d042f0:	4620      	mov	r0, r4
c0d042f2:	4629      	mov	r1, r5
c0d042f4:	f000 f836 	bl	c0d04364 <usbd_is_valid_intf>
c0d042f8:	2800      	cmp	r0, #0
c0d042fa:	d008      	beq.n	c0d0430e <USBD_LL_Reset+0x38>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
c0d042fc:	00e8      	lsls	r0, r5, #3
c0d042fe:	5830      	ldr	r0, [r6, r0]
c0d04300:	6840      	ldr	r0, [r0, #4]
c0d04302:	f7fe fb45 	bl	c0d02990 <pic>
c0d04306:	4602      	mov	r2, r0
c0d04308:	7921      	ldrb	r1, [r4, #4]
c0d0430a:	4620      	mov	r0, r4
c0d0430c:	4790      	blx	r2
  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0430e:	1c6d      	adds	r5, r5, #1
c0d04310:	2d03      	cmp	r5, #3
c0d04312:	d1ed      	bne.n	c0d042f0 <USBD_LL_Reset+0x1a>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
    }
  }
  
  return USBD_OK;
c0d04314:	2000      	movs	r0, #0
c0d04316:	bd70      	pop	{r4, r5, r6, pc}

c0d04318 <USBD_LL_SetSpeed>:
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetSpeed(USBD_HandleTypeDef  *pdev, USBD_SpeedTypeDef speed)
{
  pdev->dev_speed = speed;
c0d04318:	7401      	strb	r1, [r0, #16]
c0d0431a:	2000      	movs	r0, #0
  return USBD_OK;
c0d0431c:	4770      	bx	lr

c0d0431e <USBD_LL_Suspend>:
{
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_old_state =  pdev->dev_state;
  //pdev->dev_state  = USBD_STATE_SUSPENDED;
  return USBD_OK;
c0d0431e:	2000      	movs	r0, #0
c0d04320:	4770      	bx	lr

c0d04322 <USBD_LL_Resume>:
USBD_StatusTypeDef USBD_LL_Resume(USBD_HandleTypeDef  *pdev)
{
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_state = pdev->dev_old_state;  
  return USBD_OK;
c0d04322:	2000      	movs	r0, #0
c0d04324:	4770      	bx	lr

c0d04326 <USBD_LL_SOF>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
c0d04326:	b570      	push	{r4, r5, r6, lr}
c0d04328:	4604      	mov	r4, r0
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
c0d0432a:	20fc      	movs	r0, #252	; 0xfc
c0d0432c:	5c20      	ldrb	r0, [r4, r0]
c0d0432e:	2803      	cmp	r0, #3
c0d04330:	d116      	bne.n	c0d04360 <USBD_LL_SOF+0x3a>
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && pdev->interfacesClass[intf].pClass->SOF != NULL)
c0d04332:	2045      	movs	r0, #69	; 0x45
c0d04334:	0080      	lsls	r0, r0, #2
c0d04336:	1826      	adds	r6, r4, r0
c0d04338:	2500      	movs	r5, #0
c0d0433a:	4620      	mov	r0, r4
c0d0433c:	4629      	mov	r1, r5
c0d0433e:	f000 f811 	bl	c0d04364 <usbd_is_valid_intf>
c0d04342:	2800      	cmp	r0, #0
c0d04344:	d009      	beq.n	c0d0435a <USBD_LL_SOF+0x34>
c0d04346:	00e8      	lsls	r0, r5, #3
c0d04348:	5830      	ldr	r0, [r6, r0]
c0d0434a:	69c0      	ldr	r0, [r0, #28]
c0d0434c:	2800      	cmp	r0, #0
c0d0434e:	d004      	beq.n	c0d0435a <USBD_LL_SOF+0x34>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
c0d04350:	f7fe fb1e 	bl	c0d02990 <pic>
c0d04354:	4601      	mov	r1, r0
c0d04356:	4620      	mov	r0, r4
c0d04358:	4788      	blx	r1
USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0435a:	1c6d      	adds	r5, r5, #1
c0d0435c:	2d03      	cmp	r5, #3
c0d0435e:	d1ec      	bne.n	c0d0433a <USBD_LL_SOF+0x14>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
      }
    }
  }
  return USBD_OK;
c0d04360:	2000      	movs	r0, #0
c0d04362:	bd70      	pop	{r4, r5, r6, pc}

c0d04364 <usbd_is_valid_intf>:

/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
c0d04364:	4602      	mov	r2, r0
c0d04366:	2000      	movs	r0, #0
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d04368:	2902      	cmp	r1, #2
c0d0436a:	d808      	bhi.n	c0d0437e <usbd_is_valid_intf+0x1a>
c0d0436c:	00c8      	lsls	r0, r1, #3
c0d0436e:	1810      	adds	r0, r2, r0
c0d04370:	2145      	movs	r1, #69	; 0x45
c0d04372:	0089      	lsls	r1, r1, #2
c0d04374:	5841      	ldr	r1, [r0, r1]
c0d04376:	2001      	movs	r0, #1
c0d04378:	2900      	cmp	r1, #0
c0d0437a:	d100      	bne.n	c0d0437e <usbd_is_valid_intf+0x1a>
c0d0437c:	4608      	mov	r0, r1
c0d0437e:	4770      	bx	lr

c0d04380 <USBD_StdDevReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d04380:	b580      	push	{r7, lr}
c0d04382:	784a      	ldrb	r2, [r1, #1]
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d04384:	2a04      	cmp	r2, #4
c0d04386:	dd08      	ble.n	c0d0439a <USBD_StdDevReq+0x1a>
c0d04388:	2a07      	cmp	r2, #7
c0d0438a:	dc0f      	bgt.n	c0d043ac <USBD_StdDevReq+0x2c>
c0d0438c:	2a05      	cmp	r2, #5
c0d0438e:	d014      	beq.n	c0d043ba <USBD_StdDevReq+0x3a>
c0d04390:	2a06      	cmp	r2, #6
c0d04392:	d11b      	bne.n	c0d043cc <USBD_StdDevReq+0x4c>
  {
  case USB_REQ_GET_DESCRIPTOR: 
    
    USBD_GetDescriptor (pdev, req) ;
c0d04394:	f000 f821 	bl	c0d043da <USBD_GetDescriptor>
c0d04398:	e01d      	b.n	c0d043d6 <USBD_StdDevReq+0x56>
c0d0439a:	2a00      	cmp	r2, #0
c0d0439c:	d010      	beq.n	c0d043c0 <USBD_StdDevReq+0x40>
c0d0439e:	2a01      	cmp	r2, #1
c0d043a0:	d017      	beq.n	c0d043d2 <USBD_StdDevReq+0x52>
c0d043a2:	2a03      	cmp	r2, #3
c0d043a4:	d112      	bne.n	c0d043cc <USBD_StdDevReq+0x4c>
    USBD_GetStatus (pdev , req);
    break;
    
    
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
c0d043a6:	f000 f93b 	bl	c0d04620 <USBD_SetFeature>
c0d043aa:	e014      	b.n	c0d043d6 <USBD_StdDevReq+0x56>
c0d043ac:	2a08      	cmp	r2, #8
c0d043ae:	d00a      	beq.n	c0d043c6 <USBD_StdDevReq+0x46>
c0d043b0:	2a09      	cmp	r2, #9
c0d043b2:	d10b      	bne.n	c0d043cc <USBD_StdDevReq+0x4c>
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
    break;
    
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
c0d043b4:	f000 f8c3 	bl	c0d0453e <USBD_SetConfig>
c0d043b8:	e00d      	b.n	c0d043d6 <USBD_StdDevReq+0x56>
    
    USBD_GetDescriptor (pdev, req) ;
    break;
    
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
c0d043ba:	f000 f89b 	bl	c0d044f4 <USBD_SetAddress>
c0d043be:	e00a      	b.n	c0d043d6 <USBD_StdDevReq+0x56>
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_STATUS:                                  
    USBD_GetStatus (pdev , req);
c0d043c0:	f000 f90b 	bl	c0d045da <USBD_GetStatus>
c0d043c4:	e007      	b.n	c0d043d6 <USBD_StdDevReq+0x56>
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
c0d043c6:	f000 f8f1 	bl	c0d045ac <USBD_GetConfig>
c0d043ca:	e004      	b.n	c0d043d6 <USBD_StdDevReq+0x56>
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
    break;
    
  default:  
    USBD_CtlError(pdev , req);
c0d043cc:	f000 f971 	bl	c0d046b2 <USBD_CtlError>
c0d043d0:	e001      	b.n	c0d043d6 <USBD_StdDevReq+0x56>
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
    break;
    
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
c0d043d2:	f000 f944 	bl	c0d0465e <USBD_ClrFeature>
  default:  
    USBD_CtlError(pdev , req);
    break;
  }
  
  return ret;
c0d043d6:	2000      	movs	r0, #0
c0d043d8:	bd80      	pop	{r7, pc}

c0d043da <USBD_GetDescriptor>:
* @param  req: usb request
* @retval status
*/
void USBD_GetDescriptor(USBD_HandleTypeDef *pdev , 
                               USBD_SetupReqTypedef *req)
{
c0d043da:	b5b0      	push	{r4, r5, r7, lr}
c0d043dc:	b082      	sub	sp, #8
c0d043de:	460d      	mov	r5, r1
c0d043e0:	4604      	mov	r4, r0
  uint16_t len;
  uint8_t *pbuf = NULL;
  
    
  switch (req->wValue >> 8)
c0d043e2:	8869      	ldrh	r1, [r5, #2]
c0d043e4:	0a08      	lsrs	r0, r1, #8
c0d043e6:	2805      	cmp	r0, #5
c0d043e8:	dc13      	bgt.n	c0d04412 <USBD_GetDescriptor+0x38>
c0d043ea:	2801      	cmp	r0, #1
c0d043ec:	d01c      	beq.n	c0d04428 <USBD_GetDescriptor+0x4e>
c0d043ee:	2802      	cmp	r0, #2
c0d043f0:	d025      	beq.n	c0d0443e <USBD_GetDescriptor+0x64>
c0d043f2:	2803      	cmp	r0, #3
c0d043f4:	d13b      	bne.n	c0d0446e <USBD_GetDescriptor+0x94>
c0d043f6:	b2c8      	uxtb	r0, r1
      }
    }
    break;
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
c0d043f8:	2802      	cmp	r0, #2
c0d043fa:	dc3d      	bgt.n	c0d04478 <USBD_GetDescriptor+0x9e>
c0d043fc:	2800      	cmp	r0, #0
c0d043fe:	d065      	beq.n	c0d044cc <USBD_GetDescriptor+0xf2>
c0d04400:	2801      	cmp	r0, #1
c0d04402:	d06d      	beq.n	c0d044e0 <USBD_GetDescriptor+0x106>
c0d04404:	2802      	cmp	r0, #2
c0d04406:	d132      	bne.n	c0d0446e <USBD_GetDescriptor+0x94>
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
c0d04408:	2011      	movs	r0, #17
c0d0440a:	0100      	lsls	r0, r0, #4
c0d0440c:	5820      	ldr	r0, [r4, r0]
c0d0440e:	68c0      	ldr	r0, [r0, #12]
c0d04410:	e00e      	b.n	c0d04430 <USBD_GetDescriptor+0x56>
c0d04412:	2806      	cmp	r0, #6
c0d04414:	d01e      	beq.n	c0d04454 <USBD_GetDescriptor+0x7a>
c0d04416:	2807      	cmp	r0, #7
c0d04418:	d026      	beq.n	c0d04468 <USBD_GetDescriptor+0x8e>
c0d0441a:	280f      	cmp	r0, #15
c0d0441c:	d127      	bne.n	c0d0446e <USBD_GetDescriptor+0x94>
    
  switch (req->wValue >> 8)
  { 
#if (USBD_LPM_ENABLED == 1)
  case USB_DESC_TYPE_BOS:
    pbuf = ((GetBOSDescriptor_t)PIC(pdev->pDesc->GetBOSDescriptor))(pdev->dev_speed, &len);
c0d0441e:	2011      	movs	r0, #17
c0d04420:	0100      	lsls	r0, r0, #4
c0d04422:	5820      	ldr	r0, [r4, r0]
c0d04424:	69c0      	ldr	r0, [r0, #28]
c0d04426:	e003      	b.n	c0d04430 <USBD_GetDescriptor+0x56>
    break;
#endif    
  case USB_DESC_TYPE_DEVICE:
    pbuf = ((GetDeviceDescriptor_t)PIC(pdev->pDesc->GetDeviceDescriptor))(pdev->dev_speed, &len);
c0d04428:	2011      	movs	r0, #17
c0d0442a:	0100      	lsls	r0, r0, #4
c0d0442c:	5820      	ldr	r0, [r4, r0]
c0d0442e:	6800      	ldr	r0, [r0, #0]
c0d04430:	f7fe faae 	bl	c0d02990 <pic>
c0d04434:	4602      	mov	r2, r0
c0d04436:	7c20      	ldrb	r0, [r4, #16]
c0d04438:	a901      	add	r1, sp, #4
c0d0443a:	4790      	blx	r2
c0d0443c:	e034      	b.n	c0d044a8 <USBD_GetDescriptor+0xce>
    break;
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
c0d0443e:	2045      	movs	r0, #69	; 0x45
c0d04440:	0080      	lsls	r0, r0, #2
c0d04442:	5820      	ldr	r0, [r4, r0]
c0d04444:	2100      	movs	r1, #0
c0d04446:	2800      	cmp	r0, #0
c0d04448:	d02f      	beq.n	c0d044aa <USBD_GetDescriptor+0xd0>
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
c0d0444a:	7c21      	ldrb	r1, [r4, #16]
c0d0444c:	2900      	cmp	r1, #0
c0d0444e:	d025      	beq.n	c0d0449c <USBD_GetDescriptor+0xc2>
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
        //pbuf[1] = USB_DESC_TYPE_CONFIGURATION; CONST BUFFER KTHX
      }
      else
      {
        pbuf   = (uint8_t *)((GetFSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetFSConfigDescriptor))(&len);
c0d04450:	6ac0      	ldr	r0, [r0, #44]	; 0x2c
c0d04452:	e024      	b.n	c0d0449e <USBD_GetDescriptor+0xc4>
#endif   
    }
    break;
  case USB_DESC_TYPE_DEVICE_QUALIFIER:                   

    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL )   
c0d04454:	7c20      	ldrb	r0, [r4, #16]
c0d04456:	2800      	cmp	r0, #0
c0d04458:	d109      	bne.n	c0d0446e <USBD_GetDescriptor+0x94>
c0d0445a:	2045      	movs	r0, #69	; 0x45
c0d0445c:	0080      	lsls	r0, r0, #2
c0d0445e:	5820      	ldr	r0, [r4, r0]
c0d04460:	2800      	cmp	r0, #0
c0d04462:	d004      	beq.n	c0d0446e <USBD_GetDescriptor+0x94>
    {
      pbuf   = (uint8_t *)((GetDeviceQualifierDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetDeviceQualifierDescriptor))(&len);
c0d04464:	6b40      	ldr	r0, [r0, #52]	; 0x34
c0d04466:	e01a      	b.n	c0d0449e <USBD_GetDescriptor+0xc4>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d04468:	7c20      	ldrb	r0, [r4, #16]
c0d0446a:	2800      	cmp	r0, #0
c0d0446c:	d00f      	beq.n	c0d0448e <USBD_GetDescriptor+0xb4>
c0d0446e:	4620      	mov	r0, r4
c0d04470:	4629      	mov	r1, r5
c0d04472:	f000 f91e 	bl	c0d046b2 <USBD_CtlError>
c0d04476:	e027      	b.n	c0d044c8 <USBD_GetDescriptor+0xee>
c0d04478:	2803      	cmp	r0, #3
c0d0447a:	d02c      	beq.n	c0d044d6 <USBD_GetDescriptor+0xfc>
c0d0447c:	2804      	cmp	r0, #4
c0d0447e:	d034      	beq.n	c0d044ea <USBD_GetDescriptor+0x110>
c0d04480:	2805      	cmp	r0, #5
c0d04482:	d1f4      	bne.n	c0d0446e <USBD_GetDescriptor+0x94>
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_INTERFACE_STR:
      pbuf = ((GetInterfaceStrDescriptor_t)PIC(pdev->pDesc->GetInterfaceStrDescriptor))(pdev->dev_speed, &len);
c0d04484:	2011      	movs	r0, #17
c0d04486:	0100      	lsls	r0, r0, #4
c0d04488:	5820      	ldr	r0, [r4, r0]
c0d0448a:	6980      	ldr	r0, [r0, #24]
c0d0448c:	e7d0      	b.n	c0d04430 <USBD_GetDescriptor+0x56>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d0448e:	2045      	movs	r0, #69	; 0x45
c0d04490:	0080      	lsls	r0, r0, #2
c0d04492:	5820      	ldr	r0, [r4, r0]
c0d04494:	2800      	cmp	r0, #0
c0d04496:	d0ea      	beq.n	c0d0446e <USBD_GetDescriptor+0x94>
    {
      pbuf   = (uint8_t *)((GetOtherSpeedConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetOtherSpeedConfigDescriptor))(&len);
c0d04498:	6b00      	ldr	r0, [r0, #48]	; 0x30
c0d0449a:	e000      	b.n	c0d0449e <USBD_GetDescriptor+0xc4>
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
      {
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
c0d0449c:	6a80      	ldr	r0, [r0, #40]	; 0x28
c0d0449e:	f7fe fa77 	bl	c0d02990 <pic>
c0d044a2:	4601      	mov	r1, r0
c0d044a4:	a801      	add	r0, sp, #4
c0d044a6:	4788      	blx	r1
c0d044a8:	4601      	mov	r1, r0
c0d044aa:	a801      	add	r0, sp, #4
  default: 
     USBD_CtlError(pdev , req);
    return;
  }
  
  if((len != 0)&& (req->wLength != 0))
c0d044ac:	8802      	ldrh	r2, [r0, #0]
c0d044ae:	2a00      	cmp	r2, #0
c0d044b0:	d00a      	beq.n	c0d044c8 <USBD_GetDescriptor+0xee>
c0d044b2:	88e8      	ldrh	r0, [r5, #6]
c0d044b4:	2800      	cmp	r0, #0
c0d044b6:	d007      	beq.n	c0d044c8 <USBD_GetDescriptor+0xee>
  {
    
    len = MIN(len , req->wLength);
c0d044b8:	4282      	cmp	r2, r0
c0d044ba:	d300      	bcc.n	c0d044be <USBD_GetDescriptor+0xe4>
c0d044bc:	4602      	mov	r2, r0
c0d044be:	a801      	add	r0, sp, #4
c0d044c0:	8002      	strh	r2, [r0, #0]
    
    // prepare abort if host does not read the whole data
    //USBD_CtlReceiveStatus(pdev);

    // start transfer
    USBD_CtlSendData (pdev, 
c0d044c2:	4620      	mov	r0, r4
c0d044c4:	f000 fb08 	bl	c0d04ad8 <USBD_CtlSendData>
                      pbuf,
                      len);
  }
  
}
c0d044c8:	b002      	add	sp, #8
c0d044ca:	bdb0      	pop	{r4, r5, r7, pc}
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
    {
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
c0d044cc:	2011      	movs	r0, #17
c0d044ce:	0100      	lsls	r0, r0, #4
c0d044d0:	5820      	ldr	r0, [r4, r0]
c0d044d2:	6840      	ldr	r0, [r0, #4]
c0d044d4:	e7ac      	b.n	c0d04430 <USBD_GetDescriptor+0x56>
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
c0d044d6:	2011      	movs	r0, #17
c0d044d8:	0100      	lsls	r0, r0, #4
c0d044da:	5820      	ldr	r0, [r4, r0]
c0d044dc:	6900      	ldr	r0, [r0, #16]
c0d044de:	e7a7      	b.n	c0d04430 <USBD_GetDescriptor+0x56>
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
      break;
      
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
c0d044e0:	2011      	movs	r0, #17
c0d044e2:	0100      	lsls	r0, r0, #4
c0d044e4:	5820      	ldr	r0, [r4, r0]
c0d044e6:	6880      	ldr	r0, [r0, #8]
c0d044e8:	e7a2      	b.n	c0d04430 <USBD_GetDescriptor+0x56>
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
c0d044ea:	2011      	movs	r0, #17
c0d044ec:	0100      	lsls	r0, r0, #4
c0d044ee:	5820      	ldr	r0, [r4, r0]
c0d044f0:	6940      	ldr	r0, [r0, #20]
c0d044f2:	e79d      	b.n	c0d04430 <USBD_GetDescriptor+0x56>

c0d044f4 <USBD_SetAddress>:
* @param  req: usb request
* @retval status
*/
void USBD_SetAddress(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d044f4:	b570      	push	{r4, r5, r6, lr}
c0d044f6:	4604      	mov	r4, r0
  uint8_t  dev_addr; 
  
  if ((req->wIndex == 0) && (req->wLength == 0)) 
c0d044f8:	8888      	ldrh	r0, [r1, #4]
c0d044fa:	2800      	cmp	r0, #0
c0d044fc:	d10b      	bne.n	c0d04516 <USBD_SetAddress+0x22>
c0d044fe:	88c8      	ldrh	r0, [r1, #6]
c0d04500:	2800      	cmp	r0, #0
c0d04502:	d108      	bne.n	c0d04516 <USBD_SetAddress+0x22>
  {
    dev_addr = (uint8_t)(req->wValue) & 0x7F;     
c0d04504:	8848      	ldrh	r0, [r1, #2]
c0d04506:	267f      	movs	r6, #127	; 0x7f
c0d04508:	4006      	ands	r6, r0
    
    if (pdev->dev_state == USBD_STATE_CONFIGURED) 
c0d0450a:	20fc      	movs	r0, #252	; 0xfc
c0d0450c:	5c20      	ldrb	r0, [r4, r0]
c0d0450e:	4625      	mov	r5, r4
c0d04510:	35fc      	adds	r5, #252	; 0xfc
c0d04512:	2803      	cmp	r0, #3
c0d04514:	d103      	bne.n	c0d0451e <USBD_SetAddress+0x2a>
c0d04516:	4620      	mov	r0, r4
c0d04518:	f000 f8cb 	bl	c0d046b2 <USBD_CtlError>
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d0451c:	bd70      	pop	{r4, r5, r6, pc}
    {
      USBD_CtlError(pdev , req);
    } 
    else 
    {
      pdev->dev_address = dev_addr;
c0d0451e:	20fe      	movs	r0, #254	; 0xfe
c0d04520:	5426      	strb	r6, [r4, r0]
      USBD_LL_SetUSBAddress(pdev, dev_addr);               
c0d04522:	b2f1      	uxtb	r1, r6
c0d04524:	4620      	mov	r0, r4
c0d04526:	f7ff fd0b 	bl	c0d03f40 <USBD_LL_SetUSBAddress>
      USBD_CtlSendStatus(pdev);                         
c0d0452a:	4620      	mov	r0, r4
c0d0452c:	f000 faff 	bl	c0d04b2e <USBD_CtlSendStatus>
      
      if (dev_addr != 0) 
c0d04530:	2002      	movs	r0, #2
c0d04532:	2101      	movs	r1, #1
c0d04534:	2e00      	cmp	r6, #0
c0d04536:	d100      	bne.n	c0d0453a <USBD_SetAddress+0x46>
c0d04538:	4608      	mov	r0, r1
c0d0453a:	7028      	strb	r0, [r5, #0]
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d0453c:	bd70      	pop	{r4, r5, r6, pc}

c0d0453e <USBD_SetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_SetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d0453e:	b570      	push	{r4, r5, r6, lr}
c0d04540:	460d      	mov	r5, r1
c0d04542:	4604      	mov	r4, r0
  
  uint8_t  cfgidx;
  
  cfgidx = (uint8_t)(req->wValue);                 
c0d04544:	78ae      	ldrb	r6, [r5, #2]
  
  if (cfgidx > USBD_MAX_NUM_CONFIGURATION ) 
c0d04546:	2e02      	cmp	r6, #2
c0d04548:	d21d      	bcs.n	c0d04586 <USBD_SetConfig+0x48>
  {            
     USBD_CtlError(pdev , req);                              
  } 
  else 
  {
    switch (pdev->dev_state) 
c0d0454a:	20fc      	movs	r0, #252	; 0xfc
c0d0454c:	5c21      	ldrb	r1, [r4, r0]
c0d0454e:	4620      	mov	r0, r4
c0d04550:	30fc      	adds	r0, #252	; 0xfc
c0d04552:	2903      	cmp	r1, #3
c0d04554:	d007      	beq.n	c0d04566 <USBD_SetConfig+0x28>
c0d04556:	2902      	cmp	r1, #2
c0d04558:	d115      	bne.n	c0d04586 <USBD_SetConfig+0x48>
    {
    case USBD_STATE_ADDRESSED:
      if (cfgidx) 
c0d0455a:	2e00      	cmp	r6, #0
c0d0455c:	d022      	beq.n	c0d045a4 <USBD_SetConfig+0x66>
      {                                			   							   							   				
        pdev->dev_config = cfgidx;
c0d0455e:	6066      	str	r6, [r4, #4]
        pdev->dev_state = USBD_STATE_CONFIGURED;
c0d04560:	2103      	movs	r1, #3
c0d04562:	7001      	strb	r1, [r0, #0]
c0d04564:	e009      	b.n	c0d0457a <USBD_SetConfig+0x3c>
      }
      USBD_CtlSendStatus(pdev);
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
c0d04566:	2e00      	cmp	r6, #0
c0d04568:	d012      	beq.n	c0d04590 <USBD_SetConfig+0x52>
        pdev->dev_state = USBD_STATE_ADDRESSED;
        pdev->dev_config = cfgidx;          
        USBD_ClrClassConfig(pdev , cfgidx);
        USBD_CtlSendStatus(pdev);
      } 
      else  if (cfgidx != pdev->dev_config) 
c0d0456a:	6860      	ldr	r0, [r4, #4]
c0d0456c:	4286      	cmp	r6, r0
c0d0456e:	d019      	beq.n	c0d045a4 <USBD_SetConfig+0x66>
      {
        /* Clear old configuration */
        USBD_ClrClassConfig(pdev , pdev->dev_config);
c0d04570:	b2c1      	uxtb	r1, r0
c0d04572:	4620      	mov	r0, r4
c0d04574:	f7ff fd8b 	bl	c0d0408e <USBD_ClrClassConfig>
        
        /* set new configuration */
        pdev->dev_config = cfgidx;
c0d04578:	6066      	str	r6, [r4, #4]
c0d0457a:	4620      	mov	r0, r4
c0d0457c:	4631      	mov	r1, r6
c0d0457e:	f7ff fd69 	bl	c0d04054 <USBD_SetClassConfig>
c0d04582:	2802      	cmp	r0, #2
c0d04584:	d10e      	bne.n	c0d045a4 <USBD_SetConfig+0x66>
c0d04586:	4620      	mov	r0, r4
c0d04588:	4629      	mov	r1, r5
c0d0458a:	f000 f892 	bl	c0d046b2 <USBD_CtlError>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d0458e:	bd70      	pop	{r4, r5, r6, pc}
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
      {                           
        pdev->dev_state = USBD_STATE_ADDRESSED;
c0d04590:	2102      	movs	r1, #2
c0d04592:	7001      	strb	r1, [r0, #0]
        pdev->dev_config = cfgidx;          
c0d04594:	6066      	str	r6, [r4, #4]
        USBD_ClrClassConfig(pdev , cfgidx);
c0d04596:	4620      	mov	r0, r4
c0d04598:	4631      	mov	r1, r6
c0d0459a:	f7ff fd78 	bl	c0d0408e <USBD_ClrClassConfig>
        USBD_CtlSendStatus(pdev);
c0d0459e:	4620      	mov	r0, r4
c0d045a0:	f000 fac5 	bl	c0d04b2e <USBD_CtlSendStatus>
c0d045a4:	4620      	mov	r0, r4
c0d045a6:	f000 fac2 	bl	c0d04b2e <USBD_CtlSendStatus>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d045aa:	bd70      	pop	{r4, r5, r6, pc}

c0d045ac <USBD_GetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_GetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d045ac:	b580      	push	{r7, lr}

  if (req->wLength != 1) 
c0d045ae:	88ca      	ldrh	r2, [r1, #6]
c0d045b0:	2a01      	cmp	r2, #1
c0d045b2:	d10a      	bne.n	c0d045ca <USBD_GetConfig+0x1e>
  {                   
     USBD_CtlError(pdev , req);
  }
  else 
  {
    switch (pdev->dev_state )  
c0d045b4:	22fc      	movs	r2, #252	; 0xfc
c0d045b6:	5c82      	ldrb	r2, [r0, r2]
c0d045b8:	2a03      	cmp	r2, #3
c0d045ba:	d009      	beq.n	c0d045d0 <USBD_GetConfig+0x24>
c0d045bc:	2a02      	cmp	r2, #2
c0d045be:	d104      	bne.n	c0d045ca <USBD_GetConfig+0x1e>
    {
    case USBD_STATE_ADDRESSED:                     
      pdev->dev_default_config = 0;
c0d045c0:	2100      	movs	r1, #0
c0d045c2:	6081      	str	r1, [r0, #8]
c0d045c4:	4601      	mov	r1, r0
c0d045c6:	3108      	adds	r1, #8
c0d045c8:	e003      	b.n	c0d045d2 <USBD_GetConfig+0x26>
c0d045ca:	f000 f872 	bl	c0d046b2 <USBD_CtlError>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d045ce:	bd80      	pop	{r7, pc}
                        1);
      break;
      
    case USBD_STATE_CONFIGURED:   
      USBD_CtlSendData (pdev, 
                        (uint8_t *)&pdev->dev_config,
c0d045d0:	1d01      	adds	r1, r0, #4
c0d045d2:	2201      	movs	r2, #1
c0d045d4:	f000 fa80 	bl	c0d04ad8 <USBD_CtlSendData>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d045d8:	bd80      	pop	{r7, pc}

c0d045da <USBD_GetStatus>:
* @param  req: usb request
* @retval status
*/
void USBD_GetStatus(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d045da:	b5b0      	push	{r4, r5, r7, lr}
c0d045dc:	4604      	mov	r4, r0
  
    
  switch (pdev->dev_state) 
c0d045de:	20fc      	movs	r0, #252	; 0xfc
c0d045e0:	5c20      	ldrb	r0, [r4, r0]
c0d045e2:	22fe      	movs	r2, #254	; 0xfe
c0d045e4:	4002      	ands	r2, r0
c0d045e6:	2a02      	cmp	r2, #2
c0d045e8:	d116      	bne.n	c0d04618 <USBD_GetStatus+0x3e>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d045ea:	2001      	movs	r0, #1
c0d045ec:	60e0      	str	r0, [r4, #12]
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d045ee:	2041      	movs	r0, #65	; 0x41
c0d045f0:	0080      	lsls	r0, r0, #2
c0d045f2:	5821      	ldr	r1, [r4, r0]
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d045f4:	4625      	mov	r5, r4
c0d045f6:	350c      	adds	r5, #12
c0d045f8:	2003      	movs	r0, #3
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d045fa:	2900      	cmp	r1, #0
c0d045fc:	d005      	beq.n	c0d0460a <USBD_GetStatus+0x30>
c0d045fe:	4620      	mov	r0, r4
c0d04600:	f000 faa1 	bl	c0d04b46 <USBD_CtlReceiveStatus>
c0d04604:	68e1      	ldr	r1, [r4, #12]
c0d04606:	2002      	movs	r0, #2
c0d04608:	4308      	orrs	r0, r1
    {
       pdev->dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;                                
c0d0460a:	60e0      	str	r0, [r4, #12]
    }
    
    USBD_CtlSendData (pdev, 
c0d0460c:	2202      	movs	r2, #2
c0d0460e:	4620      	mov	r0, r4
c0d04610:	4629      	mov	r1, r5
c0d04612:	f000 fa61 	bl	c0d04ad8 <USBD_CtlSendData>
    
  default :
    USBD_CtlError(pdev , req);                        
    break;
  }
}
c0d04616:	bdb0      	pop	{r4, r5, r7, pc}
                      (uint8_t *)& pdev->dev_config_status,
                      2);
    break;
    
  default :
    USBD_CtlError(pdev , req);                        
c0d04618:	4620      	mov	r0, r4
c0d0461a:	f000 f84a 	bl	c0d046b2 <USBD_CtlError>
    break;
  }
}
c0d0461e:	bdb0      	pop	{r4, r5, r7, pc}

c0d04620 <USBD_SetFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_SetFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d04620:	b5b0      	push	{r4, r5, r7, lr}
c0d04622:	460d      	mov	r5, r1
c0d04624:	4604      	mov	r4, r0

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
c0d04626:	8868      	ldrh	r0, [r5, #2]
c0d04628:	2801      	cmp	r0, #1
c0d0462a:	d117      	bne.n	c0d0465c <USBD_SetFeature+0x3c>
  {
    pdev->dev_remote_wakeup = 1;  
c0d0462c:	2041      	movs	r0, #65	; 0x41
c0d0462e:	0080      	lsls	r0, r0, #2
c0d04630:	2101      	movs	r1, #1
c0d04632:	5021      	str	r1, [r4, r0]
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d04634:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d04636:	2802      	cmp	r0, #2
c0d04638:	d80d      	bhi.n	c0d04656 <USBD_SetFeature+0x36>
c0d0463a:	00c0      	lsls	r0, r0, #3
c0d0463c:	1820      	adds	r0, r4, r0
c0d0463e:	2145      	movs	r1, #69	; 0x45
c0d04640:	0089      	lsls	r1, r1, #2
c0d04642:	5840      	ldr	r0, [r0, r1]
{

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
  {
    pdev->dev_remote_wakeup = 1;  
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d04644:	2800      	cmp	r0, #0
c0d04646:	d006      	beq.n	c0d04656 <USBD_SetFeature+0x36>
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d04648:	6880      	ldr	r0, [r0, #8]
c0d0464a:	f7fe f9a1 	bl	c0d02990 <pic>
c0d0464e:	4602      	mov	r2, r0
c0d04650:	4620      	mov	r0, r4
c0d04652:	4629      	mov	r1, r5
c0d04654:	4790      	blx	r2
    }
    USBD_CtlSendStatus(pdev);
c0d04656:	4620      	mov	r0, r4
c0d04658:	f000 fa69 	bl	c0d04b2e <USBD_CtlSendStatus>
  }

}
c0d0465c:	bdb0      	pop	{r4, r5, r7, pc}

c0d0465e <USBD_ClrFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_ClrFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d0465e:	b5b0      	push	{r4, r5, r7, lr}
c0d04660:	460d      	mov	r5, r1
c0d04662:	4604      	mov	r4, r0
  switch (pdev->dev_state)
c0d04664:	20fc      	movs	r0, #252	; 0xfc
c0d04666:	5c20      	ldrb	r0, [r4, r0]
c0d04668:	21fe      	movs	r1, #254	; 0xfe
c0d0466a:	4001      	ands	r1, r0
c0d0466c:	2902      	cmp	r1, #2
c0d0466e:	d11b      	bne.n	c0d046a8 <USBD_ClrFeature+0x4a>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
c0d04670:	8868      	ldrh	r0, [r5, #2]
c0d04672:	2801      	cmp	r0, #1
c0d04674:	d11c      	bne.n	c0d046b0 <USBD_ClrFeature+0x52>
    {
      pdev->dev_remote_wakeup = 0; 
c0d04676:	2041      	movs	r0, #65	; 0x41
c0d04678:	0080      	lsls	r0, r0, #2
c0d0467a:	2100      	movs	r1, #0
c0d0467c:	5021      	str	r1, [r4, r0]
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d0467e:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d04680:	2802      	cmp	r0, #2
c0d04682:	d80d      	bhi.n	c0d046a0 <USBD_ClrFeature+0x42>
c0d04684:	00c0      	lsls	r0, r0, #3
c0d04686:	1820      	adds	r0, r4, r0
c0d04688:	2145      	movs	r1, #69	; 0x45
c0d0468a:	0089      	lsls	r1, r1, #2
c0d0468c:	5840      	ldr	r0, [r0, r1]
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
    {
      pdev->dev_remote_wakeup = 0; 
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d0468e:	2800      	cmp	r0, #0
c0d04690:	d006      	beq.n	c0d046a0 <USBD_ClrFeature+0x42>
        ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d04692:	6880      	ldr	r0, [r0, #8]
c0d04694:	f7fe f97c 	bl	c0d02990 <pic>
c0d04698:	4602      	mov	r2, r0
c0d0469a:	4620      	mov	r0, r4
c0d0469c:	4629      	mov	r1, r5
c0d0469e:	4790      	blx	r2
      }
      USBD_CtlSendStatus(pdev);
c0d046a0:	4620      	mov	r0, r4
c0d046a2:	f000 fa44 	bl	c0d04b2e <USBD_CtlSendStatus>
    
  default :
     USBD_CtlError(pdev , req);
    break;
  }
}
c0d046a6:	bdb0      	pop	{r4, r5, r7, pc}
      USBD_CtlSendStatus(pdev);
    }
    break;
    
  default :
     USBD_CtlError(pdev , req);
c0d046a8:	4620      	mov	r0, r4
c0d046aa:	4629      	mov	r1, r5
c0d046ac:	f000 f801 	bl	c0d046b2 <USBD_CtlError>
    break;
  }
}
c0d046b0:	bdb0      	pop	{r4, r5, r7, pc}

c0d046b2 <USBD_CtlError>:
  USBD_LL_StallEP(pdev , 0);
}

__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
c0d046b2:	b510      	push	{r4, lr}
c0d046b4:	4604      	mov	r4, r0
* @param  req: usb request
* @retval None
*/
void USBD_CtlStall( USBD_HandleTypeDef *pdev)
{
  USBD_LL_StallEP(pdev , 0x80);
c0d046b6:	2180      	movs	r1, #128	; 0x80
c0d046b8:	f7ff fbe6 	bl	c0d03e88 <USBD_LL_StallEP>
  USBD_LL_StallEP(pdev , 0);
c0d046bc:	2100      	movs	r1, #0
c0d046be:	4620      	mov	r0, r4
c0d046c0:	f7ff fbe2 	bl	c0d03e88 <USBD_LL_StallEP>
__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
  UNUSED(req);
  USBD_CtlStall(pdev);
}
c0d046c4:	bd10      	pop	{r4, pc}

c0d046c6 <USBD_StdItfReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdItfReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d046c6:	b5b0      	push	{r4, r5, r7, lr}
c0d046c8:	460d      	mov	r5, r1
c0d046ca:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  
  switch (pdev->dev_state) 
c0d046cc:	20fc      	movs	r0, #252	; 0xfc
c0d046ce:	5c20      	ldrb	r0, [r4, r0]
c0d046d0:	2803      	cmp	r0, #3
c0d046d2:	d117      	bne.n	c0d04704 <USBD_StdItfReq+0x3e>
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d046d4:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d046d6:	2802      	cmp	r0, #2
c0d046d8:	d814      	bhi.n	c0d04704 <USBD_StdItfReq+0x3e>
c0d046da:	00c0      	lsls	r0, r0, #3
c0d046dc:	1820      	adds	r0, r4, r0
c0d046de:	2145      	movs	r1, #69	; 0x45
c0d046e0:	0089      	lsls	r1, r1, #2
c0d046e2:	5840      	ldr	r0, [r0, r1]
  
  switch (pdev->dev_state) 
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d046e4:	2800      	cmp	r0, #0
c0d046e6:	d00d      	beq.n	c0d04704 <USBD_StdItfReq+0x3e>
    {
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d046e8:	6880      	ldr	r0, [r0, #8]
c0d046ea:	f7fe f951 	bl	c0d02990 <pic>
c0d046ee:	4602      	mov	r2, r0
c0d046f0:	4620      	mov	r0, r4
c0d046f2:	4629      	mov	r1, r5
c0d046f4:	4790      	blx	r2
      
      if((req->wLength == 0)&& (ret == USBD_OK))
c0d046f6:	88e8      	ldrh	r0, [r5, #6]
c0d046f8:	2800      	cmp	r0, #0
c0d046fa:	d107      	bne.n	c0d0470c <USBD_StdItfReq+0x46>
      {
         USBD_CtlSendStatus(pdev);
c0d046fc:	4620      	mov	r0, r4
c0d046fe:	f000 fa16 	bl	c0d04b2e <USBD_CtlSendStatus>
c0d04702:	e003      	b.n	c0d0470c <USBD_StdItfReq+0x46>
c0d04704:	4620      	mov	r0, r4
c0d04706:	4629      	mov	r1, r5
c0d04708:	f7ff ffd3 	bl	c0d046b2 <USBD_CtlError>
    
  default:
     USBD_CtlError(pdev , req);
    break;
  }
  return USBD_OK;
c0d0470c:	2000      	movs	r0, #0
c0d0470e:	bdb0      	pop	{r4, r5, r7, pc}

c0d04710 <USBD_StdEPReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdEPReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d04710:	b570      	push	{r4, r5, r6, lr}
c0d04712:	460d      	mov	r5, r1
c0d04714:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d04716:	7828      	ldrb	r0, [r5, #0]
c0d04718:	2160      	movs	r1, #96	; 0x60
c0d0471a:	4001      	ands	r1, r0
{
  
  uint8_t   ep_addr;
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
c0d0471c:	792e      	ldrb	r6, [r5, #4]
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d0471e:	2920      	cmp	r1, #32
c0d04720:	d110      	bne.n	c0d04744 <USBD_StdEPReq+0x34>
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d04722:	2e02      	cmp	r6, #2
c0d04724:	d80e      	bhi.n	c0d04744 <USBD_StdEPReq+0x34>
c0d04726:	00f0      	lsls	r0, r6, #3
c0d04728:	1820      	adds	r0, r4, r0
c0d0472a:	2145      	movs	r1, #69	; 0x45
c0d0472c:	0089      	lsls	r1, r1, #2
c0d0472e:	5840      	ldr	r0, [r0, r1]
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d04730:	2800      	cmp	r0, #0
c0d04732:	d007      	beq.n	c0d04744 <USBD_StdEPReq+0x34>
  {
    ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d04734:	6880      	ldr	r0, [r0, #8]
c0d04736:	f7fe f92b 	bl	c0d02990 <pic>
c0d0473a:	4602      	mov	r2, r0
c0d0473c:	4620      	mov	r0, r4
c0d0473e:	4629      	mov	r1, r5
c0d04740:	4790      	blx	r2
c0d04742:	e06e      	b.n	c0d04822 <USBD_StdEPReq+0x112>
    
    return USBD_OK;
  }
  
  switch (req->bRequest) 
c0d04744:	7868      	ldrb	r0, [r5, #1]
c0d04746:	2800      	cmp	r0, #0
c0d04748:	d017      	beq.n	c0d0477a <USBD_StdEPReq+0x6a>
c0d0474a:	2801      	cmp	r0, #1
c0d0474c:	d01e      	beq.n	c0d0478c <USBD_StdEPReq+0x7c>
c0d0474e:	2803      	cmp	r0, #3
c0d04750:	d167      	bne.n	c0d04822 <USBD_StdEPReq+0x112>
  {
    
  case USB_REQ_SET_FEATURE :
    
    switch (pdev->dev_state) 
c0d04752:	20fc      	movs	r0, #252	; 0xfc
c0d04754:	5c20      	ldrb	r0, [r4, r0]
c0d04756:	2803      	cmp	r0, #3
c0d04758:	d11c      	bne.n	c0d04794 <USBD_StdEPReq+0x84>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d0475a:	8868      	ldrh	r0, [r5, #2]
c0d0475c:	2800      	cmp	r0, #0
c0d0475e:	d108      	bne.n	c0d04772 <USBD_StdEPReq+0x62>
      {
        if ((ep_addr != 0x00) && (ep_addr != 0x80)) 
c0d04760:	2080      	movs	r0, #128	; 0x80
c0d04762:	4330      	orrs	r0, r6
c0d04764:	2880      	cmp	r0, #128	; 0x80
c0d04766:	d004      	beq.n	c0d04772 <USBD_StdEPReq+0x62>
        { 
          USBD_LL_StallEP(pdev , ep_addr);
c0d04768:	4620      	mov	r0, r4
c0d0476a:	4631      	mov	r1, r6
c0d0476c:	f7ff fb8c 	bl	c0d03e88 <USBD_LL_StallEP>
          
        }
c0d04770:	792e      	ldrb	r6, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d04772:	2e02      	cmp	r6, #2
c0d04774:	d852      	bhi.n	c0d0481c <USBD_StdEPReq+0x10c>
c0d04776:	00f0      	lsls	r0, r6, #3
c0d04778:	e043      	b.n	c0d04802 <USBD_StdEPReq+0xf2>
      break;    
    }
    break;
    
  case USB_REQ_GET_STATUS:                  
    switch (pdev->dev_state) 
c0d0477a:	20fc      	movs	r0, #252	; 0xfc
c0d0477c:	5c20      	ldrb	r0, [r4, r0]
c0d0477e:	2803      	cmp	r0, #3
c0d04780:	d018      	beq.n	c0d047b4 <USBD_StdEPReq+0xa4>
c0d04782:	2802      	cmp	r0, #2
c0d04784:	d111      	bne.n	c0d047aa <USBD_StdEPReq+0x9a>
    {
    case USBD_STATE_ADDRESSED:          
      if ((ep_addr & 0x7F) != 0x00) 
c0d04786:	0670      	lsls	r0, r6, #25
c0d04788:	d10a      	bne.n	c0d047a0 <USBD_StdEPReq+0x90>
c0d0478a:	e04a      	b.n	c0d04822 <USBD_StdEPReq+0x112>
    }
    break;
    
  case USB_REQ_CLEAR_FEATURE :
    
    switch (pdev->dev_state) 
c0d0478c:	20fc      	movs	r0, #252	; 0xfc
c0d0478e:	5c20      	ldrb	r0, [r4, r0]
c0d04790:	2803      	cmp	r0, #3
c0d04792:	d029      	beq.n	c0d047e8 <USBD_StdEPReq+0xd8>
c0d04794:	2802      	cmp	r0, #2
c0d04796:	d108      	bne.n	c0d047aa <USBD_StdEPReq+0x9a>
c0d04798:	2080      	movs	r0, #128	; 0x80
c0d0479a:	4330      	orrs	r0, r6
c0d0479c:	2880      	cmp	r0, #128	; 0x80
c0d0479e:	d040      	beq.n	c0d04822 <USBD_StdEPReq+0x112>
c0d047a0:	4620      	mov	r0, r4
c0d047a2:	4631      	mov	r1, r6
c0d047a4:	f7ff fb70 	bl	c0d03e88 <USBD_LL_StallEP>
c0d047a8:	e03b      	b.n	c0d04822 <USBD_StdEPReq+0x112>
c0d047aa:	4620      	mov	r0, r4
c0d047ac:	4629      	mov	r1, r5
c0d047ae:	f7ff ff80 	bl	c0d046b2 <USBD_CtlError>
c0d047b2:	e036      	b.n	c0d04822 <USBD_StdEPReq+0x112>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d047b4:	4625      	mov	r5, r4
c0d047b6:	3514      	adds	r5, #20
                                         &pdev->ep_out[ep_addr & 0x7F];
c0d047b8:	4620      	mov	r0, r4
c0d047ba:	3084      	adds	r0, #132	; 0x84
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d047bc:	2180      	movs	r1, #128	; 0x80
c0d047be:	420e      	tst	r6, r1
c0d047c0:	d100      	bne.n	c0d047c4 <USBD_StdEPReq+0xb4>
c0d047c2:	4605      	mov	r5, r0
                                         &pdev->ep_out[ep_addr & 0x7F];
      if(USBD_LL_IsStallEP(pdev, ep_addr))
c0d047c4:	4620      	mov	r0, r4
c0d047c6:	4631      	mov	r1, r6
c0d047c8:	f7ff fba8 	bl	c0d03f1c <USBD_LL_IsStallEP>
c0d047cc:	2101      	movs	r1, #1
c0d047ce:	2800      	cmp	r0, #0
c0d047d0:	d100      	bne.n	c0d047d4 <USBD_StdEPReq+0xc4>
c0d047d2:	4601      	mov	r1, r0
c0d047d4:	207f      	movs	r0, #127	; 0x7f
c0d047d6:	4006      	ands	r6, r0
c0d047d8:	0130      	lsls	r0, r6, #4
c0d047da:	5029      	str	r1, [r5, r0]
c0d047dc:	1829      	adds	r1, r5, r0
      else
      {
        pep->status = 0x0000;  
      }
      
      USBD_CtlSendData (pdev,
c0d047de:	2202      	movs	r2, #2
c0d047e0:	4620      	mov	r0, r4
c0d047e2:	f000 f979 	bl	c0d04ad8 <USBD_CtlSendData>
c0d047e6:	e01c      	b.n	c0d04822 <USBD_StdEPReq+0x112>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d047e8:	8868      	ldrh	r0, [r5, #2]
c0d047ea:	2800      	cmp	r0, #0
c0d047ec:	d119      	bne.n	c0d04822 <USBD_StdEPReq+0x112>
      {
        if ((ep_addr & 0x7F) != 0x00) 
c0d047ee:	0670      	lsls	r0, r6, #25
c0d047f0:	d014      	beq.n	c0d0481c <USBD_StdEPReq+0x10c>
        {        
          USBD_LL_ClearStallEP(pdev , ep_addr);
c0d047f2:	4620      	mov	r0, r4
c0d047f4:	4631      	mov	r1, r6
c0d047f6:	f7ff fb6d 	bl	c0d03ed4 <USBD_LL_ClearStallEP>
          if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d047fa:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d047fc:	2802      	cmp	r0, #2
c0d047fe:	d80d      	bhi.n	c0d0481c <USBD_StdEPReq+0x10c>
c0d04800:	00c0      	lsls	r0, r0, #3
c0d04802:	1820      	adds	r0, r4, r0
c0d04804:	2145      	movs	r1, #69	; 0x45
c0d04806:	0089      	lsls	r1, r1, #2
c0d04808:	5840      	ldr	r0, [r0, r1]
c0d0480a:	2800      	cmp	r0, #0
c0d0480c:	d006      	beq.n	c0d0481c <USBD_StdEPReq+0x10c>
c0d0480e:	6880      	ldr	r0, [r0, #8]
c0d04810:	f7fe f8be 	bl	c0d02990 <pic>
c0d04814:	4602      	mov	r2, r0
c0d04816:	4620      	mov	r0, r4
c0d04818:	4629      	mov	r1, r5
c0d0481a:	4790      	blx	r2
c0d0481c:	4620      	mov	r0, r4
c0d0481e:	f000 f986 	bl	c0d04b2e <USBD_CtlSendStatus>
    
  default:
    break;
  }
  return ret;
}
c0d04822:	2000      	movs	r0, #0
c0d04824:	bd70      	pop	{r4, r5, r6, pc}

c0d04826 <USBD_ParseSetupRequest>:
* @retval None
*/

void USBD_ParseSetupRequest(USBD_SetupReqTypedef *req, uint8_t *pdata)
{
  req->bmRequest     = *(uint8_t *)  (pdata);
c0d04826:	780a      	ldrb	r2, [r1, #0]
c0d04828:	7002      	strb	r2, [r0, #0]
  req->bRequest      = *(uint8_t *)  (pdata +  1);
c0d0482a:	784a      	ldrb	r2, [r1, #1]
c0d0482c:	7042      	strb	r2, [r0, #1]
  req->wValue        = SWAPBYTE      (pdata +  2);
c0d0482e:	788a      	ldrb	r2, [r1, #2]
c0d04830:	78cb      	ldrb	r3, [r1, #3]
c0d04832:	021b      	lsls	r3, r3, #8
c0d04834:	4313      	orrs	r3, r2
c0d04836:	8043      	strh	r3, [r0, #2]
  req->wIndex        = SWAPBYTE      (pdata +  4);
c0d04838:	790a      	ldrb	r2, [r1, #4]
c0d0483a:	794b      	ldrb	r3, [r1, #5]
c0d0483c:	021b      	lsls	r3, r3, #8
c0d0483e:	4313      	orrs	r3, r2
c0d04840:	8083      	strh	r3, [r0, #4]
  req->wLength       = SWAPBYTE      (pdata +  6);
c0d04842:	798a      	ldrb	r2, [r1, #6]
c0d04844:	79c9      	ldrb	r1, [r1, #7]
c0d04846:	0209      	lsls	r1, r1, #8
c0d04848:	4311      	orrs	r1, r2
c0d0484a:	80c1      	strh	r1, [r0, #6]

}
c0d0484c:	4770      	bx	lr

c0d0484e <USBD_HID_Setup>:
  * @param  req: usb requests
  * @retval status
  */
uint8_t  USBD_HID_Setup (USBD_HandleTypeDef *pdev, 
                                USBD_SetupReqTypedef *req)
{
c0d0484e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04850:	b083      	sub	sp, #12
c0d04852:	460d      	mov	r5, r1
c0d04854:	4604      	mov	r4, r0
c0d04856:	a802      	add	r0, sp, #8
c0d04858:	2700      	movs	r7, #0
  uint16_t len = 0;
c0d0485a:	8007      	strh	r7, [r0, #0]
c0d0485c:	a801      	add	r0, sp, #4
  uint8_t  *pbuf = NULL;

  uint8_t val = 0;
c0d0485e:	7007      	strb	r7, [r0, #0]

  switch (req->bmRequest & USB_REQ_TYPE_MASK)
c0d04860:	7829      	ldrb	r1, [r5, #0]
c0d04862:	2060      	movs	r0, #96	; 0x60
c0d04864:	4008      	ands	r0, r1
c0d04866:	2800      	cmp	r0, #0
c0d04868:	d010      	beq.n	c0d0488c <USBD_HID_Setup+0x3e>
c0d0486a:	2820      	cmp	r0, #32
c0d0486c:	d138      	bne.n	c0d048e0 <USBD_HID_Setup+0x92>
c0d0486e:	7868      	ldrb	r0, [r5, #1]
  {
  case USB_REQ_TYPE_CLASS :  
    switch (req->bRequest)
c0d04870:	4601      	mov	r1, r0
c0d04872:	390a      	subs	r1, #10
c0d04874:	2902      	cmp	r1, #2
c0d04876:	d333      	bcc.n	c0d048e0 <USBD_HID_Setup+0x92>
c0d04878:	2802      	cmp	r0, #2
c0d0487a:	d01c      	beq.n	c0d048b6 <USBD_HID_Setup+0x68>
c0d0487c:	2803      	cmp	r0, #3
c0d0487e:	d01a      	beq.n	c0d048b6 <USBD_HID_Setup+0x68>
                        (uint8_t *)&val,
                        1);      
      break;      
      
    default:
      USBD_CtlError (pdev, req);
c0d04880:	4620      	mov	r0, r4
c0d04882:	4629      	mov	r1, r5
c0d04884:	f7ff ff15 	bl	c0d046b2 <USBD_CtlError>
c0d04888:	2702      	movs	r7, #2
c0d0488a:	e029      	b.n	c0d048e0 <USBD_HID_Setup+0x92>
      return USBD_FAIL; 
    }
    break;
    
  case USB_REQ_TYPE_STANDARD:
    switch (req->bRequest)
c0d0488c:	7868      	ldrb	r0, [r5, #1]
c0d0488e:	280b      	cmp	r0, #11
c0d04890:	d014      	beq.n	c0d048bc <USBD_HID_Setup+0x6e>
c0d04892:	280a      	cmp	r0, #10
c0d04894:	d00f      	beq.n	c0d048b6 <USBD_HID_Setup+0x68>
c0d04896:	2806      	cmp	r0, #6
c0d04898:	d122      	bne.n	c0d048e0 <USBD_HID_Setup+0x92>
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
c0d0489a:	8868      	ldrh	r0, [r5, #2]
c0d0489c:	0a00      	lsrs	r0, r0, #8
c0d0489e:	2700      	movs	r7, #0
c0d048a0:	2821      	cmp	r0, #33	; 0x21
c0d048a2:	d00f      	beq.n	c0d048c4 <USBD_HID_Setup+0x76>
c0d048a4:	2822      	cmp	r0, #34	; 0x22
      
      //USBD_CtlReceiveStatus(pdev);
      
      USBD_CtlSendData (pdev, 
                        pbuf,
                        len);
c0d048a6:	463a      	mov	r2, r7
c0d048a8:	4639      	mov	r1, r7
c0d048aa:	d116      	bne.n	c0d048da <USBD_HID_Setup+0x8c>
c0d048ac:	ae02      	add	r6, sp, #8
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
      {
        pbuf =  USBD_HID_GetReportDescriptor_impl(&len);
c0d048ae:	4630      	mov	r0, r6
c0d048b0:	f000 f852 	bl	c0d04958 <USBD_HID_GetReportDescriptor_impl>
c0d048b4:	e00a      	b.n	c0d048cc <USBD_HID_Setup+0x7e>
c0d048b6:	a901      	add	r1, sp, #4
c0d048b8:	2201      	movs	r2, #1
c0d048ba:	e00e      	b.n	c0d048da <USBD_HID_Setup+0x8c>
                        len);
      break;

    case USB_REQ_SET_INTERFACE :
      //hhid->AltSetting = (uint8_t)(req->wValue);
      USBD_CtlSendStatus(pdev);
c0d048bc:	4620      	mov	r0, r4
c0d048be:	f000 f936 	bl	c0d04b2e <USBD_CtlSendStatus>
c0d048c2:	e00d      	b.n	c0d048e0 <USBD_HID_Setup+0x92>
c0d048c4:	ae02      	add	r6, sp, #8
        len = MIN(len , req->wLength);
      }
      // 0x21
      else if( req->wValue >> 8 == HID_DESCRIPTOR_TYPE)
      {
        pbuf = USBD_HID_GetHidDescriptor_impl(&len);
c0d048c6:	4630      	mov	r0, r6
c0d048c8:	f000 f832 	bl	c0d04930 <USBD_HID_GetHidDescriptor_impl>
c0d048cc:	4601      	mov	r1, r0
c0d048ce:	8832      	ldrh	r2, [r6, #0]
c0d048d0:	88e8      	ldrh	r0, [r5, #6]
c0d048d2:	4282      	cmp	r2, r0
c0d048d4:	d300      	bcc.n	c0d048d8 <USBD_HID_Setup+0x8a>
c0d048d6:	4602      	mov	r2, r0
c0d048d8:	8032      	strh	r2, [r6, #0]
c0d048da:	4620      	mov	r0, r4
c0d048dc:	f000 f8fc 	bl	c0d04ad8 <USBD_CtlSendData>
      
    }
  }

  return USBD_OK;
}
c0d048e0:	b2f8      	uxtb	r0, r7
c0d048e2:	b003      	add	sp, #12
c0d048e4:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d048e6 <USBD_HID_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d048e6:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d048e8:	b081      	sub	sp, #4
c0d048ea:	4604      	mov	r4, r0
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d048ec:	2182      	movs	r1, #130	; 0x82
c0d048ee:	2603      	movs	r6, #3
c0d048f0:	2540      	movs	r5, #64	; 0x40
c0d048f2:	4632      	mov	r2, r6
c0d048f4:	462b      	mov	r3, r5
c0d048f6:	f7ff fa8b 	bl	c0d03e10 <USBD_LL_OpenEP>
c0d048fa:	2702      	movs	r7, #2
                 HID_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d048fc:	4620      	mov	r0, r4
c0d048fe:	4639      	mov	r1, r7
c0d04900:	4632      	mov	r2, r6
c0d04902:	462b      	mov	r3, r5
c0d04904:	f7ff fa84 	bl	c0d03e10 <USBD_LL_OpenEP>
                 HID_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR, HID_EPOUT_SIZE);
c0d04908:	4620      	mov	r0, r4
c0d0490a:	4639      	mov	r1, r7
c0d0490c:	462a      	mov	r2, r5
c0d0490e:	f7ff fb42 	bl	c0d03f96 <USBD_LL_PrepareReceive>
  USBD_LL_Transmit (pdev, 
                    HID_EPIN_ADDR,                                      
                    NULL,
                    0);
  */
  return USBD_OK;
c0d04912:	2000      	movs	r0, #0
c0d04914:	b001      	add	sp, #4
c0d04916:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d04918 <USBD_HID_DeInit>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_DeInit (USBD_HandleTypeDef *pdev, 
                                 uint8_t cfgidx)
{
c0d04918:	b510      	push	{r4, lr}
c0d0491a:	4604      	mov	r4, r0
  UNUSED(cfgidx);
  /* Close HID EP IN */
  USBD_LL_CloseEP(pdev,
c0d0491c:	2182      	movs	r1, #130	; 0x82
c0d0491e:	f7ff fa9d 	bl	c0d03e5c <USBD_LL_CloseEP>
                  HID_EPIN_ADDR);
  
  /* Close HID EP OUT */
  USBD_LL_CloseEP(pdev,
c0d04922:	2102      	movs	r1, #2
c0d04924:	4620      	mov	r0, r4
c0d04926:	f7ff fa99 	bl	c0d03e5c <USBD_LL_CloseEP>
                  HID_EPOUT_ADDR);
  
  return USBD_OK;
c0d0492a:	2000      	movs	r0, #0
c0d0492c:	bd10      	pop	{r4, pc}
	...

c0d04930 <USBD_HID_GetHidDescriptor_impl>:
{
  *length = sizeof (USBD_CfgDesc);
  return (uint8_t*)USBD_CfgDesc;
}

uint8_t* USBD_HID_GetHidDescriptor_impl(uint16_t* len) {
c0d04930:	4601      	mov	r1, r0
  switch (USBD_Device.request.wIndex&0xFF) {
c0d04932:	2043      	movs	r0, #67	; 0x43
c0d04934:	0080      	lsls	r0, r0, #2
c0d04936:	4a06      	ldr	r2, [pc, #24]	; (c0d04950 <USBD_HID_GetHidDescriptor_impl+0x20>)
c0d04938:	5c12      	ldrb	r2, [r2, r0]
      *len = sizeof(USBD_HID_Desc_fido);
      return (uint8_t*)USBD_HID_Desc_fido; 
#endif // HAVE_IO_U2F
    case HID_INTF:
      *len = sizeof(USBD_HID_Desc);
      return (uint8_t*)USBD_HID_Desc; 
c0d0493a:	2309      	movs	r3, #9
c0d0493c:	2000      	movs	r0, #0
c0d0493e:	2a00      	cmp	r2, #0
c0d04940:	d000      	beq.n	c0d04944 <USBD_HID_GetHidDescriptor_impl+0x14>
c0d04942:	4603      	mov	r3, r0
    case U2F_INTF:
      *len = sizeof(USBD_HID_Desc_fido);
      return (uint8_t*)USBD_HID_Desc_fido; 
#endif // HAVE_IO_U2F
    case HID_INTF:
      *len = sizeof(USBD_HID_Desc);
c0d04944:	800b      	strh	r3, [r1, #0]
      return (uint8_t*)USBD_HID_Desc; 
c0d04946:	2a00      	cmp	r2, #0
c0d04948:	d101      	bne.n	c0d0494e <USBD_HID_GetHidDescriptor_impl+0x1e>
c0d0494a:	4802      	ldr	r0, [pc, #8]	; (c0d04954 <USBD_HID_GetHidDescriptor_impl+0x24>)
c0d0494c:	4478      	add	r0, pc
  }
  *len = 0;
  return 0;
}
c0d0494e:	4770      	bx	lr
c0d04950:	20001f38 	.word	0x20001f38
c0d04954:	000012c0 	.word	0x000012c0

c0d04958 <USBD_HID_GetReportDescriptor_impl>:

uint8_t* USBD_HID_GetReportDescriptor_impl(uint16_t* len) {
c0d04958:	4601      	mov	r1, r0
  switch (USBD_Device.request.wIndex&0xFF) {
c0d0495a:	2043      	movs	r0, #67	; 0x43
c0d0495c:	0080      	lsls	r0, r0, #2
c0d0495e:	4a06      	ldr	r2, [pc, #24]	; (c0d04978 <USBD_HID_GetReportDescriptor_impl+0x20>)
c0d04960:	5c12      	ldrb	r2, [r2, r0]
    *len = sizeof(HID_ReportDesc_fido);
    return (uint8_t*)HID_ReportDesc_fido;
#endif // HAVE_IO_U2F
  case HID_INTF:
    *len = sizeof(HID_ReportDesc);
    return (uint8_t*)HID_ReportDesc;
c0d04962:	2322      	movs	r3, #34	; 0x22
c0d04964:	2000      	movs	r0, #0
c0d04966:	2a00      	cmp	r2, #0
c0d04968:	d000      	beq.n	c0d0496c <USBD_HID_GetReportDescriptor_impl+0x14>
c0d0496a:	4603      	mov	r3, r0

    *len = sizeof(HID_ReportDesc_fido);
    return (uint8_t*)HID_ReportDesc_fido;
#endif // HAVE_IO_U2F
  case HID_INTF:
    *len = sizeof(HID_ReportDesc);
c0d0496c:	800b      	strh	r3, [r1, #0]
    return (uint8_t*)HID_ReportDesc;
c0d0496e:	2a00      	cmp	r2, #0
c0d04970:	d101      	bne.n	c0d04976 <USBD_HID_GetReportDescriptor_impl+0x1e>
c0d04972:	4802      	ldr	r0, [pc, #8]	; (c0d0497c <USBD_HID_GetReportDescriptor_impl+0x24>)
c0d04974:	4478      	add	r0, pc
  }
  *len = 0;
  return 0;
}
c0d04976:	4770      	bx	lr
c0d04978:	20001f38 	.word	0x20001f38
c0d0497c:	000012a1 	.word	0x000012a1

c0d04980 <USBD_HID_DataIn_impl>:
}
#endif // HAVE_IO_U2F

uint8_t  USBD_HID_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d04980:	b580      	push	{r7, lr}
  UNUSED(pdev);
  switch (epnum) {
c0d04982:	2902      	cmp	r1, #2
c0d04984:	d103      	bne.n	c0d0498e <USBD_HID_DataIn_impl+0xe>
    // HID gen endpoint
    case (HID_EPIN_ADDR&0x7F):
      io_usb_hid_sent(io_usb_send_apdu_data);
c0d04986:	4803      	ldr	r0, [pc, #12]	; (c0d04994 <USBD_HID_DataIn_impl+0x14>)
c0d04988:	4478      	add	r0, pc
c0d0498a:	f7fd f967 	bl	c0d01c5c <io_usb_hid_sent>
      break;
  }

  return USBD_OK;
c0d0498e:	2000      	movs	r0, #0
c0d04990:	bd80      	pop	{r7, pc}
c0d04992:	46c0      	nop			; (mov r8, r8)
c0d04994:	ffffd579 	.word	0xffffd579

c0d04998 <USBD_HID_DataOut_impl>:
}

uint8_t  USBD_HID_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d04998:	b5b0      	push	{r4, r5, r7, lr}
c0d0499a:	4614      	mov	r4, r2
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d0499c:	2902      	cmp	r1, #2
c0d0499e:	d11b      	bne.n	c0d049d8 <USBD_HID_DataOut_impl+0x40>

  // HID gen endpoint
  case (HID_EPOUT_ADDR&0x7F):
    // prepare receiving the next chunk (masked time)
    USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR , HID_EPOUT_SIZE);
c0d049a0:	2102      	movs	r1, #2
c0d049a2:	2240      	movs	r2, #64	; 0x40
c0d049a4:	f7ff faf7 	bl	c0d03f96 <USBD_LL_PrepareReceive>

    // avoid troubles when an apdu has not been replied yet
    if (G_io_apdu_media == IO_APDU_MEDIA_NONE) {      
c0d049a8:	4d0c      	ldr	r5, [pc, #48]	; (c0d049dc <USBD_HID_DataOut_impl+0x44>)
c0d049aa:	7828      	ldrb	r0, [r5, #0]
c0d049ac:	2800      	cmp	r0, #0
c0d049ae:	d113      	bne.n	c0d049d8 <USBD_HID_DataOut_impl+0x40>
      // add to the hid transport
      switch(io_usb_hid_receive(io_usb_send_apdu_data, buffer, io_seproxyhal_get_ep_rx_size(HID_EPOUT_ADDR))) {
c0d049b0:	2002      	movs	r0, #2
c0d049b2:	f7fd fa45 	bl	c0d01e40 <io_seproxyhal_get_ep_rx_size>
c0d049b6:	4602      	mov	r2, r0
c0d049b8:	480c      	ldr	r0, [pc, #48]	; (c0d049ec <USBD_HID_DataOut_impl+0x54>)
c0d049ba:	4478      	add	r0, pc
c0d049bc:	4621      	mov	r1, r4
c0d049be:	f7fd f879 	bl	c0d01ab4 <io_usb_hid_receive>
c0d049c2:	2802      	cmp	r0, #2
c0d049c4:	d108      	bne.n	c0d049d8 <USBD_HID_DataOut_impl+0x40>
        default:
          break;

        case IO_USB_APDU_RECEIVED:
          G_io_apdu_media = IO_APDU_MEDIA_USB_HID; // for application code
c0d049c6:	2001      	movs	r0, #1
c0d049c8:	7028      	strb	r0, [r5, #0]
          G_io_apdu_state = APDU_USB_HID; // for next call to io_exchange
c0d049ca:	4805      	ldr	r0, [pc, #20]	; (c0d049e0 <USBD_HID_DataOut_impl+0x48>)
c0d049cc:	2107      	movs	r1, #7
c0d049ce:	7001      	strb	r1, [r0, #0]
          G_io_apdu_length = G_io_usb_hid_total_length;
c0d049d0:	4804      	ldr	r0, [pc, #16]	; (c0d049e4 <USBD_HID_DataOut_impl+0x4c>)
c0d049d2:	6800      	ldr	r0, [r0, #0]
c0d049d4:	4904      	ldr	r1, [pc, #16]	; (c0d049e8 <USBD_HID_DataOut_impl+0x50>)
c0d049d6:	8008      	strh	r0, [r1, #0]
      }
    }
    break;
  }

  return USBD_OK;
c0d049d8:	2000      	movs	r0, #0
c0d049da:	bdb0      	pop	{r4, r5, r7, pc}
c0d049dc:	20001e7c 	.word	0x20001e7c
c0d049e0:	20001e92 	.word	0x20001e92
c0d049e4:	20001d68 	.word	0x20001d68
c0d049e8:	20001e94 	.word	0x20001e94
c0d049ec:	ffffd547 	.word	0xffffd547

c0d049f0 <USBD_DeviceDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_DeviceDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_DeviceDesc);
c0d049f0:	2012      	movs	r0, #18
c0d049f2:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_DeviceDesc;
c0d049f4:	4801      	ldr	r0, [pc, #4]	; (c0d049fc <USBD_DeviceDescriptor+0xc>)
c0d049f6:	4478      	add	r0, pc
c0d049f8:	4770      	bx	lr
c0d049fa:	46c0      	nop			; (mov r8, r8)
c0d049fc:	0000129a 	.word	0x0000129a

c0d04a00 <USBD_LangIDStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_LangIDStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_LangIDDesc);  
c0d04a00:	2004      	movs	r0, #4
c0d04a02:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_LangIDDesc;
c0d04a04:	4801      	ldr	r0, [pc, #4]	; (c0d04a0c <USBD_LangIDStrDescriptor+0xc>)
c0d04a06:	4478      	add	r0, pc
c0d04a08:	4770      	bx	lr
c0d04a0a:	46c0      	nop			; (mov r8, r8)
c0d04a0c:	0000129c 	.word	0x0000129c

c0d04a10 <USBD_ManufacturerStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ManufacturerStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_MANUFACTURER_STRING);
c0d04a10:	200e      	movs	r0, #14
c0d04a12:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_MANUFACTURER_STRING;
c0d04a14:	4801      	ldr	r0, [pc, #4]	; (c0d04a1c <USBD_ManufacturerStrDescriptor+0xc>)
c0d04a16:	4478      	add	r0, pc
c0d04a18:	4770      	bx	lr
c0d04a1a:	46c0      	nop			; (mov r8, r8)
c0d04a1c:	00001290 	.word	0x00001290

c0d04a20 <USBD_ProductStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ProductStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_PRODUCT_FS_STRING);
c0d04a20:	200e      	movs	r0, #14
c0d04a22:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_PRODUCT_FS_STRING;
c0d04a24:	4801      	ldr	r0, [pc, #4]	; (c0d04a2c <USBD_ProductStrDescriptor+0xc>)
c0d04a26:	4478      	add	r0, pc
c0d04a28:	4770      	bx	lr
c0d04a2a:	46c0      	nop			; (mov r8, r8)
c0d04a2c:	0000128e 	.word	0x0000128e

c0d04a30 <USBD_SerialStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_SerialStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USB_SERIAL_STRING);
c0d04a30:	200a      	movs	r0, #10
c0d04a32:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USB_SERIAL_STRING;
c0d04a34:	4801      	ldr	r0, [pc, #4]	; (c0d04a3c <USBD_SerialStrDescriptor+0xc>)
c0d04a36:	4478      	add	r0, pc
c0d04a38:	4770      	bx	lr
c0d04a3a:	46c0      	nop			; (mov r8, r8)
c0d04a3c:	0000128c 	.word	0x0000128c

c0d04a40 <USBD_ConfigStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ConfigStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_CONFIGURATION_FS_STRING);
c0d04a40:	200e      	movs	r0, #14
c0d04a42:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_CONFIGURATION_FS_STRING;
c0d04a44:	4801      	ldr	r0, [pc, #4]	; (c0d04a4c <USBD_ConfigStrDescriptor+0xc>)
c0d04a46:	4478      	add	r0, pc
c0d04a48:	4770      	bx	lr
c0d04a4a:	46c0      	nop			; (mov r8, r8)
c0d04a4c:	0000126e 	.word	0x0000126e

c0d04a50 <USBD_InterfaceStrDescriptor>:
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_InterfaceStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
  UNUSED(speed);
  *length = sizeof(USBD_INTERFACE_FS_STRING);
c0d04a50:	200e      	movs	r0, #14
c0d04a52:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_INTERFACE_FS_STRING;
c0d04a54:	4801      	ldr	r0, [pc, #4]	; (c0d04a5c <USBD_InterfaceStrDescriptor+0xc>)
c0d04a56:	4478      	add	r0, pc
c0d04a58:	4770      	bx	lr
c0d04a5a:	46c0      	nop			; (mov r8, r8)
c0d04a5c:	0000125e 	.word	0x0000125e

c0d04a60 <USB_power>:
  // nothing to do ?
  return 0;
}
#endif // HAVE_USB_CLASS_CCID

void USB_power(unsigned char enabled) {
c0d04a60:	b570      	push	{r4, r5, r6, lr}
c0d04a62:	4604      	mov	r4, r0
c0d04a64:	204d      	movs	r0, #77	; 0x4d
c0d04a66:	0085      	lsls	r5, r0, #2
  os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d04a68:	4810      	ldr	r0, [pc, #64]	; (c0d04aac <USB_power+0x4c>)
c0d04a6a:	2100      	movs	r1, #0
c0d04a6c:	462a      	mov	r2, r5
c0d04a6e:	f7fd f8cb 	bl	c0d01c08 <os_memset>

  if (enabled) {
c0d04a72:	2c00      	cmp	r4, #0
c0d04a74:	d016      	beq.n	c0d04aa4 <USB_power+0x44>
    os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d04a76:	4c0d      	ldr	r4, [pc, #52]	; (c0d04aac <USB_power+0x4c>)
c0d04a78:	2600      	movs	r6, #0
c0d04a7a:	4620      	mov	r0, r4
c0d04a7c:	4631      	mov	r1, r6
c0d04a7e:	462a      	mov	r2, r5
c0d04a80:	f7fd f8c2 	bl	c0d01c08 <os_memset>
    /* Init Device Library */
    USBD_Init(&USBD_Device, (USBD_DescriptorsTypeDef*)&HID_Desc, 0);
c0d04a84:	490a      	ldr	r1, [pc, #40]	; (c0d04ab0 <USB_power+0x50>)
c0d04a86:	4479      	add	r1, pc
c0d04a88:	4620      	mov	r0, r4
c0d04a8a:	4632      	mov	r2, r6
c0d04a8c:	f7ff fa96 	bl	c0d03fbc <USBD_Init>
    
    /* Register the HID class */
    USBD_RegisterClassForInterface(HID_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_HID);
c0d04a90:	4a08      	ldr	r2, [pc, #32]	; (c0d04ab4 <USB_power+0x54>)
c0d04a92:	447a      	add	r2, pc
c0d04a94:	4630      	mov	r0, r6
c0d04a96:	4621      	mov	r1, r4
c0d04a98:	f7ff faca 	bl	c0d04030 <USBD_RegisterClassForInterface>
    USBD_RegisterClassForInterface(WEBUSB_INTF, &USBD_Device, (USBD_ClassTypeDef*)&USBD_WEBUSB);
    USBD_LL_PrepareReceive(&USBD_Device, WEBUSB_EPOUT_ADDR , WEBUSB_EPOUT_SIZE);
#endif // HAVE_WEBUSB

    /* Start Device Process */
    USBD_Start(&USBD_Device);
c0d04a9c:	4620      	mov	r0, r4
c0d04a9e:	f7ff fad4 	bl	c0d0404a <USBD_Start>
  }
  else {
    USBD_DeInit(&USBD_Device);
  }
}
c0d04aa2:	bd70      	pop	{r4, r5, r6, pc}

    /* Start Device Process */
    USBD_Start(&USBD_Device);
  }
  else {
    USBD_DeInit(&USBD_Device);
c0d04aa4:	4801      	ldr	r0, [pc, #4]	; (c0d04aac <USB_power+0x4c>)
c0d04aa6:	f7ff faa4 	bl	c0d03ff2 <USBD_DeInit>
  }
}
c0d04aaa:	bd70      	pop	{r4, r5, r6, pc}
c0d04aac:	20001f38 	.word	0x20001f38
c0d04ab0:	000011b2 	.word	0x000011b2
c0d04ab4:	000011c6 	.word	0x000011c6

c0d04ab8 <USBD_GetCfgDesc_impl>:
  * @param  length : pointer data length
  * @retval pointer to descriptor buffer
  */
static uint8_t  *USBD_GetCfgDesc_impl (uint16_t *length)
{
  *length = sizeof (USBD_CfgDesc);
c0d04ab8:	2129      	movs	r1, #41	; 0x29
c0d04aba:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_CfgDesc;
c0d04abc:	4801      	ldr	r0, [pc, #4]	; (c0d04ac4 <USBD_GetCfgDesc_impl+0xc>)
c0d04abe:	4478      	add	r0, pc
c0d04ac0:	4770      	bx	lr
c0d04ac2:	46c0      	nop			; (mov r8, r8)
c0d04ac4:	0000120e 	.word	0x0000120e

c0d04ac8 <USBD_GetDeviceQualifierDesc_impl>:
* @param  length : pointer data length
* @retval pointer to descriptor buffer
*/
static uint8_t  *USBD_GetDeviceQualifierDesc_impl (uint16_t *length)
{
  *length = sizeof (USBD_DeviceQualifierDesc);
c0d04ac8:	210a      	movs	r1, #10
c0d04aca:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_DeviceQualifierDesc;
c0d04acc:	4801      	ldr	r0, [pc, #4]	; (c0d04ad4 <USBD_GetDeviceQualifierDesc_impl+0xc>)
c0d04ace:	4478      	add	r0, pc
c0d04ad0:	4770      	bx	lr
c0d04ad2:	46c0      	nop			; (mov r8, r8)
c0d04ad4:	0000122a 	.word	0x0000122a

c0d04ad8 <USBD_CtlSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendData (USBD_HandleTypeDef  *pdev, 
                               uint8_t *pbuf,
                               uint16_t len)
{
c0d04ad8:	b5b0      	push	{r4, r5, r7, lr}
c0d04ada:	460c      	mov	r4, r1
  /* Set EP0 State */
  pdev->ep0_state          = USBD_EP0_DATA_IN;                                      
c0d04adc:	21f4      	movs	r1, #244	; 0xf4
c0d04ade:	2302      	movs	r3, #2
c0d04ae0:	5043      	str	r3, [r0, r1]
  pdev->ep_in[0].total_length = len;
c0d04ae2:	6182      	str	r2, [r0, #24]
  pdev->ep_in[0].rem_length   = len;
c0d04ae4:	61c2      	str	r2, [r0, #28]
  // store the continuation data if needed
  pdev->pData = pbuf;
c0d04ae6:	2113      	movs	r1, #19
c0d04ae8:	0109      	lsls	r1, r1, #4
c0d04aea:	5044      	str	r4, [r0, r1]
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));  
c0d04aec:	6a01      	ldr	r1, [r0, #32]
c0d04aee:	428a      	cmp	r2, r1
c0d04af0:	d300      	bcc.n	c0d04af4 <USBD_CtlSendData+0x1c>
c0d04af2:	460a      	mov	r2, r1
c0d04af4:	b293      	uxth	r3, r2
c0d04af6:	2500      	movs	r5, #0
c0d04af8:	4629      	mov	r1, r5
c0d04afa:	4622      	mov	r2, r4
c0d04afc:	f7ff fa32 	bl	c0d03f64 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d04b00:	4628      	mov	r0, r5
c0d04b02:	bdb0      	pop	{r4, r5, r7, pc}

c0d04b04 <USBD_CtlContinueSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueSendData (USBD_HandleTypeDef  *pdev, 
                                       uint8_t *pbuf,
                                       uint16_t len)
{
c0d04b04:	b5b0      	push	{r4, r5, r7, lr}
c0d04b06:	460c      	mov	r4, r1
 /* Start the next transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));   
c0d04b08:	6a01      	ldr	r1, [r0, #32]
c0d04b0a:	428a      	cmp	r2, r1
c0d04b0c:	d300      	bcc.n	c0d04b10 <USBD_CtlContinueSendData+0xc>
c0d04b0e:	460a      	mov	r2, r1
c0d04b10:	b293      	uxth	r3, r2
c0d04b12:	2500      	movs	r5, #0
c0d04b14:	4629      	mov	r1, r5
c0d04b16:	4622      	mov	r2, r4
c0d04b18:	f7ff fa24 	bl	c0d03f64 <USBD_LL_Transmit>
  return USBD_OK;
c0d04b1c:	4628      	mov	r0, r5
c0d04b1e:	bdb0      	pop	{r4, r5, r7, pc}

c0d04b20 <USBD_CtlContinueRx>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueRx (USBD_HandleTypeDef  *pdev, 
                                          uint8_t *pbuf,                                          
                                          uint16_t len)
{
c0d04b20:	b510      	push	{r4, lr}
c0d04b22:	2400      	movs	r4, #0
  UNUSED(pbuf);
  USBD_LL_PrepareReceive (pdev,
c0d04b24:	4621      	mov	r1, r4
c0d04b26:	f7ff fa36 	bl	c0d03f96 <USBD_LL_PrepareReceive>
                          0,                                            
                          len);
  return USBD_OK;
c0d04b2a:	4620      	mov	r0, r4
c0d04b2c:	bd10      	pop	{r4, pc}

c0d04b2e <USBD_CtlSendStatus>:
*         send zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendStatus (USBD_HandleTypeDef  *pdev)
{
c0d04b2e:	b510      	push	{r4, lr}

  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_IN;
c0d04b30:	21f4      	movs	r1, #244	; 0xf4
c0d04b32:	2204      	movs	r2, #4
c0d04b34:	5042      	str	r2, [r0, r1]
c0d04b36:	2400      	movs	r4, #0
  
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, NULL, 0);   
c0d04b38:	4621      	mov	r1, r4
c0d04b3a:	4622      	mov	r2, r4
c0d04b3c:	4623      	mov	r3, r4
c0d04b3e:	f7ff fa11 	bl	c0d03f64 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d04b42:	4620      	mov	r0, r4
c0d04b44:	bd10      	pop	{r4, pc}

c0d04b46 <USBD_CtlReceiveStatus>:
*         receive zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlReceiveStatus (USBD_HandleTypeDef  *pdev)
{
c0d04b46:	b510      	push	{r4, lr}
  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_OUT; 
c0d04b48:	21f4      	movs	r1, #244	; 0xf4
c0d04b4a:	2205      	movs	r2, #5
c0d04b4c:	5042      	str	r2, [r0, r1]
c0d04b4e:	2400      	movs	r4, #0
  
 /* Start the transfer */  
  USBD_LL_PrepareReceive ( pdev,
c0d04b50:	4621      	mov	r1, r4
c0d04b52:	4622      	mov	r2, r4
c0d04b54:	f7ff fa1f 	bl	c0d03f96 <USBD_LL_PrepareReceive>
                    0,
                    0);  

  return USBD_OK;
c0d04b58:	4620      	mov	r0, r4
c0d04b5a:	bd10      	pop	{r4, pc}

c0d04b5c <__aeabi_uidiv>:
c0d04b5c:	2200      	movs	r2, #0
c0d04b5e:	0843      	lsrs	r3, r0, #1
c0d04b60:	428b      	cmp	r3, r1
c0d04b62:	d374      	bcc.n	c0d04c4e <__aeabi_uidiv+0xf2>
c0d04b64:	0903      	lsrs	r3, r0, #4
c0d04b66:	428b      	cmp	r3, r1
c0d04b68:	d35f      	bcc.n	c0d04c2a <__aeabi_uidiv+0xce>
c0d04b6a:	0a03      	lsrs	r3, r0, #8
c0d04b6c:	428b      	cmp	r3, r1
c0d04b6e:	d344      	bcc.n	c0d04bfa <__aeabi_uidiv+0x9e>
c0d04b70:	0b03      	lsrs	r3, r0, #12
c0d04b72:	428b      	cmp	r3, r1
c0d04b74:	d328      	bcc.n	c0d04bc8 <__aeabi_uidiv+0x6c>
c0d04b76:	0c03      	lsrs	r3, r0, #16
c0d04b78:	428b      	cmp	r3, r1
c0d04b7a:	d30d      	bcc.n	c0d04b98 <__aeabi_uidiv+0x3c>
c0d04b7c:	22ff      	movs	r2, #255	; 0xff
c0d04b7e:	0209      	lsls	r1, r1, #8
c0d04b80:	ba12      	rev	r2, r2
c0d04b82:	0c03      	lsrs	r3, r0, #16
c0d04b84:	428b      	cmp	r3, r1
c0d04b86:	d302      	bcc.n	c0d04b8e <__aeabi_uidiv+0x32>
c0d04b88:	1212      	asrs	r2, r2, #8
c0d04b8a:	0209      	lsls	r1, r1, #8
c0d04b8c:	d065      	beq.n	c0d04c5a <__aeabi_uidiv+0xfe>
c0d04b8e:	0b03      	lsrs	r3, r0, #12
c0d04b90:	428b      	cmp	r3, r1
c0d04b92:	d319      	bcc.n	c0d04bc8 <__aeabi_uidiv+0x6c>
c0d04b94:	e000      	b.n	c0d04b98 <__aeabi_uidiv+0x3c>
c0d04b96:	0a09      	lsrs	r1, r1, #8
c0d04b98:	0bc3      	lsrs	r3, r0, #15
c0d04b9a:	428b      	cmp	r3, r1
c0d04b9c:	d301      	bcc.n	c0d04ba2 <__aeabi_uidiv+0x46>
c0d04b9e:	03cb      	lsls	r3, r1, #15
c0d04ba0:	1ac0      	subs	r0, r0, r3
c0d04ba2:	4152      	adcs	r2, r2
c0d04ba4:	0b83      	lsrs	r3, r0, #14
c0d04ba6:	428b      	cmp	r3, r1
c0d04ba8:	d301      	bcc.n	c0d04bae <__aeabi_uidiv+0x52>
c0d04baa:	038b      	lsls	r3, r1, #14
c0d04bac:	1ac0      	subs	r0, r0, r3
c0d04bae:	4152      	adcs	r2, r2
c0d04bb0:	0b43      	lsrs	r3, r0, #13
c0d04bb2:	428b      	cmp	r3, r1
c0d04bb4:	d301      	bcc.n	c0d04bba <__aeabi_uidiv+0x5e>
c0d04bb6:	034b      	lsls	r3, r1, #13
c0d04bb8:	1ac0      	subs	r0, r0, r3
c0d04bba:	4152      	adcs	r2, r2
c0d04bbc:	0b03      	lsrs	r3, r0, #12
c0d04bbe:	428b      	cmp	r3, r1
c0d04bc0:	d301      	bcc.n	c0d04bc6 <__aeabi_uidiv+0x6a>
c0d04bc2:	030b      	lsls	r3, r1, #12
c0d04bc4:	1ac0      	subs	r0, r0, r3
c0d04bc6:	4152      	adcs	r2, r2
c0d04bc8:	0ac3      	lsrs	r3, r0, #11
c0d04bca:	428b      	cmp	r3, r1
c0d04bcc:	d301      	bcc.n	c0d04bd2 <__aeabi_uidiv+0x76>
c0d04bce:	02cb      	lsls	r3, r1, #11
c0d04bd0:	1ac0      	subs	r0, r0, r3
c0d04bd2:	4152      	adcs	r2, r2
c0d04bd4:	0a83      	lsrs	r3, r0, #10
c0d04bd6:	428b      	cmp	r3, r1
c0d04bd8:	d301      	bcc.n	c0d04bde <__aeabi_uidiv+0x82>
c0d04bda:	028b      	lsls	r3, r1, #10
c0d04bdc:	1ac0      	subs	r0, r0, r3
c0d04bde:	4152      	adcs	r2, r2
c0d04be0:	0a43      	lsrs	r3, r0, #9
c0d04be2:	428b      	cmp	r3, r1
c0d04be4:	d301      	bcc.n	c0d04bea <__aeabi_uidiv+0x8e>
c0d04be6:	024b      	lsls	r3, r1, #9
c0d04be8:	1ac0      	subs	r0, r0, r3
c0d04bea:	4152      	adcs	r2, r2
c0d04bec:	0a03      	lsrs	r3, r0, #8
c0d04bee:	428b      	cmp	r3, r1
c0d04bf0:	d301      	bcc.n	c0d04bf6 <__aeabi_uidiv+0x9a>
c0d04bf2:	020b      	lsls	r3, r1, #8
c0d04bf4:	1ac0      	subs	r0, r0, r3
c0d04bf6:	4152      	adcs	r2, r2
c0d04bf8:	d2cd      	bcs.n	c0d04b96 <__aeabi_uidiv+0x3a>
c0d04bfa:	09c3      	lsrs	r3, r0, #7
c0d04bfc:	428b      	cmp	r3, r1
c0d04bfe:	d301      	bcc.n	c0d04c04 <__aeabi_uidiv+0xa8>
c0d04c00:	01cb      	lsls	r3, r1, #7
c0d04c02:	1ac0      	subs	r0, r0, r3
c0d04c04:	4152      	adcs	r2, r2
c0d04c06:	0983      	lsrs	r3, r0, #6
c0d04c08:	428b      	cmp	r3, r1
c0d04c0a:	d301      	bcc.n	c0d04c10 <__aeabi_uidiv+0xb4>
c0d04c0c:	018b      	lsls	r3, r1, #6
c0d04c0e:	1ac0      	subs	r0, r0, r3
c0d04c10:	4152      	adcs	r2, r2
c0d04c12:	0943      	lsrs	r3, r0, #5
c0d04c14:	428b      	cmp	r3, r1
c0d04c16:	d301      	bcc.n	c0d04c1c <__aeabi_uidiv+0xc0>
c0d04c18:	014b      	lsls	r3, r1, #5
c0d04c1a:	1ac0      	subs	r0, r0, r3
c0d04c1c:	4152      	adcs	r2, r2
c0d04c1e:	0903      	lsrs	r3, r0, #4
c0d04c20:	428b      	cmp	r3, r1
c0d04c22:	d301      	bcc.n	c0d04c28 <__aeabi_uidiv+0xcc>
c0d04c24:	010b      	lsls	r3, r1, #4
c0d04c26:	1ac0      	subs	r0, r0, r3
c0d04c28:	4152      	adcs	r2, r2
c0d04c2a:	08c3      	lsrs	r3, r0, #3
c0d04c2c:	428b      	cmp	r3, r1
c0d04c2e:	d301      	bcc.n	c0d04c34 <__aeabi_uidiv+0xd8>
c0d04c30:	00cb      	lsls	r3, r1, #3
c0d04c32:	1ac0      	subs	r0, r0, r3
c0d04c34:	4152      	adcs	r2, r2
c0d04c36:	0883      	lsrs	r3, r0, #2
c0d04c38:	428b      	cmp	r3, r1
c0d04c3a:	d301      	bcc.n	c0d04c40 <__aeabi_uidiv+0xe4>
c0d04c3c:	008b      	lsls	r3, r1, #2
c0d04c3e:	1ac0      	subs	r0, r0, r3
c0d04c40:	4152      	adcs	r2, r2
c0d04c42:	0843      	lsrs	r3, r0, #1
c0d04c44:	428b      	cmp	r3, r1
c0d04c46:	d301      	bcc.n	c0d04c4c <__aeabi_uidiv+0xf0>
c0d04c48:	004b      	lsls	r3, r1, #1
c0d04c4a:	1ac0      	subs	r0, r0, r3
c0d04c4c:	4152      	adcs	r2, r2
c0d04c4e:	1a41      	subs	r1, r0, r1
c0d04c50:	d200      	bcs.n	c0d04c54 <__aeabi_uidiv+0xf8>
c0d04c52:	4601      	mov	r1, r0
c0d04c54:	4152      	adcs	r2, r2
c0d04c56:	4610      	mov	r0, r2
c0d04c58:	4770      	bx	lr
c0d04c5a:	e7ff      	b.n	c0d04c5c <__aeabi_uidiv+0x100>
c0d04c5c:	b501      	push	{r0, lr}
c0d04c5e:	2000      	movs	r0, #0
c0d04c60:	f000 f806 	bl	c0d04c70 <__aeabi_idiv0>
c0d04c64:	bd02      	pop	{r1, pc}
c0d04c66:	46c0      	nop			; (mov r8, r8)

c0d04c68 <__aeabi_uidivmod>:
c0d04c68:	2900      	cmp	r1, #0
c0d04c6a:	d0f7      	beq.n	c0d04c5c <__aeabi_uidiv+0x100>
c0d04c6c:	e776      	b.n	c0d04b5c <__aeabi_uidiv>
c0d04c6e:	4770      	bx	lr

c0d04c70 <__aeabi_idiv0>:
c0d04c70:	4770      	bx	lr
c0d04c72:	46c0      	nop			; (mov r8, r8)

c0d04c74 <__aeabi_uldivmod>:
c0d04c74:	2b00      	cmp	r3, #0
c0d04c76:	d111      	bne.n	c0d04c9c <__aeabi_uldivmod+0x28>
c0d04c78:	2a00      	cmp	r2, #0
c0d04c7a:	d10f      	bne.n	c0d04c9c <__aeabi_uldivmod+0x28>
c0d04c7c:	2900      	cmp	r1, #0
c0d04c7e:	d100      	bne.n	c0d04c82 <__aeabi_uldivmod+0xe>
c0d04c80:	2800      	cmp	r0, #0
c0d04c82:	d002      	beq.n	c0d04c8a <__aeabi_uldivmod+0x16>
c0d04c84:	2100      	movs	r1, #0
c0d04c86:	43c9      	mvns	r1, r1
c0d04c88:	1c08      	adds	r0, r1, #0
c0d04c8a:	b407      	push	{r0, r1, r2}
c0d04c8c:	4802      	ldr	r0, [pc, #8]	; (c0d04c98 <__aeabi_uldivmod+0x24>)
c0d04c8e:	a102      	add	r1, pc, #8	; (adr r1, c0d04c98 <__aeabi_uldivmod+0x24>)
c0d04c90:	1840      	adds	r0, r0, r1
c0d04c92:	9002      	str	r0, [sp, #8]
c0d04c94:	bd03      	pop	{r0, r1, pc}
c0d04c96:	46c0      	nop			; (mov r8, r8)
c0d04c98:	ffffffd9 	.word	0xffffffd9
c0d04c9c:	b403      	push	{r0, r1}
c0d04c9e:	4668      	mov	r0, sp
c0d04ca0:	b501      	push	{r0, lr}
c0d04ca2:	9802      	ldr	r0, [sp, #8]
c0d04ca4:	f000 f806 	bl	c0d04cb4 <__udivmoddi4>
c0d04ca8:	9b01      	ldr	r3, [sp, #4]
c0d04caa:	469e      	mov	lr, r3
c0d04cac:	b002      	add	sp, #8
c0d04cae:	bc0c      	pop	{r2, r3}
c0d04cb0:	4770      	bx	lr
c0d04cb2:	46c0      	nop			; (mov r8, r8)

c0d04cb4 <__udivmoddi4>:
c0d04cb4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04cb6:	464d      	mov	r5, r9
c0d04cb8:	4656      	mov	r6, sl
c0d04cba:	4644      	mov	r4, r8
c0d04cbc:	465f      	mov	r7, fp
c0d04cbe:	b4f0      	push	{r4, r5, r6, r7}
c0d04cc0:	4692      	mov	sl, r2
c0d04cc2:	b083      	sub	sp, #12
c0d04cc4:	0004      	movs	r4, r0
c0d04cc6:	000d      	movs	r5, r1
c0d04cc8:	4699      	mov	r9, r3
c0d04cca:	428b      	cmp	r3, r1
c0d04ccc:	d82f      	bhi.n	c0d04d2e <__udivmoddi4+0x7a>
c0d04cce:	d02c      	beq.n	c0d04d2a <__udivmoddi4+0x76>
c0d04cd0:	4649      	mov	r1, r9
c0d04cd2:	4650      	mov	r0, sl
c0d04cd4:	f000 f8ae 	bl	c0d04e34 <__clzdi2>
c0d04cd8:	0029      	movs	r1, r5
c0d04cda:	0006      	movs	r6, r0
c0d04cdc:	0020      	movs	r0, r4
c0d04cde:	f000 f8a9 	bl	c0d04e34 <__clzdi2>
c0d04ce2:	1a33      	subs	r3, r6, r0
c0d04ce4:	4698      	mov	r8, r3
c0d04ce6:	3b20      	subs	r3, #32
c0d04ce8:	469b      	mov	fp, r3
c0d04cea:	d500      	bpl.n	c0d04cee <__udivmoddi4+0x3a>
c0d04cec:	e074      	b.n	c0d04dd8 <__udivmoddi4+0x124>
c0d04cee:	4653      	mov	r3, sl
c0d04cf0:	465a      	mov	r2, fp
c0d04cf2:	4093      	lsls	r3, r2
c0d04cf4:	001f      	movs	r7, r3
c0d04cf6:	4653      	mov	r3, sl
c0d04cf8:	4642      	mov	r2, r8
c0d04cfa:	4093      	lsls	r3, r2
c0d04cfc:	001e      	movs	r6, r3
c0d04cfe:	42af      	cmp	r7, r5
c0d04d00:	d829      	bhi.n	c0d04d56 <__udivmoddi4+0xa2>
c0d04d02:	d026      	beq.n	c0d04d52 <__udivmoddi4+0x9e>
c0d04d04:	465b      	mov	r3, fp
c0d04d06:	1ba4      	subs	r4, r4, r6
c0d04d08:	41bd      	sbcs	r5, r7
c0d04d0a:	2b00      	cmp	r3, #0
c0d04d0c:	da00      	bge.n	c0d04d10 <__udivmoddi4+0x5c>
c0d04d0e:	e079      	b.n	c0d04e04 <__udivmoddi4+0x150>
c0d04d10:	2200      	movs	r2, #0
c0d04d12:	2300      	movs	r3, #0
c0d04d14:	9200      	str	r2, [sp, #0]
c0d04d16:	9301      	str	r3, [sp, #4]
c0d04d18:	2301      	movs	r3, #1
c0d04d1a:	465a      	mov	r2, fp
c0d04d1c:	4093      	lsls	r3, r2
c0d04d1e:	9301      	str	r3, [sp, #4]
c0d04d20:	2301      	movs	r3, #1
c0d04d22:	4642      	mov	r2, r8
c0d04d24:	4093      	lsls	r3, r2
c0d04d26:	9300      	str	r3, [sp, #0]
c0d04d28:	e019      	b.n	c0d04d5e <__udivmoddi4+0xaa>
c0d04d2a:	4282      	cmp	r2, r0
c0d04d2c:	d9d0      	bls.n	c0d04cd0 <__udivmoddi4+0x1c>
c0d04d2e:	2200      	movs	r2, #0
c0d04d30:	2300      	movs	r3, #0
c0d04d32:	9200      	str	r2, [sp, #0]
c0d04d34:	9301      	str	r3, [sp, #4]
c0d04d36:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0d04d38:	2b00      	cmp	r3, #0
c0d04d3a:	d001      	beq.n	c0d04d40 <__udivmoddi4+0x8c>
c0d04d3c:	601c      	str	r4, [r3, #0]
c0d04d3e:	605d      	str	r5, [r3, #4]
c0d04d40:	9800      	ldr	r0, [sp, #0]
c0d04d42:	9901      	ldr	r1, [sp, #4]
c0d04d44:	b003      	add	sp, #12
c0d04d46:	bc3c      	pop	{r2, r3, r4, r5}
c0d04d48:	4690      	mov	r8, r2
c0d04d4a:	4699      	mov	r9, r3
c0d04d4c:	46a2      	mov	sl, r4
c0d04d4e:	46ab      	mov	fp, r5
c0d04d50:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d04d52:	42a3      	cmp	r3, r4
c0d04d54:	d9d6      	bls.n	c0d04d04 <__udivmoddi4+0x50>
c0d04d56:	2200      	movs	r2, #0
c0d04d58:	2300      	movs	r3, #0
c0d04d5a:	9200      	str	r2, [sp, #0]
c0d04d5c:	9301      	str	r3, [sp, #4]
c0d04d5e:	4643      	mov	r3, r8
c0d04d60:	2b00      	cmp	r3, #0
c0d04d62:	d0e8      	beq.n	c0d04d36 <__udivmoddi4+0x82>
c0d04d64:	07fb      	lsls	r3, r7, #31
c0d04d66:	0872      	lsrs	r2, r6, #1
c0d04d68:	431a      	orrs	r2, r3
c0d04d6a:	4646      	mov	r6, r8
c0d04d6c:	087b      	lsrs	r3, r7, #1
c0d04d6e:	e00e      	b.n	c0d04d8e <__udivmoddi4+0xda>
c0d04d70:	42ab      	cmp	r3, r5
c0d04d72:	d101      	bne.n	c0d04d78 <__udivmoddi4+0xc4>
c0d04d74:	42a2      	cmp	r2, r4
c0d04d76:	d80c      	bhi.n	c0d04d92 <__udivmoddi4+0xde>
c0d04d78:	1aa4      	subs	r4, r4, r2
c0d04d7a:	419d      	sbcs	r5, r3
c0d04d7c:	2001      	movs	r0, #1
c0d04d7e:	1924      	adds	r4, r4, r4
c0d04d80:	416d      	adcs	r5, r5
c0d04d82:	2100      	movs	r1, #0
c0d04d84:	3e01      	subs	r6, #1
c0d04d86:	1824      	adds	r4, r4, r0
c0d04d88:	414d      	adcs	r5, r1
c0d04d8a:	2e00      	cmp	r6, #0
c0d04d8c:	d006      	beq.n	c0d04d9c <__udivmoddi4+0xe8>
c0d04d8e:	42ab      	cmp	r3, r5
c0d04d90:	d9ee      	bls.n	c0d04d70 <__udivmoddi4+0xbc>
c0d04d92:	3e01      	subs	r6, #1
c0d04d94:	1924      	adds	r4, r4, r4
c0d04d96:	416d      	adcs	r5, r5
c0d04d98:	2e00      	cmp	r6, #0
c0d04d9a:	d1f8      	bne.n	c0d04d8e <__udivmoddi4+0xda>
c0d04d9c:	465b      	mov	r3, fp
c0d04d9e:	9800      	ldr	r0, [sp, #0]
c0d04da0:	9901      	ldr	r1, [sp, #4]
c0d04da2:	1900      	adds	r0, r0, r4
c0d04da4:	4169      	adcs	r1, r5
c0d04da6:	2b00      	cmp	r3, #0
c0d04da8:	db22      	blt.n	c0d04df0 <__udivmoddi4+0x13c>
c0d04daa:	002b      	movs	r3, r5
c0d04dac:	465a      	mov	r2, fp
c0d04dae:	40d3      	lsrs	r3, r2
c0d04db0:	002a      	movs	r2, r5
c0d04db2:	4644      	mov	r4, r8
c0d04db4:	40e2      	lsrs	r2, r4
c0d04db6:	001c      	movs	r4, r3
c0d04db8:	465b      	mov	r3, fp
c0d04dba:	0015      	movs	r5, r2
c0d04dbc:	2b00      	cmp	r3, #0
c0d04dbe:	db2c      	blt.n	c0d04e1a <__udivmoddi4+0x166>
c0d04dc0:	0026      	movs	r6, r4
c0d04dc2:	409e      	lsls	r6, r3
c0d04dc4:	0033      	movs	r3, r6
c0d04dc6:	0026      	movs	r6, r4
c0d04dc8:	4647      	mov	r7, r8
c0d04dca:	40be      	lsls	r6, r7
c0d04dcc:	0032      	movs	r2, r6
c0d04dce:	1a80      	subs	r0, r0, r2
c0d04dd0:	4199      	sbcs	r1, r3
c0d04dd2:	9000      	str	r0, [sp, #0]
c0d04dd4:	9101      	str	r1, [sp, #4]
c0d04dd6:	e7ae      	b.n	c0d04d36 <__udivmoddi4+0x82>
c0d04dd8:	4642      	mov	r2, r8
c0d04dda:	2320      	movs	r3, #32
c0d04ddc:	1a9b      	subs	r3, r3, r2
c0d04dde:	4652      	mov	r2, sl
c0d04de0:	40da      	lsrs	r2, r3
c0d04de2:	4641      	mov	r1, r8
c0d04de4:	0013      	movs	r3, r2
c0d04de6:	464a      	mov	r2, r9
c0d04de8:	408a      	lsls	r2, r1
c0d04dea:	0017      	movs	r7, r2
c0d04dec:	431f      	orrs	r7, r3
c0d04dee:	e782      	b.n	c0d04cf6 <__udivmoddi4+0x42>
c0d04df0:	4642      	mov	r2, r8
c0d04df2:	2320      	movs	r3, #32
c0d04df4:	1a9b      	subs	r3, r3, r2
c0d04df6:	002a      	movs	r2, r5
c0d04df8:	4646      	mov	r6, r8
c0d04dfa:	409a      	lsls	r2, r3
c0d04dfc:	0023      	movs	r3, r4
c0d04dfe:	40f3      	lsrs	r3, r6
c0d04e00:	4313      	orrs	r3, r2
c0d04e02:	e7d5      	b.n	c0d04db0 <__udivmoddi4+0xfc>
c0d04e04:	4642      	mov	r2, r8
c0d04e06:	2320      	movs	r3, #32
c0d04e08:	2100      	movs	r1, #0
c0d04e0a:	1a9b      	subs	r3, r3, r2
c0d04e0c:	2200      	movs	r2, #0
c0d04e0e:	9100      	str	r1, [sp, #0]
c0d04e10:	9201      	str	r2, [sp, #4]
c0d04e12:	2201      	movs	r2, #1
c0d04e14:	40da      	lsrs	r2, r3
c0d04e16:	9201      	str	r2, [sp, #4]
c0d04e18:	e782      	b.n	c0d04d20 <__udivmoddi4+0x6c>
c0d04e1a:	4642      	mov	r2, r8
c0d04e1c:	2320      	movs	r3, #32
c0d04e1e:	0026      	movs	r6, r4
c0d04e20:	1a9b      	subs	r3, r3, r2
c0d04e22:	40de      	lsrs	r6, r3
c0d04e24:	002f      	movs	r7, r5
c0d04e26:	46b4      	mov	ip, r6
c0d04e28:	4097      	lsls	r7, r2
c0d04e2a:	4666      	mov	r6, ip
c0d04e2c:	003b      	movs	r3, r7
c0d04e2e:	4333      	orrs	r3, r6
c0d04e30:	e7c9      	b.n	c0d04dc6 <__udivmoddi4+0x112>
c0d04e32:	46c0      	nop			; (mov r8, r8)

c0d04e34 <__clzdi2>:
c0d04e34:	b510      	push	{r4, lr}
c0d04e36:	2900      	cmp	r1, #0
c0d04e38:	d103      	bne.n	c0d04e42 <__clzdi2+0xe>
c0d04e3a:	f000 f807 	bl	c0d04e4c <__clzsi2>
c0d04e3e:	3020      	adds	r0, #32
c0d04e40:	e002      	b.n	c0d04e48 <__clzdi2+0x14>
c0d04e42:	1c08      	adds	r0, r1, #0
c0d04e44:	f000 f802 	bl	c0d04e4c <__clzsi2>
c0d04e48:	bd10      	pop	{r4, pc}
c0d04e4a:	46c0      	nop			; (mov r8, r8)

c0d04e4c <__clzsi2>:
c0d04e4c:	211c      	movs	r1, #28
c0d04e4e:	2301      	movs	r3, #1
c0d04e50:	041b      	lsls	r3, r3, #16
c0d04e52:	4298      	cmp	r0, r3
c0d04e54:	d301      	bcc.n	c0d04e5a <__clzsi2+0xe>
c0d04e56:	0c00      	lsrs	r0, r0, #16
c0d04e58:	3910      	subs	r1, #16
c0d04e5a:	0a1b      	lsrs	r3, r3, #8
c0d04e5c:	4298      	cmp	r0, r3
c0d04e5e:	d301      	bcc.n	c0d04e64 <__clzsi2+0x18>
c0d04e60:	0a00      	lsrs	r0, r0, #8
c0d04e62:	3908      	subs	r1, #8
c0d04e64:	091b      	lsrs	r3, r3, #4
c0d04e66:	4298      	cmp	r0, r3
c0d04e68:	d301      	bcc.n	c0d04e6e <__clzsi2+0x22>
c0d04e6a:	0900      	lsrs	r0, r0, #4
c0d04e6c:	3904      	subs	r1, #4
c0d04e6e:	a202      	add	r2, pc, #8	; (adr r2, c0d04e78 <__clzsi2+0x2c>)
c0d04e70:	5c10      	ldrb	r0, [r2, r0]
c0d04e72:	1840      	adds	r0, r0, r1
c0d04e74:	4770      	bx	lr
c0d04e76:	46c0      	nop			; (mov r8, r8)
c0d04e78:	02020304 	.word	0x02020304
c0d04e7c:	01010101 	.word	0x01010101
	...

c0d04e88 <__aeabi_memclr>:
c0d04e88:	b510      	push	{r4, lr}
c0d04e8a:	2200      	movs	r2, #0
c0d04e8c:	f000 f802 	bl	c0d04e94 <__aeabi_memset>
c0d04e90:	bd10      	pop	{r4, pc}
c0d04e92:	46c0      	nop			; (mov r8, r8)

c0d04e94 <__aeabi_memset>:
c0d04e94:	0013      	movs	r3, r2
c0d04e96:	b510      	push	{r4, lr}
c0d04e98:	000a      	movs	r2, r1
c0d04e9a:	0019      	movs	r1, r3
c0d04e9c:	f000 f802 	bl	c0d04ea4 <memset>
c0d04ea0:	bd10      	pop	{r4, pc}
c0d04ea2:	46c0      	nop			; (mov r8, r8)

c0d04ea4 <memset>:
c0d04ea4:	b570      	push	{r4, r5, r6, lr}
c0d04ea6:	0783      	lsls	r3, r0, #30
c0d04ea8:	d03f      	beq.n	c0d04f2a <memset+0x86>
c0d04eaa:	1e54      	subs	r4, r2, #1
c0d04eac:	2a00      	cmp	r2, #0
c0d04eae:	d03b      	beq.n	c0d04f28 <memset+0x84>
c0d04eb0:	b2ce      	uxtb	r6, r1
c0d04eb2:	0003      	movs	r3, r0
c0d04eb4:	2503      	movs	r5, #3
c0d04eb6:	e003      	b.n	c0d04ec0 <memset+0x1c>
c0d04eb8:	1e62      	subs	r2, r4, #1
c0d04eba:	2c00      	cmp	r4, #0
c0d04ebc:	d034      	beq.n	c0d04f28 <memset+0x84>
c0d04ebe:	0014      	movs	r4, r2
c0d04ec0:	3301      	adds	r3, #1
c0d04ec2:	1e5a      	subs	r2, r3, #1
c0d04ec4:	7016      	strb	r6, [r2, #0]
c0d04ec6:	422b      	tst	r3, r5
c0d04ec8:	d1f6      	bne.n	c0d04eb8 <memset+0x14>
c0d04eca:	2c03      	cmp	r4, #3
c0d04ecc:	d924      	bls.n	c0d04f18 <memset+0x74>
c0d04ece:	25ff      	movs	r5, #255	; 0xff
c0d04ed0:	400d      	ands	r5, r1
c0d04ed2:	022a      	lsls	r2, r5, #8
c0d04ed4:	4315      	orrs	r5, r2
c0d04ed6:	042a      	lsls	r2, r5, #16
c0d04ed8:	4315      	orrs	r5, r2
c0d04eda:	2c0f      	cmp	r4, #15
c0d04edc:	d911      	bls.n	c0d04f02 <memset+0x5e>
c0d04ede:	0026      	movs	r6, r4
c0d04ee0:	3e10      	subs	r6, #16
c0d04ee2:	0936      	lsrs	r6, r6, #4
c0d04ee4:	3601      	adds	r6, #1
c0d04ee6:	0136      	lsls	r6, r6, #4
c0d04ee8:	001a      	movs	r2, r3
c0d04eea:	199b      	adds	r3, r3, r6
c0d04eec:	6015      	str	r5, [r2, #0]
c0d04eee:	6055      	str	r5, [r2, #4]
c0d04ef0:	6095      	str	r5, [r2, #8]
c0d04ef2:	60d5      	str	r5, [r2, #12]
c0d04ef4:	3210      	adds	r2, #16
c0d04ef6:	4293      	cmp	r3, r2
c0d04ef8:	d1f8      	bne.n	c0d04eec <memset+0x48>
c0d04efa:	220f      	movs	r2, #15
c0d04efc:	4014      	ands	r4, r2
c0d04efe:	2c03      	cmp	r4, #3
c0d04f00:	d90a      	bls.n	c0d04f18 <memset+0x74>
c0d04f02:	1f26      	subs	r6, r4, #4
c0d04f04:	08b6      	lsrs	r6, r6, #2
c0d04f06:	3601      	adds	r6, #1
c0d04f08:	00b6      	lsls	r6, r6, #2
c0d04f0a:	001a      	movs	r2, r3
c0d04f0c:	199b      	adds	r3, r3, r6
c0d04f0e:	c220      	stmia	r2!, {r5}
c0d04f10:	4293      	cmp	r3, r2
c0d04f12:	d1fc      	bne.n	c0d04f0e <memset+0x6a>
c0d04f14:	2203      	movs	r2, #3
c0d04f16:	4014      	ands	r4, r2
c0d04f18:	2c00      	cmp	r4, #0
c0d04f1a:	d005      	beq.n	c0d04f28 <memset+0x84>
c0d04f1c:	b2c9      	uxtb	r1, r1
c0d04f1e:	191c      	adds	r4, r3, r4
c0d04f20:	7019      	strb	r1, [r3, #0]
c0d04f22:	3301      	adds	r3, #1
c0d04f24:	429c      	cmp	r4, r3
c0d04f26:	d1fb      	bne.n	c0d04f20 <memset+0x7c>
c0d04f28:	bd70      	pop	{r4, r5, r6, pc}
c0d04f2a:	0014      	movs	r4, r2
c0d04f2c:	0003      	movs	r3, r0
c0d04f2e:	e7cc      	b.n	c0d04eca <memset+0x26>

c0d04f30 <setjmp>:
c0d04f30:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0d04f32:	4641      	mov	r1, r8
c0d04f34:	464a      	mov	r2, r9
c0d04f36:	4653      	mov	r3, sl
c0d04f38:	465c      	mov	r4, fp
c0d04f3a:	466d      	mov	r5, sp
c0d04f3c:	4676      	mov	r6, lr
c0d04f3e:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0d04f40:	3828      	subs	r0, #40	; 0x28
c0d04f42:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d04f44:	2000      	movs	r0, #0
c0d04f46:	4770      	bx	lr

c0d04f48 <longjmp>:
c0d04f48:	3010      	adds	r0, #16
c0d04f4a:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0d04f4c:	4690      	mov	r8, r2
c0d04f4e:	4699      	mov	r9, r3
c0d04f50:	46a2      	mov	sl, r4
c0d04f52:	46ab      	mov	fp, r5
c0d04f54:	46b5      	mov	sp, r6
c0d04f56:	c808      	ldmia	r0!, {r3}
c0d04f58:	3828      	subs	r0, #40	; 0x28
c0d04f5a:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d04f5c:	1c08      	adds	r0, r1, #0
c0d04f5e:	d100      	bne.n	c0d04f62 <longjmp+0x1a>
c0d04f60:	2001      	movs	r0, #1
c0d04f62:	4718      	bx	r3

c0d04f64 <strlen>:
c0d04f64:	b510      	push	{r4, lr}
c0d04f66:	0783      	lsls	r3, r0, #30
c0d04f68:	d027      	beq.n	c0d04fba <strlen+0x56>
c0d04f6a:	7803      	ldrb	r3, [r0, #0]
c0d04f6c:	2b00      	cmp	r3, #0
c0d04f6e:	d026      	beq.n	c0d04fbe <strlen+0x5a>
c0d04f70:	0003      	movs	r3, r0
c0d04f72:	2103      	movs	r1, #3
c0d04f74:	e002      	b.n	c0d04f7c <strlen+0x18>
c0d04f76:	781a      	ldrb	r2, [r3, #0]
c0d04f78:	2a00      	cmp	r2, #0
c0d04f7a:	d01c      	beq.n	c0d04fb6 <strlen+0x52>
c0d04f7c:	3301      	adds	r3, #1
c0d04f7e:	420b      	tst	r3, r1
c0d04f80:	d1f9      	bne.n	c0d04f76 <strlen+0x12>
c0d04f82:	6819      	ldr	r1, [r3, #0]
c0d04f84:	4a0f      	ldr	r2, [pc, #60]	; (c0d04fc4 <strlen+0x60>)
c0d04f86:	4c10      	ldr	r4, [pc, #64]	; (c0d04fc8 <strlen+0x64>)
c0d04f88:	188a      	adds	r2, r1, r2
c0d04f8a:	438a      	bics	r2, r1
c0d04f8c:	4222      	tst	r2, r4
c0d04f8e:	d10f      	bne.n	c0d04fb0 <strlen+0x4c>
c0d04f90:	3304      	adds	r3, #4
c0d04f92:	6819      	ldr	r1, [r3, #0]
c0d04f94:	4a0b      	ldr	r2, [pc, #44]	; (c0d04fc4 <strlen+0x60>)
c0d04f96:	188a      	adds	r2, r1, r2
c0d04f98:	438a      	bics	r2, r1
c0d04f9a:	4222      	tst	r2, r4
c0d04f9c:	d108      	bne.n	c0d04fb0 <strlen+0x4c>
c0d04f9e:	3304      	adds	r3, #4
c0d04fa0:	6819      	ldr	r1, [r3, #0]
c0d04fa2:	4a08      	ldr	r2, [pc, #32]	; (c0d04fc4 <strlen+0x60>)
c0d04fa4:	188a      	adds	r2, r1, r2
c0d04fa6:	438a      	bics	r2, r1
c0d04fa8:	4222      	tst	r2, r4
c0d04faa:	d0f1      	beq.n	c0d04f90 <strlen+0x2c>
c0d04fac:	e000      	b.n	c0d04fb0 <strlen+0x4c>
c0d04fae:	3301      	adds	r3, #1
c0d04fb0:	781a      	ldrb	r2, [r3, #0]
c0d04fb2:	2a00      	cmp	r2, #0
c0d04fb4:	d1fb      	bne.n	c0d04fae <strlen+0x4a>
c0d04fb6:	1a18      	subs	r0, r3, r0
c0d04fb8:	bd10      	pop	{r4, pc}
c0d04fba:	0003      	movs	r3, r0
c0d04fbc:	e7e1      	b.n	c0d04f82 <strlen+0x1e>
c0d04fbe:	2000      	movs	r0, #0
c0d04fc0:	e7fa      	b.n	c0d04fb8 <strlen+0x54>
c0d04fc2:	46c0      	nop			; (mov r8, r8)
c0d04fc4:	fefefeff 	.word	0xfefefeff
c0d04fc8:	80808080 	.word	0x80808080
c0d04fcc:	727a7071 	.word	0x727a7071
c0d04fd0:	38783979 	.word	0x38783979
c0d04fd4:	74326667 	.word	0x74326667
c0d04fd8:	30776476 	.word	0x30776476
c0d04fdc:	6e6a3373 	.word	0x6e6a3373
c0d04fe0:	686b3435 	.word	0x686b3435
c0d04fe4:	6d366563 	.word	0x6d366563
c0d04fe8:	6c376175 	.word	0x6c376175
c0d04fec:	00000000 	.word	0x00000000

c0d04ff0 <ui_getPublicKey_approve>:
c0d04ff0:	00000003 00800000 00000020 00000001     ........ .......
c0d05000:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05028:	00030005 0007000c 00000007 00000000     ................
c0d05038:	00ffffff 00000000 00070000 00000000     ................
	...
c0d05060:	00750005 0008000d 00000006 00000000     ..u.............
c0d05070:	00ffffff 00000000 00060000 00000000     ................
	...
c0d05098:	00000007 0080000c 0000000c 00000000     ................
c0d050a8:	00ffffff 00000000 0000800a 20001932     ............2.. 
	...
c0d050d0:	706d6f43 3a657261 00000000              Compare:....

c0d050dc <ui_getPublicKey_compare>:
c0d050dc:	00000003 00800000 00000020 00000001     ........ .......
c0d050ec:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05114:	00030105 0007000c 00000007 00000000     ................
c0d05124:	00ffffff 00000000 00090000 00000000     ................
	...
c0d0514c:	00750205 0008000d 00000006 00000000     ..u.............
c0d0515c:	00ffffff 00000000 000a0000 00000000     ................
	...
c0d05184:	00000007 0080000c 0000000c 00000000     ................
c0d05194:	00ffffff 00000000 0000800a c0d050d0     .............P..
	...
c0d051bc:	00000007 0080001a 0000000c 00000000     ................
c0d051cc:	00ffffff 00000000 0000800a 200019cf     ............... 
	...

c0d051f4 <ui_signTx_approve>:
c0d051f4:	00000003 00800000 00000020 00000001     ........ .......
c0d05204:	00000000 00ffffff 00000000 00000000     ................
	...
c0d0522c:	00030005 0007000c 00000007 00000000     ................
c0d0523c:	00ffffff 00000000 00070000 00000000     ................
	...
c0d05264:	00750005 0008000d 00000006 00000000     ..u.............
c0d05274:	00ffffff 00000000 00060000 00000000     ................
	...
c0d0529c:	00000007 0080000c 0000000c 00000000     ................
c0d052ac:	00ffffff 00000000 0000800a 20001d3b     ............;.. 
	...

c0d052d4 <ui_address_compare>:
c0d052d4:	00000003 00800000 00000020 00000001     ........ .......
c0d052e4:	00000000 00ffffff 00000000 00000000     ................
	...
c0d0530c:	00030105 0007000c 00000007 00000000     ................
c0d0531c:	00ffffff 00000000 00090000 00000000     ................
	...
c0d05344:	00750205 0008000d 00000006 00000000     ..u.............
c0d05354:	00ffffff 00000000 000a0000 00000000     ................
	...
c0d0537c:	00000007 0080000c 0000000c 00000000     ................
c0d0538c:	00ffffff 00000000 0000800a c0d053ec     .............S..
	...
c0d053b4:	00000007 0080001a 0000000c 00000000     ................
c0d053c4:	00ffffff 00000000 0000800a 20001c12     ............... 
	...
c0d053ec:	646e6553 206f7420 72646441 6d41003a     Send to Addr:.Am
c0d053fc:	746e756f 7246003a 53206d6f 64726168     ount:.From Shard
c0d0540c:	6f54003a 61685320 003a6472              :.To Shard:.

c0d05418 <ui_amount_compare_large>:
c0d05418:	00000003 00800000 00000020 00000001     ........ .......
c0d05428:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05450:	00030105 0007000c 00000007 00000000     ................
c0d05460:	00ffffff 00000000 00090000 00000000     ................
	...
c0d05488:	00750205 0008000d 00000006 00000000     ..u.............
c0d05498:	00ffffff 00000000 000a0000 00000000     ................
	...
c0d054c0:	00000007 0080000c 0000000c 00000000     ................
c0d054d0:	00ffffff 00000000 0000800a c0d053fa     .............S..
	...
c0d054f8:	00000007 0080001a 0000000c 00000000     ................
c0d05508:	00ffffff 00000000 0000800a 20001c74     ............t.. 
	...

c0d05530 <ui_amount_compare>:
c0d05530:	00000003 00800000 00000020 00000001     ........ .......
c0d05540:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05568:	00030005 0007000c 00000007 00000000     ................
c0d05578:	00ffffff 00000000 00070000 00000000     ................
	...
c0d055a0:	00750005 0008000d 00000006 00000000     ..u.............
c0d055b0:	00ffffff 00000000 00060000 00000000     ................
	...
c0d055d8:	00000007 0080000c 0000000c 00000000     ................
c0d055e8:	00ffffff 00000000 0000800a c0d053fa     .............S..
	...
c0d05610:	00000007 0080001a 0000000c 00000000     ................
c0d05620:	00ffffff 00000000 0000800a 20001c74     ............t.. 
	...

c0d05648 <ui_fromshard_approve>:
c0d05648:	00000003 00800000 00000020 00000001     ........ .......
c0d05658:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05680:	00030005 0007000c 00000007 00000000     ................
c0d05690:	00ffffff 00000000 00070000 00000000     ................
	...
c0d056b8:	00750005 0008000d 00000006 00000000     ..u.............
c0d056c8:	00ffffff 00000000 00060000 00000000     ................
	...
c0d056f0:	00000007 0080000c 0000000c 00000000     ................
c0d05700:	00ffffff 00000000 0000800a c0d05402     .............T..
	...
c0d05728:	00000007 0080001a 0000000c 00000000     ................
c0d05738:	00ffffff 00000000 0000800a 20001c81     ............... 
	...

c0d05760 <ui_toshard_approve>:
c0d05760:	00000003 00800000 00000020 00000001     ........ .......
c0d05770:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05798:	00030005 0007000c 00000007 00000000     ................
c0d057a8:	00ffffff 00000000 00070000 00000000     ................
	...
c0d057d0:	00750005 0008000d 00000006 00000000     ..u.............
c0d057e0:	00ffffff 00000000 00060000 00000000     ................
	...
c0d05808:	00000007 0080000c 0000000c 00000000     ................
c0d05818:	00ffffff 00000000 0000800a c0d0540e     .............T..
	...
c0d05840:	00000007 0080001a 0000000c 00000000     ................
c0d05850:	00ffffff 00000000 0000800a 20001c8e     ............... 
	...

c0d05878 <C_icon_back_colors>:
c0d05878:	00000000 00ffffff                       ........

c0d05880 <C_icon_back_bitmap>:
c0d05880:	c1fe01e0 067f38fd c4ff81df bcfff37f     .....8..........
c0d05890:	f1e7e71f 7807f83f 00000000              ....?..x....

c0d0589c <C_icon_back>:
c0d0589c:	0000000e 0000000e 00000001 c0d05878     ............xX..
c0d058ac:	c0d05880                                .X..

c0d058b0 <C_icon_dashboard_colors>:
c0d058b0:	00000000 00ffffff                       ........

c0d058b8 <C_icon_dashboard_bitmap>:
c0d058b8:	c1fe01e0 067038ff 9e7e79d8 b9e7e79f     .....8p..y~.....
c0d058c8:	f1c0e601 7807f83f 00000000              ....?..x....

c0d058d4 <C_icon_dashboard>:
c0d058d4:	0000000e 0000000e 00000001 c0d058b0     .............X..
c0d058e4:	c0d058b8                                .X..

c0d058e8 <menu_main>:
	...
c0d058f8:	c0d05958 c0d05964 00000000 c0d05994     XY..dY.......Y..
	...
c0d05914:	c0d05970 00000000 00000000 00000000     pY..............
c0d05924:	c0d03059 00000000 c0d058d4 c0d05976     Y0.......X..vY..
c0d05934:	00000000 00001d32 00000000 00000000     ....2...........
	...
c0d05958:	74696157 20676e69 00726f66 6d6d6f63     Waiting for.comm
c0d05968:	73646e61 002e2e2e 756f6241 75510074     ands....About.Qu
c0d05978:	61207469 56007070 69737265 31006e6f     it app.Version.1
c0d05988:	302e302e 63614200 0000006b              .0.0.Back...

c0d05994 <menu_about>:
	...
c0d059a4:	c0d0597f c0d05987 00000000 c0d058e8     .Y...Y.......X..
	...
c0d059bc:	c0d0589c c0d0598d 00000000 0000283d     .X...Y......=(..
	...

c0d059e8 <ux_menu_elements>:
c0d059e8:	00008003 00800000 00000020 00000001     ........ .......
c0d059f8:	00000000 00ffffff 00000000 00000000     ................
	...
c0d05a20:	00038105 0007000e 00000004 00000000     ................
c0d05a30:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d05a58:	00768205 0007000e 00000004 00000000     ..v.............
c0d05a68:	00ffffff 00000000 000c0000 00000000     ................
	...
c0d05a90:	000e4107 00640003 0000000c 00000000     .A....d.........
c0d05aa0:	00ffffff 00000000 0000800a 00000000     ................
	...
c0d05ac8:	000e4207 00640023 0000000c 00000000     .B..#.d.........
c0d05ad8:	00ffffff 00000000 0000800a 00000000     ................
	...
c0d05b00:	000e1005 00000009 00000000 00000000     ................
c0d05b10:	00ffffff 00000000 00000000 00000000     ................
	...
c0d05b38:	000e2007 00640013 0000000c 00000000     . ....d.........
c0d05b48:	00ffffff 00000000 00008008 00000000     ................
	...
c0d05b70:	000e2107 0064000c 0000000c 00000000     .!....d.........
c0d05b80:	00ffffff 00000000 00008008 00000000     ................
	...
c0d05ba8:	000e2207 0064001a 0000000c 00000000     ."....d.........
c0d05bb8:	00ffffff 00000000 00008008 00000000     ................
	...

c0d05be0 <UX_MENU_END_ENTRY>:
	...

c0d05bfc <HEXDIGITS>:
c0d05bfc:	33323130 37363534 62613938 66656463     0123456789abcdef
c0d05c0c:	00000000                                ....

c0d05c10 <USBD_HID_Desc>:
c0d05c10:	01112109 22220100 ffa00600                       .!...."".

c0d05c19 <HID_ReportDesc>:
c0d05c19:	09ffa006 0901a101 26001503 087500ff     ...........&..u.
c0d05c29:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d05c39:	f100c008                                         ...

c0d05c3c <HID_Desc>:
c0d05c3c:	c0d049f1 c0d04a01 c0d04a11 c0d04a21     .I...J...J..!J..
c0d05c4c:	c0d04a31 c0d04a41 c0d04a51 00000000     1J..AJ..QJ......

c0d05c5c <USBD_HID>:
c0d05c5c:	c0d048e7 c0d04919 c0d0484f 00000000     .H...I..OH......
c0d05c6c:	00000000 c0d04981 c0d04999 00000000     .....I...I......
	...
c0d05c84:	c0d04ab9 c0d04ab9 c0d04ab9 c0d04ac9     .J...J...J...J..

c0d05c94 <USBD_DeviceDesc>:
c0d05c94:	02000112 40000000 00012c97 02010200     .......@.,......
c0d05ca4:	03040103                                         ..

c0d05ca6 <USBD_LangIDDesc>:
c0d05ca6:	04090304                                ....

c0d05caa <USBD_MANUFACTURER_STRING>:
c0d05caa:	004c030e 00640065 00650067 030e0072              ..L.e.d.g.e.r.

c0d05cb8 <USBD_PRODUCT_FS_STRING>:
c0d05cb8:	004e030e 006e0061 0020006f 030a0053              ..N.a.n.o. .S.

c0d05cc6 <USB_SERIAL_STRING>:
c0d05cc6:	0030030a 00300030 02090031                       ..0.0.0.1.

c0d05cd0 <USBD_CfgDesc>:
c0d05cd0:	00290209 c0020101 00040932 00030200     ..).....2.......
c0d05ce0:	21090200 01000111 07002222 40038205     ...!...."".....@
c0d05cf0:	05070100 00400302 00000001              ......@.....

c0d05cfc <USBD_DeviceQualifierDesc>:
c0d05cfc:	0200060a 40000000 00000001              .......@....

c0d05d08 <_etext>:
	...
