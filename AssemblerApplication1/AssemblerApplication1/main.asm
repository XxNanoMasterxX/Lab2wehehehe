;
; AssemblerApplication1.asm
;
; Created: 2/13/2025 3:10:10 PM
; Author : laloj
;
.include "M38PDEF.inc"

.cseg
.org 0x0000
	JMP START
.org OC0Aa
	JMP TMR0_ISR

	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	LDI R16, HIGH(RAMEND)
	OUT SPG, R16

	SETUP:
	CLI

	LDI R16, (1 << CLKPCE)
	STS CLKPR, R16
	LDI R16, 0x04
	STS CLKPR, R16

	// INICIALIZAR TEMPORIZADOR
	LDI R16, (1 << CS01) | (1 << CS00)
	OUT TCCR0B, R16
	LDI R16, 100
	OUT RCNT0, R16

	//
	LDI R16, (1 << TOIE0)
	STS TIMSK0, R16

	SBI DDRB, PB5
	SBI DDRB, PB0
	CBI PORTB, PB5
	CBI PORTB, PB0

	LDI R20, 0
	SEI
	
MAIN_LOOP:
	CPI R20, 50
	BRNE MAIN_LOOP
	CLR R20
	SBI PINB, PB5

; Replace with your application code
start:
    inc r16
    rjmp start
