	.file	"integral_calc.c"
	.text
	.globl	f
	.def	f;	.scl	2;	.type	32;	.endef
	.seh_proc	f
f:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	.seh_endprologue
	movsd	%xmm0, 16(%rbp)     ; переменная: Сохраняем аргумент x из регистра %xmm0 в память в ячейку 16(%rbp)
	movsd	16(%rbp), %xmm0     ; Загружаем x обратно в регистр %xmm0 для вычислений
	mulsd	%xmm0, %xmm0        ; Вычисляем x * x, результат в %xmm0
	popq	%rbp
	ret                         ; Возврат из функции f - значение x*x возвращается через %xmm0
	.seh_endproc
	
	.globl	integrate
	.def	integrate;	.scl	2;	.type	32;	.endef
	.seh_proc	integrate
integrate:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$64, %rsp           ; Выделяем 64 байта на стеке под локальные переменные
	.seh_stackalloc	64
	.seh_endprologue
	

	movsd	%xmm0, 16(%rbp)     ; Переменная: start сохраняется в 16(%rbp)
	movsd	%xmm1, 24(%rbp)     ; Переменная: end сохраняется в 24(%rbp)
	movl	%r8d, 32(%rbp)      ; Переменная: steps сохраняется в 32(%rbp)
	
	; step_size = (end - start) / steps
	movsd	24(%rbp), %xmm0     ; Загружаем end в %xmm0
	subsd	16(%rbp), %xmm0     ; Вычитаем start: %xmm0 = end - start
	pxor	%xmm1, %xmm1        ; Очищаем регистр %xmm1
	cvtsi2sdl	32(%rbp), %xmm1 ; Переводим целое число steps в double
	divsd	%xmm1, %xmm0        ; (end - start) / steps
	movsd	%xmm0, -24(%rbp)    ; Переменная: step_size сохраняется в -24(%rbp)
	
	; Иициализация перменных перед циклом
	pxor	%xmm0, %xmm0        ; Получаем 0.0 в регистре %xmm0
	movsd	%xmm0, -8(%rbp)     ; Переменная: sum = 0.0  хранится в -8(%rbp)
	movl	$0, -12(%rbp)       ; Переменная счетчик: i = 0 хранится в -12(%rbp)
	jmp	.L4                     ; Переход на проверку условия цикла
	
.L5:                            ; Начало цикла
	; Вычисление x = start + i * step_size
	pxor	%xmm0, %xmm0        	; Очищается %xmm0
	cvtsi2sdl	-12(%rbp), %xmm0 	; i в double
	mulsd	-24(%rbp), %xmm0    	; i * step_size
	movsd	16(%rbp), %xmm1     	; Загружаем start в %xmm1
	addsd	%xmm1, %xmm0        	;  start + (i * step_size)
	movsd	%xmm0, -32(%rbp)    	; x = результат сохраняем в -32(%rbp)
	
	; Подготовка к вызову функции f(x)
	movq	-32(%rbp), %rax     ; Переносим x в регистр общего назначения %rax
	movq	%rax, %xmm0         ; Переносим x в %xmm0
	call	f                   ; Вызов f(x), результат f(x) вернется в %xmm0
	
	; sum += f(x) * step_size
	movq	%xmm0, %rax         ; Копируем результат f(x) в %rax
	movq	%rax, %xmm0         ; Возвращаем в %xmm0
	mulsd	-24(%rbp), %xmm0    ; f(x) * step_size
	movsd	-8(%rbp), %xmm1     ; Загружаем текущую sum из -8(%rbp)
	addsd	%xmm1, %xmm0        ; sum + (f(x) * step_size)
	movsd	%xmm0, -8(%rbp)     ; Сохраняем обновленную sum обратно на стек
	
	addl	$1, -12(%rbp)       ; i++
	
.L4:                            ; Условие цилка for
	movl	-12(%rbp), %eax     ; Загружаем текущее значение i в %eax
	cmpl	32(%rbp), %eax      ; Сравниваем i с переменной steps (32(%rbp))
	jl	.L5                     ; Если i < steps, идем обратно в тело цикла
	
	;  Выход из цикла
	movsd	-8(%rbp), %xmm0     ; Помещаем финальную sum в %xmm0
	addq	$64, %rsp           ; Освобождаем 64 байта памяти
	popq	%rbp
	ret                         ; Выход из функции integrate
	.seh_endproc
	.ident	"GCC: (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders, r3) 14.2.0"