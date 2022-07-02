module HazardUnit (
    input [4:0] id_rs_a,
    input [4:0] id_rt_a,
    input [4:0] ex_rs_a,
    input [4:0] ex_rt_a,
    input [4:0] mem_rd_a,
    input [4:0] wb_rd_a,
    input mem_RegWrite,
    input wb_RegWrite,
    output [1:0] ex_forward_a,
    output [1:0] ex_forward_b
    );

    wire ex_type1_a;
    wire ex_type1_b;
    wire ex_type2_1;
    wire ex_type2_b;

    assign ex_type1_a = mem_RegWrite && (mem_rd_a != 0) && (mem_rd_a == ex_rs_a);
    assign ex_type1_b = mem_RegWrite && (mem_rd_a != 0) && (mem_rd_a == ex_rt_a);
    assign ex_type2_a = wb_RegWrite && (wb_rd_a != 0) && (wb_rd_a == ex_rs_a);
    assign ex_type2_b = wb_RegWrite && (wb_rd_a != 0) && (wb_rd_a == ex_rt_a);

    assign ex_forward_a =   ex_type1_a ? 2'b10 :
                            ex_type2_a ? 2'b01 : 2'b00;
                            
    assign ex_forward_b =   ex_type1_b ? 2'b10 :
                            ex_type2_b ? 2'b01 : 2'b00;

    
endmodule