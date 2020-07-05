`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/16 15:49:46
// Design Name: 
// Module Name: Ideal_Memory
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


module Ideal_Memory(input CLK,input [31:0]Addr,input [31:0]WD,input WE,output reg [31:0]RD,input IRWrite

    );
   parameter [5:0] ori = 6'b010010,
                     addi=6'b000010,
                     R_type = 6'b100000,
                     add = 6'b000000,
                     sub = 6'b000001,
                     slt = 6'b100110,
                     sw = 6'b110000,
                     lw = 6'b110001,
                     beq = 6'b110100,
                     bne=6'b110101,
                     Or = 6'b010000,
                     And = 6'b010001,
                     jump=6'b111000,
                     stop = 6'b111111;
            
  parameter   r0=5'b00000,r1=5'b00001,r2=5'b00010,r3=5'b00011,r4=5'b00100,r5=5'b00101,r6=5'b00110,r7=5'b00111,
              r8=5'b01000,zero=5'b01001;
  parameter [15:0] sort_loop1=16'b0000_0000_0000_0101,
                    sort_loop2=16'b0000_0000_0000_0000,
                    sort_next=16'b0000_0000_0000_1101;
                    
    reg [31:0]InsMem[31:0];
    reg [31:0]DaMem[31:0];
    initial begin
   /*InsMem[0]={addi ,r1,r1,16'b0000_0000_0000_0100};
    InsMem[1]={addi ,r0,r5,16'b0000_0000_0000_0001};
    InsMem[2]= {addi ,r1,r1,16'b0000_0000_0000_0100}; 
    InsMem[3]= {addi ,r0,r0,16'b0000_0000_0000_0100}; */
    /*InsMem[0]={lw,r0,r3,16'b0000_0000_0000_0010};
    InsMem[1]={lw ,r1,r4,16'b0000_0000_0000_0010};
    //InsMem[2]= {R_type,r2,r4,r7,5'b0000,slt}; 
    InsMem[2]= {beq ,r3, r4, 16'b0000_0000_0000_0100}; 
    InsMem[7]=  {addi,r0,r5,16'b0000_0000_0000_0100}; */
    //InsMem[4]={bne,r2,r4,16'b0000_0000_0000_0001};
   // InsMem[5]={jump, 26'b0000_0000_0000_0000_0000_0111_00};
    //InsMem[7]=  {sw,r1,r3,16'b0000_0000_0000_0000};
    //InsMem[7]={R_type,r3,r4,r6,5'b0000,add};
    //InsMem[3] = {addi, r2,r2,16'b1111_111_1111_1111};
    //InsMem[4] = {jump ,26'b0000_0000_0000_0000_0000_0110_00};
    //InsMem[6]=  {sw,r0,r2,16'b0000_0000_0000_0000};*/
    
    InsMem[0] = {addi,zero,r1,16'b0000_0000_0000_0001}; //r1����ڶ��������±꣨��ַ��
    InsMem[1] = {addi,zero,r0,16'b0000_0000_0000_0000};    //r0�����һ�������±꣨��ַ��
    InsMem[2] = {addi, zero,r2,16'b0000_0000_0000_0101};//r2�ڲ�������Ҫ��������ݸ���
    InsMem[3] = {lw,r0,r3,16'b0000_0000_0000_0000}; //sort_loop  �������ĵ�һ������
    
    InsMem[4] = {lw ,r1,r4,16'b0000_0000_0000_0000};//�������ĵڶ�������
    
    InsMem[5]= {R_type,r3,r4,r7,5'b0000,slt}; //�Ƚ�r3 r4�Ĵ�С������һ��boolֵ����t0  r4>r3  t0=1; r4<=r3  t0=0;
    InsMem[6]= {beq,r7,zero,sort_next}; //����
    
    InsMem[7]=  {sw,r0,r4,16'b0000_0000_0000_0000};
    InsMem[8]=  {sw,r1,r3,16'b0000_0000_0000_0000};//����д��
    
    InsMem[9]=  {addi ,r1,r6,16'b0000_0000_0000_0001};//�ڶ������±��һ  ָ����һ����   sort_next
    InsMem[10]= {addi ,r0,r8,16'b0000_0000_0000_0001};//��һ�����±��һ  ָ����һ����
    InsMem[11]=  {addi ,r6,r1,16'b0000_0000_0000_0000};
    InsMem[12]= {addi ,r8,r0,16'b0000_0000_0000_0000};
    
    InsMem[13]= {bne ,r0, r2, sort_loop1}; //�ڶ���ѭ�����ж�
    
    InsMem[14]=  {addi ,zero,r0,16'b0000_0000_0000_0000};//��һ��ѭ�������ص�һ���� �����±�
    InsMem[15]=  {addi ,zero,r1,16'b0000_0000_0000_0001};//��һ��ѭ�������صڶ����� �����±�
    
    InsMem[16]=  {addi,zero,r5,16'b0000_0000_0000_0001};//��r5����4��������������
    
    InsMem[17]= {R_type,r2,r5,r2,5'b00000,sub};//�����δ��������һ�����֣���С�ĸ���ȥ  
    
    InsMem[18]= {bne,r0,r2,sort_loop2};//���ѭ��
    
    InsMem[19]=  {jump,26'b0000_0000_0000_0000_0000_0000_11};//��ת sort_loop
    InsMem[20]=  {jump,26'b0000_0000_0000_0000_0000_0010_01};//��ת sort_next
    //InsMem[21]=  {stop,26'b0000_0000_0000_0000_0000_0000_00};
    
    
    
    
    /*InsMem[17]=  {R_type,r3,r4,r6,5'b0000,slt};
    InsMem[18]=  {beq,r7,r6,16'b0000_0000_0000_0011};
    InsMem[19]=  {sw,r0,r3,16'b0000_0000_0000_0000};
    InsMem[20]= {R_type,r0,r4,r3,5'b00000,add};
    InsMem[21]= {lw,r0,r4,16'b0000_0000_0000_0000};
    
    InsMem[22]=  {R_type,r4,r5,r6,5'b0000,slt};
    InsMem[23]=  {beq,r7,r6,16'b0000_0000_0000_0011};
    InsMem[24]=  {sw,r0,r4,16'b0000_0000_0000_0000};
    InsMem[25]= {R_type,r0,r5,r4,5'b00000,add};
    InsMem[26]= {lw,r0,r5,16'b0000_0000_0000_0000};
     
    InsMem[27]={R_type,r8,r7,r8,5'b00000,sub};
    InsMem[28]={beq,r0,r8,16'b0000_0000_0000_0001};*/
    //InsMem[29]={jump,26'b000000_0000_0000_0000_0000_0111};
    //InsMem[30]={jump,26'b000000_0000_0000_0000_0000_0000};
  end
  integer i;
  initial begin 
     for( i=0 ;i<32 ; i= i+1)   DaMem[i] <= 0;
  end
  initial begin
      DaMem[0]<=32'b0000_0000_0000_0000_0000_0000_0000_0010;//8
      DaMem[1]<=32'b0000_0000_0000_0000_0000_0000_0000_0111;//2
      DaMem[2]<=32'b0000_0000_0000_0000_0000_0000_0000_0001;//1
      DaMem[3]<=32'b0000_0000_0000_0000_0000_0000_0000_0011;//7
      DaMem[4]<=32'b0000_0000_0000_0000_0000_0000_0000_1001;//4
  end 

    always @(posedge CLK ) begin
    if (WE) begin
        DaMem[Addr]<=WD;
    end
     
     //$display(" now Addr %d",Addr>>2);
     //$display(" now RD %d",RD);
      $display("DaMem0      DaMem1      DaMem2       DaMem3      DaMem4       DaMem5       DaMem6      DaMem7       DaMem8");
      $display("%h %h %h %h %h %h %h %h %h",DaMem[0],DaMem[1],DaMem[2],DaMem[3],DaMem[4],DaMem[5],DaMem[6],DaMem[7],DaMem[8]);
       
    end
   /* always @(WE) begin
        $display("DaMem0      DaMem1      DaMem2       DaMem3      DaMem4       DaMem5       DaMem6      DaMem7       DaMem8");
        $display("%h %h %h %h %h %h %h %h %h",DaMem[0],DaMem[1],DaMem[2],DaMem[3],DaMem[4],DaMem[5],DaMem[6],DaMem[7],DaMem[8]);
    end*/
    always @(*) begin
        if(IRWrite /*& ~WE*/) begin 
         RD<=InsMem[Addr];
     end
     else /*if (~IRWrite )  */begin
         RD<=DaMem[Addr];
     end
      
    end
    
endmodule
