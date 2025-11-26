`timescale 1ns / 1ps

module DecodePipelineRegisters ( 
        input CLK,
        input StallD,
        input FlushD,
        input MCycleBusy,
        input [31:0] InstrF,
        input [31:0] PCF,
        output reg [31:0] InstrD,
        output reg [31:0] PCD,

        input PredictedTakenF,
        input [31:0] PredictedBTAF,
        output reg PredictedTakenD,
        output reg [31:0] PredictedBTAD
				
    );
    
	always @ (posedge CLK) begin	   
	   if (!MCycleBusy) begin
           if (FlushD) begin
                InstrD  <= 0;
                PCD <= 0;
                PredictedTakenD <= 0;
                PredictedBTAD <= 0;
    
           end else if (~StallD) begin
                InstrD <= InstrF;
                PCD <= PCF;
                PredictedTakenD <= PredictedTakenF;
                PredictedBTAD <= PredictedBTAF;
    
           end
       end
	end
	
endmodule












