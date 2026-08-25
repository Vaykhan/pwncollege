.intel_syntax noprefix
.global _start
.extern atoi
.extern itoa

_start:
cmp QWORD PTR [rsp], 2
jl exit
mov rbx, QWORD PTR [rsp+16]
mov rbp, 40
sub rsp, 16

print:
cmp BYTE PTR [rbx], 0
je exit

backslash:
cmp BYTE PTR [rbx], '\\' # backslash(\)
jne percent
cmp BYTE PTR [rbx+1], 'n'
je newline
cmp BYTE PTR [rbx+1], 'x'
je hex_byte_start
cmp BYTE PTR [rbx+1], '\\'
je double_escape
jmp normal_char

percent:
cmp BYTE PTR [rbx], '%'
jne normal_char
cmp BYTE PTR [rbx+1], 'd'
je decimal
cmp BYTE PTR [rbx+1], 's'
je string_literal_start
cmp BYTE PTR [rbx+1], '%'
je double_escape
jmp normal_char

decimal:
mov rdi, QWORD PTR [rsp+rbp]
call atoi
mov rdi, rax
call itoa
add rbp, 8
add rbx, 2
jmp print

string_literal_start:
mov r12, QWORD PTR [rsp+rbp]
string_literal:
cmp BYTE PTR [r12], 0
je string_literal_end
mov rax, 1
mov rdi, 1
mov rsi, r12
mov rdx, 1
syscall
inc r12
jmp string_literal
string_literal_end:
add rbp, 8
add rbx, 2
jmp print

hex_byte_start:
add rbx, 2
xor r12, r12
xor rax, rax
mov rcx, 0
hex_byte1:
mov r12b, BYTE PTR [rbx]
sub r12, 0x30
cmp r12, 0xA
jnb hex_byte2
add rax, r12
jmp hex_byte_end
hex_byte2:
sub r12, 0x11
cmp r12, 0x7
jnb hex_byte3
add rax, r12
add rax, 0xA #add 10 to the hex digit's corresponding number
jmp hex_byte_end
hex_byte3:
sub r12, 0x20
cmp r12, 0x7
jnb print
add rax, r12
add rax, 0xA
jmp hex_byte_end
hex_byte_end:
cmp rcx, 1
je print_hex_byte #print the byte; add rbx, 2;
shl rax, 4
add rcx, 1
add rbx, 1
jmp hex_byte1 #SHift Left, increase rcx
print_hex_byte:
mov BYTE PTR [rsp], al
mov rax, 1
mov rdi, 1
mov rsi, rsp
mov rdx, 1
syscall
add rbx, 1
jmp print

double_escape:
inc rbx
jmp normal_char

newline:
mov rax, 1
mov rdi, 1
mov BYTE PTR [rsp], 0x0a
mov rsi, rsp
mov rdx, 1
syscall
add rbx, 2
jmp print

normal_char:
mov rax, 1
mov rdi, 1
mov rsi, rbx
mov rdx, 1
syscall
inc rbx
jmp print
exit:
add rsp, 16
mov rax, 60
mov rdi, 0
syscall
