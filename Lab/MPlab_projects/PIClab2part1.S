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
    lui $16, 0x002f
    ori $16,$16,0xf000
    add $17,$0,$0
    loop:
    	div $15,$8
	mfhi $15
	//lw $13 ,0($14) 
	addi $13,$0,0x0100
	beq $15,$0,nine
	beq $15,$1,nine
	beq $15,$2,one
	beq $15,$3,zero1
	beq $15,$4,one
	beq $15,$5,four
	beq $15,$6,seven
	beq $15,$7,three
	
	nine:
	addi $13,$13,0x006f //01101111
	j out
	
	seven:
	addi $13,$13,0x0007  //00000111
	j out
	
	four:
	addi $13,$13,0x0066  //01100110
	j out
	
	three:
	addi $13,$13,0x004f  //01001111
	j out
	
	one:
	addi $13,$13,0x0006  //00000110
	j out
	
	zero1:
	addi $13,$13,0x003f  //00111111
	j out
	
	out:
	addi $15,$15,0x0001 //counter
	loop2:
	    addi $17,$17,0x0001 
	    sw $13,0($14)
	    beq $17,$16,afterLoop
	j loop2
	
	afterLoop:
	    add $17,$0,$0
	
    j loop
    
.end main