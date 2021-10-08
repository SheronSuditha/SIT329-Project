'include "ir-temp-sensor/volts_to_temp.v"
'include "heart-rate-sensor/heartRate_sim.v"
'include "pwm-blink/PWM_Blink.v"



module cycle_trainer(clock,adc_inp,status,pulse_bn,button,temp,c_led,pulse);
  input [11:0]adc_inp;
  input clock,status,pulse_bn,button,reset;
  output c_led,pulse;
  output  [7:0]temp;
  reg start,stop,database_request,sensor_request,database_recieved,sensor_recieved;
 // volts_to_temp A(adc_inp ,temp );
//  PWM_Blink B(temp,clock,c_led);
 // kicker C(status, pulse_bn,clock,reset,pulses);   
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
      volts_to_temp A(adc_inp ,temp );
  PWM_Blink B(temp,clock,c_led);
  kicker C(status, pulse_bn,clock,reset,pulses);   
    sensor_recieved<=1'b1;
  if(button)
    stop<=1'b1;
end
endmodule
