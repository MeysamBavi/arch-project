module EXMEMReg (
    input clk,
    input reset,
    input bubble,

    input [31:0] alu_res,
    output reg [31:0] alu_res_out,

    input [31:0] Rt_data,
    output reg [31:0] Rt_data_out,

    input [4:0] write_reg,
    output reg [4:0] write_reg_out,

    // control signals
    input MemWrite,
    output reg MemWrite_out,

    input MemToReg,
    output reg MemToReg_out,

    input RegWrite,
    output reg RegWrite_out);

    always @(posedge clk) begin
        if (reset | bubble) begin
            alu_res_out <= 0;
            Rt_data_out <= 0;
            write_reg_out <= 0;
            
            MemWrite_out <= 0;
            MemToReg_out <= 0;
            RegWrite_out <= 0;

        end else begin
            alu_res_out <= alu_res;
            Rt_data_out <= Rt_data;
            write_reg_out <= write_reg;

            MemWrite_out <= MemWrite;
            MemToReg_out <= MemToReg;
            RegWrite_out <= RegWrite;
        end
    end

endmodule