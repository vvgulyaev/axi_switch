module axi4_switch #(
    parameter M = 2,           // Number of master modules
    parameter N = 2,           // Number of slave modules
    parameter AW = 32,         // Address width
    parameter DW = 64,         // Data width
    parameter IDW = 4,         // ID width
    parameter LOG_N = (N > 1) ? $clog2(N) : 1, // Width of destination index
    parameter LOG_M = (M > 1) ? $clog2(M) : 1  // Width of source index
) (
    // Clock and reset
    input                           clk,
    input                           rstn,

    // AXI4 Slave Ports (Read) connected to master
    input        [M-1:0]           m_axi_arvalid,
    input        [AW-1:0]          m_axi_araddr[M],
    input        [IDW-1:0]         m_axi_arid[M],
    input        [1:0]             m_axi_arburst[M],
    input        [7:0]             m_axi_arlen[M],
    input        [7:0]             m_axi_arsize[M],
    input        [M-1:0]           m_axi_arready,
    output logic [M-1:0]           m_axi_rvalid,
    output logic [DW-1:0]          m_axi_rdata[M],
    output logic [IDW-1:0]         m_axi_rid[M],
    output logic [M-1:0]           m_axi_rlast,
    input        [M-1:0]           m_axi_rready,

    // AXI4 Slave Ports (Write) connected to master
    input        [M-1:0]           m_axi_awvalid,
    input        [AW-1:0]          m_axi_awaddr[M],
    input        [IDW-1:0]         m_axi_awid[M],
    output logic [M-1:0]           m_axi_awready,
    input        [1:0]             m_axi_awburst[M],
    input        [7:0]             m_axi_awlen[M],
    input        [7:0]             m_axi_awsize[M],
    input        [M-1:0]           m_axi_wvalid,
    input        [DW-1:0]          m_axi_wdata[M],
    output logic [M-1:0]           m_axi_wready,
    output logic [M-1:0]           m_axi_bvalid,
    output logic [1:0]             m_axi_bresp[M],
    output logic [IDW-1:0]         m_axi_bid[M],
    input        [M-1:0]           m_axi_bready,

    // AXI4 Master Ports (Read) connected to slave
    output logic [N-1:0]           s_axi_arvalid,
    output logic [AW-1:0]          s_axi_araddr[N],
    output logic [IDW-1:0]         s_axi_arid[N],
    output logic [1:0]             s_axi_arburst[M],
    output logic [7:0]             s_axi_arlen[M],
    output logic [7:0]             s_axi_arsize[M],
    input        [N-1:0]           s_axi_arready,
    input        [N-1:0]           s_axi_rvalid,
    input        [DW-1:0]          s_axi_rdata[N],
    input        [IDW-1:0]         s_axi_rid[M],
    input        [N-1:0]           s_axi_rlast,
    output logic [N-1:0]           s_axi_rready,

    // AXI4 Master Ports (Write) connected to slave
    output logic [N-1:0]           s_axi_awvalid,
    output logic [AW-1:0]          s_axi_awaddr[N],
    output logic [IDW-1:0]         s_axi_awid[M],
    input        [N-1:0]           s_axi_awready,
    output logic [1:0]             s_axi_awburst[M],
    output logic [7:0]             s_axi_awlen[M],
    output logic [7:0]             s_axi_awsize[M],
    output logic [N-1:0]           s_axi_wvalid,
    output logic [DW-1:0]          s_axi_wdata[N],
    input        [N-1:0]           s_axi_wready,
    input        [N-1:0]           s_axi_bvalid,
    input        [1:0]             s_axi_bresp[N],
    input        [IDW-1:0]         s_axi_bid[M],
    output logic [N-1:0]           s_axi_bready
);

    localparam int AXI_ADR_CHAN_DW = AW + IDW + 2 + 8 + 3; // address, id, burst, length, size

    logic [LOG_N-1:0]            m_axi_rd_target[M];
    logic [AXI_ADR_CHAN_DW-1:0]  m_axi_ar_chan_dat[M];
    logic [AXI_ADR_CHAN_DW-1:0]  s_axi_ar_chan_dat[N];

    logic [LOG_M-1:0]            s_axi_rd_target[N];

    logic [AXI_ADR_CHAN_DW-1:0]  m_axi_aw_chan_dat[M];
    logic [AXI_ADR_CHAN_DW-1:0]  s_axi_aw_chan_dat[N];

    logic [LOG_N-1:0]            m_axi_wr_target[M];

    always_comb begin
        for (int i=0; i<M; i++) begin
            m_axi_rd_target[i] = m_axi_araddr[i][AW-1 : AW-LOG_N-1];
            m_axi_ar_chan_dat[i] = {m_axi_araddr[i],
                                    m_axi_arid[i],
                                    m_axi_arburst[i],
                                    m_axi_arlen[i],
                                    m_axi_arsize[i]};

            m_axi_wr_target[i] = m_axi_awaddr[i][AW-1 : AW-LOG_N-1];
            m_axi_aw_chan_dat[i] = {m_axi_awaddr[i],
                                    m_axi_awid[i],
                                    m_axi_awburst[i],
                                    m_axi_awlen[i],
                                    m_axi_awsize[i]};
        end

        for (int i=0; i<N; i++) begin
            {s_axi_araddr[i],
             s_axi_arid[i],
             s_axi_arburst[i],
             s_axi_arlen[i],
             s_axi_arsize[i]} = s_axi_ar_chan_dat[i];

            {s_axi_awaddr[i],
             s_axi_awid[i],
             s_axi_awburst[i],
             s_axi_awlen[i],
             s_axi_awsize[i]} = s_axi_aw_chan_dat[i];

        end

    end

