.model small 
.data
str1 db '$$$$$'
strDecimal db ".$$"   ; Define the string ".$"

.stack 10h
                 
.code
mov ax, @data ;carga la direccion en ax
mov ds,ax ; copia el segmento al registro de datos

mov ax,5093
mov bx,3
div bx
jmp displayEntero
calcDec:;segmento que imprime el punto y 2 decimales
mov ah, 09h
mov dx,offset strDecimal
int 21h
;guarda el segundo numero
xor ax,ax
xor bx,bx

mov ax,5093;vuelve a registrar el primer numero en ax
xor dx,dx
mov bx, 3
div bx ;divide, en dx va a quedar el residuo y en ax el cociente
;el residuo se multiplica por 10
mov ax,dx
mov bx,10;(20)
mul bx 

;luego se divide ax entre el segundo numero para obtener el decimal
mov bx,3
div bx ;en ax quedara el decimal (6) y en dx el residuo (2)
mov cx,dx ;en cx queda 2
mov bx,10
mul bx ;en ax queda (60)
mov bx,ax ;en bx queda 60
mov ax, cx;en ax queda 2 
mov cx, bx ;en cx queda 60
mov bx,10
mul bx ;en ax va a quedar 20
mov bx,3
div bx ;en ax me quedaria 6 o el segundo decimal
mov bx, cx ;en bx queda 60
mov cx,ax;cx(6)
mov ax, bx ;ax(60)
add ax,cx ;60+6
mov bx,100
mul bx
;en ax deberia quedar 6600


jmp displayDecimal1

;jmp displayDecimal2;muestra el primer decimal


;procede a terminar el programa
jmp terminateProgram                     
      
      
displayEntero:;proceso que va a anadir los numeros al stack
    ;en ax esta el numero a imprimir
    xor cx,cx ;cx seteado como 0
    nextdiv:
    xor dx, dx; reseteado a 0
    mov bx,10
    div bx
    add dx,'0'; convierte el residuo en ascii, el residuo queda en dx y el cociente en ax
    push dx ;lo mete en el stack
    inc cx
    cmp ax,0 ;si ax es 0, es true (como un if)
    je popq
    jmp nextdiv
    
    ret
    
    push ax
    popq:
    lea bx,str1
    xor si,si;si sera el indice
    popnext:
    pop dx
    mov [bx+si],dl
    inc si
    loop popnext
    mov dx,bx
    ;-----------------------
    
    mov ah,09h;imprime el string
    int 21h
jmp calcDec

displayDecimal1:
    ;en ax esta el numero a imprimir
    xor cx,cx ;cx seteado como 0
    nextdivDecimal1:
    xor dx, dx; reseteado a 0
    mov bx,10
    div bx
    add dx,'0'; convierte el residuo en ascii, el residuo queda en dx y el cociente en ax
    push dx ;lo mete en el stack
    inc cx
    cmp ax,0 ;si ax es 0, es true (como un if)
    je popqDecimal1
    jmp nextdivDecimal1
    
    ret
    
    popqDecimal1:
    lea bx,str1
    xor si,si;si sera el indice
    popnextDecimal1:
    pop dx
    mov [bx+si],dl
    inc si
    loop popnextDecimal1
    mov dx,bx
    ;-----------------------
    mov ah,09h;imprime el string
    int 21h    
   
    
jmp terminateProgram

 

terminateProgram:
mov ah,04ch
int 21h
end


    
    