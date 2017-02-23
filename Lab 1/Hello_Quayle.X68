*-----------------------------------------------------------
* Title      : Hello World
* Written by : Tyler Quayle
* Date       : 4/11/2016   
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    LEA MESSAGE, A1
    MOVE.B #14, D0
    TRAP #15
    
    MOVE.B #9, D0
    TRAP #15
CR  EQU $0D             ;ASCII code for Carriage Return
LF  EQU $0A             ;ASCII code for Line Feed
MESSAGE DC.B 'Hello, My Name is Tyler Quayle', CR, LF
        DC.B 'This program took anywhere from 2 minutes to 10 minutes',CR,LF
        DC.B CR,LF
        DC.B 'Thank you for listening', 0
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
