/*
Slave Arbiter Module for AXI4 Switch
Manages two channel arbiters for R and B channels, routing responses from N slaves to M masters.
Includes RID/BID tables with destination buffers for response routing.
*/

module slave_switch #(
    parameter M = 2,           // Number of master ports
    parameter N = 2,           // Number of slave ports
    parameter WIDTH = 32,      // Data width
    parameter ID_WIDTH = 4,    // ID width
    parameter ADDR_WIDTH = 32, // Address width
    parameter LOG_M = (M > 1) ? $clog2(M) : 1, // Width of master index
    parameter LOG_N = (N > 1) ? $clog2(N) : 1  // Width of slave index
) (
    // Clock and reset
    input  logic                     clk,
    input  logic                     rstn,

    // Slave module interface (N slaves)
    output logic [N-1:0]             s_axi_arvalid,
    input  logic [N-1:0]             s_axi_arready,
    output logic [ID_WIDTH-1:0]     s_axi_arid[N],
    output logic [ADDR_WIDTH-1:0]   s_axi_araddr[N],
    output logic [7:0]              s_axi_arlen[N],
    output logic [2:0]              s_axi_arsize[N],
    output logic [1:0]              s_axi_arburst[N],

    output logic [N-1:0]             s_axi_awvalid,
    input  logic [N-1:0]             s_axi_awready,
    output logic [ID_WIDTH-1:0]     s_axi_awid[N],
    output logic [ADDR_WIDTH-1:0]   s_axi_awaddr[N],
    output logic [7:0]              s_axi_awlen[N],
    output logic [2:0]              s_axi_awsize[N],
    output logic [1:0]              s_axi_awburst[N],

    output logic [N-1:0]             s_axi_wvalid,
    input  logic [N-1:0]             s_axi_wready,
    output logic [WIDTH-1:0]         s_axi_wdata[N],
    output logic [WIDTH/8-1:0]       s_axi_wstrb[N],
    output logic                     s_axi_wlast[N],

    input  logic [N-1:0]             s_axi_rvalid,
    output logic [N-1:0]             s_axi_rready,
    input  logic [ID_WIDTH-1:0]      s_axi_rid[N],
    input  logic [WIDTH-1:0]         s_axi_rdata[N],
    input  logic [1:0]               s_axi_rresp[N],
    input  logic                     s_axi_rlast[N],

    input  logic [N-1:0]             s_axi_bvalid,
    output logic [N-1:0]             s_axi_bready,
    input  logic [ID_WIDTH-1:0]      s_axi_bid[N],
    input  logic [1:0]               s_axi_bresp[N],

    // Arbitrated channel buses
    // AR channel (from master switch)
    input  logic [M-1:0]                     busARVld_i,
    output logic [N-1:0]                    busARRdy_o,
    input  logic [ADDR_WIDTH-1:0]          busARAddr_i,
    input  logic [ID_WIDTH-1:0]            busARId_i,
    input  logic [7:0]                     busARLen_i,
    input  logic [2:0]                     busARSz_i,
    input  logic [1:0]                     busARBurst_i,
    input  logic [LOG_M-1:0]               busARSrc_i,
    input  logic [LOG_N-1:0]               busARDst_i,

    // AW channel (from master switch)
    input  logic [M-1:0]                   busAWVld_i,
    output logic [N-1:0]                   busAWRdy_o,
    input  logic [ADDR_WIDTH-1:0]          busAWAddr_i,
    input  logic [ID_WIDTH-1:0]            busAWId_i,
    input  logic [7:0]                     busAWLen_i,
    input  logic [2:0]                     busAWSz_i,
    input  logic [1:0]                     busAWBurst_i,
    input  logic [LOG_M-1:0]               busAWSrc_i,
    input  logic [LOG_N-1:0]               busAWDst_i,

    // W channel (from master switch)
    input  logic [M-1:0]                busWVld_i,
    output logic [N-1:0]                busWRdy_o,
    input  [WIDTH-1:0]                  busWData_i,
    input  [WIDTH/8-1:0]                busWStrb_i,
    input  logic                        busWLast_i,
    input  [LOG_M-1:0]                  busWSrc_i,
    input  [LOG_N-1:0]                  busWDst_i,

    // R channel (to master switch)
    output [N-1:0]                      busRVld_o,
    input  [M-1:0]                      busRRdy_i,
    output [WIDTH-1:0]                  busRData_o,
    output [ID_WIDTH-1:0]               busRId_o,
    output [1:0]                        busRResp_o,
    output logic                        busRLast_o,
    output [LOG_N-1:0]                  busRSrc_o,
    output [LOG_M-1:0]                  busRDst_o,

    // B channel (to master switch)
    output [N-1:0]                      busBVld_o,
    input  [M-1:0]                      busBRdy_i,
    output [ID_WIDTH-1:0]               busBId_o,
    output [1:0]                        busBResp_o,
    output [LOG_N-1:0]                  busBSrc_o,
    output [LOG_M-1:0]                  busBDst_o
);


