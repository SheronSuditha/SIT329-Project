module shift_register #(parameter BITS=12) (
	input clk,
	input rst,
	input in,
	output reg [BITS-1:0] data
);

initial begin
	data = 0;
end

always @(posedge clk or posedge rst) begin
	if (rst) data <= 0;	// Reset data to 0
	else begin 
		data = data << 1;	// Shift left 1 bit
		data[0] = in;		// Set LSB to data in
	end
end

endmodule