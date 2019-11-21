.globl main
main:
.include "strlen_main.asm"
.include "index_of_main.asm"
.include "bytecopy_main.asm"
.include "scramble_encrypt_main.asm"
.include "scramble_decrypt_main.asm"
.include "base64_encode_main.asm"
.include "base64_decode_main.asm"
.include "bifid_encrypt_main.asm"
.include "bifid_decrypt_main.asm"

li $v0, 10
syscall

.include "proj2.asm"