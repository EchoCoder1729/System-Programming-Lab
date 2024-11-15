.model small
.stack 100h
.data
array dw 50 dup(0)
sz dw ?
msg1 db 13,10,"Enter size of array: $"
msg2 db 13,10,"Enter array element: $"
msg3 db 13,10,"The second largest element is: $"
msg4 db 13,10,"The second smallest element is: $"
msg5 db 13,10,"$"
msg6 db "Element: $"
max dw ?
min dw ?
s_min dw ?
s_max dw ?
.code

print_msg macro msg
    push ax
    push bx
    push cx
    push dx
    mov ah, 09h
    lea dx, msg
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
endm

main proc

; Code starts here

mov ax, @data
mov ds, ax

mov si, OFFSET array
print_msg msg1
call readnum
mov sz, ax

mov cx, sz

; looping to store elements of the array
loop_label_1:
print_msg msg2
call readnum
mov [si], ax
dec cx
add si,2
cmp cx,0
jne loop_label_1

mov cx, sz
mov si, OFFSET array
; looping to display elements of the array
loop_label_2:
mov ax, [si]
print_msg msg6
call writenum
print_msg msg5
dec cx
add si,2
cmp cx,0
jne loop_label_2

; Logic to find the min and max element of the array
mov cx, sz
mov si, OFFSET array
mov bx, [si]
dec cx
mov max,bx
mov min,bx
mov s_max,bx
mov s_min,bx
cmp cx,0
je singleton_array
add si,2
loop_label_3:
mov bx,[si]
;updating max of array
cmp bx, max
jle max_not_updated
mov max,bx
max_not_updated:
cmp bx,min
jge min_not_updated
mov min,bx
min_not_updated:
add si,2
dec cx
cmp cx,0
jne loop_label_3

; Logic to find the second max and second min of the array
mov s_min, 9999
mov s_max, 0000
mov cx, sz
mov si, OFFSET array
loop_label_4:
mov bx, [si]
cmp bx, min
jle smin_not_updated
cmp bx, s_min
jge smin_not_updated
mov s_min,bx
smin_not_updated:
cmp bx, max
jge smax_not_updated
cmp bx, s_max
jle smax_not_updated
mov s_max,bx
smax_not_updated:
add si,2
dec cx
cmp cx,0
jne loop_label_4

singleton_array:
;Printing the second maximum element
print_msg msg3
mov ax, s_max
call writenum
;Printing the second minimum element
print_msg msg4
mov ax, s_min
call writenum

; Ending the program
mov ah, 4ch
int 21h

readnum proc near
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

writenum proc near
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
main endp
end main
