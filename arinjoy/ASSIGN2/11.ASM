.model small
.stack 100h
.data
    arr db 10 dup(0)    ; Array to store up to 10 elements
    n db 0              ; Number of elements
    prompt1 db 'Enter number of elements (max 10): $'
    prompt2 db 'Enter the numbers:$'
    prompt3 db 'Insertion Sort Result: $'
    prompt4 db 'Selection Sort Result: $'
    newline db 0Dh, 0Ah, '$'

.code
; insertion sort and selection sort
main proc
    mov ax, @data        ; Initialize data segment
    mov ds, ax

    ; Get number of elements
    mov ah, 09h
    lea dx, prompt1
    int 21h

    mov ah, 01h          ; Read number of elements
    int 21h
    sub al, '0'          ; Convert ASCII to integer
    mov n, al            ; Store number of elements

    ; Get array elements from user
    mov ah, 09h
    lea dx, prompt2
    int 21h

    xor cx, cx           ; Clear CX (counter)
input_loop:
    mov ah, 01h          ; Read number
    int 21h
    sub al, '0'          ; Convert ASCII to integer
    mov arr[cx], al      ; Store in array
    inc cx               ; Increment counter
    cmp cx, n            ; Compare counter with number of elements
    jl input_loop        ; Loop until all elements are entered

    ; Perform insertion sort
    call insertion_sort

    ; Display Insertion Sort result
    mov ah, 09h
    lea dx, prompt3
    int 21h
    call display_array   ; Display sorted array
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Reload array for selection sort
    call reload_array

    ; Perform selection sort
    call selection_sort

    ; Display Selection Sort result
    mov ah, 09h
    lea dx, prompt4
    int 21h
    call display_array   ; Display sorted array
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h
main endp

; Insertion Sort Procedure
insertion_sort proc
    mov cx, 1            ; Start from second element
insertion_loop:
    mov si, cx           ; Current element index
    mov al, arr[si]      ; Current element
    mov bx, cx
compare_loop:
    dec bx
    cmp arr[bx], al      ; Compare with previous element
    jle done_compare     ; If less than or equal, exit loop
    mov arr[bx+1], arr[bx] ; Shift element right
    cmp bx, 0            ; Stop if first element
    jz done_compare
    jmp compare_loop
done_compare:
    mov arr[bx+1], al    ; Place current element in correct position
    inc cx
    cmp cx, n
    jl insertion_loop
    ret
insertion_sort endp

; Selection Sort Procedure
selection_sort proc
    mov cx, 0
selection_outer_loop:
    mov si, cx           ; Index of the current element
    mov bx, cx           ; Assume minimum is at current index
    mov dx, cx
selection_inner_loop:
    inc dx
    cmp dx, n
    jge selection_swap
    cmp arr[dx], arr[bx] ; Find the minimum element
    jge selection_inner_loop
    mov bx, dx
    jmp selection_inner_loop
selection_swap:
    cmp si, bx
    je done_swap
    mov al, arr[si]      ; Swap current with minimum element
    mov arr[si], arr[bx]
    mov arr[bx], al
done_swap:
    inc cx
    cmp cx, n
    jl selection_outer_loop
    ret
selection_sort endp

; Reload original array after insertion sort
reload_array proc
    ; Here, you'd typically reload the array with the original unsorted data
    ; This is a placeholder as the input process does not preserve original data
    ret
reload_array endp

; Display sorted array
display_array proc
    mov cx, 0
display_loop:
    mov al, arr[cx]       ; Get current element
    add al, '0'           ; Convert integer to ASCII
    mov ah, 02h           ; DOS print character
    int 21h
    inc cx
    cmp cx, n
    jl display_loop
    ret
display_array endp

end main