.model small
.data
array db 5, 3, 8, 1, 4    ; Example array to be sorted
size dw 5                 ; Number of elements in the array

.code
main proc
mov ax, @data
mov ds, ax

mov cx, size
mov bx,0
printArray:
    mov al, [array + bx]
    mov ah, 2
    int 21H
    inc bx
loop printArray

mov si,0
mov cx, size

selection_sort:
    cmp si, cx            ; If SI >= CX, all elements are sorted
    jge end_sort          ; Exit if we've reached the end

    mov di, si            ; Set DI to the current position of SI (starting position of unsorted part)
    mov bx, si            ; BX will store the index of the minimum element found

find_min:
    inc di                ; Increment DI to search for the minimum in the remaining elements
    cmp di, size          ; Check if we have reached the end of the array
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

    mov cx, size
    mov bx,0
    printArray:
        mov al, [array + bx]
        mov ah, 2
        int 21H
        inc bx
    loop printArray

main endp
end main