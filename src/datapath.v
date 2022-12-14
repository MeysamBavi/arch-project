module Datapath (
    input clk,
    input reset,
    output[31:0] pc,
    input [31:0] instr,
    output mem_write,
    output[31:0] aluout,
    output[31:0] write_data,
    input [31:0] readdata);

    // Fetch

    wire [31:0] nextPC;
    wire pc_en;
    PCReg pcr(clk, reset, pc_en, nextPC, pc);

    wire if_id_en;
    wire if_id_flush;
    wire [31:0] instrD;
    wire [31:0] pc_plus4;
    wire [31:0] pc_plus4D;
    assign pc_plus4 = pc + 4;
    IFIDReg if_id_reg(clk, reset, if_id_en, if_id_flush, instr, instrD, pc_plus4, pc_plus4D);

    // Decode
    wire [5:0] opcode;
    wire [5:0] funct;
    wire zero;

    assign opcode = instrD[31:26];
    assign funct = instrD[5:0];

    wire MemToRegD;
    wire RegWriteD;
    wire MemWriteD;
    wire PcSrcD;
    wire ALUSrcD;
    wire RegDstD;
    wire BranchD;
    wire JumpD;
    wire [2:0] ALUControlD;
    wire [1:0] LoadByteD;
    Controller c(opcode, funct, zero, MemToRegD, MemWriteD, PcSrcD, ALUSrcD, RegDstD, RegWriteD, BranchD, JumpD, ALUControlD, LoadByteD);

    wire [31:0] branchOrNormalPC;
    wire [31:0] PCBranchD;
    wire [31:0] JumpPC;
    MUX2to1 #(32) branch_pc_mux(pc_plus4, PCBranchD, PcSrcD, branchOrNormalPC);
    MUX2to1 #(32) next_pc_mux(branchOrNormalPC, JumpPC, JumpD, nextPC);

    wire [4:0] write_reg_W;
    wire [31:0] resultW;
    wire [31:0] Rs_data;
    wire [31:0] Rt_data;
    wire RegWriteW;
    wire valid_rs;
    wire valid_rt;

    wire [4:0] Rs_a_D;
    wire [4:0] Rt_a_D;
    wire [4:0] Rd_a_D;

    assign Rs_a_D = instrD[25:21];
    assign Rt_a_D = instrD[20:16];
    assign Rd_a_D = instrD[15:11];

    RegFile rf(clk, RegWriteW, Rs_a_D, Rt_a_D, write_reg_W, resultW, Rs_data, Rt_data, valid_rs, valid_rt);

    assign zero = valid_rs && valid_rt && (Rs_data == Rt_data);

    wire [31:0] immediateD;
    SignExt sn(instrD[15:0], immediateD);
    assign PCBranchD = pc_plus4D + (immediateD << 2);
    assign JumpPC = {pc_plus4D[31:28], instrD[25:0], 2'b00};

    // Execute

    wire id_ex_flush;
    wire [4:0] Rs_a_E;
    wire [4:0] Rt_a_E;
    wire [4:0] Rd_a_E;
    wire [31:0] Rs_data_E;
    wire [31:0] Rt_data_E;
    wire [31:0] immediateE;
    wire ALUSrcE;
    wire [2:0] ALUControlE;
    wire [1:0] LoadByteE;
    wire RegDstE;
    wire MemWriteE;
    wire MemToRegE;
    wire RegWriteE;
    IDEXReg id_ex_reg(clk, reset, id_ex_flush, Rs_a_D, Rs_a_E, Rt_a_D, Rt_a_E, Rd_a_D, Rd_a_E,
                      Rs_data, Rs_data_E, Rt_data, Rt_data_E, immediateD, immediateE,
                      ALUSrcD, ALUSrcE, ALUControlD, ALUControlE, RegDstD, RegDstE,
                      MemWriteD, MemWriteE, MemToRegD, MemToRegE, RegWriteD, RegWriteE, LoadByteD, LoadByteE);

    
    wire [4:0] write_reg_E;
    MUX2to1 #(5) wre(Rt_a_E, Rd_a_E, RegDstE, write_reg_E);


    wire [31:0] aluoutM;

    wire [1:0] forwardAE;
    wire [31:0] SrcAE;
    MUX3to1 fa(Rs_data_E, resultW, aluoutM, forwardAE, SrcAE);

    wire [1:0] forwardBE;
    wire [31:0] WriteDataE;
    MUX3to1 fb(Rt_data_E, resultW, aluoutM, forwardBE, WriteDataE);

    wire [31:0] SrcBE;
    MUX2to1 #(32) as(WriteDataE, immediateE, ALUSrcE, SrcBE);

    wire [31:0] aluoutE;
    wire zeroE;
    ALU alu(SrcAE, SrcBE, ALUControlE, aluoutE, zeroE);

    // Memory

    wire [31:0] WriteDataM;
    wire [4:0] write_reg_M;
    wire MemWriteM;
    wire MemToRegM;
    wire RegWriteM;
    wire [1:0] LoadByteM;
    EXMEMReg ex_mem_reg(clk, reset, 1'b0, aluoutE, aluoutM, WriteDataE, WriteDataM,
                        write_reg_E, write_reg_M, MemWriteE, MemWriteM, MemToRegE, MemToRegM,
                        RegWriteE, RegWriteM, LoadByteE, LoadByteM);


    wire LoadStore;

    assign aluout = aluoutM;
    assign write_data = LoadStore ? resultW : WriteDataM;
    assign mem_write = MemWriteM;

    // Write Back

    wire [31:0] aluoutW;
    wire [31:0] ReadDataW;
    wire MemToRegW;
    wire [1:0] LoadByteW;
    MEMWBReg mem_wb_reg(clk, reset, 1'b0, aluoutM, aluoutW, readdata, ReadDataW, write_reg_M, write_reg_W,
                        MemToRegM, MemToRegW, RegWriteM, RegWriteW, LoadByteM, LoadByteW);

    wire [31:0] Byte;
    wire [31:0] UByte;
    wire [31:0] ByteOrWord;

    assign Byte = {{24{ReadDataW[7]}}, ReadDataW[7:0]};
    assign UByte = {24'b0, ReadDataW[7:0]};

    MUX3to1 bow(ReadDataW, Byte, UByte, LoadByteW, ByteOrWord);

    MUX2to1 #(32) rwm(aluoutW, ByteOrWord, MemToRegW, resultW);

    // hazard unit

    wire StallF;
    wire StallD;
    HazardUnit hu(Rs_a_D, Rt_a_D, Rs_a_E, Rt_a_E, write_reg_E, write_reg_M, write_reg_W,
                  BranchD, MemWriteD, RegWriteE, MemToRegE, RegWriteM, MemToRegM, MemWriteM, RegWriteW, MemToRegW,
                  forwardAE, forwardBE, StallF, StallD, id_ex_flush, LoadStore);
    
    assign pc_en = ~StallF;
    assign if_id_en = ~StallD;

    assign if_id_flush = JumpD | PcSrcD;

    
    always @(posedge clk) begin
        #1;
        $display("controls: %b", {MemToRegD, RegWriteD, MemWriteD, PcSrcD, ALUSrcD, RegDstD, BranchD, JumpD, ALUControlD});
    end

endmodule