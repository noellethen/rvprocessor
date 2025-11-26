#----------------------------------------------------------------------------------
#-- (c) Rajesh Panicker
#--	License terms :
#--	You are free to use this code as long as you
#--		(i) DO NOT post it on any public repository;
#--		(ii) use it only for educational purposes;
#--		(iii) accept the responsibility to ensure that your implementation does not violate anyone's intellectual property.
#--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
#--		(v) send an email to rajesh<dot>panicker<at>ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
#--		(vi) retain this notice in this file and any files derived from this.
#----------------------------------------------------------------------------------

# This sample program for RISC-V simulation using RARS

.eqv MMIO_BASE 0xFFFF0000

# Memory-mapped peripheral register offsets
.eqv UART_RX_VALID_OFF 		0x00 #RO, status bit
.eqv UART_RX_OFF			0x04 #RO
.eqv UART_TX_READY_OFF		0x08 #RO, status bit
.eqv UART_TX_OFF			0x0C #WO
.eqv OLED_COL_OFF			0x20 #WO
.eqv OLED_ROW_OFF			0x24 #WO
.eqv OLED_DATA_OFF			0x28 #WO
.eqv OLED_CTRL_OFF			0x2C #WO
.eqv ACCEL_DATA_OFF			0x40 #RO
.eqv ACCEL_DREADY_OFF	    0x44 #RO, status bit
.eqv DIP_OFF				0x64 #RO
.eqv PB_OFF				    0x68 #RO
.eqv LED_OFF				0x60 #WO
.eqv SEVENSEG_OFF			0x80 #WO
.eqv CYCLECOUNT_OFF			0xA0 #RO

# ------- <code memory (Instruction Memory ROM) begins>
.text	## IROM segment: IROM_BASE to IROM_BASE+2^IROM_DEPTH_BITS-1
# Total number of real instructions should not exceed 2^IROM_DEPTH_BITS/4 (127 excluding the last line 'halt B halt' if IROM_DEPTH_BITS=9).
# Pseudoinstructions (e.g., li, la) may be implemented using more than one actual instruction. See the assembled code in the Execute tab of RARS.

# You can also use the actual register numbers directly. For example, instead of s1, you can write x9

# Load DIP as 20 to test

main:
    # Setup
    nop
    lw s5, delay_val
    addi s6, x0, 0x8
    addi s8, x0, 0x40
    li s0, MMIO_BASE
    addi s1, s0, LED_OFF
    addi s2, s0, DIP_OFF
    addi s11, s0, SEVENSEG_OFF
    
    
    # Mem to mem copy
    lw s3, (s2)
    sw s3, (s1)
    
    
    # Data forwarding
    add s8, s8, s5
    sub s4, s8, s6
    # result is s4 = 40 + 32 - 8 = 6a

    
    #  Read after write -> W to D Forwarding
    add s9, s5, s5
    add s7, s9, s6
    # result is s7 = 32 + 32 + 8 = 6c
    
    
    # Load and use
    lw s3, (s2)
    xor s10, s3, s6
    # supposed to stall
    # result is s10 = DIP + 8 = 28
    
    
    # Loop branch prediction
    addi, s4, x0, 0x10
    
loop:
    addi s4, s4, -1
    bne, s4, x0, loop
    # Predicted behaviour: NNYYYYYYYN    
    
    # Testing jal and jalr
    jal hello
    nop
    nop
    nop
    
    
# ---------------- START OF COUNTDOWN ---------------- #
    
init_dot:
    addi s5, x0, 0xFFFFFFFF
    sw s5, (s11)
    
# Moving right
    
delay:
    lw s6, dot_delay_val
    lw s3, (s2)
    mul s6, s6, s3
    addi s6, s6, 1
loop_decrease:
    addi, s6, s6, -1
    bne s6, x0, loop_decrease
    
count_down_seven_seg:
    addi s5 s5, -1
    sw s5, (s11)
    bne s5, x0, delay
        
# ---------------- END OF COUTNDOWN ---------------- #

   addi s7, x0, 8
   add s8, s7, s7

hello:
    ret # compiled as jalr
    addi s9, x0, 10
    add s10, s9, s9
    add s4, s9, s10
  

halt:
    j halt 
    
# s0: MMIO BASE, repurposed to led value
# s1: LED addr
# s2: push button addr
# s3: DIP address
# s4 seven seg address
# s5: short delay value for leds
# s6: long delay val
# s8: reserved reg for dip val to do shifting and stuff
# s11: reference dip from last cycle 

				
# ------- <code memory (Instruction Memory ROM) ends>			
				
								
#------- <Data Memory begins>									
.data  ## DMEM segment: DMEM_BASE to DMEM_BASE+2^DMEM_DEPTH_BITS-1
# Total number of constants+variables should not exceed 2^DMEM_DEPTH_BITS/4 (128 if DMEM_DEPTH_BITS=9).

DMEM:

delay_val: .word 50	# a constant, at location DMEM+0x00

dot_delay_val: .word 10

half_second_delay_val: .word 260416	# a constant, at location DMEM+0x00

string1:
.asciz "\r\nWelcome to CG3207..\r\n"	# string, from DMEM+0x4 to DMEM+0x1F (including null character).
var1: .word	1 		# a statically allocated variable (which can have an initial value, say 1), at location DMEM+0x60
# Food for thought: What will be the address of var1 if string1 had one extra character, say  "..." instead of ".."? Hint: words are word-aligned.

.align 9	# To set the address at this point to be 512-byte aligned, i.e., DMEM+0x200
STACK_INIT:	# Stack pointer can be initialised to this location - DMEM+0x200 (i.e., the address of stack_top)
			# stack grows downwards, so stack pointer should be decremented when pushing and incremented when popping.Stack can be used for function calls and local variables.
		# Not allocating any heap, as it is unlikely to be used in this simple program. If we need dynamic memory allocation,we need to allocate memory and imeplement a heap manager.
#------- <Data Memory ends>													