module DataMem(
    input  clk, write_en,
    input [31:0] a, write_data,
    output [31:0] data
);

  reg [31:0] RAM[63:0];

  assign data = RAM[a[31:2]]; // word aligend

  always @(posedge clk) begin
    if (write_en) begin
        RAM[a[31:2]] <= write_data;
    end
  end
endmodule


