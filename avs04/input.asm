; file.asm - использование файлов в NASM
extern printf
extern fscanf

extern CAR
extern BUS
extern TRUCK
;----------------------------------------------
; // Ввод параметров машины из файла

global InCar
InCar:
section .data
    .infmt db "%d%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .prect  resq    1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.prect], rdi          ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.prect]       ; &x
    mov     rcx, [.prect]
    add     rcx, 4              ; &y = &x + 4
    mov     r8, [.prect]
    add     r8, 8               ; &c = &x + 8
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

; // Ввод параметров автобуса из файла

global InBus
InBus:
section .data
    .infmt db "%d%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .trian  resq    1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.trian], rdi          ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод треугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.trian]       ; &a
    mov     rcx, [.trian]
    add     rcx, 4              ; &b = &a + 4
    mov     r8, [.trian]
    add     r8, 8               ; &c = &x + 8
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

;_____________________________________
; // Ввод параметров грузовика из файла

global InTruck
InTruck:
section .data
    .infmt db "%d%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .pttruck  resq    1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pttruck], rdi          ; сохраняется адрес треугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод треугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.pttruck]       ; &a
    mov     rcx, [.pttruck]
    add     rcx, 4              ; &b = &a + 4
    mov     r8, [.pttruck]
    add     r8, 8               ; &c = &x + 8
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

; // Ввод параметров обобщенной фигуры из файла

global InTransport
InTransport:
section .data
    .tagFormat   db      "%d",0
    .tagOutFmt   db     "Tag is: %d",10,0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .pshape     resq    1   ; адрес фигуры
    .shapeTag   resd    1   ; признак фигуры
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pshape], rdi          ; сохраняется адрес фигуры
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фигуры и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pshape]      ; адрес начала фигуры (ее признак)
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fscanf

    ; Тестовый вывод признака фигуры
;     mov     rdi, .tagOutFmt
;     mov     rax, [.pshape]
;     mov     esi, [rax]
;     call    printf

    mov rcx, [.pshape]          ; загрузка адреса начала фигуры
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [CAR]
    je .carIn
    cmp eax, [BUS]
    je .busIn
    cmp eax, [TRUCK]
    je .truckIn
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return
.carIn:
    ; Ввод прямоугольника
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InCar
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.busIn:
    ; Ввод треугольника
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InBus
    mov     rax, 1  ; Код возврата - true
    jmp     .return
    
.truckIn:
; Ввод truck
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InTruck
    mov     rax, 1  ; Код возврата - true
    jmp     .return
    
.return:

leave
ret

; // Ввод содержимого контейнера из указанного файла

global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx        ; число фигур = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; нет чисел с плавающей точкой
    call    InTransport     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rbx
    inc rbx

    pop rdi
    add rdi, 16             ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret

