.text
.globl main
main:
	
	jal Coeficientes
	move $s0, $v0			#Registra a
	jal Coeficientes
	move $s1, $v0			#Registra b
	jal Calcular_Raiz
	
	jal Imprime_Inteiro
	
	j EXIT
	
Coeficientes:		
	li $v0, 5			# Comando
	syscall				# Le os coeficientes
	jr $ra	
	
Calcular_Raiz:
	not $s1, $s1 
	addi $s1, $s1, 1  
	div $s2, $s1, $s0  
	move $a0, $s2
	jr $ra 
	
Imprime_Inteiro:
	li $v0, 1 
	syscall
	jr $ra


EXIT:
	j EXIT
	
	 
