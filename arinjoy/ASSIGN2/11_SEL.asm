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

selection_sort:
    cmp si, cx            ; If SI >= CX, all elements are sorted
    jge end_sort          ; Exit if we've reached the end

    mov di, si            ; Set DI to the current position of SI (starting position of unsorted part)
    mov bx, si            ; BX will store the index of the minimum element found

find_min:
    inc di                ; Increment DI to search for the minimum in the remaining elements
    cmp di, len          ; Check if we have reached the end of the array
    jge swap_elements     ; If yes, go to the swapping section

    mov al, [array + bx]  ; Load the current minimum element
    cmp al, [array + di]  ; Compare with the next element in the unsorted part
    jbe find_min          ; If the current minimum <= [array + di], continue finding

    mov bx, di            ; Update BX to the new index of the minimum element
    jmp find_min          ; Repeat the loop to find the minimum

swap_elements:
    cmp bx, si            ; If the minimum element is already in place, skip the swap
    je skip_swap

    ; Swap [array + si] and [array + bx]
    mov al, [array + si]  ; Load the element at SI into AL
    mov dl, [array + bx]  ; Load the element at BX into DL
    mov [array + si], dl  ; Move the minimum element to the current position
    mov [array + bx], al  ; Move the previous element to the position of the minimum

skip_swap:
    inc si                ; Move to the next element in the outer loop
    jmp selection_sort    ; Repeat the selection sort

end_sort:
    ; The array is now sorted; you can exit the program or proceed with the sorted data
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