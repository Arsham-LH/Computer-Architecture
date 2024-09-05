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
    addi $28,$0,0x0001
    addi $4,$0,0x0004
    addi $3,$0,0x0003
    addi $7,$0,0x0007
    addi $2,$0,0x0002
    addi $5,$0,0x0005
    addi $6,$0,0x0006
    addi $27,$0,0x0008
    addi $19,$0,0x000a //10
    addi $21,$0,0x0064 //100
    addi $22,$0,0x03e8 //1000
    lui $16, 0x0000
    ori $16,$16,0x00a0
    add $17,$0,$0 //loop counter
    addi $18,$0,0x0300 //delay final value
    add $20,$0,$0 //delay counter
    addi $8,$0,0x0000 //main loop counter
    addi $30,$0,0x0001
    loop:
	div $8,$22
	mflo $23 //hamino 7seg
	mfhi $24
	div $24,$21
	mflo $24
	mfhi $25
	div $25,$19
	mflo $25
	mfhi $15
	add $26,$0,$23
	jal num27seg
	addi $23,$26,0x0800 //$23=k1
	add $26,$0,$24
	jal num27seg
	addi $24,$26,0x0400 //$24=k2
	add $26,$0,$25
	jal num27seg
	addi $25,$26,0x0200 //$25=k3
	add $26,$0,$15
	jal num27seg
	addi $15,$26,0x0100 //$15=k4
	

	    
	display:
	    add $13,$0,$23  //first digit
	    sw $13,0($14)
	    jal delay
	    
	    add $13,$0,$24  //second digit
	    sw $13,0($14)
	    jal delay
	    
	    add $13,$0,$25  //third digit
	    sw $13,0($14)
	    jal delay
	    
	    add $13,$0,$15  //fourth digit
	    sw $13,0($14)
	    jal delay
	    
	    
	    //addi $18,$0,0xf000
	   // jal delay
	jal out
	//afterState:
    j loop
    
    delay:
    addi $20,$0,0x0000
    loop2:
    addi $20,$20,0x0001
    beq $20,$18,next
    j loop2
    next:
    jr $31

    num27seg:
    //$26 our input
    	beq $26,$0,zero1
	beq $26,$28,one
	beq $26,$2,two
	beq $26,$3,three
	beq $26,$4,four
	beq $26,$5,five
	beq $26,$6,six
	beq $26,$7,seven
	beq $26,$27,eight
	beq $26,$9,nine
	
	zero1:
	    addi $26,$0,0x003f
	    jr $31
	one:
	    addi $26,$0,0x0006
	    jr $31
	two:
	    addi $26,$0,0x005b
	    jr $31
	three:
	    addi $26,$0,0x004f
	    jr $31
	four:
	    addi $26,$0,0x0066
	    jr $31
	five:
	    addi $26,$0,0x006d
	    jr $31 
	six:
	    addi $26,$0,0x007d
	    jr $31
	seven:
	    addi $26,$0,0x0007
	    jr $31
	eight:
	    addi $26,$0,0x007f
	    jr $31
	nine:
	    addi $26,$0,0x006f
	    jr $31


out:
	addi $17,$17,0x0001
	bne $17,$16,display
	add $17,$0,$0
	add $30,$30,$28
	add $8,$0,$30
	jr $31




    

.end main
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	