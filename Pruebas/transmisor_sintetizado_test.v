`timescale 1ns/1ps
`include "Modulos/libs/cmos_cells.v"
`include "Sintesis/tx_sintetizado.v"
`include "Sintesis/"
`ifndef sintetizado
`include "Modulos/mux/mux.v"
`include "Modulos/byte_striping/byte_striping.v"
`endif


module transmisor_tester(
	clk,
	rst,
	enb,
	tx_Data,
	com,		
	skp,		
	stp,		
	sdp,		
	end_ok,		
	edb,		
	fts, 		
	idle,		
	control_dk,
	tx_lane0,       
	tx_lane1,               
	tx_lane2,               
	tx_lane3,               

);




output  reg clk;
output  reg  enb;
output  reg  rst;
output  reg  [7:0] tx_Data;
output  reg  [7:0] com;
output  reg  [7:0] skp;
output  reg  [7:0] stp;
output  reg  [7:0] sdp;
output  reg  [7:0] end_ok;
output  reg  [7:0] edb;
output  reg  [7:0] fts;
output  reg  [7:0] idle;
output  reg  [3:0] control_dk;

input wire [7:0] tx_lane0;
input wire [7:0] tx_lane1;
input wire [7:0] tx_lane2;
input wire [7:0] tx_lane3;
      
//variables internas
       
//conexinpution entre mux y byte_striping
wire [7:0] tx_mux_out;
wire tx_Valid;

transmisor transmisor_tester(
		.clk(clk),
		.rst(rst),
		.enb(enb),
		.tx_Data(tx_Data),
		.com(com),
		.skp(skp),
		.stp(stp),
		.sdp(sdp),
		.end_ok(end_ok),
		.edb(edb),
		.fts(fts),
                .idle(idle),	   
              .control_dk(control_dk),
                .tx_lane0(tx_lane0),  
                .tx_lane1(tx_lane1),  
                .tx_lane2(tx_lane2),  
                .tx_lane3(tx_lane3)
);	
		 
		 
//parametros    
parameter [7:0] INACTIVE = 8'b0;
parameter [7:0] STP = 8'hFB;
parameter [7:0] SDP = 8'h5C;
parameter [7:0] SKP = 8'h1C;
parameter [7:0] END = 8'hFD;
parameter [7:0] EDB = 8'hFE;
parameter [7:0] FTS = 8'h3C;
parameter [7:0] IDLE = 8'h7C;
parameter [7:0] COM = 8'hBC; 
//generacion de la señal de reloj
//ciclo de 2 ns

always #1 clk = ~clk;

initial begin
	$dumpfile("gtkws/tx_sintetizado.vcd");
	$dumpvars;
	$display("clk\tend\trst\ttx_Data\tcom\tskp\tstp\tsdp\tend_ok\tedb\tfts\tidle\tcontrol_dk\ttx_lane0\ttx_lane1\ttxlane2\ttxlane3");
	$monitor($time,"\t%b\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%b\t%h\t%h\t%h\t%h", clk, enb, rst, tx_Data, com, skp, stp, sdp, end_ok, edb, fts, idle, control_dk, tx_lane0, tx_lane1, tx_lane2, tx_lane3);
clk <= 0;
enb <= 0;
rst <= 1;
tx_Data <= 8'hff;
com <= COM;
skp <= SKP;
stp <= STP;
sdp <= SDP;
end_ok <= END;
edb <= EDB;
fts <= FTS;
idle <= IDLE;
@(posedge clk) begin
	rst <= 0;
	enb <= 1;
	end


#15
//Señal  IDLE
repeat (4)  begin
	@(posedge clk);
	control_dk <= 4'b1000; 
end
//COM
repeat (4)  begin
	@(posedge clk);
	control_dk <= 4'b0001;

end

//STP
	@(posedge clk); 
	control_dk <= 'b0011; 

//Data
repeat (2)  begin
	@(posedge clk);
	control_dk <= 4'b0000; 
end

//END
	@(posedge clk); 
	control_dk <= 4'b0101;

//COM
repeat (4)  begin
	@(posedge clk);
	control_dk <= 4'b0001;

end

//SKP
repeat (12) begin
	@(posedge clk);
	control_dk <= 4'b0010;
end

//STP
@(posedge clk); 
control_dk <= 4'b0011;

//Data
repeat (10)  begin
	@(posedge clk)
	control_dk <= 4'b0000;
end

//END
@(posedge clk);
control_dk <= 4'b0101;


//SDP
@(posedge clk);
control_dk <= 4'b0100;


//Data
repeat (2)  begin
	@(posedge clk);
	control_dk <= 4'b0000;
end
//END
@(posedge clk);
control_dk <= 4'b0101;


//IDLE
repeat (12)  begin
	@(posedge clk);
	control_dk <= 4'b1000; 
end

$finish;

end


endmodule
