; TODO: Entradas y salidas de punto flotante, verificación de limites -9999, 9999, entradas y salidas negativas
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
	
	negativo1 db 0  
	negativo2 db 0   
	resultN: db '-$'
	
.code
	; Label que maneja los mensajes iniciales del programa y espera a que el usuario ingrese una operacion
	start:
		mov ax, @data ; Cargar los strings en ax
		mov ds, ax	; Guardarlos en ds
		
		;------------ Mensajes de bienvenida------------------
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
		
		mov ah, 0	; Lee entrada
		int 16h
		
		cmp al,31h	; Si usuario escoje 1, es suma
		je Suma		
		cmp al,32h	; Si usuario escoje 2, es resta
		je Resta
		cmp al, 33h	; Si usuario escoje 3, es multiplicacion
		je Multiplicar
		cmp al, 34h	; Si usuario escoje 4, es division
		je Dividir
		
		mov ah, 9
		mov dx, offset error	; Else, error
		int 21h
		
		mov ah,0
		int 16h
		jmp start
		
    HayNegativo1: ;Ver si es un -
        mov negativo1, 1 ;cambiar la variable a 1
        mov ah, 9
		mov dx, offset resultN	; Mensaje de resultado
		int 21h  
        mov ah, 0
        int 16h  
        jmp PG1 
    
    HayNegativo2: ;Ver si es un -
        mov negativo2, 1 ;cambiar la variable a 1
        mov ah, 9
		mov dx, offset resultN	; Mensaje de resultado
		int 21h   
        mov ah, 0
        int 16h
        jmp PG2  
     HayNegativo3: ;Ver si es un -
        mov negativo1, 1 ;cambiar la variable a 1
        mov ah, 9
		mov dx, offset resultN	; Mensaje de resultado
		int 21h  
        mov ah, 0
        int 16h  
        jmp PG3 
    
    HayNegativo4: ;Ver si es un -
        mov negativo2, 1 ;cambiar la variable a 1
        mov ah, 9
		mov dx, offset resultN	; Mensaje de resultado
		int 21h   
        mov ah, 0
        int 16h
        jmp PG4  
    HayNegativo5: ;Ver si es un -
        mov negativo1, 1 ;cambiar la variable a 1
        mov ah, 9
		mov dx, offset resultN	; Mensaje de resultado
		int 21h   
        mov ah, 0
        int 16h
        jmp PG5 
    HayNegativo6: ;Ver si es un -
        mov negativo2, 1 ;cambiar la variable a 1
        mov ah, 9
		mov dx, offset resultN	; Mensaje de resultado
		int 21h   
        mov ah, 0
        int 16h
        jmp PG6 
    HayNegativo7: ;Ver si es un -
        mov negativo1, 1 ;cambiar la variable a 1
        mov ah, 9
		mov dx, offset resultN	; Mensaje de resultado
		int 21h   
        mov ah, 0
        int 16h
        jmp PG7
    HayNegativo8: ;Ver si es un -
        mov negativo2, 1 ;cambiar la variable a 1
        mov ah, 9
		mov dx, offset resultN	; Mensaje de resultado
		int 21h   
        mov ah, 0
        int 16h
        jmp PG8 
	; Label que maneja la operacion de suma
	Suma:
		mov ah, 9
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		mov ah, 0
        int 16h  
        cmp al, 2Dh ;Ver si es -
		je HayNegativo1 ;Si es - 
	PG1:
		mov cx, 0	; Establece counter en 0
		call NumEntrada
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov ah, 0
        int 16h   
        cmp al, 2Dh ;Ver si es -
		je HayNegativo2 ;Si es - 
	PG2:
		mov cx, 0	; Counter en 0
		call NumEntrada
		pop bx	; Guarda operando anterior en bx
		mov al, negativo1 ;Indicador de negativo
		cmp al, negativo2 ;Compara los signos de los operando
		je Suma1
		cmp al, 1 ;Ver si el primer operando es negativo
		je Suma2    
		mov al, negativo2
		cmp al, 1 ;Ver si el segundo operando es negativo
		je Suma3
	Suma1: ;Caso suma: los dos operando tienen mismo signo
	    cmp al, 1 ;Ver si el primer operando es negativo  
	    je Suma11   
	Resta1: ;Caso resta: segundo operando es negativo 
	    add dx, bx	; Suma los numeros
		push dx	; Guarda resultado en stack
		mov ah, 9
		mov dx, offset result	; Mensaje de resultado
		int 21h
		
		mov cx, 10000 ; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
		jmp exit 
	Suma11: ;Caso suma: los dos operando son negativos, Caso resta: primer opernado negativo
	    add dx, bx	; Suma los numeros
		push dx	; Guarda resultado en stack
		mov ah, 9
		mov dx, offset result	; Mensaje de resultado
		int 21h
		
		mov dx, offset resultN ;Imprimir -
		int 21h 
		mov cx, 10000 ; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado  
		jmp exit
	Suma2: ;Caso suma: primer operando negativo
	    cmp bx, dx
	    jle SCaso2 
	    jmp SCaso1 
	    
	SCaso1: ;Caso: primer operando mayor que segundo operando
	   sub bx, dx
	   push dx
	   mov ah, 9
	   mov dx, offset result
	   int 21h                
	   
	   mov dx, offset resultN  
	   int 21h
	   mov cx, 10000
	   pop dx
	   call Resultado
	   jmp exit   
	SCaso2: ;Caso: segundo operando mayor o igual que primer operando
	   sub dx, bx
	    push dx
	    mov ah, 9
	    mov dx, offset result
	    int 21h
	    
	    mov cx, 10000
	    pop dx
	    call Resultado
	    jmp exit
	SCaso3: ;Caso: primer operando mayor que segundo operando
	   sub bx, dx 
	   mov dx, bx
	   push dx
	   mov ah, 9
	   mov dx, offset result
	   int 21h
	   
	   mov cx, 10000
	   pop dx
	   call Resultado
	   jmp exit   
	SCaso4: ;Caso: Segundo operando mayor o igual que primer operando
	   sub dx, bx
	    push dx
	    mov ah, 9
	    mov dx, offset result
	    int 21h
	    
	    mov dx, offset resultN 
	    int 21h
	    mov cx, 10000
	    pop dx
	    call Resultado
	    jmp exit
	Suma3: ;Caso suma: segundo operando negativo
	    cmp dx, bx
	    jle SCaso3
	    jmp SCaso4	
	
	; Label que maneja la operacion de multiplicacion
	Multiplicar:
		mov ah, 9	
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov ah, 0
        int 16h  
        cmp al, 2Dh ;Ver si es -
		je HayNegativo5 
	PG5:	
		mov cx, 0	; Establece counter en 0
		call NumEntrada
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h 
		
		mov ah, 0
        int 16h  
        cmp al, 2Dh ;Ver si es -
		je HayNegativo6
	PG6:	
		mov cx, 0	; Counter en 0
		call NumEntrada	
		pop bx	; Guarda operando anterior en bx
		mov al, negativo1 
		cmp al, negativo2
		jne Multiplicar1
		mov ax, dx	; Mueve otro operando a ax
		mul bx	; ax * bx	
		mov dx, ax	; Mueve el resultado a dx
		push dx	; Guarda resultado en stack
		mov ah, 9
		mov dx, offset result	; Mensaje de resultado
		int 21h
		
		mov cx, 10000	; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
		jmp exit
    
    Multiplicar1: ;Caso multiplicar: algun operando es negativo
        mov ax, dx	; Mueve otro operando a ax
		mul bx	; ax * bx	
		mov dx, ax	; Mueve el resultado a dx
		push dx	; Guarda resultado en stack
		mov ah, 9
		mov dx, offset result	; Mensaje de resultado
		int 21h
		
		mov dx, offset resultN 
	    int 21h
		mov cx, 10000	; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
		jmp exit
	; Label que maneja la operacion de resta
	Resta:
		mov ah, 9
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov ah, 0
        int 16h  
        cmp al, 2Dh ;Ver si es -
		je HayNegativo3 
		
		
	PG3:
		mov cx, 0	; Establece counter en 0
		call NumEntrada
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h  
		
		mov ah, 0
        int 16h  
        cmp al, 2Dh ;Ver si es -
		je HayNegativo4 
	PG4:	
		mov cx, 0	; Counter en 0
		call NumEntrada
		pop bx	; Guarda operando anterior en bx
		
		mov al, negativo1
		cmp al, negativo2
		je Resta2
		cmp al, 1
		je Suma11    
		mov al, negativo2
		cmp al, 1
		je Resta1
		   
    Resta2: ;Caso resta: ambos operando tiene mismo signo
        cmp al, 1
        je Suma2
        jmp Suma3
	; Label que maneja la operacion de division
	Dividir:
		mov ah, 9
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov ah, 0
        int 16h 
        cmp al, 2Dh ;Ver si es -
		je HayNegativo7  
    PG7:  
		mov cx, 0	; Establece counter en 0
		call NumEntrada
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov ah, 0
        int 16h
        cmp al, 2Dh ;Ver si es -
		je HayNegativo8 
    PG8:    
		mov cx, 0	; Counter en 0
		call NumEntrada
		pop bx	; Guarda operando anterior en bx
		mov ax, bx	; Mueve operando en ax
		mov cx, dx	; Mueve otro operando a cx
		mov dx, 0	; Clear dx
		mov bx, 0	; Clear bx
		div cx	; cx / ax
		mov bx, dx	; Mueve residuo a bx
		mov dx, ax	; Guarda resultado en dx
		push bx	; Guarda residuo en stack
		push dx	; Guarda resultado en stack	
		
		mov al, negativo1 
		cmp al, negativo2
		jne Dividir1
		
		mov ah, 9
		mov dx, offset result
		int 21h
		
		mov cx, 10000 ; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
		jmp exit
	
	Dividir1: ;Caso division: algun operando es negativo
	    mov ah, 9
		mov dx, offset result
		int 21h
		
		mov dx, offset resultN 
	    int 21h
		mov cx, 10000 ; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
		jmp exit	
	; Label que se encarga de procesar el tamaño del numero de entrada, y administra el Resultado los digitos 
	; o procesarlos al presionar enter
	NumEntrada:
		mov ah, 0
		cmp al, 2Dh
		mov dx, 0	; Inicializa dx
		mov bx, 1	; Establece 1 para multiplicacion
		cmp al, 0Dh	; Si presiona enter
		je CreaNum
		sub ax, 30h ; ASCII a numero decimal
		call MostrarNum
		mov ah, 0
		push ax	; Guarda numero en stack
		inc cx	; Contador + 1
		mov ah, 0
        int 16h
		jmp NumEntrada
        
    
	; Label que se encarga de guardar operando en dx
	CreaNum: 
		pop ax	; Guarda ultimo digito en ax
		push dx	; Guarda digito en stack	 
		mul bx	; ax * bx
		pop dx	; Guarda digito en dx
		add dx, ax	; Guarda digito en dx
		mov ax, bx	; Guarda bx en ax
		mov bx, 10	; Para agregar digito al numero
		push dx	; Guarda digito en stack
		mul bx	; Multiplica ax por 10
		pop dx	; Guarda digito en dx
		mov bx, ax	; Mueve resultado de multiplicacion en bx
		dec cx	; Decrementa cuenta decimal
		cmp cx, 0
		jne CreaNum	; if cx != 0, todavia quedan digitos del num
		ret ; Else regrese a label anterior

	; Label que se encarga de procesar el resultado de la operacion
	Resultado:
		mov ax, dx	; Mueve resultado a ax
		mov dx, 0	
		div cx	; cx / ax para obtener primer digito
		call MostrarNum
		mov bx, dx	; Mueve resultado a bx
		mov dx, 0	; Reset dx
		mov ax, cx	; Mueve 10000 a ax
		mov cx, 10
		div cx	; Guarda en ax division de 10000 / 10
		mov dx, bx	; Guarda resultado en dx
		mov cx, ax	; Guarda division en cx
		cmp ax, 0	
		jne Resultado	; Si todavia quedan digitos, repetir
		ret

	; Label que se encarga de mostrar el numero en el registro ax
	MostrarNum:
		push ax	; Guarda numero en stack
		push dx	; Guarda residuo en stack
		mov dx, ax	; Guarda numero en dx 
		
	    
		add dl, 30h ; Convierte numero a ASCII
		
		mov ah, 2	; Imprime numero ingresado en consola
		int 21h
		
		pop dx	; Regresa resultado a dx
		pop ax	; Regresa numero a ax
		ret	; Regresa a label anterior
	
	exit:
	; -------- Mensajes de salida --------------------
		
		mov negativo1, 0 ;Resetear negativo1
		mov negativo2, 0 ;Resetear negativo2
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
		cmp al, 31h ; Si es 1
		mov ax, 0	; Reset ax
		je start	; Regresa al inicio
		mov dx, offset bye	; Else mensaje de despedida
		mov ah, 9
		int 21h
		ret
