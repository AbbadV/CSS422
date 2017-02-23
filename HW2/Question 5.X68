*-----------------------------------------------------------
* Title      : Decode a Floating Point Number
* Written by : Tyler Quayle
* Date       : April 22, 2016
* Description: Given 32-Bit Floating point Hexadecimal, give sign, exponent, mantissa
*-----------------------------------------------------------
SignBit     EQU $580
Exponent    EQU $582
Mantissa    EQU $584
    ORG    $400
START:                  ; first instruction of program

* Put program code here
    LEA     InMsg, A1   * Insert Msg to prompt user into A1 for display
    MOVE.B  #14, D0     * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF
    TRAP    #15         * Display Prompt
    MOVE.B  #2, D0      * Task 2 for Trap 15, Read in String
    TRAP    #15         * Get User input

    MOVEA.L #$56A, A5   * Give A5 Starting Address   
    MOVE.B  #9, D2      * D2 used for Looping 8 times 

CONVERT * For(D2 = 8, D2 > 0, D2--)  
    MOVE.B  (A1)+,D4    * Give D4 first Byte of user input, then increment
    
    SUB.B   #1, D2      * For Loop decrement
    CMP.B   #0, D2      * Check for end of For-Loop
    BEQ     MOVEBITS    * Conversion Done, Go To Movebits
 
    CMP.B   #$40, D4    * Compare if D4 contains greater than $40 (A = $41, B = $42)
    BGT     CONV_LETTER * Letter Possibly Found, go to Conv_Letter to Confirm
    
    CMP.B   #$3A, D4    * Compare D4 if less than $3A (Hex for :) (9 = $39, 8 = $38) 
    BLT     CONV_NUMBER * Number possibly Found, go to Conv_Number to Confirm
    
CONV_LETTER
    CMP.B   #$46, D4    * Check to see if D4 falls within $41-$46 (A-F)
    BGT     MISSING     * Not $41-$46 (HEX A-F), Bad/No Data, Jump to Missing
    SUB.B   #$37, D4    * Subtract $37, to convert (ASCII->HEX)
    MOVE.B  D4, (A5)+   * Give current A5 the D4 hex value and Increment
    BRA CONVERT         * Successfully Convert (ASCII->HEX), Branch back to Convert Loop

CONV_NUMBER
    CMP.B   #$30, D4    * Check to see if D4 falls within $30-$39 (0-9)    
    BLT     MISSING     * Not $30-$39 (HEX 0-9), Bad/No Data, Jump to Missing
    SUB.B   #$30, D4    * Subtract $30, to convert (ASCII->HEX)
    MOVE.B  D4, (A5)+   * Give current A5 the D4 hex value and Increment
    BRA CONVERT         * Successfully Convert (ASCII->HEX), Branch back to Convert Loop

MISSING * Here in case user did not enter 8 numbers, 'fills' rest with 0's
    MOVE.B  #$00, (A5)+ * Give Current address Byte value $00, increment A5
    BRA CONVERT         * Branch back to Convert Loop

MOVEBITS
    MOVEA.L #$56A, A5   * Reset A5 to starting address
    MOVE.B  #5, D2      * Give D2 $5, used in MOVELOOP logic

MOVELOOP * For(D2 = 5, D2 > 0, D2--)
    SUB.B   #1, D2      * For Loop decrement
    CMP.B   #0, D2      * Check if conditions have been met
    BEQ     FINDSIGN    * Bit moving done, D4 Now contains correct 32-Bit Hex
    MOVE.B (A5)+, D3    * Move Current Byte into D3
    LSL.L   #4, D3      * Logical Shift Bits 1 Nibble Left (0X->X0)
    ADD.B  (A5)+,D3     * Add next Byte into Bit Shifted D3(XX)
    LSL.L   #8, D4      * Logical Shift D4 1 Byte (00XX->XX00)
    ADD.B   D3, D4      * Add D3 Byte to D4 (XXXX)
    BRA MOVELOOP        * Repeat Loop
    
FINDSIGN
    MOVE.L  D4, D3          * Move D4(User Hex Value) into D3 for manipulation
    MOVE.B  #31, D2         * Move 31 into D2, used for Following Logic Shift 
    LSL.L   D2, D3          * Logic-Shift-Left 31, leaving only MSB
    MOVE.B  #$2D, SignBit   * Default to $2D (Hex for '-')
    CMP.B   #$1, D3         * Compare D3 to 1 (check for negative input)
    BEQ     FINDEXP         * If MSB was negative, continue
    MOVE.B  #$2B, SignBit   * MSB was 0, change Sign to $2B (Hex for '+')
FINDEXP
    MOVE.L  D4, D3          * Move D4(User Hex Value) into D3 for manipulation
    BCLR.L  #31, D3         * Clear MSB
    MOVE.B  #23, D2         * Move 23 into D2, 
    LSR.L   D2, D3          * Logic-Shift-Right 23 || Get rid of Mantissa
    MOVE.W  D3, Exponent    * Give variable Exponent the value in D3
FINDMAN
    MOVE.L  D4, D3          * Move D4(User Hex Value) into D3 for manipulation
    MOVE.B  #9, D2          * Move 9 into D2, Used for Following Logic Shift
    LSL.L   D2, D3          * Logic-Shift-Left 9,
    MOVE.B  #28, D2         * Move 28 into D2, Used for following logic shift
    LSR.L   D2, D3          * Logic-Shift-Right 28, moving first 4 bits of decimals into D3.B
    MOVE.W  D3, Mantissa    * Give variable Mantissa value in D3
    
PRINT
    LEA     OutSig, A1      * Load OutSig message into A1 for display
    MOVE.B  #14, D0         * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF
    TRAP    #15             * Display OutSig (Sign) message
    MOVE.B  SignBit, D1     * Move variable SignBit into D1 for display
    MOVE.B  #6, D0          * Task 6, Trap 15 - Display Single Char in D1 (Hex code for +/-)
    TRAP    #15             * Display char in D1, Hex value for either '+' or '-'
    
    LEA     OutExp, A1      * Load OutExp message into A1 for display
    MOVE.B  #14, D0         * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF      
    TRAP    #15             * Display OutExp (Exponent) message
    MOVE.W  Exponent, D1    * Move variable Exponent into D1 for display
    MOVE.B  #3, D0          * Task 3, Trap 15 - Display Value in D1 as Decimal
    TRAP    #15             * Display variable Exponent
    
    LEA     OutMan, A1      * Load OutMan message into A1 for display
    MOVE.B  #14, D0         * Task 14, Trap 15 - Display NULL terminate Sting, no CR/LF
    TRAP    #15             * Display OutMan
    MOVE.W  Mantissa, D1    * Move variable Mantissa into D1 for display
    MOVE.B  #3, D0          * Task 3, Trap 15 - Display Value in D1 as Decimal
    TRAP    #15             * Display variable mantissa
 
    SIMHALT             ; halt simulator

*---------OutPut Values--------------------------------------------------------
CR      EQU $0D             ;ASCII code for Carriage Return
LF      EQU $0A             ;ASCII code for Line Feed
InMsg   DC.B CR,'Please enter IEEE 32-bit floating point number in hexadecimal: ' ,0
OutSig  DC.B CR, LF,'Sign Bit: ',0
OutExp  DC.B CR, LF,'Exponent: ',0
OutMan  DC.B CR, LF,'Mantissa: ',0

* Put variables and constants here

    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
