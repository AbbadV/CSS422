*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
SignBit     EQU $600
Exponent    EQU $620
Mantissa    EQU $630
    ORG    $1000
START:                  ; first instruction of program
    MOVE.L  #$70680000, D4
FINDSIGN
    MOVE.L  D4, D3
    MOVE.B  #31, D2
    LSL.L   D2, D3
    MOVE.B  #$2D, SignBit
    CMP.B   #$1, D3
    BEQ     FINDEXP
    MOVE.B  #$2B, SignBit
FINDEXP
    MOVE.L  D4, D3
    BCLR.L  #31, D3 * Clear MSB
    MOVE.B  #23, D2
    LSR.L   D2, D3
    MOVE.W  D3, Exponent
FINDMAN
    MOVE.L  D4, D3
    MOVE.B  #9, D2
    LSL.L   D2, D3
    LSR.L   D2, D3
    MOVE.B  #19, D2
    LSR.L   D2, D3
    MOVE.L  D3, Mantissa
    
PRINT
    LEA     OutSig, A1
    MOVE.B  #14, D0
    TRAP    #15
    MOVE.B  SignBit, D1
    MOVE.B  #6, D0
    TRAP    #15
    LEA     OutExp, A1
    MOVE.B  #14, D0
    TRAP    #15
    MOVE.W  Exponent, D1
    MOVE.B  #3, D0
    TRAP    #15
    LEA     OutMan, A1
    MOVE.B  #14, D0
    TRAP    #15
    MOVE.W  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
* Put program code here

    SIMHALT             ; halt simulator
CR  EQU $0D             ;ASCII code for Carriage Return
LF  EQU $0A             ;ASCII code for Line Feed
InMsg DC.B CR,'Please enter IEEE 32-bit floating point number in hexadecimal: ' ,0
OutSig DC.B CR, LF,'Sign Bit: ',0
OutExp  DC.B CR, LF,'Exponent: ',0
OutMan  DC.B CR, LF,'Mantissa: ',0
* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
