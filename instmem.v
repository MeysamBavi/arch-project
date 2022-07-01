module InstMem(
    input [31:0] a,
    output [31:0] data
    );

  reg [31:0] RAM[63:0];

  initial begin
      $readmemh("memfile.dat", RAM);
  end

  assign data = RAM[a[7:2]]; // word aligned
endmodule