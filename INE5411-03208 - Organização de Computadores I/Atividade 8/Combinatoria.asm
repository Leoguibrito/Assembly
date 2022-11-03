.text
.globl main
main:	
	jal Ler_Entrada		#n
	move $s0, $v0
	jal Ler_Entrada		#p
	move $s1, $v0
	
	jal Cal_Comb
	
	add	$a0, $zero, $t0		# Valor a ser escrito
	li 	$v0, 1  		# Comando.
	syscall
	
	j EXIT

Ler_Entrada:
	li $v0, 5       	# atribui 5 para $vo. Codigo para read_int
	syscall         	# chamada de sistema para E/S. Retorno estara em $v0
	jr $ra
	
Cal_Comb:
	move $s5, $ra
	
	move $t0, $s0
	move $t1, $s0
	jal Fatorial		#n!
	move $s2, $t1
	
	move $t0, $s1
	move $t1, $s1
	jal Fatorial		#p!
	move $s3, $t1
	
	sub $t0, $s0, $s1
	move $t1, $t0
	jal Fatorial		#(n-p)!
	move $s4, $t1
	
	mul $t0, $s3, $s4
	div $t0, $s2, $t0
	jr $s5
	
Fatorial:
	ble $t0, 1, Fatorial1
	sub $t0, $t0, 1
	mul $t1, $t1, $t0	
	j Fatorial

Fatorial1:
	ble $t0, 0, Fatorial0
	mul $t1, $t1, $t0
	jr $ra

 Fatorial0:
 	 li $t1, 1
 	 jr $ra

EXIT:
	j EXIT