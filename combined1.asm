default rel
extern printf, scanf, fgets, __acrt_iob_func, fflush, fgetc

section .data
    menu    db "Choose option:",10
            db "1. Print Hello",10
            db "2. Sum of two numbers",10
            db "3. Factorial",10
            db "4. Fibonacci",10
            db "5. String Reverse (supports spaces)",10
            db "6. Array Sum/Max/Min",10
            db "0. Exit",10,0

    prompt1 db "Enter first number: ",0
    prompt2 db "Enter second number: ",0
    promptn db "Enter n: ",0
    promptstr db "Enter a string (press Enter when done): ",0

    fmt_int db "%d",0
    fmt_sum db "Sum = %d",10,0
    fmt_hello db "Hello, World!",10,0
    fmt_fact db "Factorial(%d) = %d",10,0
    fmt_fib db "Fibonacci(%d) = %d",10,0
    fmt_rev db "Reversed: %s",10,0
    fmt_arr db "Array elements: 3,7,2,9,5",10,0
    fmt_arrsum db "Array sum = %d",10,0
    fmt_arrmax db "Array max = %d",10,0
    fmt_arrmin db "Array min = %d",10,0

    stdin_ptr dq 0
    stdout_ptr dq 0

section .bss
    num1 resd 1
    num2 resd 1
    nval resd 1
    buf  resb 128

section .data
    arr dd 3,7,2,9,5
    arrlen equ 5

section .text
    global main

main:
    ; initialize stdin/stdout pointers
    mov ecx,0
    call __acrt_iob_func
    mov [stdin_ptr], rax

    mov ecx,1
    call __acrt_iob_func
    mov [stdout_ptr], rax

main_loop:
    sub rsp, 40
    mov rcx, menu
    call printf
    add rsp, 40

    sub rsp, 40
    mov rcx, fmt_int
    lea rdx, [rel nval]
    call scanf
    add rsp, 40
    call clear_stdin

    mov eax, [rel nval]
    cmp eax, 1
    je do_hello
    cmp eax, 2
    je do_sum
    cmp eax, 3
    je do_fact
    cmp eax, 4
    je do_fib
    cmp eax, 5
    je do_reverse
    cmp eax, 6
    je do_array
    cmp eax, 0
    je do_exit
    jmp main_loop

; ------------------------
do_hello:
    sub rsp, 40
    mov rcx, fmt_hello
    call printf
    add rsp, 40
    jmp main_loop

; ------------------------
do_sum:
    ; prompt1
    sub rsp, 40
    mov rcx, prompt1
    call printf
    add rsp, 40
    sub rsp, 40
    mov rcx, [stdout_ptr]
    call fflush
    add rsp, 40

    sub rsp, 40
    mov rcx, fmt_int
    lea rdx, [rel num1]
    call scanf
    add rsp, 40
    call clear_stdin

    ; prompt2
    sub rsp, 40
    mov rcx, prompt2
    call printf
    add rsp, 40
    sub rsp, 40
    mov rcx, [stdout_ptr]
    call fflush
    add rsp, 40

    sub rsp, 40
    mov rcx, fmt_int
    lea rdx, [rel num2]
    call scanf
    add rsp, 40
    call clear_stdin

    mov eax, [rel num1]
    add eax, [rel num2]

    sub rsp, 40
    mov rcx, fmt_sum
    mov edx, eax
    call printf
    add rsp, 40
    jmp main_loop

; ------------------------
do_fact:
    ; promptn
    sub rsp, 40
    mov rcx, promptn
    call printf
    add rsp, 40
    sub rsp, 40
    mov rcx, [stdout_ptr]
    call fflush
    add rsp, 40

    sub rsp, 40
    mov rcx, fmt_int
    lea rdx, [rel nval]
    call scanf
    add rsp, 40
    call clear_stdin

    mov ecx, [rel nval]
    mov eax, 1
.fact_loop:
    cmp ecx, 1
    jl .fact_done
    imul eax, ecx
    dec ecx
    jmp .fact_loop
.fact_done:
    sub rsp, 40
    mov rcx, fmt_fact
    mov edx, [rel nval]
    mov r8d, eax
    call printf
    add rsp, 40
    jmp main_loop

