module IDEXReg (
    input clk,
    input reset,
    input bubble,

    input [4:0] Rs_a,
    output reg [4:0] Rs_a_out,

    input [4:0] Rt_a,
    output reg [4:0] Rt_a_out,

    input [4:0] Rd_a,
    output reg [4:0] Rd_a_out,

    input [31:0] Rs_data,
    output reg [31:0] Rs_data_out,

    input [31:0] Rt_data,
    output reg [31:0] Rt_data_out,

    input [31:0] immediate,
    output reg [31:0] immediate_out,

    // control signals
    input ALUSrc,
    output reg ALUSrc_out,

    input [2:0] ALUOp,
    output reg [2:0] ALUOp_out,

    input RegDst,
    output reg RegDst_out,

    input MemWrite,
    output reg MemWrite_out,

    input MemToReg,
    output reg MemToReg_out,

    input RegWrite,
    output reg RegWrite_out);

    always @(posedge clk) begin
        if (reset | bubble) begin
            Rs_a_out <= 0;
            Rt_a_out <= 0;
            Rd_a_out <= 0;
            Rs_data_out <= 0;
            Rt_data_out <= 0;
            immediate_out <= 0;
            
            ALUSrc_out <= 0;
            ALUOp_out <= 0;
            RegDst_out <= 0;
            MemWrite_out <= 0;
            MemToReg_out <= 0;
            RegWrite_out <= 0;

        end else begin
            Rs_a_out <= Rs_a;
            Rt_a_out <= Rt_a;
            Rd_a_out <= Rd_a;
            Rs_data_out <= Rs_data;
            Rt_data_out <= Rt_data;
            immediate_out <= immediate;

            ALUSrc_out <= ALUSrc;
            ALUOp_out <= ALUOp;
            RegDst_out <= RegDst;
            MemWrite_out <= MemWrite;
            MemToReg_out <= MemToReg;
            RegWrite_out <= RegWrite;
        end
    end

endmodule