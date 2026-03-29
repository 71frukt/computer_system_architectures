`timescale 1ns / 1ps

module alu_register_tb();

    localparam WIDTH = 8;

    reg             clk_i;
    reg             rst_i;
    reg             valid_i;
    reg [WIDTH-1:0] first_i;
    reg [WIDTH-1:0] second_i;
    reg [1:0]       opcode_i;

    wire             valid_o;
    wire [WIDTH-1:0] result_o;

    alu_register #(
        .WIDTH(WIDTH)
    ) alu_inst (
        .clk_i   (clk_i),
        .rst_i   (rst_i),
        .valid_i (valid_i),
        .first_i (first_i),
        .second_i(second_i),
        .opcode_i(opcode_i),
        .valid_o (valid_o),
        .result_o(result_o)
    );

    // T = 10 нс
    always #5 clk_i = ~clk_i;

    initial begin
        $dumpvars;

        clk_i    = 0;
        rst_i    = 1;
        valid_i  = 0;
        first_i  = 0;
        second_i = 0;
        opcode_i = 0;

        @(posedge clk_i);
        #1;
        rst_i = 0;

        // Сложение (знаковое)
        valid_i  = 1;
        opcode_i = 2'b00;
        first_i  = 8'd10;
        second_i = 8'd15;
        // expected: result_o <= 0x19, valid_o <= 1.
        @(posedge clk_i); 
        #1;

        // second_i <= first_i
        valid_i  = 1;
        opcode_i = 2'b01;
        first_i  = 8'hAA;
        second_i = 8'hBB;
        // expected: result_o <= 0x00 (false)
        @(posedge clk_i);
        #1;

        // Логический сдвиг second_i влево на first_i
        valid_i  = 1;
        opcode_i = 2'b10;
        first_i  = 8'd3;
        second_i = 8'b0000_1111;
        // expected: 0000_1111 << 3 = 0111_1000 (0x78)
        @(posedge clk_i);
        #1;

        // Побитовое НЕ-ИЛИ
        valid_i  = 1;
        opcode_i = 2'b11;
        first_i  = 8'b1010_1010;
        second_i = 8'b0101_0101;
        // expected: ИЛИ -> 1111_1111, НЕ -> 0000_0000
        @(posedge clk_i);
        #1;

        // если valid_i = 0
        valid_i  = 0;
        opcode_i = 2'b00;   // попытка сложения
        first_i  = 8'd100;
        second_i = 8'd100;
        // expected: result_o не изменится; valid_o <= 0
        @(posedge clk_i);
        #1;
        
        @(posedge clk_i);
        
        $finish;
    end

endmodule