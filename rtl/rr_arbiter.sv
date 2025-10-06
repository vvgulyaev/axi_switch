module rr_arbiter #(
    parameter N = 2,           // Number of requesters
    parameter LOG_N = (N > 1) ? $clog2(N) : 1  // Width of the requester index
) (
    // Clock and reset
    input  logic                    clk,
    input  logic                    rstn,
    // Requester interface
    input  logic [N-1:0]            req_i,         // Valid signals from requesters
    output logic [LOG_N-1:0]        gnt_idx,     // Index of the granted requester
    output logic [N-1:0]            gnt         // Ready signals to requesters
);

reg [LOG_N-1:0] rrptr, rrptr_r, m;

always_comb begin
    gnt = 0;
    rrptr = rrptr_r;
    for (int i = N-1; i >=0; i--) begin
        m = (rrptr_r + i) % N;
        if (req_i[m]) begin
            gnt[m] = 1'b1;
            gnt_idx = m;
            rrptr = (m + 1) % N;
        end
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        rrptr_r <= '0;
    end else begin
        rrptr_r <= rrptr;
    end
end

endmodule
