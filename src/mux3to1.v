module MUX3to1 (
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [1:0] sel,
    output [31:0] out
);

    assign out = sel == 2'b10 ? c :
                 sel == 2'b01 ? b : a;
    
endmodule