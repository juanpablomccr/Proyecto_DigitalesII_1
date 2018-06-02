module mux(
	clk,			//reloj
	rst,			//reset
	enb,			//enable
	tx_DataE,		//arreglo de datos de entrada desde data layer
	com,			//señal de control COM
	skp,			//señal de control SKP
	stp,			//señal de control STP
	sdp,			//señal de control SDP
	end_ok,			//señal de control END
	edb,			//señal de control EDB
	fts, 			//señal de control FTS
	idle,			//señal de control IDLE
	control_dk,		//entrada que indica cual señal del mux debe pasar al proceso de byte_stripping
	tx_multiplexada,        //arreglo de salida que contiene la informacion de tx_DataE y las señales de control multiplexada
	tx_ValidS		//salida que indica si el arreglo de salida TX lleva señál de control(0) o data(1)
);

input wire clk;
input wire rst;
input wire enb;
input wire [7:0] tx_DataE;
input wire [7:0] com;
input wire [7:0] skp;
input wire [7:0] stp;
input wire [7:0] sdp;
input wire [7:0] end_ok;
input wire [7:0] edb;
input wire [7:0] fts;
input wire [7:0] idle;
input wire [3:0] control_dk;
output reg [7:0] tx_multiplexada;
output reg tx_ValidS;


parameter [7:0] INACTIVE = 8'b0;

always @ (*) begin
	if(rst) begin
		tx_multiplexada = INACTIVE;
		tx_ValidS = 1;
	end else if(!rst && enb) begin
		case (control_dk)
			0000: begin
			      	tx_ValidS = 1;
				tx_multiplexada = tx_DataE;
			end
			0001: begin
			       tx_ValidS = 0;
			       tx_multiplexada = com;
			end
			0010: begin
			       tx_ValidS = 0;
			       tx_multiplexada = skp;
			end
			0011: begin
			       tx_ValidS = 0;
			       tx_multiplexada = stp;
			end
			0100: begin
			       tx_ValidS = 0;
			       tx_multiplexada = sdp;
			end
			0101: begin
			       tx_ValidS = 0;
			       tx_multiplexada = end_ok;
			end
			0110: begin
			       tx_ValidS = 0;
			       tx_multiplexada = edb;
			end
			0111: begin
			       tx_ValidS = 0;
			       tx_multiplexada = fts;
			end
			1000: begin
			      	tx_ValidS = 1;
				tx_multiplexada = idle;
			end
			default: begin
				tx_multiplexada = INACTIVE;  
				tx_ValidS = 1;
			end
		endcase	
	end
end
endmodule

