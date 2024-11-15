.model small
.stack 100h
.data
array db 6, 3, 2, 5, 3, 7, 2
n dw 7
min db 00h
max db 00h
msg1 db 13,10,'Minimum number of array is: $'
msg2 db 13,10,'Maximum number of array is: $'
.code
main proc
mov ax, @data
mov ds, ax
mov si, OFFSET array
mov cx, n

mov al, [si]
mov dl, al
call print_result
mov min, al
mov max, al
add si, 1
dec cx

traverse: mov al, [si] ; loop begins

mov dl, al
call print_result

cmp al, min
jge skip_min
mov min, al

skip_min: cmp al, max
jle skip_max
mov max, al

skip_max: add si, 1
dec cx
jne traverse ; loop ends

lea dx, msg1
mov ah, 09h
int 21h
mov dl, min
mov ah, 02h
int 21h
lea dx, msg2
mov ah, 09h
int 21h
mov dl, max
mov ah, 02h
int 21h

mov ah, 4ch
int 21h

print_result: add dl, 30h
mov ah, 02h
int 21h
ret

main endp
end main