; ------------------------
do_fib:
    ; promptn
    sub rsp, 40
    mov rcx, promptn
    call printf
    add rsp, 40
    sub rsp, 40
    mov rcx, [stdout_ptr]
    call fflush
    add rsp, 40

    sub rsp, 40
    mov rcx, fmt_int
    lea rdx, [rel nval]
    call scanf
    add rsp, 40
    call clear_stdin

    mov ecx, [rel nval]
    cmp ecx, 0
    jl .fib_done
    cmp ecx, 1
    jle .fib_base

    mov eax, 0
    mov ebx, 1
    mov edx, 2
.fib_loop:
    cmp edx, ecx
    jg .fib_end
    mov esi, eax
    add esi, ebx
    mov eax, ebx
    mov ebx, esi
    inc edx
    jmp .fib_loop
.fib_end:
    mov eax, ebx
    jmp .fib_print
.fib_base:
    mov eax, ecx
.fib_print:
    sub rsp, 40
    mov rcx, fmt_fib
    mov edx, [rel nval]
    mov r8d, eax
    call printf
    add rsp, 40
.fib_done:
    jmp main_loop

; ------------------------
do_reverse:
    ; promptstr
    sub rsp, 40
    mov rcx, promptstr
    call printf
    add rsp, 40
    sub rsp, 40
    mov rcx, [stdout_ptr]
    call fflush
    add rsp, 40

    ; fgets(buf,128,stdin)
    sub rsp, 40
    lea rcx, [rel buf]
    mov edx, 128
    mov r8, [rel stdin_ptr]
    call fgets
    add rsp, 40

    ; strip newline
    lea rsi, [rel buf]
.strip_nl:
    mov al, [rsi]
    cmp al, 0
    je .done_strip
    cmp al, 10
    jne .cont_strip
    mov byte [rsi], 0
    jmp .done_strip
.cont_strip:
    inc rsi
    jmp .strip_nl
.done_strip:

    ; reverse in-place
    lea rsi, [rel buf]
    lea rdi, [rel buf]
.find_end:
    cmp byte [rdi], 0
    je .found_end
    inc rdi
    jmp .find_end
.found_end:
    dec rdi
.revloop:
    cmp rsi, rdi
    jge .revdone
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp .revloop
.revdone:
    sub rsp, 40
    mov rcx, fmt_rev
    lea rdx, [rel buf]
    call printf
    add rsp, 40
    jmp main_loop

; ------------------------
do_array:
    sub rsp, 40
    mov rcx, fmt_arr
    call printf
    add rsp, 40

    xor eax, eax
    mov ecx, arrlen
    lea rsi, [rel arr]
    xor edx, edx
.sum_loop:
    cmp ecx, 0
    je .sum_done
    add eax, [rsi + rdx*4]
    inc rdx
    dec ecx
    jmp .sum_loop
.sum_done:
    sub rsp, 40
    mov rcx, fmt_arrsum
    mov edx, eax
    call printf
    add rsp, 40

    lea rsi, [rel arr]
    mov eax, [rsi]
    mov ebx, eax
    mov edi, eax
    mov edx, 1
.maxmin_loop:
    cmp edx, arrlen
    jge .maxmin_done
    mov eax, [rsi + rdx*4]
    cmp eax, ebx
    jg .new_max
    cmp eax, edi
    jl .new_min
    jmp .cont
.new_max:
    mov ebx, eax
    jmp .cont
.new_min:
    mov edi, eax
.cont:
    inc edx
    jmp .maxmin_loop
.maxmin_done:
    sub rsp, 40
    mov rcx, fmt_arrmax
    mov edx, ebx
    call printf
    add rsp, 40

    sub rsp, 40
    mov rcx, fmt_arrmin
    mov edx, edi
    call printf
    add rsp, 40

    jmp main_loop

; ------------------------
do_exit:
    xor eax, eax
    ret

; ------------------------
; helper: clear leftover stdin until newline
clear_stdin:
.clear_loop:
    sub rsp, 40
    mov rcx, [stdin_ptr]
    call fgetc
    add rsp, 40
    cmp eax, 10
    je .done_clear
    cmp eax, -1
    je .done_clear
    jmp .clear_loop
.done_clear:
    ret
