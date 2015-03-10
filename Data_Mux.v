
module Data_Mux(SCL,selData,reset,selAA,sel55,selB0,selC0,selD0,selE0,sel00,WE_N,CE_N,OE_N,DInDOut,EnDataOut,EnDataIn,selAddr,shiftRegOut,
shiftRegIn,data_out);

input wire reset,SCL,selData,selAA,sel55,selB0,selC0,selD0,selE0,WE_N,CE_N,OE_N,EnDataOut,selAddr,sel00,EnDataIn;

input [7:0] shiftRegOut,data_out;
//wire  shiftRegOut;

output reg [7:0] DInDOut, shiftRegIn;

parameter DataAA=8'hAA, Data55=8'h55, DataB0=8'hB0, DataC0=8'hC0, DataD0=8'hD0, DataE0=8'hE0, Data00=8'h00;



always @*//(negedge WE_N)
 begin:Data_block
//if(reset == 1) begin
//	DInDOut = 8'b0;
//	shiftRegIn = 8'b0;
//	end
//else begin
	if(!(WE_N == 0 && CE_N == 0) && !(OE_N == 0 && CE_N == 0))disable Data_block;

	if(selAA == 1)DInDOut = DataAA;

	if(sel55 == 1)DInDOut = Data55;

	if(selB0 == 1)DInDOut = DataB0;

	if(selC0 == 1)DInDOut = DataC0;

	if(selD0 == 1)DInDOut = DataD0;

	if(selE0 == 1)DInDOut = DataE0;

	if(sel00 == 1)DInDOut = Data00;

	if(selData == 1 && EnDataOut == 1) DInDOut = shiftRegOut;

	if(EnDataIn == 1) 
	shiftRegIn = data_out; 
//   end
end

endmodule
