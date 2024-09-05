`timescale 1ns/1ns
module multiplier3(
//-----------------------Port directions and deceleration
   input clk,  
   input start,
   input [7:0] A, 
   input [7:0] B, 
   output reg signed [15:0] Product,
   output ready
    );



//------------------------------------------------------

//----------------------------------- register deceleration
reg [7:0] Multiplicand ;
reg [3:0]  counter;
//-------------------------------------------------------

//------------------------------------- wire deceleration
wire product_write_enable;
wire [7:0] adder_output;
wire adder_cout;
//---------------------------------------------------------

//-------------------------------------- combinational logic
assign product_write_enable = Product[0];
assign ready = counter[3];

/*if counter==7, the last clock is in progress, thus if Bi==1, we must complement A, and then add to Product (if Bi==0, this result is not written)*/
assign {adder_cout,adder_output} = {Product[15],Product[15:8]} + (&counter[2:0] ? (~{Multiplicand[7],Multiplicand}+1) : {Multiplicand[7],Multiplicand});  //one bit extension in MSB, for preventing overflow
//---------------------------------------------------------

//--------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= 4'h0 ;
      Product <= {8'h00,B};
      Multiplicand <= A ;
   end

   else if(! ready) begin
         counter <= counter + 1;
        if(product_write_enable) begin
            Product[7:0] <= Product[7:0]>>1;
            Product[15:7] <= {adder_cout,adder_output};
         end
         else begin
            Product <= Product>>1;
            Product[15] <= Product[15]; //Sign extension
         end

   end   

endmodule
