//-----------------------------------------------------------------------------
//
// Title       : RE_control
// Design      : digi_cam
// Author      : Liz
// Company     : Liz
//
//-----------------------------------------------------------------------------
//
// File        : RE_control.v
// Generated   : Thu Nov 14 11:27:24 2013
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ps


module RE_control ( clk, reset, init, exp_inc, exp_dec, NRE_1, NRE_2, ADC, Expose, Erase, ovf4, ovf5, EX_time);	   
	
input clk, reset, init, exp_inc, exp_dec;
output reg NRE_1, NRE_2, ADC, Expose, Erase;
output reg ovf4, ovf5; 	// overflow timers
output reg [4:0] EX_time;		// exposure time
reg [4:0] counter;	// counter 
reg [1:0] state, next_state;

parameter 	Idle = 2'b00,
			Exposure = 2'b01,
			Readout = 2'b10,
			Other = 2'b11;	  
			
parameter	S0 = 5'b00000,
			S1 = 5'b00001,
			S2 = 5'b00010,
			S3 = 5'b00011,
			S4 = 5'b00100,
			S5 = 5'b00101,
			S6 = 5'b00110,
			S7 = 5'b00111,
			S8 = 5'b01000,
			S9 = 5'b01001,
			S28 = 5'b11100,
			S30 = 5'b11110;
			
initial
	begin
		state <= Idle;
		counter <= 0;	
		EX_time <= S5;
	end

always @ (posedge clk or posedge reset)		 
	begin
		// reset
		if (reset)	
			begin
				state <= Idle;
				counter <= 0;	
			end
		else
			begin
			// state machine
				case(state)	
					
					Idle: 			//0
					begin
						if(!init)
							begin
								state <= Idle;
								next_state <= Exposure;
								Erase <= 1;
								Expose <= 0;
								NRE_1 <= 1;
								NRE_2 <= 1;
								ADC <= 0;
							end	
						else
							begin
								state <= next_state; 
							end
					end
					
					Exposure:		  //1	 
					begin
						if (!ovf5)
							begin
								state <= Exposure;
								next_state <= Readout;
								Erase <= 0;
								Expose <= 1;
								NRE_1 <= 1;
								NRE_2 <= 1;
								ADC <= 0; 
								counter <= counter + 1;
							end	 
						else
							begin
								state <= next_state;
								Expose <= 0;
								counter <= 0;
								ovf5 <= 0;
							end
					end
							
					Readout:	   //2	 
					begin
						if (!ovf4)
							begin
								if (counter < S3)
									begin	   
										NRE_1 <= 0;	 
										next_state <= Idle;
										if (counter == S1)  
											begin
												ADC <= 1; 
											end
										else 
											begin
												ADC <= 0;
											end	
										counter <= counter + 1;
									end	   
								else if (counter == S3)
									begin
										NRE_1 <= 1;
										NRE_2 <= 1;
										counter <= counter + 1;
									end	  
								else if ((counter > S3)&&(counter < S7))
									begin
										NRE_2 <= 0;
										if (counter == S5)
											begin
												ADC <= 1;
											end
										else
											begin
												ADC <= 0;
											end	
										counter <= counter + 1;
									end	
								else if (counter == S7)
									begin
										NRE_2 <= 1;
										counter <= counter + 1;
									end									
							end	 
						else
							begin
								state <= next_state;
								counter <= 0; 
								Erase <= 1;
								ovf4 <= 0;
							end
					end
					
					Other:	  //3
					begin	  
						state <= Idle;						
					end   	
					
				endcase		 
			end
	end			
	
	
always @ (posedge clk)
	begin  
		// Exposure time  
		case(state)
			Idle:
			begin
				if(exp_inc == 1)		
					begin  	 
						if (EX_time > S28)
							begin  
								EX_time <= S30;
							end	
						else
							begin
								EX_time <= EX_time + 1;	   
							end
					end
				else if((exp_inc == 0) && (exp_dec == 1))	
					begin
						if (EX_time<S4)  
							begin
								EX_time <= S2;		  
							end
						else	   
							begin
								EX_time <= EX_time - 1;
							end
					end
				else 
					begin 
						EX_time <= EX_time;
					end	 
			end	
		endcase
			
		// Overflow flags
		
		// Exposure time (expose state)
		if (counter >= EX_time-2) 
			begin
				ovf5 <= 1;
			end	  
		else
			begin
				ovf5 <= 0;
			end
		
		// Readout time (readout state)
		if (counter >= S7)
			begin
				ovf4 <= 1;
			end
		else  
			begin
				ovf4 <= 0;	
			end
	end		

endmodule
