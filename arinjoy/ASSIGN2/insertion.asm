.model small
.data
array db 5, 3, 8, 1, 4  ; Example array with elements to sort
size db 5               ; Number of elements in the array

.code
main proc
mov ax, @data
mov ds, ax

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

main endp
end main