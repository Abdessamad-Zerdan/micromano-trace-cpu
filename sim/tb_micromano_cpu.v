`timescale 1ns / 1ps

module tb_micromano_cpu;

reg clk;
reg reset;

wire halt_debug;
wire [7:0]  upc_debug;
wire [11:0] pc_debug;
wire [11:0] ar_debug;
wire [15:0] ir_debug;
wire [15:0] dr_debug;
wire [15:0] ac_debug;
wire [15:0] bus_debug;

micromano_cpu uut (
    .clk(clk),
    .reset(reset),
    .halt_debug(halt_debug),
    .upc_debug(upc_debug),
    .pc_debug(pc_debug),
    .ar_debug(ar_debug),
    .ir_debug(ir_debug),
    .dr_debug(dr_debug),
    .ac_debug(ac_debug),
    .bus_debug(bus_debug)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    reset = 1'b1;

    uut.datapath_inst.memory_inst.mem[12'd0] = 16'h2064; // LDA 100
    uut.datapath_inst.memory_inst.mem[12'd1] = 16'h1065; // ADD 101
    uut.datapath_inst.memory_inst.mem[12'd2] = 16'h3066; // STA 102
    uut.datapath_inst.memory_inst.mem[12'd3] = 16'h6067; // SWAP 103
    uut.datapath_inst.memory_inst.mem[12'd4] = 16'h7000; // HLT

    uut.datapath_inst.memory_inst.mem[12'd100] = 16'd5;
    uut.datapath_inst.memory_inst.mem[12'd101] = 16'd7;
    uut.datapath_inst.memory_inst.mem[12'd102] = 16'd0;
    uut.datapath_inst.memory_inst.mem[12'd103] = 16'd99;

    #20;
    reset = 1'b0;

    #300;

    $display("Final AC = %d", ac_debug);
    $display("M[102]   = %d", uut.datapath_inst.memory_inst.mem[12'd102]);
    $display("M[103]   = %d", uut.datapath_inst.memory_inst.mem[12'd103]);

    if (uut.datapath_inst.memory_inst.mem[12'd102] == 16'd12 &&
        uut.datapath_inst.memory_inst.mem[12'd103] == 16'd12 &&
        ac_debug == 16'd99) begin
        $display("PASS: program completed with expected results.");
    end else begin
        $display("FAIL: unexpected final state.");
    end

    $stop;
end

endmodule