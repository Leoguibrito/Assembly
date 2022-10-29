.data
MA:     	.word 1, 2, 3, 0, 1, 4, 0, 0, 1
MB:     	.word 1, -2, 5, 0, 1, -4, 0, 0, 1
MC:     	.space 9

.text
.globl main
main: 
	la $s0, MA    			# Endereço MA
	la $s1, MB   			# Endereço MB
	la $s2, MC			# Endereço MC
	add $t7, $t7, $s1 		# Armazena endereço base de S1
	
Multi:
Multi_linha:
	li $t4, 0			#Buffer de Soma
	lw $t1, 0($s0)  		# Valor MA
	lw $t2, 0($s1)  		# Valor MB
	mul $t3, $t1, $t2		# Multiplica Linha x Coluna
	add $t4, $t4, $t3		# Acumula o Valor
	
	lw $t1, 4($s0)  		
	lw $t2, 12($s1)  		
	mul $t3, $t1, $t2
	add $t4, $t4, $t3	
	
	lw $t1, 8($s0) 			
	lw $t2, 24($s1)  		
	mul $t3, $t1, $t2
	add $t4, $t4, $t3		
		
	sw $t4, 0($s2)  		# Guarda resultado em MC
	add $s1, $s1, 4  		# Atualiza ENDEREÇO MB
	add $s2, $s2, 4  		# Atualiza ENDEREÇO MC
	add $t0, $t0, 1  		# Atualiza contador interno
	
	add	$a0, $zero, $t4		# Valor a ser escrito
	li 	$v0, 1  		# Comando.
	syscall

	li 	$a0, ' '		# Valor a ser escrito
	li	$v0, 11			# Comando
	syscall 	
	
	bne $t0, 3, Multi_linha 	# Executa Linha n de MA com as 3 colunas de MB
	
	addi $s0, $s0, 12    		# Atualiza Linha de MA
	move $s1, $t7        		# Volta ao endereço inicial da coluna
	move $t0, $zero	  		# Zera contador interno
	add $t8, $t8, 1  		# Atualiza contador externo
	
	li	$a0, '\n'	
	li	$v0, 11		
	syscall

	bne $t8, 3, Multi

EXIT:
	j EXIT
