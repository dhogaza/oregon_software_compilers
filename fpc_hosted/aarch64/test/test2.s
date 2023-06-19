	.text
	.align 2
#
#	bar
#
.P1:
	sub	sp,sp,64
	stp	x30,x29,[sp,24]
	add	x29,sp,24
	str	x26,[x29,-8]
# Line: 8, Stmt: 1
# Line: 9, Stmt: 2
	ldrsw	x15,[x28,32]
	ldrsw	x14,[x28,36]
	add	w26,w15,w14
	sub	w26,w15,w14
	mul	w26,w15,w14
	sdiv	w14,w15,w26
	msub	w13,w14,w26,w15
	str	w14,[x28,36]
	str	w13,[x28,36]
	ldrsw	x14,[x28,36]
	add	w26,w15,w14
	movz	w16,3
	str	w16,[x28,36]
.L2:
	ldr	x26,[x29,-8]
	ldp	x30,x29,[sp,24]
	add	sp,sp,64
	ret
	.bss
	.align 3
.L32766:
	.space 40
	.text
	.align 2
#
#	foo (main)
#
	.global main
main:
	sub	sp,sp,32
	stp	x30,x29,[sp,8]
	add	x29,sp,8
	str	x28,[x29,-8]
	adrp	x28,.L32766
	add	x28,x28,:lo12:.L32766
# Line: 18, Stmt: 1
.L3:
	ldr	x28,[x29,-8]
	ldp	x30,x29,[sp,8]
	add	sp,sp,32
	ret
