	.file	"integral_calc.c"
	.text
	.globl	f
	.def	f;	.scl	2;	.type	32;	.endef
	.seh_proc	f
f:
	.seh_endprologue
	mulsd	%xmm0, %xmm0
	ret
	.seh_endproc
	.globl	integrate
	.def	integrate;	.scl	2;	.type	32;	.endef
	.seh_proc	integrate
integrate:
	.seh_endprologue
	movapd	%xmm0, %xmm3
	subsd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%r8d, %xmm0
	divsd	%xmm0, %xmm1
	testl	%r8d, %r8d
	jle	.L5
	movl	$0, %eax
	pxor	%xmm0, %xmm0
	.p2align 6
.L4:
	pxor	%xmm2, %xmm2
	cvtsi2sdl	%eax, %xmm2
	mulsd	%xmm1, %xmm2
	addsd	%xmm3, %xmm2
	mulsd	%xmm2, %xmm2
	mulsd	%xmm1, %xmm2
	addsd	%xmm2, %xmm0
	addl	$1, %eax
	cmpl	%eax, %r8d
	jne	.L4
.L2:
	ret
.L5:
	pxor	%xmm0, %xmm0
	jmp	.L2
	.seh_endproc
	.ident	"GCC: (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders, r3) 14.2.0"
