module cycle_trainer(clock,rst,adc_inp,status,pulse_bn,temp,c_led,pulse);
input clock,rst,[11:0]adc_inp,status,pulse_bn,button;
output [7:0]temp,c_led,pulse;
parameter start,stop,database_request,sensor_request,database_recieved,sensor_recieved;
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
  volts_to_temp instance(.adc_inp(adc_input),.temp(temperature));
  PWM_Blink instance(.temp(temperature),.c_led(led));
  kicker instance(.status(status_sw), .pulse_bn(pulse_btn), .pulses(pulse));
    sensor_recieved<=1'b1;
  if(button)
    stop<=1'b1;
end
end module