module datapath (
    input  wire        clk,
    input  wire        reset,

    input  wire [2:0]  bus_sel,
    input  wire [2:0]  alu_op,

    input  wire        mem_write,
    input  wire        ld_ar,
    input  wire        ld_pc,
    input  wire        inc_pc,
    input  wire        ld_ir,
    input  wire        ld_dr,
    input  wire        ld_ac,

    output wire [2:0]  opcode,

    output wire [11:0] pc_debug,
    output wire [11:0] ar_debug,
    output wire [15:0] ir_debug,
    output wire [15:0] dr_debug,
    output wire [15:0] ac_debug,
    output wire [15:0] bus_debug
);

reg [11:0] pc;

wire [11:0] ar;
wire [15:0] ir;
wire [15:0] dr;
wire [15:0] ac;

wire [15:0] memory_out;
wire [15:0] alu_result;
wire [15:0] bus_out;

assign opcode = ir[14:12];

assign pc_debug  = pc;
assign ar_debug  = ar;
assign ir_debug  = ir;
assign dr_debug  = dr;
assign ac_debug  = ac;
assign bus_debug = bus_out;

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 12'd0;
    else if (ld_pc)
        pc <= bus_out[11:0];
    else if (inc_pc)
        pc <= pc + 1'b1;
end

register #(.WIDTH(12)) ar_reg (
    .clk(clk),
    .reset(reset),
    .load(ld_ar),
    .data_in(bus_out[11:0]),
    .data_out(ar)
);

register #(.WIDTH(16)) ir_reg (
    .clk(clk),
    .reset(reset),
    .load(ld_ir),
    .data_in(memory_out),
    .data_out(ir)
);

register #(.WIDTH(16)) dr_reg (
    .clk(clk),
    .reset(reset),
    .load(ld_dr),
    .data_in(memory_out),
    .data_out(dr)
);

register #(.WIDTH(16)) ac_reg (
    .clk(clk),
    .reset(reset),
    .load(ld_ac),
    .data_in(bus_out),
    .data_out(ac)
);

memory memory_inst (
    .clk(clk),
    .mem_write(mem_write),
    .address(ar),
    .data_in(bus_out),
    .data_out(memory_out)
);

alu alu_inst (
    .ac(ac),
    .dr(dr),
    .alu_op(alu_op),
    .result(alu_result)
);

bus_mux bus_mux_inst (
    .pc_in({4'b0000, pc}),
    .ar_in({4'b0000, ar}),
    .ir_addr_in({4'b0000, ir[11:0]}),
    .dr_in(dr),
    .ac_in(ac),
    .alu_in(alu_result),
    .bus_sel(bus_sel),
    .bus_out(bus_out)
);

endmodule