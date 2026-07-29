.intel_syntax noprefix
.global _start
.extern atoi
.extern itoa


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