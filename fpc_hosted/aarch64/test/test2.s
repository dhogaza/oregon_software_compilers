#
#	p
#
	.text
	.align 2
.P1:
	sub	sp,sp,48
	stp	x30,x29,[sp]
	add	x29,sp,0
# Line: 7, Stmt: 1
# Line: 8, Stmt: 2
	lsl	w15,w1,4
	add	x15,x0,x15, sxtw 0
	mov	x14,3
	str	w14,[x15, w2, sxtw 2]
.L2:
	ldp	x30,x29,[sp]
	add	sp,sp,48
	ret
	.bss
	.align 3
.L0:
	.space 80
#
#	main (main)
#
	.text
	.align 2
	.global main
main:
	sub	sp,sp,32
	stp	x30,x29,[sp, 8]
	add	x29,sp,8
	str	x28,[x29, -8]
	adrp	x28,.L0
	add	x28,x28,:lo12:.L0
# Line: 11, Stmt: 1
.L3:
	ldr	x28,[x29, -8]
	ldp	x30,x29,[sp, 8]
	add	sp,sp,32
	ret
