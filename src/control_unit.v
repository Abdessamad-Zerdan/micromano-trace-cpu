module control_unit (
    input  wire       clk,
    input  wire       reset,
    input  wire [2:0] opcode,

    output wire [7:0] upc_out,
    output wire [2:0] bus_sel,
    output wire [2:0] alu_op,

    output wire       mem_write,
    output wire       ld_ar,
    output wire       ld_pc,
    output wire       inc_pc,
    output wire       ld_ir,
    output wire       ld_dr,
    output wire       ld_ac,
    output wire       halt
);

reg [7:0] upc;

wire [7:0] next_addr;
wire [1:0] seq_type;
wire [7:0] next_upc;

assign upc_out = upc;

micro_rom rom_inst (
    .addr(upc),
    .next_addr(next_addr),
    .seq_type(seq_type),
    .bus_sel(bus_sel),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .ld_ar(ld_ar),
    .ld_pc(ld_pc),
    .inc_pc(inc_pc),
    .ld_ir(ld_ir),
    .ld_dr(ld_dr),
    .ld_ac(ld_ac),
    .halt(halt)
);

micro_sequencer sequencer_inst (
    .current_upc(upc),
    .seq_type(seq_type),
    .next_addr(next_addr),
    .opcode(opcode),
    .next_upc(next_upc)
);

always @(posedge clk or posedge reset) begin
    if (reset)
        upc <= 8'd0;
    else if (!halt)
        upc <= next_upc;
end

endmodule