module IFIDReg (
    input clk,
    input bubble,
    input [31:0] inst_in,
    output reg [31:0] inst_out,
    input [31:0] pcplus4_in,
    output reg [31:0] pcplus4_out);

    always @(posedge clk) begin
        if (bubble) begin
            inst_out <= 0;
            pcplus4_out <= 0; 
        end else begin
            inst_out <= inst_in;
            pcplus4_out <= pcplus4_out;
        end
    end

endmodule