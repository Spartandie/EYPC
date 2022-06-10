title "Proyecto: Bricks" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada página de código
	.model small	;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386			;directiva para indicar version del procesador
	.stack 64 		;Define el tamano del segmento de stack, se mide en bytes
	.data			;Definicion del segmento de datos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Definición de constantes


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Valor ASCII de caracteres para el marco del programa
marcoEsqInfIzq 		equ 	200d 	;'╚'
marcoEsqInfDer 		equ 	188d	;'╝'
marcoEsqSupDer 		equ 	187d	;'╗'
marcoEsqSupIzq 		equ 	201d 	;'╔'
marcoCruceVerSup	equ		203d	;'╦'

marcoCruceHorDer	equ 	47d 	;'╣'

marcoCruceVerInf	equ		202d	;'╩'
marcoCruceHorIzq	equ 	204d 	;'╠'

marcoCruce 			equ		206d	;'╬'

marcoHor 			equ 	205d 	;'═'

marcoVer 			equ 	186d 	;'║'
;Atributos de color de BIOS
;Valores de color para carácter
cNegro 			equ		00h
cAzul 			equ		01h
cVerde 			equ 	02h
cCyan 			equ 	03h
cRojo 			equ 	04h
cMagenta 		equ		05h
cCafe 			equ 	06h
cGrisClaro		equ		07h
cGrisOscuro		equ		08h
cAzulClaro		equ		09h
cVerdeClaro		equ		0Ah
cCyanClaro		equ		0Bh
cRojoClaro		equ		0Ch
cMagentaClaro	equ		0Dh
cAmarillo 		equ		0Eh
cBlanco 		equ		0Fh
;Valores de color para fondo de carácter
bgNegro 		equ		00h
bgAzul 			equ		10h
bgVerde 		equ 	20h
bgCyan 			equ 	30h
bgRojo 			equ 	40h
bgMagenta 		equ		50h
bgCafe 			equ 	60h
bgGrisClaro		equ		70h
bgGrisOscuro	equ		80h
bgAzulClaro		equ		90h
bgVerdeClaro	equ		0A0h
bgCyanClaro		equ		0B0h
bgRojoClaro		equ		0C0h
bgMagentaClaro	equ		0D0h
bgAmarillo 		equ		0E0h
bgBlanco 		equ		0F0h
;Valores para delimitar el área de juego
lim_superior 	equ		1
lim_inferior 	equ		23
lim_izquierdo 	equ		1
lim_derecho 	equ		30
;Valores de referencia para la posición inicial del jugador y la bola
ini_columna 	equ 	lim_derecho/2
ini_renglon 	equ 	22

;Valores para la posición de los controles e indicadores dentro del juego
;Lives
lives_col 		equ  	lim_derecho+7
lives_ren 		equ  	4

;Scores
hiscore_ren	 	equ 	11
hiscore_col 	equ 	lim_derecho+7
score_ren	 	equ 	13
score_col 		equ 	lim_derecho+7

;Botón STOP
stop_col 		equ 	lim_derecho+15
stop_ren 		equ 	19
stop_izq 		equ 	stop_col-1
stop_der 		equ 	stop_col+1
stop_sup 		equ 	stop_ren-1
stop_inf 		equ 	stop_ren+1

;Botón PAUSE
pause_col 		equ 	lim_derecho+25
pause_ren 		equ 	19
pause_izq 		equ 	pause_col-1
pause_der 		equ 	pause_col+1
pause_sup 		equ 	pause_ren-1
pause_inf 		equ 	pause_ren+1

;Botón PLAY
play_col 		equ 	lim_derecho+35
play_ren 		equ 	19
play_izq 		equ 	play_col-1
play_der 		equ 	play_col+1
play_sup 		equ 	play_ren-1
play_inf 		equ 	play_ren+1

max_digitos		equ 	1 	; Constante que determina el máximo de dígitos permitido

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;////////////////////////////////////////////////////
;Definición de variables
;////////////////////////////////////////////////////
titulo 			db 		"BRICKS"
scoreStr 		db 		"SCORE"
hiscoreStr		db 		"HI-SCORE"
livesStr		db 		"LIVES"
blank			db 		"     "
player_lives 	db 		3
player_score 	dw 		0
player_hiscore 	dw 		0
estado 			db 		2

dificultad 		db 		0; Determina la dificultad del juego



player_col		db 		ini_columna
player_ren		db 		ini_renglon

col_aux 		db 		0
ren_aux 		db 		0

conta 			db 		0
t_inicial 		dw 		0,0
tick_ms			dw 		55 		;55 ms por cada tick del sistema, esta variable se usa para operación de MUL convertir ticks a segundos
mil				dw		1000 	;1000 auxiliar para operación DIV entre 1000
cien 			dw 		100
diez 			dw 		10 		;10 auxiliar para operaciones
sesenta			db 		60 		;60 auxiliar para operaciones
ticks 			dw		0 		;Variable para almacenar el número de ticks del sistema y usarlo como referencia



milisegundos	dw		0		;variable para guardar la cantidad de milisegundos
segundos		db		0 		;variable para guardar la cantidad de segundos
minutos 		db		0		;variable para guardar la cantidad de minutos
seg_aux			db 		0


presionar_sal	db 		0Ah,"Presione cualquier tecla para salir",0Ah,"$"
gameover 		db 		"Game Over$"; Cadena cuando se pierde

winner 			db 		"Felicidades, ganaste:)$";Cadena cuando se gana

real_winner		db 		"Felicidades, sos un capo ;)$";Cadena cuando se gana	

ingresa_dif		db 		0Ah,0Dh,"Selecciona una dificultad del 1 al 4 (Facil, Normal, Dificil y Extrema): $"

dif_facil		db 		0Ah,0Dh,"Dificultad facil seleccionada. Disfruta tu juego :D$"
dif_normal		db 		0Ah,0Dh,"Dificultad normal seleccionada. Disfruta tu juego :D$"
dif_dificil		db 		0Ah,0Dh,"Dificultad dificil seleccionada. Disfruta tu juego :D$"
dif_extrema	    db 		0Ah,0Dh,"Dificultad extrema seleccionada. Disfruta tu juego... o no>:)$"

presiona_ent   	db 		0Ah,0Dh,"Presiona [enter] para continuar$"

