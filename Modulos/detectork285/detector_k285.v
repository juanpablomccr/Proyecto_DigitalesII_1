`timescale 1ns/1ps


module detector_k285(
  clk, 					//clock
  rst,					//reset
  enb,					//enb
  rx_DataE,				// array de rx_DataE de datos del canal RX
  rx_Valid,				// rx_Valid == 0, señál de control, rx_Valid == 1 señal de datos o IDLE
  k285, 				// indica que se detecto señal k28.5
  rx_DataS				//array de salida con la informacion, indistinto de si es data o señal de control
);


  //Entradas y salidas
  input wire clk;			
  input wire rst;
  input wire enb;
  input wire [7:0] rx_DataE;		 
  output reg k285;		
  output reg rx_Valid;
  output reg [7:0] rx_DataS;
  //parametros

  parameter [7:0] COM = 8'hBC;  
  parameter [7:0] STP = 8'hFB;
  parameter [7:0] SDP = 8'h5C;
  parameter [7:0] SKP = 8'h1C;
  parameter [7:0] END = 8'hFD;
  parameter [7:0] EDB = 8'hFE;
  parameter [7:0] FTS = 8'h3C;
  parameter [7:0] IDLE = 8'h7C;


  always @ (posedge clk) begin
    if (rst) begin
      k285 <= 0;			
   // rx_Valid <= 0;				//deshabilita la bandera de lectura
    end else if (!rst && enb ) begin
		rx_DataS <= rx_DataE;			//Se pasa el byte de entrada a la salida.
		k285 <= ( rx_DataS == COM );		//se cambia el estado rx_Valid
							//solo se indicara cuando se detecta un COM pero no se implementara funcionalidad con el
	//       rx_Valid <= k285 ? ~rx_Valid : rx_Valid;   //Si k285==1  ~rx_Valid, si k285==0 rx_Valid
		case (rx_DataE)
			STP: rx_Valid <= 1;
			SDP: rx_Valid <= 1;
			SKP: rx_Valid <= 1;
			END: rx_Valid <= 1;
			EDB: rx_Valid <= 1;
			FTS: rx_Valid <= 1;
			COM: rx_Valid <= 1;
			default: rx_Valid <= 0;
					
		endcase

	end
    end
endmodule

