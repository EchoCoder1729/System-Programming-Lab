.model small
.stack 100h
.data
array db 50 dup(0)
len dw 5                 ; Number of elements in the array
space db 13,10,"$"
gap db " $"
msg1 db 13,10,"Enter size of the array: $"
msg2 db 13,10,"Enter element: $"
.code
print macro msg
    push ax
    push dx
    lea dx, msg
    mov ah, 09H
    int 21H
    pop dx
    pop ax
endm
main proc
mov ax, @data
mov ds, ax

; Reading the length of the array from the user
print msg1
call readnum
mov len, ax

; Reading the array from the user
mov si,0
mov cx,len
readArray:
    print msg2
    call readnum
    mov array[si], al
    inc si
loop readArray

xor dx, dx
mov cx, len
mov si, 0
printArray1:
    mov dl, array[si]
    add dl, '0'
    mov ah, 2
    int 21H
    inc si
    print gap
loop printArray1
print space
mov si,0
mov cx, len

insertion_sort:
    cmp si, cx          ; Check if we have sorted all elements
    jge end_sort        ; If SI >= CX, we're done

    mov di, si          ; DI will be used as the inner loop index
    mov al, [array + si]; Store the current element in AL

inner_loop:
    cmp di, 0           ; Check if DI is at the beginning
    jle insert_element  ; If DI <= 0, we're at the beginning, insert element

    mov bl, [array + di - 1] ; Load the previous element in BL
    cmp bl, al          ; Compare previous element with current element
    jle insert_element  ; If the previous element <= current element, insert

    ; Shift element to the right
    mov [array + di], bl ; Shift previous element to the right
    dec di               ; Move left in the array
    jmp inner_loop       ; Repeat the inner loop

insert_element:
    mov [array + di], al ; Insert current element in its position

    inc si               ; Move to the next element
    jmp insertion_sort   ; Repeat the outer loop

end_sort:
    ; Exit program or continue with sorted array

xor dx, dx
mov cx, len
mov si, 0
printArray2:
    mov dl, array[si]
    add dl, '0'
    mov ah, 2
    int 21H
    inc si
    print gap
loop printArray2
print space
mov ah, 4CH
int 21h

main endp

readnum proc
	; this procedure will take a number as input from user and store in AX
	; input : none
	
	; output : AX

	
	push bx
	push cx
	mov cx,0ah
	mov bx,00h
	loopnum: 
		mov ah,01h
		int 21h
		cmp al,'0'
		jb skip
		cmp al,'9'
		ja skip
		sub al,'0'
		push ax
		mov ax,bx
		mul cx
		mov bx,ax
		pop ax
		mov ah,00h
		add bx,ax
	jmp loopnum
	
	skip:
	mov ax,bx
	pop cx
	pop bx
	ret
readnum endp

writenum proc
	; this procedure will display a decimal number
	; input : AX
	; output : none

	push bx                        
	push cx                        
	push dx                        

	xor cx, cx
	mov bx, 0ah                     

	@output:                       
		xor dx, dx                   
		div bx                       ; divide AX by BX
		push dx                      ; push remainder onto the STACK
		inc cx                       
		or ax, ax                    
	jne @output                    

	mov ah, 02h                      ; set output function

	@display:                      
		pop dx                       ; pop a value(remainder) from STACK to DX
		or dl, 30h                   ; convert decimal to ascii code
		int 21h                      
	loop @display                  

	pop dx                         
	pop cx                         
	pop bx                         

	ret                            
writenum endp
end main