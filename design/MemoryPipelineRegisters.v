`timescale 1ns / 1ps

module MemoryPipelineRegisters ( 
        input CLK,
        input MCycleBusy,
        // Inputs
        input RegWriteE,
        input MemtoRegE,
        input MemWriteE,
        input [31:0] ALUResultE,
        input [31:0] WriteDataE,
        input [4:0] rdE,
        input [4:0] rs2E,
        // Outputs
        output reg RegWriteM,
        output reg MemtoRegM,
        output reg MemWriteM,
        output reg [31:0] ALUResultM,
        output reg [31:0] WriteDataM,
        output reg [4:0] rdM,
        output reg [4:0] rs2M
    );
    
    initial begin
        RegWriteM = 0;
        MemtoRegM = 0;
        MemWriteM = 0;
        ALUResultM = 0;
        WriteDataM = 0;
        rdM = 0;
        rs2M = 0;
    end
    
	always @ (posedge CLK) begin
	   if (!MCycleBusy) begin
           RegWriteM <= RegWriteE;
           MemtoRegM <= MemtoRegE;
           MemWriteM <= MemWriteE;
           ALUResultM <= ALUResultE;
           WriteDataM <= WriteDataE;
           rdM <= rdE;
           rs2M <= rs2E;
       end
	end
	
endmodule