brick_color 	db 		0; Variable que se usa para pasar el color del brick
mapa_bricks 	db 		3,2,1,3,2,1,'#',2,1,3,2,1,3,'#',1,3,2,1,3,2,'#',3,2,1,3,2,1,'#',2,1,3,2,1,3,'%';Mapa de los bricks 3.Azul, 2.Verde, 1.Rojo
;el número indica el "nivel" del brick, el carácter '#' indica el fin del renglón
;el carácter '%' indica el fin del mapa
;Bola
bola_col		db 		ini_columna 	 	;columna de la bola
bola_ren		db 		ini_renglon-1 		;renglón de la bola
dir 			db 		0 					;Direccion horizontal de la bola
dir_ver 		db 		0 					;Direccion vertical de la bola




;Variables que sirven de parámetros de entrada para el procedimiento IMPRIME_BOTON
boton_caracter 	db 		0
boton_renglon 	db 		0
boton_columna 	db 		0
boton_color		db 		0
boton_bg_color	db 		0


;Auxiliar para calculo de coordenadas del mouse
ocho			db 		8
;Cuando el driver del mouse no está disponible
no_mouse		db 	'No se encuentra driver de mouse. Presione [enter] para salir$'

temp db 0 	;variable temp para almacenar temporalmente
;////////////////////////////////////////////////////

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;Macros;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
;clear - Limpia pantalla
clear macro
	mov ax,0003h 	;ah = 00h, selecciona modo video
					;al = 03h. Modo texto, 16 colores
	int 10h		;llama interrupcion 10h con opcion 00h. 
				;Establece modo de video limpiando pantalla
endm

;posiciona_cursor - Cambia la posición del cursor a la especificada con 'renglon' y 'columna' 
posiciona_cursor macro renglon,columna
	mov dh,renglon	;dh = renglon
	mov dl,columna	;dl = columna
	mov bx,0
	mov ax,0200h 	;preparar ax para interrupcion, opcion 02h
	int 10h 		;interrupcion 10h y opcion 02h. Cambia posicion del cursor
endm 

;inicializa_ds_es - Inicializa el valor del registro DS y ES
inicializa_ds_es 	macro
	mov ax,@data
	mov ds,ax
	mov es,ax 		;Este registro se va a usar, junto con BP, para imprimir cadenas utilizando interrupción 10h
endm

;muestra_cursor_mouse - Establece la visibilidad del cursor del mouser
muestra_cursor_mouse	macro
	mov ax,1		;opcion 0001h
	int 33h			;int 33h para manejo del mouse. Opcion AX=0001h
					;Habilita la visibilidad del cursor del mouse en el programa
endm


;oculta_cursor_teclado - Oculta la visibilidad del cursor del teclado
oculta_cursor_teclado	macro
	mov ah,01h 		;Opcion 01h
	mov cx,2607h 	;Parametro necesario para ocultar cursor
	int 10h 		;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

limite_mouse macro 	;Establece que el mouse no pase al área del juego, se pasan los límites en forma de resolución
	mov ax, 7 	;Ax->Limite horizontal (opcion de la interrupcion)
	mov cx, 260 ;Cx->limite por la izq
	mov dx, 625
	int 33h

endm

;apaga_cursor_parpadeo - Deshabilita el parpadeo del cursor cuando se imprimen caracteres con fondo de color
;Habilita 16 colores de fondo
apaga_cursor_parpadeo	macro
	mov ax,1003h 		;Opcion 1003h
	xor bl,bl 			;BL = 0, parámetro para int 10h opción 1003h
  	int 10h 			;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
;Los colores disponibles están en la lista a continuacion;
; Colores:
; 0h: Negro
; 1h: Azul
; 2h: Verde
; 3h: Cyan
; 4h: Rojo
; 5h: Magenta
; 6h: Cafe
; 7h: Gris Claro
; 8h: Gris Oscuro
; 9h: Azul Claro
; Ah: Verde Claro
; Bh: Cyan Claro
; Ch: Rojo Claro
; Dh: Magenta Claro
; Eh: Amarillo
; Fh: Blanco
; utiliza int 10h opcion 09h
; 'caracter' - caracter que se va a imprimir
; 'color' - color que tomará el caracter
; 'bg_color' - color de fondo para el carácter en la celda
; Cuando se define el color del carácter, éste se hace en el registro BL:
; La parte baja de BL (los 4 bits menos significativos) define el color del carácter
; La parte alta de BL (los 4 bits más significativos) define el color de fondo "background" del carácter
imprime_caracter_color macro caracter,color,bg_color
	mov ah,09h				;preparar AH para interrupcion, opcion 09h
	mov al,caracter 		;AL = caracter a imprimir
	mov bh,0				;BH = numero de pagina
	mov bl,color 			
	or bl,bg_color 			;BL = color del caracter
							;'color' define los 4 bits menos significativos 
							;'bg_color' define los 4 bits más significativos 
	mov cx,1				;CX = numero de veces que se imprime el caracter
							;CX es un argumento necesario para opcion 09h de int 10h
	int 10h 				;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm

;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
; utiliza int 10h opcion 09h
; 'cadena' - nombre de la cadena en memoria que se va a imprimir
; 'long_cadena' - longitud (en caracteres) de la cadena a imprimir
; 'color' - color que tomarán los caracteres de la cadena
; 'bg_color' - color de fondo para los caracteres en la cadena
imprime_cadena_color macro cadena,long_cadena,color,bg_color
	mov ah,13h				;preparar AH para interrupcion, opcion 13h
	lea bp,cadena 			;BP como apuntador a la cadena a imprimir
	mov bh,0				;BH = numero de pagina
	mov bl,color 			
	or bl,bg_color 			;BL = color del caracter
							;'color' define los 4 bits menos significativos 
							;'bg_color' define los 4 bits más significativos 
	mov cx,long_cadena		;CX = longitud de la cadena, se tomarán este número de localidades a partir del apuntador a la cadena
	int 10h 				;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm

;lee_mouse - Revisa el estado del mouse
;Devuelve:
;;BX - estado de los botones
;;;Si BX = 0000h, ningun boton presionado
;;;Si BX = 0001h, boton izquierdo presionado
;;;Si BX = 0002h, boton derecho presionado
;;;Si BX = 0003h, boton izquierdo y derecho presionados
; (400,120) => 80x25 =>Columna: 400 x 80 / 640 = 50; Renglon: (120 x 25 / 200) = 15 => 50,15
;;CX - columna en la que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
;;DX - renglon en el que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
lee_mouse	macro
	mov ax,0003h
	int 33h
endm


;Revisa si el teclado fue presionado
; AL = Boton presionado
int_teclado macro 
mov ah, 01h
int 16h
endm

;Limpia buffer del teclado
vacia_teclado macro
mov ah, 00h
int 16h
endm
	
