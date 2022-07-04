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
    output Branch,
    output Jump,
    output [2:0] alucontrol
);

    wire [1:0] aluop;

    maindec md(opcode, MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump, aluop);
    aludec ad(funct, aluop, alucontrol);

    assign PcSrc = Branch & zero;
    
endmodule