.model small
.stack 300h
.data
char1 db '($'
char2 db ')$'
space db ' $'
endl db 0AH,0DH,'$'

val1 dw ?

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
	
	mov bx, 64h
	mov ax, 64h
	loop1:
		print char1
		call writenum
		print space
		mov val1, ax
		
		mov ax, bx
		mov cx, val1
		sub ax, cx
		call writenum
		print char2
		print space
		
		mov ax, val1
		sub ax,2
		jnz loop1
		        
	print char1
	call writenum
	print space
	mov ax, 64h
	call writenum
	print char2
      	
	exit:
    mov ah, 4ch
    int 21h

main endp

writenum proc near
	; this procedure will display a decimal number
	; input : AX
	; output : none

	push ax
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
	pop ax

	ret                            
writenum endp

end main