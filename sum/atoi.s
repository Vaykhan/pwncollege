.intel_syntax noprefix
.global atoi


atoi:
mov r8b, 0
cmp BYTE PTR [rdi], 0x2d
jne calc_start   		#dont invert the neg byte(r8b) if there is not a negative sign(-)
mov r8b, 1
inc rdi

calc_start:
xor edx, edx
xor eax, eax
xor ecx, ecx

loop:
mov cl, BYTE PTR [rdi]
sub cl, 0x30
cmp cl, 0x10
jnb neg_check	
imul rdx, 10			# 10*a
xor eax, eax
mov al, BYTE PTR [rdi]
sub al, 0x30
add rdx, rax			# 10*a + b
inc rdi				# move on to the next byte
jmp loop

neg_check:
cmp r8b, 0
je exit_atoi
neg rdx

exit_atoi:
mov rax, rdx
ret
