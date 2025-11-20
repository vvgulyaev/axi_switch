/*
Create a pair of channel arbiters, namely source arbiter and destination arbiters
    - the destination module forwards all ready signals of its connected module to the source module
    - the source module should use round robin arbitration to select a source module 's' targeting a destination module 'd' such that
        - both source valid and the destination ready are '1', i.e. vld[s]==1 and ready[d]==1
        - for s = 0 to S-1
            d = dest[s]
            if (vld[s] & ready[d]) { sourceSel=s; target=dest[s]; break;}
*/

// Generic Channel Arbiter: Connects S source modules to D destination modules with round-robin arbitration
module channel_arbiter #(
    parameter S = 2,           // Number of source modules
    parameter D = 2,           // Number of destination modules
    parameter WIDTH = 64,      // payload width
    parameter LOG_D = (D > 1) ? $clog2(D) : 1, // Width of destination index
    parameter LOG_S = (S > 1) ? $clog2(S) : 1  // Width of source index
) (
    // Clock and reset
    input  logic                    clk,
    input  logic                    rstn,

    // Source module interface (S sources)
    input  logic [S-1:0]            srcVld_i,            // Valid signals from sources
    input  [LOG_D-1:0]              srcTarget_i[S],      // Destination indices from sources
    input  [WIDTH-1:0]              srcDat_i[S],         // Data from sources
    output reg [S-1:0]              grantRdy_o,          // Ready signals to sources

    // Destination module interface (N destinations)
    input  logic [D-1:0]            dstRdy_i,           // Ready signals from destinations
    output logic [D-1:0]            dstVld_o,           // Valid signals to destinations
    output logic [LOG_S-1:0]        dstSrc_o,
    output logic [WIDTH-1:0]        dstDat_o            // Broadcast to all destinations
);

    logic  [S-1:0]     srcVld, srcVld_r;
    logic  [LOG_D-1:0] srcTarget[S], srcTarget_r[S];
    logic  [WIDTH-1:0] srcDat[S], srcDat_r[S];
    logic  [S-1:0]     clrSrcVld;
    logic  [LOG_D-1:0] dstIdx;

    // Arbitration state
    logic [LOG_S-1:0]     rrPtr_r, rrPtr;
    logic [D-1:0]         dstVld, dstVld_r;
    logic [WIDTH-1:0]     dstDat, dstDat_r;
    logic [LOG_S-1:0]     dstSrc, dstSrc_r;
    logic [D-1:0]         dstRdy_r;
    logic [D-1:0]         target_busy, target_busy_r;

    //-----------------------------------------------
    //Stage 0: Input buffer
    //-----------------------------------------------
    always_comb begin
        srcVld = srcVld_r;
        srcTarget = srcTarget_r;
        srcDat = srcDat_r;
        grantRdy_o = 0;
        target_busy = target_busy_r;//avoid access to same dst from different src

        for (int i = 0; i < S; i++) begin
            if (clrSrcVld[i]) begin
                srcVld[i] = 0;
                target_busy[srcTarget_r[i]] = 0;
            end

            if ((~srcVld_r[i] && ~target_busy[srcTarget_i[i]]) && srcVld_i[i]) begin
                grantRdy_o[i] = 1;
                srcVld[i] = 1;
                srcTarget[i] = srcTarget_i[i];
                srcDat[i] = srcDat_i[i];
                target_busy[srcTarget_i[i]] = 1;
            end
        end
    end


    //------------------------------------------------
    //Stage 1: RR arbiter
    //------------------------------------------------
    always_comb begin
        clrSrcVld = 0;
        rrPtr = rrPtr_r;
        dstIdx = 0;

        dstVld = dstVld_r;
        dstDat = dstDat_r;
        dstSrc = dstSrc_r;
        for (int i = 0; i < D; i++) begin
            if (dstVld_r[i] && dstRdy_i[i]) begin
                dstVld[i] = 0;
            end
        end

        for (int i = 0; i < S; i++) begin
            int m;
            m = (rrPtr_r + i) % S;
            dstIdx = srcTarget_r[m];
            if (srcVld_r[m] && (dstVld==0)) begin
                dstVld[dstIdx] = 1'b1;
                dstDat = srcDat_r[m];
                clrSrcVld[m] = 1;
                dstSrc = m;
                rrPtr = (rrPtr_r + 1) % S;
                break;
            end
        end
    end

    // Assign registered outputs
    assign dstVld_o = dstVld_r;
    assign dstDat_o = dstDat_r;
    assign dstSrc_o = dstSrc_r;


    //------------------------------------------------
    // Registering
    //------------------------------------------------
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            srcVld_r <= 0;
            srcTarget_r <= '{default: '0};
            srcDat_r <= '{default: '0};
            target_busy_r <= 0;

            rrPtr_r  <= 0;

            dstVld_r <= 0;
            dstDat_r <= 0;
            dstSrc_r <= 0;
            dstRdy_r <= 0;
        end
        else begin
            srcVld_r <= srcVld;
            srcTarget_r <= srcTarget;
            srcDat_r <= srcDat;
            target_busy_r <= target_busy;

            rrPtr_r <= rrPtr;

            dstVld_r <= dstVld;
            dstDat_r <= dstDat;
            dstSrc_r <= dstSrc;
            dstRdy_r <= dstRdy_i;
        end
    end

endmodule
