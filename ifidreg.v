module IFIDReg (
    input clk,
    input reset,
    input en,
    input flush,
    input [31:0] inst_in,
    output reg [31:0] inst_out,
    input [31:0] pcplus4_in,
    output reg [31:0] pcplus4_out);

    always @(posedge clk) begin
        if (reset || (en && flush)) begin
            inst_out <= 0;
            pcplus4_out <= 0;
        end else if (en) begin
            inst_out <= inst_in;
            pcplus4_out <= pcplus4_out;
        end
    end

endmodule