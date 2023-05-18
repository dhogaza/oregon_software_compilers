#
#	ppp
#
	.text
	.align 2
.P3:
	sub	sp,sp,16
	stp	x30,x29,[sp]
	add	x29,sp,0
# Line: 10, Stmt: 1
# Line: 11, Stmt: 2
	mov	x15,3
	str	w15,[x27, 15]
.L2:
	ldp	x30,x29,[sp]
	add	sp,sp,16
	ret
#
#	pp
#
	.text
	.align 2
.P2:
	sub	sp,sp,48
	stp	x30,x29,[sp, 16]
	add	x29,sp,16
# Line: 14, Stmt: 1
	str	x0,[x29, 15]
# Line: 18, Stmt: 2
	mov	x14,3
	mul	w15,w1,w14
	str	w15,[x28, 16]
	str	x2,[sp, 8]
	str	x1,[sp]
	ldrsw	x0,[x2]
	bl	P
	ldr	x15,[sp]
	add	w15,w15,2
	str	w15,[x28, 16]
	mov	x15,7
	str	w15,[x29, 16]
.L3:
	ldp	x30,x29,[sp, 16]
	add	sp,sp,48
	ret
	.bss
	.align 3
.L0:
	.space 64
#
#	foo (main)
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
# Line: 24, Stmt: 1
	ldrsw	x0,[x28, 16]
	ldrsw	x1,[x28, 16]
	add	x2,x28,16
	bl	.P2
.L4:
	ldr	x28,[x29, -8]
	ldp	x30,x29,[sp, 8]
	add	sp,sp,32
	ret
