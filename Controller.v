module I2C_Controller(SCL,SDA,reset,shiftRegOut,write,read,EnSDAOut,shiftIn,shiftOut,LoadDevID,LoadRW,
LoadAddLSB,LoadAddMSB,sel5555,selAA,WE_N,CE_N,OE_N,,selAAAA,sel55,sel00,selB0,selC0,selD0,
selE0,sel00,selAddr,selData,EnDataOut,IncrAddr,selAux,SDAIn,SDAOut,LoadShift,selStartAddr,EnDataIn,START,STOP);

input wire SCL,SDA,write,read,reset;
input wire [7:0] shiftRegOut;

output reg shiftIn,shiftOut,LoadRW,SDAIn,SDAOut;
output reg EnSDAOut,LoadDevID,sel5555,WE_N,CE_N,OE_N,selAAAA,selAA,sel55,sel00,selB0,selC0,selD0,selE0,LoadAddLSB,LoadAddMSB,
selAddr,selData,EnDataOut,IncrAddr,selAux,LoadShift,selStartAddr,EnDataIn,START,STOP;

//wire [7:0] shiftRegOut;
//wire [7:0] Addr;

reg [5:0] current_state, next_state;



parameter IDLE=8'b0,DAdd0=8'b10, DAdd1=8'b11, DAdd2=8'b100,DAdd3=8'b101,DAdd4=8'b110,DAdd5=8'b111,DAdd6=8'b1000,
W=8'b1001,DevIDACK=8'b1010,Add0=8'b1011,Add1=8'b1100,Add2=8'b1101,Add3=8'b1110,Add4=8'b1111,
Add5=8'b10000,Add6=8'b10001,Add7=8'b10010,AddLSBACK=8'b10011,Add8=8'b10100,Add9=8'b10101,Add10=8'b10110,
Add11=8'b10111,Add12=8'b11000,Add13=8'b11001,Add14=8'b11010,Add15=8'b11011,AddMSBACK=8'b11100,D0F=8'b11101,
D1F=8'b11110,D2F=8'b11111,D3F=8'b100000,D4F=8'b100001,D5F=8'b100010,D6F=8'b100011,D7F=8'b100100,
DataACK=8'b100101,D0=8'b100110,D1=8'b100111,D2=8'b101000,D3=8'b101001,D4=8'b101010,D5=8'b101011,D6=8'b101100,D7=8'b101101,
oxD0=8'b101110,HOLD2=8'b101111,oxE0=8'b110000,MACK=8'b110001,HOLD1=8'b110010;//STOP=11111111;  

/*
initial begin
	current_state = IDLE;
	CE_N = 1;
	WE_N = 1;
	LoadRW = 0;
end*/


//To detect start condition
always @(negedge SDA)	if(SCL == 1)begin START <= 1; STOP <= 0; current_state <= IDLE; end

//To detect stop condition
always @(posedge SDA)	if(SCL == 1)begin 
START <= 0; STOP <= 1;
next_state <= HOLD1; end

always  @(negedge SCL)
//if(reset == 1) current_state <= IDLE;
 current_state <= next_state;




always @(current_state) begin
	sel5555 	<= 0;
	selAAAA 	<= 0;
	selAA 		<= 0;
	sel55 		<= 0;
	selB0 		<= 0;
	selC0 		<= 0;
	selD0 		<= 0;
	selE0 		<= 0;
	shiftIn 	<= 0;
	shiftOut	<= 0;
        EnSDAOut 	<= 0;
	LoadAddLSB 	<= 0;
	LoadAddMSB 	<= 0;
	selAddr 	<= 0;
	selData 	<= 0;
	EnDataOut 	<= 0;
	IncrAddr 	<= 0;
	LoadRW 		<= 0;
	EnDataOut 	<= 0;
	//OE_N		<= 1;
	
case(current_state)
IDLE:
begin
	if(START == 1)	next_state = DAdd0;
	if(START == 0) next_state = IDLE;
end
DAdd0:
begin
	shiftIn		<=1;
	CE_N		<=1;
	WE_N 		<= 1;
	next_state 	<= DAdd1;
end


DAdd1:
begin
	shiftIn		<=1;
	CE_N		<=1;
	WE_N 		<= 1;
	next_state 	<= DAdd2;
end

DAdd2:
begin
	shiftIn<=1;
	CE_N<=1;
	WE_N <= 1;
	next_state <= DAdd3;
end
DAdd3:
begin
	shiftIn<=1;
	CE_N<=1;
	WE_N <= 1;
	next_state <= DAdd4;
end
DAdd4:
begin
	shiftIn<=1;
	CE_N<=1;
	WE_N <= 1;
	next_state <= DAdd5;
end
DAdd5:
begin
	shiftIn<=1;
	CE_N<=1;
	WE_N <= 1;
	next_state <= DAdd6;
