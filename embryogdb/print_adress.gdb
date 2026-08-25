start
break *main+798 #change offset from main according to where <read@plt> is called
commands
	silent
	set $random_val = *(unsigned long long *)($rbp-0x18)
	printf "%llx\n", $random_val
	continue
end
continue
