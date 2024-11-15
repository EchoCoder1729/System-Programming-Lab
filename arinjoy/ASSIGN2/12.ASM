.MODEL SMALL
.STACK 100h
.DATA
old_name db 50 dup(?)
new_name db 50 dup(?)
msg1 db 13,10,"File is renamed$"
msg2 db 13,10,"File cannot be renames$"
msg3 db 13,10,"old name: $"
msg4 db 13,10,"new name: $"
.CODE
print macro msg
	push ax
	push dx
	mov ah, 09h
	lea dx, msg
	int 21h
	pop dx
	pop ax
endm

MAIN PROC
mov ax, @data
mov ds, ax
print msg3
mov si,0
mov ah,1
input1:
	int 21H
	cmp al, 0dh
	je ahead1
	mov old_name[si], al
	inc si
jmp input1
ahead1:
mov old_name[si],0
print msg4
mov si,0
mov ah,1
input2:
	int 21H
	cmp al, 0dh
	je ahead2
	mov new_name[si], al
	inc si
jmp input2
ahead2:
mov new_name[si],0
mov ah,56h
mov dx, seg old_name
mov ds,dx
mov dx,offset old_name
mov di,seg new_name
mov es,di
mov di,offset new_name
int 21h
jc error
print msg1
jmp ahead
error:
print msg2
ahead: mov ah,4ch
int 21h

MAIN ENDP
END MAIN