end
DAdd6:
begin
	shiftIn<=1;
	CE_N<=1;
	WE_N <= 1;
	next_state <= W;
end

W:
begin
	shiftIn<=1;
	CE_N<=1;
	WE_N <= 1;
	LoadRW <= 1;
	next_state <= DevIDACK;
end
/*
DevIDACK:
begin
	shiftIn=0;
	EnSDAOut = 1;
	LoadDevID=1;
	sel5555 = 1;
	selAAAA = 0;
	selAA = 1;
	sel55 = 0;
	CE_N=0;
	WE_N = 0;
	next_state = Add0; 
end
*/
endcase

//current_state <= next_state;

end



always @(current_state)
begin

if(read == 1) begin
	sel5555 <= 0;sel55<=0;selAAAA<=0;selAA<= 0;sel00<= 0;SDAIn<= 0;LoadAddLSB <= 0;EnSDAOut<=0;EnDataOut<=0;
	shiftOut <= 0; SDAOut <= 0; LoadAddMSB <= 0; IncrAddr <= 0; LoadDevID<=0; LoadShift <= 0;
case(current_state)
DevIDACK:
begin
	shiftIn<=0;EnSDAOut <= 1;	LoadDevID<=1;CE_N<=0;WE_N <= 0;
	next_state <= Add0; 
end

Add0:
begin
	shiftIn <= 1; sel5555 <= 1; selAA <= 1; EnDataOut <= 1; SDAIn <= 1; CE_N <= 0; WE_N <= 0; OE_N <= 1;
	next_state <= Add1;
end

Add1:
begin
	shiftIn <= 1; SDAIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add2;
end

Add2:
begin
	shiftIn <= 1; sel55 <= 1; selAAAA <= 1;EnDataOut <= 1; SDAIn <= 1; CE_N <= 0; WE_N <= 0; OE_N <= 1;		
	next_state <= Add3;
end

Add3:
begin
	shiftIn <= 1; SDAIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add4;
end

Add4:
begin
	shiftIn <= 1; sel5555 <= 1; sel00 <= 1;EnDataOut <= 1; SDAIn <= 1; CE_N <= 0; WE_N <= 0; OE_N <= 1;		
	next_state <= Add5;
end


Add5:
begin
	shiftIn <= 1; SDAIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add6;
end


Add6:
begin
	shiftIn <= 1; SDAIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add7;
end


Add7:
begin
	shiftIn <= 1; SDAIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= AddLSBACK;
end


AddLSBACK:
begin
	LoadAddLSB <= 1; EnSDAOut <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add8;
end

Add8:
begin
	SDAIn <= 1; shiftIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add9;
end

Add9:
begin
	SDAIn <= 1; shiftIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add10;
end

Add10:
begin
	SDAIn <= 1; shiftIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add11;
end

Add11:
begin
	SDAIn <= 1; shiftIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add12;
end

Add12:
begin
	SDAIn <= 1; shiftIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add13;
end

Add13:
begin
	SDAIn <= 1; shiftIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add14;
end

Add14:
begin
	SDAIn <= 1; shiftIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= Add15;
end

Add15:
begin
	SDAIn <= 1; shiftIn <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;		
	next_state <= AddMSBACK;
end

AddMSBACK:
begin
	LoadAddMSB <= 1; LoadShift <= 1; selStartAddr <= 1;selAddr <= 1;EnDataIn <= 1;EnSDAOut <= 1; WE_N <= 1; CE_N <= 0;
	OE_N 		<= 0;
	next_state 	<= D0;
end

D0:
begin
	shiftOut <= 1;SDAOut <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;
	next_state <= D1;
end

D1:
begin
	shiftOut <= 1;SDAOut <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;
	next_state <= D2;
end

D2:
begin
	shiftOut <= 1; sel5555 <= 1;selAA <= 1; EnDataOut <= 1; SDAOut <= 1; CE_N <= 0; WE_N <= 0; OE_N <= 1;
	next_state <= D3;
end

D3:
begin
	shiftOut <= 1; SDAOut <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;
	next_state <= D4;
end

D4:
begin
	shiftOut <= 1; sel55 <= 1;selAAAA <= 1; EnDataOut <= 1; SDAOut <= 1; CE_N <= 0; WE_N <= 0; OE_N <= 1;
	next_state <= D5;
end
	
D5:
begin
	shiftOut <= 1; SDAOut <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;
	next_state <= D6;
end

D6:
begin
	shiftOut <= 1; sel5555 <= 1;sel00 <= 1; EnDataOut <= 1; SDAOut <= 1; CE_N <= 0; WE_N <= 0; OE_N <= 1;
	next_state <= D7;
end

D7:
begin
	IncrAddr <= 1; SDAOut <= 1; CE_N <= 1; WE_N <= 1; OE_N <= 1;
	next_state <= MACK;
