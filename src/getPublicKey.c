#include <stdint.h>
#include <stdbool.h>
#include <os.h>
#include <os_io_seproxyhal.h>
#include "harmony.h"
#include "ux.h"

// Get a pointer to getPublicKey's state variables.
static getPublicKeyContext_t *ctx = &global.getPublicKeyContext;

// Define the comparison screen. This is where the user will compare the
// public key (or address) on their device to the one shown on the computer.
static const bagl_element_t ui_getPublicKey_compare[] = {
	UI_BACKGROUND(),
	UI_ICON_LEFT(0x01, BAGL_GLYPH_ICON_LEFT),
	UI_ICON_RIGHT(0x02, BAGL_GLYPH_ICON_RIGHT),
	UI_TEXT(0x00, 0, 12, 128, "Compare:"),
	// The visible portion of the public key or address.
	UI_TEXT(0x00, 0, 26, 128, global.getPublicKeyContext.partialStr),
};

static const bagl_element_t* ui_prepro_getPublicKey_compare(const bagl_element_t *element) {
    switch (element->component.userid) {
        case 1:
            return (ctx->displayIndex == 0) ? NULL : element;
        case 2:
            return (ctx->displayIndex >= 42 - 12) ? NULL : element;
        default:
            return element;
    }
}

// Define the button handler for the comparison screen. Again, this is nearly
// identical to the signHash comparison button handler.
static unsigned int ui_getPublicKey_compare_button(unsigned int button_mask, unsigned int button_mask_counter) {
	switch (button_mask) {
	case BUTTON_LEFT:
	case BUTTON_EVT_FAST | BUTTON_LEFT: // SEEK LEFT
		if (ctx->displayIndex > 0) {
			ctx->displayIndex--;
		}
		os_memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
		UX_REDISPLAY();
		break;

	case BUTTON_RIGHT:
	case BUTTON_EVT_FAST | BUTTON_RIGHT: // SEEK RIGHT
		if (ctx->displayIndex < 42 - 12) {
			ctx->displayIndex++;
		}
		os_memmove(ctx->partialStr, ctx->fullStr+ctx->displayIndex, 12);
		UX_REDISPLAY();
		break;

	case BUTTON_EVT_RELEASED | BUTTON_LEFT | BUTTON_RIGHT: // PROCEED
		// The user has finished comparing, so return to the main screen.
		ui_idle();
		break;
	}
	return 0;
}

static const bagl_element_t ui_getPublicKey_approve[] = {
	UI_BACKGROUND(),
	UI_ICON_LEFT(0x00, BAGL_GLYPH_ICON_CROSS),
	UI_ICON_RIGHT(0x00, BAGL_GLYPH_ICON_CHECK),

	UI_TEXT(0x00, 0, 12, 128, global.getPublicKeyContext.typeStr),
};

static unsigned int ui_getPublicKey_approve_button(unsigned int button_mask, unsigned int button_mask_counter) {
	uint16_t tx = 0;
	cx_ecfp_public_key_t publicKey;
	switch (button_mask) {
	case BUTTON_EVT_RELEASED | BUTTON_LEFT: // REJECT
		io_exchange_with_code(SW_USER_REJECTED, 0);
		ui_idle();
		break;

	case BUTTON_EVT_RELEASED | BUTTON_RIGHT: // APPROVE
		// Derive the public key and address and store them in the APDU
		// buffer. Even though we know that tx starts at 0, it's best to
		// always add it explicitly; this prevents a bug if we reorder the
		// statements later.
		deriveOneKeypair(NULL, &publicKey);

		pubkeyToOneAddress(G_io_apdu_buffer + tx, &publicKey);
		tx += 42;
		// Flush the APDU buffer, sending the response.
		io_exchange_with_code(SW_OK, tx);

		// Prepare the comparison screen, filling in the header and body text.
		os_memmove(ctx->typeStr, "Compare:", 9);
		os_memmove(ctx->fullStr, G_io_apdu_buffer, 42);
		ctx->fullStr[42] = '\0';

		os_memmove(ctx->partialStr, ctx->fullStr, 12);
		ctx->partialStr[12] = '\0';
		ctx->displayIndex = 0;

		// Display the comparison screen.
		UX_DISPLAY(ui_getPublicKey_compare, ui_prepro_getPublicKey_compare);
		break;
	}
	return 0;
}

// These are APDU parameters that control the behavior of the getPublicKey
// command.
#define P2_DISPLAY_ADDRESS 0x00
#define P2_DISPLAY_PUBKEY  0x01

void handleGetPublicKey(uint8_t p1, uint8_t p2, uint8_t *dataBuffer, uint16_t dataLength, volatile unsigned int *flags, volatile unsigned int *tx) {
    os_memset(ctx, 0, sizeof(getPublicKeyContext_t));

	// Sanity-check the command parameters.
	if ((p2 != P2_DISPLAY_ADDRESS) && (p2 != P2_DISPLAY_PUBKEY)) {
		THROW(SW_INVALID_PARAM);
	}

	ctx->genAddr = (p2 == P2_DISPLAY_ADDRESS);
	// Prepare the approval screen, filling in the header and body text.
	os_memmove(ctx->typeStr, "Display Address?", 17);
	UX_DISPLAY(ui_getPublicKey_approve, NULL);
	
	*flags |= IO_ASYNCH_REPLY;
}

