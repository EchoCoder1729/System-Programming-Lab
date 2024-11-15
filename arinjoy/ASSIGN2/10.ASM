.model small
.stack 300h
.data
msg1 db 0AH,0DH,'Enter number: $'
msg2 db 0AH,0DH,'Prime number are $ '
msg3 db 0AH,0DH,'Number is not prime $'
endl db 0AH,0DH,'$'
space db ' $'
val db ?

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
	
	print msg2
    mov ax,02h
    call writenum
    print space
	mov al,03h

  loop2 : 
    mov val,al
    mov cl, 02h
	loop1:
		mov al, val
		mov ah,00h
		div cl
		or ah,ah
		jz notp
		inc cl
		cmp cl, val
	jb loop1

	isp:
  mov al, val
  mov ah,0
	call writenum
  print space
    notp :
    mov al,val
    inc al
    cmp al,64h
    jb loop2	
	  
    exit:
    mov ah, 4ch
    int 21h
main endp

writenum proc near

	push ax
	push bx                        
	push cx                        
	push dx                        

	xor cx, cx
	mov bx, 0ah                     

	@output:                       
		xor dx, dx                   
		div bx                      
		push dx                   
		inc cx                       
		or ax, ax                    
	jne @output                    

	mov ah, 02h                      

	@display:                      
		pop dx                      
		or dl, 30h                 
		int 21h                      
	loop @display                  

	pop dx                         
	pop cx                         
	pop bx 
	pop ax

	ret                            
writenum endp

end main
