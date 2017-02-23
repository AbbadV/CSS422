*-----------------------------------------------------------
* Title      : Input_branch_quayle
* Written by : Tyler Quayle
* Date       : 4/11/2016
* Description: Easy68k Branching Tutorial
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
*----------- Code for Output-----------------    
LOOP    LEA MESSAGE, A1
        MOVE.B  #14, D0
        TRAP    #15
*----------- Code for Input------------------
        MOVE.B  #4, D0
        TRAP    #15
        CMP.L   #1573052, D1
        BEQ     DONE
        
        CMP.B   #20, D1         * Compare input to 20
        BLT     INVALID         * If less, call invalid
        CMP.B   #25, D1         * Compare input to 25
        BGT     INVALID         * If greater, call invalid
        
*----------- Addition 1 ----------------------
        CMP.B   #20, D1         * Compare D1 to 20 
        BNE     TWENONE         * if not 20, try 21
        LEA     DISTWENTY, A1
        MOVE.B  #14,D0
        TRAP    #15             *Display MSG for 20
        BRA     LOOP

TWENONE CMP.B   #21, D1         *21 Function
        BNE     TWENTWO         *If not 21, try 22
        LEA     DISTWEONE, A1
        MOVE.B  #14,D0
        TRAP    #15             * Display MSG for 21
        BRA     LOOP

TWENTWO CMP.B   #22, D1         *22 Function
        BNE     TWENTHR         *If not 22, Try 23
        LEA     DISTWETWO, A1
        MOVE.B  #14,D0
        TRAP    #15             * Display MSG for 22
        BRA     LOOP

TWENTHR CMP.B   #23, D1         * 23 Function
        BNE     TWENFOU         * If not 23, Try 24
        LEA     DISTWETHR, A1
        MOVE.B  #14,D0
        TRAP    #15             * Display MSG for 23
        BRA     LOOP

TWENFOU CMP.B   #24, D1         * 24 Function
        BNE     TWENFIV         * If not 24, Try 25
        LEA     DISTWEFOU, A1
        MOVE.B  #14,D0
        TRAP    #15             * Display MSG for 24
        BRA     LOOP

TWENFIV CMP.B   #25, D1         * 25 Function
        BNE     LOOP            * If not 25, restart loop
        LEA     DISTWEFIV, A1   
        MOVE.B  #14,D0
        TRAP    #15             * Display MSG for 25
        BRA     LOOP
        
        
DONE    MOVE.B  #9, D0
        TRAP    #15

INVALID LEA     INV, A1
        MOVE.B  #14, D0
        TRAP    #15
        BRA     LOOP

CR  EQU $0D             ;ASCII code for Carriage Return
LF  EQU $0A             ;ASCII code for Line Feed
MESSAGE DC.B LF, CR,'Enter a Number between 20 and 25, 1573052 to exit: ' ,0
INV     DC.B 'Invalid number, outside of range: [20-25]',CR, LF, 0
*----------- Different Messages--------------
DISTWENTY   DC.B 'A Score is another name for 20, 3 Scores and 10 is equal to 70',CR,LF,0
DISTWEONE   DC.B '21 is A member of the Fibonacci Sequence',CR, LF, 0
DISTWETWO   DC.B '22 Yards, or 1 chain length, is the distance between wickets in cricket',CR, LF, 0
DISTWETHR   DC.B '23rdians are a group of people who believe is the mystical power of 23',CR, LF, 0
DISTWEFOU   DC.B '24 is the factorial of 4. (24 = 4!)',CR, LF, 0
DISTWEFIV   DC.B '25 smallest base 10 Friedman Number. Which is being expressed by its own number. 5^2',CR, LF, 0

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
