.model small
.stack 300h
.data
msg1 db 0AH,0DH,'Enter binary number: $'
msg2 db 0AH,0DH,'Decimal: $'
msg3 db 0AH,0DH,'Enter Decimal number: $'
msg4 db 0AH,0DH,'Binary: $'

space db ' $'
endl db 0AH,0DH,'$'

val1 dw ?
val2 dw ?

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
	call readbin
	print msg2
	call writenum
	print msg3
	call readnum
	print msg4
	call writebin
	
	exit:
    mov ah, 4ch
    int 21h

main endp

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

readbin proc near

	push bx
	push cx
	mov cx,02h
	mov bx,00h
	loop1: 
		mov ah,01h
		int 21h
		cmp al,'0'
		jb skip1
		cmp al,'1'
		ja skip1
		sub al,'0'
		push ax
		mov ax,bx
		mul cx
		mov bx,ax
		pop ax
		mov ah,00h
		add bx,ax
	jmp loop1
	
	skip1:
	mov ax,bx
	pop cx
	pop bx
	ret
readbin endp

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

writebin proc near
	push ax
	push bx                        
	push cx                        
	push dx                        

	xor cx, cx
	mov bx, 02h                     

	@out:                       
		xor dx, dx                   
		div bx                       ; divide AX by BX
		push dx                      ; push remainder onto the STACK
		inc cx                       
		or ax, ax                    
	jne @out                    

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
writebin endp

end main
