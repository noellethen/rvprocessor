`timescale 1ns / 1ps

module ExecutePipelineRegisters ( 
        input CLK,
        input FlushE,
        input MCycleBusy,
        // Inputs
        input [1:0] PCSD,
        input RegWriteD,
        input MemtoRegD,
        input MemWriteD,
        input [3:0] ALUControlD,
        input [1:0] ALUSrcAD,
        input [1:0] ALUSrcBD,
        input [31:0] RD1D,
        input [31:0] RD2D,
        input [31:0] ExtImmD,
        input [4:0] rdD,
        input [31:0] PCD,
        input [4:0] rs1D,
        input [4:0] rs2D,
        
        // inputs for prediction information
        input PredictedTakenD,
        input [31:0] PredictedBTAD,
        
        input [2:0] Funct3D,
        input [6:0] OpcodeD,
        input [6:0] Funct7D,
        // Outputs
        output reg [1:0] PCSE,
        output reg RegWriteE,
        output reg MemtoRegE,
        output reg MemWriteE,
        output reg [3:0] ALUControlE,
        output reg [1:0] ALUSrcAE,
        output reg [1:0] ALUSrcBE,
        output reg [31:0] RD1E,
        output reg [31:0] RD2E,
        output reg [31:0] ExtImmE,
        output reg [4:0] rdE,
        output reg [31:0] PCE,
        output reg [4:0] rs1E,
        output reg [4:0] rs2E,
        
        // outputs for prediction information
        output reg PredictedTakenE,
        output reg [31:0] PredictedBTAE,
        output reg [2:0] Funct3E,
        output reg [6:0] OpcodeE,
        output reg [6:0] Funct7E
    );
    
    initial begin
        PCSE = 0;
        RegWriteE = 0;
        MemtoRegE = 0;
        MemWriteE = 0;
        ALUControlE = 0;
        ALUSrcAE = 0;
        ALUSrcBE = 0;
        RD1E = 0;
        RD2E = 0;
        ExtImmE = 0;
        rdE = 0;
        PCE = 0;
        rs1E = 0;
        rs2E = 0;
        PredictedTakenE = 0;
        PredictedBTAE = 0;
        Funct3E = 0;
        OpcodeE = 0;
        Funct7E = 0;
    end
    
	always @ (posedge CLK) begin	
	   if (!MCycleBusy) begin   
           if (FlushE) begin
               PCSE <= 0;
               RegWriteE <= 0;
               MemtoRegE <= 0;
               MemWriteE <= 0;
               ALUControlE <= 0;
               ALUSrcAE <= 0;
               ALUSrcBE <= 0;
               RD1E <= 0;
               RD2E <= 0;
               ExtImmE <= 0;
               rdE <= 0;
               PCE <= 0;
               rs1E <= 0;
               rs2E <= 0;
               OpcodeE <= 0;
               Funct7E <= 0;
               
               PredictedTakenE <= 0;
               PredictedBTAE <= 0;
               Funct3E <= 0;
           end else begin
               PCSE <= PCSD;
               RegWriteE <= RegWriteD;
               MemtoRegE <= MemtoRegD;
               MemWriteE <= MemWriteD;
               ALUControlE <= ALUControlD;
               ALUSrcAE <= ALUSrcAD;
               ALUSrcBE <= ALUSrcBD;
               RD1E <= RD1D;
               RD2E <= RD2D;
               ExtImmE <= ExtImmD;
               rdE <= rdD;
               PCE <= PCD;  
               rs1E <= rs1D;
               rs2E <= rs2D;
               
               PredictedTakenE <= PredictedTakenD;
               PredictedBTAE <= PredictedBTAD;
               Funct3E <= Funct3D;
               OpcodeE <= OpcodeD;
               Funct7E <= Funct7D;
           end
       end
	end
	
endmodule











