`timescale 1ns/1ns
module multiplier1(

   input clk,  
   input start,
   input [31:0] A, 
   input [31:0] B, 
   output reg [63:0] Product,
   output ready
    );
reg [63:0] Multiplicand ;
reg [31:0]  Multiplier;
reg [8:0]  counter;
wire product_write_enable;
wire [63:0] adder_output;
//---------------------------------------------------------

//-------------------------------------- combinational logic
assign adder_output = Product + Multiplicand;
assign product_write_enable = Multiplier[0];
assign ready = counter[8];
//---------------------------------------------------------

//--------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= 8'h0 ;
      Product <= B;
      Product <= 64'h00;
      Multiplicand <= {32'h00, A} ;
   end

   else if(! ready) begin
         counter <= counter + 1;
         Multiplier <= Multiplier >> 1;
         Multiplicand <= Multiplicand << 1;
       	 
        
      if(product_write_enable) begin
         Product <= adder_output;
         end

   end   

endmodule
