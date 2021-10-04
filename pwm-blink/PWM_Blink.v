module PWM_Blink(
	 input [7:0] temperature,
    input clk,
	 output led
	 );
	 
reg [7:0] counter =0;
always@(posedge clk) begin
	if (counter < 100) counter <= counter +1;
	else counter <= 0;
end


integer temp;
integer percent;
always @(temperature) begin
	temp = temperature;
	percent = temp *3;
	if (percent > 100) percent = 100;
end

assign led = (counter < percent) ? 1:0;
endmodule
