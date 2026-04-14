module edge_detector (
    input  wire       clk_i,
    input  wire       rst_i,
    input  wire       signal_i,
    output reg  [1:0] detect_o
);

    reg signal_prev;

    always @(posedge clk_i)
    begin
    
        if (rst_i) 
        begin
            signal_prev <= 1'b0;
            detect_o    <= 2'b00;
        end
        
        else begin
            signal_prev <= signal_i;

            if (signal_i == 1'b1 && signal_prev == 1'b0)
            begin
                detect_o <= 2'b01;
            end

            else if (signal_i == 1'b0 && signal_prev == 1'b1)
            begin
                detect_o <= 2'b10;
            end
            
            else begin
                detect_o <= 2'b00;
            end
        end
    end

endmodule