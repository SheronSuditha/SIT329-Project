module adc_interface (
   input clk,
   input dout,
	output wire sclk,
	output reg din,
	output reg cs,
	output reg [11:0] ch0
);

reg [4:0] cycle;
reg [11:0] ch0_buffer;

initial begin
    cycle = 4'b0;
    cs = 1'b1;
end

// Manage CS (CONVST) and SCLK
always @(negedge clk) begin
    if (cycle == 0) cs <= 0;
	 else if (cycle == 12) cs <= 1;
end
assign sclk = cs?0:clk;

// Configure ADC using DIN
always @(negedge clk) begin
	din <= 1;
	case (cycle)
	0: din <= 1; // 1 = SINGLE-ENDED, 0 = DIFFERENTIAL
	1: din <= 0; // 1 = ODD, 0 = SIGN BIT
	2: din <= 0; // ADDRESS SELECT BIT 1
	3: din <= 0; // ADDRESS SELECT BIT 0
	4: din <= 1; // 1 = UNIPOLAR, 0 = BIPOLAR
	5: din <= 0; // 1 = SLEEP MODE
	endcase
end

// Read ADC data on DOUT
always @(posedge clk) begin
	case (cycle)
	1: ch0_buffer[11] <= dout;
	2: ch0_buffer[10] <= dout;
	3: ch0_buffer[9] <= dout;
	4: ch0_buffer[8] <= dout;
	5: ch0_buffer[7] <= dout;
	6: ch0_buffer[6] <= dout;
	7: ch0_buffer[5] <= dout;
	8: ch0_buffer[4] <= dout;
	9: ch0_buffer[3] <= dout;
	10: ch0_buffer[2] <= dout;
	11: ch0_buffer[1] <= dout;
	12: ch0_buffer[0] <= dout;
	13: ch0[11:0] <= ch0_buffer[11:0]; // Transfer buffer to output register
	endcase
end

always @(negedge clk) begin
    cycle <= cycle + 1;
end

endmodule