key:5
	mov	x15,3
	str	w15,[x27, 24]
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
	str	w15,[x27, 24]
.L2:
	ldp	x30,x29,[sp]
	add	sp,sp,16
	ret
key:6
	str	x0,[x29, 24]
key:12
	mov	x14,3
	mul	w15,w1,w14
key:13
	str	w15,[x28, 16]
savekey:499
	str	x1,[sp, -8]
savekey:498
	str	x2,[sp, -16]
key:16
	str	x1,[sp, -8]
	str	x2,[sp, -16]
key:18
	bl	P
key:17
	ldr	x15,[sp, -8]
	add	w15,w15,2
key:18
	str	w15,[x28, 16]
key:18
	mov	x15,7
	str	w15,[x29, 16]
key:18
	ldr	x15,[sp, -16]
	ldrsw	x15,[x15]
	str	w15,[x29, 24]
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
	str	x0,[x29, 24]
# Line: 18, Stmt: 2
	mov	x14,3
	mul	w15,w1,w14
	str	w15,[x28, 16]
	str	x1,[sp, 8]
	str	x2,[sp]
	ldrsw	x0,[x2]
	bl	P
	ldr	x15,[sp, 8]
	add	w15,w15,2
	str	w15,[x28, 16]
	mov	x15,7
	str	w15,[x29, 16]
	ldr	x15,[sp]
	ldrsw	x15,[x15]
	str	w15,[x29, 24]
.L3:
	ldp	x30,x29,[sp, 16]
	add	sp,sp,48
	ret
key:9
	add	x2,x28,16
key:8
	bl	.P2
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
# Line: 25, Stmt: 1
	ldrsw	x0,[x28, 16]
	ldrsw	x1,[x28, 16]
	add	x2,x28,16
	bl	.P2
.L4:
	ldr	x28,[x29, -8]
	ldp	x30,x29,[sp, 8]
	add	sp,sp,32
	ret
