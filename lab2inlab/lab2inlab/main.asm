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
/****************************************/
// Configuraci n de la pila?
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R16, HIGH(RAMEND)
OUT SPH, R16
/****************************************/
mitabla: .DB 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6D, 0x7D, 0x07, 0x7f, 0x67, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71

SETUP:
LDI R16, 0x00
OUT DDRC, R16 //PORTC COMO ENTRADA
LDI R16, 0xff
OUT DDRD, R16 //PORTD COMO SALIDA
OUT PORTC, R16 //PORTC COMO PULL UP
LDI R16, 0x00
LDI R17, 0xff
LDI R18, 0x00
LDI R21, 0xff
LDI ZL, LOW(mitabla<<1)
LDI ZH, HIGH(mitabla<<1)
LPM R20, Z
EOR R20, R21
OUT PORTD, R20

LOOP:
IN R16, PINC
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
JMP LOOP

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
	    LDI     R19, 0
	SUBDELAY4:
    INC     R19
    CPI     R19, 0
    BRNE    SUBDELAY4
    RET