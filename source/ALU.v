`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/16 14:59:37
// Design Name: ���㵥Ԫ
// Module Name: ALU
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

//Zero ��banchָ�������ָ֧���ת�������Ƿ�Ϊ��

module ALU(input [31:0]A,B,input [2:0]ALUctr,output reg [31:0]Out,output Zero  
    );
    initial begin
        Out = 32'b0;
    end
    assign Zero=Out? 1:0;
    always @(A or B or ALUctr)
      begin 
      case (ALUctr)
       3'b010: Out<= A + B;
       3'b110: Out<= A - B;
       3'b000: Out<= A & B;
       3'b001: Out<= A | B;
       3'b111: Out<= (A<B)?1:0;
       3'b100: Out<=(A==B)?1:0;
       3'b011: Out<=(A!=B)?1:0;
       endcase
      end
      
endmodule
