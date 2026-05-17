	.file	"integral_calc.c"
	.text
	.p2align 4
	.globl	f
	.def	f;	.scl	2;	.type	32;	.endef
	.seh_proc	f
f:
	.seh_endprologue
	mulsd	%xmm0, %xmm0
	ret
	.seh_endproc
	.p2align 4
	.globl	integrate
	.def	integrate;	.scl	2;	.type	32;	.endef
	.seh_proc	integrate
integrate:
	.seh_endprologue
	subsd	%xmm0, %xmm1
	movapd	%xmm0, %xmm3
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%r8d, %xmm0
	divsd	%xmm0, %xmm1
	testl	%r8d, %r8d
	jle	.L6
	xorl	%eax, %eax
	pxor	%xmm0, %xmm0
	.p2align 6
	.p2align 4
	.p2align 3
.L5:
	pxor	%xmm2, %xmm2
	cvtsi2sdl	%eax, %xmm2
	addl	$1, %eax
	mulsd	%xmm1, %xmm2
	addsd	%xmm3, %xmm2
	mulsd	%xmm2, %xmm2
	mulsd	%xmm1, %xmm2
	addsd	%xmm2, %xmm0
	cmpl	%eax, %r8d
	jne	.L5
	ret
	.p2align 4,,10
	.p2align 3
.L6:
	pxor	%xmm0, %xmm0
	ret
	.seh_endproc
	.ident	"GCC: (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders, r3) 14.2.0"
