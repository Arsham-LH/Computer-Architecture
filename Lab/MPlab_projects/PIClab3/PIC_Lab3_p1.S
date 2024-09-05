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

//jal InterruptSetup

    la $10, ANSELB
    sw $0 ,0($10)// ANSELB = 0x0000
    
    la $10, TRISB 
    ori $11 ,$0, 0x0000
    sw $11, 0($10)// TRISB = 0x0000

    la $12, PORTB 
    la $14, LATB
    sw $0, 0($14)

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
    lui $16, 0x0010
    ori $16,$16,0x0000
    add $17,$0,$0 //main loop counter
    addi $18,$0,0x0030 //delay final value
    add $20,$0,$0 //delay counter


    loop:
        jal InterruptSetup
    	div $15,$8
	mfhi $15
	//lw $13 ,0($14) 
	//addi $13,$0,0x0100
	la $14, seg
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
	    
	    addi $13,$0,0x046f  //9 at second
	    sw $13,4($14)
	    
	    addi $13,$0,0x0206  //1 at third
	    sw $13,8($14)
	    
	    addi $13,$0,0x013f  //0 at fourth
	    sw $13,12($14)
	    j out
	    
	state1:
	    addi $13,$0,0x086f  //9 at first
	    sw $13,0($14)
	    
	    addi $13,$0,0x0406  //1 at second
	    sw $13,4($14)
	    
	    addi $13,$0,0x023f  //0 at third
	    sw $13,8($14)
	    
	    addi $13,$0,0x0106  //1 at fourth
	    sw $13,12($14)
	    
	    j out
	
	state2:
	    addi $13,$0,0x0806  //1 at first
	    sw $13,0($14)
	    
	    addi $13,$0,0x043f  //0 at second
	    sw $13,4($14)
	    
	    addi $13,$0,0x0206  //1 at third
	    sw $13,8($14)
	    
	    addi $13,$0,0x0166  //4 at fourth
	    sw $13,12($14)
	    j out
	
	
	state3:
	    addi $13,$0,0x083f  //0 at first
	    sw $13,0($14)
	    
	    addi $13,$0,0x0406  //1 at second
	    sw $13,4($14)
	    
	    addi $13,$0,0x0266  //4 at third
	    sw $13,8($14)
	    
	    addi $13,$0,0x0107  //7 at fourth
	    sw $13,12($14)
	    j out
	    
	    state4:
	    addi $13,$0,0x0806  //1 at first
	    sw $13,0($14)
	    
	    addi $13,$0,0x0466  //4 at second
	    sw $13,4($14)
	    
	    addi $13,$0,0x0207  //7 at third
	    sw $13,8($14)
	    
	    addi $13,$0,0x014f  //3 at fourth
	    sw $13,12($14)
	    j out
	    
	    state5:
	    addi $13,$0,0x0866  //4 at first
	    sw $13,0($14)
	    
	    addi $13,$0,0x0407  //7 at second
	    sw $13,4($14)
	    
	    addi $13,$0,0x024f  //3 at third
	    sw $13,8($14)
	    
	    addi $13,$0,0x016f  //9 at fourth
	    sw $13,12($14)    
	    j out
	
	    state6:
	    addi $13,$0,0x0807  //7 at first
	    sw $13,0($14)
	    
	    addi $13,$0,0x044f  //3 at second
	    sw $13,4($14)
	    
	    addi $13,$0,0x026f  //9 at third
	    sw $13,8($14)
	    
	    addi $13,$0,0x016f  //9 at fourth
	    sw $13,12($14)
	    j out 
	    
	    state7:
	    addi $13,$0,0x084f  //3 at first
	    sw $13,0($14)
	    
	    addi $13,$0,0x046f  //9 at second
	    sw $13,4($14)
	    
	    addi $13,$0,0x026f  //9 at third
	    sw $13,8($14)
	    
	    addi $13,$0,0x0106  //1 at fourth
	    sw $13,12($14)
	    j out
	    
	out:
	addi $17,$17,0x0001
	bne $17,$16,out
	addi $15,$15,0x0001 //state counter
	add $17,$0,$0
	j loop
	
	//afterState:
	   // j out
	    


	
  //  j loop
    
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