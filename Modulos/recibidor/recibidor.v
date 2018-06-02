`timescale 1ns/1ps

//includes para poder ejecutarse

include "../byte_strip/byte_striping.v"
include "../mux/mux.v" 



module recibidor (
		rst,
		enb,
		clk,
		tx_Data,
		control_dk,	
	        tx_lane0,
		tx_lane1,
		tx_lane2,
		tx_lane3	
);

always@() begin
	if(rst) begin
		
	end else if ( !rst && enb) begin

	end

end
endmodule
