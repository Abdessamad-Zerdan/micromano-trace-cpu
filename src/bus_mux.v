module bus_mux (
    input  wire [15:0] pc_in,
    input  wire [15:0] ar_in,
    input  wire [15:0] ir_addr_in,
    input  wire [15:0] dr_in,
    input  wire [15:0] ac_in,
    input  wire [15:0] alu_in,
    input  wire [2:0]  bus_sel,
    output reg  [15:0] bus_out
);

always @(*) begin
    case (bus_sel)
        3'b000: bus_out = pc_in;
        3'b001: bus_out = ir_addr_in;
        3'b010: bus_out = dr_in;
        3'b011: bus_out = ac_in;
        3'b100: bus_out = alu_in;
        3'b101: bus_out = ar_in;
        default: bus_out = 16'b0;
    endcase
end

endmodule