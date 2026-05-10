#ifndef SAM_API_H
#define SAM_API_H

#define SAM_API_EXPORT __attribute__((visibility("default")))
#define SAM_SUCCESS 0
#define SAM_ERROR 1

#ifdef __cplusplus
extern "C" {
#endif

int sam_text_to_u8_buff(const char* text, int speed, const char** buff, int* buff_length);

#ifdef __cplusplus
}
#endif

#endif  // SAM_API_H
