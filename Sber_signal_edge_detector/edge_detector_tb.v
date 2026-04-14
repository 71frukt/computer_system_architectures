`timescale 1ns / 1ps

module edge_detector_tb();

    reg        clk_i;
    reg        rst_i;
    reg        signal_i;

    wire [1:0] detect_o;

    edge_detector dut (
        .clk_i   (clk_i),
        .rst_i   (rst_i),
        .signal_i(signal_i),
        .detect_o(detect_o)
    );

    // T = 10 нс
    always #5 clk_i = ~clk_i;

    initial begin
        $dumpvars;

        clk_i    = 0;
        rst_i    = 1;
        signal_i = 0;

        @(posedge clk_i);
        #1; // имитирует задержку распространения и предотвращаеь состояние гонки
        rst_i = 0;

        // expected: detect_o <= 2'b00
        @(posedge clk_i); 
        #1;


        // передний фронт
        signal_i = 1;
        // expected: detect_o <= 2'b01 на следующем такте
        @(posedge clk_i);
        #1;

        // expected: detect_o <= 2'b00.
        @(posedge clk_i);
        #1;

        // задний фронт
        signal_i = 0;
        // expected: detect_o <= 2'b10 на следующем такте.
        @(posedge clk_i);
        #1;
        
        // короткий импульс
        #2 signal_i = 1;
        #4 signal_i = 0;
        
        // expected: detect_o <= 2'b00 - импульс проигнорирован
        @(posedge clk_i);
        #1;

        @(posedge clk_i);
        
        $finish;
    end

endmodule