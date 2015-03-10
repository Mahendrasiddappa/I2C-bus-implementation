module DeviceIDW(LoadDevID,SCL,shiftRegOut,DeviceID);

input LoadDevID,SCL,shiftRegOut;
wire LoadDevID,SCL;
wire [7:0] shiftRegOut;

output reg [7:0] DeviceID;


always @(negedge SCL)
#1 begin
if(LoadDevID == 1)
DeviceID = shiftRegOut;
end
endmodule
