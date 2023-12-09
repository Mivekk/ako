.686
.model flat

extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main

.code
	read PROC
		push ebp
		mov ebp, esp

		sub esp, 7 ; reserve space for edi
		mov edi, esp

		push 7
		push edi
		push 0
		call __read
		add esp, 12

		mov ebx, 0Ah ; multiplier

		xor eax, eax ; clear younger part for mul
		xor edx, edx ; clear older part for mul
		xor esi, esi ; chars iterator

		toNumber:
			movzx ecx, byte PTR [edi][esi]
			sub ecx, 30h
			add eax, ecx
 
			cmp byte PTR [edi][esi + 1], 0Ah
			je readReturn

			mul ebx			

			inc esi
			cmp esi, 7
			jne toNumber

		readReturn:

		mov esp, ebp
		pop ebp

		ret
	read ENDP

	write PROC
		push ebp
		mov ebp, esp

		sub esp, 11
		mov edi, esp

		mov byte PTR [edi][10], 0Ah ; insert new line

		mov ebx, 0Ah ; divisor

		mov esi, 10
		toDec:
			dec esi

			xor edx, edx
			div ebx

			add dl, 30h
			mov byte PTR [edi][esi], dl

			cmp esi, 0
			jnz toDec

		mov ebx, 11
		reduce:
			cmp byte PTR [edi][esi], 30h
			jne writeReturn
			
			dec ebx
			jz writeReturn

			inc edi
			jmp reduce

		writeReturn:

		push ebx
		push edi
		push 1
		call __write

		mov esp, ebp
		pop ebp
		ret
	write ENDP

	_main PROC
		call read

		xor edx, edx
		mul eax

		call write

		push 0
		call _ExitProcess@4
	_main ENDP
END