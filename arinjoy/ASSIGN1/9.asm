.model small
.stack 100h
.data
msg db 13,10,"Press q to quit: $"
.code

main proc

mov ax, @data
mov ds, ax

mov dx, OFFSET msg

l1: 
    mov ah, 09h         ; Display message
    int 21h
    mov ah, 01h         ; Read character
    int 21h
    cmp al, 71h         ; Compare with 'q'
    je exit             ; If 'q', exit
    cmp al, 51h         ; Compare with 'Q'
    je exit             ; If 'Q', exit
    jmp l1              ; Loop again if not 'q' or 'Q'

exit:
    mov ah, 4ch         ; Exit program
    int 21h

main endp
end main
