`timescale 1ns/1ns
module multiplier4
#(
//-----------------------parameter declaration
    parameter nb=8
)

(
//-----------------------Port directions and deceleration
   input clk,  
   input start,
   input [nb-1:0] A, 
   input [nb-1:0] B, 
   output reg signed [2*nb-1:0] Product,
   output ready
    );

//------------------------------------------------------


//----------------------------------- register deceleration
reg [nb-1:0] Multiplicand ;
reg [nb-1:0]  counter;
//-------------------------------------------------------

//------------------------------------- wire deceleration
wire product_write_enable;
wire [nb-1:0] adder_output;
wire adder_cout;
//---------------------------------------------------------


//-------------------------------------- combinational logic
assign product_write_enable = Product[0];
assign ready = (counter==nb);

/*if counter==7, the last clock is in progress, thus if Bi==1, we must complement A, and then add to Product (if Bi==0, this result is not written)*/
assign {adder_cout,adder_output} = {Product[2*nb-1],Product[2*nb-1:nb]} + (counter==nb-1 ? (~{Multiplicand[nb-1],Multiplicand}+1) : {Multiplicand[nb-1],Multiplicand});  //one bit extension in MSB, for preventing overflow
//---------------------------------------------------------

//--------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= (nb)'('b0);
      Product <= {{nb{1'b0}},B};
      Multiplicand <= A ;
   end

   else if(! ready) begin
         counter <= counter + 1;
        if(product_write_enable) begin
            Product[nb-1:0] <= Product[nb-1:0]>>1;
            Product[2*nb-1:nb-1] <= {adder_cout,adder_output};
         end
         else begin
            Product <= Product>>1;
            Product[2*nb-1] <= Product[2*nb-1]; //Sign extension
         end

   end   

endmodule
