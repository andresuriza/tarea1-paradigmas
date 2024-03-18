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
	punto: db '.$'
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

	; Label que maneja la operacion de suma
	Suma:
		mov ah, 9
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov cx, 0	; Establece counter en 0
		xor si,si
		xor di,di
		call NumEntrada ;en dx quedara el numero1
		;si no es ni uno ni dos, no se toca
		push dx	; Guarda operando en stack (en este punto el ultimo es la parte flotante y el siguiente es la parte entera)
		
		
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov cx, 0	; Counter en 0
		xor si,si
		xor di,di
		call NumEntrada;
		
        ;en dx anda el segundo numero
        push dx ;empujo el resulta [float2,int2,float1,int1]
        pop si ;aqui guardare el float2
        pop di ;aqui el int2
        pop dx ;aqui el float1
        pop cx ;aqui el int1
        ;proceso de suma
        add dx,si ;se suman flotantes
        add cx,di ;se suman enteros
		;le sumo al cx el primer digito de dx
		mov si,dx ;float
		mov di,cx ;int
		;divido dx entre 100
		mov bx,100
		mov ax,si 
		div bx ;en ax queda el cociente y en dx el residuo, en este caso sera el decimal
		add bx,di ;en bx ahora tengo la parte entera
		
		push dx
		push bx	; Guarda resultado en stack [int, float]
		mov ah, 9
		mov dx, offset result	; Mensaje de resultado
		int 21h
		
		mov cx, 10000 ; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call ResultadoEntero
		
		mov ah, 9
        mov dx,offset punto
        int 21h
		
		mov cx,10
		pop dx
		call Resultado
	
	
	; Label que maneja la operacion de multiplicacion
	Multiplicar:
		mov ah, 9	
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov cx, 0	; Establece counter en 0
		xor si,si
		xor di,di
		call NumEntrada

		
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov cx, 0	; Counter en 0
		xor si,si
		xor di,di
		call NumEntrada	
		pop bx	; Guarda operando anterior en bx
		
		;proceso de multiplicacion
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
	

	; Label que maneja la operacion de resta
	Resta:
		mov ah, 9
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov cx, 0	; Establece counter en 0
		xor si,si
		xor di,di
		call NumEntrada
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov cx, 0	; Counter en 0 
		xor si,si
		xor di,di
		call NumEntrada
		pop bx	; Guarda operando anterior en bx
		
		;proceso de resta
		sub bx, dx	; Resta operandos
		mov dx, bx	; Guarda resultado en dx
		push dx	; Guarda resultado en stack		
		mov ah, 9
		mov dx, offset result	; Mensaje de resultado
		int 21h
		
		mov cx, 10000	; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
	

	; Label que maneja la operacion de division
	Dividir:
		mov ah, 9
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov cx, 0	; Establece counter en 0
		xor si,si
		xor di,di
		call NumEntrada
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov cx, 0	; Counter en 0
		xor si,si
		xor di,di
		call NumEntrada
		pop bx	; Guarda operando anterior en bx
		
		;proceso de division
		mov ax, bx	; Mueve operando en ax
		mov cx, dx	; Mueve otro operando a cx
		mov dx, 0	; Clear dx
		mov bx, 0	; Clear bx
		div cx	; cx / ax
		mov bx, dx	; Mueve residuo a bx
		mov dx, ax	; Guarda resultado en dx
		push bx	; Guarda residuo en stack
		push dx	; Guarda resultado en stack	
		mov ah, 9
		mov dx, offset result
		int 21h
		
		mov cx, 10000 ; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
	
		
	; Label que se encarga de procesar el tamaño del numero de entrada, y administra el Resultado los digitos 
	; o procesarlos al presionar enter
	NumEntrada:
		mov ah, 0	; Recibe numero
		int 16h
		mov dx, 0	; Inicializa dx
		mov bx, 1	; Establece 1 para multiplicacion
		cmp al, 0Dh	; Si presiona enter
		je CreaNum
		jne revisarFlotante
		
	revisarFlotante: ;revisa si se encuentra un punto flotante
	    cmp al,2Eh ;si es igual a .
		jne noFlotMostrar ;brinca a mostrar el numero si no es .
		je hayFlot ;cuando topa con el flotante, guarda la parte entera en el stack 	

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
		
	; Label que se encarga de guardar operando en dx
	CreaNumEntero:
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
		jne CreaNumEntero	; if cx != 0, todavia quedan digitos del num
		je continuarHayFlot ; Else regresa a hayFlot
		
    ;si no es un punto, convierte el numero a ascii y lo muestra
    noFlotMostrar:
        sub ax, 30h ; ASCII a numero decimal
		call MostrarNum
		mov ah, 0 
		push ax	; Guarda numero en stack
		inc cx	; Contador + 1
		jmp NumEntrada
    noFlot: ;si no 
        sub ax, 30h ; ASCII a numero decimal
		call MostrarNum
		mov ah, 0 
		push ax	; Guarda numero en stack
		inc cx	; Contador + 1
		jmp NumEntrada
		
    ;si hay punto, lo muestra pero no lo guarda en el stack
    ;e indica en di que se encontro un punto
	hayFlot: ;en hay flot, se almacenara en el stack la parte entera del numero
	    ;guardar cantidad de digitos despues del punto 
	    call MostrarPunto
	    mov ah,0
	    inc di ;di+=1, binario, 0 si no ha aparecido un punto, 1 si aparecio
	    ;-----
	    jmp CreaNumEntero
	    continuarHayFlot:
	    push dx
	    ;resetea valores para llamar a NumEntrada de nuevo para guardar la parte flotante
	    mov cx,0

	    ;crear num para la parte entera
	    jmp NumEntrada

	    
	      
	    
	; Label que se encarga de procesar el resultado de la operacion
	
	
	Resultado:
		mov ax, dx	; Mueve resultado a ax
		mov dx, 0	
		div cx	; cx / ax para obtener primer digito
		call MostrarNum
		mov bx, dx	; Mueve resultado a bx
		mov dx, 0	; Reset dx
		mov ax, cx	; Mueve 10 a ax
		mov cx, 10
		div cx	; Guarda en ax division de 10 / 10
		mov dx, bx	; Guarda resultado en dx
		mov cx, ax	; Guarda division en cx
		cmp ax, 0	
		jne Resultado	; Si todavia quedan digitos, repetir
		jmp exit
    
    ResultadoEntero:
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
    MostrarPunto:
        push ax	; Guarda numero en stack
		push dx	; Guarda residuo en stack
		mov dx, ax	; Guarda numero en dx
		
		mov ah, 2	; Imprime numero ingresado en consola
		int 21h
		
		pop dx	; Regresa resultado a dx
		pop ax	; Regresa numero a ax
		ret	; Regresa a label anterior
	
	exit:
	; -------- Mensajes de salida --------------------
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
	end
		