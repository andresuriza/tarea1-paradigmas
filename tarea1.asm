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
		mov si,0
		call NumEntrada
		push si ;guarda el flotante 1 de ultimo
		push dx	; Guarda entero 1 de primero
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov cx, 0	; Counter en 0
		mov si,0
		call NumEntrada ;en dx entero 2 y en si entero 1
		pop bx	; Guarda entero 1 en bx
		pop di  ; Guarda flotante 1 en di
		
		;primero suma los enteros
		add dx, bx	; Suma los numeros
		mov cx,dx ;copia dx a cx
		;luego suma los decimales y guarda el resultado en si
		add si, di ;resultado en si 
		mov ax, si ;copia el resultado en ax
		mov bx,100
		mul bx
		
		cmp ax,9999
		jg div100
		jle div10
		
		div100:
		    mov bx,10000
		    div bx
		    jmp continuarSuma
	    
		div10:
		    cmp ax,999
		    jle normal
		    mov bx,100
		    mul bx
    		mov bx,1000
    		div bx
    		jmp continuarSuma
        
        normal:
            cmp ax,0
        continuarSuma:
        ;le suma este exceso a la parte entera 
        mov dx,cx
        add dx,ax
        cmp ax,0
        je resultadoSuma ;en caso que no hay que corregir la parte flotante
        ;copiamos el resultado en cx
        mov cx,dx ;en dx queda el entero total
		mov ax,si ;copia el resultado en ax
		mov dx,0
		mov bx,100
		mul bx
		
		cmp ax,999
		jg corregir100
		jle corregir10
		
		corregir100:;elimina el primer digito
		    ;en si esta con el exceso
		    mov bx,10000
		    mov ax,si
		    add ax,bx ;queda 10xxx
		    mov bx,10
		    div bx
		    push dx ;se guarda el primer residuo en stack
		    ;por un error desconocido volvemos a hacer la suma
		    mov bx,10000
		    add ax,bx
		    mov bx,10
		    div bx
		    push dx ;guarda el segundo residuo en stack
		    ;recordando que en cx esta el entero
		    pop ax
		    pop si
		    mov bx,10
		    mul bx
		    ;en ax queda el numero
		    add si,ax ;suma el primer digito del float y el segundo
		    mov dx,cx ;en dx queda el entero y en si el flotante
		    jmp resultadoSuma
		corregir10:
		    ;en si esta con el exceso
		    mov bx,10000
		    mov ax,si
		    add ax,bx ;queda 100xx
		    mov bx,10
		    div bx
		    push dx ;se guarda el primer residuo en stack
		    mov bx,10000
		    add ax,bx
		    mov bx,10
		    div bx
		    push dx ;guarda el segundo residuo en stack
		    ;recordando que en cx esta el entero
		    pop ax
		    pop si
		    mov bx,10
		    mul bx
		    ;en ax queda el numero
		    add si,ax ;suma el primer digito del float y el segundo
		    mov dx,cx ;en dx queda el entero y en si el flotante
		    
		     
		resultadoSuma:    
		push dx	; Guarda resultado en stack
		
		
		mov ah, 9
		mov dx, offset result	; Mensaje de resultado
		int 21h
		
		mov cx, 10000 ; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
		jmp exit
	
	; Label que maneja la operacion de multiplicacion
	Multiplicar:
		mov ah, 9	
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov si,0
		call NumEntrada
		push si ;guarda el flotante 1 de ultimo
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov cx, 0	; Counter en 0
		mov si,0
		call NumEntrada
		pop bx	; Guarda entero 1 en bx
		pop di  ; Guarda flotante 1 en di
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

	; Label que maneja la operacion de resta
	Resta:
		mov ah, 9
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov cx, 0	; Establece counter en 0
		mov si,0
		call NumEntrada
		push si ;guarda el flotante 1 de ultimo
		push dx	; Guarda operando en stack
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov cx, 0	; Counter en 0
		mov si,0
		call NumEntrada
		pop bx	; Guarda entero 1 en bx
		pop di  ; Guarda flotante 1 en di
		sub bx, dx	; Resta operandos
		mov dx, bx	; Guarda resultado en dx
		push dx	; Guarda resultado en stack		
		mov ah, 9
		mov dx, offset result	; Mensaje de resultado
		int 21h
		
		mov cx, 10000	; Maximo 32 bits
		pop dx	; Guarda resultado en dx
		call Resultado
		jmp exit

	; Label que maneja la operacion de division
	Dividir:
		mov ah, 9
		mov dx, offset op1	; Mensaje para ingresar primer operando
		int 21h
		
		mov cx, 0	; Establece counter en 0
		mov si,0 ;inicializa si como 0
		mov si,0
		call NumEntrada
		push si ;guarda el flotante 1 de ultimo
		push dx
		mov ah, 9
		mov dx, offset op2	; Mensaje para ingresar segundo operando
		int 21h
		
		mov cx, 0	; Counter en 0
		mov si, 0
		call NumEntrada
		pop bx	; Guarda entero 1 en bx
		pop di  ; Guarda flotante 1 en di

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
		jmp exit
		
	; Label que se encarga de procesar el tamaño del numero de entrada, y administra el Resultado los digitos 
	; o procesarlos al presionar enter
	NumEntrada:
		mov ah, 0	; Recibe numero
		int 16h
		
		mov dx, 0	; Inicializa dx
		mov bx, 1	; Establece 1 para multiplicacion
		cmp al, 0Dh	; Si presiona enter
		jne revisarFlotante ;si aun no termina el numero, pasa a revisar si ya se va a ingresar un flotante
		je CreaNumFlot ;cuando se termine el numero crea el numero y guarda en dx
	
	;labels de manejo del punto flotante _____________________________________________________________________________________	
	revisarFlotante: ;revisa si se encuentra un punto flotante
	    cmp al,2Eh ;si es igual a .
		jne noFlotMostrar ;brinca a mostrar el numero si no es .
		je hayFlot ;cuando topa con el flotante, guarda la parte entera en el stack
		
    ;se encontr un .
	hayFlot: ;en hay flot, se almacenara en el stack la parte entera del numero
	    call MostrarPunto
	    mov ah,0
	    push ax
	    inc cx
	    jmp NumEntrada
	    
	MostrarPunto:
        push ax	; Guarda numero en stack
		push dx	; Guarda residuo en stack
		mov dx, ax	; Guarda numero en dx
		
		mov ah, 2	; Imprime numero ingresado en consola
		int 21h
		
		pop dx	; Regresa resultado a dx
		pop ax	; Regresa numero a ax
		ret	; Regresa a label anterior
		 
    ;si no es un punto, convierte el numero a ascii y lo muestra
    noFlotMostrar:
        sub ax, 30h ; ASCII a numero decimal
		call MostrarNum
		mov ah, 0 
		push ax	; Guarda digito en stack
		inc cx	; Contador + 1
		jmp NumEntrada
    noFlot: ;si no 
        sub ax, 30h ; ASCII a numero decimal
		call MostrarNum
		mov ah, 0 
		push ax	; Guarda numero en stack
		inc cx	; Contador + 1
		jmp NumEntrada
;fin manejo punto flotante en creacion___________________________________________________________________________________    
    
	; Label que se encarga de guardar operando en dx
	CreaNumFlot:
		pop ax	; Guarda ultimo digito en ax
		cmp al,2Eh
		je almacenarFloat
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
		jne CreaNumFlot	; if cx != 0, todavia quedan digitos del num
		ret ; Else regrese a label anterior, el numero se guarda al final en dx
	almacenarFloat:
	    ;considerando que en dx esta el num flotante
	    mov si,dx ;almacena dx en si
	    mov dx,0
	    mov bx,1
	    dec cx ;decrementa 1 por que en esta posicion estaba el .
	    cmp cx,0
	    jne CrearEntero
	    ret	
		
	CrearEntero:
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
		jne CrearEntero	; if cx != 0, todavia quedan digitos del num
		ret ; Else regrese a label anterior, el numero se guarda al final en dx

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
		cmp si,0;si ax llega a ser 0
		jne resultadoFlotante ;si SI no es 0
		ret
    ;label que revisa si hay que imprimir parte flotante
    resultadoFlotante:
        mov cx, 10
        mov al, 2Eh
        mov ah,2
        int 21h
        
        mov dx,si
        mov si,0
        jmp Resultado
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