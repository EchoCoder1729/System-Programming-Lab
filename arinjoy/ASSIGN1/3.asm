.model small
.stack 100h
.data 
    iprompt db 13,10,"Enter all hexadecimal numbers in uppercase only$"
    prompt1 db 13,10,"enter the 1st number: $"
    prompt2 db 13,10,"enter the 2nd number: $"
    prompt3 db 13,10,"the result of the addition is: $"
    hex_digits   db "0123456789ABCDEF$"

.code
    print macro message
        push ax
        push dx
        lea dx, message
        mov ah,09h
        int 21h
        pop dx
        pop ax
    endm
   main proc
          mov ax,@data                                ;for moving data to data segment
          mov ds,ax
          xor bx,bx                                   ;initially bx value is equal to 0

          print iprompt                               ;showing instruction prompt

          print prompt1
          call ReadNum                                ;Reading the first hex number
          mov bx, ax
      line1:
          print prompt2                               ;show num2 prompt

          call ReadNum                                ;Reading the second hex number
          mov cx, ax
      sum:
          add bx,cx                                 ;add two number which are stored in bx and cx register
          mov dx, 0
          jc pc1                                    ;if the register is overflowed then print an extra 1
      output:                                       ;label for printing their sum
          mov cl, 4
          print prompt3                             ;show answer prompt
          mov ax, dx
          call PrintHex
          mov ax, bx
          call PrintHex
          jmp exit
      pc1:                                          ;level for printing overflowed 1
          mov dx, 1
          jmp output
      exit:
          mov ah, 4ch                               ;return control to dos
          int 21h
    main endp

;procedure to read a hexadecimal number and store it in ax
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

;Procedure to print a hexadecimal number stored in ax
PrintHex proc
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx,ax
    mov cx,4
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
PrintHex endp
   end main