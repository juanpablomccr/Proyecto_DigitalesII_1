`timescale 1ns/1ps
`define estransmisor 1
`include "Modulos/mux/mux.v"
`include "Modulos/byte_striping/byte_striping.v"

	
module transmisor (
	clk,
	rst,
	enb,
	tx_Data,		//arreglo de datos de entrada desde data layer
	com,			//señal de control COM
	skp,			//señal de control SKP
	stp,			//señal de control STP
	sdp,			//señal de control SDP
	end_ok,			//señal de control END
	edb,			//señal de control EDB
	fts, 			//señal de control FTS
	idle,			//señal de control IDLE
	control_dk,		//entrada que indica cual señal del mux debe pasar al proceso de byte_stripping
	tx_lane0,               // arreglo de salida de canal0
	tx_lane1,               // arreglo de salida de canal1
	tx_lane2,               // arreglo de salida de canal2
	tx_lane3,               // arreglo de salida de canal3
);
//Declaracion de puertos de entrada y salida
input wire clk;
input wire enb;
input wire rst;
input wire [7:0] tx_Data;
input wire [7:0] com;
input wire [7:0] skp;
input wire [7:0] stp;
input wire [7:0] sdp;
input wire [7:0] end_ok;
input wire [7:0] edb;
input wire [7:0] fts;
input wire [7:0] idle;
input wire [3:0] control_dk;
output wire [7:0] tx_lane0;
output wire [7:0] tx_lane1;
output wire [7:0] tx_lane2;
output wire [7:0] tx_lane3;
//variables internas

//conexion entre mux y byte_striping
wire [7:0] tx_mux_out;
wire tx_Valid;


//Instancias de los módulos
mux tx_mux(
	.clk(clk),
	.enb(enb),
	.rst(rst),
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
	.tx_multiplexada(tx_mux_out),
	.tx_Valid(tx_Valid)
);

byte_striping tx_byte_striping(
	.clk(clk),
	.enb(enb),
	.rst(rst),
	.tx_Data(tx_mux_out),
	.tx_Valid(tx_Valid),
	.tx_lane0(tx_lane0),
	.tx_lane1(tx_lane1),
	.tx_lane2(tx_lane2),
	.tx_lane3(tx_lane3)
);
endmodule
