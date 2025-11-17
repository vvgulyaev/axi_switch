/*
Master Arbiter Module for AXI4 Switch
Manages two channel arbiters for R and B channels, routing responses from M slaves to N masters.
Includes RID/BID tables with destination buffers for response routing.
*/

module master_switch #(
    parameter N = 2,           // Number of slave ports connected to masters
    parameter M = 2,           // Number of master ports connected to slaves
    parameter WIDTH = 32,      // Data width
    parameter ID_WIDTH = 4,    // ID width
    parameter ADDR_WIDTH = 32, // Address width
    parameter LOG_N = (N > 1) ? $clog2(N) : 1, // Width of master index
    parameter LOG_M = (M > 1) ? $clog2(M) : 1  // Width of slave index
) (
    // Clock and reset
    input  logic                     clk,
    input  logic                     rstn,

    // Slave module interface (M slaves)
    output logic [M-1:0]            m_axi_arvalid,
    input  logic [M-1:0]            m_axi_arready,
    output logic [ID_WIDTH-1:0]     m_axi_arid[M],
    output logic [ADDR_WIDTH-1:0]   m_axi_araddr[M],
    output logic [7:0]              m_axi_arlen[M],
    output logic [2:0]              m_axi_arsize[M],
    output logic [1:0]              m_axi_arburst[M],

    output logic [M-1:0]            m_axi_awvalid,
    input  logic [M-1:0]            m_axi_awready,
    output logic [ID_WIDTH-1:0]     m_axi_awid[M],
    output logic [ADDR_WIDTH-1:0]   m_axi_awaddr[M],
    output logic [7:0]              m_axi_awlen[M],
    output logic [2:0]              m_axi_awsize[M],
    output logic [1:0]              m_axi_awburst[M],

    output logic [M-1:0]             m_axi_wvalid,
    input  logic [M-1:0]             m_axi_wready,
    output logic [WIDTH-1:0]         m_axi_wdata[M],
    output logic [WIDTH/8-1:0]       m_axi_wstrb[M],
    output logic                     m_axi_wlast[M],

    input  logic [M-1:0]             m_axi_rvalid,
    output logic [M-1:0]             m_axi_rready,
    input  logic [ID_WIDTH-1:0]      m_axi_rid[M],
    input  logic [WIDTH-1:0]         m_axi_rdata[M],
    input  logic [1:0]               m_axi_rresp[M],
    input  logic                     m_axi_rlast[M],

    input  logic [M-1:0]             m_axi_bvalid,
    output logic [M-1:0]             m_axi_bready,
    input  logic [ID_WIDTH-1:0]      m_axi_bid[M],
    input  logic [1:0]               m_axi_bresp[M],

    // Arbitrated channel buses
    // AR channel (from master switch)
    input  logic [M-1:0]                   busARVld_i,
    output logic [M-1:0]                   busARRdy_o,
    input  logic [ADDR_WIDTH-1:0]          busARAddr_i,
    input  logic [ID_WIDTH-1:0]            busARId_i,
    input  logic [7:0]                     busARLen_i,
    input  logic [2:0]                     busARSz_i,
    input  logic [1:0]                     busARBurst_i,
    input  logic [LOG_N-1:0]               busARSrc_i,
    input  logic [LOG_M-1:0]               busARDst_i,

    // AW channel (from master switch)
    input  logic [M-1:0]                   busAWVld_i,
    output logic [M-1:0]                   busAWRdy_o,
    input  logic [ADDR_WIDTH-1:0]          busAWAddr_i,
    input  logic [ID_WIDTH-1:0]            busAWId_i,
    input  logic [7:0]                     busAWLen_i,
    input  logic [2:0]                     busAWSz_i,
    input  logic [1:0]                     busAWBurst_i,
    input  logic [LOG_N-1:0]               busAWSrc_i,
    input  logic [LOG_M-1:0]               busAWDst_i,

    // W channel (from master switch)
    input  logic [M-1:0]                    busWVld_i,
    output logic [M-1:0]                    busWRdy_o,
    input  [WIDTH-1:0]                      busWData_i,
    input  [WIDTH/8-1:0]                    busWStrb_i,
    input  logic                            busWLast_i,
    input  [LOG_N-1:0]                      busWSrc_i,
    input  [LOG_M-1:0]                      busWDst_i,

    // R channel (to master switch)
    output [N-1:0]                          busRVld_o,
    input  [N-1:0]                          busRRdy_i,
    output [WIDTH-1:0]                      busRData_o,
    output [ID_WIDTH-1:0]                   busRId_o,
    output [1:0]                            busRResp_o,
    output logic                            busRLast_o,
    output [LOG_M-1:0]                      busRSrc_o,
    output [LOG_N-1:0]                      busRDst_o,

    // B channel (to master switch)
    output [N-1:0]                          busBVld_o,
    input  [N-1:0]                          busBRdy_i,
    output [ID_WIDTH-1:0]                   busBId_o,
    output [1:0]                            busBResp_o,
    output [LOG_M-1:0]                      busBSrc_o,
    output [LOG_N-1:0]                      busBDst_o
);

    // AR channel registers
    logic [M-1:0]            bum_axi_arvalid, bum_axi_arvalid_r;
    logic [ID_WIDTH-1:0]     bum_axi_arid, bum_axi_arid_r;
    logic [ADDR_WIDTH-1:0]   bum_axi_araddr, bum_axi_araddr_r;
    logic [7:0]              bum_axi_arlen, bum_axi_arlen_r;
    logic [2:0]              bum_axi_arsize, bum_axi_arsize_r;
    logic [1:0]              bum_axi_arburst, bum_axi_arburst_r;

    logic [M-1:0]            m_axi_arvalid_w;
    logic [M-1:0]            m_axi_arready_w;
    logic [ID_WIDTH-1:0]     m_axi_arid_w[M];
    logic [ADDR_WIDTH-1:0]   m_axi_araddr_w[M];
    logic [7:0]              m_axi_arlen_w[M];
    logic [2:0]              m_axi_arsize_w[M];
    logic [1:0]              m_axi_arburst_w[M];

    logic [M-1:0]            clr_bum_arvalid;

    // AW channel registers
    logic [M-1:0]            bum_axi_awvalid, bum_axi_awvalid_r;
    logic [ID_WIDTH-1:0]     bum_axi_awid, bum_axi_awid_r;
    logic [ADDR_WIDTH-1:0]   bum_axi_awaddr, bum_axi_awaddr_r;
    logic [7:0]              bum_axi_awlen, bum_axi_awlen_r;
    logic [2:0]              bum_axi_awsize, bum_axi_awsize_r;
    logic [1:0]              bum_axi_awburst, bum_axi_awburst_r;

    // W channel registers
    logic [M-1:0]            bum_axi_wvalid, bum_axi_wvalid_r;
    logic [WIDTH-1:0]        bum_axi_wdata, bum_axi_wdata_r;
    logic [WIDTH/8-1:0]      bum_axi_wstrb, bum_axi_wstrb_r;
    logic                    bum_axi_wlast, bum_axi_wlast_r;

    // Internal signals for tracking rid/bid lookups
    logic [M-1:0]            rid_re;
    logic [M-1:0]            rid_valid;
    logic [LOG_N-1:0]        rid_dest;
    logic [M-1:0]            bid_re;
    logic [M-1:0]            bid_valid;
    logic [LOG_N-1:0]        bid_dest;
    reg [M-1:0]              rtargetVld_r, wtargetVld_r;  // Valid signals for target buffers
    reg [LOG_N-1:0]          rtargetBuf_r[M], wtargetBuf_r[M];  // Target master matrix

    logic [ID_WIDTH-1:0]     busAWId[1];
    logic [LOG_N-1:0]        busAWSrc[1];
    logic [ID_WIDTH-1:0]     busARId[1];
    logic [LOG_N-1:0]        busARSrc[1];


    logic [M-1:0]            m_axi_awvalid_w;
    logic [M-1:0]            m_axi_awready_w;
    logic [ID_WIDTH-1:0]     m_axi_awid_w[M];
    logic [ADDR_WIDTH-1:0]   m_axi_awaddr_w[M];
    logic [7:0]              m_axi_awlen_w[M];
    logic [2:0]              m_axi_awsize_w[M];
    logic [1:0]              m_axi_awburst_w[M];

    logic [M-1:0]            clr_bum_awvalid;

    logic [M-1:0]             m_axi_wvalid_w;
    logic [WIDTH-1:0]         m_axi_wdata_w[M];
    logic [WIDTH/8-1:0]       m_axi_wstrb_w[M];
    logic                     m_axi_wlast_w[M];
    logic [M-1:0]             clr_bum_wvalid;


    // Connect registered signals to outputs
    always_comb begin
        for (int r = 0; r < M; r++) begin : gen_r_target
            // Request lookup when valid response received without destination info
            rid_re[r] = m_axi_rvalid[r] & ~rtargetVld_r[r];
            // Set target based on lookup result
            /*if (rid_valid[r]) begin
                rtargetVld_r[r] = 1'b1;
                rtargetBuf_r[r] = rid_dest;
            end*/
        end

        //avoid compilation errors at connecting to rid and bid tables
        busAWId[0] = busAWId_i;
        busAWSrc[0] = busAWSrc_i;
        busARId[0] = busARId_i;
        busARSrc[0] = busARSrc_i;
    end

    // Forward valids of requesting channels to slave requesting channels and ready back
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            bum_axi_arvalid_r <= '0;
            bum_axi_arid_r <= '0;
            bum_axi_araddr_r <= '0;
            bum_axi_arlen_r <= '0;
            bum_axi_arsize_r <= '0;
            bum_axi_arburst_r <= '0;

            m_axi_arvalid <= 0;
            m_axi_arid    <= '{default: '0};
            m_axi_araddr  <= '{default: '0};
            m_axi_arlen   <= '{default: '0};
            m_axi_arsize  <= '{default: '0};
            m_axi_arburst <= '{default: '0};

            bum_axi_awvalid_r <= '0;
            bum_axi_awid_r <= '0;
            bum_axi_awaddr_r <= '0;
            bum_axi_awlen_r <= '0;
            bum_axi_awsize_r <= '0;
            bum_axi_awburst_r <= '0;

            bum_axi_wvalid_r <= '0;
            bum_axi_wdata_r <= '0;
            bum_axi_wstrb_r <= '0;
            bum_axi_wlast_r <= '0;

            m_axi_awvalid <= 0;
            m_axi_awid    <= '{default: '0};
            m_axi_awaddr  <= '{default: '0};
            m_axi_awlen   <= '{default: '0};
            m_axi_awsize  <= '{default: '0};
            m_axi_awburst <= '{default: '0};

            m_axi_wvalid <= 0;
            m_axi_wdata <= '{default: '0};
            m_axi_wstrb <= '{default: '0};
            m_axi_wlast <= '{default: '0};
        end else begin
            bum_axi_arvalid_r   <= bum_axi_arvalid;
            bum_axi_arid_r      <= bum_axi_arid;
            bum_axi_araddr_r    <= bum_axi_araddr;
            bum_axi_arlen_r     <= bum_axi_arlen;
            bum_axi_arsize_r    <= bum_axi_arsize;
            bum_axi_arburst_r   <= bum_axi_arburst;

            m_axi_arvalid <= m_axi_arvalid_w;
            m_axi_arid    <= m_axi_arid_w;
            m_axi_araddr  <= m_axi_araddr_w;
            m_axi_arlen   <= m_axi_arlen_w;
            m_axi_arsize  <= m_axi_arsize_w;
            m_axi_arburst <= m_axi_arburst_w;

            bum_axi_awvalid_r   <= bum_axi_awvalid;
            bum_axi_awid_r      <= bum_axi_awid;
            bum_axi_awaddr_r    <= bum_axi_awaddr;
            bum_axi_awlen_r     <= bum_axi_awlen;
            bum_axi_awsize_r    <= bum_axi_awsize;
            bum_axi_awburst_r   <= bum_axi_awburst;

            bum_axi_wvalid_r <= bum_axi_wvalid;
            bum_axi_wdata_r <= bum_axi_wdata;
            bum_axi_wstrb_r <= bum_axi_wstrb;
            bum_axi_wlast_r <= bum_axi_wlast;

            m_axi_awvalid <= m_axi_awvalid_w;
            m_axi_awid    <= m_axi_awid_w;
            m_axi_awaddr  <= m_axi_awaddr_w;
            m_axi_awlen   <= m_axi_awlen_w;
            m_axi_awsize  <= m_axi_awsize_w;
            m_axi_awburst <= m_axi_awburst_w;

            m_axi_wvalid <= m_axi_wvalid_w;
            m_axi_wdata  <= m_axi_wdata_w;
            m_axi_wstrb  <= m_axi_wstrb_w;
            m_axi_wlast  <= m_axi_wlast_w;

        end
    end

    //-----------------------------------------------
    //Stage 0: AXI Read address buffer
    //-----------------------------------------------
    always_comb begin
        busARRdy_o = 0;
        bum_axi_arvalid = bum_axi_arvalid_r;
        bum_axi_arid = bum_axi_arid_r;
        bum_axi_araddr = bum_axi_araddr_r;
        bum_axi_arlen = bum_axi_arlen_r;
        bum_axi_arsize = bum_axi_arsize_r;
        bum_axi_arburst = bum_axi_arburst_r;

        for (int i = 0; i < M; i++) begin
            if (busARVld_i[i] && (~bum_axi_arvalid_r[i] || clr_bum_arvalid[i])) begin
                busARRdy_o[i] = 1'b1;
                bum_axi_arvalid[i] = 1'b1;
                bum_axi_arid = busARId_i;
                bum_axi_araddr = busARAddr_i;
                bum_axi_arlen = busARLen_i;
                bum_axi_arsize = busARSz_i;
                bum_axi_arburst = busARBurst_i;
            end
            else if (clr_bum_arvalid[i]) begin
                bum_axi_arvalid[i] = 1'b0;
            end
        end
    end

    //-----------------------------------------------
    //Stage 1: AXI Read address output buffer
    //-----------------------------------------------
    always_comb begin
        clr_bum_arvalid = 0;

        m_axi_arvalid_w = m_axi_arvalid;
        m_axi_arid_w    = m_axi_arid;
        m_axi_araddr_w  = m_axi_araddr;
        m_axi_arlen_w   = m_axi_arlen;
        m_axi_arsize_w  = m_axi_arsize;
        m_axi_arburst_w = m_axi_arburst;

        for (int i=0; i<M; i++) begin
            if (m_axi_arvalid[i] && m_axi_arready[i]) begin
                m_axi_arvalid_w[i] = 1'b0;
                m_axi_arid_w[i]    = 0;
                m_axi_araddr_w[i]  = 0;
                m_axi_arlen_w[i]   = 0;
                m_axi_arsize_w[i]  = 0;
                m_axi_arburst_w[i] = 0;
            end
        end

        for (int i = 0; i < M; i++) begin
            if (~m_axi_arvalid_w[i] && bum_axi_arvalid_r[i]) begin
                clr_bum_arvalid[i] = 1;
                m_axi_arvalid_w[i] = 1;
                m_axi_arid_w[i]    = bum_axi_arid_r;
                m_axi_araddr_w[i]  = bum_axi_araddr_r;
                m_axi_arlen_w[i]   = bum_axi_arlen_r;
                m_axi_arsize_w[i]  = bum_axi_arsize_r;
                m_axi_arburst_w[i] = bum_axi_arburst_r;
            end
        end
    end


    //-----------------------------------------------
    //Stage 0: AXI Write address buffer
    //-----------------------------------------------
    always_comb begin
        busAWRdy_o = 0;
        bum_axi_awvalid = bum_axi_awvalid_r;
        bum_axi_awid = bum_axi_awid_r;
        bum_axi_awaddr = bum_axi_awaddr_r;
        bum_axi_awlen = bum_axi_awlen_r;
        bum_axi_awsize = bum_axi_awsize_r;
        bum_axi_awburst = bum_axi_awburst_r;

        for (int i = 0; i < M; i++) begin
            if (busAWVld_i[i] && (~bum_axi_awvalid_r[i] || clr_bum_awvalid[i])) begin
                busAWRdy_o[i] = 1'b1;
                bum_axi_awvalid[i] = 1'b1;
                bum_axi_awid = busAWId_i;
                bum_axi_awaddr = busAWAddr_i;
                bum_axi_awlen = busAWLen_i;
                bum_axi_awsize = busAWSz_i;
                bum_axi_awburst = busAWBurst_i;
            end
            else if (clr_bum_awvalid[i]) begin
                bum_axi_awvalid[i] = 1'b0;
            end
        end
    end

    //-----------------------------------------------
    //Stage 1: AXI Write address output buffer
    //-----------------------------------------------
    always_comb begin
        clr_bum_awvalid = 0;

        m_axi_awvalid_w = m_axi_awvalid;
        m_axi_awid_w    = m_axi_awid;
        m_axi_awaddr_w  = m_axi_awaddr;
        m_axi_awlen_w   = m_axi_awlen;
        m_axi_awsize_w  = m_axi_awsize;
        m_axi_awburst_w = m_axi_awburst;

        for (int i=0; i<M; i++) begin
            if (m_axi_awvalid[i] && m_axi_awready[i]) begin
                m_axi_awvalid_w[i] = 1'b0;
                m_axi_awid_w[i]    = 0;
                m_axi_awaddr_w[i]  = 0;
                m_axi_awlen_w[i]   = 0;
                m_axi_awsize_w[i]  = 0;
                m_axi_awburst_w[i] = 0;
            end
        end

        for (int i = 0; i < M; i++) begin
            if (~m_axi_awvalid_w[i] && bum_axi_awvalid_r[i]) begin
                clr_bum_awvalid[i] = 1;
                m_axi_awvalid_w[i] = 1;
                m_axi_awid_w[i]    = bum_axi_awid_r;
                m_axi_awaddr_w[i]  = bum_axi_awaddr_r;
                m_axi_awlen_w[i]   = bum_axi_awlen_r;
                m_axi_awsize_w[i]  = bum_axi_awsize_r;
                m_axi_awburst_w[i] = bum_axi_awburst_r;
            end
        end
    end

    //-----------------------------------------------
    //Stage 0: AXI Write data input buffer
    //-----------------------------------------------
    always_comb begin
        busWRdy_o = 0;

        bum_axi_wvalid = bum_axi_wvalid_r;
        bum_axi_wdata = bum_axi_wdata_r;
        bum_axi_wstrb = bum_axi_wstrb_r;
        bum_axi_wlast = bum_axi_wlast_r;

        for (int i = 0; i < M; i++) begin
            if (busWVld_i[i] && (~bum_axi_wvalid_r[i] || clr_bum_wvalid[i])) begin
                busWRdy_o[i] = 1'b1;
                bum_axi_wvalid[i] = 1'b1;
                bum_axi_wdata = busWData_i;
                bum_axi_wstrb = busWStrb_i;
                bum_axi_wlast = busWLast_i;
            end
            else if (clr_bum_wvalid[i]) begin
                bum_axi_wvalid[i] = 1'b0;
            end
        end
    end

    //-----------------------------------------------
    //Stage 1: AXI Write data output buffer
    //-----------------------------------------------
    always_comb begin
        clr_bum_wvalid = 0;

        m_axi_wvalid_w = m_axi_wvalid;
        m_axi_wdata_w = m_axi_wdata;
        m_axi_wstrb_w = m_axi_wstrb;
        m_axi_wlast_w = m_axi_wlast;

        for (int i=0; i<M; i++) begin
            if (m_axi_wvalid[i] && m_axi_wready[i]) begin
                m_axi_wvalid_w[i] = 1'b0;
                m_axi_wdata_w[i] = 0;
                m_axi_wstrb_w[i] = 0;
                m_axi_wlast_w[i] = 0;
            end
        end

        for (int i = 0; i < M; i++) begin
            if (~m_axi_wvalid_w[i] && bum_axi_wvalid_r[i]) begin
                clr_bum_wvalid[i] = 1;
                m_axi_wvalid_w[i] = 1;
                m_axi_wdata_w[i] = bum_axi_wdata_r;
                m_axi_wstrb_w[i] = bum_axi_wstrb_r;
                m_axi_wlast_w[i] = bum_axi_wlast_r;
            end
        end
    end

    // RID table to track master destination for read responses
    arbitrated_dual_port_ram #(
        .W      (1),                  // One write port (from AR channel)
        .R      (M),                  // M read ports (one per slave)
        .D      (2**ID_WIDTH),        // Depth based on ID width
        .WIDTH  (LOG_N)           // Width to store master index
    ) rid_table (
        .clk        (clk),
        .rstn       (rstn),
        .we_i       (busARVld_i!=0),     // Write on valid AR transaction
        .wadr_i     (busARId),     // Address = transaction ID
        .wdat_i     (busARSrc),    // Data = source master index
        .re_i       (rid_re),     // Read when lookup requested
        .radr_i     (m_axi_rid),     // Address = response ID
        .rdat_o     (rid_dest),      // Data = destination master
        .rdRdy_o    (rid_valid)     // Valid signal for lookup result
    );

    // BID table to track master destination for write responses
    arbitrated_dual_port_ram #(
        .W      (1),                  // One write port (from AW channel)
        .R      (M),                  // M read ports (one per slave)
        .D      (2**ID_WIDTH),        // Depth based on ID width
        .WIDTH  (LOG_N)           // Width to store master index
    ) bid_table (
        .clk        (clk),
        .rstn       (rstn),
        .we_i       (busAWVld_i!=0),     // Write on valid AW transaction
        .wadr_i     (busAWId),     // Address = transaction ID
        .wdat_i     (busAWSrc),    // Data = source master index
        .re_i       (m_axi_bvalid),     // Read when lookup requested
        .radr_i     (m_axi_bid),     // Address = response ID
        .rdat_o     (bid_dest),      // Data = destination master
        .rdRdy_o    (bid_valid)     // Valid signal for lookup result
    );


    // Read/write response target buffer
    logic [LOG_N-1:0] rtarget, wtarget;

    always_comb begin
        rtarget = '0;
        wtarget = '0;
        for (int i = 0; i < M; i++) begin
            if (m_axi_rvalid[i] & rtargetVld_r[i]) begin
                rtarget = rtargetBuf_r[i];
            end
            if (m_axi_bvalid[i] & wtargetVld_r[i]) begin
                wtarget = wtargetBuf_r[i];
            end
        end
    end
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            rtargetVld_r <= '0;
            wtargetVld_r <= '0;
            for (int i = 0; i < M; i++) begin
                rtargetBuf_r[i] <= '0;
                wtargetBuf_r[i] <= '0;
            end
        end else begin
            rtargetVld_r <= rtargetVld_r | rid_valid;
            wtargetVld_r <= wtargetVld_r | bid_valid;
            for (int i = 0; i < M; i++) begin
                if (rid_valid[i]) begin
                    rtargetVld_r[i] <= 1'b1;
                    rtargetBuf_r[i] <= rid_dest;
                end
                if (bid_valid[i]) begin
                    wtargetBuf_r[i] <= bid_dest;
                end
            end
        end
    end


    // Pack read data from all slaves
    logic [WIDTH+ID_WIDTH+2+1-1:0] r_src_data[M];

    // Pack data for each slave
    genvar i;
    generate
        for (i = 0; i < M; i++) begin : gen_r_data
            assign r_src_data[i] = {m_axi_rdata[i], m_axi_rid[i], m_axi_rresp[i], m_axi_rlast[i]};
        end
    endgenerate

    // R channel arbiter
    channel_arbiter #(
        .S(M),                 // M slaves as sources
        .D(N),                 // N masters as destinations
        .WIDTH(WIDTH+ID_WIDTH+2+1)     // Data+ID+Resp+Last
    ) r_arbiter (
        .clk            (clk),
        .rstn           (rstn),
        .srcVld_i       (m_axi_rvalid & rtargetVld_r), // Only valid if target known
        .grantRdy_o     (m_axi_rready),
        .srcDat_i       (r_src_data),
        .srcTarget_i    (rtargetBuf_r),
        .dstVld_o       (busRVld_o),
        .dstRdy_i       (busRRdy_i),
        .dstDat_o       ({busRData_o, busRId_o, busRResp_o, busRLast_o})
        // dstSrc_o not used since there is no feedback to slaves
    );


    // Pack write response data from all slaves
    logic [ID_WIDTH+2-1:0] b_src_data[M];

    // Pack data for each slave
    generate
        for (i = 0; i < M; i++) begin : gen_b_data
            assign b_src_data[i] = {m_axi_bid[i], m_axi_bresp[i]};
        end
    endgenerate

    // B channel arbiter
    channel_arbiter #(
        .S      (M),          // M slaves as sources
        .D      (N),          // N masters as destinations
        .WIDTH  (ID_WIDTH+2)      // ID+Resp
    ) b_arbiter (
        .clk            (clk),
        .rstn           (rstn),
        .srcVld_i       (m_axi_bvalid & wtargetVld_r), // Only valid if write target is known
        .grantRdy_o     (m_axi_bready),
        .srcDat_i       (b_src_data),
        //input  [LOG_N-1:0]              srcTarget_i[M],      // Destination indices from sources
        .srcTarget_i    (wtargetBuf_r),
        .dstVld_o       (busBVld_o),
        .dstRdy_i       (busBRdy_i),
        .dstDat_o       ({busBId_o, busBResp_o})
        // dstSrc_o not used since there is no feedback to slaves
    );

endmodule




