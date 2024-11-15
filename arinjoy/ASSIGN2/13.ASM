.model small

.stack 100h

.data
year dw 0
month db 0
day db 0
hours db 0
minutes db 0
seconds db 0
msg1 db 13,10,"System date is: $"
msg2 db 13,10,"System Time is: $"
msg3 db "hours$"
msg4 db "minutes$"
char1 db "/$"
char2 db ":$"
char3 db "0$"
endl db 13,10,"$"

.code

print macro msg
	push ax
	push dx
	mov ah, 09h
	lea dx, msg
	int 21h
	pop dx
	pop ax
endm

main proc

mov ax, @data
mov ds,ax

mov ah,2ah
int 21h

mov year,cx
mov month,dh
mov day, dl
mov ah,2ch
int 21h
mov hours,ch
mov minutes,cl
mov seconds,dh

print msg1
mov al, day
mov ah, 0
call writenum
print char1
mov al,month
mov ah, 0
call writenum
print char1
mov ax,year
call writenum

print msg2
mov al, hours
mov ah, 0
call writenum
print char2
mov cl, minutes
cmp cl, 0ah
jge ahead1
print char3
ahead1:
mov al, minutes
mov ah, 0
call writenum
print char2
mov cl, seconds
cmp cl, 0ah
jge ahead2
print char3
ahead2:
mov al, seconds
mov ah, 0
call writenum

mov ah, 4ch
int 21h

main endp
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
end main