// AR channel registers
logic [N-1:0]             bus_axi_arvalid_r;
logic [ID_WIDTH-1:0]     bus_axi_arid_r;
logic [ADDR_WIDTH-1:0]   bus_axi_araddr_r;
logic [7:0]              bus_axi_arlen_r;
logic [2:0]              bus_axi_arsize_r;
logic [1:0]              bus_axi_arburst_r;

// AW channel registers
logic [N-1:0]             bus_axi_awvalid_r;
logic [ID_WIDTH-1:0]     bus_axi_awid_r;
logic [ADDR_WIDTH-1:0]   bus_axi_awaddr_r;
logic [7:0]              bus_axi_awlen_r;
logic [2:0]              bus_axi_awsize_r;
logic [1:0]              bus_axi_awburst_r;

// W channel registers
logic [N-1:0]             bus_axi_wvalid_r;
logic [WIDTH-1:0]        bus_axi_wdata_r;
logic [WIDTH/8-1:0]      bus_axi_wstrb_r;
logic                    bus_axi_wlast_r;

// Internal signals for tracking rid/bid lookups
logic [N-1:0] rid_re;
logic [N-1:0] rid_valid;
logic [LOG_M-1:0] rid_dest;
logic [N-1:0] bid_re;
logic [N-1:0] bid_valid;
logic [LOG_M-1:0] bid_dest;
reg [LOG_N-1:0] rtargetVld_r, wtargetVld_r;  // Valid signals for target buffers
reg [LOG_M-1:0] rtargetBuf_r[N], wtargetBuf_r[N];  // Target master matrix

// Connect registered signals to outputs
always_comb begin
    for (int i = 0; i < N; i++) begin
        s_axi_arid[i] = bus_axi_arid_r;
        s_axi_araddr[i] = bus_axi_araddr_r;
        s_axi_arlen[i] = bus_axi_arlen_r;
        s_axi_arsize[i] = bus_axi_arsize_r;
        s_axi_arburst[i] = bus_axi_arburst_r;

        s_axi_awid[i] = bus_axi_awid_r;
        s_axi_awaddr[i] = bus_axi_awaddr_r;
        s_axi_awlen[i] = bus_axi_awlen_r;
        s_axi_awsize[i] = bus_axi_awsize_r;
        s_axi_awburst[i] = bus_axi_awburst_r;

        s_axi_wdata[i] = bus_axi_wdata_r;
        s_axi_wstrb[i] = bus_axi_wstrb_r;
        s_axi_wlast[i] = bus_axi_wlast_r;
    end

    for (int r = 0; r < N; r++) begin : gen_r_target
        // Request lookup when valid response received without destination info
        rid_re[r] = s_axi_rvalid[r] & ~rtargetVld_r[r];
        // Set target based on lookup result
        /*if (rid_valid[r]) begin
            rtargetVld_r[r] = 1'b1;
            rtargetBuf_r[r] = rid_dest;
        end*/
    end
