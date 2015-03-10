

module ShiftReg(SCL,SDA,OE_N,shiftIn,shiftOut,reset,START,STOP,LoadShift,LoadRW,LoadDevID,LoadAddLSB,LoadAddMSB,shiftRegOut,shiftRegIn,write,read,SDAOut);


input SCL,reset,shiftIn,LoadDevID,LoadRW,LoadShift,LoadAddLSB,LoadAddMSB,shiftOut,START,STOP,OE_N;
//input SCL,SDA,reset;
input [7:0] shiftRegIn;
inout SDA;

output reg SDAOut;

output reg [7:0] shiftRegOut;
output reg write,read;

reg [2:0] count;
reg [7:0] shiftReg;




initial count = 3'b0;


//assign SDA = (shiftOut == 1)?shiftRegIn[count]:0;

always @(posedge START)
 shiftRegOut = 8'b0;


always @(negedge SCL)
begin
//for(i=0;i<DELAY;)i = i + 1;
if(reset == 1)
	begin
	count = 3'b0;
	shiftRegOut = 7'b0;
	//shiftRegIn = 7'b0;
	end
else if(shiftIn == 1)
	begin
	shiftRegOut[count] = SDA;
	count = count + 1;	
	end
else if(shiftOut == 1)
	begin
	SDAOut = shiftRegIn[count];
	count = count + 1;	
	end
if(LoadShift == 1)
begin
	count = 3'b0;
	shiftReg = shiftRegIn;

end


if(LoadRW == 1)
begin
	if(SDA == 1) begin write = 1; read = 0; end
	if(SDA == 0) begin write = 0; read = 1; end

end	
end

always @(posedge OE_N)
begin
	count = 3'b0;
	shiftReg = shiftRegIn;

end


endmodule
