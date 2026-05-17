; Начало функции
integrate:
    pushq	%rbp
    movq	%rsp, %rbp
    subq	$64, %rsp           ; Выделение 64 байта памяти
    
    ; Сохранение аргументов из регистров в память
    movsd	%xmm0, 16(%rbp)     ; переменная start
    movsd	%xmm1, 24(%rbp)     ; переменная end
    movl	%r8d, 32(%rbp)      ; переменная steps

    ; double step_size = (end - start) / steps;
    movsd	24(%rbp), %xmm0     ; берем end
    subsd	16(%rbp), %xmm0     ; end - start
    pxor	%xmm1, %xmm1        ; обнуляем xmm1
    cvtsi2sdl	32(%rbp), %xmm1 ; преобразуем steps в double
    divsd	%xmm1, %xmm0        ; делим разницу на steps
    movsd	%xmm0, -24(%rbp)    ; сохраняем step_size в память

    ; double sum = 0.0;
    pxor	%xmm0, %xmm0
    movsd	%xmm0, -8(%rbp)     ; сохраняем sum в память

    ; int i = 0;
    movl	$0, -12(%rbp)
    jmp	.L4

; Начало цикла for (int i = 0; i < steps; i++)
.L5: 
    ; double x = start + i * step_size;
    pxor	%xmm0, %xmm0
    cvtsi2sdl	-12(%rbp), %xmm0 ; i в double
    mulsd	-24(%rbp), %xmm0     ; i * step_size d xmm0
    movsd	16(%rbp), %xmm1      ; берем start в xmm1
    addsd	%xmm1, %xmm0         ; start + (i * step_size)
    movsd	%xmm0, -32(%rbp)     ; сохраняем полученный x в память

    ; sum += f(x) * step_size;
    movq	-32(%rbp), %rax
    movq	%rax, %xmm0
    call	f                    ; Вызываем функцию f
    
    mulsd	-24(%rbp), %xmm0     ; умножаем результат f(x) на step_size
    movsd	-8(%rbp), %xmm1      ; берем текущую сумму
    addsd	%xmm1, %xmm0         ; прибавляем новое значение
    movsd	%xmm0, -8(%rbp)      ; сохраняем sum обратно в память

    addl	$1, -12(%rbp)        ; i++

; Проверка условия цикла
.L4:
    movl	-12(%rbp), %eax      ; загружаем i
    cmpl	32(%rbp), %eax       ; сравниваем i с steps
    jl	.L5                    	 ; если i < steps, идем обратно в начало цикла

    ; return sum;
    movsd	-8(%rbp), %xmm0      ; кладем результат в регистр
    addq	$64, %rsp            ; очищаем память
    popq	%rbp
    ret
