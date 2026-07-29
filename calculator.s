.intel_syntax noprefix
.global _start
.extern atoi
.extern itoa


_start:
cmp BYTE PTR [rsp], 4
je binary_op
cmp BYTE PTR [rsp], 3
je unary_op
wrong_val:
mov rdi, 0
call itoa
mov rax, 60
mov rdi, 1
syscall
binary_op:
mov rdi, QWORD PTR [rsp+32]
call atoi
push rax
mov rdi, QWORD PTR [rsp+24]
call atoi
push rax
mov rcx, QWORD PTR [rsp+40]
pop rdi
pop rbx
cmp BYTE PTR [rcx], '+'
je op_add
cmp BYTE PTR [rcx], '-'
je op_sub
cmp BYTE PTR [rcx], '*'
je op_mult
cmp BYTE PTR [rcx], '^'
je op_xor
cmp BYTE PTR [rcx], '|'
je op_or
cmp BYTE PTR [rcx], '&'
je op_and
jmp wrong_val
op_add:
add rdi, rbx
jmp end
op_sub:
sub rdi, rbx
jmp end
op_mult:
imul rdi, rbx
jmp end
op_xor:
xor rdi, rbx
jmp end
op_or:
or rdi, rbx
jmp end
op_and:
and rdi, rbx
jmp end
unary_op:
mov rdi, QWORD PTR [rsp+24]
call atoi
mov rdi, rax
mov rcx, QWORD PTR [rsp+16]
cmp BYTE PTR [rcx], '-'
je op_neg
cmp BYTE PTR [rcx], '~'
je op_not
jmp wrong_val
op_neg:
neg rdi
jmp end
op_not:
not rdi
jmp end
end:
call itoa
mov rax, 60
mov rdi, 0
syscall
