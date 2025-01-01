`timescale 1ns/1ps
module test_bench;
	parameter N = 32;

	reg [N - 1: 0] a;
	reg [N - 1: 0] b;
	reg [3:0] ctrl;

	wire [N - 1: 0] result;
	wire zero;
	wire negative;
	wire overflow;
	wire carry;

	alu #(N) dut(
		.a(a),
		.b(b),
		.ctrl(ctrl),
		.result(result),
		.zero(zero),	
		.negative(negative),
		.overflow(overflow),
		.carry(carry)
	);

	task verify;
		input [N - 1 : 0] exp_result;
		input exp_zero, exp_negative, exp_overflow, exp_carry;
		begin
			#5;
			$display("At time: %t, a = %b, b = %b, ctrl = 4'b%b", $time, a, b, ctrl);
			if (result !== exp_result || zero !== exp_zero || negative !== exp_negative || overflow !== exp_overflow || carry !== exp_carry) begin
				$display("-------------------------------------------------------------------------------------------------------------------------------------");
				$display("-------------------------------------------RUN TESTBENCH AT TESTCASE: FAILED---------------------------------------------------------");
				$display("Expedted: exp_result: %b, exp_zero: %b, exp_negative: %b, exp_overflow: %b, exp_carry:%b", exp_result, exp_zero, exp_negative, exp_overflow, exp_carry);
				$display("Got: result: %b, zero = %b, negative: %b, overflow: %b, carry: %b", result, zero, negative, overflow, carry);
				$display("-------------------------------------------------------------------------------------------------------------------------------------");
			end else begin
				$display("-------------------------------------------------------------------------------------------------------------------------------------");
				$display("------------------------------------------RUN TESTBENCH AT TESTCASE: PASSED----------------------------------------------------------");
				$display("Expected: exp_result: %b, exp_zero: %b, exp_negative: %b, exp_overflow: %b, exp_carry: %b", exp_result, exp_zero, exp_negative, exp_overflow, exp_carry);
				$display("Got: result: %b, zero: %b, negative: %b, overflow: %b, carry: %b", result, zero, negative, overflow, carry);
				$display("-------------------------------------------------------------------------------------------------------------------------------------");
			end
		end
	endtask

	initial begin
		$dumpfile("test_bench.vcd");
		$dumpvars(0, test_bench);

		$display("-------------------------------------------------------------------------------------------------------------------------------------");
		$display("----------------------------------------------- TESTBENCH FOR ALU N BIT--------------------------------------------------------------");
		$display("-------------------------------------------------------------------------------------------------------------------------------------");
		
		// Test case 1: add operation
		ctrl = 4'b0000;
		a = 32'h00000010;
		b = 32'h00000020;
		#20;
		verify(32'h00000030, 0, 0, 0, 0);

		// Test case 2: Add operation
		ctrl = 4'b0000;
		a = 32'h80000000;
		b = 32'h80000000;
		#20;
		verify(32'h00000000,1, 0, 1, 1);

		// Test case 3: Subtract operation
		ctrl = 4'b0001;
		a = 32'h00000030;
		b = 32'h00000010;
		#20;
		verify(32'h00000020, 0, 0, 0, 0);

		// Test case 4: Subtract operation
		ctrl = 4'b0001;
		a = 32'h80000000;
		b = 32'h7fffffff;
		#20;
		verify(32'h00000001, 0, 1, 1, 0);

		// Test case 5: And operation
		ctrl = 4'b0010;
		a = 32'haaaaaaaa;
		b = 32'h55555555;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);
		
		// Test case 6: And operation
		ctrl = 4'b0010;
		a = 32'hf0dae34f;
		b = 32'h7dafacbc;
		#20;
		verify(32'h708aa00c, 0, 0, 0, 0);

		// Test case 7: OR operation
		ctrl = 4'b0011;
		a = 32'haaaaaaaa;
		b = 32'h55555555;
		#20;
		verify(32'hffffffff, 0, 1, 0, 0);

		// Test case 8: OR operation
		ctrl = 4'b0011;
		a = 32'hcccccccc;
		b = 32'h00000001;
		#20;
		verify(32'hcccccccd, 0, 1, 0, 0);

		// Test case 9: XOR operation
		ctrl = 4'b0100;
		a = 32'haaaaaaaa;
		b = 32'h55555555;
		#20;
		verify(32'hffffffff, 0, 1, 0, 0);

		// Test case 10: XOR operation
		ctrl = 4'b0100;
		a = 32'h10101010;
		b = 32'h10101010;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);

		// Test case 11: NOT operation
		ctrl = 4'b0101;
		a = 32'hffffffff;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);
		
		// Test case 12: SHILF LEFT operation
		ctrl = 4'b0110;
		a = 32'h12345678;
		b = 32'h00000008;
		#20;
		verify(32'h34567800, 0, 0, 0, 0);

		// Test case 13: SHIFT LEFT operation
		ctrl = 4'b0110;
		a = 32'habcdef45;
		b = 32'h15789004;
		#20;
		verify(32'hbcdef450, 0, 1, 0, 0);

		// Test case 14: SHIFT RIGHT operation
		ctrl = 4'b0111;
		a = 32'h15975312;
		b = 32'habefd044;
		#20;
		verify(32'h01597531, 0, 0, 0, 0);

		// Test case 15: SHIFT  RIGHT operation
		ctrl = 4'b0111;
		a = 32'hbadefc45;
		b = 32'h14895608;
		#20;
		verify(32'h00badefc, 0, 0, 0, 0);

		//Test case 16: ARITHMETIC SHIFT RIGHT operation
		ctrl = 4'b1000;
		a = 32'h8fffffff;
		b = 32'h12345674;
		#20;
		verify(32'hf8ffffff, 0, 1, 0, 0);

		// Test case 17: ARITHMETIC SHHIFT RIGHT operation
		ctrl = 4'b1000;
		a = 32'h7abcdeff;
		b = 32'h15236808;
		#20;
		verify(32'h007abcde, 0, 0, 0, 0);

		// Test case 18: EQUALY operation
		ctrl = 4'b1001;
		a = 32'h23456789;
		b = 32'h12345678;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);

		//Test case 19: EQUALY operation
		ctrl = 4'b1001;
		a = 32'habcdefaa;
		b = 32'habcdefaa;
		#20;
		verify(32'hffffffff, 0, 1, 0, 0);
		
		// Test case 20: LESS THAN operation
		ctrl = 4'b1010;
		a = 32'h7fffffff;
		b = 32'h8fffffff;
		#20;
		verify(32'hffffffff, 0, 1, 0, 0);
		
		// Test case 21: LESS THAN operation 
		ctrl = 4'b1010;
		a = 32'h3fffffff;
		b = 32'h0fffffff;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);	

		// Test case 22: GREATER THAN operation
		ctrl = 4'b1011;
		a = 32'h40021057;
		b = 32'h3fd4789d;
		#20;
		verify(32'hffffffff, 0, 1, 0, 0);

		// Test case 23: GREATER THAN operation
		ctrl = 4'b1011;
		a = 32'h7fffffff;
		b = 32'h8fffffff;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);

		// Test case 24: Multiplication
		ctrl = 4'b1100;
		a = 32'h00001234;
		b = 32'h0000abcd;
		#20;
		verify(32'h0c374fa4, 0, 0, 0 ,0);

		// Test case 25: Multiplication
		ctrl = 4'b1100;
		a = 32'hff001478;
		b = 32'h12340ef7;
		#20;
		verify(32'h01324fc8, 0, 0, 0 ,0);

		// Test case 26: Division
		ctrl = 4'b1101;
		a = 32'habcdef85;
		b = 32'h12345678;
		#20;
		verify(32'h00000009, 0, 0, 0, 0);

		// test case 27: Division
		ctrl = 4'b1101;
		a = 32'h14253679;
		b = 32'h00000000;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);

		// Test case 28: Modulus
		ctrl = 4'b1110;
		a = 32'h14725836;
		b = 32'h00abfecd;
		#20;
		verify(32'h004a7c30, 0, 0, 0, 0);

		// Test case 29: Modulus
		ctrl = 4'b1110;
		a = 32'h15768943;
		b = 32'h00000000;;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);

		// Default case
		ctrl = 4'b1111;
		a = 32'ha5b782ff;
		b = 32'h10000000;
		#20;
		verify(32'h00000000, 1, 0, 0, 0);

		#100;
		$finish;
	end
endmodule
