.model small                            ;defines the memory model to be used for the ALP
.data                                   ;data segment begins here
        ms db "Display Your Name by Arinjoy Pramanik$"   ;String Hello World gets stored in msg

.code                                   ;code segment begins here
        mov ax,@data                    ;moving base address of data to ax
        mov ds,ax                       ;moving contents of ax into ds
                                        ;data section now gets initialized
        mov dx, OFFSET ms                      ;load the offset address of msg
        mov ah,09h                      ;to display contents at dx
        int 21h                         ;call the kernel

        mov ah,4ch                      ;to terminate the program
        int 21h                         ;call the kernel
end
