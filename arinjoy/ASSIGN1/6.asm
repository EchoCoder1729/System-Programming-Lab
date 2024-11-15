.model small
.stack 100h
.data
msg1 db 13,10,"Type a character: $"
msg2 db 13,10,"The entered character is: $"

.code

main proc

mov ax, @data
mov ds,ax
mov dx, OFFSET msg1
mov ah, 09h
int 21h

mov ah,1
int 21h
mov bx, ax

mov ax, @data
mov ds, ax
mov dx, OFFSET msg2
mov ah, 09h
int 21h

mov ax, bx
mov dl, al
mov ah, 02h
int 21h

mov ah, 4ch
int 21h

main endp
end main
