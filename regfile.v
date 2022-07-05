module RegFile (
    input clk,
    input write_en,
    input [4:0] read_a1,
    input [4:0] read_a2,
    input [4:0] write_a,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output valid_d1,
    output valid_d2
);

    reg [31:0] rf[31:0];
    reg valid[31:0];


    assign read_data1 = (read_a1 == 0) ? 0 : rf[read_a1];
    assign read_data2 = (read_a2 == 0) ? 0 : rf[read_a2];
    
    assign valid_d1 = (read_a1 == 0) ? 1 : valid[read_a1];
    assign valid_d2 = (read_a2 == 0) ? 1 : valid[read_a2];

    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            valid[i] <= 0;
        end
    end

    always @(negedge clk) begin
        if (write_en) begin
            rf[write_a] <= write_data;
            valid[write_a] <= 1;
            #1;
            $display("R%d: %d", write_a, rf[write_a]);
        end
    end


    
endmodule