/*
Create a pair of channel arbiters, namely source arbiter and destination arbiters
    - the destination module forwards all ready signals of its connected module to the source module
    - the source module should use round robin arbitration to select a source module 's' targeting a destination module 'd' such that
        - both source valid and the destination ready are '1', i.e. vld[s]==1 and ready[d]==1
        - for s = 0 to S-1
            d = dest[s]
            if (vld[s] & ready[d]) { sourceSel=s; target=dest[s]; break;}
*/

// Generic Channel Arbiter: Connects M source modules to N destination modules with round-robin arbitration
module channel_arbiter #(
    parameter M = 2,           // Number of source modules
    parameter N = 2,           // Number of destination modules
    parameter WIDTH = 64,      // Data width
    parameter LOG_N = (N > 1) ? $clog2(N) : 1, // Width of destination index
    parameter LOG_M = (M > 1) ? $clog2(M) : 1  // Width of source index
) (
    // Clock and reset
    input  logic                    clk,
    input  logic                    rstn,

    // Source module interface (M sources)
    input  logic [M-1:0]            srcVld_i,            // Valid signals from sources
    input  [LOG_N-1:0]              srcTarget_i[M],      // Destination indices from sources
    input  [WIDTH-1:0]              srcDat_i[M],         // Data from sources
    output reg [M-1:0]              grantRdy_o,          // Ready signals to sources

    // Destination module interface (N destinations)
    input  logic [N-1:0]            dstRdy_i,           // Ready signals from destinations
    output logic [N-1:0]            dstVld_o,           // Valid signals to destinations
    output logic [WIDTH-1:0]        dstDat_o            // Broadcast to all destinations
);

    // Registered input signals
    reg [M-1:0]            srcVld_r;
    reg [LOG_N-1:0]        srcTarget_r[M];
    reg [WIDTH-1:0]        srcDat_r[M];
    reg [N-1:0]            dstRdy_r;

    // Registered output signals
    reg [N-1:0]            dstVld, dstVld_r;
    reg [WIDTH-1:0]        dstDat, dstDat_r;

    // Arbitration state
    logic [LOG_M-1:0]     rrPtr_r, rrPtr, m;
    logic [LOG_N-1:0]     target, n;
    logic [LOG_N-1:0]     d;
    logic [M-1:0]         grantRdy;

    // Register inputs
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            srcVld_r <= '0;
            dstRdy_r <= '0;
            dstVld_r <= '0;
            dstDat_r <= '0;
            grantRdy_o <= '0;
            rrPtr_r <= '0;
            for (int i = 0; i < M; i++) begin
                srcTarget_r[i] <= '0;
                srcDat_r[i] <= '0;
            end
        end else begin
            srcVld_r <= srcVld_i;
            dstRdy_r <= dstRdy_i;
            dstVld_r <= dstVld;
            dstDat_r <= dstDat;
            grantRdy_o <= grantRdy;
            rrPtr_r <= rrPtr;
            for (int i = 0; i < M; i++) begin
                srcTarget_r[i] <= srcTarget_i[i];
                srcDat_r[i] <= srcDat_i[i];
            end
        end
    end

    // Round-robin arbitration: map
    //     - from srcVld, srcTarget, srcDat
    //     - to grantRdy, dstVld, dstDat
    always_comb begin
        grantRdy = 0;
        dstVld = 0;
        dstDat = 0;
        rrPtr = rrPtr_r;
        for (int i = M-1; i >=0; i--) begin
            m = (rrPtr_r + i) % M;
            d = srcTarget_r[m];
            if (srcVld_r[m] && dstRdy_r[d]) begin
                grantRdy[m] = 1'b1;
                dstVld[d] = 1'b1;
                dstDat = srcDat_r[m];
                rrPtr = (m + 1) % M;
            end
        end
    end


    // Assign registered outputs
    assign dstVld_o = dstVld_r;
    assign dstDat_o = dstDat_r;
endmodule
