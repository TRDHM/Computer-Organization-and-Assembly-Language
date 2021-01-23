; Daniel Mitchell
; p5 - Matrix Management
; October 4, 2020
; Looping through matrix and such


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Test Case 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ROWS:	EQU	5	; constant of rows equal to 5
COLS:	EQU	7	; constant of rows equal to 7

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
MyMatrix:	dd 1, 2, 3, 4, 5, 6, 7
		dd 8, 9, 10, 11, 12, 13, 14
		dd 15, 16, 17, 18, 19, 20, 21
		dd 22, 23, 24, 25, 26, 27, 28
		dd 29, 30, 31, 32, 33, 34, 35

SECTION .bss
; define uninitialized data here
RowSums:	RESD ROWS
ColSums:	RESD COLS
Sum:		RESD 1
saveECX:	RESD 1
index:		RESD 1


SECTION .text
global _main
_main:

mov [RowSums], DWORD 0
mov ebx, RowSums
mov edx, MyMatrix
mov ecx, ROWS

RowSum:		;;sum up row values
	mov [saveECX], ecx
	mov ecx, COLS
	xor eax, eax

	innerRowSum:
		add eax, [edx]
		add edx, 4
		loop innerRowSum

	mov [ebx], eax
	add [Sum], eax
	add ebx, 4
	mov ecx, [saveECX]
	loop RowSum


xor 	ebx, ebx
xor	edx, edx
xor 	ecx, ecx


mov [index], DWORD 0	;;just to be safe 0 out registers before resetting the edx pointer and putting ColSums in ebx
mov [ColSums], DWORD 0

mov edx, MyMatrix
mov ecx, ROWS

ColSum:
	mov [saveECX], ecx
	mov ecx, COLS
	mov ebx, ColSums
	xor eax, eax

	innerColSum:
		add eax, [edx]
		add [ebx], eax
		add edx, 4	
		add ebx, 4

		loop innerColSum

	mov [ebx], eax
	sub ebx, ColSums ;reset index to column pointer after every full column
	mov ecx, [saveECX]
	
loop ColSum

lastBreak: 

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
