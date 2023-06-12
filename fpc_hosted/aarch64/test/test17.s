#
#	pp
#
	.text
	.align 2
.P2:
	sub	sp,sp,48
	stp	x30,x29,[sp, 24]
	add	x29,sp,24
# Line: 9, Stmt: 1
# Line: 10, Stmt: 2
	str	x1,[sp, 8]
	str	w1,[x2]
	add	w1,w1,1
	str	x1,[sp, 8]
	ldrsw	x16,[x28, 16]
	add	w17,w16,1
	str	w17,[x28, 16]
	mov	x16,3
	mul	w17,w1,w16
	str	w17,[x28, 16]
	ldrsw	x0,[x2]
	bl	P
	ldr	x16,[sp, 8]
	add	w17,w16,1
	str	x17,[sp, 16]
	str	w17,[x28, 16]
	mov	x0,x17
	bl	P
	ldr	x17,[sp, 16]
	str	w17,[x28, 16]
	mov	x17,7
.L2:
	ldp	x30,x29,[sp, 24]
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
# Line: 21, Stmt: 1
	ldrsw	x0,[x28, 16]
	ldrsw	x1,[x28, 16]
	add	x2,x28,16
	bl	.P2
.L3:
	ldr	x28,[x29, -8]
	ldp	x30,x29,[sp, 8]
	add	sp,sp,32
	ret
