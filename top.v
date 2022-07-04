module top(
    input clk,
    input reset, 
    output [31:0] writedata,
    output [31:0] dataadr, 
    output memwrite
    );

  wire [31:0] pc;
  wire [31:0] instr;
  wire [31:0] readdata;
  
  // instantiate processor and memories
  Datapath dp(clk, reset, pc, instr, memwrite, dataadr, 
            writedata, readdata);
  InstMem imem(pc, instr);
  DataMem dmem(clk, memwrite, dataadr, writedata, readdata);
endmodule
