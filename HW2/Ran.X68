*-----------------------------------------------------------
* Description: Gets hex user input digits, coverts them to
*              the corresponding numerical value, and then
*              converts the value into decimal digits.
*              - No error checking.
*              - Three hex digits max.
*-----------------------------------------------------------
        ORG     $1000      ; Start of code memory.
START:  JSR     PROMPT     ; Display an indication to enter hex digits in window.
        JSR     GETCHR     ; Start a loop to wait for and read hex digits.
        JSR     DETVAL     ; Determine the value of all the digits interpreted as a single value.
        JSR     TODEC      ; Convert to decimal characters.
        JSR     PRTDEC     ; Display the decimal digits to the screen.
        JMP     FIN
   
PROMPT: LEA     STROUT, A1 ; Load the user prompt address into A1.
        MOVE.B  #14, D0    ; Select subroutine to display a string to user.
        TRAP    #15        ; Start the subroutine to display the prompt.
        RTS
   
GETCHR: LEA     INPUT, A1  ; Store the address to write the results to in A1.
        MOVE.B  #0, D2     ; Count the number of digits processed.
NXTCHR: MOVE    #5, D0     ; Select the subroutine to read a character from the keyboard.
        TRAP    #15        ; Start the character input subroutine.
        CMP.B   #13, D1    ; The character is placed into the LSB of D1.
        BEQ     GCDONE     ; End if the <Return> key was pressed.
        JSR     HX2BIN     ; Jump to the subroutine to check and convert hex digits.
        JMP     NXTCHR     ; Read the next character.
GCDONE: RTS
   
HX2BIN: CMP.B   #57, D1    ; See if the digit is in the range or 0-9 or a-f.
        BLE.B   LTE9       ; If the difference is less than or equal to 0, it's 0-9
        SUB.B   #87, D1    ; 'a' is decimal 97, subtract 87 for decimal values a-f.
        JMP     STORE      ;
LTE9:   SUB.B   #48, D1    ; '0' is decimal 48, subtract 48 for decimal values 0-9.
STORE:  MOVE.B  D1,(A1)+   ; Write the converted value to memory starting at $2000.
        ADD     #1, D2     ; Increment the count of hex digits read.
        RTS                ; We've completed this character, see if there's more to do.
   
DETVAL: MOVE.L  #0, D3     ; Use D3 to hold the total value.
        MOVE.L  #16, D4    ; Use D4 to multiply by 16.
        MOVE.B  -(A1),D3   ; Get the least significant byte.
NXTDIG: SUB.B   #1, D2     ; Decrement the counter by one.
        CMP.B   #0, D2     ; See if there are any more digits to process.
        BEQ     DVDONE
        MOVE.B  -(A1),D5   ; Get the next hex digit.
        MULU    D4, D5     ; Multiply it by the power of 16 corresponding to the digit position.
        ADD.L   D5, D3     ; Total the current digit with the sum so far.
        MULU    #16, D4    ; Increase the hex digit multiplying power.
        BRA     NXTDIG     ; See if there are any more digits to process.
DVDONE: RTS

TODEC:  LEA     DECHRS, A1 ;
        MOVE.L  #0, D5     ; Our counter for decimal digits.
        MOVE    D3, D4     ; Make a copy of the total value.
NXTDEC: MOVE    D4, D1     ;   
        CMP.L   #0, D4     ; Stop when there are no more digits left to process.
        BLE     TDDONE     ;
        DIVU    #10, D4
        MULU    #10, D4
        SUB.W   D4, D1     ;
        ADD.W   #48, D1    ; Convert the value to the corresponding character.
        MOVE.B  D1,(A1)+   ; Store the decimal character.
        DIVU    #10, D4    ; Find the next decimal digit.
        ADD     #1, D5     ; Increment the decimal digit counter.
        BRA     NXTDEC
TDDONE: RTS

PRTDEC: MOVE.B  -(A1),D1   ; Get a decimal character.
        MOVE.B  #6, D0     ; Set up the print character to output subroutine.
        TRAP    #15        ; Print it.
        SUB.B   #1, D5     ; Decrement the counter.
        CMP.B   #0, D5     ; See if we're done.
        BNE     PRTDEC     ; If not, process the next character.
        RTS
      
FIN:    MOVE.B  #9,D0      ; This is the code for halting the simulator.
        TRAP     #15       ; Halt the simulator. TRAP calls the O/S.

* Variables and Strings
        ORG     $2000      ; Start of data memory.
INPUT:  DS.B    16         ; Converted values are written here.
DECHRS: DS.B    16         ; Decimal character representation of number.
STROUT: DC.B    'Input Hex Digits > ',0  ; Text for user prompt.

        END     START      ; End of program.   
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
