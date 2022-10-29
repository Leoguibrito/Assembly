.data
Matriz:     	.word 1, 2, 0, 1, -1, -3, 0, 1, 3, 6, 1, 3, 2, 4, 0, 3
MatrizT:     	.space 64

.text
.globl main
main: 
	la $s0, Matriz
	la $s1, MatrizT	
	
	add $t1, $t1, $s1 		#Posição na Mat T

	
Loop_j:
	add $t0, $t3, $s0		#Endereço Linha
Loop_i:
	lw $t2, 0($t0) 			#Registra o Valor 
	sw $t2, 0($t1) 			#Insere na MemT
	add $t1, $t1, 4			#Muda a posição da Mat
	add $t0, $t0, 16		#Pula a Linha e Registra o Prox Valor...
	addi $t4, $t4, 1		#Contador interno
	
	add	$a0, $zero, $t2		# Escreve a Transposta
	li 	$v0, 1  		
	syscall

	li 	$a0, ' '		# Espaço
	li	$v0, 11			
	syscall 
	
	bne $t4, 4, Loop_i
	
	li	$a0, '\n'		#Pula Linha no Console		
	syscall
	
	li $t4, 0
	add $t3, $t3, 4
	bne $t3, 16, Loop_j

EXIT:
	j EXIT