;comprueba_mouse - Revisa si el driver del mouse existe
comprueba_mouse 	macro
	mov ax,0		;opcion 0
	int 33h			;llama interrupcion 33h para manejo del mouse, devuelve un valor en AX
					;Si AX = 0000h, no existe el driver. Si AX = FFFFh, existe driver
endm

;Define la dirección inicial de la bola
direccion_inicial macro
	mov [dir_ver],-1d ;Arriba
	mov [dir], 1d     ;Derecha
endm

;Devuelve el caracter y color en la posicion actual del cursor del teclado
detecta_caracter macro
	mov ah, 08h 	;ah = 08h, Obtener color y caracter en el cursor
					;AH=COLOR, AL=CARACTER
	int 10h		;llama interrupcion 10h con opcion 08h. 
endm


;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;Fin Macros;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

	.code
inicio:					;etiqueta inicio
	inicializa_ds_es
	clear

	seleccion_dificultad: 	;Seccion para seleccionar la dificultad	
	lea dx,[ingresa_dif]	;DX apunta la cadena 'ingresa_dif'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'
	CALL LEE_DIF

	seleccion:
	clear 
	cmp [dificultad], 4
	je extrema
	cmp [dificultad], 3
	je dificil
	cmp [dificultad], 2
	je normal


	facil:
	mov [tick_ms], 220d ;velocidad

	lea dx,[dif_facil]	;DX apunta la cadena 'dif_facil'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'

	lea dx,[presiona_ent]	;DX apunta la cadena 'presiona_ent'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'


	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO

	cmp al,0Dh 			;compara si la tecla presionada fue [enter]
	jne	seleccion		;Si tecla es [enter], salta a etiqueta inicia

	jmp inicia


	normal:
	mov [tick_ms], 440d ;velocidad al doble que fácil


	lea dx,[dif_normal]	;DX apunta la cadena 'dif_normal'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'

	lea dx,[presiona_ent]	;DX apunta la cadena 'presiona_ent'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'


	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO

	cmp al,0Dh 			;compara si la tecla presionada fue [enter]
	jne	seleccion		;Si tecla es [enter], salta a etiqueta inicia

	jmp inicia

	dificil:
	mov [tick_ms], 550d ;velocidad


	lea dx,[dif_dificil]	;DX apunta la cadena 'dif_dificil'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'

	lea dx,[presiona_ent]	;DX apunta la cadena 'presiona_ent'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'


	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO

	cmp al,0Dh 			;compara si la tecla presionada fue [enter]
	jne	seleccion		;Si tecla es [enter], salta a etiqueta inicia
	jmp inicia

	extrema:

	mov [tick_ms], 600d

	lea dx,[dif_extrema]	;DX apunta la cadena 'dif_extrema'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'

	lea dx,[presiona_ent]	;DX apunta la cadena 'presiona_ent'
	mov ah,09h
	int 21h				;int 21h con opcion AH=09h. Imprime una cadena empezando en DX y termina hasta encontrar '$'


	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO

	cmp al,0Dh 			;compara si la tecla presionada fue [enter]
	jne	seleccion		;Si tecla es [enter], sigue a inicia


	inicia:
	
	direccion_inicial ;macro dirección inicial de la bola, arriba a la derecha
	;Maneja el tiempo 
	;Lee el valor del contador de ticks y lo guarda en variable t_inicial
	;adquieren la hora del sistema
	mov ah,00h
	int 1Ah
	mov [t_inicial],dx
	mov [t_inicial + 2],cx

	comprueba_mouse		;macro para revisar si existe el driver de mouse
	xor ax,0FFFFh		;compara el valor de AX con FFFFh, si el resultado es zero, entonces existe el driver de mouse
	jz imprime_ui		;Si existe el driver del mouse, entonces salta a 'imprime_ui'
	;Si no existe el driver del mouse entonces se muestra un mensaje
	lea dx,[no_mouse]
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.
	jmp teclado		;salta a 'teclado' donde se comprueba si la tecla presionada fue enter para salir 
imprime_ui:
	clear 					;limpia pantalla
	oculta_cursor_teclado	;oculta cursor del teclado
	apaga_cursor_parpadeo 	;Deshabilita parpadeo del cursor
	call DIBUJA_UI 			;procedimiento que dibuja marco de la interfaz
	limite_mouse			;Establece que el mouse no pase al área del juego
	muestra_cursor_mouse 	;hace visible el cursor del mouse



;loop principal

mouse_no_clic:
	
	cmp [estado], 1 	;Checa si el juego está activo
	je loopmover		;mover bola

	input:			;Checa si hay alguna entrada
	call LEER_MOUSE ;lee mouse, si se presiona izq salta a hacer la conversión para obtener el valor correspondiente en resolucion 80x25
	int_teclado ;revisa si el teclado fue presionado
	
	jz mouse_no_clic ;si no hubo entradas regresa 
	
	vacia_teclado ; si se detectó el teclado vacía el buffer y verifica qué botón se presionó
	cmp al,61h 			;compara si la tecla presionada fue "a"
	je mover_izq			
	cmp al,64h 			;compara si la tecla presionada fue "d"
	je mover_der
	cmp al,41h 			;compara si la tecla presionada fue "A"
	je mover_izq
	cmp al,44h 			;compara si la tecla presionada fue "D"
	je mover_der

	jmp mouse_no_clic



conversion_mouse:
	;
	;80x25 (columnas x renglones) en modo texto
	mov ax,dx 			;Copia DX en AX. DX es un valor entre 0 y 199 (renglon)
	div [ocho] 			;Division de 8 bits
						;divide el valor del renglon en resolucion 640x200 en donde se encuentra el mouse
						;para obtener el valor correspondiente en resolucion 80x25
	xor ah,ah 			;Descartar el residuo de la division anterior
	mov dx,ax 			;Copia AX en DX. AX es un valor entre 0 y 24 (renglon)

	mov ax,cx 			;Copia CX en AX. CX es un valor entre 0 y 639 (columna)
	div [ocho] 			;Division de 8 bits
						;divide el valor de la columna en resolucion 640x200 en donde se encuentra el mouse
						;para obtener el valor correspondiente en resolucion 80x25
	xor ah,ah 			;Descartar el residuo de la division anterior
	mov cx,ax 			;Copia AX en CX. AX es un valor entre 0 y 79 (columna)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BOTONES PLAY                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;se va a revisar si fue dentro del boton [play], los tres botones comparten 3 renglones 19, 20 y 21
	cmp dx,19
	je boton_play
	cmp dx,20
	je boton_play
	cmp dx,21
	je boton_play

	jmp botonsalir ;si no está en los 3 renglones de los botones, comprueba si fue el boton de x
