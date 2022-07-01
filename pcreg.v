module PCReg (
    input clk,
    input nextPC,
    output pc
);

    reg [31:0] r;

    assign pc = r;

    always @(posedge clk) begin
        r <= nextPC;
    end
    
endmodule