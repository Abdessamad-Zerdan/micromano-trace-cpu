module register #(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire reset,
    input wire load,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        data_out <= {WIDTH{1'b0}};
    else if (load)
        data_out <= data_in;
end

endmodule