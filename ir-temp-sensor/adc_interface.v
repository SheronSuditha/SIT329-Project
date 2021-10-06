module adc_interface (
   input clk,
   input dout,
	output wire sclk,
	output reg din,
	output reg cs,
	output reg [11:0] ch0,
	output reg [11:0] ch1,
	output reg [11:0] ch2,
	output reg [11:0] ch3
);


// Timing
reg [4:0] cycle;


// Multi-Channel control
reg [1:0] channel;

wire [1:0] address;
assign address = channel + 1;		// Address is configuring the next channel


// Shift register to receive data from ADC
reg rst;
wire [11:0] buffer;
shift_register #(12) sr (
	.clk(sclk),
	.rst(rst),
	.in(dout),
	.data(buffer)
	);


// Initialisation
initial begin
    cycle = 4'b0;
    cs = 1'b1;
	 rst = 1'b0;
	 channel = 0;
end


// Manage CS (CONVST) and SCLK
always @(negedge clk) begin
    if (cycle == 0) cs <= 0;
	 else if (cycle == 12) cs <= 1;
end
assign sclk = cs?0:clk;


// Configure ADC
always @(negedge clk) begin

	// Default DIN state
	din <= 1;	
	
	case (cycle)
		0: din <= 1; // 1 = SINGLE-ENDED, 0 = DIFFERENTIAL
		1: din <= 0; // 1 = ODD, 0 = SIGN BIT
		2: din <= address[1]; // ADDRESS SELECT BIT 1
		3: din <= address[0]; // ADDRESS SELECT BIT 0
		4: din <= 1; // 1 = UNIPOLAR, 0 = BIPOLAR
		5: din <= 0; // 1 = SLEEP MODE
	endcase
end


// Manage data collection per channel
always @(posedge clk) begin
	
	// Default RST state
	rst <= 0;	

	case (cycle)
		13: begin
			// Transfer shift register buffer to channel output
			case (channel)
				0: ch0[11:0] = buffer[11:0]; 
				1: ch1[11:0] = buffer[11:0];
				2: ch2[11:0] = buffer[11:0];
				3: ch3[11:0] = buffer[11:0];
			endcase
		end
		14: begin
			rst <= 1;	// Reset shift register
			channel <= channel + 1;	// Move to next channel
		end
	endcase
end

always @(negedge clk) begin
    cycle <= cycle + 1;
end

endmodule