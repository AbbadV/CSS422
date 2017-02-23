*-----------------------------------------------------------
* Title      : Pattern Finding and Cumulative Program
* Written by : Tyler Quayle 
* Date       : April 21, 2016
* Description: Question 4, in HW2. Find byte in memory, then find SUM of 256 bytes
*-----------------------------------------------------------
* FOLLOWING TWO VARIABLES ARE USED TO HARD CODE THE BYTE TO FIND,
* OTHERWISE WOULD 'SUCCEED', ON FIRST COMPARE SINCE ALL MEMORY DEFAULTS
* TO 'FF'
NumTo   EQU $07     * Number hardcoded to find
NumLoc  EQU $6553   * Address between $6k-$8k, where variable is 'Hidden'
************************************************************
CompA       EQU $A000   * The memory location that is being compared against
StarA       EQU $6000   * Starting Address to search From
EndA        EQU $8000   * End Address to search thru

Addr1       EQU $10F0   * Defined in HW2, used to track the 'successful' find of matching data 
Addsum      EQU $10F4   * Defined in HW2, Used to sum 256 consecutive memory addresses
CarryBit    EQU $10F8     * Defined in HW2, Stores carrybit from ADD Addsum

    ORG    $1000
START:  
        MOVEA.L     #$6000, A4      * Assign address $6000 (start) to A4
        MOVEA.L     #CompA, A3      * Assign Address $A300 (compare) to A3
        MOVE.B      #NumTo, NumLoc  * Hardcode number for loop to find
        MOVE.B      #NumTo, CompA   * Hardcode number that loop to find to A300 (A4/CompA)
        MOVE.B      (A3),D0         * Give D0 the byte data in A3
        CLR.W       Addsum          * Set 4 Bytes to Zero at Addsum address. Otherwise starts summing at FFFF
        CLR.W       CarryBit        * Set 4 Bytes to Zero, So carry bit is represent correctly. Otherwise is FFFF
SEARCHLOOP     
        ADDA.W      #$1,A4          * Increment the Address of A4 by $1
        MOVE.B      (A4),D1         * Give D1 the current Byte A4 is on in the loop
        CMP.B       D0, D1          * Compare the byte of data in D0 ($A300) and D1 (A4 Current Byte)    
        BEQ         FOUND           * If D1,D0 Equal, go to find
        CMPA.L      #EndA, A4       * Compare current A4 Address to end address
        BEQ         ERROR           * If EndA hit, jump to error
        BRA         SEARCHLOOP      * Restart Loop if A) Not found B) not the end
FOUND  
        MOVE.L      A4,Addr1        * Update Variable Addr1 to Address that was successfully found
        BRA         CONTINUE        * Jump to CONTINUE
ERROR
        MOVE.L      #$6000, Addr1   * 'Error Code' to insert $6000 into Addr1
        BRA         CONTINUE        * Jump to CONTINUE
CONTINUE
        MOVEA.L     Addr1, A4       * Update A4 with the Address of Addr1 
        CLR.W       D1              * Clear out D1 to Zero, so it can be used to count down properly
        CLR.W       D3              * Clear out D3 word, need to Add BYTE but store in WORD. 
ADDLOOP
        MOVE.B      (A4)+, D2       * Move the Byte value in A4 to D2, than increment A4
        ADD.W       D2, Addsum      * Add the current Byte in D2 to Addsum
        BCS         CARRY           * If Addsum exceeds 4 Bytes (Word). BCS (branch on carry CCR) to Carry
        ADD.W       #1, D1          * Add 1 to D1, used to count the 'loops'
        CMP.W       #255, D1        * Compare 255 to D1, used to see if D1 is greater than 255
        BGT         FINISH          * If D1 is greater than 255, finish the program
        BRA         ADDLOOP         * D1 is still less than 255, loop again
CARRY
        MOVE.W      #1, CarryBit    * Assign 1 to Carrybit, to represent CCR carrybit
        BRA         ADDLOOP         * Jump back to ADDLOOP
FINISH
*-------Display Address----------------------------------------------
        LEA         AddOut, A1      * Move AddOut into A1 for display
        MOVE.B      #14, D0         * Move (Task)14 into D0 for Trap 15
        TRAP        #15             * Display contents of A1
        MOVEA.L     Addr1, A1       * Move Address of Addr1 ($6553) into A1
        MOVE.W      A1, D1          * Move Address of A1 into D1 for display
        MOVE.B      #3, D0          * Move (Task)3[display D1 in decimal] into D0 for Trap 15
        TRAP        #15             * Display contents of D1
*-------Display Sum of Memory-----------------------------------------       
        LEA         SumOut, A1      * Move SumOut into A1 for display
        MOVE.B      #14, D0         * Move (Task)14 into D0 for Trap 15
        TRAP        #15             * Display contents of A1
        MOVE.W      Addsum, D1      * Move Addsum into D1
        MOVE.B      #3, D0          * Move (Task)3[Display D1 in decimal] into D0 for Trap 15
        TRAP        #15             * Display contents of D1, in decimal (Task 3)
*-------Display Carry Bit---------------------------------------------    
        LEA         CarOut, A1      * Move CarOut into A1 for display
        MOVE.B      #14, D0         * Move (Task)14 into D0 for Trap 15
        TRAP        #15             * Display contents of A1
        MOVE.W      CarryBit, D1    * Move CarryBit into D1
        MOVE.B      #3, D0          * Move (Task)3[Display D1 in decimal] into D0 for Trap 15
        TRAP        #15             * Display contents of D1, in decimal (Task 3)     

    SIMHALT             ; halt simulator
CR      EQU $0D             ;ASCII code for Carriage Return
LF      EQU $0A             ;ASCII code for Line Feed
AddOut  DC.B 'Address: ',0
SumOut  DC.B LF, CR,'Sum of 256: ',0
CarOut  DC.B LF, CR,'Carry  Bit: ',0

    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
