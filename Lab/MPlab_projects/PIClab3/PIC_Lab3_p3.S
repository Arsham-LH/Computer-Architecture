#include <xc.h>

//You cannot use sp as a general purpose register.

#define TIMER_PERIOD (20000)	// maximum value is 65535, actual rate is 5,000,000/TIMER_PERIOD

#define CT_INT_ON (1)
#define CT_INT_PRIOR_3 (3)

.global main

.data

seg:
.word 0x0000, 0x0000, 0x0000, 0x0000 
//    seg1, seg2, seg3, seg4
InterruptCounter:
.word 0x0000

.text

.ent main 
main:
    la $8, ANSELB
    sw $0 ,0($8)// ANSELB = 0x0000
    
    la $8, ANSELA
    sw $0 ,0($8)// ANSELA = 0x0000

    la $8, TRISB 
    ori $9 ,$0, 0xf000
    sw $9, 0($8)// TRISB = 0xf000

    la $8, TRISA 
    ori $9 ,$0, 0x0000
    sw $9, 0($8)// TRISA = 0x0000

    la $8, PORTB
    la $9, PORTA
    la $10, LATB
    la $11, LATA
    
    addi $2,$0,0x1000 //Address 12
    addi $3,$0,0x2000 //Address 13
    addi $4,$0,0x4000 //Address 14
    addi $5,$0,0x0000 //Address 15
    addi $6,$0,0x0001
    addi $25,$0,0x0100
    addi $26,$0,0x0200
    addi $27,$0,0x0400
    addi $28,$0,0x0800
    addi $22,$0,0x0ED0
    addi $23,$0,0x0080 //cathode address
    addi $18,$0,0x0300
    
    loop:
	//lw $12 ,0($8) //$8 = RB[15]:RB[0]
	//lw $13 ,0($9) //$9 = RA[4]:RA[0]
	add $21,$0,$0 //debouncing counter
	addi $24 , $0, 0x0800
	
	addi $13,$0,0x0001 //RA[0] = 1
	sw $13,0($11) //RA[0] = 1
	nop
	nop
	nop
	nop
	lw $12 ,0($8) //$8 = RB[15]:RB[0]
	
	and $14,$12,$2 //RB[12]
	beq $14,$2,state1
	
	and $14,$12,$3 //RB[13]
	beq $14,$3,state4
	
	and $14,$12,$4 //RB[14]
	beq $14,$4,state7
	
	addi $2,$0,0x1000 
	addi $13,$0,0x0002 //RA[1] = 1
	sw $13,0($11) //RA[1] = 1
	nop
	nop
	nop
	nop
	lw $12 ,0($8) //$8 = RB[15]:RB[0]

	and $14,$12,$2 //RB[12]
	beq $14,$2,state2
	sll $2,$2,1
	
	and $14,$12,$3 //RB[13]
	beq $14,$3,state5
	sll $2,$2,1
	
	and $14,$12,$4 //RB[14]
	beq $14,$4,state8
	sll $2,$2,1
	
	and $14,$12,$2 //RB[15]
	beq $14,$2,state0
	
        addi $2,$0,0x1000 //Address 12
	addi $13,$0,0x0004 //RA[2] = 1
	sw $13,0($11) //RA[2] = 1
        nop
	nop
	nop
	nop
	lw $12 ,0($8) //$8 = RB[15]:RB[0]

	and $14,$12,$2 //RB[12]
	beq $14,$2,state3
	
	
	and $14,$12,$3 //RB[13]
	beq $14,$3,state6
	
	
	and $14,$12,$4 //RB[14]
	beq $14,$4,state9
	
	j go

	state0:
	    addi $15,$0,0x003f  //0 at first
	    beq $5,$0,go
            jal debouncing_loop
	    j output
	state1:
    	    addi $15,$0,0x0006  //1 at first
	    beq $5,$0,go
            jal debouncing_loop
	    j output
	state2:
    	    addi $15,$0,0x005b  //2 at first  0101_1011
	    beq $5,$0,go
            jal debouncing_loop	    
	    j output
	state3:
    	    addi $15,$0,0x004f  //3 at first
	    beq $5,$0,go
            jal debouncing_loop	    
	    j output
	state4:
    	    addi $15,$0,0x0066  //4 at first
	    beq $5,$0,go
	    jal debouncing_loop	    
	    j output
	state5:
    	    addi $15,$0,0x006d  //5 at first 0110_1101
	    beq $5,$0,go
	    jal debouncing_loop	    
	    j output
	state6:
    	    addi $15,$0,0x007d  //6 at first 0111_1101
	    beq $5,$0,go	    
	    jal debouncing_loop
	    add $21,$0,$0
	    jal debouncing_loop
	    j output
	state7:
    	    addi $15,$0,0x0007  //7 at first
	    beq $5,$0,go
	    jal debouncing_loop	    
	    j output
	state8:
    	    addi $15,$0,0x007f  //8 at first
	    beq $5,$0,go
	    jal debouncing_loop	    
	    j output
	state9:
    	    addi $15,$0,0x006f  //9 at first
	    beq $5,$0,go
	    jal debouncing_loop	    	    
	    
	output:
	    sll $23,$23,1
	    addi $6,$0,0x0100
	    beq $23,$6,ka1
	    sll $6,$6,1
	    beq $23,$6,ka2
	    sll $6,$6,1
	    beq $23,$6,ka3
	    sll $6,$6,1
	    beq $23,$6,ka4
	    sll $6,$6,1
	    beq $23,$6,showError
	    j go
	    
	    ka1:
		or $25, $25 , $15
		j go
	    ka2:
		or $26, $26 , $15
		j go
	    ka3:
		or $27, $27 , $15
		j go
	    ka4:
		or $28, $28 , $15
		j go
	    
	    go:


	    andi $12,$12,0xf000 //keep RB[15]:RB[12]
	    bne $12,$0,after_debounceSetting
	    addi $5, $0, 0x0001 //if no button pressed: $5=1
    
    
	    
	    after_debounceSetting:

            
	    
	    show_loop1:
	    sw $25, 0($10)
	    addi $17 , $17, 0x0001
	    bne $17, $18, show_loop1
	    add $17, $0, $0
	    nop
	    nop
	    nop
	    nop
	    
	    show_loop2:
	    sw $26, 0($10)
	    addi $17 , $17, 0x0001
	    bne $17, $18, show_loop2
	    add $17, $0, $0
	    nop
	    nop
	    nop
	    nop	    
	    
	    show_loop3:
	    sw $27, 0($10)
	    addi $17 , $17, 0x0001
	    bne $17, $18, show_loop3
	    add $17, $0, $0
	    nop
	    nop
	    nop
	    nop
	    
	    show_loop4:
	    sw $28, 0($10)
	    addi $17 , $17, 0x0001
	    bne $17, $18, show_loop4
	    add $17, $0, $0

	    loop2:
		//addi $6,$0,0x0001
	        addi $2,$0,0x1000 //Address 12
		

    j loop
    
    showError:
	addi $25, $25 , 0x0080
	j go
    
    debouncing_loop:
	addi $21,$21,0x0001
	bne $21,$22,debouncing_loop
	
	add $5,$0,$0 //no debouncing anymore

	//lw $12 ,0($8) //$8 = RB[15]:RB[0]
	//and $12,$12,0xf000
	jr $31
	
    show_loop:
	
	addi $17 , $17, 0x0001
	bne $17, $18, show_loop
	add $17, $0, $0
	jr $31
    
