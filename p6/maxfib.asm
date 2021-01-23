; DANIEL MITCHELL
; MAX DWORD FIB - P6
; OCTOBER 13, 2020
; USES LOOP TO FIND MAX FIB DWORD

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ

SECTION .bss
; define uninitialized data here
MaxFib:		RESD 1

SECTION .text
global _main
_main:
; put your code here.
	mov	eax, 0
	mov	edx, 1

top:				;;loop until carry flag is set
	add	edx, eax
jc fin
	mov	eax, ebx	;;store the result in ebx if no carry	
	mov	ebx, edx

jnc top

fin:
	mov	[MaxFib], eax

lastBreak:
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
