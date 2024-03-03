.model small
.stack 100h

.data
    saludo db 'Bienvenido a CalcuTec',13,10,'$'
    op1 db 'Por favor ingrese su primer operando',13,10,'$'
    instr1 db 'Por favor presione:',13,10,'$'
    instr2 db '1. Para sumar',13,10,'$'
    instr3 db '2. Para restar',13,10,'$'
    instr4 db '3. Para multiplicar',13,10,'$'
    instr5 db '4. Para dividir',13,10,'$'
    op2 db 'Por favor ingrese su segundo operando',13,10,'$'
    result db 'El resultado de su operacion es:',13,10,'$'
    cont1 db 'Por favor presione:',13,10,'$'
    cont2 db '1. Para continuar',13,10,'$'
    salir db '2. Para salir',13,10,'$'
    bye db 'Gracias por utilizar CalcuTec',13,10,'$'

.code
start:
    mov ax, @data
    mov ds, ax
	
    mov dx, offset saludo
	mov ah, 9
    int 21h


    mov dx, offset op1
	mov ah, 9
    int 21h
    

    mov dx, offset instr1
	mov ah, 9
    int 21h
	

    mov dx, offset instr2
	mov ah, 9
    int 21h
	
    ; Finalizar
    mov ah, 4ch
	mov al,0
    int 21h
end start