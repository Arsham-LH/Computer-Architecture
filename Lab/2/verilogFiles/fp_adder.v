`timescale 1ns/1ns
module fp_adder
(
//-----------------------Port directions and deceleration
   input [31:0] a, 
   input [31:0] b, 
   output [31:0] s
    );

//------------------------------------------------------


//------------------------------------- wire deceleration
wire sign1;
wire sign2;

wire [7:0] E1;
wire [7:0] E2;

wire [-1:-23] F1;
wire [-1:-23] F2;


wire [7:0] init_E1;
wire [7:0] init_E2;

//Does ** retain zeros before '.' ?
wire [0:-25] init_mantissa1; //including guard & round
wire [0:-25] init_mantissa2; //including guard & round

wire [7:0] smallALU_output;
wire smallALU_cout;

wire right_sign;
wire left_sign;

wire [0:-25] right_mantissa; //bigger number
wire [0:-51] left_mantissa; //smaller number. 26 bits reserved for creating s(or) bit

wire [7:0] right_E; //Final E for adder output
wire [7:0] left_E;


wire [7:0] smallerNum_shift; //shift amount for smaller number's mantissa


// A SEPERATE WIRE FOR FINDING THE POSITION OF POINT ??? IF NEEDED LATER
wire [0:-51] shifted_left_mantissa; //shifted mantissa for the left number. Must be added to right_mantissa. 26 bits rserved for creating s(or) bit

// A BETTER WAY TO HANDLE "(smallerNum_shift>5'd26)?" , PROBABLY USING A SEPERATE SUBTRACTER
//wire left_s= !smallerNum_shift? 1'b0 : (smallerNum_shift>5'd26)? (|left_mantissa): (|left_mantissa[smallerNum_shift-1:0]);  //computing s(or) for smaller number (if shift>26, s equals or on whole digits)
wire left_s;  //computing s(or) for smaller number
wire right_s;


//converting to 2cns
wire [2:-26] final_left_mantissa; //complement if the sign is 1
wire [2:-26] final_right_mantissa; //complement if the sign is 1

wire [2:-26] adder_output;
wire output_sign; //sign of output

wire [0:-27] shifted_adder_mantissa; //shifting the '.',one bit to the left (Now we have 1 bit before, and 27 bit after the point). Also shifting the '.',one bit to the left (Now we have 1 bit before, and 27 bit after the point)


wire [4:0] leadingOne_ind; //index of leading one bit in shifted_adder_mantissa, from 0 to 27 (28 for the case that none of thebits are 1, thus the final result is zero!)

wire [4:0] normal_shift; //number of left shift to normalize the mantissa
wire [7:0] normal_E; //output E, after normalization


//normal_mantissa will contain 2 bits before, and 26 bits after '.' (23 bits for F, plus guard, round, s(or) bits)
wire [0:-27] shiftCase_normal_mantissa; //normal_mantissa in cases that the mantissa must be shifted to the left
wire [1:-27] normal_mantissa;

//rounding the number
wire [1:-23] rounded_mantissa;
wire [0:-23] final_mantissa;
wire [7:0] final_E;

//---------------------------------------------------------





//-------------------------------------- combinational logic
assign sign1=a[31];
assign sign2=b[31];

assign E1=a[30:23];
assign E2=b[30:23];

assign F1=a[22:0];
assign F2=b[22:0];


assign init_E1= (!E1? 8'h01:E1);
assign init_E2= (!E2? 8'h01:E2);

assign init_mantissa1= (!E1? {1'b0,F1,2'b00}: {1'b1,F1,2'b00}); //including guard & round
assign init_mantissa2= (!E2? {1'b0,F2,2'b00}: {1'b1,F2,2'b00}); //including guard & round

assign {smallALU_cout,smallALU_output} = init_E1 + (~init_E2+1); //computes init_E1-init_E2, with cout=0 showing underflow

assign right_mantissa= !smallALU_cout? init_mantissa1: init_mantissa2; //bigger number
assign left_mantissa= !smallALU_cout? {init_mantissa2, 26'd0}: {init_mantissa1, 26'd0}; //smaller number. 26 bits reserved for creating s(or) bit

assign right_E= !smallALU_cout? init_E1: init_E2; //Final E for adder output
assign left_E= !smallALU_cout? init_E2: init_E1;

assign right_sign= !smallALU_cout? sign1: sign2; //Final sign for adder output
assign left_sign = !smallALU_cout? sign2: sign1;

assign smallerNum_shift = !smallALU_cout? smallALU_output: (~smallALU_output+1); //shift amount for smaller number's mantissa


assign shifted_left_mantissa = !smallerNum_shift? left_mantissa: (left_mantissa >> smallerNum_shift); //shifted mantissa for the left number. Must be added to right_mantissa. 26 bits rserved for creating s(or) bit

// A BETTER WAY TO HANDLE "(smallerNum_shift>5'd26)?" , PROBABLY USING A SEPERATE SUBTRACTER
assign left_s= |shifted_left_mantissa[-26:-51];  //computing s(or) for smaller number
assign right_s= 1'b0;


//converting to 2cns
assign final_left_mantissa= left_sign? ~{2'b00, shifted_left_mantissa[0:-25], left_s}+1 : {2'b00, shifted_left_mantissa[0:-25], left_s}; //complement if the sign is 1
assign final_right_mantissa= right_sign? ~{2'b00, right_mantissa, right_s}+1 : {2'b00, right_mantissa, right_s}; //complement if the sign is 1

assign adder_output= final_right_mantissa+final_left_mantissa;
assign output_sign= adder_output[2]; //sign of output


assign shifted_adder_mantissa = output_sign? (~adder_output[1:-26]+1): adder_output[1:-26]; //converting adder_output from 2cns to signed number (extracting mantissa), and removing sign bit. Also shifting the '.',one bit to the left (Now we have 1 bit before, and 27 bit after the point)
assign leadingOne_ind= shifted_adder_mantissa[0] ? 0 :
                       shifted_adder_mantissa[-1] ? -1 :
                       shifted_adder_mantissa[-2] ? -2 :
                       shifted_adder_mantissa[-3] ? -3 :
                       shifted_adder_mantissa[-4] ? -4 :
                       shifted_adder_mantissa[-5] ? -5 :
                       shifted_adder_mantissa[-6] ? -6 :
                       shifted_adder_mantissa[-7] ? -7 :
                       shifted_adder_mantissa[-8] ? -8 :
                       shifted_adder_mantissa[-9] ? -9 :
                       shifted_adder_mantissa[-10] ? -10 :
                       shifted_adder_mantissa[-11] ? -11 :
                       shifted_adder_mantissa[-12] ? -12 :
                       shifted_adder_mantissa[-13] ? -13 :
                       shifted_adder_mantissa[-14] ? -14 :
                       shifted_adder_mantissa[-15] ? -15 :
                       shifted_adder_mantissa[-16] ? -16 :
                       shifted_adder_mantissa[-17] ? -17 :
                       shifted_adder_mantissa[-18] ? -18 :
                       shifted_adder_mantissa[-19] ? -19 :
                       shifted_adder_mantissa[-20] ? -20 :
                       shifted_adder_mantissa[-21] ? -21 :
                       shifted_adder_mantissa[-22] ? -22 :
                       shifted_adder_mantissa[-23] ? -23 :
                       shifted_adder_mantissa[-24] ? -24 :
                       shifted_adder_mantissa[-25] ? -25 :
                       shifted_adder_mantissa[-26] ? -26 :
                       shifted_adder_mantissa[-27] ? -27 : 1;

assign normal_shift=/*(leadingOne_ind===5'd1)? 5'd1 :*/ 5'd0-leadingOne_ind; //number of left shift to normalize the mantissa
assign normal_E= (leadingOne_ind===5'd1 || normal_shift > right_E)? 8'h00 : (right_E+1 + (~normal_shift+1)); //output E, after normalization


//normal_mantissa will contain 2 bits before, and 26 bits after '.' (23 bits for F, plus guard, round, s(or) bits)
assign shiftCase_normal_mantissa = (normal_shift > right_E)? (shifted_adder_mantissa << right_E) : (shifted_adder_mantissa << normal_shift); //normal_mantissa in cases that the mantissa must be shifted to the left
assign normal_mantissa= (leadingOne_ind===5'd1)? 28'd0 :                                   //27'd0: 27 is because of extending another bit before the point, so we'd have 2 bits before and 26 bits after the point
                             (normal_shift===5'd0) ? shifted_adder_mantissa[0:-27] :            //if shift amount==0, it means we must shift the main mantissa, one bit right. Thus, the LSB will be removed
                             {shiftCase_normal_mantissa[0:-26],1'b0};      //DOUBT ON THIS: [1:-25] is because of extending another bit before the point, so we'd have 2 bits before and 26 bits after the point (We won't lose any important bit here, as the [0] bit becomes 0 after the shift!)

//rounding the number
assign rounded_mantissa= (!normal_mantissa[-24]) ? normal_mantissa[1:-23] : //checking the guard bit           
                              (normal_mantissa[-25]) ? normal_mantissa[1:-23] + 1 : //checking the round bit
                              (normal_mantissa[-26]) ? normal_mantissa[1:-23] + 1 : //checking the s(or) bit
                              (normal_shift===5'd0 && normal_mantissa[-27]) ? normal_mantissa[1:-23] + 1 : //checking the bit after s(or), for the case of normal_shift=0
                              (normal_mantissa[-23]) ? normal_mantissa[1:-23] + 1 : normal_mantissa[1:-23]; //rounding to 0 (the even bit)

assign final_mantissa= rounded_mantissa[1] ? (rounded_mantissa >> 1) : rounded_mantissa[0:-23];
assign final_E= rounded_mantissa[1] ? normal_E+1 : normal_E;

assign s={output_sign, final_E, final_mantissa[-1:-23]};

//---------------------------------------------------------






endmodule