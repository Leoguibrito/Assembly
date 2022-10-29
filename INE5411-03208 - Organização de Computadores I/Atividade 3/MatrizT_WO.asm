.data
Matriz:     	.word 1, 2, 0, 1, -1, -3, 0, 1, 3, 6, 1, 3, 2, 4, 0, 3     
MatrizT:     	.space 152		#16 NÚMEROS, 16 ESPAÇOS, 4 QUEBRAS DE LINHA, 2 NUMEROS NEGATIVOS
fout:   	.asciiz "MatrizT.dat"
.text
.globl main
main: 
	la $s0, Matriz
	la $s1, MatrizT	
	add $t1, $t1, $s1 		#Posição na Mat T
	li $s2, 32			#Espaço na MatrizT
	li $s3, 10			#Pula linha na MatrizT
	li $s4, 45			#Sinal de menos na MatrizT
	
	# Open (for writing) a file that does not exist
  	li   $v0, 13       		# system call for open file
  	la   $a0, fout     		# output file name
  	li   $a1, 1        		# Open for writing (flags are 0: read, 1: write)
  	li   $a2, 0        		# mode is ignored
  	syscall            		# open a file (file descriptor returned in $v0)
  	move $s6, $v0      		# save the file descriptor 
	
Loop_j:
	add $t0, $t3, $s0		#Endereço Linha
Loop_i:
	lw $t2, 0($t0) 			#Registra o Valor
	jal Conversao
	addi $t1, $t1, 4
 	sw $s2, 0($t1)			#Adiciona um Espaço 
	addi $t1, $t1, 4		#Muda a posição da Mat
	addi $t0, $t0, 16		#Pula a Linha e Registra o Prox Valor...
	addi $t4, $t4, 1		#Contador interno
	bne $t4, 4, Loop_i
	
	sw $s3, 0($t1)			#Adiciona quebra de linha
	addi $t1, $t1, 4
	li $t4, 0
	addi $t3, $t3, 4
	bne $t3, 16, Loop_j
	
	# Write to file just opened
  	li   $v0, 15       		# system call for write to file
  	move $a0, $s6      		# file descriptor 
  	la   $a1, MatrizT  		# address of buffer from which to write
  	li   $a2, 152       		# hardcoded buffer length
  	syscall            		# write to file
  	
  	# Close the file 
  	li   $v0, 16       		# system call for close file
  	move $a0, $s6      		# file descriptor to close
  	syscall            		# close file	
  	j EXIT
  	
 Conversao:		#Converte para ASCII(SOMENTE 1 DIGITO)
 	blt $t2, 0, Conversao_Menor 	#Se for negativo, Pula
 	addi $t2, $t2, 48
 	sw $t2, 0($t1) 			#Insere na Mem
 	jr $ra
 	Conversao_Menor:
 	sw $s4, 0($t1)			#Registra o - na Mem
 	addi $t1, $t1, 4
 	not $t2, $t2			#Inverte o numero para positivo
 	addi $t2, $t2, 49		#48 + 1
 	sw $t2, 0($t1)			#Registra o numero na Mem
 	jr $ra
 	
 	
 EXIT:
 	j EXIT
