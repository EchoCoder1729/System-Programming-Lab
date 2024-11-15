.model small
.stack 300h
.data  
    arr db 50 dup(0)
    msg1 db 'Enter number of elements in the array: $'
    msg2 db 'Enter elements of the array: $'
    msg3 db 'Largest element of the array: $'
    msg4 db 'Smallest element of the array: $'
    endl db 0ah, 0dh, '$'
    len db 00h
    mx db 00h
    mn db 00h

.code

print macro msg
    push ax
    push dx
    lea dx, msg
    mov ah, 09h
    int 21h
    pop dx
    pop ax
endm


main proc
    mov ax, @data
    mov ds, ax

    print msg1
    call readnum
    mov len, al
    xor bx, bx
    mov bl, len

    rdnxt:
        print msg2
        call readnum
        mov arr[bx], al
        dec bx
    jnz rdnxt

    xor cx, cx
    mov bx, 1
    xor ax, ax
    mov cl, len
    mov al, arr[bx]
    mov mx, al
    mov mn, al
    inc bx
    find_ext:
        mov al, arr[bx]
        cmp al, mx
        jbe check_min
        mov mx, al
        jmp nxt

        check_min:
        cmp al, mn
        jae nxt
        mov mn, al

        nxt:
        inc bx
        cmp bx, cx 
    jbe find_ext

    print msg3
    xor ax, ax
    mov al, mx
    call writenum
    print endl
    print msg4
    xor ax, ax
    mov al, mn
    call writenum

    mov ah, 4ch
    int 21h
main endp

readnum proc near
	; this procedure will take a number as input from user and store in AL
	; input : none
	
	; output : AL

	
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

writenum proc near
	; this procedure will display a decimal number
	; input : AX
	; output : none

	push bx                        
	push cx                        
	push dx                        

	xor cx, cx
	mov bx, 0ah                     

	@output:                       
		xor dx, dx                   
		div bx                       ; divide AX by BX
		push dx                      ; push remainder onto the STACK
		inc cx                       
		or ax, ax                    
	jne @output                    

	mov ah, 02h                      ; set output function

	@display:                      
		pop dx                       ; pop a value(remainder) from STACK to DX
		or dl, 30h                   ; convert decimal to ascii code
		int 21h                      
	loop @display                  

	pop dx                         
	pop cx                         
	pop bx                         

	ret                            
writenum endp
	
end main
