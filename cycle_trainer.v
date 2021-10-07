module volts_to_temp (input [11:0] adc_input,output reg [7:0] temperature);
// Scale adc_input range from 0 - 4095 to 0 - 100 temperature range
always @(*) begin
	temperature <= adc_input / 41;	
end
endmodule

module kicker(status_sw, pulse_btn, clk, rst, pulse);
  input status_sw, pulse_btn, clk, rst;
  output pulse;
  reg [3:1] state; 
  reg pulse_status;
  
  parameter status_switch_OFF = 3'b000; //status switch is OFF
  parameter status_switch_ON = 3'b100; //status switch is ON
  
  //can add other possible states to get a relative count of the heart rate. 
  // furthermore, get the input from the ADC to process the needed data and result an output. 
  
  always @(posedge clk) 
    begin 
		if(status_sw == 1) 
        begin 
          state = status_switch_ON;
        end    
		  
      if(rst)
        begin 
          state = status_switch_OFF;
        end 
      else 
        begin
          case (state)
            status_switch_ON:
              begin
					  if(pulse_btn == 1)
							pulse_status = 1;
						else 
							pulse_status = 0;
				  end
				  default:
					pulse_status = 0;
          endcase
        end
    end
	 assign pulse = pulse_status;
endmodule
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

module cycle_trainer(clock,adc_inp,status,pulse_bn,button,temp,c_led,pulse);
  input [11:0]adc_inp;
  input clock,status,pulse_bn,button,reset;
  output c_led,pulse;
  output  [7:0]temp;
  reg start,stop,database_request,sensor_request,database_recieved,sensor_recieved;
  volts_to_temp A(adc_inp ,temp );
  PWM_Blink B(temp,clock,c_led);
  kicker C(status, pulse_bn,clock,reset,pulses);   
always @ (posedge clock)
begin
  
  if(button)
    start<=1'b1;
  if(start)
    database_request<=1'b1;
    sensor_request<=1'b1;
  if(database_request)
    database_recieved<=1'b1;
  if(sensor_request)  
    sensor_recieved<=1'b1;
  if(button)
    stop<=1'b1;
end
endmodule
