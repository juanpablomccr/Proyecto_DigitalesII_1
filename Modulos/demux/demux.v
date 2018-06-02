/*
*Código de implementación del demux que pasa los datos y señales de control  de la PHY al Data Link layer 
*
*
*
*/ 
`timescale 1ns/1ps


module demux (
	clk,			//reloj
	rst,			//reset
	enb,			//enable
	rx_multiplexada,    	//entrada proveniente del detector de la señal COM
	rx_ValidS,		//Dato Rx (1) o señál de control IDLED, señal de control K (0)
	rx_Data,		//arreglo de datos de salida hacia data link layer
	com,			//señal de control COM
	skp,			//señal de control SKP
	stp,			//señal de control STP
	sdp,			//señal de control SDP
	end_ok,			//señal de control END
	edb,			//señal de control EDB
	fts, 			//señal de control FTS
	idle,			//señal de control IDLE
);

//Declaracion de variables

input wire clk;		
input wire rst;		
input wire enb;		
input wire [7:0] rx_multiplexada;
input rx_Valid;
output reg rx_ValidS;
output reg [7:0] rx_Data;	
output reg [7:0] com;		
output reg [7:0] skp;		
output reg [7:0] stp;		
output reg [7:0] sdp;		
output reg [7:0] end_ok;		
output reg [7:0] edb;		
output reg [7:0] fts; 		
output reg [7:0] idle;

//parametros
parameter [7:0] INACTIVE = 8'b0;
parameter [7:0] COM = 8'hBC;  
parameter [7:0] STP = 8'hFB;
parameter [7:0] SDP = 8'h5C;
parameter [7:0] SKP = 8'h1C;
parameter [7:0] END = 8'hFD;
parameter [7:0] EDB = 8'hFE;
parameter [7:0] FTS = 8'h3C;
parameter [7:0] IDLE = 8'h7C;

always @ (*) begin
	if(rst) begin
		
	end else if(!rst && enb) begin
		 case (rx_multiplexada)
			COM: begin
			       rx_ValidS = 0;
			       com = rx_multiplexada;
				skp = INACTIVE;    
				stp = INACTIVE;    
				sdp = INACTIVE;    
				end_ok = INACTIVE; 
				edb = INACTIVE;    
				fts = INACTIVE;    
				idle = INACTIVE;  
			end
			SKP: begin
			       rx_ValidS = 0;
			       skp = rx_multiplexada;
				com = INACTIVE;    
				rx_Data = INACTIVE;    
				stp = INACTIVE;    
				sdp = INACTIVE;    
				end_ok = INACTIVE; 
				edb = INACTIVE;    
				fts = INACTIVE;    
				idle = INACTIVE;  
			end
			STP: begin
			       rx_ValidS = 0;
			       stp = rx_multiplexada ;
				com = INACTIVE;    
				skp = INACTIVE;    
				rx_Data = INACTIVE;    
				sdp = INACTIVE;    
				end_ok = INACTIVE; 
				edb = INACTIVE;    
				fts = INACTIVE;    
				idle = INACTIVE;  
			end
			SDP: begin
			       rx_ValidS = 0;
			       sdp = rx_multiplexada;
				com = INACTIVE;    
				skp = INACTIVE;    
				stp = INACTIVE;    
				rx_Data = INACTIVE;    
				end_ok = INACTIVE; 
				edb = INACTIVE;    
				fts = INACTIVE;    
				idle = INACTIVE;  
			end
			END: begin
			       rx_ValidS = 0;
			       end_ok = rx_multiplexada;
				com = INACTIVE;    
				skp = INACTIVE;    
				stp = INACTIVE;    
				sdp = INACTIVE;    
				rx_Data = INACTIVE; 
				edb = INACTIVE;    
				fts = INACTIVE;    
				idle = INACTIVE;  
			end
			EDB: begin
			       rx_ValidS = 0;
			       edb = rx_multiplexada;
				com = INACTIVE;    
				skp = INACTIVE;    
				stp = INACTIVE;    
				sdp = INACTIVE;    
				end_ok = INACTIVE; 
				rx_Data = INACTIVE;    
				fts = INACTIVE;    
				idle = INACTIVE;  
			end
			FTS: begin
			       rx_ValidS = 0;
			       fts = rx_multiplexada;
				com = INACTIVE;    
				skp = INACTIVE;    
				stp = INACTIVE;    
				sdp = INACTIVE;    
				end_ok = INACTIVE; 
				edb = INACTIVE;    
				rx_Data = INACTIVE;    
				idle = INACTIVE;  
			end
			IDLE: begin
			      	rx_ValidS = 1;
				idle = rx_multiplexada;
				com = INACTIVE;    
				skp = INACTIVE;    
				stp = INACTIVE;    
				sdp = INACTIVE;    
				end_ok = INACTIVE; 
				edb = INACTIVE;    
				fts = INACTIVE;    
				rx_Data = INACTIVE;  
			end
			default: begin
				rx_ValidS = 1;
				rx_Data = rx_multiplexada;  
				com = INACTIVE;    
				skp = INACTIVE;    
				stp = INACTIVE;    
				sdp = INACTIVE;    
				end_ok = INACTIVE; 
				edb = INACTIVE;    
				fts = INACTIVE;    
				idle = INACTIVE;  
			end
		endcase	
	end
end
endmodule


