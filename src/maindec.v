module maindec(input  [5:0] op,
               output memtoreg,
               output memwrite,
               output branch,
               output alusrc,
               output regdst,
               output regwrite,
               output jump,
               output [1:0] aluop);

  reg [8:0] controls;

  // assign {regwrite, regdst, alusrc, branch, memwrite,
  //         memtoreg, jump, aluop} = controls;

  // always @(op) begin
  //   $display("changing");
  //   case(op)
  //     6'b000000: controls <= 9'b110000010; // RTYPE
  //     6'b100011: controls <= 9'b101001000; // LW
  //     6'b101011: controls <= 9'b001010000; // SW
  //     6'b000100: controls <= 9'b000100001; // BEQ
  //     6'b001000: controls <= 9'b101000000; // ADDI
  //     6'b000010: controls <= 9'b000000100; // J
  //     default:   begin
  //       controls <= 9'bxxxxxxxxx; // illegal op
  //       $display("Illegal Op");
  //     end
  //   endcase
  // end

  assign {regwrite, regdst, alusrc, branch, memwrite,
          memtoreg, jump, aluop} = op == 6'b000000 ? 9'b110000010 :
                                   op == 6'b100011 || op == 6'b100000 || op == 6'b100100 ? 9'b101001000 : // lw or lb or lbu
                                   op == 6'b101011 ? 9'b001010000 :
                                   op == 6'b000100 ? 9'b000100001 :
                                   op == 6'b001000 ? 9'b101000000 :
                                   op == 6'b000010 ? 9'b000000100 :
                                   9'bzzzzzzzzz;
endmodule


