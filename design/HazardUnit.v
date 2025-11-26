`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2025 06:45:31 AM
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(
//    input MCycleBusy,
    input [1:0] PCSE,
    input BranchMispredicted,
    // Input
    input [4:0] rs1D,
    input [4:0] rs2D,
    input [4:0] rs1E,
    input [4:0] rs2E,
    input [4:0] rdE,
    input [4:0] rs2M,
    input [4:0] rdM,
    input [4:0] rdW,
    // Output
    output reg StallF,
    output reg StallD,
    output reg FlushD,
    output reg Forward2D,
    output reg Forward1D,
    output reg FlushE,
    output reg [1:0] ForwardBE,
    output reg [1:0] ForwardAE,
    input MemtoRegE,
    
    // input BranchMispredicted,
    
    input [1:0] PCSrcE,
    output reg ForwardM,
    input RegWriteM,
    input MemWriteM,
    input RegWriteW,
    input MemtoRegW
    );
    
    initial begin
        StallF = 0;
        StallD = 0;
        FlushD = 0;
        Forward2D = 0;
        Forward1D = 0;
        FlushE = 0;
        ForwardBE = 0;
        ForwardAE = 0;
        ForwardM = 0;
    end
    
    reg lwStall;
    reg ToFlush;
    
    always @(*) begin
    
        // Data forwarding
        if ((rs1E == rdM) & RegWriteM & (rdM != 0)) begin
            ForwardAE = 2'b10;
        end else if ((rs1E == rdW) & RegWriteW & (rdW != 0)) begin
            ForwardAE = 2'b01;
        end else begin
            ForwardAE = 2'b00;
        end
        if ((rs2E == rdM) & RegWriteM & (rdM != 0)) begin
            ForwardBE = 2'b10;
        end else if ((rs2E == rdW) & RegWriteW & (rdW != 0)) begin
            ForwardBE = 2'b01;
        end else begin
            ForwardBE = 2'b00;
        end
        
        // Mem to mem copy -> load store problem
        ForwardM = (rs2M == rdW) & MemWriteM & MemtoRegW & (rdW != 0);
        
        
        // Load and use
        lwStall = ((rs1D == rdE) || (rs2D == rdE)) && MemtoRegE;
        StallF = lwStall;
        StallD = lwStall;
        
        ToFlush = (PCSE == 2'b10 || PCSE == 2'b11) || BranchMispredicted;
        FlushE = lwStall || ToFlush;
        
        // Avoiding unecessary stalls
        // todo -> slide 30
        
        // Control hazards - Flushing
        FlushD = ToFlush;
        
        /// W to D forwarding
        Forward1D = (rs1D == rdW) & RegWriteW & (rdW != 0);
        Forward2D = (rs2D == rdW) & RegWriteW & (rdW != 0);
        
        // 
    end
    
endmodule
