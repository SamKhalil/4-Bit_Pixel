//-----------------------------------------------------------------------------
//
// Title       : RE_control_TB
// Design      : digi_cam
// Author      : Liz
// Company     : Liz
//
//-----------------------------------------------------------------------------
//
// File        : RE_control_TB.v
// Generated   : Fri Nov 15 17:30:41 2013
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ms / 1 ns

module RE_control_TB;
	reg clk, reset, init, exp_inc, exp_dec;
	wire NRE_1, NRE_2, ADC, Expose, Erase, ovf4, ovf5;
	wire [4:0] EX_time;
	
	RE_control U0 (
	.clk		(clk),
	.reset		(reset),
	.init		(init),
	.exp_inc 	(exp_inc),
	.exp_dec 	(exp_dec),
	.NRE_1		(NRE_1),
	.NRE_2		(NRE_2),
	.ADC		(ADC),
	.Expose		(Expose),
	.Erase		(Erase),
	.ovf4		(ovf4),
	.ovf5		(ovf5),
	.EX_time	(EX_time)
	);
	
	initial
		begin
			clk = 1;
			reset = 0;
			init = 0;
			exp_inc = 0;
			exp_dec = 0;
		end
		
	always
		#0.5 	clk = !clk;
		
	initial
		begin
			$display("\t\tclk, \t\treset, \t\tinit, \t\texp_inc, \t\texp_dec, \t\tNRE_1, \t\tNRE_2, \t\tADC, \t\tExpose, \t\tErase, \t\tovf4, \t\tovf5, \t\tEX_time");
			$monitor("%d, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%b, \t%d", $time, clk, reset, init, exp_inc, exp_dec, NRE_1, NRE_2, ADC, Expose, Erase, ovf4, ovf5, EX_time);
		end
		
	initial
		begin
			
			#5	
			init <= 1;
			#1
			init <= 0;	 
			
			#25
			exp_inc <= 1;
			#30
			init <= 1;
			#1
			init <= 0;
			
			#25
			exp_inc <= 0;
			exp_dec <= 1;
			#15
			init <= 1;
			#1
			init <= 0;
			
			#25
			init <= 1;
			#1
			init <= 0;
			#10
			reset <= 1;	 
			#1
			reset <= 0;
			
			#5
			exp_inc <= 1;
			#8
			exp_inc <= 0;
					
			
			#50 $finish;
			
		end
		
			

endmodule
