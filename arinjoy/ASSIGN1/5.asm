.model small
.stack 100h
.data
msg db 13,10,"The program terminated successfully with error code 0$"
.code

main proc

mov ax,@data
mov ds,ax
mov dx, OFFSET msg
mov ah,09h
int 21h

mov ah, 4ch
int 21h

main endp

end main
