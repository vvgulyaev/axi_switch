// axi_switch.sv - Top-level wrapper connecting master and slave switches for AXI4 crossbar

/*
axi_switch
    - master_switch: handles AR, AW, W channels from masters to slaves
        - 3 channel aribiter instances inside
    - slave_switch: handles R, B channels from slaves to masters
        - 2 channel arbiter instances inside
        - 2 arbitrated mutliple-port memory for RID and BID lookup tables
*/

module axi_switch #(
    // Number of masters and slaves
    parameter int M = 4,                       // Number of masters
    parameter int N = 4,                       // Number of slaves

    // AXI parameters
    parameter int AW = 32,                     // Address width
    parameter int DW = 64,                     // Data width
    parameter int IDW = 4,                     // ID width

    // Derived parameters - do not override
    parameter int LOG_M = (M > 1) ? $clog2(M) : 1,
    parameter int LOG_N = (N > 1) ? $clog2(N) : 1
) (
    // Clock and reset
    input  logic                   clk,
    input  logic                   rstn,

    // Master ports (M masters)
    // AR channel
    input  logic [M-1:0]    m_axi_arvalid,
    output logic [M-1:0]    m_axi_arready,
    input  logic [AW-1:0]   m_axi_araddr[M],
    input  logic [IDW-1:0]  m_axi_arid[M],
    input  logic [7:0]      m_axi_arlen[M],
    input  logic [2:0]      m_axi_arsize[M],
    input  logic [1:0]      m_axi_arburst[M],

    // AW channel
    input  logic [M-1:0]    m_axi_awvalid,
    output logic [M-1:0]    m_axi_awready,
    input  logic [AW-1:0]   m_axi_awaddr[M],
    input  logic [IDW-1:0]  m_axi_awid[M],
    input  logic [7:0]      m_axi_awlen[M],
    input  logic [2:0]      m_axi_awsize[M],
    input  logic [1:0]      m_axi_awburst[M],

    // W channel
    input  logic [M-1:0]    m_axi_wvalid,
    output logic [M-1:0]    m_axi_wready,
    input  logic [DW-1:0]   m_axi_wdata[M],
    input  logic [DW/8-1:0] m_axi_wstrb[M],
    input  logic [M-1:0]    m_axi_wlast,

    // R channel
    output logic [M-1:0]    m_axi_rvalid,
    input  logic [M-1:0]    m_axi_rready,
    output logic [DW-1:0]   m_axi_rdata[M],
    output logic [IDW-1:0]  m_axi_rid[M],
    output logic [1:0]      m_axi_rresp[M],
    output logic [M-1:0]    m_axi_rlast,

    // B channel
    output logic [M-1:0]    m_axi_bvalid,
    input  logic [M-1:0]    m_axi_bready,
    output logic [IDW-1:0]  m_axi_bid[M],
    output logic [1:0]      m_axi_bresp[M],

    // Slave ports (N slaves)
    // AR channel
    output logic [N-1:0]    s_axi_arvalid,
    input  logic [N-1:0]    s_axi_arready,
    output logic [AW-1:0]   s_axi_araddr[N],
    output logic [IDW-1:0]  s_axi_arid[N],
    output logic [7:0]      s_axi_arlen[N],
    output logic [2:0]      s_axi_arsize[N],
    output logic [1:0]      s_axi_arburst[N],

    // AW channel
    output logic [N-1:0]    s_axi_awvalid,
    input  logic [N-1:0]    s_axi_awready,
    output logic [AW-1:0]   s_axi_awaddr[N],
    output logic [IDW-1:0]  s_axi_awid[N],
    output logic [7:0]      s_axi_awlen[N],
    output logic [2:0]      s_axi_awsize[N],
    output logic [1:0]      s_axi_awburst[N],

    // W channel
    output logic [N-1:0]    s_axi_wvalid,
    input  logic [N-1:0]    s_axi_wready,
    output logic [DW-1:0]   s_axi_wdata[N],
    output logic [DW/8-1:0] s_axi_wstrb[N],
    output logic            s_axi_wlast[N],

    // R channel
    input  logic [N-1:0]    s_axi_rvalid,
    output logic [N-1:0]    s_axi_rready,
    input  logic [DW-1:0]   s_axi_rdata[N],
    input  logic [IDW-1:0]  s_axi_rid[N],
    input  logic [1:0]      s_axi_rresp[N],
    input  logic            s_axi_rlast[N],

    // B channel
    input  logic [N-1:0]    s_axi_bvalid,
    output logic [N-1:0]    s_axi_bready,
    input  logic [IDW-1:0]  s_axi_bid[N],
    input  logic [1:0]      s_axi_bresp[N]
);

    // Unpack input arrays for module interfaces
    logic [AW-1:0]   m_axi_araddr_u[M];
    logic [IDW-1:0]  m_axi_arid_u[M];
    logic [7:0]      m_axi_arlen_u[M];
    logic [2:0]      m_axi_arsize_u[M];
    logic [1:0]      m_axi_arburst_u[M];

    logic [AW-1:0]   m_axi_awaddr_u[M];
    logic [IDW-1:0]  m_axi_awid_u[M];
    logic [7:0]      m_axi_awlen_u[M];
    logic [2:0]      m_axi_awsize_u[M];
    logic [1:0]      m_axi_awburst_u[M];

    logic [DW-1:0]   m_axi_wdata_u[M];
    logic [DW/8-1:0] m_axi_wstrb_u[M];
    logic            m_axi_wlast_u[M];

    logic [DW-1:0]   s_axi_rdata_u[N];
    logic [IDW-1:0]  s_axi_rid_u[N];
    logic [1:0]      s_axi_rresp_u[N];
    logic            s_axi_rlast_u[N];
    logic [1:0]      s_axi_bresp_u[N];
    logic [IDW-1:0]  s_axi_bid_u[N];

    // Pack output arrays for module interfaces
    logic [DW-1:0]   m_axi_rdata_unpacked[M];
    logic [IDW-1:0]  m_axi_rid_unpacked[M];
    logic [1:0]      m_axi_rresp_unpacked[M];
    logic            m_axi_rlast_unpacked[M];
    logic [1:0]      m_axi_bresp_unpacked[M];
    logic [IDW-1:0]  m_axi_bid_unpacked[M];

    logic [AW-1:0]   s_axi_araddr_unpacked[N];
    logic [IDW-1:0]  s_axi_arid_unpacked[N];
    logic [7:0]      s_axi_arlen_unpacked[N];
    logic [2:0]      s_axi_arsize_unpacked[N];
    logic [1:0]      s_axi_arburst_unpacked[N];

    logic [AW-1:0]   s_axi_awaddr_unpacked[N];
    logic [IDW-1:0]  s_axi_awid_unpacked[N];
    logic [7:0]      s_axi_awlen_unpacked[N];
    logic [2:0]      s_axi_awsize_unpacked[N];
    logic [1:0]      s_axi_awburst_unpacked[N];

    logic [DW-1:0]   s_axi_wdata_unpacked[N];
    logic [DW/8-1:0] s_axi_wstrb_unpacked[N];
    logic            s_axi_wlast_unpacked[N];

    // Convert input packed to unpacked arrays and output unpacked to packed arrays
    genvar i;
    generate
        for (i = 0; i < M; i++) begin : gen_master_convert
            // Unpack master inputs
            assign m_axi_araddr_u[i] = m_axi_araddr[i];
            assign m_axi_arid_u[i] = m_axi_arid[i];
            assign m_axi_arlen_u[i] = m_axi_arlen[i];
            assign m_axi_arsize_u[i] = m_axi_arsize[i];
            assign m_axi_arburst_u[i] = m_axi_arburst[i];

            assign m_axi_awaddr_u[i] = m_axi_awaddr[i];
            assign m_axi_awid_u[i] = m_axi_awid[i];
            assign m_axi_awlen_u[i] = m_axi_awlen[i];
            assign m_axi_awsize_u[i] = m_axi_awsize[i];
            assign m_axi_awburst_u[i] = m_axi_awburst[i];

            assign m_axi_wdata_u[i] = m_axi_wdata[i];
            assign m_axi_wstrb_u[i] = m_axi_wstrb[i];
            assign m_axi_wlast_u[i] = m_axi_wlast[i];

            // Pack master outputs
            assign m_axi_rdata[i] = m_axi_rdata_unpacked[i];
            assign m_axi_rid[i] = m_axi_rid_unpacked[i];
            assign m_axi_rresp[i] = m_axi_rresp_unpacked[i];
            assign m_axi_rlast[i] = m_axi_rlast_unpacked[i];
            assign m_axi_bresp[i] = m_axi_bresp_unpacked[i];
            assign m_axi_bid[i] = m_axi_bid_unpacked[i];
        end

        for (i = 0; i < N; i++) begin : gen_slave_convert
            // Pack slave outputs
            assign s_axi_araddr[i] = s_axi_araddr_unpacked[i];
            assign s_axi_arid[i] = s_axi_arid_unpacked[i];
            assign s_axi_arlen[i] = s_axi_arlen_unpacked[i];
            assign s_axi_arsize[i] = s_axi_arsize_unpacked[i];
            assign s_axi_arburst[i] = s_axi_arburst_unpacked[i];

            assign s_axi_awaddr[i] = s_axi_awaddr_unpacked[i];
            assign s_axi_awid[i] = s_axi_awid_unpacked[i];
            assign s_axi_awlen[i] = s_axi_awlen_unpacked[i];
            assign s_axi_awsize[i] = s_axi_awsize_unpacked[i];
            assign s_axi_awburst[i] = s_axi_awburst_unpacked[i];

            assign s_axi_wdata[i] = s_axi_wdata_unpacked[i];
            assign s_axi_wstrb[i] = s_axi_wstrb_unpacked[i];
            assign s_axi_wlast[i] = s_axi_wlast_unpacked[i];

            // Unpack slave inputs
            assign s_axi_rdata_u[i] = s_axi_rdata[i];
            assign s_axi_rid_u[i] = s_axi_rid[i];
            assign s_axi_rresp_u[i] = s_axi_rresp[i];
            assign s_axi_rlast_u[i] = s_axi_rlast[i];
            assign s_axi_bresp_u[i] = s_axi_bresp[i];
            assign s_axi_bid_u[i] = s_axi_bid[i];
        end
    endgenerate

    // Arbitrated channel buses connecting master_switch and slave_switch
    // AR channel
    logic [M-1:0]        busARVld;
    logic [N-1:0]        busARRdy;
    logic [AW-1:0]       busARAddr;
    logic [IDW-1:0]      busARId;
    logic [7:0]          busARLen;
    logic [2:0]          busARSz;
    logic [1:0]          busARBurst;
    logic [LOG_M-1:0]    busARSrc;
    logic [LOG_N-1:0]    busARDst;

    // AW channel
    logic [M-1:0]        busAWVld;
    logic [N-1:0]        busAWRdy;
    logic [AW-1:0]       busAWAddr;
    logic [IDW-1:0]      busAWId;
    logic [7:0]          busAWLen;
    logic [2:0]          busAWSz;
    logic [1:0]          busAWBurst;
    logic [LOG_M-1:0]    busAWSrc;
    logic [LOG_N-1:0]    busAWDst;

    // W channel
    logic [M-1:0]        busWVld;
    logic [N-1:0]        busWRdy;
    logic [DW-1:0]       busWData;
    logic [DW/8-1:0]     busWStrb;
    logic                busWLast;
    logic [LOG_M-1:0]    busWSrc;
    logic [LOG_N-1:0]    busWDst;

    // R channel
    logic [N-1:0]        busRVld;
    logic [M-1:0]        busRRdy;
    logic [DW-1:0]       busRData;
    logic [IDW-1:0]      busRId;
    logic [1:0]          busRResp;
    logic                busRLast;

    // B channel
    logic [N-1:0]        busBVld;
    logic [M-1:0]        busBRdy;
    logic [IDW-1:0]      busBId;
    logic [1:0]          busBResp;

    // Calculate destinations from addresses
    assign busARDst = busARAddr[AW-1 : AW-LOG_N];
    assign busAWDst = busAWAddr[AW-1 : AW-LOG_N];
    assign busWDst = busAWAddr[AW-1 : AW-LOG_N]; // Use AW address for W destination

    // Instantiate master_switch (handles AR, AW, W channels from masters to slaves)
    master_switch #(
        .M          (M),
        .N          (N),
        .WIDTH      (DW),
        .ID_WIDTH   (IDW),
        .ADDR_WIDTH (AW)
    ) u_master_switch (
        .clk                (clk),
        .rstn               (rstn),
        // Master interfaces
        .m_axi_arvalid      (m_axi_arvalid),
        .m_axi_arready      (m_axi_arready),
        .m_axi_araddr       (m_axi_araddr_u),
        .m_axi_arid         (m_axi_arid_u),
        .m_axi_arlen        (m_axi_arlen_u),
        .m_axi_arsize       (m_axi_arsize_u),
        .m_axi_arburst      (m_axi_arburst_u),

        .m_axi_awvalid      (m_axi_awvalid),
        .m_axi_awready      (m_axi_awready),
        .m_axi_awaddr       (m_axi_awaddr_u),
        .m_axi_awid         (m_axi_awid_u),
        .m_axi_awlen        (m_axi_awlen_u),
        .m_axi_awsize       (m_axi_awsize_u),
        .m_axi_awburst      (m_axi_awburst_u),

        .m_axi_wvalid       (m_axi_wvalid),
        .m_axi_wready       (m_axi_wready),
        .m_axi_wdata        (m_axi_wdata_u),
        .m_axi_wstrb        (m_axi_wstrb_u),
        .m_axi_wlast        (m_axi_wlast_u),

        .m_axi_rvalid       (m_axi_rvalid),
        .m_axi_rready       (m_axi_rready),
        .m_axi_rdata        (m_axi_rdata_unpacked),
        .m_axi_rid          (m_axi_rid_unpacked),
        .m_axi_rresp        (m_axi_rresp_unpacked),
        .m_axi_rlast        (m_axi_rlast_unpacked),

        .m_axi_bvalid       (m_axi_bvalid),
        .m_axi_bready       (m_axi_bready),
        .m_axi_bid          (m_axi_bid_unpacked),
        .m_axi_bresp        (m_axi_bresp_unpacked),

        // Arbitrated channel buses
        .busARVld_o         (busARVld),
        .busARRdy_i         (busARRdy),
        .busARAddr_o        (busARAddr),
        .busARId_o          (busARId),
        .busARLen_o         (busARLen),
        .busARSz_o          (busARSz),
        .busARBurst_o       (busARBurst),
        .busARSrc_o         (busARSrc),

        .busAWVld_o         (busAWVld),
        .busAWRdy_i         (busAWRdy),
        .busAWAddr_o        (busAWAddr),
        .busAWId_o          (busAWId),
        .busAWLen_o         (busAWLen),
        .busAWSz_o          (busAWSz),
        .busAWBurst_o       (busAWBurst),
        .busAWSrc_o         (busAWSrc),

        .busWVld_o          (busWVld),
        .busWRdy_i          (busWRdy),
        .busWData_o         (busWData),
        .busWStrb_o         (busWStrb),
        .busWLast_o         (busWLast),
        .busWSrc_o          (busWSrc),

        .busRVld_i          (busRVld),
        .busRRdy_o          (busRRdy),
        .busRData_i         (busRData),
        .busRId_i           (busRId),
        .busRResp_i         (busRResp),
        .busRLast_i         (busRLast),

        .busBVld_i          (busBVld),
        .busBRdy_o          (busBRdy),
        .busBId_i           (busBId),
        .busBResp_i         (busBResp)
    );

    // Instantiate slave_switch (handles R, B channels from slaves to masters)
    slave_switch #(
        .M          (M),
        .N          (N),
        .WIDTH      (DW),
        .ID_WIDTH   (IDW),
        .ADDR_WIDTH (AW)
    ) u_slave_switch (
        .clk                (clk),
        .rstn               (rstn),

        // Slave interfaces
        .s_axi_arvalid      (s_axi_arvalid),
        .s_axi_arready      (s_axi_arready),
        .s_axi_araddr       (s_axi_araddr_unpacked),
        .s_axi_arid         (s_axi_arid_unpacked),
        .s_axi_arlen        (s_axi_arlen_unpacked),
        .s_axi_arsize(s_axi_arsize_unpacked),
        .s_axi_arburst(s_axi_arburst_unpacked),

        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_awaddr(s_axi_awaddr_unpacked),
        .s_axi_awid(s_axi_awid_unpacked),
        .s_axi_awlen(s_axi_awlen_unpacked),
        .s_axi_awsize(s_axi_awsize_unpacked),
        .s_axi_awburst(s_axi_awburst_unpacked),

        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_wdata(s_axi_wdata_unpacked),
        .s_axi_wstrb(s_axi_wstrb_unpacked),
        .s_axi_wlast(s_axi_wlast_unpacked),

        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready),
        .s_axi_rdata(s_axi_rdata_u),
        .s_axi_rid(s_axi_rid_u),
        .s_axi_rresp(s_axi_rresp_u),
        .s_axi_rlast(s_axi_rlast_u),

        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bid(s_axi_bid_u),
        .s_axi_bresp(s_axi_bresp_u),

        // Arbitrated channel buses - to be connected properly
        .busARVld_i(busARVld),
        .busARRdy_o(busARRdy),
        .busARAddr_i(busARAddr),
        .busARId_i(busARId),
        .busARLen_i(busARLen),
        .busARSz_i(busARSz),
        .busARBurst_i(busARBurst),
        .busARSrc_i(busARSrc),
        .busARDst_i(/* Need destination logic */),

        .busAWVld_i(busAWVld),
        .busAWRdy_o(busAWRdy),
        .busAWAddr_i(busAWAddr),
        .busAWId_i(busAWId),
        .busAWLen_i(busAWLen),
        .busAWSz_i(busAWSz),
        .busAWBurst_i(busAWBurst),
        .busAWSrc_i(busAWSrc),
        .busAWDst_i(/* Need destination logic */),

        .busWVld_i(busWVld),
        .busWRdy_o(busWRdy),
        .busWData_i(busWData),
        .busWStrb_i(busWStrb),
        .busWLast_i(busWLast),
        .busWSrc_i(busWSrc),
        .busWDst_i(/* Need destination logic */),

        .busRVld_o(busRVld),
        .busRRdy_i(busRRdy),
        .busRData_o(busRData),
        .busRId_o(busRId),
        .busRResp_o(busRResp),
        .busRLast_o(busRLast),
        .busRSrc_o(/* Not used */),
        .busRDst_o(/* Not used */),

        .busBVld_o(busBVld),
        .busBRdy_i(busBRdy),
        .busBId_o(busBId),
        .busBResp_o(busBResp),
        .busBSrc_o(/* Not used */),
        .busBDst_o(/* Not used */)
    );

endmodule