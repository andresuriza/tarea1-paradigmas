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
		mov cx,0
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
		
		;entero1=bx   entero2=dx  flotante1=di   flotante2=si     ejemplo 25.12x13.23
		;se iguala la cantidad de digitos en ambos flotantes
		;primero di
		push bx
		push dx ;se guardan [dx,bx] [entero1,entero2]
		;se mueve el di
		mov ax,di
		;calcular cantidad de digitos
		mov bx,1000
		mul bx ;en ax queda ejmeplo 12000
		cmp ax,9999
		jle incrementar1dig
		jg flotante1Arreglado ;no le hace nada y pasa con el siguiente
		incrementar1dig:
		    mov bx,100
		    div ax ;si fuera 1200, entonces ahora queda 12
		    mov di,ax ;guarda el flotante 1 en di para mantener el orden  
		flotante1Arreglado:
		;se repite el proceso para si
		;se mueve el si
		mov ax,si
		;calcular cantidad de digitos
		mov bx,1000
		mul bx ;en ax queda ejmeplo 12000
		cmp ax,9999
		jle incrementar1dig2
		jg flotante2Arreglado ;no le hace nada y pasa con el siguiente
		incrementar1dig2:
		    mov bx,100
		    div ax ;si fuera 1200, entonces ahora queda 12
		    mov si,ax ;guarda el flotante 2 en si para mantener el orden
		flotante2Arreglado:
		;ahora en si y di hay 2 digitos en c/u
		;entero1=bx(25)   entero2=dx(13)  flotante1=di(12)   flotante2=si(23)     ejemplo 25.12x13.23
		;se saca la parte entera del stack
		pop dx
		pop bx
		;primero se le incrementan 2 dig al entero 1
		push bx ;guarda copia en stack 
		push si ;guarda el flotante 2 [23,25]
		mov si,dx ;si=13
		mov ax,bx ;ax=25
		mov bx,100
		mul bx ;ax=2500
		;se le suma la parte flotante
		add ax,di ;ax=2512
		;actualmente: bx=100    dx=0   di=12  si=13
		;reacomodamos por que me perdi
		mov dx,si
		pop si ;[25]
		pop bx 
		;actualmente: ax=2512   bx=25    dx=13   di=12  si=23
		;se guardan valores que aun no se van a usar
		push bx ;[25]
		push dx ;[13,25]
		push di ;[12, 13, 25]
		
		mov bx,100  ;bx=100
		mov di, ax ;di=2512
		mov ax, si ;ax=23
		add ax,bx  ;ax=123
		mov bx,10
		div bx     ;ax=12, dx=3
		mov bx, 10
		sub ax,bx ;ax=2
		push ax   ;[2, 12, 13, 25]
		;multiplico el primer digito por 2512
		mov ax, di ;ax=2512
		mov bx,dx ;bx=3
		mul bx ;ax=7536 dx=0
		mov bx,10
		div bx ;ax=753 dx=6
		;ahora se multiplica el segundo numero, en di=2512
		mov bx, ax ;bx=753
		mov ax,di  ;ax=2512
		mov cx, ax ;copia en cx
		mov di,bx  ;di=753
		pop bx     ;bx=2    [12, 13, 25]
		mul bx     ;ax=5024
		;ahora se suma el resultado anterior con este
		add ax,di ;ax=576X   x por que ese digito no me interesa
		mov bx,10
		div bx    ;ax= 576  bx=10
		;volvemos a ordenar, el registro en si, ya no se ocupa asi que se puede ordenar de la forma
		pop si    ;si=12 [13,25]
		pop di    ;di=13 [25]
		pop dx    ;dx=25 []
		mov bx,ax ;bx=576
		mov ax,cx ;ax=2512
		;actualmente  ax=2512(entero 1 compuesto)  bx=576(residuo)  dx=25(entero 1)  di=13(entero 2)
		;seguimos
		mov cx,100
		push dx ;[25]
		mov si,ax ;si=2512
		mov ax,di ;ax=13
		add ax,cx ;ax 113
		mov cx,10
		div cx    ;ax 11  dx=3
		mov cx, 10
		sub ax,cx ;ax=1
		push ax  ;[1,25]
		mov ax,si ;ax=2512
		mov cx,dx ;cx=3
		mul cx    ;ax=7536
		add ax,bx ;ax=8112 aqui el 2 es el primer digito de interes para el flotante
		pop di
		pop cx
		mov cx,0 ;no se ocupaba el valor
		mov bx,ax

		;actualmente  ax=8112  bx=8112  dx=0  di=1(entero 2 restante)  si=2512  []
		;se extrae el primer digito de interes para la parte flotante
		mov cx,10
		div cx    ;ax=811  dx=2
		push dx   ;[2]
		;se multiplica si por di
		mov cx, ax ;cx=811
		mov ax,si  ;si=2512
		mov bx,di  ;bx=1(o el resto del entero 2)
		mul bx  ;ax=2512
		add ax,cx  ;ax=3323
		mov cx,10
		div cx     ;ax=332  dx=3
		push dx    ;[3,2]
		mov cx,ax  ;cx=332 (PARTE ENTERA FINAL)
		;ahora a armar el flotante
		pop ax     ;ax=3 [2] 
		mov bx,10
		mul bx     ;ax=30
		pop bx     ;bx=2
		add ax,bx  ;ax=32 (PARTE FLOTANTE FINAL)
		;se guardan en los registros correspondientes			
		mov dx, cx	; Mueve la parte entera a dx
		mov si, ax
		xor cx,cx
		xor di,di
		xor bx,bx ;limpio registros
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
		sub bx, dx	; Resta operandos ejemplo 20.15 - 5.22
		;en si esta el flotante 2
		;copiar resultado entero en cx
		mov cx,bx
		
		mov bx,100
		add di,bx ;ejemplo .49+.100 =.149
		
		;primero se resta parte decimal
		sub di,si ;ejemplo 149-69=080                   flotante 1 - flotante 2
		;si fuera el segundo numero menor 149-39=110
		;se compara si di es menor o mayor que 99
		;si es menor que 99, se le resta 1 a la parte entera, si no, se deja igua
		cmp di,99
		jle restarEntero
		jg arreglarDecimal
		restarEntero: 
		    sub cx,1 ;ejemplo 20-1=19
		    ;ya que en di esta la parte flotante, ejemplo 080
		    jmp continuarResta
		arreglarDecimal:
		    ;se le resta el 100 a di
		    sub di,100
		continuarResta:;en di debe quedar la parte flotante y en dx queda la parte entera
		mov si,di
		mov di,0
		mov dx, cx	; Guarda resultado en dx
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
		;codigo para realizar la division
		

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
		mov ah, 0	; Recibe numero     86042600
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