end

// Forward valids of requesting channels to slave requesting channels and ready back
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        bus_axi_arvalid_r <= '0;
        bus_axi_awvalid_r <= '0;
        bus_axi_wvalid_r <= '0;
        busARRdy_o <= '0;
        busAWRdy_o <= '0;
        busWRdy_o <= '0;
    // broadcasted registers
        bus_axi_arid_r <= '0;
        bus_axi_araddr_r <= '0;
        bus_axi_arlen_r <= '0;
        bus_axi_arsize_r <= '0;
        bus_axi_arburst_r <= '0;

        bus_axi_awid_r <= '0;
        bus_axi_awaddr_r <= '0;
        bus_axi_awlen_r <= '0;
        bus_axi_awsize_r <= '0;
        bus_axi_awburst_r <= '0;

        bus_axi_wdata_r <= '0;
        bus_axi_wstrb_r <= '0;
        bus_axi_wlast_r <= '0;

    end else begin
        bus_axi_arvalid_r <= busARVld_i;
        bus_axi_awvalid_r <= busAWVld_i;
        bus_axi_wvalid_r <= busWVld_i;
        // busRdy = s_ready & ~s_valid ensure it not ready at the next cycle to allow pipelined propagation of s_ready
        busARRdy_o <= s_axi_arready & ~s_axi_arvalid;
        busAWRdy_o <= s_axi_awready & ~s_axi_awvalid;
        busWRdy_o <= s_axi_wready & ~s_axi_wvalid;

        if (|busARVld_i) begin
            bus_axi_arid_r <= busARId_i;
            bus_axi_araddr_r <= busARAddr_i;
            bus_axi_arlen_r <= busARLen_i;
            bus_axi_arsize_r <= busARSz_i;
            bus_axi_arburst_r <= busARBurst_i;
        end

        if (|busAWVld_i) begin
            bus_axi_awid_r <= busAWId_i;
            bus_axi_awaddr_r <= busAWAddr_i;
            bus_axi_awlen_r <= busAWLen_i;
            bus_axi_awsize_r <= busAWSz_i;
            bus_axi_awburst_r <= busAWBurst_i;
        end

        if (|busWVld_i) begin
            bus_axi_wdata_r <= busWData_i;
            bus_axi_wstrb_r <= busWStrb_i;
            bus_axi_wlast_r <= busWLast_i;
        end

    end