.end main 

/*********************************************************************
 * This is the actual interrupt handler that gets installed
 * in the interrupt vector table. It jumps to the core-timer
 * interrupt handler function.
 *
 * Note: The ".section .vector_0" is not allocatable. Hence to force
 * this section to be allocatable, use the "ax" directive.
 ********************************************************************/
.section .vector_0,code
   j      CoreTimerIntHandler

/*********************************************************************
 * CoreTimerIntHandler()
 * Interrupt handler function for core-timer. The function
 * clears the interrupt flag, shows one digit on the seven segment board and updates the
 * core-timer registers.
 *
 * pre-condition: A jump to ISR is registered in vector table
 * Input: none
 * Output: none
 * Side effect: shows one digit on the seven segment board
 ********************************************************************/
.text
.ent CoreTimerIntHandler 
CoreTimerIntHandler:
   /* interrupt prologue */
   addiu sp, sp, -20
   sw $1, 0(sp)
   sw t0, 4(sp)
   sw t1, 8(sp)
   
   mfc0 t1, $14          /* read EPC register (program counter at last exeption) */
   sw t1, 12(sp)      /* save EPC on stack */
   
   mfc0 t1, $12         /* read STATUS register */
   sw t1, 16(sp)         /* save STATUS on stack */
   
   mfc0        t0, $13          /* read CAUSE register */
   srl         t0, t0,0xA      /* align RIPL (Requested Interrupt Priority Level) to bit 0 */
   ins         t1, t0, 10, 6      /* insert RIPL to IPL(Interrupt Priority Level) field (copy and replace from 6 LSBs of k0 to k1 starting at bit 10 of k1, k1<15:10> = k0<5:0>) */
   ins         t1, zero, 1, 4	/* k1<4:1> = zero<3:0> */
   mtc0        t1, $12         /* write STATUS register  (status<15:10> = cause<15:10>, status<4:1> = 0)  */
   
   
   /* set up t0 with time period and then call the update core-timer routine for next interrupt. */
   ori     t0, zero, TIMER_PERIOD
   mtc0	   $0, $9   // count register ($9) in coprocessor0 = 0
   mtc0	   t0, $11  // compare register ($11) in coprocessor0 = TIMER_PERIOD
   
   /* clear interrupt flag */
   addiu   t1, zero, 1
   la      t0, IFS0CLR
   sw      t1, 0(t0)	// IFS0<0> = 0
   
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
   la t0, LATBCLR
   addi t1, zero, 0x0fff
   sw t1, 0(t0)
   
   la t1, InterruptCounter
   lw t0, 0(t1)
   addiu t0, t0, 4
   sw t0, 0(t1)	      // InterruptCounter = InterruptCounter + 4
   andi t0, t0, 0xf     // t0 = InterrupCounter%16
   la t1, seg
   add t0, t1, t0       // t0 = seg address + InterrupCounter%16
   
    lw t1, 0(t0)        // t1 = pattern
    andi t1, t1, 0x0fff
    la t0, LATBSET
    sw t1, 0(t0)        // LATB<11:0> = seg<11:0>
      
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
   /* interrupt epilogue */
   di                      /* disable interrupts */
   
   lw t1, 12(sp)      /* restore EPC from stack */
   mtc0 t1, $14
   
   lw t1, 16(sp)         /* restore STATUS from stack */
   mtc0 t1, $12
   
   lw $1, 0(sp)
   lw t0, 4(sp)
   lw t1, 8(sp)
   addiu sp, sp, 20
   
   ei                        /* enable interrupts */
   /* return from interrupt */
   eret        
