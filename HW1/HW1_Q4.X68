*-----------------------------------------------------------
* Title      :HW1 - Question 4.3
* Written by :Tyler Quayle
* Date       :April 14, 2016
* Description:Add -102 and -87 as Hexadecimals to Address $5000
*-----------------------------------------------------------
data1   EQU $FF9A   *-102
data2   EQU $FFA9   *-87
addr1   EQU $5000
    ORG    $1000
START:                  ; first instruction of program

    MOVE.W  #data1, D1  *Load data1(FF9A) into D1
    MOVE.W  #data2, D2  *Load data2(FFA9) into D2
    ADD.W   D2, D1      *ADD D1 and D2, put result in D2
    BCS OVERFLOWERR     *If carry flag is set, branch to OVERFLOWERR
DISPLAY    
    MOVEA.W #addr1, A1  *Load addr1(5000) into A1    
    MOVE.W  D1, (A1)    *Move result into A0 ($5000) 
    MOVE.B  #3, D0      *Task 3 for Trap 15 (displays as decimal)
    TRAP    #15         *Display whatever is in A1            
    
    SIMHALT             ; halt simulator

OVERFLOWERR *OVER FLOW ERROR FOUND
    LEA overflmsg, A1   *Give Address A1 the Error msg
    MOVE.B  #14, D0     *Task 14 for TRAP 15
    TRAP #15            *Display Error Msg
    JMP DISPLAY         *Jump back up and display result

CR  EQU $0D             ;ASCII code for Carriage Return
LF  EQU $0A             ;ASCII code for Line Feed
overflmsg DC.B 'Overflow Occured',CR,LF,0
* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