boton_play:
	jmp boton_play1

;Lógica para revisar si el mouse fue presionado en [play]
;play se encuentra entre columnas 65 y 67
boton_play1:
	cmp cx,65
	jge boton_play2
	jmp mas_botonesplay
boton_play2:
	cmp cx,67
	jbe boton_play3
	jmp mas_botonesplay
boton_play3:
	;Se cumplieron todas las condiciones

	;Checa si el jugador ya ganó o perdió. De ser así, se regresa al flujo principal
	cmp [player_lives],0
	je	mouse_no_clic

	cmp [player_score],10000d
	je	mouse_no_clic

	mov [estado], 1 ;Cambia el estado a activo


	loopmover:

		CALL MOV_BOLA ;Se encarga del movimiento y colisiones de la bola
		CALL CRONO	  ;Se encarga del manejo del tiempo

	jmp input
mas_botonesplay:
	jmp boton_pausa

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BOTONES PAUSA                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;se va a revisar si fue dentro del boton [pausa]

boton_pausa:
	jmp boton_pausa1

;Lógica para revisar si el mouse fue presionado en [pausa]
; se encuentra en renglon 0 y entre columnas 55 y 57
boton_pausa1:
	cmp cx,55
	jge boton_pausa2
	jmp mas_botonespausa
boton_pausa2:
	cmp cx,57
	jbe boton_pausa3
	jmp mas_botonespausa
boton_pausa3:

	mov [estado], 0
	cmp [dificultad], 4
	jne mouse_no_clic

	;Dificultad extrema

	mov [player_score], 0

	cmp [player_lives],0 ;Si ya no hay vidas se va a mouse_no_clic
	je  mouse_no_clic

	borra_progreso:		;Si aun hay vidas se borra progreso
	CALL DIBUJA_UI
	jmp mouse_no_clic

mas_botonespausa:
	jmp boton_stop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BOTONES STOP                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;se va a revisar si fue dentro del boton [stop]

boton_stop:
	jmp boton_stop1

;Lógica para revisar si el mouse fue presionado en [stop]
; se encuentra en renglon 0 y entre columnas 45 y 47
boton_stop1:
	cmp cx,45
	jge boton_stop2
	jmp mouse_no_clic
boton_stop2:
	cmp cx,47
	jbe boton_stop3
	jmp mouse_no_clic
boton_stop3:
	;Se cumplieron todas las condiciones

	mov [estado], 2 	;Vuelve al estado inicial
	direccion_inicial; establece de nuevo la dir inicial de la bola para no rebotar indebidamente al reiniciar
	CALL DATOS_INICIALES ; reinicia las vidas y el score
	jmp imprime_ui	; imprime de nuevo la interfaz

mas_botonesstop:
	jmp mouse_no_clic



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Aqui va la lógica de la posicion del mouse;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Si el mouse fue presionado en el renglon 0
	;se va a revisar si fue dentro del boton [X]

botonsalir:
	cmp dx,0
	je boton_x

	jmp mouse_no_clic
boton_x:
	jmp boton_x1

;Lógica para revisar si el mouse fue presionado en [X]
;[X] se encuentra en renglon 0 y entre columnas 76 y 78
boton_x1:
	cmp cx,76
	jge boton_x2
	jmp mouse_no_clic
boton_x2:
	cmp cx,78
	jbe boton_x3
	jmp mouse_no_clic
boton_x3:
	;Se cumplieron todas las condiciones
	jmp salir

mas_botones:
	jmp mouse_no_clic



mover_izq:				;Comprueba condiciones para mover a la izquierda
	cmp [player_col], 3 ;No mover si está en el límite
	je mouse_no_clic

	cmp [estado], 2 	;Si esta en estado inicial se puede mover directamente
	je moveri

	cmp [estado], 1 	;No mover si juego está en pausa
	jne mouse_no_clic

	moveri:					;Mover a la izquierda	

	call BORRA_JUGADOR
	dec [player_col]

	cmp [estado], 2 	;Si esta en estado inicial se puede mover la bola también
	jne actualiza_player_i

	CALL BORRA_BOLA
	dec [bola_col]
	CALL IMPRIME_BOLA
	actualiza_player_i:;Si no esta en estado inicial solo mover la barra
	call IMPRIME_JUGADOR


	jmp mouse_no_clic


mover_der:				;Comprueba condiciones para mover a la derecha
	cmp [player_col], 28 ; No mover si está en límite
	je mouse_no_clic

	cmp [estado], 2 	;Si esta en estado inicial se puede mover directamente
	je moverd

	cmp [estado], 1 	;No mover si juego está en pausa
	jne mouse_no_clic

	moverd:				;Mover a la derecha

	call BORRA_JUGADOR
	inc [player_col]

	cmp [estado], 2 	;Si esta en estado inicial se puede mover la bola también
	jne actualiza_player_d


	CALL BORRA_BOLA
	inc [bola_col]
	CALL IMPRIME_BOLA

	actualiza_player_d:	;Si no esta en estado inicial solo mover la barra

	call IMPRIME_JUGADOR
	jmp mouse_no_clic

;Si no se encontró el driver del mouse, muestra un mensaje y el usuario debe salir tecleando [enter]
teclado:
	mov ah,08h
	int 21h
	cmp al,0Dh		;compara la entrada de teclado si fue [enter]
	jnz teclado 	;Sale del ciclo hasta que presiona la tecla [enter]

