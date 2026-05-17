	.file	"integral_calc.c"
	.text
	.p2align 4
	.globl	f
	.def	f;	.scl	2;	.type	32;	.endef
	.seh_proc	f
f:
	.seh_endprologue
	mulsd	%xmm0, %xmm0        ; Оптимизиция - функция сжалась до одной инструкции x * x
	ret
	.seh_endproc
	
	.p2align 4
	.globl	integrate
	.def	integrate;	.scl	2;	.type	32;	.endef
	.seh_proc	integrate
integrate:
	.seh_endprologue
	; Оптимизиция - переменные сразу распределяются по регистрам:
	; %xmm0 = start, %xmm1 = end, %r8d = steps
	
	subsd	%xmm0, %xmm1        ; %xmm1 = end - start
	movapd	%xmm0, %xmm3        ; Регистр %xmm3 = переменная start
	pxor	%xmm0, %xmm0        ; Очищаем %xmm0
	cvtsi2sdl	%r8d, %xmm0     ; Конвертируем steps в double
	divsd	%xmm0, %xmm1        ; Регистр %xmm1 = переменная step_size = (end - start) / steps
	
	testl	%r8d, %r8d          ; Проверяем, если steps <= 0
	jle	.L6                     ; Если steps <= 0, сразу идем на выход в .L6
	
	xorl	%eax, %eax          ; Регистр %eax = переменная-счетчик i = 0
	pxor	%xmm0, %xmm0        ; Регистр %xmm0 = переменная sum = 0.0
	.p2align 6
	.p2align 4
	.p2align 3
	
.L5:                            ; Начало цикла for
	pxor	%xmm2, %xmm2        ; Очищаем регистр %xmm2
	cvtsi2sdl	%eax, %xmm2     ; Счетчик i в double
	addl	$1, %eax            ; i++
	mulsd	%xmm1, %xmm2        ; %xmm2 = i * step_size
	addsd	%xmm3, %xmm2        ; %xmm2 = start + (i * step_size), это x
	
	mulsd	%xmm2, %xmm2        ; Прямое вычисление x * x
	mulsd	%xmm1, %xmm2        ; %xmm2 = (x * x) * step_size
	addsd	%xmm2, %xmm0        ; sum += %xmm2 
	
	cmpl	%eax, %r8d          ; Сравниваем steps в %r8d с текущим i в %eax
	jne	.L5                     ; Если не равны то продолжаем цикл идем в L5
	
	ret                         ; Конец работы, результат sum уже находится в %xmm0
	
	.p2align 4,,10
	.p2align 3
.L6:                            ; Если steps <= 0
	pxor	%xmm0, %xmm0        ; Возвращаем sum = 0.0
	ret
	.seh_endproc
	.ident	"GCC: (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders, r3) 14.2.0"