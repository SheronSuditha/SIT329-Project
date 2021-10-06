module led_display (
	input [7:0] temperature,
	output wire [7:0] LED
);

reg [7:0] state;

initial begin
	state = 8'd0;
end

always @(*) begin
	state <= 8'd0;
	if (temperature > 11) state[0] <= 1'd1;
	if (temperature > 22) state[1] <= 1'd1;
	if (temperature > 33) state[2] <= 1'd1;
	if (temperature > 44) state[3] <= 1'd1;	
	if (temperature > 55) state[4] <= 1'd1;	
	if (temperature > 66) state[5] <= 1'd1;
	if (temperature > 77) state[6] <= 1'd1;
	if (temperature > 88) state[7] <= 1'd1;
end

assign LED = state;

endmodule