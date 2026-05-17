module memory (
    input  wire        clk,
    input  wire        mem_write,
    input  wire [11:0] address,
    input  wire [15:0] data_in,
    output wire [15:0] data_out
);

reg [15:0] mem [0:4095];

assign data_out = mem[address];

always @(posedge clk) begin
    if (mem_write)
        mem[address] <= data_in;
end

endmodule