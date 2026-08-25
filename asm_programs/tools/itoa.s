.intel_syntax noprefix
.global itoa


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

exit_itoa:
add rsp, rdx
mov rax, rdi
ret
