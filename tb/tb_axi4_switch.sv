
`timescale 1ns/1ps

module tb_axi4_switch;

    // Parameters
    parameter M = 4;           // Number of masters
    parameter N = 4;           // Number of slaves
    parameter AW = 32;         // Address width
    parameter DW = 64;         // Data width
    parameter IDW = 4;         // ID width
    parameter LOG_N = $clog2(N);
    parameter LOG_M = $clog2(M);
    parameter NUM_TESTS = 100; // Number of random transactions

    // Clock and reset
    logic clk;
    logic rstn;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // AXI4 Master interfaces (connected to DUT slave ports)
    logic [M-1:0]           m_axi_arvalid;
    logic [AW-1:0]          m_axi_araddr[M];
    logic [IDW-1:0]         m_axi_arid[M];
    logic [1:0]             m_axi_arburst[M];
    logic [7:0]             m_axi_arlen[M];
    logic [2:0]             m_axi_arsize[M];
    logic [M-1:0]           m_axi_arready;
    logic [M-1:0]           m_axi_rvalid;
    logic [DW-1:0]          m_axi_rdata[M];
    logic [IDW-1:0]         m_axi_rid[M];
    logic [1:0]             m_axi_rresp[M];
    logic [M-1:0]           m_axi_rlast;
    logic [M-1:0]           m_axi_rready;

    logic [M-1:0]           m_axi_awvalid;
    logic [AW-1:0]          m_axi_awaddr[M];
    logic [IDW-1:0]         m_axi_awid[M];
    logic [1:0]             m_axi_awburst[M];
    logic [7:0]             m_axi_awlen[M];
    logic [2:0]             m_axi_awsize[M];
    logic [M-1:0]           m_axi_awready;
    logic [M-1:0]           m_axi_wvalid;
    logic [DW-1:0]          m_axi_wdata[M];
    logic [DW/8-1:0]        m_axi_wstrb[M];
    logic [M-1:0]           m_axi_wlast;
    logic [M-1:0]           m_axi_wready;
    logic [M-1:0]           m_axi_bvalid;
    logic [1:0]             m_axi_bresp[M];
    logic [IDW-1:0]         m_axi_bid[M];
    logic [M-1:0]           m_axi_bready;

    // AXI4 Slave interfaces (connected to DUT master ports)
    logic [N-1:0]           s_axi_arvalid;
    logic [AW-1:0]          s_axi_araddr[N];
    logic [IDW-1:0]         s_axi_arid[N];
    logic [1:0]             s_axi_arburst[N];
    logic [7:0]             s_axi_arlen[N];
    logic [2:0]             s_axi_arsize[N];
    logic [N-1:0]           s_axi_arready;
    logic [N-1:0]           s_axi_rvalid;
    logic [DW-1:0]          s_axi_rdata[N];
    logic [IDW-1:0]         s_axi_rid[N];
    logic [1:0]             s_axi_rresp[N];
    logic                   s_axi_rlast[N];
    logic [N-1:0]           s_axi_rready;

    logic [N-1:0]           s_axi_awvalid;
    logic [AW-1:0]          s_axi_awaddr[N];
    logic [IDW-1:0]         s_axi_awid[N];
    logic [1:0]             s_axi_awburst[N];
    logic [7:0]             s_axi_awlen[N];
    logic [2:0]             s_axi_awsize[N];
    logic [N-1:0]           s_axi_awready;
    logic [N-1:0]           s_axi_wvalid;
    logic [DW-1:0]          s_axi_wdata[N];
    logic [DW/8-1:0]        s_axi_wstrb[N];
    logic                   s_axi_wlast[N];
    logic [N-1:0]           s_axi_wready;
    logic [N-1:0]           s_axi_bvalid;
    logic [1:0]             s_axi_bresp[N];
    logic [IDW-1:0]         s_axi_bid[N];
    logic [N-1:0]           s_axi_bready;

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

    // DUT instantiation
    axi_switch #(
        .M(N), //number of master ports equals to number of slaves
        .N(M), //number of slave ports equals to number of masters
        .AW(AW),
        .DW(DW),
        .IDW(IDW),
        .LOG_N(LOG_N),
        .LOG_M(LOG_M)
    ) dut (
        .clk(clk),
        .rstn(rstn),

        //slave ports connected to masters
        .s_axi_arvalid(m_axi_arvalid),
        .s_axi_araddr(m_axi_araddr),
        .s_axi_arid(m_axi_arid),
        .s_axi_arburst(m_axi_arburst),
        .s_axi_arlen(m_axi_arlen),
        .s_axi_arsize(m_axi_arsize),
        .s_axi_arready(m_axi_arready),
        .s_axi_rvalid(m_axi_rvalid),
        .s_axi_rdata(m_axi_rdata),
        .s_axi_rid(m_axi_rid),
        .s_axi_rresp(m_axi_rresp),
        .s_axi_rlast(m_axi_rlast),
        .s_axi_rready(m_axi_rready),

        .s_axi_awvalid(m_axi_awvalid),
        .s_axi_awaddr(m_axi_awaddr),
        .s_axi_awid(m_axi_awid),
        .s_axi_awburst(m_axi_awburst),
        .s_axi_awlen(m_axi_awlen),
        .s_axi_awsize(m_axi_awsize),
        .s_axi_awready(m_axi_awready),
        .s_axi_wvalid(m_axi_wvalid),
        .s_axi_wdata(m_axi_wdata),
        .s_axi_wstrb(m_axi_wstrb),
        .s_axi_wlast(m_axi_wlast),
        .s_axi_wready(m_axi_wready),
        .s_axi_bvalid(m_axi_bvalid),
        .s_axi_bresp(m_axi_bresp),
        .s_axi_bid(m_axi_bid),
        .s_axi_bready(m_axi_bready),

        //master ports connected to slaves
        .m_axi_arvalid(s_axi_arvalid),
        .m_axi_araddr(s_axi_araddr),
        .m_axi_arid(s_axi_arid),
        .m_axi_arburst(s_axi_arburst),
        .m_axi_arlen(s_axi_arlen),
        .m_axi_arsize(s_axi_arsize),
        .m_axi_arready(s_axi_arready),
        .m_axi_rvalid(s_axi_rvalid),
        .m_axi_rdata(s_axi_rdata),
        .m_axi_rid(s_axi_rid),
        .m_axi_rresp(s_axi_rresp),
        .m_axi_rlast(s_axi_rlast),
        .m_axi_rready(s_axi_rready),

        .m_axi_awvalid(s_axi_awvalid),
        .m_axi_awaddr(s_axi_awaddr),
        .m_axi_awid(s_axi_awid),
        .m_axi_awburst(s_axi_awburst),
        .m_axi_awlen(s_axi_awlen),
        .m_axi_awsize(s_axi_awsize),
        .m_axi_awready(s_axi_awready),
        .m_axi_wvalid(s_axi_wvalid),
        .m_axi_wdata(s_axi_wdata),
        .m_axi_wstrb(s_axi_wstrb),
        .m_axi_wlast(s_axi_wlast),
        .m_axi_wready(s_axi_wready),
        .m_axi_bvalid(s_axi_bvalid),
        .m_axi_bresp(s_axi_bresp),
        .m_axi_bid(s_axi_bid),
        .m_axi_bready(s_axi_bready)
    );

    // Initialize signals
    initial begin
        rstn = 0;

        // Initialize master interfaces
        for (int i = 0; i < M; i++) begin
            m_axi_arvalid[i] = 0;
            m_axi_araddr[i] = 0;
            m_axi_arid[i] = 0;
            m_axi_arburst[i] = 0;
            m_axi_arlen[i] = 0;
            m_axi_arsize[i] = 0;
            m_axi_rready[i] = 0;

            m_axi_awvalid[i] = 0;
            m_axi_awaddr[i] = 0;
            m_axi_awid[i] = 0;
            m_axi_awburst[i] = 0;
            m_axi_awlen[i] = 0;
            m_axi_awsize[i] = 0;
            m_axi_wvalid[i] = 0;
            m_axi_wdata[i] = 0;
            m_axi_wstrb[i] = 0;
            m_axi_wlast[i] = 0;
            m_axi_bready[i] = 0;
        end

        // Initialize slave interfaces
        for (int i = 0; i < N; i++) begin
            s_axi_arready[i] = 0;
            s_axi_rvalid[i] = 0;
            s_axi_rdata[i] = 0;
            s_axi_rid[i] = 0;
            s_axi_rresp[i] = 0;
            s_axi_rlast[i] = 0;

            s_axi_awready[i] = 0;
            s_axi_wready[i] = 0;
            s_axi_bvalid[i] = 0;
            s_axi_bresp[i] = 0;
            s_axi_bid[i] = 0;

            slave_read_busy[i] = 0;
            slave_write_busy[i] = 0;
        end

        // Reset sequence
        repeat(10) @(posedge clk);
        rstn = 1;
        repeat(5) @(posedge clk);

        $display("=== AXI4 Switch Testbench Started ===");
        $display("Configuration: M=%0d masters, N=%0d slaves", M, N);
        $display("Address Width: %0d, Data Width: %0d, ID Width: %0d", AW, DW, IDW);
    end

    // Task: Generate random read transaction
    task automatic send_read_transaction(int master_id);
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
        while (!m_axi_arready[master_id]) @(posedge clk);

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

        // Send address phase
        @(posedge clk);
        m_axi_awvalid[master_id] = 1;
        m_axi_awaddr[master_id] = trans.addr;
        m_axi_awid[master_id] = trans.id;
        m_axi_awburst[master_id] = trans.burst;
        m_axi_awlen[master_id] = trans.len;
        m_axi_awsize[master_id] = trans.size;

        // Wait for ready
        while (!m_axi_awready[master_id]) @(posedge clk);

        m_axi_awvalid[master_id] = 0;

        // Send data phase
        for (int i = 0; i <= trans.len; i++) begin
            @(posedge clk);
            m_axi_wvalid[master_id] = 1;
            m_axi_wdata[master_id] = trans.data[i];
            m_axi_wstrb[master_id] = trans.strb[i];
            m_axi_wlast[master_id] = (i == trans.len);

            while (!m_axi_wready[master_id]) @(posedge clk);

            m_axi_wvalid[master_id] = 0;
        end

        // Wait for response
        @(posedge clk);
        m_axi_bready[master_id] = 1;
        while (!m_axi_bvalid[master_id]) @(posedge clk);
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

    // Main test loop
    initial begin
        // Run tests
        for (int i = 0; i < NUM_TESTS; i++) begin
            master_id = $urandom_range(0, M-1);

            // Randomly choose between read and write
            if ($urandom_range(0, 1)) begin
                send_read_transaction(master_id);
            end else begin
                send_write_transaction(master_id);
            end

            // Random delay between transactions
            repeat ($urandom_range(1, 10)) @(posedge clk);
        end

        // Wait for all transactions to complete
        repeat(100) @(posedge clk);

        // Print final results
        $display("=== Test Results ===");
        $display("Read transactions sent: %0d", read_transactions_sent);
        $display("Read transactions completed: %0d", read_transactions_completed);
        $display("Write transactions sent: %0d", write_transactions_sent);
        $display("Write transactions completed: %0d", write_transactions_completed);
        $display("Total errors: %0d", errors);

        if (read_transactions_sent != read_transactions_completed ||
            write_transactions_sent != write_transactions_completed) begin
            $display("ERROR: Some transactions did not complete!");
            $finish(1);
        end else begin
            $display("SUCCESS: All transactions completed successfully!");
            $finish(0);
        end
    end

endmodule
