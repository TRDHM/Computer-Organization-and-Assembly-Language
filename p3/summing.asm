; Daniel Mitchell
; p3
; September 23, 2020
; Sum arrays

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
bArray:		DB		-1,2,-3,4,-5,6
wArray:		DW		09h,0ah,0bh,0ch,0dh
dArray:		DD		-10,-20,-30,-40,-50
bArraySum:	DB		0
wArraySum:	DW		0
dArraySum:	DD		0
grandTotal:	DD		0


SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:

mov 	al,  [bArray]
mov 	bx,  [wArray]
mov 	ecx, [dArray]
mov	bl,  [bArraySum]
mov	ax,  [wArraySum]
mov	eax, [dArraySum]
mov	ebx, [grandTotal]


break1:

add	bl, [bArray]
add	bl, [bArray+1]
add	bl, [bArray+2]
add	bl, [bArray+3]
add	bl, [bArray+4]
add	bl, [bArray+5]

add	ax, [wArray]
add	ax, [wArray+1]
add	ax, [wArray+2]
add	ax, [wArray+3]
add	ax, [wArray+4]

add	eax, [dArray]
add	eax, [dArray+1]
add	eax, [dArray+2]
add	eax, [dArray+3]
add	eax, [dArray+4]


break2:

mov 	bl,al
mov 	ax,bx
mov 	eax,ecx

;clear registers used to add
xor	ecx,ecx


add	ebx,eax


movsx	ecx,bl
add	ebx,ecx

xor 	ecx,ecx

movsx	ecx,ax
add	ebx,ecx



lastBreak:
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
