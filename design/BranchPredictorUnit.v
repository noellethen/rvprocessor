`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 11:42:56 PM
// Design Name: 
// Module Name: BranchPredictorUnit
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


module BranchPredictorUnit #(
    parameter BHT_SIZE = 12 // 12-bit index -- 4096 entries
)(
    input wire CLK,
    input wire RESET,
    
    // Fetch stage -- predicted outcome
    input wire [31:0] PCF,
    output reg PredictedTakenF,
    output reg [31:0] PredictedBTAF,
    
    // Execute stage -- actual outcome
    input wire [31:0] PCE,
    input wire IsBranchE, // check for whether the instruction is a branch instruction
    input wire ActualTakenE, // actual branch outcome (from PCSrcE)
    input wire [31:0] ActualBTAE
);

    // branch history table
    reg [1:0] BHT [0:(2**BHT_SIZE)-1]; // 2-bit saturating counter
    
    // branch target buffer
    reg [31:0] BTB [0:(2**BHT_SIZE)-1];
    
    // lower bits of PC as index for table
    wire [BHT_SIZE-1:0] IndexF;
    wire [BHT_SIZE-1:0] IndexE;
    
    // lower 2 bits are not considered as PC is word-aligned (multiple of 4)
    assign IndexF = PCF[BHT_SIZE+1:2];
    assign IndexE = PCE[BHT_SIZE+1:2];
    
    // initialisation for BHT and BTB (can change to static later)
    integer i;
    initial begin
        for (i = 0; i < (2**BHT_SIZE); i = i + 1) begin
            BHT[i] = 2'b01;
            BTB[i] = 32'h0;        
        end
        
        PredictedTakenF = 1'b0;
        PredictedBTAF = 32'h0;
    end
    
    always @(*) begin
    
        // read prediction from BHT, predict taken if counter >= 2 (weakly taken)
        PredictedTakenF = BHT[IndexF][1];
        
        // read predicted target address
        PredictedBTAF = BTB[IndexF];
    end
    
    always @(posedge CLK) begin
        if (RESET) begin
            // reset all to weakly not taken (can change this to static later)
            for (i = 0; i < (2**BHT_SIZE); i = i + 1) begin
                BHT[i] <= 2'b01;
                BTB[i] <= 32'h0;      
            end
        end
        
        else if (IsBranchE) begin
            // update BHT based on actual outcome
            if (ActualTakenE) begin
                // branch was taken, increment counter (saturate at 11)
                if (BHT[IndexE] != 2'b11) begin
                    BHT[IndexE] <= BHT[IndexE] + 1;
                end
            end
            
            else begin
                // branch not taken, decrement counter (saturate at 00)
                if (BHT[IndexE] != 2'b00) begin
                    BHT[IndexE] <= BHT[IndexE] - 1;
                end
            end
            
            if (ActualTakenE) begin
                // update BTB with actual target address only if branch was taken
                BTB[IndexE] <= ActualBTAE;
            end
        end
    end
endmodule
