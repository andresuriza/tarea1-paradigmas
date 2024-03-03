org 100h

.data
	saludo: db 'Bienvenido a CalcuTec',13,10,'$'
	op1: db 'Por favor ingrese su primer operando',13,10,'$'
	instr1: db 'Por favor presione:',13,10,'$'
	instr2: db '1. Para sumar',13,10,'$'
	instr3: db '2. Para restar',13,10,'$'
	instr4: db '3. Para multiplicar',13,10,'$'
	instr5: db '4. Para dividir',13,10, '$'
	op2: db 13,10,'Por favor ingrese su segundo operando',13, 10,'$'
	result: db 13,10,'El resultado de su operacion es:',13,10,'$'
	cont1: db 13,10,'Por favor presione:',13,10,'$'
	cont2: db '1. Para continuar',13,10,'$'
	salir: db '2. Para salir',13,10,'$'
	bye: db 'Gracias por utilizar CalcuTec',13,10,'$'
	error: db 'Entrada erronea',13,10,'$'
.code
	start:
		mov ax, @data
		mov ds, ax
		
		mov ah, 9
		mov dx, offset saludo
		int 21h
		
		mov ah, 9
		mov dx, offset instr1
		int 21h
		
		mov ah, 9
		mov dx, offset instr2
		int 21h
		
		mov ah, 9
		mov dx, offset instr3
		int 21h
		
		mov ah, 9
		mov dx, offset instr4
		int 21h
		
		mov ah, 9
		mov dx, offset instr5
		int 21h
		
		mov ah, 0
		int 16h
		cmp al,31h
		je Suma
		cmp al,32h
		je Resta
		cmp al, 33h
		je Multiplicar
		cmp al, 34h
		je Dividir
		
		mov ah, 9
		mov dx, offset error
		int 21h
		
		mov ah,0
		int 16h
		jmp start

	Suma:
		mov ah, 9
		mov dx, offset op1
		int 21h
		
		mov cx, 0
		call NumEntrada
		push dx
		mov ah, 9
		mov dx, offset op2
		int 21h
		mov cx, 0
		call NumEntrada
		pop bx
		add dx, bx
		push dx
		mov ah, 9
		mov dx, offset result
		int 21h
		mov cx, 10000
		pop dx
		call Mostrar
		jmp exit

	NumEntrada:
		mov ah, 0
		int 16h
		mov dx, 0
		mov bx, 1
		cmp al, 0dh
		je CreaNum
		sub ax, 30h
		call MostrarNo
		mov ah, 0
		push ax
		inc cx
		jmp NumEntrada

	CreaNum:
		pop ax
		push dx
		mul bx
		pop dx
		add dx, ax
		mov ax, bx
		mov bx, 10
		push dx
		mul bx
		pop dx
		mov bx, ax
		dec cx
		cmp cx, 0
		jne CreaNum
		ret

	Mostrar:
		mov ax, dx
		mov dx, 0
		div cx
		call MostrarNo
		mov bx, dx
		mov dx, 0
		mov ax, cx
		mov cx, 10
		div cx
		mov dx, bx
		mov cx, ax
		cmp ax, 0
		jne Mostrar
		ret

	MostrarNo:
		push ax
		push dx
		mov dx, ax
		add dl, 30h
		mov ah, 2
		int 21h
		pop dx
		pop ax
		ret

	exit:
		mov dx, offset cont1
		mov ah, 9
		int 21h
		
		mov dx, offset cont2
		mov ah, 9
		int 21h
		
		mov dx, offset salir
		mov ah, 9
		int 21h
		
		mov ah, 0
		int 16h
		cmp al, 31h
		mov ax, 0
		je start
		
		mov dx, offset bye
		mov ah, 9
		int 21h
		
		ret

	Multiplicar:
		mov ah, 9
		mov dx, offset op1
		int 21h
		
		mov cx, 0
		call NumEntrada
		push dx
		mov ah, 9
		mov dx, offset op2
		int 21h
		mov cx, 0
		call NumEntrada
		pop bx
		mov ax, dx
		mul bx
		mov dx, ax
		push dx
		mov ah, 9
		mov dx, offset result
		int 21h
		mov cx, 10000
		pop dx
		call Mostrar
		jmp exit

	Resta:
		mov ah, 9
		mov dx, offset op1
		int 21h
		mov cx, 0
		call NumEntrada
		push dx
		mov ah, 9
		mov dx, offset op2
		int 21h
		mov cx, 0
		call NumEntrada
		pop bx
		sub bx, dx
		mov dx, bx
		push dx
		mov ah, 9
		mov dx, offset result
		int 21h
		mov cx, 10000
		pop dx
		call Mostrar
		jmp exit

	Dividir:
		mov ah, 9
		mov dx, offset op1
		int 21h
		
		mov cx, 0
		call NumEntrada
		push dx
		mov ah, 9
		mov dx, offset op2
		int 21h
		mov cx, 0
		call NumEntrada
		pop bx
		mov ax, bx
		mov cx, dx
		mov dx, 0
		mov bx, 0
		div cx
		mov bx, dx
		mov dx, ax
		push bx
		push dx
		mov ah, 9
		mov dx, offset result
		int 21h
		mov cx, 10000
		pop dx
		call Mostrar
		jmp exit