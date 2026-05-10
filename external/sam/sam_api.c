#include "sam_api.h"

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "reciter.h"
#include "sam.h"

int debug = 0;

int sam_text_to_u8_buff(const char* text, int speed, const char** buff, int* buff_length) {
    if (text == NULL) return -1;

    if (speed <= 0) speed = 72; // default speed

    SetSpeed(speed);

    size_t input_size = strlen(text) + 1;

    char input[256];
    memset(input, 0, sizeof(input));

    strncat(input, text, 255);
    strncat(input, " ", 255);

    for(int i=0; input[i] != 0; ++i)
        input[i] = toupper((int)input[i]);

    strncat(input, "[", 256);
    if (!TextToPhonemes(input)) {
        return SAM_ERROR;
    }

    SetInput(input);

    if (!SAMMain()) {
        return SAM_ERROR;
    }

    *buff = GetBuffer();
    *buff_length = GetBufferLength() / 50;

    return SAM_SUCCESS;;
}
