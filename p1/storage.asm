; Daniel Mitchell
; Program 1: Data Storage
; September 9, 2020
; Etc...

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ

a1:      db      11
b1:      dw      11b
c1:      dd      11h
d1:      dq      11q
e1:      dw      -5
f1:      db      'CSC322'
g1:      db      'Howdy'
a2:	db 	5
b2:	db	4
c2:	db 	3
d2:	db 	2
a3:	db 	1
b3:	dw	1
c3:	dw	2
d3:	dw 	3
e3:	dw	4
f3:	dw	5
g3:	dd	10
h3:	dd	11
i3:	dd	12
j3:	dd	13
k3:	dq	10h
l3:	dq	11h
m3:	dq	12h
n3:	dq	13h
o3:	db	-5	
p3:	dw	-10
q3: 	db	-15
r3:	dw	-20
s3:	db	-25
a4:	db	'Mercer'
b4:	db	10
c4:	db	0
d4:	db	'Go '
e4:	db	'Bears!'
a5:	dw	100
b5:	dd	100h
c5:	db	100b
d5:	dw	100q
e5:	dd	100d

SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:

; put your code here.



; Normal termination code
mov eax, 1
mov ebx, 0
int 80h