salir:				;inicia etiqueta salir
	clear 			;limpia pantalla
	mov ax,4C00h	;AH = 4Ch, opción para terminar programa, AL = 0 Exit Code, código devuelto al finalizar el programa
	int 21h			;señal 21h de interrupción, pasa el control al sistema operativo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;PROCEDIMIENTOS;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DIBUJA_UI proc
		;imprimir esquina superior izquierda del marco
		posiciona_cursor 0,0
		imprime_caracter_color marcoEsqSupIzq,cAmarillo,bgNegro
		
		;imprimir esquina superior derecha del marco
		posiciona_cursor 0,79
		imprime_caracter_color marcoEsqSupDer,cAmarillo,bgNegro
		
		;imprimir esquina inferior izquierda del marco
		posiciona_cursor 24,0
		imprime_caracter_color marcoEsqInfIzq,cAmarillo,bgNegro
		
		;imprimir esquina inferior derecha del marco
		posiciona_cursor 24,79
		imprime_caracter_color marcoEsqInfDer,cAmarillo,bgNegro
		
		;imprimir marcos horizontales, superior e inferior
		mov cx,78 		;CX = 004Eh => CH = 00h, CL = 4Eh 
	marcos_horizontales:
		mov [col_aux],cl
		;Superior
		posiciona_cursor 0,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro
		;Inferior
		posiciona_cursor 24,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro
		
		mov cl,[col_aux]
		loop marcos_horizontales

		;imprimir marcos verticales, derecho e izquierdo
		mov cx,23 		;CX = 0017h => CH = 00h, CL = 17h 
	marcos_verticales:
		mov [ren_aux],cl
		;Izquierdo
		posiciona_cursor [ren_aux],0
		imprime_caracter_color marcoVer,cAmarillo,bgNegro
		;Inferior
		posiciona_cursor [ren_aux],79
		imprime_caracter_color marcoVer,cAmarillo,bgNegro
		;Limite mouse
		posiciona_cursor [ren_aux],lim_derecho+1
		imprime_caracter_color marcoVer,cAmarillo,bgNegro

		mov cl,[ren_aux]
		loop marcos_verticales

		;imprimir marcos horizontales internos
		mov cx,79-lim_derecho-1 		
	marcos_horizontales_internos:
		push cx
		mov [col_aux],cl
		add [col_aux],lim_derecho
		;Interno superior 
		posiciona_cursor 8,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro

		;Interno inferior
		posiciona_cursor 16,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro

		mov cl,[col_aux]
		pop cx
		loop marcos_horizontales_internos

		;imprime intersecciones internas	
		posiciona_cursor 0,lim_derecho+1
		imprime_caracter_color marcoCruceVerSup,cAmarillo,bgNegro
		posiciona_cursor 24,lim_derecho+1
		imprime_caracter_color marcoCruceVerInf,cAmarillo,bgNegro

		posiciona_cursor 8,lim_derecho+1
		imprime_caracter_color marcoCruceHorIzq,cAmarillo,bgNegro
		posiciona_cursor 8,79
		imprime_caracter_color marcoCruceHorDer,cAmarillo,bgNegro

		posiciona_cursor 16,lim_derecho+1
		imprime_caracter_color marcoCruceHorIzq,cAmarillo,bgNegro
		posiciona_cursor 16,79
		imprime_caracter_color marcoCruceHorDer,cAmarillo,bgNegro

		;imprimir [X] para cerrar programa
		posiciona_cursor 0,76
		imprime_caracter_color '[',cAmarillo,bgNegro
		posiciona_cursor 0,77
		imprime_caracter_color 'X',cRojoClaro,bgNegro
		posiciona_cursor 0,78
		imprime_caracter_color ']',cAmarillo,bgNegro

		;imprimir título
		posiciona_cursor 0,52
		imprime_cadena_color [titulo],6,cBlanco,bgNegro

		call IMPRIME_TEXTOS

		call IMPRIME_BOTONES

		call IMPRIME_BRICKS

		call IMPRIME_DATOS_INICIALES

		call IMPRIME_SCORES

		call IMPRIME_LIVES

		ret
	endp

	IMPRIME_TEXTOS proc
		;Imprime cadena "LIVES"
		posiciona_cursor lives_ren,lives_col
		imprime_cadena_color livesStr,5,cGrisClaro,bgNegro

		;Imprime cadena "SCORE"
		posiciona_cursor score_ren,score_col
		imprime_cadena_color scoreStr,5,cGrisClaro,bgNegro

		;Imprime cadena "HI-SCORE"
		posiciona_cursor hiscore_ren,hiscore_col
		imprime_cadena_color hiscoreStr,8,cGrisClaro,bgNegro
		ret
	endp

	IMPRIME_BOTONES proc
		;Botón STOP
		mov [boton_caracter],254d		;Carácter '■'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],stop_ren 	;Renglón en "stop_ren"
		mov [boton_columna],stop_col 	;Columna en "stop_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		;Botón PAUSE
		mov [boton_caracter],19d 		;Carácter '‼'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],pause_ren 	;Renglón en "pause_ren"
		mov [boton_columna],pause_col 	;Columna en "pause_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		;Botón PLAY
		mov [boton_caracter],16d  		;Carácter '►'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],play_ren 	;Renglón en "play_ren"
		mov [boton_columna],play_col 	;Columna en "play_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		ret
	endp

	IMPRIME_SCORES proc
		;Imprime el valor de la variable player_score en una posición definida
		call IMPRIME_SCORE
		;Imprime el valor de la variable player_hiscore en una posición definida
		call IMPRIME_HISCORE
		ret
	endp

	IMPRIME_SCORE proc
		;Imprime "player_score" en la posición relativa a 'score_ren' y 'score_col'
		mov [ren_aux],score_ren
		mov [col_aux],score_col+20
		mov bx,[player_score]
		call IMPRIME_BX
		ret
	endp

	IMPRIME_HISCORE proc
	;Imprime "player_score" en la posición relativa a 'hiscore_ren' y 'hiscore_col'
		mov [ren_aux],hiscore_ren
		mov [col_aux],hiscore_col+20
		mov bx,[player_hiscore]
		call IMPRIME_BX
		ret
	endp

	;Imprime el valor del registro BX como entero sin signo (positivo)
	;Se imprime con 5 dígitos (incluyendo ceros a la izquierda)
	;Se usan divisiones entre 10 para obtener dígito por dígito en un LOOP 5 veces (una por cada dígito)
	IMPRIME_BX proc
		mov ax,bx
		mov cx,5
	div10:
		xor dx,dx
		div [diez]
		push dx
		loop div10
		mov cx,5
	imprime_digito:

		pop dx
		or dl,30h
		mov [temp], dl
		mov [conta],cl
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color [temp],cBlanco,bgNegro
		xor ch,ch
		mov cl,[conta]
		inc [col_aux]
		loop imprime_digito
		ret
	endp

	IMPRIME_DATOS_INICIALES proc
		;call DATOS_INICIALES 		;inicializa variables de juego
		;imprime la barra del jugador
		;borra la posición actual, luego se reinicializa la posición y entonces se vuelve a imprimir
		call BORRA_JUGADOR
		mov [player_col], ini_columna
		mov [player_ren], ini_renglon
		call IMPRIME_JUGADOR

		;imprime bola
		;borra la posición actual, luego se reinicializa la posición y entonces se vuelve a imprimir
		call BORRA_BOLA
		mov [bola_col], ini_columna
		mov [bola_ren], ini_renglon-1
		call IMPRIME_BOLA

		ret
	endp

	;Inicializa variables del juego
	DATOS_INICIALES proc
		mov [player_score],0
		mov [player_lives],3
		ret
	endp

	;Imprime los caracteres ☻ que representan vidas. Inicialmente se imprime el número de 'player_lives'
	
	IMPRIME_LIVES proc
		xor cx,cx
		mov di,lives_col+20
		mov cl,[player_lives]
	imprime_live:
		push cx
		mov ax,di
		posiciona_cursor lives_ren,al
		imprime_caracter_color 2d,cCyanClaro,bgNegro
		add di,2
		pop cx
		loop imprime_live
		ret
	endp

	BORRA_LIVES proc
		xor cx,cx
		mov di,lives_col+20
		mov cl,[player_lives]
	borra_live:
		push cx
		mov ax,di
		posiciona_cursor lives_ren,al
		imprime_caracter_color 0d,cCyanClaro,bgNegro
		add di,2
		pop cx
		loop borra_live
		ret
	endp

	;Imprime un brick, que recibe como parámetros las variables ren_aux, col_aux y color_brick, que indican la posición superior izquierda del brick y su color
	PRINT_BRICK proc
		mov ah,[col_aux]
		mov al,[ren_aux]
		push ax
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219d,[brick_color],bgNegro
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219d,[brick_color],bgNegro
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219d,[brick_color],bgNegro
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219d,[brick_color],bgNegro
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219d,[brick_color],bgNegro
		pop ax
		mov [ren_aux],al
		mov [col_aux],ah
		ret
	endp

	;Imprime la bola de juego, que recibe como parámetros las variables bola_col y bola_ren, que indican la posición de la bola
	IMPRIME_BOLA proc
		mov ah,[bola_col]
		mov al,[bola_ren]
		posiciona_cursor [bola_ren],[bola_col]
		imprime_caracter_color 2d,cCyanClaro,bgNegro 
		ret
	endp

	;Borra la bola de juego, que recibe como parámetros las variables bola_col y bola_ren, que indican la posición de la bola
	BORRA_BOLA proc
	
		posiciona_cursor [bola_ren], [bola_col]
		imprime_caracter_color 0d, cNegro,bgNegro

		ret
	endp

	;procedimiento IMPRIME_BOTON
	;Dibuja un boton que abarca 3 renglones y 5 columnas
	;con un caracter centrado dentro del boton
	;en la posición que se especifique (esquina superior izquierda)
	;y de un color especificado
	;Utiliza paso de parametros por variables globales
	;Las variables utilizadas son:
	;boton_caracter: debe contener el caracter que va a mostrar el boton
	;boton_renglon: contiene la posicion del renglon en donde inicia el boton
	;boton_columna: contiene la posicion de la columna en donde inicia el boton
	;boton_color: contiene el color del boton
	IMPRIME_BOTON proc
	 	;background de botón
		mov ax,0600h 		;AH=06h (scroll up window) AL=00h (borrar)
		mov bh,cRojo	 	;Caracteres en color amarillo
		xor bh,[boton_color]
		mov ch,[boton_renglon]
		mov cl,[boton_columna]
		mov dh,ch
		add dh,2
		mov dl,cl
		add dl,2
		int 10h
		mov [col_aux],dl
		mov [ren_aux],dh
		dec [col_aux]
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color [boton_caracter],cRojo,[boton_color]
	 	ret 			;Regreso de llamada a procedimiento
	endp	 			;Indica fin de procedimiento UI para el ensamblador
	
	BORRA_JUGADOR proc
		mov ah, [player_col]
		mov [col_aux], ah

		posiciona_cursor [player_ren],[player_col]
		imprime_caracter_color 0,cBlanco,bgNegro
		dec [col_aux]
		posiciona_cursor [player_ren],[col_aux]
		imprime_caracter_color 0,cBlanco,bgNegro
		dec [col_aux]
		posiciona_cursor [player_ren],[col_aux]
		imprime_caracter_color 0,cBlanco,bgNegro
		add [col_aux],3
		posiciona_cursor [player_ren],[col_aux]
		imprime_caracter_color 0,cBlanco,bgNegro
		inc [col_aux]
		posiciona_cursor [player_ren],[col_aux]
		imprime_caracter_color 0,cBlanco,bgNegro
		ret
	endp


	IMPRIME_BRICKS proc
		mov [col_aux],1
		mov [ren_aux],3
		mov di,0
		mapa_sig_columna:
			mov bl,[mapa_bricks+di]
			cmp bl,3
			je mapa_brick_n3
			cmp bl,2
			je mapa_brick_n2
			cmp bl,1
			je mapa_brick_n1
			cmp bl,'#'
			je mapa_fin_renglon
			cmp bl,'%'
			je mapa_fin
		mapa_brick_n3:
			mov [brick_color],cAzul
			jmp mapa_imprime_brick
		mapa_brick_n2:
			mov [brick_color],cVerde
			jmp mapa_imprime_brick
		mapa_brick_n1:
			mov [brick_color],cRojo
		mapa_imprime_brick:
			call PRINT_BRICK
			add [col_aux],5
			inc di
			jmp mapa_sig_columna		
		mapa_fin_renglon:
			add [ren_aux],3
			mov [col_aux],1
			inc di
			jmp mapa_sig_columna
		mapa_fin:
		ret
	endp


