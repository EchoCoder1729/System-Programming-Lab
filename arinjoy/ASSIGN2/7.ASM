.MODEL SMALL
.STACK 100H
.DATA
	MESS1 DB 10,13, "Enter string : $"
	MESS2 DB 10,13, "Enter substring to be deleted : $"
	MESS3 DB 10,13, "The string after deletion : $"
	MESS4 DB 10,13, "Substring is not contained in string.$"
	STRING DB 50 DUP(?)
	SUBSTRING DB 50 DUP(?)
	NUM DW ?
	LEN1 DB ?
	LEN2 DB ?
	STARTINDEX DW ?
	ENDINDEX DW ?
.CODE
	main proc
	MOV AX, @DATA
	MOV DS, AX

	LEA DX, MESS1
	MOV AH, 09H
	INT 21H
	; Input the String
	MOV SI, 0
	MOV CX, 0
	MOV AH, 01H
	IN1: INT 21H
		CMP AL, 0DH
		JE OUT1
		MOV STRING[SI], AL
		INC SI
		INC CX
	JMP IN1

	OUT1:
	MOV LEN1, CL
	LEA DX, MESS2
        MOV AH, 09H
        INT 21H
	; Input the substring
        MOV SI, 0
		MOV CX, 0
        MOV AH, 01H
        IN2: INT 21H
                CMP AL, 0DH
                JE OUT2
                MOV SUBSTRING[SI], AL
                INC SI
		INC CX
        JMP IN2

	OUT2:
	MOV LEN2, CL

	MOV DH, 0
	MOV DL, LEN1
	SUB DL, LEN2
	ADD DL, 1
	; dx = len1 - len 2 + 1

	MOV CH, 0
	MOV CL, LEN2
	; cx = len2

	MOV SI, 0
	; Outer loop comparing the first letter of substring with the letters of string
	EQUL: MOV STARTINDEX, SI
		MOV AL, STRING[SI]
		MOV BL, SUBSTRING[0]
		CMP AL, BL
		JNE NEXXTT
		; If first letter doesn't match check with next letter in string
		; Inner Loop to see if entire substring matches with part of string
		; SI getting changes in inner loop, backed up at STARTINDEX
		MOV DI, 0
		EQULN:
			MOV AL, STRING[SI]
			MOV BL, SUBSTRING[DI]
			CMP AL, BL
			JNE NEXT
			ADD SI, 1
			ADD DI, 1
			LOOP EQULN
		NEXT: CMP CX, 0
			JBE FIND

			MOV SI, STARTINDEX
		NEXXTT:	INC SI
			MOV CH, 0
			MOV CL, LEN2
			DEC DX
	JNZ EQUL

	JMP NOTFIND
	; executed when exact match is found, deletion operation
	FIND: MOV CL, LEN1
		MOV BH, LEN2
		CMP CL, BH
		JB NOTFIND
		; edge case when string length is less than substring length
   		LEA DX, MESS3
		MOV AH, 09H
		INT 21H

		SUB SI, 1
		MOV ENDINDEX, SI				;ENDINDEX WILL BE SI+LENGTH OF SUBSTRING

		MOV CH, 0
		MOV CL, LEN1

		MOV DI, 0
		MOV AH, 02H
		; printing only those characters whose index < STARTINDEX and > ENDINDEX
		; Loop runs for the length of string 1
		PRINT: CMP DI, STARTINDEX
			JB PRINTC
			CMP DI, ENDINDEX
			JA  PRINTC
			JMP NEXTT
			PRINTC:MOV DL, STRING[DI]
				INT 21H
			NEXTT: ADD DI, 1
		LOOP PRINT

	JMP EXITT

	NOTFIND: LEA DX, MESS4
		MOV AH, 09H
		INT 21H

	EXITT: MOV AH, 4CH
		INT 21H

main endp
END MAIN
