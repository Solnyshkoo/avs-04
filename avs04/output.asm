; file.asm - использование файлов в NASM
extern printf
extern fprintf

extern DistanceCar
extern DistanceBus
extern DistanceTruck

extern CAR 
extern BUS 
extern TRUCK

;----------------------------------------------
;// Вывод параметров машины в файл

global OutCar
OutCar:
section .data
    .outfmt db "It is Car: Fuel capacity = %d, Fuel consumption = %d, Maximum speed = %d. Distance = %g",10,0
section .bss
    .prect  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1      
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.prect], rdi          
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    
    call    DistanceCar
    movsd   [.p], xmm0          


    ; Вывод информациив файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.prect]      
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; y
    mov      r8, [rax+8] 
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров автобуса в файл

global OutBus
OutBus:
section .data
    .outfmt db "It is Bus: Fuel capacity = %d, Fuel consumption = %d, Maximum pearson capacity = %d. Distance = %g",10,0
section .bss
    .ptrian  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1      
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.ptrian], rdi       
    mov     [.FILE], rsi          ; сохраняется указатель на файл

   
    call    DistanceBus
    movsd   [.p], xmm0          


    ; Вывод информации в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.ptrian]      
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; b
    mov      r8, [rax+8]        ; c
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret
;------------------------------------------
;Truck
global OutTruck
OutTruck:
section .data
    .outfmt db "It is Truck: Fuel capacity = %d, Fuel consumption = %d, Lifting capacity = %d. Distance = %g",10,0
section .bss
    .pttruck  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1    
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.pttruck], rdi    
    mov     [.FILE], rsi          ; сохраняется указатель на файл

   
    call    DistanceTruck
    movsd   [.p], xmm0        


    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.pttruck]      
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; b
    mov      r8, [rax+8]        ; c
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров текущей фигуры в файл

global OutShape
OutShape:
section .data
    .erShape db "Incorrect figure!",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [CAR]
    je carOut
    cmp eax, [BUS]
    je busOut
    cmp eax, [TRUCK]
    je truckOut
    ;jmp rectOut
    mov rdi, .erShape
 
    mov rax, 0
    call fprintf
    jmp     return
carOut:
    ; Вывод прямоугольника
    add     rdi, 4
    call    OutCar
    jmp     return
busOut:
    ; Вывод треугольника
    add     rdi, 4
    call    OutBus
    jmp     return
truckOut:
    add     rdi, 4
    call    OutTruck
return:
leave
ret

;----------------------------------------------
; // Вывод содержимого контейнера в файл

global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фигур
    xor ecx, ecx            ; счетчик фигур = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    push rbx
    push rcx

    ; Вывод номера фигуры
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фигуры
    mov     edx, ecx        ; индекс текущей фигуры
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущей фигуры
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutShape     ; Получение периметра первой фигуры

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующей фигуры

    mov     rax, [.pcont]
    add     rax, 16         ; адрес следующей фигуры
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret
