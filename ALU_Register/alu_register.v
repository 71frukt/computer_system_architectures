`timescale 1ns / 1ps

module alu_register #(
    parameter WIDTH = 8
)(
    input  wire             clk_i,
    input  wire             rst_i,
    input  wire             valid_i,
    input  wire [WIDTH-1:0] first_i,
    input  wire [WIDTH-1:0] second_i,
    input  wire [1:0]       opcode_i,

    output reg              valid_o,
    output reg  [WIDTH-1:0] result_o
);

    reg [WIDTH-1:0] alu_result;

    always @(*) begin
        alu_result = {WIDTH{1'b0}}; 
        
        case (opcode_i)
            2'b00:   alu_result = $signed(first_i) + $signed(second_i); // Сложение (знаковое)
            2'b01:   alu_result = (second_i <= first_i);                // second_i <= first_i
            2'b10:   alu_result = second_i << first_i;                  // Логический сдвиг second_i влево на first_i
            2'b11:   alu_result = ~(first_i | second_i);                // Побитовое НЕ-ИЛИ
            
            default: alu_result = {WIDTH{1'b0}};
        endcase
    end

    always @(posedge clk_i)
    begin
        if (rst_i) begin
            valid_o <= 1'b0;
        end
        else begin
            valid_o <= valid_i;
        end

        if (valid_i) begin
            result_o <= alu_result;
        end
    end

endmodule