.end CoreTimerIntHandler
   
 /*********************************************************************
 * InterruptSetup()
 *
 * cause<23> = 1
 * ei
 * count = 0
 * compare = TIMER_PERIOD
 * IFS0CLR<0> = 0
 * IPC0<4:2> = CT_INT_PRIOR_3
 * IEC0<0> = CT_INT_ON
 ********************************************************************/
.ent InterruptSetup
InterruptSetup:
    /* function prologue - save registers used in this function 
     * on stack and adjust stack-pointer
     */
   addiu   sp, sp, -8
   sw      s0, 0(sp)
   sw      s1, 4(sp)

   //INTEnableSystemMultiVectoredInt:
   mfc0    s0, $13
   lui     s1, 0x0080
   or      s0, s0, s1
   mtc0    s0, $13  // bit <23> (IV bit = Interrupt Vector) in the cause register ($13) in coprocessor0 is set
   ei      /* enable system-wide interrupts */
   
   //OpenCoreTimer:
   ori     s0, zero, TIMER_PERIOD  // s0 = TIMER_PERIOD
   mtc0	   $0, $9   // count register ($9) in coprocessor0 = 0
   mtc0	   s0, $11  // compare register ($11) in coprocessor0 = TIMER_PERIOD
   
   //mCTClearIntFlag:
   addiu   s1, zero, 1
   la      s0, IFS0CLR
   sw      s1, 0(s0)	// bit <0> in the Interrupt Flag Status register is cleared
   
   //mCTSetIntPriority:
   addiu   s1, zero, (7 << 2)
   la      s0, IPC0CLR
   sw      s1, 0(s0)
   ori     s0, zero, CT_INT_PRIOR_3 // s0 = CT_INT_PRIOR_3
   sll     s1, s0, 2
   la      s0, IPC0SET
   sw      s1, 0(s0)	// bits <4:2> in the Interrupt Priority Control register (of the core timer interrupt), which are the core timer interrupt priority bits = CT_INT_PRIOR_3
   
   //mCTIntEnable:
   ori     s1, zero, CT_INT_ON	// s1 = CT_INT_ON
   la      s0, IEC0SET
   sw      s1, 0(s0)	// bit <0> in the Interrupt Enable Control register (of the core timer interrupt), which is the core timer interrupt enable bit = CT_INT_ON
   
   /* function epilogue - restore registers used in this function
     * from stack and adjust stack-pointer
     */
   lw      s1, 4(sp)
   lw      s0, 0(sp)
   addiu   sp, sp, 8
   
   /* return to caller */
   jr      ra
.end InterruptSetup