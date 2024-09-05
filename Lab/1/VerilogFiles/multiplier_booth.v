`timescale 1ns/1ns
module multiplier_booth
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
reg prev_b;
//-------------------------------------------------------

//------------------------------------- wire deceleration
wire [2:0] product_write_status;
wire [nb-1:0] adder_output;
wire adder_cout;
//---------------------------------------------------------


//-------------------------------------- combinational logic
assign product_write_status = {Product[1:0],prev_b}; //contains b{2i+1},b{2i},b{2i-1}
assign ready = (counter==nb);

assign {adder_cout,adder_output} = ((product_write_status==3'd3 || product_write_status==3'd4)?
{{2{Product[2*nb-1]}},Product[2*nb-1:nb+1]}: {Product[2*nb-1],Product[2*nb-1:nb]}) + 
((product_write_status==3'd1 || product_write_status==3'd2 || product_write_status==3'd3) ? {Multiplicand[nb-1],Multiplicand}: 
(product_write_status==3'd4 || product_write_status==3'd5 || product_write_status==3'd6)? (~{Multiplicand[nb-1],Multiplicand}+1): (nb)'('b0));  //one bit extension in MSB, for preventing overflow
//---------------------------------------------------------

//--------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= (nb)'('b0);
      Product <= {{nb{1'b0}},B};
      Multiplicand <= A ;
      prev_b <= 1'b0;
   end

   else if(! ready) begin
         counter <= counter + 2'b10;
         prev_b <= Product[1];

         case(product_write_status)
            3'b000, 3'b111: Product <= Product>>>2; //PPi=0
            3'b001, 3'b010, 3'b101, 3'b110: begin
                Product <= Product>>2;
                Product[2*nb-2:nb-2] <= {adder_cout,adder_output};
                Product[2*nb-1] <= adder_cout; //one bit extension
            end
            3'b011, 3'b100: begin
                Product <= Product>>2;
                Product[2*nb-1:nb-1] <= {adder_cout,adder_output};
            end
         endcase
   end   

endmodule

