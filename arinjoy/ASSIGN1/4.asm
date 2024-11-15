.model small
.stack 100h
.data
array db 5,2,3,4,5,6,7,8,9
n dw 9
first_max db ?
second_max db ?
first_min db ?
second_min db ?
msg1 db 13,10,'Second Smallest number is: $'
msg2 db 13,10,'Second Largest number is: $'
.code

main proc

mov ax, @data ; Init Array
mov ds, ax
mov si, OFFSET array
mov cx, n ; Load array length

mov al, [si] ; load the element of the array
mov dl, al
call print_result ; print the element of the array
mov first_min, al ; init first_min with first element
mov second_min, al ; init second_min with first element
mov first_max, al ; init first_max with first element
mov second_max, al ; init second_max with second element
add si, 1
dec cx

traverse: mov al, [si] ; loop begins

mov dl, al
call print_result ; printing each element of the array

; Update first_max and second_max
    cmp al, first_max
    jle check_second_max
    mov bl, first_max
    mov second_max, bl
    mov first_max, al
    jmp check_min
    
check_second_max:
    cmp al, second_max
    jle check_min
    mov second_max, al

check_min:
    ; Update first_min and second_min
    cmp al, first_min
    jge check_second_min
    mov bl, first_min
    mov second_min, bl
    mov first_min, al
    jmp next
    
check_second_min:
    cmp al, second_min
    jge next
    mov second_min, al

next:
    add si, 1 ; Move to next array element
	dec cx
	jne traverse ; loop ends

lea dx, msg1
mov ah, 09h
int 21h
mov dl, second_min
mov ah, 02h
int 21h
lea dx, msg2
mov ah, 09h
int 21h
mov dl, second_max
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
