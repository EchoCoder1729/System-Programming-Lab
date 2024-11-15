.model small
.stack 100h
.data
msg1 db 13,10,"Enter multiplicand: $"
msg2 db 13,10,"Enter nultiplier: $"
;multiplicand dw 1234h, 5678h  ; 32-bit multiplicand
;multiplier   dw 8765h, 4321h  ; 32-bit multiplier
multiplicand dw 0004h, 0000h  ; 32-bit multiplicand
multiplier   dw 0005h, 0000h  ; 32-bit multiplier
product      dw 0, 0, 0, 0    ; 64-bit product, initialized to zero
hex_digits   db "0123456789ABCDEF$" ; Hexadecimal characters for conversion

.code
print macro msg
    push ax
    push dx
    lea dx, msg
    mov ah, 09h
    int 21h
    pop dx
    pop ax
endm
main proc
    mov ax, @data
    mov ds, ax
;   mov es, ax                 ; Set ES segment for accessing product data

    print msg1
    mov bx, offset [multiplicand+2]
    mov cx, 2
    call ReadHex32
    print msg2
    mov bx, offset [multiplier+2]
    mov cx, 2
    call ReadHex32

    mov   bx, [multiplicand+0]  ; multiply low words
    mov   ax, bx
    mul   word ptr [multiplier+0]
    mov   [product+0], ax
    mov   cx, dx

    mov   ax, [multiplicand+2]  ; multiply high words
    mov   bp, [multiplier+2]
    mul   bp
    mov   si, ax
    mov   di, dx

    mov   ax, bx                ; multiply middle 1    [multiplier+2]*[multiplicand+0]
    mul   bp
    add   cx, ax
    adc   si, dx
    adc   di, 0

    mov   ax, [multiplier+0]    ; multiply middle 2    [multiplier+0]*[multiplicand+2]
    mul   word ptr [multiplicand+2]
    add   cx, ax
    adc   si, dx
    adc   di, 0

    mov   [product+2], cx
    mov   [product+4], si
    mov   [product+6], di

    ; Display the product as hexadecimal
    mov bx, offset [product+6]     ; Point to the dnd of the product
    mov cx, 4                  ; Number of 16-bit words in product
    call PrintHex64            ; Call procedure to print 64-bit value in hex

    ; End of program
    mov ax, 4c00h              ; Exit to DOS
    int 21h
main endp

;Procedure to read 32 bit hexademical number
ReadHex32 proc
    ; Assumes BX points to the 64-bit value and CX has the word count
    ; Each word is printed in big-endian order as hexadecimal
    ReadNextWord:
        call ReadNum
        mov [bx], ax
        sub bx, 2               ; Move to next word
        loop ReadNextWord      ; Repeat for all words
    ret
ReadHex32 endp

;procedure to read a 16 bit hexadecimal number and store it in ax
ReadNum proc
    push bx
    push cx
    push dx

    mov cl,4
    xor bx, bx
    xor ax, ax
    input:
    mov ah,1
    int 21h
    cmp al, 0dh
    je exitLoop
    cmp al, 39h
    jg letterInput
    and al, 0fh
    jmp shift
    letterInput:
    sub al, 37h
    shift:
    shl bx, cl
    or bl, al
    jmp input
    exitLoop:
    mov ax,bx

    pop dx
    pop cx
    pop bx
    ret
ReadNum endp

; Procedure to print 64-bit value in hexadecimal
PrintHex64 proc
    ; Assumes BX points to the 64-bit value and CX has the word count
    ; Each word is printed in big-endian order as hexadecimal
    PrintNextWord:
        mov ax, [bx]            ; Load next word to AX
        call PrintHexWord       ; Print it in hexadecimal
        sub bx, 2               ; Move to next word
        loop PrintNextWord      ; Repeat for all words
    ret
PrintHex64 endp

; Procedure to print a 16-bit word in hexadecimal
PrintHexWord proc
    push ax                    ; Preserve AX
    push bx                    ; Preserve BX
    push cx
    push dx
    push si

    mov bx, ax                 ; Copy AX to BX for division
    mov cx, 4                  ; We have 4 hex digits per word

    PrintNextHexDigit:
        rol bx, 1              ; Rotate left 4 bits (1 hex digit at a time)
        rol bx, 1 
        rol bx, 1 
        rol bx, 1 
        mov dl, bl             ; Isolate lower nibble
        and dl, 0Fh            ; Mask out high nibble
        mov dh,0
        mov si,dx
        mov ah, hex_digits[si] ; Get ASCII character for hex digit
        mov dl, ah
        mov ah, 02h            ; Function 2 - display character
        int 21h                ; Display the hex digit
        dec cx
        jnz PrintNextHexDigit
    pop si
    pop dx
    pop cx
    pop bx                     ; Restore BX
    pop ax                     ; Restore AX
    ret
PrintHexWord endp

end main
