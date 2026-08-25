start
continue
break *main+633
commands
	silent
	set *(unsigned long long *)($rbp - 0x18) = 0x0000000000000000
	set $rip = *main+695
	set *(unsigned long long *)($rbp - 0x10) = 0x0000000000000000
	continue
end
continue
