#
#	p
#
	.text
	.align 2
.P2:
	sub	sp,sp,32
	stp	x30,x29,[sp, 8]
	add	x29,sp,8
# Line: 8, Stmt: 1
# Line: 9, Stmt: 2
	ldrsw	x15,[x28, 16]
	ldrsw	x14,[x28, 20]
	cmp	x15,x14
	b.ge	.L3
	ldrsw	x15,[x28, 24]
	cmp	x14,x15
	b.le	.L3
.L4:
	bl	pext
	ldrsw	x15,[x28, 16]
	str	w15,[x28, 24]
	b	.L6
.L3:
	str	w14,[x28, 24]
.L2:
.L6:
	ldp	x30,x29,[sp, 8]
	add	sp,sp,32
	ret
	.bss
	.align 3
.L0:
	.space 32
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
# Line: 17, Stmt: 1
.L7:
	ldr	x28,[x29, -8]
	ldp	x30,x29,[sp, 8]
	add	sp,sp,32
	ret
