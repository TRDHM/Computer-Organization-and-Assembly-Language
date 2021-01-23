; NAME:  Daniel Mitchell
; Assignment: Wanderer
; Date: Nov 10, 2020
; Current issues to fix: itoa pushes 4 bytes instead of 2 so need to cut them off before inserting, causes row num to print besides G and nothing else, wrapping works but the extra row/col being printed out overwrites the * sometimes

%macro setCursor 2	;%1 = row, %2 = col, sets cursor using the _cursor proc
mov	ah, %1
mov	al, %2
call	_cursor
%endmacro

%macro callitoa 2	;ax = num, ebx = output 
	pusha
	mov ax, %1
	mov ebx, %2
	call _itoa
popa
%endmacro	


%macro Print 2
pusha
mov	eax, 4
mov	ebx, 1
mov	ecx, %1
mov	edx, %2
int	80h
popa
%endmacro

%macro printBoundary 0	;prints the boundaries
mov	BYTE [currRow], 1
mov	BYTE [currCol], 1
first:			;prints top wall
cmp	BYTE [currCol], 41
je	next
setCursor	[currRow], [currCol]
Print		star, starlen
inc		BYTE [currCol]
jmp		first

next:			;prints left vertical wall
mov	BYTE [currRow], 1
mov	BYTE [currCol], 1
two:
cmp	BYTE [currRow], 21
je	nextSecond
setCursor	[currRow], [currCol]
Print		star, starlen
inc		BYTE [currRow]
jmp		two

nextSecond:		;prints bottom row
mov	BYTE [currRow], 20
mov	BYTE [currCol], 1
third:
cmp	BYTE [currCol], 41
je	finalSecond
setCursor	[currRow], [currCol]
Print		star, starlen
inc		BYTE [currCol]
jmp		third

finalSecond:		;prints right vertical wall
mov	BYTE [currRow], 1
mov	BYTE [currCol], 40
fourth:
cmp	BYTE [currRow], 21
je	endBoundary
setCursor	[currRow], [currCol]
Print		star, starlen
inc		BYTE [currRow]
jmp		fourth


endBoundary:
%endmacro

LEN:	EQU 21

