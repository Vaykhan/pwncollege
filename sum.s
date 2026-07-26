.intel_syntax noprefix
.global _start



_start:
xor rbx, rbx

mov rdx, 16
mov rcx, QWORD PTR [rsp]
cmp rcx, 1
je output_sum #jump directly to printing if no argument has been supplied

sum_inputs:
mov rdi, QWORD PTR [rsp+rdx]
push rdx
push rcx
call atoi
pop rcx
pop rdx
add rbx, rax
add rdx, 8
dec rcx
cmp rcx, 1 # check if all the arguments except argv[0] has been summed
je output_sum
jmp sum_inputs

output_sum:
mov rdi, rbx
call itoa
#write to stdout
mov rax, 60
syscall




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
cmp cl, 0x30
jnae neg_check			#jump to the end if non-digit byte is reached
cmp cl, 0x39
jnbe neg_check			# dont forget to simplify this jump into a single j* instruction
imul rdx, 10			# 10*a
xor eax, eax
mov al, BYTE PTR [rdi]
sub al, 0x30
add rdx, rax			# 10*a + b
inc rdi				# move on to the next byte
jmp loop

neg_check:
cmp r8b, 0
je exit
neg rdx

exit:
mov rax, rdx
ret



itoa:
mov rax, rdi
xor edi, edi
xor r8, r8
cmp rax, 0
jge skip
neg rax
mov r8b, 1 #set neg bit to true
skip:
mov rcx, 10

get_digits:
xor edx, edx
div rcx
add dl, 0x30
sub rsp, 1
mov BYTE PTR [rsp], dl
inc rdi
cmp rax, 0
je check_neg
jmp get_digits

check_neg:
cmp r8b, 1
jne write_number
inc rdi
sub rsp, 1
mov BYTE PTR [rsp], 0x2d

write_number:
mov rdx, rdi
mov rax, 1
mov rdi, 1
mov rsi, rsp
syscall

end:
add rsp, rdx #fix rsp alignment
mov rax, rdi
ret
