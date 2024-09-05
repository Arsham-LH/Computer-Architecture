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
    addi $8,$0,0x0008
    lui $16, 0x0000
    ori $16,$16,0x3000
    add $17,$0,$0 //main loop counter
    addi $18,$0,0x0030 //delay final value
    add $20,$0,$0 //delay counter

    
    loop:
    	div $15,$8
	mfhi $15
	//lw $13 ,0($14) 
	//addi $13,$0,0x0100
	beq $15,$0,state0
	beq $15,$28,state1
	beq $15,$2,state2
	beq $15,$3,state3
	beq $15,$4,state4
	beq $15,$5,state5
	beq $15,$6,state6
	beq $15,$7,state7
	
	state0:
	    addi $13,$0,0x086f  //9 at first
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x046f  //9 at second
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0206  //1 at third
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x013f  //0 at fourth
	    sw $13,0($14)
	    jal delay
	    
	    j out
	    

	
	
	state1:
	    addi $13,$0,0x086f  //9 at first
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0406  //1 at second
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x023f  //0 at third
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0106  //1 at fourth
	    sw $13,0($14)
	    jal delay
	    
	    j out
	
	    
	    
	state2:
	    addi $13,$0,0x0806  //1 at first
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x043f  //0 at second
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0206  //1 at third
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0166  //4 at fourth
	    sw $13,0($14)
	    jal delay
	    j out
	
	
	state3:
	    addi $13,$0,0x083f  //0 at first
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0406  //1 at second
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0266  //4 at third
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0107  //7 at fourth
	    sw $13,0($14)
	    jal delay
	    
	    j out
	    
	    state4:
	    addi $13,$0,0x0806  //1 at first
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0466  //4 at second
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0207  //7 at third
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x014f  //3 at fourth
	    sw $13,0($14)
	    jal delay
	    
	    j out
	    
	    state5:
	    addi $13,$0,0x0866  //4 at first
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0407  //7 at second
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x024f  //3 at third
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x016f  //9 at fourth
	    sw $13,0($14)
	    jal delay
	    
	    j out
	
	
	    state6:
	    addi $13,$0,0x0807  //7 at first
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x044f  //3 at second
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x026f  //9 at third
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x016f  //9 at fourth
	    sw $13,0($14)
	    jal delay
	    
	    j out

	    
	    
	    state7:
	    addi $13,$0,0x084f  //3 at first
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x046f  //9 at second
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x026f  //9 at third
	    sw $13,0($14)
	    jal delay
	    
	    addi $13,$0,0x0106  //1 at fourth
	    sw $13,0($14)
	    jal delay
	    
	    j out
	    

	    
	    
	
	out:
	addi $17,$17,0x0001
	bne $17,$16,afterState
	addi $15,$15,0x0001 //state counter
	add $17,$0,$0
	afterState:

	
	
    j loop
    
    delay:
    addi $20,$0,0x0000
    loop2:
    addi $20,$20,0x0001
    beq $20,$18,next
    j loop2
    next:
    jr $31

    

.end main