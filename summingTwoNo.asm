extern printf
section .data
    fmt db "Sum of %d and %d is %d", 10, 0  ; format string

section .text
    global main
main:
    sub rsp, 40           ; align + shadow space (32 bytes)
    
    mov rcx, fmt          ; 1st arg = format string
    mov rdx, 5            ; 2nd arg
    mov r8, 7             ; 3rd arg
    mov r9, 12            ; 4th arg
    call printf

    add rsp, 40
    xor eax, eax
    ret