LEER_MOUSE proc
	lee_mouse
	and bx,00000011b 	;mascara aplicada sobre BX para ignorar los bits que no corresponden a los botones derecho e izquierdo del mouse
	cmp bx,3			;compara si el valor del registro BX es 3, eso implicaria que ambos botones del mouse estan presionados
	je otro 	;si BX = 3 entonces se cumple condicion y salta a la etiqueta 'clic_derecho_izquierdo'
	cmp bx,2			;compara si el valor del registro BX es 2, eso implicaria que el boton derecho del mouse esta presionado
	je otro	;si BX = 2 entonces se cumple condicion y salta a la etiqueta 'clic_derecho'
	cmp bx,1 			;compara si el valor del registro BX es 1, eso implicaria que el boton izquierdo del mouse esta presionado
	je clic_izquierdo 	;si BX = 1 entonces se cumple condicion y salta a la etiqueta 'clic_izquierdo'
	jmp otro 		
	clic_izquierdo:
		jmp conversion_mouse

	otro:


	ret
endp


IMPRIME_JUGADOR proc
		
;Imprime la barra del jugador, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central de la barra
	;imprime el carácter '' en la posición indicada, 2 renglones hacia arriba y 2 hacia abajo
		mov ah, [player_col]
		mov [col_aux], ah

		posiciona_cursor [player_ren],[player_col]
		imprime_caracter_color 223,cBlanco,bgNegro
		dec [col_aux]
		posiciona_cursor [player_ren],[col_aux]
		imprime_caracter_color 223,cBlanco,bgNegro
		dec [col_aux]
		posiciona_cursor [player_ren],[col_aux]
		imprime_caracter_color 223,cBlanco,bgNegro
		add [col_aux],3
		posiciona_cursor [player_ren],[col_aux]
		imprime_caracter_color 223,cBlanco,bgNegro
		inc [col_aux]
		posiciona_cursor [player_ren],[col_aux]
		imprime_caracter_color 223,cBlanco,bgNegro
		ret

		
