.data
	file: .asciiz "/home/leonardo/Documents/MARS/Atividade 6/Conversion.dat"
	.align 2
	buffer: .space 134
	.align 2
	Array: .space 40	
	
.text
.globl main
main:

	la $s1, buffer			
	la $s2, Array
	li $t1, 10	

	# Open (for writing) a file that does not exist
  	li   $v0, 13       		# system call for open file
  	la   $a0, file     		# output file name
  	li   $a1, 0        		# Open for writing (flags are 0: read, 1: write)
  	syscall            		# open a file (file descriptor returned in $v0)
  	move $s0, $v0      		# save the file descriptor 
	
	#Escreve o arquivo ascii no buffer
	move $a0, $s0 			
	li $v0, 14 		
	la $a1, buffer
	li $a2, 134
	syscall
	addi $s1, $s1, 4		#Pula o primeiro byte
	
	# chama procedimento
	Loop_buffer:
	lw $t0, 0($s1)
	jal Inverted_Conversion		#Chamada do procedimento
	addi $s2, $s2, 4		#Atualiza o Array
	addi $t3, $t3, 1		#Contador
	bne $t3, 11, Loop_buffer
	
	
	# Close the file 
  	li   $v0, 16       		# system call for close file
  	move $a0, $s6      		# file descriptor to close
  	syscall            		# close file	
  	j EXIT
  	
  	
  	
Inverted_Conversion:
	Espaço:
	bne $t0, 32, Inteiro		#Ignora o Espaço
	addi $s1, $s1, 4 	
	lw $t0, 0($s1)
	
	Inteiro:
	bne $t0, 45, Positivo		#Checa se é Positivo ou Negativo
	
	
	addi $s1, $s1, 4		#Se é negativo pula o sinal de -
	lw $t0, 0($s1)
	Negativo:
	sub $t0, $t0, 48
	mul $t2, $t2, $t1		#Aumenta a casa decimal do resultado
	add $t2, $t2, $t0		#Soma com o valor do buffer
	addi $s1, $s1, 4
	lw $t0, 0($s1)			#Carrega novo valor do buffer
	bne $t0, 32, Negativo		#Espaço indica fim do número
	not $t2, $t2
	addi $t2, $t2, 1
	sw $t2, 0($s2)			#Armazena o numero negativo
	li $t2, 0
	jr $ra
	
	
	Positivo:
	sub $t0, $t0, 48 	  	
	mul $t2, $t2, $t1		#Aumenta a casa decimal do resultado
	add $t2, $t2, $t0		#Soma com o valor do buffer
	addi $s1, $s1, 4
	lw $t0, 0($s1)			#Carrega novo valor do buffer
	bne $t0, 32, Positivo		#Espaço indica fim do número
	sw $t2, 0($s2)			#Armazena o numero positivo
	li $t2, 0
	jr $ra
  		
  																											
 EXIT:
 	j EXIT	
