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
//      
//module LFSR15(clk, out); //LFSR module to be used in the future
//  input clk;
//  output reg [3:0] out;
//  wire feedback;
//  
//  assign feedback = ~(out[3] ^ out[2]);
//  
//  always @(posedge clk)
//    begin 
//      out = {out[3:0], feedback};
//    end
//endmodule