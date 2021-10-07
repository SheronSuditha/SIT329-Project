// Code your testbench here
// or browse Examples

module cycle_trainer_tb;
  reg clock,pulse_button,buttons,status;
  reg[11:0] adc_input;
  wire[7:0] temperature;
  wire led,pulses;
  cycle_trainer uut(clock,adc_input,status,pulse_button,buttons,temperature,led,pulses );
    initial 
      begin
        clock <=1'b1;
        status<=1'b1;
        
    adc_input<=11'b1100110011;  pulse_button <= 1'b1;
 buttons<=1'b1;
   #10
 

    $dumpfile("dump.vcd");
    $dumpvars(1);
  end 
endmodule
