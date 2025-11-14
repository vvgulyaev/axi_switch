
`timescale 1ns/1ps

module tb_axi4_switch;

    `define TEST_LOG(str) \
    begin \
            do\
            $display("[%6t ps]: %s",  $time,  str);\
            while (0);\
    end

    // Parameters
    localparam int M = 4;           // Number of masters
    localparam int N = 4;           // Number of slaves
    localparam int AW = 32;         // Address width
    localparam int DW = 64;         // Data width
    localparam int IDW = 4;         // ID width
    localparam int LOG_N = $clog2(N);
    localparam int LOG_M = $clog2(M);
    localparam int NUM_TESTS = 100; // Number of random transactions

    localparam int      RESET_DUTY_CYCLES = 100;
    localparam realtime SYS_CLK_HPERIOD   = 2ns;
    localparam int      TIMEOUT = 1000;
    localparam int      TEST_LEN = 100;

    localparam int RANDOM_M_AXI_ARVALID = 1;
    localparam int RANDOM_M_AXI_RREADY = 1;
    localparam int RANDOM_M_AXI_AWVALID = 1;
    localparam int RANDOM_M_AXI_WVALID = 1;
    localparam int RANDOM_M_AXI_BREADY = 1;

    localparam int RANDOM_S_AXI_ARREADY = 1;
    localparam int RANDOM_S_AXI_RVALID = 1;
    localparam int RANDOM_S_AXI_AWREADY = 1;
    localparam int RANDOM_S_AXI_WREADY = 1;
    localparam int RANDOM_S_AXI_BVALID = 1;

    // Clock and reset
    logic clk = 0;
    logic rstn = 1;

    // Clock generation
    always #(SYS_CLK_HPERIOD)    clk = ~clk;

    // AXI4 Master interfaces (connected to DUT slave ports)
    logic [M-1:0]           m_axi_arvalid = 0;
    logic [AW-1:0]          m_axi_araddr[M] = '{default: '0};
    logic [IDW-1:0]         m_axi_arid[M] = '{default: '0};
    logic [1:0]             m_axi_arburst[M] = '{default: '0};
    logic [7:0]             m_axi_arlen[M] = '{default: '0};
    logic [2:0]             m_axi_arsize[M] = '{default: '0};
    logic [M-1:0]           m_axi_arready;
    logic [M-1:0]           m_axi_arready_r;
    logic [M-1:0]           m_axi_rvalid;
    logic [DW-1:0]          m_axi_rdata[M];
    logic [IDW-1:0]         m_axi_rid[M];
    logic [1:0]             m_axi_rresp[M];
    logic [M-1:0]           m_axi_rlast;
    logic [M-1:0]           m_axi_rready = 0;

    logic [M-1:0]           m_axi_awvalid = 0;
    logic [AW-1:0]          m_axi_awaddr[M] = '{default: '0};
    logic [IDW-1:0]         m_axi_awid[M] = '{default: '0};
    logic [1:0]             m_axi_awburst[M] = '{default: '0};
    logic [7:0]             m_axi_awlen[M] = '{default: '0};
    logic [2:0]             m_axi_awsize[M] = '{default: '0};
    logic [M-1:0]           m_axi_awready;
    logic [M-1:0]           m_axi_awready_r;
    logic [M-1:0]           m_axi_wvalid = 0;
    logic [DW-1:0]          m_axi_wdata[M] = '{default: '0};
    logic [DW/8-1:0]        m_axi_wstrb[M] = '{default: '0};
    logic [M-1:0]           m_axi_wlast = '{default: '0};
    logic [M-1:0]           m_axi_wready;
    logic [M-1:0]           m_axi_wready_r;
    logic [M-1:0]           m_axi_bvalid;
    logic [1:0]             m_axi_bresp[M];
    logic [IDW-1:0]         m_axi_bid[M];
    logic [M-1:0]           m_axi_bready = 0;

    // AXI4 Slave interfaces (connected to DUT master ports)
    logic [N-1:0]           s_axi_arvalid;
    logic [AW-1:0]          s_axi_araddr[N];
    logic [IDW-1:0]         s_axi_arid[N];
    logic [1:0]             s_axi_arburst[N];
    logic [7:0]             s_axi_arlen[N];
    logic [2:0]             s_axi_arsize[N];
    logic [N-1:0]           s_axi_arready = 0;
    logic [N-1:0]           s_axi_rvalid = 0;
    logic [DW-1:0]          s_axi_rdata[N] = '{default: '0};
    logic [IDW-1:0]         s_axi_rid[N] = '{default: '0};
    logic [1:0]             s_axi_rresp[N] = '{default: '0};
    logic                   s_axi_rlast[N] = '{default: '0};
    logic [N-1:0]           s_axi_rready;
    logic [N-1:0]           s_axi_rready_r;

    logic [N-1:0]           s_axi_awvalid;
    logic [AW-1:0]          s_axi_awaddr[N];
    logic [IDW-1:0]         s_axi_awid[N];
    logic [1:0]             s_axi_awburst[N];
    logic [7:0]             s_axi_awlen[N];
    logic [2:0]             s_axi_awsize[N];
    logic [N-1:0]           s_axi_awready = 0;
    logic [N-1:0]           s_axi_wvalid;
    logic [DW-1:0]          s_axi_wdata[N];
    logic [DW/8-1:0]        s_axi_wstrb[N];
    logic                   s_axi_wlast[N];
    logic [N-1:0]           s_axi_wready = 0;
    logic [N-1:0]           s_axi_bvalid = 0;
    logic [1:0]             s_axi_bresp[N] = '{default: '0};
    logic [IDW-1:0]         s_axi_bid[N] = '{default: '0};
    logic [N-1:0]           s_axi_bready;
    logic [N-1:0]           s_axi_bready_r;

    // Transaction tracking
    typedef struct {
        logic [AW-1:0]      addr;
        logic [IDW-1:0]     id;
        logic [7:0]         len;
        logic [2:0]         size;
        logic [1:0]         burst;
        int                 master_id;
        int                 slave_id;
        logic [DW-1:0]      data[$];
        logic [DW/8-1:0]    strb[$];
        int                 beat_count;
    } transaction_t;

    transaction_t read_pending[M][$];
    transaction_t write_pending[M][$];
    transaction_t slave_read_active[N];
    transaction_t slave_write_active[N];
    logic slave_read_busy[N];
    logic slave_write_busy[N];

    // Scoreboard
    int read_transactions_sent = 0;
    int read_transactions_completed = 0;
    int write_transactions_sent = 0;
    int write_transactions_completed = 0;
    int errors = 0;

    int master_id;

    transaction_t   master_write_trans_q[M][$];
    transaction_t   ref_slave_aw_trans_q[N][$];
    transaction_t   ref_slave_w_trans_q[N][$];
    logic [IDW-1:0] ref_bresp_q[M][$];

    always_ff @(posedge clk) begin
        m_axi_arready_r <= m_axi_arready;
        m_axi_awready_r <= m_axi_awready;
        m_axi_wready_r <= m_axi_wready;
        s_axi_rready_r <= s_axi_rready;
        s_axi_bready_r <= s_axi_bready;
    end


    // DUT instantiation
    axi_switch #(
        .M      (N), //number of master ports equals to number of slaves
        .N      (M), //number of slave ports equals to number of masters
        .AW     (AW),
        .DW     (DW),
        .IDW    (IDW),
        .LOG_N  (LOG_N),
        .LOG_M  (LOG_M)
    ) dut (
        .clk            (clk),
        .rstn           (rstn),

        //slave ports connected to masters
        .s_axi_arvalid  (m_axi_arvalid),
        .s_axi_araddr   (m_axi_araddr),
        .s_axi_arid     (m_axi_arid),
        .s_axi_arburst  (m_axi_arburst),
        .s_axi_arlen    (m_axi_arlen),
        .s_axi_arsize   (m_axi_arsize),
        .s_axi_arready  (m_axi_arready),
        .s_axi_rvalid   (m_axi_rvalid),
        .s_axi_rdata    (m_axi_rdata),
        .s_axi_rid      (m_axi_rid),
        .s_axi_rresp    (m_axi_rresp),
        .s_axi_rlast    (m_axi_rlast),
        .s_axi_rready   (m_axi_rready),

        .s_axi_awvalid  (m_axi_awvalid),
        .s_axi_awaddr   (m_axi_awaddr),
        .s_axi_awid     (m_axi_awid),
        .s_axi_awburst  (m_axi_awburst),
        .s_axi_awlen    (m_axi_awlen),
        .s_axi_awsize   (m_axi_awsize),
        .s_axi_awready  (m_axi_awready),
        .s_axi_wvalid   (m_axi_wvalid),
        .s_axi_wdata    (m_axi_wdata),
        .s_axi_wstrb    (m_axi_wstrb),
        .s_axi_wlast    (m_axi_wlast),
        .s_axi_wready   (m_axi_wready),
        .s_axi_bvalid   (m_axi_bvalid),
        .s_axi_bresp    (m_axi_bresp),
        .s_axi_bid      (m_axi_bid),
        .s_axi_bready   (m_axi_bready),

        //master ports connected to slaves
        .m_axi_arvalid  (s_axi_arvalid),
        .m_axi_araddr   (s_axi_araddr),
        .m_axi_arid     (s_axi_arid),
        .m_axi_arburst  (s_axi_arburst),
        .m_axi_arlen    (s_axi_arlen),
        .m_axi_arsize   (s_axi_arsize),
        .m_axi_arready  (s_axi_arready),
        .m_axi_rvalid   (s_axi_rvalid),
        .m_axi_rdata    (s_axi_rdata),
        .m_axi_rid      (s_axi_rid),
        .m_axi_rresp    (s_axi_rresp),
        .m_axi_rlast    (s_axi_rlast),
        .m_axi_rready   (s_axi_rready),

        .m_axi_awvalid  (s_axi_awvalid),
        .m_axi_awaddr   (s_axi_awaddr),
        .m_axi_awid     (s_axi_awid),
        .m_axi_awburst  (s_axi_awburst),
        .m_axi_awlen    (s_axi_awlen),
        .m_axi_awsize   (s_axi_awsize),
        .m_axi_awready  (s_axi_awready),
        .m_axi_wvalid   (s_axi_wvalid),
        .m_axi_wdata    (s_axi_wdata),
        .m_axi_wstrb    (s_axi_wstrb),
        .m_axi_wlast    (s_axi_wlast),
        .m_axi_wready   (s_axi_wready),
        .m_axi_bvalid   (s_axi_bvalid),
        .m_axi_bresp    (s_axi_bresp),
        .m_axi_bid      (s_axi_bid),
        .m_axi_bready   (s_axi_bready)
    );

    program test_all;
        initial begin
            apply_reset();
            run_test();
            `TEST_LOG("TEST PASSED");
            stop();
        end
    endprogram

    task automatic run_test();
        logic [M-1:0] wreq_done = 0;
        `TEST_LOG("run test");
        fork
            //----------------------
            M_AW_CH0: begin
                m_axi_aw_thread(0);
                wreq_done[0] = 1;
            end
            M_W_CH0: begin
                m_axi_w_thread(0, wreq_done);
            end
            M_B_CH0: begin
                m_axi_b_thread(0, wreq_done);
            end

            //----------------------
            S_AW_CH0: begin
                s_axi_aw_thread(0, wreq_done);
            end
            S_W_CH0: begin
                s_axi_w_thread(0, wreq_done);
            end

            //----------------------
            S_AW_CH1: begin
                s_axi_aw_thread(1, wreq_done);
            end
            S_W_CH1: begin
                s_axi_w_thread(1, wreq_done);
            end

            //----------------------
            S_AW_CH2: begin
                s_axi_aw_thread(2, wreq_done);
            end
            S_W_CH2: begin
                s_axi_w_thread(2, wreq_done);
            end

            //----------------------
            S_AW_CH3: begin
                s_axi_aw_thread(3, wreq_done);
            end
            S_W_CH3: begin
                s_axi_w_thread(3, wreq_done);
            end
        join

        pause_cycles(100);
    endtask

    task automatic m_axi_aw_thread(int master_id);
        int             slave_id;
        transaction_t   trans;
        int             timeout_cnt;

        for (int t=0; t<TEST_LEN; t++) begin
            if (RANDOM_M_AXI_AWVALID) begin
                pause_cycles($urandom_range(0, 16));
            end

            trans.master_id = master_id;
            slave_id = $urandom_range(0, N-1);
            trans.slave_id = slave_id;

            // Generate random transaction parameters
            trans.addr = (slave_id << (AW - LOG_N)) | ($urandom & ((1 << (AW - LOG_N)) - 1));
            trans.id = master_id;
            trans.len = $urandom_range(0, 15); // Burst length 1-16
            trans.size = $urandom_range(0, $clog2(DW/8)); // Size up to bus width
            trans.burst = $urandom_range(0, 2); // FIXED, INCR, WRAP
            trans.beat_count = 0;

            // Generate random data and strobes
            for (int i = 0; i <= trans.len; i++) begin
                trans.data.push_back($urandom);
                trans.strb.push_back($urandom & ((1 << (DW/8)) - 1));
            end

            m_axi_awvalid[master_id] = 1;
            m_axi_awaddr[master_id] = trans.addr;
            m_axi_awid[master_id] = trans.id;
            m_axi_awburst[master_id] = trans.burst;
            m_axi_awlen[master_id] = trans.len;
            m_axi_awsize[master_id] = trans.size;

            master_write_trans_q[master_id].push_back(trans);
            ref_slave_aw_trans_q[slave_id].push_back(trans);
            ref_slave_w_trans_q[slave_id].push_back(trans);
            ref_bresp_q[master_id].push_back(trans.id);

            timeout_cnt = 0;
            @(posedge clk);
            while (~m_axi_awready_r[master_id] && (timeout_cnt++ < TIMEOUT)) begin
                @(posedge clk);
            end
            if (timeout_cnt >= TIMEOUT) begin
                `TEST_LOG($sformatf("Master %0d: Write request to slave %0d awready timed out", master_id, slave_id));
                $stop;
            end
            m_axi_awvalid[master_id] = 0;
        end
    endtask

    task automatic m_axi_w_thread(int master_id, ref [M-1:0] req_done);
        transaction_t   trans;
        int             timeout_cnt;
        while (~req_done[master_id] || master_write_trans_q[master_id].size() > 0) begin
            @(posedge clk);
            if (master_write_trans_q[master_id].size() > 0) begin
                trans = master_write_trans_q[master_id].pop_front();

                for (int i = 0; i <= trans.len; i++) begin
                    if (RANDOM_M_AXI_WVALID) begin
                        pause_cycles($urandom_range(0, 16));
                    end
                    m_axi_wvalid[master_id] = 1;
                    m_axi_wdata[master_id] = trans.data[i];
                    m_axi_wstrb[master_id] = trans.strb[i];
                    m_axi_wlast[master_id] = (i == trans.len);
                    @(posedge clk);
                    timeout_cnt = 0;
                    while ((!m_axi_wready_r[master_id]) && (timeout_cnt++ < TIMEOUT)) begin
                        @(posedge clk);
                    end
                    if (timeout_cnt >= TIMEOUT) begin
                        `TEST_LOG($sformatf("Master %0d: Write request to slave %0d wready timed out", master_id, trans.slave_id));
                        $stop;
                    end
                    m_axi_wvalid[master_id] = 0;
                end
            end
        end
    endtask

    task automatic m_axi_b_thread(int master_id, ref [M-1:0] req_done);
        logic [IDW-1:0] bid;
        int             timeout_cnt;
        logic           found;
        while (~req_done[master_id] || (ref_bresp_q[master_id].size() > 0)) begin
            @ (posedge clk);
            m_axi_bready[master_id] = (RANDOM_M_AXI_BREADY) ? $urandom_range(0, 1) : 1;
            @ (negedge clk);
            if (m_axi_bvalid[master_id] && m_axi_bready[master_id]) begin
                //search received bid in reference queue
                found = 0;
                for (int i=0; i<ref_bresp_q[master_id].size(); i++) begin
                    if (m_axi_bid[master_id] === ref_bresp_q[master_id][i]) begin
                        ref_bresp_q[master_id].delete(i);
                        found = 1;
                        break;
                    end
                end
                if (!found) begin
                    `TEST_LOG($sformatf("Master %0d: BRESP received without matching BID (%01h)", master_id, m_axi_bid[master_id]));
                    $stop;
                end
            end
        end
    endtask

    task automatic s_axi_aw_thread(int slave_id, ref [M-1:0] req_done);
        logic found;
        while ((req_done!={M{1'b1}}) || (ref_slave_aw_trans_q[slave_id].size() > 0)) begin
            @(posedge clk);
            s_axi_awready[slave_id] = (RANDOM_S_AXI_AWREADY) ? $urandom_range(0, 1) : 1;
            @(negedge clk);
            if (s_axi_awready[slave_id] && s_axi_awvalid[slave_id]) begin
                //search received awid in reference queue
                found = 0;
                for (int i=0; i<ref_slave_aw_trans_q[slave_id].size(); i++) begin
                    if (s_axi_awid[slave_id] === ref_slave_aw_trans_q[slave_id][i].id) begin
                        ref_slave_aw_trans_q[slave_id].delete(i);
                        found = 1;
                        break;
                    end
                end
                if (!found) begin
                    `TEST_LOG($sformatf("Slave %0d: Received AWID without matching in reference queue (%01h)", slave_id, s_axi_awid[slave_id]));
                    $stop;
                end
            end
        end
    endtask

    task automatic s_axi_w_thread(int slave_id, ref [M-1:0] req_done);
        logic found = 0;
        logic [IDW-1:0]     id;
        logic [DW-1:0]      data[$];
        logic [DW/8-1:0]    strb[$];
        logic [DW-1:0]      ref_data;
        logic [DW/8-1:0]    ref_strb;
        logic               ref_wlast;

        while ((req_done!={M{1'b1}}) || (ref_slave_w_trans_q[slave_id].size() > 0)) begin
            @(posedge clk);
            s_axi_wready[slave_id] = (RANDOM_S_AXI_AWREADY) ? $urandom_range(0, 1) : 1;
            @(negedge clk);
            if (s_axi_wready[slave_id] && s_axi_wvalid[slave_id]) begin
                if (found==0) begin
                    //search received awid in reference queue
                    for (int i=0; i<ref_slave_w_trans_q[slave_id].size(); i++) begin
                        if (s_axi_awid[slave_id] == ref_slave_w_trans_q[slave_id][i].id) begin
                            id = ref_slave_w_trans_q[slave_id][i].id;
                            data = ref_slave_w_trans_q[slave_id][i].data;
                            strb = ref_slave_w_trans_q[slave_id][i].strb;
                            ref_slave_w_trans_q[slave_id].delete(i);
                            found = 1;
                            break;
                        end
                    end
                    if (!found) begin
                        `TEST_LOG($sformatf("Slave %0d: Received AWID without matching in reference queue (%01h)", slave_id, s_axi_awid[slave_id]));
                        $stop;
                    end
                end
                ref_data = data.pop_front();
                ref_strb = strb.pop_front();
                ref_wlast = (data.size() == 0) ? 1 : 0;
                for (int i=0; i<DW/8; i++) begin
                    if (ref_strb[i] !== s_axi_wstrb[slave_id][i]) begin
                        `TEST_LOG($sformatf("Slave %0d: WSTRB error extected: 0x%0h actual: 0x%0h", slave_id, ref_strb, s_axi_wstrb[slave_id]));
                        $stop;
                    end
                    if (ref_strb[i] == 1'b1) begin
                        if (ref_data[i*8 +: 8] !== s_axi_wdata[slave_id][i*8 +: 8]) begin
                            `TEST_LOG($sformatf("Slave %0d: WDATA error extected: 0x%0h actual: 0x%0h", slave_id, ref_data, s_axi_wdata[slave_id]));
                            $stop;
                        end
                    end
                end
                if (ref_wlast!==s_axi_wlast[slave_id]) begin
                    `TEST_LOG($sformatf("Slave %0d: WLAST error extected: 0b%0h actual: 0b%0h", slave_id, ref_wlast, s_axi_wlast[slave_id]));
                    $stop;
                end
                if (ref_wlast == 1'b1) begin
                    found = 0;
                    @(posedge clk);
                    s_axi_wready[slave_id] = 0;
                    s_axi_bid[slave_id] = id;
                    do begin
                        s_axi_bvalid[slave_id] = RANDOM_S_AXI_BVALID ? $urandom_range(0, 1) : 1;
                        @ (posedge clk);
                    end while (~s_axi_bvalid[slave_id] | ~s_axi_bready[slave_id]);
                    s_axi_bvalid[slave_id] = 0;
                end
            end
        end
    endtask


    task automatic pause_cycles(int cycles);
        repeat (cycles) @(posedge clk);
    endtask

    task automatic apply_reset(int cycles=RESET_DUTY_CYCLES);
        rstn = 0;
        repeat (cycles) @(posedge clk);
        rstn = 1;
    endtask

    task automatic stop();
        pause_cycles(10);
        $stop;
    endtask

    // Task: Generate random read transaction
    task automatic send_read_transaction(int master_id);
        int timeout_cnt;
        transaction_t trans;
        int slave_id;

        trans.master_id = master_id;
        slave_id = $urandom_range(0, N-1);
        trans.slave_id = slave_id;

        // Generate random transaction parameters
        trans.addr = (slave_id << (AW - LOG_N)) | ($urandom & ((1 << (AW - LOG_N)) - 1));
        trans.id = $urandom_range(0, (1 << IDW) - 1);
        trans.len = $urandom_range(0, 15); // Burst length 1-16
        trans.size = $urandom_range(0, $clog2(DW/8)); // Size up to bus width
        trans.burst = $urandom_range(0, 2); // FIXED, INCR, WRAP
        trans.beat_count = 0;

        // Send address phase
        @(posedge clk);
        m_axi_arvalid[master_id] = 1;
        m_axi_araddr[master_id] = trans.addr;
        m_axi_arid[master_id] = trans.id;
        m_axi_arburst[master_id] = trans.burst;
        m_axi_arlen[master_id] = trans.len;
        m_axi_arsize[master_id] = trans.size;

        // Wait for ready
        timeout_cnt = 0;
        while ((!m_axi_arready[master_id]) && (timeout_cnt++ < TIMEOUT)) begin
            @(posedge clk);
        end
        if (timeout_cnt >= TIMEOUT) begin
            `TEST_LOG($sformatf("Master %0d: Read request to slave %0d arready timed out", master_id, slave_id));
            $stop;
        end

        m_axi_arvalid[master_id] = 0;

        // Store transaction
        read_pending[master_id].push_back(trans);
        read_transactions_sent++;

        $display("Master %0d: Sent read request to slave %0d, addr=0x%0h, len=%0d",
                 master_id, slave_id, trans.addr, trans.len);
    endtask

    // Task: Generate random write transaction
    task automatic send_write_transaction(int master_id);
        transaction_t trans;
        int slave_id;
        int timeout_cnt;

        trans.master_id = master_id;
        slave_id = $urandom_range(0, N-1);
        trans.slave_id = slave_id;

        // Generate random transaction parameters
        trans.addr = (slave_id << (AW - LOG_N)) | ($urandom & ((1 << (AW - LOG_N)) - 1));
        trans.id = $urandom_range(0, (1 << IDW) - 1);
        trans.len = $urandom_range(0, 15); // Burst length 1-16
        trans.size = $urandom_range(0, $clog2(DW/8)); // Size up to bus width
        trans.burst = $urandom_range(0, 2); // FIXED, INCR, WRAP
        trans.beat_count = 0;

        // Generate random data and strobes
        for (int i = 0; i <= trans.len; i++) begin
            trans.data.push_back($urandom);
            trans.strb.push_back($urandom & ((1 << (DW/8)) - 1));
        end

        $display("Master %0d: Prep write request to slave %0d, addr=0x%0h, len=%0d",
                  master_id, slave_id, trans.addr, trans.len);


        // Send address phase
        @(posedge clk);
        m_axi_awvalid[master_id] = 1;
        m_axi_awaddr[master_id] = trans.addr;
        m_axi_awid[master_id] = trans.id;
        m_axi_awburst[master_id] = trans.burst;
        m_axi_awlen[master_id] = trans.len;
        m_axi_awsize[master_id] = trans.size;

        // Wait for ready
        timeout_cnt = 0;
        while ((!m_axi_awready[master_id]) && (timeout_cnt++ < TIMEOUT)) begin
            @(posedge clk);
        end
        if (timeout_cnt >= TIMEOUT) begin
            `TEST_LOG($sformatf("Master %0d: Write request to slave %0d awready timed out", master_id, slave_id));
            $stop;
        end

        m_axi_awvalid[master_id] = 0;

        // Send data phase
        for (int i = 0; i <= trans.len; i++) begin
            @(posedge clk);
            m_axi_wvalid[master_id] = 1;
            m_axi_wdata[master_id] = trans.data[i];
            m_axi_wstrb[master_id] = trans.strb[i];
            m_axi_wlast[master_id] = (i == trans.len);

            timeout_cnt = 0;
            while ((!m_axi_wready[master_id]) && (timeout_cnt++ < TIMEOUT)) begin
                @(posedge clk);
            end
            if (timeout_cnt >= TIMEOUT) begin
                `TEST_LOG($sformatf("Master %0d: Write request to slave %0d wready timed out", master_id, slave_id));
                $stop;
            end

            m_axi_wvalid[master_id] = 0;
        end

        // Wait for response
        @(posedge clk);
        m_axi_bready[master_id] = 1;
        timeout_cnt = 0;
        while ((!m_axi_bvalid[master_id]) && (timeout_cnt++ < TIMEOUT)) begin
            @(posedge clk);
        end
        m_axi_bready[master_id] = 0;

        // Store transaction
        write_pending[master_id].push_back(trans);
        write_transactions_sent++;

        $display("Master %0d: Sent write request to slave %0d, addr=0x%0h, len=%0d",
                  master_id, slave_id, trans.addr, trans.len);
    endtask

    // Monitor read responses
    always @(posedge clk) begin
        for (int i = 0; i < M; i++) begin
            if (m_axi_rvalid[i] && m_axi_rready[i]) begin
                // Find matching transaction
                for (int j = 0; j < read_pending[i].size(); j++) begin
                    if (read_pending[i][j].id == m_axi_rid[i]) begin
                        // Check if this is the last beat
                        if (m_axi_rlast[i]) begin
                            read_transactions_completed++;
                            read_pending[i].delete(j);
                            $display("Master %0d: Read transaction completed", i);
                        end
                        break;
                    end
                end
            end
        end
    end

    // Monitor write responses
    always @(posedge clk) begin
        for (int i = 0; i < M; i++) begin
            if (m_axi_bvalid[i] && m_axi_bready[i]) begin
                // Find matching transaction
                for (int j = 0; j < write_pending[i].size(); j++) begin
                    if (write_pending[i][j].id == m_axi_bid[i]) begin
                        write_transactions_completed++;
                        write_pending[i].delete(j);
                        $display("Master %0d: Write transaction completed", i);
                        break;
                    end
                end
            end
        end
    end

endmodule
