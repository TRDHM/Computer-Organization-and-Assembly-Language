; Daniel Mitchell
; p4
; October 2, 2020
; First 16 Fibonnaci numbers

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ

SECTION .bss
; define uninitialized data here
Fibs:	RESD 16


SECTION .text
global _main
_main:

; put your code here.
mov 	[Fibs],	dword 0
mov 	[Fibs+4], dword 1

mov 	ebx, Fibs
mov	ecx, 14

top:
	mov	edx, DWORD[ebx]
	add	edx, DWORD[ebx+4]
	inc	ebx
	mov	[ebx+4], edx
	xor 	edx, edx

	loop top

done:

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
