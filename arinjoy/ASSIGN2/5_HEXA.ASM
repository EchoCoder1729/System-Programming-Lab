.model small
.stack 100h
.data
msg1 db 0AH,0DH,'ENTER FIRST NUMBER: $'
msg2 db 0AH,0DH,'ENTER SECOND NUMBER: $'
msg3 db 0AH,0DH,'Division result: $'
msg_rem db 13,10,'Reminder: $'
space db ' $'
endl db 0AH,0DH,'$'

val1 dw ?
val2 dw ?
rem dw ?

hex_digits db "0123456789ABCDEF$" ; Hexadecimal characters for conversion

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
	mov ax,@data
	mov ds,ax
	
	start:
	
	print msg1
	
	call ReadNum
    call writenum
	mov val1, ax

	print msg2

	call ReadNum
    call writenum
	mov val2, ax

	print msg3
	mov ax, val1
	mov bx, val2
    xor dx, dx 
	div bx
	call writenum
    print msg_rem
	mov ax, dx
	call writenum	
	
	exit:
    mov ah, 4ch
    int 21h

main endp

;procedure to read a 16 bit hexadecimal number and store it in ax
ReadNum proc
    push bx
    push cx
    push dx

    mov cl,4
    xor bx, bx
    xor ax, ax
    input:
    mov ah,1
    int 21h
    cmp al, 0dh
    je exitLoop
    cmp al, 39h
    jg letterInput
    and al, 0fh
    jmp shift
    letterInput:
    sub al, 37h
    shift:
    shl bx, cl
    or bl, al
    jmp input
    exitLoop:
    mov ax,bx

    pop dx
    pop cx
    pop bx
    ret
ReadNum endp

;Procedure to print a hexadecimal number stored in ax
writenum proc
    push ax
    push bx
    push cx
    push dx
    push si
    xor dx, dx
    mov bx,ax
    mov cx,4
    PrintNextHexDigit:
        rol bx, 1              ; Rotate left 4 bits (1 hex digit at a time)
        rol bx, 1 
        rol bx, 1 
        rol bx, 1 
        mov dl, bl             ; Isolate lower nibble
        and dl, 0Fh            ; Mask out high nibble
        mov dh,0
        mov si,dx
        mov ah, hex_digits[si] ; Get ASCII character for hex digit
        mov dl, ah
        mov ah, 02h            ; Function 2 - display character
        int 21h                ; Display the hex digit
        dec cx
        jnz PrintNextHexDigit
    pop si
    pop dx
    pop cx
    pop bx                     ; Restore BX
    pop ax                     ; Restore AX
    ret
writenum endp

end main

