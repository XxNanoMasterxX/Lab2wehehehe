;
; lab2.asm
;
; Created: 2/11/2025 9:14:54 AM
; Author : laloj
;


// Encabezado (Definici n de Registros, Variables y Constantes)?
.include "M328PDEF.inc" // Include definitions specific to ATMega328P
.cseg
.org 0x0000
.def COUNTER = R20
/****************************************/
// Configuraci n de la pila?
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R16, HIGH(RAMEND)
OUT SPH, R16
/****************************************/

SETUP:
// Configurar Prescaler "Principal"
LDI R16, (1 << CLKPCE)
STS CLKPR, R16 // Habilitar cambio de PRESCALER
LDI R16, 0b00000100
STS CLKPR, R16 // Configurar Prescaler a 16 F_cpu = 1MHz
// Inicializar timer0
CALL INIT_TMR0
// Deshabilitar serial (esto apaga los dem s LEDs del Arduino)?
LDI R16, 0x00
STS UCSR0B, R16
; Aqui dejo de compiar a pedro gracias pedro te apreciamos mucho pedro

// Setup de los pins
LDI R16, 0xff
OUT DDRB, R16 // se establece el portd como salida
IN R16, PORTD
OUT PORTB, R16
LDI R16, 0x00
OUT PORTb, R16 //Salida inicialmente apagada
LDI R17, 0x00

LDI COUNTER, 0x00

LOOP:
IN R16, TIFR0
SBRS R16, TOV0
RJMP LOOP
SBI TIFR0, TOV0 // Limpiar bandera de "overflow"
LDI R16, 100
OUT TCNT0, R16 // Volver a cargar valor inicial en TCNT0
INC COUNTER
CPI COUNTER, 50 // R20 = 50 after 500ms (since TCNT0 is set to 10 ms)
BRNE LOOP
CLR COUNTER
OUT PINB, R17
INC R17
ANDI R17, 0X0F
OUT PINB, R17
RJMP LOOP






INIT_TMR0:
LDI R16, (1<<CS01) | (1<<CS00)
OUT TCCR0B, R16 // Setear prescaler del TIMER 0 a 64
LDI R16, 100
OUT TCNT0, R16 // Cargar valor inicial en TCNT0
RET
