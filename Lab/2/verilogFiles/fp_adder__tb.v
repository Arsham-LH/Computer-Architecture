`timescale 1ns/1ns

module fp_adder__tb();

   integer i, j, result_err, bit_err;

   reg [31:0] a, b, c, d, data[0:40000];

   initial begin

      bit_err = 0;
      result_err = 0;

      $readmemh("fp.hex", data);

      if(data[0] === 'bx) begin
         $display("ERROR: fp.hex file is not read in properly");
         $display("Make sure this file is located in working directory");
         $stop;
      end

      for(i=0; i<10000; i=i+1) begin /*10000 number of tests*/

         a = data[i*4+0];
         b = data[i*4+1];
         c = data[i*4+2]; //adding output 
         d = data[i*4+3]; //subtracting output
         #10;

         /*$write("sign1 = %b \n",uut.sign1);
         $write("sign2 = %b \n",uut.sign2);

         $write("F1 = %b \n",uut.F1);
         $write("F2 = %b \n",uut.F2);


         $write("E1 = %b \n",uut.E1);
         $write("E2 = %b \n",uut.E2);

         $write("init_E1 = %b \n",uut.init_E1);
         $write("init_E2 = %b \n",uut.init_E2);

         $write("right_mantissa = %b \n",uut.right_mantissa);
         $write("left_mantissa = %b \n",uut.left_mantissa);

         $write("right_E = %b \n",uut.right_E);
         $write("left_E = %b \n",uut.left_E);

         $write("smallALU_output = %b \n",uut.smallALU_output);
         $write("smallALU_cout = %b \n",uut.smallALU_cout);

         $write("smallerNum_shift = %b \n",uut.smallerNum_shift);
         $write("shifted_left_mantissa = %b \n",uut.shifted_left_mantissa);

         $write("final_left_mantissa = %b \n",uut.final_left_mantissa);
         $write("final_right_mantissa = %b \n",uut.final_right_mantissa);

         $write("adder_output = %b \n",uut.adder_output);
         $write("output_sign = %b \n",uut.output_sign);

         $write("shifted_adder_mantissa = %b \n",uut.shifted_adder_mantissa);
         $write("leadingOne_ind = %b \n",uut.leadingOne_ind);

         $write("normal_shift = %b \n",uut.normal_shift);
         $write("normal_E = %b \n",uut.normal_E);

         $write("shiftCase_normal_mantissa = %b \n",uut.shiftCase_normal_mantissa);
         $write("normal_mantissa = %b \n",uut.normal_mantissa);*/



         if(uut.s !== c) begin
            result_err = result_err + 1;
            $write("TEST %0d:\tError: %b + %b, expected: %8b, but got: %8b\n",i , a, b, c, uut.s);
         end

         if(uus.s !== d) begin
            result_err = result_err + 1;
            $write("TEST %0d:\tError: %b - %b, expected: %8x, but got: %8x\n",i, a, b, d, uus.s);
         end

         for(j=0; j<32; j=j+1)
            if(c[j] !== uut.s[j])
               bit_err = bit_err + 1;

         for(j=0; j<32; j=j+1)
            if(d[j] !== uus.s[j])
               bit_err = bit_err + 1;

      end

      if(result_err) begin
         $write("\n\n\tTotal Errors in the Results: %4d\n", result_err);
         $write("\tTotal Bit Mismatches in the Results: %d\n", bit_err);
      end
      else
         $write("\n\n\tWaw!! NO ERROR Found. Great Job.\n\n");

   end

   fp_adder_hiddenPoint uut( .a(a), .b(b), .s());                 // a + b
   fp_adder_hiddenPoint uus( .a(a), .b(b ^ 32'h80000000), .s());  // a - b

endmodule
