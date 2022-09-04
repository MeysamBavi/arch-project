module PCReg (
    input clk,
    input reset,
    input en,
    input [31:0] nextPC,
    output [31:0] pc
);

    reg [31:0] r;

    assign pc = r;

    always @(posedge clk) begin
        if (reset) begin
            r <= 0;
        end else if (en) begin
            r <= nextPC; 
        end
    end
    
endmodule