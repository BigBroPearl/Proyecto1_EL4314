;Proyecto1-EL4314 Juan Pablo Cruz Vargas

%include "linux64.inc"

section .data
	config db "variables.txt",0
	datos db "nombres.txt",0
;Codigos ANSI
	ver db 0x1b, "[32m"
	red db 0x1b, "[31m"
	amar db 0x1b, "[37m"
	white db 0x1b, "[33m"
;Cadenas de texto
	filaend db "|"
	cien db  "100 "
	x db "X"
	espacios2 db "  "
	espacios4 db "    "
	tab db "	"
	espacioent db " ",10

section .bss

;Espacios guardados
	texto_config resb 150 ;reserva bytes para leer archivo variables
	texto_datos resb 1000 ;reserva bytes para leer archivo datos
	almacena_config resb 1000 ;reserva bytes para almacenar variables
	almacena_datos resb 1000 ;reserva bytes para almacenar datos-nombres
	byteactual resw 1
	bytefinal resw 1
;Marcadores de posicion bubble-sort
	fila1in resw 1
	fila1out resw 1
	fila2in resw 1
	fila2out resw 1

	filacont resw 1
	filacopiador resw 1
	sizef1 resw 1
	sizef2 resw 1

	letracont resw 1
	letracopia resw 1
	bubblesort resw 1
;Guardar datos-nombres
	arreglo_notas resb 100
	arreglo_estudiantes resb 100
	nota resb 1
	num1 resb 1
	num2 resb 1
	notastotal resb 100
;comparar
        letra1 resb 1
        letra2 resb 1
        fila1copiada resb 1
        fila2copiada resb 1

;Variables de variables.txt
	aprobado resb 3
	reprobado resb 2
	ordenamiento resb 1
;con esto ahora sí me lee las notas ahhhhhhhhhhh
	size_nota resb 2
	escala resb 2


 section .text
	global _start
	_start:
;abre variables.txt
	mov rax, SYS_OPEN
	mov rdi, config
	mov rsi, O_RDONLY
	mov rdx, 0
	syscall
;lee el archivo de variables
	push rax
	mov rdi, rax
	mov rax, SYS_READ
	mov rsi, texto_config
	mov rdx, almacena_config
;cierra el archivo
	syscall
	mov rax, SYS_CLOSE
	pop rdi
	syscall

	print texto_config


;extrae el texto
	mov ax, [texto_config+21]; almacena en ax
	mov word [aprobado],ax ;almacena en aprobado los datos de ax
	mov ax, [texto_config+45]
	mov word [reprobado], ax
	mov ax, [texto_config+105]
	mov word [escala],ax
	mov al, [texto_config+122]
	mov byte [ordenamiento], al

;abre nombres.txt
	mov rax, SYS_OPEN
	mov rdi, datos
	mov rsi, O_RDONLY
	mov rdx, 0
	syscall
;lee nombres
	push rax
	mov rdi, rax
	mov rax, SYS_READ
	mov rsi, texto_datos
	mov rdx, almacena_datos
	syscall
;cierra el archivo
	mov rax, SYS_CLOSE
	pop rdi
	syscall
	print texto_datos

;limpiar todas las variables que se usan
	mov word [bubblesort],0d	;se limpia el contador
	clear:
	mov word [byteactual],0d
	mov word [fila1in],0d
	mov word [fila1out],0d
	mov word [fila2in],0d
	mov word [fila2out],0d

	mov word [bytefinal],900d
	mov word [letracont],0d
	mov word [filacopiador],0d
	mov word [sizef1],0d
	mov word [sizef2],0d
	mov word [filacont],1d

ordenbubble:

        mov word bx,[byteactual]; carga la letra actual para iniciar la fila 1
	mov byte al, [texto_datos +rbx ]

	mov word r10w,[filacopiador]
	mov byte [fila1copiada+r10],al
	add word r10w,1d
	mov word [filacopiador],r10w
        mov word cx,[byteactual]
	mov word  [fila1out], cx

	mov word [byteactual],cx
	add word cx, 1d
	mov word [byteactual],cx


	cmp byte al,10d ; compara letra actual
	jne ordenbubble
	mov word r9w,[filacopiador]
	mov word [sizef1],r9w
	mov word [filacopiador],0d


	mov word [fila2in],cx
	mov word r11w,[filacont]
	add word r11w, 1d
	mov word [filacont],r11w


_wascii2dec:
	mov byte al, [num1]
	mov byte bl,[num2]
	sub byte al,48d
	sub byte bl,48d
	mov byte cl,al
	add byte al,cl
        add byte al,cl
        add byte al,cl
        add byte al,cl
        add byte al,cl
        add byte al,cl
        add byte al,cl
        add byte al,cl
        add byte al,cl
	add byte al,bl
	ret

_wdeci2ascii:
	mov byte cl,al
	mov byte bl,10d
	div byte bl
	add byte al,48d
	mov byte [num1],al
	sub byte al,48d
	mul byte bl
	sub byte cl,al
	add byte cl,48d
	mov byte [num2],cl
	ret

finalprograma:
                mov rax,60
                mov rdi,0
                syscall

