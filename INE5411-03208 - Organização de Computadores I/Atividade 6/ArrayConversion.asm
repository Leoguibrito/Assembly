.data
Array:		.word 23, 5, 7, 138, -2, -26, 13, -18, 9, -230
Array_Conv:	.space 128
fout:   	.asciiz "Conversion.dat"

.text
.globl main 
main:	
	
	la $s0, Array
	la $s1, Array_Conv
	li $s2, 32		#Espaco na MatrizT
	li $s3, 45		#Sinal de menos na MatrizT
	
	# Open (for writing) a file that does not exist
  	li   $v0, 13       	# system call for open file
  	la   $a0, fout     	# output file name
  	li   $a1, 1        	# Open for writing (flags are 0: read, 1: write)
  	li   $a2, 0        	# mode is ignored
  	syscall            	# open a file (file descriptor returned in $v0)
  	move $s6, $v0      	# save the file descriptor 
	
Loop_Array:
	lw $t0, 0($s0)
	jal Conversao
	addi $s0, $s0, 4		#Percorre o Array
	sw $s2, 0($s1)			#Adiciona um Espaco 
	addi $s1, $s1, 4		#Atualiza o Array_Conv
	addi $t1, $t1, 1		#Contador
	bne $t1, 10, Loop_Array
	
	# Write to file just opened
  	li   $v0, 15       	# system call for write to file
  	move $a0, $s6      	# file descriptor 
  	la   $a1, Array_Conv  	# address of buffer from which to write
  	li   $a2, 128       	# hardcoded buffer length
  	syscall            	# write to file
  	
  	# Close the file 
  	li   $v0, 16       	# system call for close file
  	move $a0, $s6      	# file descriptor to close
  	syscall            	# close file	
  	j EXIT	

	
Conversao:
	blt $t0, 0 Conversao_Menor	#Se for negativo, Pula
	move $s4, $ra			#Salva o ra 
 	jal Percorre_Int	
 	jr $s4
 	
 	Conversao_Menor:
 	sw $s3, 0($s1)			#Registra o - no Array_Conv
 	addi $s1, $s1, 4		#Atualiza o Array_Conv
 	not $t0, $t0			#Inverte o numero para positivo
 	addi $t0, $t0, 1
 	move $s4, $ra
 	jal Percorre_Int
 	jr $s4

Percorre_Int:
	div $t2, $t0, 10		#Divisao por 10
	mflo $t0
	mfhi $t3
	sw $t3, 0($sp)			#Registra na Pilha
	addi $sp, $sp, -4		#Atualiza a Pilha
	addi $t5, $t5, 1		#Registra o Tamanho da Int
	bgt $t2, 0, Percorre_Int
	
	addi $sp, $sp, 4		#Volta 1 Passo na Pilha
	Armazenar_Int:
	lw $t2, 0($sp)			#Pega o Inteiro 
	addi $sp, $sp, 4
	addi $t2, $t2, 48
	sw $t2, 0($s1)			#Armazena o Inteiro no Array_Conv
	addi $s1, $s1, 4
	addi $t6, $t6, 1		#Armazena até atingir o Tamanho da Int
	blt $t6, $t5, Armazenar_Int
	
	jr $ra

EXIT:
	j EXIT
