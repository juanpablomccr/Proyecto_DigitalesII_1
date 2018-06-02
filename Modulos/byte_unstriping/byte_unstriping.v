`timescale 1ns/1ps

module byte_unstriping(
		clk,			//reloj
		rst,			//reset	
		enb,			//enable
		rx_lane0,		// arreglo de salida de canal0
		rx_lane1,		// arreglo de salida de canal1
		rx_lane2,		// arreglo de salida de canal2
		rx_lane3,		// arreglo de salida de canal3
		rx_DataS,		//arreglo de entrada
		rx_Valid,		// Dato Tx o IDLE (1), señal de control (1)
		counter,		// contador para manejar salida 
);
 
input wire clk;
input wire rst;
input wire enb;
input wire [7:0] rx_lane0;
input wire [7:0] rx_lane1;
input wire [7:0] rx_lane2;
input wire [7:0] rx_lane3;
output reg [7:0] rx_DataS;
output reg rx_Valid; 

//variables internas auxiliares
output reg [1:0] counter;

//parametros

parameter [7:0] INACTIVE = 8'h00;



always@( posedge clk) begin
	if(rst) begin
		rx_DataS <= INACTIVE;
		counter <= 2'b00;
	end else if(!rst && enb ) begin
							
		case (counter)					//case para asignar datos al canal  correspondiente en cada ciclo de reloj	
			2'b00: begin				//Se utilizan las variables auxiliares para introducir ff de sincronizacion de la 
			rx_DataS <= rx_lane0 ;			//salida hacia el receptor.
			counter <= counter + 1'b1;
			end
			2'b01: begin
			rx_DataS <= rx_lane1;
			counter <= counter + 1'b1;
			end			
			2'b10: begin
			rx_DataS <= rx_lane2;
			counter <= counter + 1'b1;
			end
			2'b11: begin
			rx_DataS <= rx_lane3;
			counter <= 2'b00;
			end	
		endcase
	end


end
endmodule


