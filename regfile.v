module RegFile (
    input clk,
    input write_en,
    input [4:0] read_a1,
    input [4:0] read_a2,
    input [4:0] write_a,
    input [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] rf[31:0];


    assign read_data1 = (read_a1 == 0) ? 0 : rf[read_a1];
    assign read_data2 = (read_a2 == 0) ? 0 : rf[read_a2];

    integer i;

    always @(negedge clk) begin
        if (write_en) begin
            rf[write_a] <= write_data;
            #1;
            $display("R%d: %d", write_a, rf[write_a]);
        end

        // for (i = 0; i < 32; i = i + 1) begin
        //     $display("R%d: %d", i, rf[i]);
        // end
        // $display("------");
    end


    
endmodule