endp



MOV_BOLA proc

	mov dl, [segundos] ; Si no ha transcurrido un segundo no se mueve la bola
	cmp dl, [seg_aux]
	je amonos

	mov [seg_aux], dl
		
	mov_bola_salida:		;Se prepara mover bola

	CALL SIGUIENTE_POSICION; 	Checa la siguiente posicion de la bola en el tiempo
	posiciona_cursor [ren_aux],[col_aux] ;posiciona el cursor en esa sig posición
	detecta_caracter ;identifica qué caracter fue

	cmp al, 219d ;Compara si el caracter es un bloque, el ascii del bloque es 219d
	je colision_bloque 
	cmp al, 223d ;Compara si el caracter es la barra, el ascii de la barra es 223d
	je colision_jugador
	cmp al, 186d ;Compara si el caracter es una pared vertical, el ascii de la pared es 186d
	je colision_lim_izq_der
	cmp al, 205d ;Compara si el caracter es una pared horizontal, el ascii de la pared es 205d
	je colision_lim_abajo_arriba
	cmp al, 203d ;Compara si el caracter es las esquina superior derecha
	je esquinas
	cmp al, 201d ;;Compara si el caracter es las esquina superior izquierda
	je esquinas
	cmp al, 200d
	je esquinas
	cmp al, 202d
	je esquinas


	cmp al, 204d
	je marco_Cruce




	call BORRA_BOLA ;elimina la bola para reimprimirla en la sig posición
	mov al, [dir]
	add [bola_col], al 	
	mov al, [dir_ver]
	add [bola_ren], al
	call IMPRIME_BOLA
	jmp amonos

	colision_bloque:		
		
		;Colision con bloque confirmada


		mov [temp],5 ;5 caracteres por bloque

		;Checa con qué bloque colisionó, hay 6 bloques por renglón
		cmp [col_aux], 5 
		jbe primero ;jbe menor o igual al último caracter del bloque 
		cmp [col_aux], 10
		jbe segundo
		cmp [col_aux], 15
		jbe tercero
		cmp [col_aux], 20
		jbe cuarto
		cmp [col_aux], 25
		jbe quinto
		cmp [col_aux], 30
		jbe sexto


		primero:
			mov [col_aux], 1 ;se posiciona en el primer caracter del bloque 
			jmp color;identifica qué color tiene el bloque

		segundo:
			mov [col_aux], 6
			jmp color
		tercero:
			mov [col_aux], 11
			jmp color
		cuarto:
			mov [col_aux], 16
			jmp color
		quinto:
				mov [col_aux], 21
				jmp color
		sexto:
			mov [col_aux], 26
			jmp color


		color:

		cmp ah, 01h
		je azul
		cmp ah, 02h
		je verde
		cmp ah, 04h
		je rojo 

		azul:	;Bucle para eliminar bloque azul
			dec [temp]
			posiciona_cursor [ren_aux],[col_aux] ;recorre el bloque
			imprime_caracter_color 219d,02h,bgNegro ;cambia a verde el color del bloque
			inc [col_aux]
			cmp [temp],0
			jne azul

			add [player_score], 300d ;suma al score 300 pts relacionados al bloque azul
			CALL IMPRIME_SCORE 
			jmp rebotar ;rebota la bola a 90º

		verde:
			dec [temp]
			posiciona_cursor [ren_aux],[col_aux]
			imprime_caracter_color 219d,04h,bgNegro
			inc [col_aux]
			cmp [temp],0
			jne verde
			add [player_score], 200d
			CALL IMPRIME_SCORE
			jmp rebotar

		rojo:
			dec [temp]
			posiciona_cursor [ren_aux],[col_aux]
			imprime_caracter_color 0d,02h,bgNegro
			inc [col_aux]
			cmp [temp],0
			jne rojo
			add [player_score], 100d
			CALL IMPRIME_SCORE
			jmp rebotar

		rebotar:

		cmp [player_score], 10000d
		je win

		cmp [dir_ver], -1d
		je rebotar_abajo

		rebotar_arriba:
			mov [dir_ver],-1d
			jmp mov_bola_salida
		rebotar_abajo:
			mov [dir_ver],1d
			jmp mov_bola_salida


		win:


		mov ax, [player_score]
		mov [player_hiscore], ax

		cmp [dificultad], 4
		je realwin

		regularwin:

		posiciona_cursor 1d, 46d; 
		lea dx,[winner]
		mov ax,0900h	;opcion 9 para interrupcion 21h
		int 21h			;interrupcion 21h. Imprime cadena.


		jmp boton_pausa3
	
			 
		realwin:
		posiciona_cursor 1d, 45d; 
		lea dx,[real_winner]
		mov ax,0900h	;opcion 9 para interrupcion 21h
		int 21h			;interrupcion 21h. Imprime cadena.

		jmp boton_pausa3
	
	

	colision_jugador:

		mov [dir_ver], -1
		jmp mov_bola_salida


	colision_lim_izq_der:

		lim_izq:
		cmp [bola_col], 2d
		jae lim_der
		mov [dir], 1d
		jmp mov_bola_salida
		lim_der:
		cmp [bola_col], 29d
		jbe lim_super
		mov [dir], -1d
		jmp mov_bola_salida

	colision_lim_abajo_arriba:


	lim_super:
		cmp [bola_ren], 2d 
		jae lim_infer
		mov [dir_ver], 1d
		jmp mov_bola_salida

	lim_infer:

		lose_lives:		;Decrementa las vidas

		direccion_inicial
		CALL BORRA_LIVES
		dec [player_lives]
		cmp [player_lives], 0 
		je game_over 		;Si ya no hay vidas es game over
		CALL IMPRIME_LIVES
		CALL JUGADOR_ORIGEN
		call BOLA_ORIGEN
		jmp boton_pausa3

		game_over:		
	
			posiciona_cursor 4d, 55d; 
			imprime_cadena_color [gameover], 9d, cBlanco, bgNegro


			mov ax, [player_hiscore]
			cmp [player_score], ax 	;Si el score es mayor se remplaza el highscore
			jg reemplazar_hscore

			jmp boton_pausa3


			reemplazar_hscore:
			mov ax, [player_score]
			mov [player_hiscore], ax
			jmp boton_pausa3
			

		esquinas:

			cmp [dir_ver], -1d 
			je esquinas_super


			esquinas_inf:

			jmp lose_lives


			esquinas_super:

			cmp [dir], 1d 
			je esquina_superior_der

			esquina_superior_izq:
				mov [dir], 1d
				mov [dir_ver], 1d 
				jmp mov_bola_salida
			esquina_superior_der:
				mov [dir], -1d
				mov [dir_ver], 1d 
				jmp mov_bola_salida


	marco_Cruce:

		cmp [dir_ver], 1d 
		je marco_abajo 

		marco_arriba:

		mov [dir], -1d
		jmp mov_bola_salida


		marco_abajo:
		mov [dir], 1d
		jmp mov_bola_salida

	amonos:

	ret
