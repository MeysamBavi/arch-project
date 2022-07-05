module HazardUnit (
    input [4:0] id_rs_a,
    input [4:0] id_rt_a,
    input [4:0] ex_rs_a,
    input [4:0] ex_rt_a,
    input [4:0] ex_rd_a,
    input [4:0] mem_rd_a,
    input [4:0] wb_rd_a,
    input id_branch,
    input id_MemWrite,
    input ex_RegWrite,
    input ex_MemToReg,
    input mem_RegWrite,
    input mem_MemToReg,
    input mem_MemWrite,
    input wb_RegWrite,
    input wb_MemToReg,

    output [1:0] ex_forward_a,
    output [1:0] ex_forward_b,
    output StallF,
    output StallD,
    output FlushE,
    output LoadStore
    );
    
    // forwarding

    wire ex_type1_a;
    wire ex_type1_b;
    wire ex_type2_1;
    wire ex_type2_b;

    assign ex_type1_a = mem_RegWrite && !mem_MemToReg && (mem_rd_a != 0) && (mem_rd_a == ex_rs_a);
    assign ex_type1_b = mem_RegWrite && !mem_MemToReg && (mem_rd_a != 0) && (mem_rd_a == ex_rt_a);
    assign ex_type2_a = wb_RegWrite && (wb_rd_a != 0) && (wb_rd_a == ex_rs_a);
    assign ex_type2_b = wb_RegWrite && (wb_rd_a != 0) && (wb_rd_a == ex_rt_a);

    assign ex_forward_a =   ex_type1_a ? 2'b10 :
                            ex_type2_a ? 2'b01 : 2'b00;
                            
    assign ex_forward_b =   ex_type1_b ? 2'b10 :
                            ex_type2_b ? 2'b01 : 2'b00;

    assign LoadStore = mem_MemWrite && wb_MemToReg && (mem_rd_a != 0 && mem_rd_a == wb_rd_a);


    // stall

    wire rs_branch_data_hazard;
    wire rt_branch_data_hazard;
    wire branch_data_hazard;

    assign rs_branch_data_hazard = id_branch && id_rs_a != 0 && ((ex_RegWrite && id_rs_a == ex_rd_a) || (mem_RegWrite && id_rs_a == mem_rd_a));
    assign rt_branch_data_hazard = id_branch && id_rt_a != 0 && ((ex_RegWrite && id_rt_a == ex_rd_a) || (mem_RegWrite && id_rt_a == mem_rd_a));
    
    assign branch_data_hazard = rs_branch_data_hazard || rt_branch_data_hazard;

    wire load_use;
    wire potentialLoadStore;
    
    assign potentialLoadStore = id_MemWrite && ex_MemToReg && (id_rt_a != 0 && id_rt_a == ex_rd_a);
    assign load_use = ex_MemToReg && !potentialLoadStore && ((id_rs_a != 0 && id_rs_a == ex_rd_a) || (id_rt_a != 0 && id_rt_a == ex_rd_a));

    assign StallF = load_use || branch_data_hazard;
    assign StallD = StallF;
    assign FlushE = StallF;

endmodule