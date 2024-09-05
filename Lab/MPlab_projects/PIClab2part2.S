#include <xc.h>
#include "configbits.c"
    .global main
.ent main
main:
    
    la $10, ANSELB
    sw $0 ,0($10)// ANSELB = 0x0000
    
    la $10, TRISB 
    ori $11 ,$0, 0x0000
    sw $11, 0($10)// TRISB = 0x0000

    la $12, PORTB 
    la $14, LATB
    add $15,$0,$0 //counter
    addi $9,$0,0x0009
    addi $1,$0,0x0001
    addi $4,$0,0x0004
    addi $3,$0,0x0003
    addi $7,$0,0x0007
    addi $2,$0,0x0002
    addi $5,$0,0x0005
    addi $6,$0,0x0006
    addi $8,$0,0x0008
    lui $16, 0x0000
    ori $16,$16,0x0300
    add $17,$0,$0
    loop:
    addi $13,$0,0x0806  //1
    sw $13,0($14)
    add $20,$0,$0
    loop2:
    addi $20,$20,0x0001
    beq $20,$16,next
    j loop2
    next:
    addi $21,$0,0x046D //5: 01101101	
    sw $21,0($14)
     add $20,$0,$0
    loop3:
    addi $20,$20,0x0001
    beq $20,$16,next2
    j loop3
    next2:
    addi $22,$0,0x023f  //0: 00111111
    sw $22,0($14)
     add $20,$0,$0
    loop4:
    addi $20,$20,0x0001
    beq $20,$16,next3
    j loop4
    next3:
    addi $23,$0,0x013f //0:
    sw $23,0($14)
     add $20,$0,$0
    loop5:
    addi $20,$20,0x0001
    beq $20,$16,next4
    j loop5
	next4:
    j loop
    
.end main