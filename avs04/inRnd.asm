; file.asm - использование файлов в NASM
extern printf
extern rand

extern CAR
extern BUS
extern TRUCK


;----------------------------------------------
; // rnd.c - содержит генератор случайных чисел в диапазоне от 1 до 399
; int Random() {
;     return rand() % 20 + 1;
; }
global Random
Random:
section .data
    .i20     dq      399
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf


leave
ret

global RandomTransport
RandomTransport:
section .data
    .i20     dq      3
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число
leave
ret

;----------------------------------------------
;// Случайный ввод параметров прямоугольника

global InRndCar
InRndCar:
section .bss
    .prect  resq 1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov     [.prect], rdi
    ; Генерация сторон прямоугольника
    call    Random
    mov     rbx, [.prect]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.prect]
    mov     [rbx+4], eax
    call    Random
    mov     rbx, [.prect]
    mov     [rbx+8], eax

leave
ret

;----------------------------------------------
;// Случайный ввод параметров треугольника

global InRndBus
InRndBus:
section .bss
    .ptrian  resq 1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov     [.ptrian], rdi
    ; Генерация сторон треугольника
    call    Random
    mov     rbx, [.ptrian]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.ptrian]
    mov     [rbx+4], eax
    call    Random
    mov     rbx, [.ptrian]
    mov     [rbx+8], eax
leave
ret
;----------------------------------------------
;// Случайный ввод параметров Truck

global InRndTr
InRndTr:
section .bss
    .pttruck  resq 1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov     [.pttruck] , rdi
    ; Генерация сторон треугольника
    call    Random
    mov     rbx, [.pttruck]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.pttruck]
    mov     [rbx+4], eax
    call    Random
    mov     rbx, [.pttruck]
    mov     [rbx+8], eax
leave
ret
;----------------------------------------------
;// Случайный ввод обобщенной фигуры

global InRndTransport
InRndTransport:
section .data
    .rndNumFmt       db "Random number = %d",10,0
section .bss
    .pshape     resq    1   ; адрес фигуры
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov [.pshape], rdi

    ; Формирование признака фигуры
    xor     rax, rax    ;
    call    RandomTransport ; запуск генератора случайных чисел

    mov     rdi, [.pshape]
    mov     [rdi], eax      ; запись ключа в фигуру
    cmp eax, [CAR]
    je .carInrnd
    cmp eax, [BUS]
    je .busInRnd
    cmp eax, [TRUCK]
    je .truckInRnd
    xor eax, eax        ; код возврата = 0
    jmp    .return
.carInrnd:
    ; Генерация прямоугольника
    add     rdi, 4
    call    InRndCar
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.busInRnd:
    ; Генерация треугольника
    add     rdi, 4
    call    InRndBus
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.truckInRnd:
    add     rdi, 4
    call    InRndTr
    mov     eax, 1 
    jmp     .return
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера

global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.psize], edx    ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx        ; число фигур = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx

    call    InRndTransport     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 16       ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