endp



CRONO proc

	;Se vuelve a leer el contador de ticks
	;Se lee para saber cuántos ticks pasaron entre la lectura inicial y ésta
	;De esa forma, se obtiene la diferencia de ticks
	;por cada incremento en el contador de ticks, transcurrieron 55 ms
	mov ah,00h
	int 1Ah

	;Se recupera el valor de los ticks iniciales para poder hacer la diferencia entre
	;el valor inicial y el último recuperado
	mov ax,[t_inicial]		;AX = parte baja de t_inicial
	mov bx,[t_inicial+2]	;BX = parte alta de t_inicial
	
	;Se hace la resta de los valores para obtener la diferencia
	sub dx,ax  				;DX = DX - AX = t_final - t_inicial, DX guarda la parte baja del contador de ticks
	sbb cx,bx 				;CX = CX - BX - C = t_final - t_inicial - C, CX guarda la parte alta del contador de ticks y se resta el acarreo si hubo en la resta anterior

	;Se asume que el valor de CX es cronómetro
	;Significaría que la diferencia de ticks no es mayor a 65535d
	;Si la diferencia está entre 0d y 65535d, significa que hay un máximo de 65535 * 55ms =  3,604,425 milisegundos
	mov ax,dx

	;Se multiplica la diferencia de ticks por 55ms para obtener 
	;la diferencia en milisegundos
	mul [tick_ms]

	;El valor anterior se divide entre 1000 para calcular la cantidad de segundos 
	;y la cantidad de milisegundos del cronómetro (0d - 999d)
	div [mil]

	;El valor de AX de la división anterior se divide entre 60
	;Segundos a minutos
	div [sesenta]
	;Al final de la división, AH tiene el valor de los segundos (0 -59d) 
	;y AL los minutos (>=0)
	;Nota: ambos valores están en hexadecimal
	
	;Se guardan los segundos en una variable
	mov [segundos],ah

	;Se calcula el número de minutos para el cronómetro dividiendo nuevamente entre 60
	;Esto dará el número de horas, pero en este caso se ignorará
	xor ah,ah
	div [sesenta]

	;Se guarda la cantidad de minutos en una variable
	mov [minutos],ah
    

	ret
crono endp

JUGADOR_ORIGEN proc 
	CALL BORRA_JUGADOR
	mov [player_col], ini_columna
	mov [player_ren], ini_renglon
	call IMPRIME_JUGADOR
	ret
endp

BOLA_ORIGEN proc
	call BORRA_BOLA
	mov [bola_col], ini_columna
	mov [bola_ren], ini_renglon-1
	call IMPRIME_BOLA
	ret
endp

SIGUIENTE_POSICION proc

	cmp [dir_ver], -1d ;verifica si la bola va hacia abajo o arriba. (-1d indica que la bola hacia arriba)
		je arriba ;salta a etiqueta arriba

		abajo: ;caso donde la direc vertical de la bola va hacia abajo
			cmp [dir], 1d ; si dir = 1 quiere decir que va abajo a la derecha
			je abajo_der ; si es vdd salta a etiqueta abajo_der

			abajo_izq: ;si es falso, la bola va abajo a la izquierda
			;obtiene la siguiente posición de la bola
				mov bh, [bola_ren]
				mov bl, [bola_col]
				inc bh 
				dec bl 

				mov [ren_aux], bh 
				mov [col_aux], bl
                
				
				jmp sig_pos
			

			abajo_der:
				mov bh, [bola_ren]
				mov bl, [bola_col]
				inc bh 
				inc bl 

				mov [ren_aux], bh 
				mov [col_aux], bl
				jmp sig_pos

		arriba:

			cmp [dir], 1d
			je arriba_der
			arriba_izq:
				mov bh, [bola_ren]
				mov bl, [bola_col]
				dec bh 
				dec bl

				mov [ren_aux], bh 
				mov [col_aux], bl
				jmp sig_pos

			arriba_der:
			

				mov bh, [bola_ren]
				mov bl, [bola_col]
				dec bh 
				inc bl 
				mov [ren_aux], bh 
				mov [col_aux], bl
				jmp sig_pos


	sig_pos:

	ret

endp



LEE_DIF proc ;Lee la dificultad

	lee:

	mov ah,08h			
	int 21h				;int 21h opcion AH=08h. Lectura de teclado SIN ECO


	;Las siguientes dos comparaciones sirven para verificar si la tecla presionada se encuentra entre 31h y 34h
	;es decir, los digitos 1-4
	;Si está fuera de ese rango, entonces la tecla no fue un carácter numérico o no es una dificultad valida
	cmp al,31h 			
	jl lee 		;Si el valor ASCII de la tecla es menor a 31h, no es número o es igual a 0
	cmp al,34h 			
	jg lee		;Si el valor ASCII de la tecla es mayor a 33h, no es número o es mayor a 4
	
	;Se imprime el caracter
	mov ah,02h		;AH=02h para int 21h
	mov dl,al 		;DL=AL, que contiene el caracter ingresado por el usuario
	int 21h 		;int 21h opcion AH=02h, imprime el caracter contenido en DL

	xor al, 30h
	mov [dificultad], al ;Guarda la dificultad seleccionada

	ret

endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;FIN PROCEDIMIENTOS;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end inicio			;fin de etiqueta inicio, fin de programa
