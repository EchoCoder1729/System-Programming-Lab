.model small
.stack 100h
.data
msg1 db 13,10,"Enter first number: $"
msg2 db 13,10,"Enter second number: $"
msg3 db 13,10,"Second number is less than first$"
msg4 db 13,10,"Second number is greater than first$"
num1 db ?
num2 db ?
.code
main proc
; can only be used to operate on single digit hexadecimal numbers
mov ax, @data
mov ds,ax
mov dx, OFFSET msg1
mov ah, 09h
int 21h
mov ah, 01h
int 21h
sub al, '0'
mov num1, al
mov dx, OFFSET msg2
mov ah, 09h
int 21h
mov ah, 01h
int 21h
sub al, '0'
mov num2, al
mov al, num1
cmp al, num2
jc ahead
mov dx, OFFSET msg3
mov ah, 09h
int 21h
jmp here
ahead: mov dx, OFFSET msg4
mov ah, 09h
int 21h
here: mov ah, 4ch
int 21h
main endp
end main
