.model small
.stack 300h
.data
arr db 50 dup(0)
msg1 db 'Enter number of elements in array: $'
msg4 db 'Enter element of the array: $'
msg2 db 'Second largest element in the array: $'
msg3 db 'Second smallest element in the array: $'
endl db 0ah,0Dh,'$'
siz db 00h

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
    mov ds, ax

    mov si, 0
    ; reading the number of elements in the array
    print msg1
    call readnum 
    mov siz, al
    mov bl, siz
    mov bh, 0
    ; populating the array in reverse order
    rdnxt:
        print msg4
        call readnum
        mov arr[bx], al
        dec bx
    jnz rdnxt

    mov si, 0
    mov cl, siz
    mov ch, 0
    mov bx, cx
    xor ax, ax
    dec bx
    ; Sorting the array (bubble sort) larger element bubbles up
    outer:
        mov si, 1
        mov di, 2
        mov cx, bx
        inner: 
            mov al, [arr+si]
            cmp al, [arr+di]
            jbe NoSwap  
            xchg al, [arr+di]
            mov [arr+si], al 
            NoSwap:
            inc di
            inc si    
        loop inner
        dec bx
    jnz outer
    ; printing the second smallest element
    print msg3
    mov si, 2
    xor ax, ax
    mov al, [arr+si]
    call writenum

    print endl
    ; printing the second largest element
    print msg2
    mov bl, siz
    mov bh, 0
    mov si, bx
    sub si, 1
    xor ax, ax
    mov al, [arr+si]
    call writenum
    
    print endl

    mov ah, 4ch
    int 21h
main endp


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
end main