end

MACK:
begin

	LoadShift <= 1; selAddr <= 1; EnDataIn <= 1;
	if(SDA == 0) begin
		next_state <= D0;
		CE_N <= 0;
		WE_N <= 1;
		OE_N = 0;
	end
	if(SDA == 1) begin
		CE_N <= 1;
		WE_N <= 1;
		OE_N <= 1;
		next_state <= IDLE;
	end
end

endcase
end

if(write == 1) begin
case(current_state)

DevIDACK:
begin
	shiftIn		<=0;
	EnSDAOut 	<= 1;
	LoadDevID	<=1;
	sel5555 	<= 1;
	selAAAA 	<= 0;
	selAA 		<= 1;
	sel55 		<= 0;
	CE_N		<=0;
	WE_N 		<= 0;
	next_state 	<= Add0; 
end


Add0:
begin
	EnSDAOut 	<= 0;
	LoadDevID	<=0;
	sel5555 	<= 0;
	selAAAA 	<= 0;
	selAA 		<= 0;
	sel55 		<= 0;
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add1; 
end

Add1:
begin
	CE_N 		<= 0;
	WE_N 		<= 0;
	shiftIn 	<= 1;
	sel5555 	<= 0;
	selAAAA 	<= 1;
	selAA 		<= 0;
	sel55 		<= 1;
	next_state 	<= Add2; 
end

Add2:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	sel5555 	<= 0;
	selAAAA 	<= 0;
	selAA 		<= 0;
	sel55 		<= 0;
	shiftIn 	<= 1;
	next_state 	<= Add3; 
end

Add3:
begin
	CE_N 		<= 0;
	WE_N 		<= 0;
	sel5555 	<= 1;
	selAAAA 	<= 0;
	selAA 		<= 0;
	sel55 		<= 0;
	shiftIn 	<= 1;
	selB0 		<= 1;
	sel5555 	<= 1;
	next_state 	<= Add4; 
end

Add4:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add5; 
end

Add5:
begin
	CE_N 		<= 0;
	WE_N 		<= 0;
	shiftIn 	<= 1;
	selC0 		<= 1;
	next_state 	<= Add6; 
end

Add6:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add7; 
end

Add7:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= AddLSBACK; 
end


AddLSBACK:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn		<= 0;
	EnSDAOut 	<= 1;
	LoadAddLSB 	<= 1;
	next_state 	<= Add8; 
end

Add8:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add9; 
end


Add9:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add10; 
end


Add10:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add11; 
end


Add11:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add12; 
end


Add12:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add13; 
end


Add13:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add14; 
end


Add14:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= Add15; 
end


Add15:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= AddMSBACK; 
end


AddMSBACK:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 0;
	EnSDAOut	<= 1;
	LoadAddMSB 	<= 1;
	next_state 	<= D0F; 
end

D0F:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D1F; 
end

D1F:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D2F; 
end

D2F:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D3F; 
end

D3F:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D4F; 
end

D4F:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D5F; 
end


D5F:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D6F; 
end


D6F:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D7F; 
end

D7F:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= DataACK; 
end


DataACK:
begin
	EnSDAOut 	<= 1;
	selAddr 	<= 1;
	selData 	<= 1;
	EnDataOut 	<= 1;
	CE_N 		<= 0;
	WE_N 		<= 0;
	shiftIn 	<= 0;
	next_state 	<= D0; 
end




D0:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D1; 
end


D1:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D2; 
end



D2:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D3; 
end


D3:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D4; 
end


D4:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D5; 
end



D5:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D6; 
end


D6:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	next_state 	<= D7; 
end


D7:
begin
	CE_N 		<= 1;
	WE_N 		<= 1;
	shiftIn 	<= 1;
	IncrAddr 	<= 1;
	next_state 	<= DataACK; 
end

HOLD1:
begin
//	selD0 		<= 0;
	shiftIn 	<= 0;
	selAux		<= 1;
	CE_N 		<= 1;
	WE_N 		<= 1;
	next_state 	<= oxD0;
end


oxD0:
begin
	shiftIn 	<= 0;
	CE_N 		<= 0;
	WE_N 		<= 0;
	selD0 		<= 1;
	selAux 		<= 1;
	next_state 	<= HOLD2;
end

HOLD2:
begin
//	selD0 		<= 0;
	shiftIn 	<= 0;
	selAux		<= 1;
	CE_N 		<= 1;
	WE_N 		<= 1;
	next_state 	<= oxE0;
end

oxE0:
begin
	shiftIn 	<= 0;
	selE0 		<= 1;
	selAux 		<= 1;
	CE_N 		<= 0;
	WE_N 		<= 0;
	next_state 	<= IDLE;
end

endcase

end


//current_state <= next_state;

end

endmodule
