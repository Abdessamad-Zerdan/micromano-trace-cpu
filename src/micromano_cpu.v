module micromano_cpu (
    input  wire        clk,
    input  wire        reset,

    output wire        halt_debug,
    output wire [7:0]  upc_debug,
    output wire [11:0] pc_debug,
    output wire [11:0] ar_debug,
    output wire [15:0] ir_debug,
    output wire [15:0] dr_debug,
    output wire [15:0] ac_debug,
    output wire [15:0] bus_debug
);

wire [2:0] opcode;
wire [2:0] bus_sel;
wire [2:0] alu_op;

wire mem_write;
wire ld_ar;
wire ld_pc;
wire inc_pc;
wire ld_ir;
wire ld_dr;
wire ld_ac;
wire halt;

assign halt_debug = halt;

control_unit control_inst (
    .clk(clk),
    .reset(reset),
    .opcode(opcode),
    .upc_out(upc_debug),
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

datapath datapath_inst (
    .clk(clk),
    .reset(reset),
    .bus_sel(bus_sel),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .ld_ar(ld_ar),
    .ld_pc(ld_pc),
    .inc_pc(inc_pc),
    .ld_ir(ld_ir),
    .ld_dr(ld_dr),
    .ld_ac(ld_ac),
    .opcode(opcode),
    .pc_debug(pc_debug),
    .ar_debug(ar_debug),
    .ir_debug(ir_debug),
    .dr_debug(dr_debug),
    .ac_debug(ac_debug),
    .bus_debug(bus_debug)
);

endmodule