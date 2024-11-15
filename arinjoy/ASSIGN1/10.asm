.model small
.stack 100h
.data
.code

main proc

mov bl, 41h
mov cl, 00h
l1:
mov dl, bl
mov ah, 2
int 21h
add cl, 01h
add bl,01h
mov al, cl
cmp al, 1ah
jne l1

mov ah, 4ch
int 21h

main endp
end main

