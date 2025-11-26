`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NUS
// Engineer: Shahzor Ahmad, Rajesh C Panicker
// 
// Create Date: 27.09.2016 16:55:23
// Design Name: 
// Module Name: test_MCycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
/* 
----------------------------------------------------------------------------------
--	(c) Shahzor Ahmad, Rajesh C Panicker
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vi) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/

module test_MCycle(

    );
    
    // DECLARE INPUT SIGNALs
    reg CLK = 0 ;
    reg RESET = 0 ;
    reg Start = 0 ;
    reg [1:0] MCycleOp = 0 ;
    reg [3:0] Operand1 = 0 ;
    reg [3:0] Operand2 = 0 ;

    // DECLARE OUTPUT SIGNALs
    wire [3:0] Result1 ;
    wire [3:0] Result2 ;
    wire Busy ;

    // INSTANTIATE DEVICE/UNIT UNDER TEST (DUT/UUT)
    MCycle dut( 
        CLK, 
        RESET, 
        Start, 
        MCycleOp, 
        Operand1, 
        Operand2, 
        Result1, 
        Result2, 
        Busy
        ) ;
    
    // STIMULI
    initial begin
        // hold reset state for 100 ns.
        
        // TESTS FOR SIGNED MULTIPLICATION
//        #10 ;    
//        MCycleOp = 2'b00 ; // Signed multiplication
//        Operand1 = 4'b1101 ; // -3
//        Operand2 = 4'b1101 ; // -3; expected P = 9, 
//        Start = 1'b1 ; // Start is asserted continously(Operations are performed back to back). To try a non-continous Start, you can uncomment the commented lines.    

//        wait(Busy) ; // suspend initial block till condition becomes true  ;
//        wait(~Busy) ;
//        #10 ;
//        Start = 1'b0 ;
//        #10 ;
//        Operand1 = 4'b0111 ; // 7
//        Operand2 = 4'b1111 ; // -1; expected P = -7,
//        Start = 1'b1 ;
        
        
        // TESTS FOR UNSIGNED MULTIPLICATION
//        wait(Busy) ; 
//        wait(~Busy) ;
        #10 ;
        Start = 1'b0 ;
        #10 ;
        MCycleOp = 2'b01 ; // Unsigned multiplication
        Operand1 = 4'b1111 ; // 2
        Operand2 = 4'b1111 ; // 4; expected P = 8
        Start = 1'b1 ;

//        wait(Busy) ; 
//        wait(~Busy) ; 
//        #10 ;
//        Start = 1'b0 ;
//        #10 ;
//        MCycleOp = 2'b01;
//        Operand1 = 4'b0100 ; // 4
//        Operand2 = 4'b0011 ; // 3; expected Q = 12
//        Start = 1'b1 ;
        
        
//        // TEST CASE FOR MULTIPLYING BY 0
//        wait(Busy) ; 
//        wait(~Busy) ; 
//        #10 ;
//        Start = 1'b0 ;
//        #10 ;
//        MCycleOp = 2'b00;
//        Operand1 = 4'b0000 ; // 0
//        Operand2 = 4'b0011 ; // 3; expected Q = 0; R = 1
//        Start = 1'b1 ;

//        // TESTS FOR SIGNED DIVISION
//        wait(Busy) ; 
//        wait(~Busy) ;
//        #10 ;
//        Start = 1'b0 ;
//        #10 ;
//        MCycleOp = 2'b10 ; // Signed division
//        Operand1 = 4'b0111 ; // 7
//        Operand2 = 4'b1101 ; // -3; expected Q = -2, R = -1
//        Start = 1'b1 ;

//        wait(Busy) ; 
//        wait(~Busy) ; 
//        #10 ;
//        Start = 1'b0 ;
//        #10 ;
//        MCycleOp = 2'b10;
//        Operand1 = 4'b1100 ; // -4
//        Operand2 = 4'b0010 ; // 2; expected Q = -2, R = 0
//        Start = 1'b1 ;

//        // TESTS FOR UNSIGNED DIVISION
//        wait(Busy) ; 
//        wait(~Busy) ;
//        #10 ;
//        Start = 1'b0 ;
//        #10 ;
//        MCycleOp = 2'b11 ; // Unigned division
//        Operand1 = 4'b0111 ; // 7
//        Operand2 = 4'b0011 ; // 3; expected Q = 2, R = 1
//        Start = 1'b1 ;

//        wait(Busy) ; 
//        wait(~Busy) ; 
//        #10 ;
//        Start = 1'b0 ;
//        #10 ;
//        MCycleOp = 2'b11;
//        Operand1 = 4'b1100 ; // 12
//        Operand2 = 4'b1000 ; // 2; expected Q = 6, R = 0
//        Start = 1'b1 ;


        wait(Busy) ; 
        wait(~Busy) ; 
        Start = 1'b0 ;
    end
     
    // GENERATE CLOCK       
    always begin 
        #5 CLK = ~CLK ; 
        // invert CLK every 5 time units 
    end
    
endmodule