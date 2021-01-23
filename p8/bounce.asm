; Daniel Mitchell
; P8 - Bounce
; 02/11/20
; Seems like it might be hard by virtue of 'never done this before' but doable
%macro Print 2
pusha
mov	eax, 4
mov	ebx, 1
mov	ecx, %1
mov	edx, %2
int 	80h
popa
%endmacro

%macro setCursor 2	;;takes row and col (in that order) as values and passes to _cursor
mov	ah, %1
mov	al, %2
call _cursor
%endmacro


SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
message:	db " "	;makes a space
		db "This Is My Message, it's a little boring but I like it"
		db " " 	;makes another space
msglen:	EQU	($-message)
offset: EQU	(79 - msglen)

sec	dd	0, 850

clr	db	1bh,'[2J'


pos	db	1bh, '['
row	db	'00'
	db	';'
col	db	'00'
	db	'H'

currCol	db	0
SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:
call	_clrscr
;;clears the screen on start
mov	cl, 0

; put your code here.
toploop:

mov	ecx, offset
forwardPrint:
inc		BYTE [currCol]
setCursor	10, [currCol]
Print		message, msglen
call		_Sleep
call		_clrscr

b1:

loop forwardPrint

mov	ecx, offset
revP:
dec		BYTE [currCol]
setCursor	10,[currCol]
Print		message, msglen
call		_Sleep
call		_clrscr
b2:
loop revP

b3:
jmp 	toploop



; Normal termination code
mov eax, 1
mov ebx, 0
int 80h


_Sleep:		;sleeps for about half a sec
pusha
mov	eax, 162
mov	ebx, sec
mov	ecx, 0
int	80h
popa
ret


_cursor:	;;needs row in ah and col in al
pusha

;save orig eax
push 	eax

;process row
shr 	ax, 8
mov	bl, 10
div	bl
bbreak1:
add	ah,'0'
add	al,'0'
bbreak2:
mov	BYTE [row], al
mov	BYTE [row+1], ah

;process col
pop	eax	;;restore original parameter
and	ax, 0FFh
mov	bl, 10
div	bl
add	ah, '0'
add	al, '0'
mov	BYTE [col], al
mov	BYTE [col+1], ah

;print set cursor codes
mov	eax, 4
mov	ebx, 1
mov	ecx, pos
mov	edx, 8
int	80h

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
