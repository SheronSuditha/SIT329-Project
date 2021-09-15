module volts_to_temp (
	input [11:0] adc_input,
	output reg [7:0] temperature
);

// Scale adc_input range from 0 - 4095 to 0 - 100 temperature range
always @(*) begin
	temperature <= adc_input / 41;	
end

endmodule