// READ process
    // read address arbiter
    channel_arbiter #(
        .M      (M),
        .N      (N),
        .WIDTH  (AXI_ADR_CHAN_DW)
    ) read_addr_arbiter (
        .clk            (clk),
        .rstn           (rstn),

        .srcVld_i       (m_axi_arvalid),
        .srcTarget_i    (m_axi_rd_target),
        .srcDat_i       (m_axi_ar_chan_dat),
        .grantRdy_o     (m_axi_arready),

        .dstRdy_i       (s_axi_arready),
        .dstVld_o       (s_axi_arvalid),
        .dstDat_o       (s_axi_ar_chan_dat)
    );


    // AXI4 Dual-Port RAM Instances
    arbitrated_dual_port_ram #(
        .W (M),
        .R (N),
        .D (1 << IDW)
    ) rid_table (
        .clk            (clk),
        .rstn           (rstn),

        .wrVld_i        (m_axi_arvalid),
        .wrRdy_o        (),
        .newId          (m_axi_arid),
        .newTarget      (m_axi_rd_target),

        .rdVld_i        (s_axi_rvalid),
        .rdRdy_o        (),
        .lookupId       (s_axi_rid),
        .lookupTarget   (s_axi_rd_target)
    );

    // read DW channel
    channel_arbiter #(
        .M          (N),
        .N          (M),
        .WIDTH      (DW)
    ) read_data_arbiter (
        .clk            (clk),
        .rstn           (rstn),

        .srcVld_i       (s_axi_rvalid),
        .srcTarget_i    (s_axi_rd_target),
        .srcDat_i       (s_axi_rdata),
        .grantRdy_o     (s_axi_rready),

        .dstRdy_i       (m_axi_rready),
        .dstVld_o       (m_axi_rvalid),
        .dstDat_o       (m_axi_rdata)
    );

// WRITE process
    //write address channel
    channel_arbiter #(
        .M(M),
        .N(N),
        .WIDTH(AW)
    ) write_addr_arbiter (
        .clk            (clk),
        .rstn           (rstn),

        .srcVld_i       (m_axi_awvalid),
        .srcTarget_i    (m_axi_wr_target),
        .srcDat_i       (m_axi_aw_chan_dat),
        .grantRdy_o     (m_axi_awready),

        .dstRdy_i       (s_axi_awready),
        .dstVld_o       (s_axi_awvalid),
        .dstDat_o       (s_axi_aw_chan_dat)
    );

    //write DW channel
    channel_arbiter #(
        .M(M),
        .N(N),
        .WIDTH(DW)
    ) write_data_arbiter (
        .clk            (clk),
        .rstn           (rstn),

        .srcVld_i       (),
        .srcTarget_i    (),
        .srcDat_i       (),
        .grantRdy_o     (),

        .dstRdy_i       (),
        .dstVld_o       (),
        .dstDat_o       ()
    );

    //write response channel
    channel_arbiter #(
        .M      (N),
        .N      (M),
        .WIDTH  (2)
    ) write_resp_arbiter (
        .clk            (clk),
        .rstn           (rstn),

        .srcVld_i       (s_axi_bvalid),
        .srcTarget_i    (s_axi_wr_target),
        .srcDat_i       (s_axi_bresp),
        .grantRdy_o     (s_axi_bready),

        .dstRdy_i       (m_axi_bready),
        .dstVld_o       (m_axi_bvalid),
        .dstDat_o       (m_axi_bresp)
    );

    arbitrated_dual_port_ram #(
        .M  (M),
        .N  (N),
        .AW (AW),
        .DW (DW)
    ) wid_table (
        .clk            (clk),
        .rstn           (rstn),

        .wrVld_i        (m_axi_awvalid),
        .wrRdy_o        (),
        .newId          (m_axi_awid),
        .newTarget      (m_axi_wr_target),

        .rdVld_i        (s_axi_bvalid),
        .rdRdy_o        (),
        .lookupId       (s_axi_bid),
        .lookupTarget   (s_axi_wr_target)
    );

endmodule
