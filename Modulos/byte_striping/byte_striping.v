`timescale 1ns/1ps

module byte_striping(
		clk,			//reloj
		rst,			//reset	
		enb,			//enable
		tx_Data,		//arreglo de entrada
		tx_Valid,		// Dato Tx o IDLE (1), señal de control (1)
		tx_lane0,		// arreglo de salida de canal0
		tx_lane1,		// arreglo de salida de canal1
		tx_lane2,		// arreglo de salida de canal2
		tx_lane3,		// arreglo de salida de canal3
);
 
input wire clk;
input wire rst;
input wire enb;
input wire tx_Valid;
input wire [7:0] tx_Data;

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
initial begin

tx_lane0 <= INACTIVE;		
tx_lane1 <= INACTIVE;		
tx_lane2 <= INACTIVE;		
tx_lane3 <= INACTIVE;
dff_lana_0_0 <= INACTIVE; 
dff_lana_0_1 <= INACTIVE;
dff_lana_0_2 <= INACTIVE;
dff_lana_1_0 <= INACTIVE;
dff_lana_1_1 <= INACTIVE;
dff_lana_2_0 <= INACTIVE;
counter <= 2'b00;

end


always@( posedge clk) begin
	if(rst) begin
	tx_lane0 <= INACTIVE;		
	tx_lane1 <= INACTIVE;		
	tx_lane2 <= INACTIVE;		
	tx_lane3 <= INACTIVE;
	dff_lana_0_0 <= INACTIVE; 
	dff_lana_0_1 <= INACTIVE;
	dff_lana_0_2 <= INACTIVE;
	dff_lana_1_0 <= INACTIVE;
	dff_lana_1_1 <= INACTIVE;
	dff_lana_2_0 <= INACTIVE;


	counter <= 2'b00;

	end else if(!rst && enb ) begin

/*case para asignar datos al canal  correspondiente en cada ciclo de reloj	
Se utilizan repeat para introducir ff de sincronizacion 
de la salida hacia el receptor.*/

		case (counter)
			2'b00: begin
			dff_lana_0_0 <= tx_Data;	
			counter <= counter + 1'b1;
			end
			2'b01: begin
			dff_lana_1_0 <= tx_Data;
			dff_lana_0_1 <= dff_lana_0_0;
			counter <= counter + 1'b1;
			end			
			2'b10: begin
			dff_lana_2_0 <= tx_Data;
			dff_lana_1_1 <= dff_lana_1_0;
			dff_lana_0_2 <= dff_lana_0_1;	
			counter <= counter + 1'b1;
			end
			2'b11: begin
			tx_lane0 <= dff_lana_0_2;
			tx_lane1 <= dff_lana_1_1;
			tx_lane2 <= dff_lana_2_0;
			tx_lane3 <= tx_Data;
			counter <= 2'b00;
			end	
		endcase
	end


end
endmodule


