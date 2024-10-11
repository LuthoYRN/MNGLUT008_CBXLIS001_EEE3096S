/*
 * assembly.s
 *
 */
 
 @ DO NOT EDIT
	.syntax unified
    .text
    .global ASM_Main
    .thumb_func

@ DO NOT EDIT
vectors:
	.word 0x20002000
	.word ASM_Main + 1

@ DO NOT EDIT label ASM_Main
ASM_Main:

	@ Some code is given below for you to start with
	LDR R0, RCC_BASE  		@ Enable clock for GPIOA and B by setting bit 17 and 18 in RCC_AHBENR
	LDR R1, [R0, #0x14]
	LDR R2, AHBENR_GPIOAB	@ AHBENR_GPIOAB is defined under LITERALS at the end of the code
	ORRS R1, R1, R2
	STR R1, [R0, #0x14]

	LDR R0, GPIOA_BASE		@ Enable pull-up resistors for pushbuttons
	MOVS R1, #0b01010101
	STR R1, [R0, #0x0C]
	LDR R1, GPIOB_BASE  	@ Set pins connected to LEDs to outputs
	LDR R2, MODER_OUTPUT
	STR R2, [R1, #0]
	MOVS R2, #0         	@ NOTE: R2 will be dedicated to holding the value on the LEDs

@ TODO: Add code, labels and logic for button checks and LED patterns

main_loop:
	LDR R5, GPIOA_BASE		  @ GPIOA BASE
    LDR R3, [R5, #0x10]       @ Reading input data register (IDR)
	
	MOVS R5, #0b00000011      @ Set R5 to 0b00000010 (mask for bit 1 - SW0)
    TST R3, R5                @ Test bit 1 by ANDing R3 and R5; sets condition flags
    BEQ sw0_sw1_pressed       @ If Z flag is set, SW0 is pressed

	MOVS R5, #0b00000001      @ Set R5 to 0b00000010 (mask for bit 1 - SW0)
    TST R3, R5                @ Test bit 1 by ANDing R3 and R5; sets condition flags
    BEQ sw0_pressed           @ If Z flag is set, SW0 is pressed

    MOVS R5, #0b00000010      @ Set R5 to 0b00000010 (mask for bit 1 - SW0)
    TST R3, R5                @ Test bit 1 by ANDing R3 and R5; sets condition flags
    BEQ sw1_pressed           @ If Z flag is set, SW0 is pressed

	MOVS R5, #0b00000100      @ Set R5 to 0b00000010 (mask for bit 1 - SW0)
    TST R3, R5                @ Test bit 1 by ANDing R3 and R5; sets condition flags
    BEQ sw2_pressed           @ If Z flag is set, SW0 is pressed

    MOVS R5, #0b00001000      @ Set R5 to 0b00000010 (mask for bit 1 - SW0)
    TST R3, R5                @ Test bit 1 by ANDing R3 and R5; sets condition flags
    BEQ sw3_pressed           @ If Z flag is set, SW0 is pressed

    B no_button_pressed

    B main_loop               @ Loop back to the start if no match

write_leds:
	STR R2, [R1, #0x14]
	B main_loop

@ LITERALS; DO NOT EDIT
	.align
RCC_BASE: 			.word 0x40021000
AHBENR_GPIOAB: 		.word 0b1100000000000000000
GPIOA_BASE:  		.word 0x48000000
GPIOB_BASE:  		.word 0x48000400
MODER_OUTPUT: 		.word 0x5555

@ TODO: Add your own values for these delays
LONG_DELAY_CNT: 	.word 0
SHORT_DELAY_CNT: 	.word 0
