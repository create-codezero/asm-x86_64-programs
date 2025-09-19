global main
extern printf

section .data
    msg db "Hello, world!", 10, 0    ; string + newline + null terminator

section .text
main:
    sub rsp, 40              ; allocate shadow space (Windows x64 ABI requires 32 bytes, align to 16)

    lea rcx, [rel msg]       ; 1st argument → RCX (pointer to string)
    call printf              ; call printf from MSVCRT

    add rsp, 40              ; restore stack

    xor eax, eax             ; return 0
    ret
