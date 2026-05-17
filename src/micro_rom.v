module micro_rom (
    input  wire [7:0] addr,

    output reg  [7:0] next_addr,
    output reg  [1:0] seq_type,
    output reg  [2:0] bus_sel,
    output reg  [2:0] alu_op,

    output reg        mem_write,
    output reg        ld_ar,
    output reg        ld_pc,
    output reg        inc_pc,
    output reg        ld_ir,
    output reg        ld_dr,
    output reg        ld_ac,
    output reg        halt
);

always @(*) begin
    next_addr = 8'd0;
    seq_type  = 2'b00;
    bus_sel   = 3'b000;
    alu_op    = 3'b000;

    mem_write = 1'b0;
    ld_ar     = 1'b0;
    ld_pc     = 1'b0;
    inc_pc    = 1'b0;
    ld_ir     = 1'b0;
    ld_dr     = 1'b0;
    ld_ac     = 1'b0;
    halt      = 1'b0;

    case (addr)
        // Fetch
        8'd0: begin
            bus_sel = 3'b000;
            ld_ar   = 1'b1;
        end

        8'd1: begin
            ld_ir  = 1'b1;
            inc_pc = 1'b1;
        end

        8'd2: begin
            bus_sel  = 3'b001;
            ld_ar    = 1'b1;
            seq_type = 2'b10;
        end

        // LDA
        8'd10: begin
            ld_dr = 1'b1;
        end

        8'd11: begin
            bus_sel   = 3'b010;
            ld_ac     = 1'b1;
            seq_type  = 2'b01;
            next_addr = 8'd0;
        end

        // ADD
        8'd20: begin
            ld_dr = 1'b1;
        end

        8'd21: begin
            alu_op    = 3'b001;
            bus_sel   = 3'b100;
            ld_ac     = 1'b1;
            seq_type  = 2'b01;
            next_addr = 8'd0;
        end

        // STA
        8'd30: begin
            bus_sel   = 3'b011;
            mem_write = 1'b1;
            seq_type  = 2'b01;
            next_addr = 8'd0;
        end

        // BUN
        8'd40: begin
            bus_sel   = 3'b101;
            ld_pc     = 1'b1;
            seq_type  = 2'b01;
            next_addr = 8'd0;
        end

        // HLT
        8'd50: begin
            halt      = 1'b1;
            seq_type  = 2'b01;
            next_addr = 8'd50;
        end

        // SWAP
        8'd60: begin
            ld_dr = 1'b1;
        end

        8'd61: begin
            bus_sel   = 3'b011;
            mem_write = 1'b1;
        end

        8'd62: begin
            bus_sel   = 3'b010;
            ld_ac     = 1'b1;
            seq_type  = 2'b01;
            next_addr = 8'd0;
        end

        default: begin
            seq_type  = 2'b01;
            next_addr = 8'd0;
        end
    endcase
end

endmodule