*-----------------------------------------------------------
* Title      :HW1 - Question 3
* Written by : Tyler Quayle
* Date       :April 14, 2016
* Description:Question 3 of HW1, UW:B CSS422 Spring 2016
*-----------------------------------------------------------
    
addr1     EQU     $4000        
addr2     EQU     $4001 
data2     EQU     $B7FF 
data3     EQU     $5555 
data4     EQU     $0000 
data5     EQU     4678 
data6     EQU     %01001111 
data7     EQU     %00010111 
    ORG    $400
START:                  ; first instruction of program
    MOVE.W #data2, D0   *Load D0
    MOVE.B #data6, D1   *Load D1
    MOVE.B #data7, D2   *Load D2
    MOVE.W #data3, D3   *Load D3
    MOVEA.W #addr1, A0  *Load address register 
    MOVE.B  D1, (A0)+   *Transfer Byte To Memory
    MOVE.B  D2, (A0)+   *Transfer second byte
    MOVEA.W #addr1, A1  *Load Address
    AND.W D3,(A1)       *Logical And
    JMP START           *Loop back to START
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
