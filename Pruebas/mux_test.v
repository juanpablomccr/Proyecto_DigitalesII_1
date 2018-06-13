`timescale 1ns/1ps
`include "Modulos/libs/cmos_cells.v"
`include "Modulos/mux/mux.v"

module transmisor_tester(
	clk,
	rst,
	enb,
	tx_DataE,
	com,		
	skp,		
	stp,		
	sdp,		
	end_ok,		
	edb,		
	fts, 		
	idle,		
	control_dk,
	tx_Valid,               
	tx_multiplexada,               

);




output  reg clk;
output  reg  enb;
output  reg  rst;
output  reg  [7:0] tx_DataE;
output  reg  [7:0] com;
output  reg  [7:0] skp;
output  reg  [7:0] stp;
output  reg  [7:0] sdp;
output  reg  [7:0] end_ok;
output  reg  [7:0] edb;
output  reg  [7:0] fts;
output  reg  [7:0] idle;
output  reg  [3:0] control_dk;
input  wire [7:0] tx_multiplexada;
input  wire tx_Valid;
      
//variables internas
       
//conexinpution entre mux y byte_striping
wire [7:0] tx_mux_out;

mux mux_tester(
		.clk(clk),
		.rst(rst),
		.enb(enb),
		.tx_DataE(tx_DataE),
		.com(com),
		.skp(skp),
		.stp(stp),
		.sdp(sdp),
		.end_ok(end_ok),
		.edb(edb),
		.fts(fts),
                .idle(idle),	   
              .control_dk(control_dk),
                .tx_multiplexada(tx_multiplexada),  
                .tx_Valid(tx_Valid)  
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

always begin
#1 clk = ~clk;
tx_DataE = 8'hff;
com = COM;
skp = SKP;
stp = STP;
sdp = SDP;
end_ok = END;
edb = EDB;
fts = FTS;
idle = IDLE;
end
initial begin
	$dumpfile("gtkws/mux123.vcd");
	$dumpvars;
	$display("clk\tend\trst\ttx_DataE\tcom\tskp\tstp\tsdp\tend_ok\tedb\tfts\tidle\tcontrol_dk\ttx_multiplexada");
	$monitor($time,"\t%b\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%h\t%b\t%h", clk, enb, rst, tx_DataE, com, skp, stp, sdp, end_ok, edb, fts, idle, control_dk, tx_multiplexada);

clk <= 0;
enb <= 0;
rst <= 1;

@(posedge clk) begin
	rst <= 0;
	enb <= 1;
end


#15
//Señal  IDLE
repeat (4)  begin
	@(posedge clk);
	control_dk <= 4'd8; 
end

//COM
repeat (4)  begin
	@(posedge clk);
	control_dk <= 4'd1;
end

//STP
repeat (1)  begin
	@(posedge clk); 
	control_dk <= 'd3; 
end 

//Data
repeat (2)  begin
	@(posedge clk);
	control_dk <= 4'b0000; 
end

//END
repeat (1)  begin
	@(posedge clk); 
	control_dk <= 4'b0000;
end

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
repeat (4)  begin
	@(posedge clk);
	control_dk <= 4'b1000; 
end

$finish;

end


endmodule
