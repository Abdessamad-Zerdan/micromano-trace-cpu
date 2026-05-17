module alu (
    input  wire [15:0] ac,
    input  wire [15:0] dr,
    input  wire [2:0]  alu_op,
    output reg  [15:0] result
);

always @(*) begin
    case (alu_op)
        3'b000: result = dr;
        3'b001: result = ac + dr;
        3'b010: result = 16'b0;
        3'b011: result = ac;
        default: result = 16'b0;
    endcase
end

endmodule