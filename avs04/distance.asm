;------------------------------------------------------------------------------
; perimeter.asm - единица компиляции, вбирающая функции вычисления периметра
;------------------------------------------------------------------------------
extern printf
extern CAR
extern BUS
extern TRUCK

;----------------------------------------------
; Вычисление периметра прямоугольника
;double PerimeterRectangle(void *r) {
;    return 2.0 * (*((int*)r)
;           + *((int*)(r+intSize)));
;}
global DistanceCar
DistanceCar:
section .data
    number1 dq 100.0
section .text
push rbp
mov rbp, rsp
   
    mov eax, [rdi]
    cvtsi2sd    xmm0, eax
    mulsd xmm0, [number1]
    mov edx, [rdi+4]
    cvtsi2sd    xmm1, edx
    divsd xmm0, xmm1
leave
ret

;----------------------------------------------
; double PerimeterTriangle(void *t) {
;    return (double)(*((int*)t)
;       + *((int*)(t+intSize))
;       + *((int*)(t+2*intSize)));
;}
global DistanceBus
DistanceBus:
section .text
push rbp
mov rbp, rsp
   
    mov eax, [rdi]
    cvtsi2sd    xmm0, eax
    mulsd xmm0, [number1]
    mov edx, [rdi+4]
    cvtsi2sd    xmm1, edx
    divsd xmm0, xmm1
leave
ret

global DistanceTruck
DistanceTruck:
section .text
push rbp
mov rbp, rsp
   
    mov eax, [rdi]
    cvtsi2sd    xmm0, eax
    mulsd xmm0, [number1]
    mov edx, [rdi+4]
    cvtsi2sd    xmm1, edx
    divsd xmm0, xmm1
leave
ret

;----------------------------------------------
; Вычисление периметра фигуры
;double PerimeterShape(void *s) {
;    int k = *((int*)s);
;    if(k == RECTANGLE) {
;        return PerimeterRectangle(s+intSize);
;    }
;    else if(k == TRIANGLE) {
;        return PerimeterTriangle(s+intSize);
;    }
;    else {
;        return 0.0;
;    }
;}
global DistanceTransport
DistanceTransport:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [CAR]
    je rectPerimeter
    cmp eax, [BUS]
    je trianPerimeter
    cmp eax, [TRUCK]
    je truck
    ;xor eax, eax
    ;cvtsi2sd    xmm0, eax
    jmp     return
rectPerimeter:
    ; Вычисление периметра прямоугольника
    add     rdi, 4
    call    DistanceCar
    jmp     return
trianPerimeter:
    ; Вычисление периметра треугольника
    add     rdi, 4
    call    DistanceBus
    jmp     return
truck:
    add rdi, 4
    call DistanceTruck    
return:
leave
ret

;----------------------------------------------
;// Вычисление суммы периметров всех фигур в контейнере
;double PerimeterSumContainer(void *c, int len) {
;    double sum = 0.0;
;    void *tmp = c;
;    for(int i = 0; i < len; i++) {
;        sum += PerimeterShape(tmp);
;        tmp = tmp + shapeSize;
;    }
;    return sum;
;}
global ShakerSortContainer
ShakerSortContainer:
section .data      

section .bss
    .last resq 1
    .first resq 1
    .i resq 1
    .end resq 1
    .distance1 resq 1;
    .idealtime2 resq 1;
    .next resq 1
    .start resq 1 ; начало контейнера
    .adress1 resq 1;
    .adress2 resq 1;
section .text
push rbp
mov rbp, rsp

; В rdi адрес начала контейнера
    mov [.start], rdi    ; сохраняется указатель на контейнер
    mov [.last], esi            ; число фигур
    mov esi, 0
    mov [.first] , esi
    mov ecx, 1
    xor R12, rax ; non-sorted    
 
.while:
    
    cmp R12, 1
    je .return
    
    mov R12, 1
    mov rdi, [.start]
    mov ecx, 1
    
    .firstloop:
      
        cmp ecx, [.last];if(i == last) break
        je .checkPoint
     
        
        mov [.adress1], rdi
        
        call DistanceTransport
        movsd [.distance1], xmm0
        add rdi, 12
        
        call DistanceTransport
        
        movsd xmm1, xmm0

        movsd xmm0, [.distance1]
        
        mov rdi, [.adress1]
        
        cld
        UCOMISD xmm0,xmm1
        ja .change 
       
                 
        jmp .continueFirstloop
   .change:
       mov [.next], R12
       
       mov eax, [rdi]
       mov edx, [rdi +16]
       mov [rdi], edx
       mov [rdi +16], eax
        
       mov eax, [rdi +4]
       mov edx, [rdi +20]
       mov [rdi +4], edx
       mov [rdi +20], eax
        
       mov eax, [rdi +8]
       mov edx, [rdi +24]
       mov [rdi +8], edx
       mov [rdi +24], eax
        
       mov eax, [rdi +12]
       mov edx, [rdi +28]
       mov [rdi +12], edx
       mov [rdi +28], eax
      
       mov R12, [.next]
      
       mov R12, 0 ; sorted = false 
   
    .continueFirstloop:       
             ; адрес следующей фигуры
        add rdi, 16
        
        inc ecx
        ;movsd xmm0, [.start]
        
        jmp .firstloop
        
    .checkPoint:  
        cmp R12, 1
        je  .return
      
      
   .secondloop:
      
        cmp ecx, [.first];if(i == first) break
        je .checkSecondPoint
    
        
        mov [.adress1], rdi
        
        call DistanceTransport
        movsd [.distance1], xmm0
        sub rdi, 20
        
        call DistanceTransport
        
        movsd xmm1, xmm0

        movsd xmm0, [.distance1]
        
        mov rdi, [.adress1]
        
        cld
        UCOMISD xmm0,xmm1

        jb .changeTwo
       
                 
        jmp .continueSecondloop
 
        
     .changeTwo:
        mov [.next], R12
         
        mov eax, [rdi]
        mov edx, [rdi -16]
        mov [rdi], edx
        mov [rdi -16], eax
        ;
        mov eax, [rdi +4]
        mov edx, [rdi -12]
        mov [rdi +4], edx
        mov [rdi -12], eax
        
        mov eax, [rdi +8]
        mov edx, [rdi -8]
        mov [rdi +8], edx
        mov [rdi -8], eax
        
        mov eax, [rdi +12]
        mov edx, [rdi -4]
        mov [rdi +12], edx
        mov [rdi -4], eax
      
        mov R12, [.next]
          
        mov R12, 0 ; sorted = false 
      
     .continueSecondloop:
        sub rdi, 16      ; адрес следующей фигуры
        
        dec ecx
        
        jmp .secondloop
       
     .checkSecondPoint:

        cmp R12, 1
        je  .return
        jmp .while
    
.return:

   mov rdi, [.start]
   ; movsd xmm0, xmm1
   mov esi, [.last]
    ;call fprintf

leave
ret

