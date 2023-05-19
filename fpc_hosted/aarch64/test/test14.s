#
#	p
#
	.text
	.align 2
.P1:
	sub	sp,sp,32
	stp	x30,x29,[sp, 16]
	add	x29,sp,16
# Line: 7, Stmt: 1
# Line: 8, Stmt: 2
	ldrsw	x15,[x28, 16]
	ldrsw	x14,[x28, 20]
	cmp	x15,x14
	b.ge	.L3
.L4:
	str	w15,[x28, 24]
	b	.L5
.L3:
	str	w14,[x28, 24]
.L2:
.L5:
	ldp	x30,x29,[sp, 16]
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
# Line: 12, Stmt: 1
.L6:
	ldr	x28,[x29, -8]
	ldp	x30,x29,[sp, 8]
	add	sp,sp,32
	ret
