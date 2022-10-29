.data
MA:		.space 36
MB:     	.space 36
MC:     	.space 36
MC_txt:		.space 200
fileName: .asciiz "Produto.dat"

.text
.globl main
main:
	la $s0, MA 			# Endereço MA
	la $s1, MB   			# Endereço MB
	la $s2, MC			# Endereço MC
	la $s3, MC_txt
	
	jal Montar_Matriz
	
	la $s0, MA 			# Endereço MA
	li $t0, 0 			# contador interno
	li $t8, 0			# contador externo
	   
	add $t7, $t7, $s1 		# Armazena enderecobase de S1
	
	jal Multi
	la $s2, MC			# Reseta endereco de S2
	lw $t0, 0($s2)
	li $t8, 0
	li $s5, 32			# Espaco na MatrizT
	li $s6, 45			# Sinal de menos na MatrizT
	li $s7, 10
	li $t5, 0
	jal Conversao_Int_Asciiz       	# CONVERTER NUMEROS E COLOCAR EM MC_txt
	jal Salvar_arquivo
	j EXIT
	
Multi:
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	jal Multi_linha
	addi $s0, $s0, 12    		# Atualiza Linha de MA
	move $s1, $t7        		# Volta ao endereço inicial da coluna
	move $t0, $zero	  		# Zera contador interno
	add $t8, $t8, 1  		# Atualiza contador externo
	
	li	$a0, '\n'	
	li	$v0, 11		
	syscall
	bne $t8, 3, Multi_linha
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra
	
Multi_linha:
	sw $ra, 0($sp)
	li $t4, 0			# Buffer de Soma
	lw $t1, 0($s0)  		# Valor MA
	lw $t2, 0($s1)  		# Valor MB
	
	mult $t1, $t2
	mflo $t3			# Multiplica Linha x Coluna
	mfhi $t5
	add $t4, $t4, $t3		# Acumula o Valor
	
	lw $t1, 4($s0)  		
	lw $t2, 12($s1)  		
	mult $t1, $t2
	mflo $t3
	mfhi $t5
	add $t4, $t4, $t3
	
	lw $t1, 8($s0) 			
	lw $t2, 24($s1)  		
	mult $t1, $t2
	mflo $t3
	mfhi $t5
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
	lw $ra, 0($sp)
	jr $ra
	
	
Montar_Matriz:
	li $v0, 5         # atribui 5 para $vo. Codigo para read_int
	syscall           # chamada de sistema para E/S. Retorno estara em $v0
	move $t2, $v0     # copia conteudo digitado para $t2 para preservar dado
	
	sw $t2, 0($s0)
	addi $s0, $s0, 4
	addi $t8, $t8, 1   # contador interno
	bne $t8, 18, Montar_Matriz
	jr $ra
	
	
	
Conversao_Int_Asciiz:
	sw $ra, 0($sp)			#Salva o ra 
	addi $sp, $sp, -4
	
	Conversao:
	blt $t0, 0, Conversao_Menor	#Se for negativo, Pula
	jal Percorre_Int	
 	lw $ra, 0($sp)
 	jr $ra
 	
 	Conversao_Menor:
 	sw $s6, 0($s3)			#Registra o - no Array_Conv
 	addi $s3, $s3, 4		#Atualiza o Array_Conv
 	not $t0, $t0			#Inverte o numero para positivo
 	addi $t0, $t0, 1
 	jal Percorre_Int
 	lw $ra, 0($sp)
 	jr $ra

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
	sw $t2, 0($s3)			#Armazena o Inteiro no Array_Conv
	addi $s3, $s3, 4
	addi $t6, $t6, 1		#Armazena até atingir o Tamanho da Int
	blt $t6, $t5, Armazenar_Int
	sw $s5, 0($s3)			#Adiciona Espaço na Matriz
	addi $s3, $s3, 4
	
	addi $t8, $t8, 1
	addi $s2, $s2, 4
	lw $t0, 0($s2)
	addi $sp, $sp, -4
	
	div $t7, $t8, 3
	mfhi $t7
	bne $t7, 0, Conversao		#Checa para ver se adiciona Quebra de Linha
	sw $s7, 0($s3)
	addi $s3, $s3, 4
	bne $t8, 9, Conversao
	
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra


Salvar_arquivo:
	# Open file
    	li $v0,13           # open_file syscall code = 13
    	la $a0, fileName    # get the file name
    	li $a1,1            # file flag = write
    	syscall
    	move $s6,$v0        # save the file descriptor 

    	#write into the file
    	li $v0, 15              # write_file syscall code = 15
    	move $a0, $s6           # file descriptor (fileName)
    	la $a1, MC_txt         # the text that will be written in the file
    	li $a2, 200              # file size? 
    	syscall

   	#close the file
    	li $v0, 16      # close_file syscall code
    	syscall
 
    	jr $ra

EXIT:
	j EXIT