end



    // RID table to track master destination for read responses
    arbitrated_dual_port_ram #(
        .W(1),                  // One write port (from AR channel)
        .R(N),                  // N read ports (one per slave)
        .D(2**ID_WIDTH),        // Depth based on ID width
        .WIDTH(LOG_M)           // Width to store master index
    ) rid_table (
        .clk(clk),
        .rstn(rstn),
        .we_i(busARVld_i!=0),     // Write on valid AR transaction
        .wadr_i(busARId_i),     // Address = transaction ID
        .wdat_i(busARSrc_i),    // Data = source master index
        .re_i(rid_re),     // Read when lookup requested
        .radr_i(s_axi_rid),     // Address = response ID
        .rdat_o(rid_dest),      // Data = destination master
        .rdRdy_o(rid_valid)     // Valid signal for lookup result
    );

    // BID table to track master destination for write responses
    arbitrated_dual_port_ram #(
        .W(1),                  // One write port (from AW channel)
        .R(N),                  // N read ports (one per slave)
        .D(2**ID_WIDTH),        // Depth based on ID width
        .WIDTH(LOG_M)           // Width to store master index
    ) bid_table (
        .clk(clk),
        .rstn(rstn),
        .we_i(busAWVld_i!=0),     // Write on valid AW transaction
        .wadr_i(busAWId_i),     // Address = transaction ID
        .wdat_i(busAWSrc_i),    // Data = source master index
        .re_i(s_axi_bvalid),     // Read when lookup requested
        .radr_i(s_axi_bid),     // Address = response ID
        .rdat_o(bid_dest),      // Data = destination master
        .rdRdy_o(bid_valid)     // Valid signal for lookup result
    );


    // Read/write response target buffer
    logic [LOG_M-1:0] rtarget, wtarget;

    always_comb begin
        rtarget = '0;
        wtarget = '0;
        for (int i = 0; i < N; i++) begin
            if (s_axi_rvalid[i] & rtargetVld_r[i]) begin
                rtarget = rtargetBuf_r[i];
            end
            if (s_axi_bvalid[i] & wtargetVld_r[i]) begin
                wtarget = wtargetBuf_r[i];
            end
        end
    end
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rtargetVld_r <= '0;
            wtargetVld_r <= '0;
            for (int i = 0; i < N; i++) begin
                rtargetBuf_r[i] <= '0;
                wtargetBuf_r[i] <= '0;
            end
        end else begin
            rtargetVld_r <= rtargetVld_r | rid_valid;
            wtargetVld_r <= wtargetVld_r | bid_valid;
            for (int i = 0; i < N; i++) begin
                if (rid_valid[i]) begin
                    rtargetVld_r[i] <= 1'b1;
                    rtargetBuf_r[i] <= rid_dest[i];
                end
                if (bid_valid[i]) begin
                    wtargetBuf_r[i] <= bid_dest[i];
                end
            end
        end
    end


    // Pack read data from all slaves
    logic [WIDTH+ID_WIDTH+2+1-1:0] r_src_data[N];

    // Pack data for each slave
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_r_data
            assign r_src_data[i] = {s_axi_rdata[i], s_axi_rid[i], s_axi_rresp[i], s_axi_rlast[i]};
        end
    endgenerate

    // R channel arbiter
    channel_arbiter #(
        .S(N),                 // N slaves as sources
        .D(M),                 // M masters as destinations
        .WIDTH(WIDTH+ID_WIDTH+2+1)     // Data+ID+Resp+Last
    ) r_arbiter (
        .clk(clk),
        .rstn(rstn),
        .srcVld_i(s_axi_rvalid & rtargetVld_r), // Only valid if target known
        .grantRdy_o(s_axi_rready),
        .srcDat_i(r_src_data),
        .srcTarget_i(rtargetBuf_r),
        .dstVld_o(busRVld_o),
        .dstRdy_i(busRRdy_i),
        .dstDat_o({busRData_o, busRId_o, busRResp_o, busRLast_o})
        // dstSrc_o not used since there is no feedback to slaves
    );


    // Pack write response data from all slaves
    logic [ID_WIDTH+2-1:0] b_src_data[N];

    // Pack data for each slave
    generate
        for (i = 0; i < N; i++) begin : gen_b_data
            assign b_src_data[i] = {s_axi_bid[i], s_axi_bresp[i]};
        end
    endgenerate

    // B channel arbiter
    channel_arbiter #(
        .S(N),          // N slaves as sources
        .D(M),          // M masters as destinations
        .WIDTH(ID_WIDTH+2)      // ID+Resp
    ) b_arbiter (
        .clk(clk),
        .rstn(rstn),
        .srcVld_i(s_axi_bvalid & wtargetVld_r), // Only valid if write target is known
        .grantRdy_o(s_axi_bready),
        .srcDat_i(b_src_data),
        //input  [LOG_M-1:0]              srcTarget_i[N],      // Destination indices from sources
        .srcTarget_i(wtargetBuf_r),
        .dstVld_o(busBVld_o),
        .dstRdy_i(busBRdy_i),
        .dstDat_o({busBId_o, busBResp_o})
        // dstSrc_o not used since there is no feedback to slaves
    );

endmodule