; Daniel Mitchell
; P9 - Sort
; November 4, 2020
; CSC 245 def helped with this
%macro	print	2
	pusha
 	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, %2
	int 80h
	popa
%endmacro

%macro printArray 1	;takes array len as input
pusha	 
mov	ecx, %1	
mov	edx, 0
call	_printArray
popa
%endmacro

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
output:	db	"  ", 10
nums:	db	21, 33, 5, 1, 7, 42, 55
numslen: EQU $-nums
ten:	db	10
hundred:db	100

clr	db	1bh,'[2J'

ogHeader: db	"Original Array", 10
oglen:	EQU $-ogHeader

sortedHeader: db	"Sorted Array", 10
sortedlen: EQU $-sortedHeader

SECTION .bss
; define uninitialized data here
key	resb 	1


SECTION .text
global _main
_main:
call	_clrscr
; put your code here.
print	ogHeader, oglen

printArray	numslen
call	_sortEm

print 	sortedHeader, sortedlen
printArray	numslen

lastBreak:
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h

_printArray:
top:
	mov al, [nums+edx]
	call	_convert
	print	output, 4
	inc edx
loop top


ret

_convert:	;al should have byte number
pusha
mov	ebx, output	
xor	ah, ah		;clears ax so al has the number passed in
div	BYTE [ten]
add	al, '0'
mov	[ebx], al
add	ah, '0'
inc	ebx
mov	[ebx], ah

popa 
ret

_sortEm:	;implements a bubble sort on the array
pusha
mov	cx, numslen	;can't store ecx inside bx, but loop operator still counts it
dec	cx

nextCheck:
mov	bx, cx
mov	esi, 0

nextCompare:
mov	al, [nums+esi]
mov	dl, [nums+esi+1]
cmp	al, dl

jc	noswap

mov	[nums+esi], dl
mov	[nums+esi+1], al

noswap:
inc	esi
dec	bx
jnz	nextCompare

loop	nextCheck

popa
ret

_clrscr:
pusha
mov	eax, 4
mov	ebx, 1
mov	ecx, clr
mov	edx, 4
int	80h
popa
ret

