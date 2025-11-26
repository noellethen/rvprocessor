`timescale 1ns / 1ps

module WritebackPipelineRegisters ( 
        input CLK,
        //input MCycleBusy,
        // Inputs
        input RegWriteM,
        input MemtoRegM,
        input [31:0] ReadDataM,
        input [31:0] ALUResultM,
        input [4:0] rdM,
        // Outputs
        output reg RegWriteW,
        output reg MemtoRegW,
        output reg [31:0] ReadDataW,
        output reg [31:0] ALUResultW,
        output reg [4:0] rdW
    );
    
    initial begin
        RegWriteW = 0;
        MemtoRegW = 0;
        ReadDataW = 0;
        ALUResultW = 0;
        rdW = 0;
    end
    
	always @ (posedge CLK) begin
//	   if (!MCycleBusy) begin
       RegWriteW <= RegWriteM;
       MemtoRegW <= MemtoRegM;
       ALUResultW <= ALUResultM;
       ReadDataW <= ReadDataM;
       rdW <= rdM;
//       end
	end
	
endmodule












