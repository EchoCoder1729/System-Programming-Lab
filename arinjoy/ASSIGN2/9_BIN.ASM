.MODEL SMALL
.STACK 300H
.DATA
ARRAY1 DB 10 dup(?)
MSG4 DB 0AH,0DH,'Enter size of the array: $'
MSG1 DB 0AH,0DH,'Enter number to be searched: $'
MSG2 DB 0AH,0DH,'Linear Search: Number found at:  $ '
MSG5 DB 0AH,0DH,'Binary Search: Number found at:  $ '
MSG3 DB 0AH,0DH,'NOT FOUND$'
ENDL DB 0AH,0DH,'$'
SPACE DB ' $'

SE DB 33H
COUNT DB 00H
idx db 0

.CODE
; linear and binary search
PRINT MACRO MSG
	push ax
	push dx
	mov AH, 09H
	lea DX, MSG
	int 21H
	;int 3
	pop dx
	pop ax
ENDM

MAIN PROC
	MOV AX,@DATA
	MOV DS,AX

START:

	PRINT MSG4
	call readnum
	mov COUNT, al
	mov cl, COUNT
	mov bx, 00h
	; Reading the array elements
	rdnxt:
		PRINT ENDL
		call readnum
		mov ARRAY1[BX],AL
		inc BX
	loop rdnxt
	; Printing the array elements
	mov cl, COUNT
	;lea si, ARRAY1
	mov bx,0
	shwnxt:
		PRINT SPACE
		mov al,ARRAY1[bx]
		mov ah,0
		call writenum
		inc bx
	loop shwnxt

	;lea si, ARRAY1
	;mov bh,0
	;mov bl, COUNT
	;call PRINT_ARRAY

	PRINT MSG1
	call readnum
	mov se,al
	LEA SI, ARRAY1
    mov cl, COUNT
    mov ch, 0
    call binarySearchFunction
    cmp dx, 0
    jnz FO
    print MSG3
    jmp END1
 
FO:
	PRINT MSG5
	mov ax, dx
    dec ax
	call writenum
 
END1:
	mov ah, 4ch
	int 21h

MAIN ENDP

PRINT_ARRAY PROC
   ; this procedure will print the elements of a given array
   ; input : SI=offset address of the array
   ;       : BX=size of the array
   ; output : none

   PUSH AX                        ; push AX onto the STACK   
   PUSH CX                        ; push CX onto the STACK
   PUSH DX                        ; push DX onto the STACK
   push SI
   MOV CX, BX                     ; set CX=BX

   @PRINT_ARRAY:                  ; loop label
     XOR AH, AH                   ; clear AH
     MOV AL, [SI]                 ; set AL=[SI]

     CALL writenum                  ; call the procedure OUTDEC

     MOV AH, 2                    ; set output function
     MOV DL, 20H                  ; set DL=20H
     INT 21H                      ; print a character

     INC SI                       ; set SI=SI+1
   LOOP @PRINT_ARRAY              ; jump to label @PRINT_ARRAY while CX!=0

   pop SI
   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP AX                         ; pop a value from STACK into AX

   RET                            ; return control to the calling procedure
 PRINT_ARRAY ENDP


readnum proc near
	
	push bx
	push cx
	mov cx,0ah
	mov bx,00h
loopnum: 
	mov ah,01h
	int 21h
	cmp al,'0'
	jb skip
	cmp al,'9'
	ja skip
	sub al,'0'
	push ax
	mov ax,bx
	mul cx
	mov bx,ax
	pop ax
	mov ah,00h
	add bx,ax
	jmp loopnum
skip:
	mov ax,bx
	pop cx
	pop bx
	ret
readnum endp

writenum PROC near
   ; this procedure will display a decimal number
   ; input : AX
   ; output : none

   push bx                        ; push BX onto the STACK
   push cx                        ; push CX onto the STACK
   push dx                        ; push DX onto the STACK

   XOR CX, CX                     ; clear CX
   MOV BX, 10                     ; set BX=10

   @OUTPUT:                       ; loop label
     XOR DX, DX                   ; clear DX
     DIV BX                       ; divide AX by BX
     PUSH DX                      ; push DX onto the STACK
     INC CX                       ; increment CX
     OR AX, AX                    ; take OR of Ax with AX
   JNE @OUTPUT                    ; jump to label @OUTPUT if ZF=0

   MOV AH, 2                      ; set output function

   @DISPLAY:                      ; loop label
     POP DX                       ; pop a value from STACK to DX
     OR DL, 30H                   ; convert decimal to ascii code
     INT 21H                      ; print a character
   LOOP @DISPLAY                  ; jump to label @DISPLAY if CX!=0

   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP BX                         ; pop a value from STACK into BX

   RET                            ; return control to the calling procedure
writenum ENDP
	
binarySearchFunction proc
    ; Inputs: SI= array offset address, CX = End index, SE = Element to search for
    ; Outputs: DX = Index of found element (1-indexed), or 0 if not found

    push ax
    push bx
    push cx
    push si
    push di
    xor bx,bx
    mov dx, si
    mov di, si
    
binarySearchLoop:
    CMP BX, CX             ; If start index > end index, exit loop
    JG bs_not_found

    ; Calculate the midpoint (SI = (BX + CX) / 2)
    MOV SI, BX
    ADD SI, CX
    SHR SI, 1              ; Midpoint in SI

    ; Access ARRAY at 0-indexed position SI
    ADD DI, SI             ; DI points to ARRAY[SI]
    mov dl, se
    CMP [DI], dl           ; Compare midpoint element with search element
    JZ bs_found            ; If equal, found the element

    ; Adjust search range
    JA adjust_right_side   ; If se > [DI], search in the upper half

    ; Else, search in the lower half
    MOV CX, SI             ; Update end index to midpoint - 1
    DEC CX
    JMP binarySearchLoop   ; Repeat loop with adjusted range

adjust_right_side:
    MOV BX, SI             ; Update start index to midpoint + 1
    INC BX
    JMP binarySearchLoop   ; Repeat loop with adjusted range

bs_found:
    MOV DX, SI             ; Store found index in DX
    INC DX
    JMP bs_done

bs_not_found:
    MOV DX, 0             ; Element not found, return 0

bs_done:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    RET
binarySearchFunction endp

END MAIN
