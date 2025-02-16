;
; lab2inlab.asm
;
; Created: 2/11/2025 2:10:05 PM
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

mitabla: .DB 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6D, 0x7D, 0x07, 0x7f, 0x67, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71

SETUP:
LDI R16, (1 << CLKPCE)
STS CLKPR, R16 // Habilitar cambio de PRESCALER
LDI R16, 0b00000100
STS CLKPR, R16 // Configurar Prescaler a 16 F_cpu = 1MHz

CALL INIT_TMR0

LDI R16, 0x00
OUT DDRC, R16 //PORTC COMO ENTRADA
LDI R16, 0xff
OUT DDRD, R16 //PORTD COMO SALIDA
OUT DDRB, R16
OUT PORTC, R16 //PORTC COMO PULL UP

LDI R16, 0x00
LDI R17, 0xff
LDI R18, 0x00
LDI R21, 0xff
LDI R22, 0X00
LDI ZL, LOW(mitabla<<1)
LDI ZH, HIGH(mitabla<<1)
LPM R20, Z
EOR R20, R21
OUT PORTD, R20
OUT PORTB, R16 //Salida inicialmente apagada

LOOP:
IN R16, PINC
IN R19, TIFR0
SBRS R19, TOV0
JMP RESTO
JMP CONTER
RESTO:
CP R17, R16
BREQ LOOP
CALL DELAY
IN R16, PINC
CP R17, R16
BREQ LOOP
MOV R17, R16

SBIS PINC, 0
CALL INCRE
SBIS PINC, 1
CALL DECRE
LPM R20, Z
EOR R20, R21
OUT PORTD, R20
OUT TIFR0, R19
CP R18, R22
BRNE mainend1
LDI R22, 0x00
CBI PORTB, PB0
CBI PORTB, PB1
CBI PORTB, PB2
CBI PORTB, PB3
SBI PINB, PB4
mainend1:
JMP LOOP

CONTER:
SBI TIFR0, TOV0 // Limpiar bandera de "overflow"
LDI R16, 100
OUT TCNT0, R16 // Volver a cargar valor inicial en TCNT0
INC COUNTER
CPI COUNTER, 100 // R20 = 50 after 500ms (since TCNT0 is set to 10 ms)
BRNE LOOP
CLR COUNTER
OUT PINB, R22
INC R22
ANDI R22, 0X0F
OUT PINB, R22
CP R18, R22
BRNE mainend2
LDI R22, 0x00
CBI PORTB, PB0
CBI PORTB, PB1
CBI PORTB, PB2
CBI PORTB, PB3
SBI PINB, PB4
mainend2:
RJMP LOOP


INCRE:
ADIW Z, 1
INC R18
ANDI R18, 0x0F
BRNE end1
LDI ZL, LOW(mitabla<<1)
LDI ZH, HIGH(mitabla<<1)
end1:
ret

DECRE:
SBIW Z, 1
DEC R18
ANDI R18, 0x0F
CPI R18, 0x0F
BRNE end2
ADIW Z, 16
end2:
ret


INIT_TMR0:
LDI R16, (1<<CS01) | (1<<CS00)
OUT TCCR0B, R16 // Setear prescaler del TIMER 0 a 64
LDI R16, 100
OUT TCNT0, R16 // Cargar valor inicial en TCNT0
RET


DELAY:
    LDI     R19, 0
SUBDELAY1:
    INC     R19
    CPI     R19, 0
    BRNE    SUBDELAY1
    LDI     R19, 0
SUBDELAY2:
    INC     R19
    CPI     R19, 0
    BRNE    SUBDELAY2
    LDI     R19, 0
SUBDELAY3:
    INC     R19
    CPI     R19, 0
    BRNE    SUBDELAY3
    RET