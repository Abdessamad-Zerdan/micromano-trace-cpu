module micro_sequencer (
    input  wire [7:0] current_upc,
    input  wire [1:0] seq_type,
    input  wire [7:0] next_addr,
    input  wire [2:0] opcode,
    output reg  [7:0] next_upc
);

always @(*) begin
    case (seq_type)
        2'b00: next_upc = current_upc + 1'b1;
        2'b01: next_upc = next_addr;

        2'b10: begin
            case (opcode)
                3'b001: next_upc = 8'd20; // ADD
                3'b010: next_upc = 8'd10; // LDA
                3'b011: next_upc = 8'd30; // STA
                3'b100: next_upc = 8'd40; // BUN
                3'b110: next_upc = 8'd60; // SWAP
                3'b111: next_upc = 8'd50; // HLT
                default: next_upc = 8'd50;
            endcase
        end

        default: next_upc = 8'd0;
    endcase
end

endmodule