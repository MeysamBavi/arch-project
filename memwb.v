module MEMWBReg (
    input clk,
    input reset,
    input bubble,

    input [31:0] alu_res,
    output reg [31:0] alu_res_out,

    input [31:0] mem_read,
    output reg [31:0] mem_read_out,

    input [4:0] write_reg,
    output reg [4:0] write_reg_out,

    // control signals
    input MemToReg,
    output reg MemToReg_out,

    input RegWrite,
    output reg RegWrite_out);

    always @(posedge clk) begin
        if (reset | bubble) begin
            alu_res_out <= 0;
            mem_read_out <= 0;
            write_reg_out <= 0;
            
            MemToReg_out <= 0;
            RegWrite_out <= 0;

        end else begin
            alu_res_out <= alu_res;
            mem_read_out <= mem_read;
            write_reg_out <= write_reg;

            MemToReg_out <= MemToReg;
            RegWrite_out <= RegWrite;
        end
    end

endmodule