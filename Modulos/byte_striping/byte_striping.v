`timescale 1ns/1ps

module byte_striping(
		clk,			//reloj
		rst,			//reset	
		enb,			//enable
		tx_DataE,		//arreglo de entrada
		tx_ValidE,		// Dato Tx o IDLE (1), señal de control (1)
		tx_lane0,		// arreglo de salida de canal0
		tx_lane1,		// arreglo de salida de canal1
		tx_lane2,		// arreglo de salida de canal2
		tx_lane3,		// arreglo de salida de canal3
);
 
input wire clk;
input wire rst;
input wire enb;
input wire tx_ValidE;
input wire [7:0] tx_DataE;

output reg [7:0] tx_lane0;
output reg [7:0] tx_lane1;
output reg [7:0] tx_lane2;
output reg [7:0] tx_lane3;

//variables internas auxiliares
reg [1:0] counter;
reg [7:0] dff_lana_0_0;
reg [7:0] dff_lana_0_1;
reg [7:0] dff_lana_0_2;
reg [7:0] dff_lana_1_0;
reg [7:0] dff_lana_1_1;
reg [7:0] dff_lana_2_0;

// reg [1:0] counter;
// reg [7:0] dff_lana_0_0;
// reg [7:0] dff_lana_0_1;
// reg [7:0] dff_lana_0_2;
// reg [7:0] dff_lana_1_0;
// reg [7:0] dff_lana_1_1;
// reg [7:0] dff_lana_2_0;

//parametros

parameter [7:0] INACTIVE = 8'h00;



always@( posedge clk) begin
	if(rst) begin
//		tx_lane0 <= INACTIVE;		
//		tx_lane1 <= INACTIVE;		
//		tx_lane2 <= INACTIVE;		
//		tx_lane3 <= INACTIVE;
//		dff_lana_0_0 <= INACTIVE; 
//		dff_lana_0_1 <= INACTIVE;
//		dff_lana_0_2 <= INACTIVE;
//		dff_lana_1_0 <= INACTIVE;
//		dff_lana_1_1 <= INACTIVE;
//		dff_lana_2_0 <= INACTIVE;
	
	
		counter <= 2'b00;

	end else if(!rst && enb ) begin
							
		case (counter)					//case para asignar datos al canal  correspondiente en cada ciclo de reloj	
			2'b00: begin				//Se utilizan las variables auxiliares para introducir ff de sincronizacion de la 
			dff_lana_0_0 <= tx_DataE;			//salida hacia el receptor.
			counter <= counter + 1'b1;
			end
			2'b01: begin
			dff_lana_1_0 <= tx_DataE;
			dff_lana_0_1 <= dff_lana_0_0;
			counter <= counter + 1'b1;
			end			
			2'b10: begin
			dff_lana_2_0 <= tx_DataE;
			dff_lana_1_1 <= dff_lana_1_0;
			dff_lana_0_2 <= dff_lana_0_1;	
			counter <= counter + 1'b1;
			end
			2'b11: begin
			tx_lane0 <= dff_lana_0_2;
			tx_lane1 <= dff_lana_1_1;
			tx_lane2 <= dff_lana_2_0;
			tx_lane3 <= tx_DataE;
			counter <= 2'b00;
			end	
		endcase
	end


end
endmodule


