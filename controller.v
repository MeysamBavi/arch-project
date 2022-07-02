module Controller (
    input [5:0] opcode,
    input [5:0] funct,
    input zero,
    output MemToReg,
    output MemWrite,
    output PcSrc,
    output ALUSrc,
    output RegDst,
    output RegWrite,
    output Jump,
    output [2:0] alucontrol
);

    wire branch;
    wire [1:0] aluop;

    maindec md(opcode, MemToReg, MemWrite, branch, ALUSrc, RegDst, RegWrite, Jump, aluop);
    aludc ad(funct, aluop, alucontrol);

    assign PcSrc = branch & zero;
    
endmodule