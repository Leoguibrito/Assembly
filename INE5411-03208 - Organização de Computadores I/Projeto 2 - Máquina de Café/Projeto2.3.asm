.data
doses:		.byte 20, 20, 20, 20
.align 0
buffer:		.byte 0 0

.text	
Inicializa:
	lb $s0, doses		#Doses Café Puro
	lb $s1, doses+1		#Doses Leite
	lb $s2, doses+2		#Doses Chocolate
	lb $s3, doses+3 	#Doses Acucar
	li $s4, 20		#Refill
	
.globl main
main:	
	li $t0, 0		#Tipo de Cafe (1 = CafePuro, 2 = CafeComLeite, 3 = Mochaccino, 4 = Refill) 
	li $t1, 0		#Tempo de preparo em s
	li $t2, 0 		#Tamanho do Cafe (1 = P, 2 = G)
	li $t3, 0		#Com/Sem Acucar	(1 = Sem, 2 = Com)
	
	jal Cafe
	jal QuerAcucar
	jal VerificaEstoque
	
	#Tempo de preparo syscall (sleep)
	mul $t1, $t1, 1000
	move $a0, $t1
	li $v0, 32
	syscall
	
	jal GerarCupom

				
			
Cafe:	
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	
	#Seleciona o tipo de cafe ou refill syscall
	li $v0, 5       	# atribui 5 para $vo. Codigo para read_int
	syscall         	# chamada de sistema para E/S. Retorno estara em $v0
	move $t0, $v0
	
	beq $t0, 4, Refill
	jal Tamanho
			
CafePuro:
	sub $s0, $s0, $t2
	sb $s0, doses
	beq $t0, 1, ExitCafe	
CafeComLeite:
	sub $s1, $s1, $t2
	sb $s1, doses+1
	beq $t0, 2 ExitCafe					
Mochaccino:
	sub $s2, $s2, $t2
	sb $s2, doses+2	
ExitCafe:
	mul $t9, $t2, $t0
	add $t1, $t1, $t9 		#Soma Tempo Cafe
	
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra	



Tamanho:
	#Seleciona o tamanho do cafe syscall
	la $a0, buffer
	li $a1, 2
	li $v0, 8
	syscall
	
	lb $t2, buffer
	beq $t2, 80, Pequeno		#P
	beq $t2, 112, Pequeno		#p
Grande:
	li $t2, 2
	addi $t1, $t1, 10		#Soma Tempo Tamanho
	jr $ra
Pequeno:
	li $t2, 1
	addi $t1, $t1, 5		#Soma Tempo Tamanho
	jr $ra



QuerAcucar:
	#Ver se quer acucar syscall
	la $a0, buffer
	li $a1, 2
	li $v0, 8
	syscall
	
	lb $t2, buffer
	beq $t2, 78, Nao		#n
	beq $t2, 110, Nao		#N
	
	li $t2, 2
	sub $s3, $s3, $t2
	sb $s3, doses+3
	li $t3, 1
	mul $t9, $t3, $t2
	add $t1, $t1, $t9
Nao: 	
	li $t2, 1
	jr $ra



GerarCupom:		#TODO



VerificaEstoque: 	#TODO
	jr $ra
EmFalta:		#TODO
	j main


Refill:
	#Seleciona o po a ser reposto syscall
	li $v0, 5       	# atribui 5 para $vo. Codigo para read_int
	syscall         	# chamada de sistema para E/S. Retorno estara em $v0
	subi $v0, $v0, 1
	sb $s5, doses($v0)