; Constant for Size of array of structs
; Define Structure for character on screen
STRUC mStruct
		RESB 2  ; space for <esc>[
	.row:	RESB 2  ; two digit number (characters)
		RESB 1  ; space for ;
	.col:	RESB 2  ; two digit number (characters)
		RESB 1  ; space for the H
	.char:	RESB 1  ; space for THE character
	.size:
ENDSTRUC

SECTION .data
; clear screen string
clr		db 1bh,'[2J'
star		db '*', 0
starlen:	EQU	($-star)

pos	db	1bh, '['
row	db	'00'
	db	';'
col	db	'00'
	db	'H'

currCol db	'00'
currRow	db	'00'
nextCol dw	16
nextRow dw 	15	

ten:	db	10
hundred: db	100


sec	dd	0, 850

; Create an array of structs: formatted like the print interrupt uses.
message:
		
		db 1bh,'[15;16HG'
		db 1bh,'[15;17Ho'
		db 1bh,'[15;18H '
		db 1bh,'[15;19HB'
		db 1bh,'[15;20He'
		db 1bh,'[15;21Ha'
		db 1bh,'[15;22Hr'
		db 1bh,'[15;23Hs'
		db 1bh,'[15;24H!'
		db 1bh,'[15;25H '
		db 1bh,'[15;26HW'
		db 1bh,'[15;27Hi'
		db 1bh,'[15;28Hn'
		db 1bh,'[15;29H '
		db 1bh,'[15;30HI'
		db 1bh,'[15;31Ht'
		db 1bh,'[15;32H '
		db 1bh,'[15;33HA'
		db 1bh,'[15;34Hl'
		db 1bh,'[15;35Hl'
		db 1bh,'[15;36H '

SECTION .bss
twodigits: RESW	1

SECTION .text
global _main
_main:
; clear the screen
call	_clrscr
; Demonstrate an infinite loop calling  functions which uses an array of structs

printBoundary
mainLoop:
  loopBreak:
 	call	_displayMessage	
	call	_pause
	rdtsc
	call	_randNum
	call	_adjustMessage
	jmp	mainLoop

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
;;;;;;;;;;;;;;;;;;;;; END OF MAIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_randNum:	;;takes number from rdtsc and performs the wraparound
pusha
cmp al, 0	;if al < 0, -1 from Row, +1 if not, then jump to checkCol
jl rowMinus
inc	WORD [nextRow]
jmp	checkCol

rowMinus:
dec	WORD [nextRow]

checkCol:	;if ah < 0, -1 from Col, otherwise +1
cmp ah, 0
jl	 colMinus
inc	WORD [nextCol]
jmp	colWrapCheck

colMinus:
dec	WORD [nextCol]

colWrapCheck:	;checks NextCol and handles wrapping
cmp	WORD [nextCol], 40
jge	makeTwo
cmp	WORD [nextCol], 1
jle	makeThreeNine
jmp	rowWrapCheck

makeTwo:	;sets nextCol to 2
mov	WORD [nextCol], 2
jmp 	rowWrapCheck

makeThreeNine:	;sets nextCol to 39
mov	WORD [nextCol], 39

rowWrapCheck:	;checks nextRow and handles wrapping if needed
cmp	WORD [nextRow], 1
jle	makeNineOne
cmp	WORD [nextRow], 20
jge	makeTwoToo
jmp	end

makeTwoToo:
mov	WORD [nextRow], 2
jmp	end

makeNineOne:
mov	WORD [nextRow], 19

end:
popa
ret

;;;;;;;;;;;;  Function that rotates the characters through the array of structs 
_adjustMessage:	
	pusha
	;push	eax   ; save for bottom
	mov	ebx,message + mStruct.size*20  ;; pointer into array, starting at bottom
	mov	ecx,LEN    ;; loop 

_amTop: 
	mov	dx,[ebx - mStruct.size + mStruct.col]
	mov	WORD [ebx + mStruct.col], dx
	mov	dx,[ebx - mStruct.size + mStruct.row]
	mov	WORD [ebx + mStruct.row], dx		

	sub	ebx, mStruct.size
	loop	_amTop
	sub	ebx, mStruct.size

	callitoa	[nextRow], twodigits
	mov		ax, [twodigits]
	mov		[message + mStruct.row], ax

	callitoa	[nextCol], twodigits
	mov		ax, [twodigits]
	mov		[message + mStruct.col], ax
	popa
	ret


;;;;;;;;;;;   Function to print the array of structs of message
_displayMessage:
	pusha
	mov	ebx,message + mStruct.size*20  ;ebx = pointer to first index 
	mov	ecx,LEN

_dmTop:	push	ecx
	push	ebx
	mov	eax,4  ; system print
	mov	ecx,ebx ; points to string to print
break1:
	mov	ebx,1   ; standard out
	mov	edx,9   ; num chars to print
	int	80h

	pop	ebx
	sub	ebx,mStruct.size		;go up one index
	pop	ecx
	
	loop	_dmTop
	popa
	ret


;;;;;;;;;;;;;  Function to sleep 1/20 second ;;;;;;;;;;;;;;;;;;;;;
_pause: 
	pusha
	mov	eax,162
	mov	ebx,seconds
	mov	ecx,0
	int	80h
	popa
	ret

;;;;;;;;;;;;	Tricky use of ram.... put some data here for _pause to use
seconds: dd	0,50000000  ;;;  seconds, nanoseconds

_clrscr:
pusha
mov	eax, 4
mov	ebx, 1
mov	ecx, clr
mov	edx, 4
int	80h
popa
ret

_convert:	;al should have byte number
pusha
mov	ebx, twodigits
xor	ah, ah
div	BYTE [ten]
add	al, '0'
mov	[ebx], al
add	ah, '0'
inc	ebx
mov	[ebx], ah

popa
ret

_cursor:
pusha

push eax

shr 	ax, 8
mov 	bl, 10
div	bl
add	ah, '0'
add	al, '0'
mov	BYTE [row], al
mov	BYTE [row+1], ah

pop 	eax
and	ax, 0FFh
mov	bl, 10
div	bl
add	ah, '0'
add	al, '0'
mov	BYTE [col], al
mov	BYTE [col+1], ah

mov	eax, 4
mov 	ebx, 1
mov	ecx, pos
mov	edx, 8
int	80h
popa
ret

_itoa:
pusha
convb1:
mov	cl, 10
div	cl

add	ah, '0'
add	al, '0'

mov	[twodigits], ax
convb2:
popa
ret

