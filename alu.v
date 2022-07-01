module Alu(input  [31:0] a, b,
           input  [2:0]  alucontrol,
           output [31:0] result,
           output        zero);

  wire [31:0] condinvb, sum;

  assign condinvb = alucontrol[2] ? ~b : b;
  assign sum = a + condinvb + alucontrol[2];

  assign result = alucontrol[1:0] == 2'b00 ? a & b :
                  alucontrol[1:0] == 2'b01 ? a | b :
                  alucontrol[1:0] == 2'b10 ? sum : sum[31];

  assign zero = (result == 32'b0);
endmodule
