;********************************************************************************
; PRACTICA 3, EJERCICIO A -> TOMAS HIGUERA VISO Y GUILLERMO HOYO BRAVO, PAREJA 1*
;********************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO                                             *
;********************************************************************************

PRACT3A SEGMENT BYTE PUBLIC 'CODE'
	PUBLIC _comprobarNumeroSecreto, _rellenarIntento
	
	DATOS SEGMENT
		datos_funcion DB 4 DUP (0)
	DATOS ENDS
	
	ASSUME CS: PRACT3A, DS: DATOS
	
		; RUTINA QUE LLAMA A LA FUNCION COMPROBARUMEROSECRETO DEL FICHERO C
		_comprobarNumeroSecreto PROC FAR
			; PUSHEAMOS BP EN LA PILA PARA PODER MOVERNOS POR LA PILA SIN NECESIDAD DE USAR SP
			PUSH BP
			; GUARDAMOS EN BP LA POSICION DE MEMORIA EN LA QUE SE ENCUENTRA LA PILA
			MOV BP, SP
			; GUARDAMOS LOS REGISTROS QUE VAMOS A USAR
			PUSH BX CX DX DI SI
			; GUARDAMOS EN BX EL OFFSET
			MOV BX, [BP + 6] 
			; GUARDAMOS EN DX EL SEGMENT
			MOV DX, [BP + 8]
			; GUARDAMOS EN DI 0 PARA REALIZAR UN BUCLE 
			MOV DI, 0
			; GUARDAMOS EN CX LA POSICION DEL DS
			MOV CX, DS
			; PUSHEAMOS EL DS EN LA PILA
			PUSH CX
			; COLOCAMOS EL DATA SEGMENT EN LA POSICION DE MEMORIA DESDE LA QUE EMPIEZAN LOS DATOS
			MOV DS, DX
			bucle1:
				; GUARDAMOS EN AH EL CONTENIDO DE LA DIRECCION DE MEMORIA QUE NOS PASAN DE ENTRADA
				MOV AH, DS:[BX][DI]
				; GUARDAMOS EN DATOS_FUNCION EL CONTENIDO DE AH
				MOV datos_funcion[DI], AH
				; INCREMENTAMOS EN UNO EL INDICE DI
				INC DI
				; COMPROBAMOS SI YA HEMOS ACABADO EL BUCLE
				CMP DI, 4	
				; SI EL INDICE ES DISTINTO DE 4 CONTINUAMOS EN EL BUCLE
				JNE bucle1
			CALL comprobacion_repetidos
			fin:
				; POPEAMOS EN BX LA POSICION DEL DS
				POP CX
				; COLOCAMOS EL DS EN LA POSICION CORRECTA
				MOV DS, CX
				; POPEAMOS TODOS LOS REGISTROS
				POP SI DI DX CX BX
				; POPEAMOS BP
				POP BP
				; VOLVEMOS A LA RUTINA DE C
				RET
		_comprobarNumeroSecreto ENDP
		
		_rellenarIntento PROC FAR
			; PUSHEAMOS BP EN LA PILA
			PUSH BP
			; GUARDAMOS EN BP LA POSICION DE LA PILA
			MOV BP, SP
			; GUARDAMOS LOS REGISTROS QUE VAMOS A USAR
			PUSH BX CX DX DI SI
			; GUARDAMOS EN AX EL NUMERO EN CUESTION
			MOV AX, [BP + 6]
			; GUARDAMOS EN BX EL OFFSET EN EL QUE GUARDAREMOS
			MOV BX, [BP + 8]
			; GUARDAMOS EN CX EL DATA SEGMENT EN EL QUE GUARDAREMOS
			MOV CX, [BP + 10]
			; GUARDAMOS EN DX LA POSICION ACTUAL DEL DATA SEGMENT
			MOV DX, DS
			; PUSHEAMOS DX EN LA PILA
			PUSH DX
			; COLOCAMOS EL DATA SEGMENT EN EL SEGMENTO QUE HEMOS GUARDADO
			MOV DS, CX
			; LLAMAMOS A LA FUNCION PARA DIVIDIR EL NUMERO
			CALL dividir_numero
			; SACAMOS DX DE LA PILA
			POP DX
			; COLOCAMOS EL DATA SEGMENT EN LA POSICION EN LA QUE SE ENCONTRABA AL PRINCIPIO
			MOV DS, DX
			; POPEAMOS TODOS LOS REGISTROS
			POP SI DI DX CX BX
			; POPEAMOS BP DE LA PILA
			POP BP
			; VOLVEMOS DONDE SE HA LLAMADO LA FUNCION
			RET
		_rellenarIntento ENDP
		
		;***********************************
		;*FUNCIONES UTILIZADAS EN EL CODIGO*
		;***********************************
		
		comprobacion_repetidos PROC
			; GUARDAMOS EN DI 0 PARA RECORRER EL ARRAY
			MOV DI, 0
			; REALIZAMOS UN BUCLE DE COMPROBACION DE LOS DATOS DEL ARRAY
			bucle2:
				; GUARDAMOS EN SI EL CONTENIDO DE DI PARA NO REPETIR COMPROBACION
				MOV SI, DI
				; INCREMENTAMOS SI PARA COMENZAR A COMPROBAR DESDE EL NUMERO SIGUIENTE
				INC SI
				; GUARDAMOS EN AH LOS DATOS DEL NUMERO DE LA FUNCION A COMPROBAR
				MOV AH, datos_funcion[DI]
				bucle3:
					; GUARDAMOS EN BH EL NUMERO DEL ARRAY CON EL QUE COMPARAREMOS 
					MOV BH, datos_funcion[SI]
					; COMPROBAMOS SI BH Y AH SON IGUALES
					CMP AH, BH
					; SI AMBOS REGISTROS SON DIFERENTES SALTAMOS A LA RUTINA REPETIDOS
					JE repetidos
					; SI SON DIFERENTES CONTINUAMOS CON LA COMPROBACION
					; INCREMENTAMOS EN UNO SI Y SEGUIMOS COMPROBANCO
					INC SI
					; COMPROBAMOS SI HEMOS LLEGADO AL FINAL DEL ARRAY
					CMP SI, 4
					; SI SI ES DISTINTO DE 4 SEGUIMOS COMPROBANDO
					JNE bucle3
				; INCREMENTAMOS DI PARA COMPROBAR EL SIGUIENTE NUMERO DEL ARRAY
				INC DI
				; COMPROBAMOS SI NOS ENCONTRAMOS EN EL ULTIMO NUMERO
				CMP DI, 3
				; SI DI ES DISTINTO DE 3 SEGUIMOS COMPROBANDO
				JNE bucle2
			; GUARDAMOS EN AX 0 PORQUE 
			MOV AX, 0
			; VOLVEMOS DONDE HEMOS LLAMADO A LA FUNCION
			RET
			repetidos:
				; GUARDAMOS EN AX 1 PORQUE SE HA REPETIDO UN NUMERO
				MOV AX, 1
				; VOLVEMOS DONDE HEMOS LLAMADO A LA FUNCION
				RET
		comprobacion_repetidos ENDP
		
		dividir_numero PROC
			; COLOCAMOS EL INDICE DI EN LA ULTIMA POSICION DEL ARRAY
			MOV DI, 3
			division:
				; INICIALIZAMOS DX A 0
				MOV DX, 0
				; GUARDAMOS EN CX 10 PARA DIVIDIR
				MOV CX, 0Ah
				; DIVIDIMOS ENTRE CX
				DIV CX
				; GUARDAMOS EL RESTO EN LA ULTIMA POSICION DE LA CADENA DE CARACTERES
				MOV DS:[BX][DI], DL
				; DECREMENTAMOS EL INDICE EN 1
				DEC DI
				; COMPROBAMOS SI EL COCIENTE ES 0
				CMP  AX, 0
				; SI NO ES 0 CONTINUAMOS DIVIDIENDO
				JNE division
			; COMPROBAMOS SI EL NUMERO ERA DE CUATRO CIFRAS
			CMP DI, -1
			; SI EL NUMERO NO ES DE CUATRO CIFRAS SALTAMOS A LA RUTINA RELLENAR
			JNE rellenar
			; SI EL NUMERO ES DE CUATRO CIFRAS VOLVEMOS DONDE HAN LLAMADO LA FUNCION
			RET
			rellenar:
				; GUARDAMOS UN 0 EN LAS POSICIONES RESTANTES
				MOV BYTE PTR DS:[BX][DI], 0h
				; DECREMENTAMOS EL INDICE
				DEC DI
				; COMPROBAMOS SI EL ARRAY ESTA LLENO
				CMP DI, -1
				; SI EL INDICE NO ES -1 CONTINUAMOS EN EL BUCLE
				JNE rellenar
				; VOLVEMOS DONDE HAN LLAMADO LA FUNCION
				RET
		dividir_numero ENDP
		
PRACT3A ENDS ; FIN DEL SEGMENTO DE CODIGO
END		     ; FIN DE pract3a.asm