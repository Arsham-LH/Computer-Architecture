`timescale 1ns/1ns
module adder_fp(input [31:0] a,
input [31:0] b,
output [31:0] s);


wire signA ;
wire [7:0] expA ;
wire [25:0] fractionA ;

wire signB ;
wire [7:0] expB ;
wire [25:0] fractionB ;


assign {signA,expA[7:0],fractionA[24:2]} = a ;
assign {signB,expB[7:0],fractionB[24:2]} = b ;

wire [7:0] exponentA ;
wire [7:0] exponentB ;

assign fractionA[25] = |expA ;
assign fractionB[25] = |expB ;
assign exponentA = (expA==0) ? 1 : expA ;
assign exponentB = (expB==0) ? 1 : expB ;
assign fractionA[1:0] = 2'b00 ;
assign fractionB[1:0] = 2'b00 ;

//part4
wire [26:0] fractionRight ;
wire [26:0] fractionLeft ;
wire [7:0] exponentC ;
wire br ;
wire signLeft ;
wire signRight ;
wire [7:0] shift ;
wire [7:0] FinalShift ;
assign {br,shift[7:0]} = {1'b0,exponentA[7:0]} + {1'b1,~exponentB[7:0]} + 8'b00000001 ;
assign exponentC[7:0] = !br ? exponentA[7:0] : exponentB[7:0] ;
assign FinalShift[7:0] = br ? ({1'b1,~exponentA[7:0]} + {1'b0,exponentB[7:0]} + 8'b00000001) : shift[7:0] ;
assign signLeft = !br ? signB : signA ;
assign fractionRight[26:1] = !br ? fractionA : fractionB ;
assign signRight = !br ? signA : signB ;

//part5
wire [51:0] Shifted ;
assign Shifted = {(!br ? fractionB[25:0] : fractionA[25:0]),26'b000000000000000000000000} >> FinalShift[7:0] ;
assign fractionLeft[26:0] = {Shifted[51:26],(Shifted[25:0]!=0)} ;
assign fractionRight[0] = 0 ;

//part6 & 7
wire [27:0] signfractionLeft ;
wire [27:0] signfractionRight ;
wire [28:0] fractionmid ;
assign signfractionLeft = signLeft ? (-fractionLeft) : {fractionLeft} ;
assign signfractionRight = signRight ? (-fractionRight) : {fractionRight} ;
assign fractionmid[28:0] = {signfractionLeft[27],signfractionLeft[27:0]} + {signfractionRight[27],signfractionRight[27:0]} ;
//part8
wire signC ;
wire [7:0] exponentC1 ;
wire [27:0] fractionC ; 
wire [27:0] fractionC1 ;
assign signC = fractionmid[28] ;
assign fractionC = signC ? (-fractionmid[27:0]) : (fractionmid[27:0]) ;

//part 9&10
wire [4:0]shiftC ;
wire [4:0]shiftCOne ;
assign shiftC = fractionC[27] ? 0:
                fractionC[26] ? 1:
                fractionC[25] ? 2:
                fractionC[24] ? 3:
                fractionC[23] ? 4:
                fractionC[22] ? 5:
                fractionC[21] ? 6:
                fractionC[20] ? 7:
                fractionC[19] ? 8:
                fractionC[18] ? 9:
                fractionC[17] ? 10:
                fractionC[16] ? 11:
                fractionC[15] ? 12:
                fractionC[14] ? 13:
                fractionC[13] ? 14:
                fractionC[12] ? 15:
                fractionC[11] ? 16:
                fractionC[10] ? 17:
                fractionC[9] ?  18:
                fractionC[8] ?  19:
                fractionC[7] ?  20:
                fractionC[6] ?  21:
                fractionC[5] ?  22:
                fractionC[4] ?  23:
                fractionC[3] ?  24:
                fractionC[2] ?  25:
                fractionC[1] ?  26: 27 ;
wire [7:0] exponentC2 ;
assign exponentC1[7:0] = exponentC[7:0] + 1 ;
assign shiftCOne = (exponentC1>shiftC) ? shiftC : (exponentC1 - 1) ;
assign exponentC2[7:0] = exponentC1[7:0] - shiftCOne[4:0]  ;
assign fractionC1 = fractionC << shiftCOne[4:0] ;

//part11
wire [28:0] fractionC2 ;
wire [7:0] exponentC3 ;
assign fractionC2 = fractionC1[3] ? (|fractionC1[2:0] ? (fractionC1[27:0]+16) : (fractionC1[4] ? (fractionC1[27:0]+16) : (fractionC1[27:0]))) : {1'b0,fractionC1[27:0]} ;
assign exponentC3 = fractionC2[28] ? (exponentC2+1) : exponentC2 ;
//part12+
wire [27:0] fractionC3 ;
wire [7:0] exponentC4 ;
assign fractionC3 = fractionC2[28] ? fractionC2[28:1] : fractionC2[27:0] ;
assign exponentC4 = fractionC3[27] ? exponentC3 : 0 ;
//end
assign s = {signC,exponentC4,fractionC3[26:4]} ;
endmodule 