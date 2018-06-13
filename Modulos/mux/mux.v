module mux(
	clk,			//reloj
	rst,			//reset
	enb,			//enable
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
	tx_multiplexada,        //arreglo de salida que contiene la informacion de tx_DataE y las señales de control multiplexada
	tx_Valid		//salida que indica si el arreglo de salida TX lleva señál de control(0) o data(1)
);

input wire clk;
input wire rst;
input wire enb;
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
output reg [7:0] tx_multiplexada;
output reg tx_Valid;


parameter [7:0] INACTIVE = 8'b0;


initial begin
tx_multiplexada = INACTIVE;
tx_Valid = 1;
end

always @ (*) begin

	tx_multiplexada = INACTIVE;
	tx_Valid = 1;
	
	if(rst) begin
		tx_multiplexada = INACTIVE;
		tx_Valid = 1;
	end else if(!rst && enb) begin
		//Los elementos de selección se dan en decimal ya que en binario no los
		//reconoce correctamente
		
		
		case (control_dk)
			0: begin
			      	tx_Valid = 1;
				tx_multiplexada = tx_Data;
			end
			1: begin
			       tx_Valid = 0;
			       tx_multiplexada = com;
			end
			2: begin
			       tx_Valid = 0;
			       tx_multiplexada = skp;
			end
			3: begin
			       tx_Valid = 0;
			       tx_multiplexada = stp;
			end
			4: begin
			       tx_Valid = 0;
			       tx_multiplexada = sdp;
			end
			5: begin
			       tx_Valid = 0;
			       tx_multiplexada = end_ok;
			end
			6: begin
			       tx_Valid = 0;
			       tx_multiplexada = edb;
			end
			7: begin
			       tx_Valid = 0;
			       tx_multiplexada = fts;
			end
			8: begin
			      	tx_Valid = 1;
				tx_multiplexada = idle;
			end
		endcase	
	end
end
endmodule

