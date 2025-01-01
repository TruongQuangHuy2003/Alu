module alu #(parameter N = 32) (
	input wire [N - 1: 0] a,
	input wire [N - 1: 0] b,
	input wire [3:0] ctrl,
	output reg [N - 1: 0] result,
	output reg zero,
	output reg negative,
	output reg overflow,
	output reg carry
);

reg [N : 0] temp;

initial begin
	if (N < 4 | N > 32) begin
		$display("-----------------------------------------------------------------------------------------------------------");
		$display("-------------------------------------------N OUT OF RANGE 3 < N < 32---------------------------------------");
		$display("-----------------------------------------------------------------------------------------------------------");
	end
end

always @(*) begin
	zero = 1'b0;
	negative = 1'b0;
	overflow = 1'b0;
	carry = 1'b0;
	result = {N{1'b0}};

	case(ctrl)
		4'b0000: begin
			temp = {1'b0, a} + {1'b0, b};
			result = temp[N - 1: 0];
			carry = temp[N];
			overflow = ((~a[N - 1] & ~b[N - 1] & result[N - 1]) | (a[N - 1] & b[N - 1] & ~result[N - 1]));
		end
		4'b0001: begin
			temp =  a + {~b + 1'b1};
			result = temp[N - 1: 0];
			carry = ~temp[N];
			overflow = ((a[N - 1] & ~b[N - 1] & ~result[N - 1]) | (~a[N - 1] & b[N - 1] & result[N - 1]));
		end
		4'b0010: begin
			result = a & b;
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b0011: begin
			result = a | b;
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b0100: begin
			result = a ^ b;
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b0101: begin
			result = ~a;
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b0110: begin
			result = a << b[3:0];
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b0111: begin
			result = a >> b[3 : 0];
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b1000: begin
			result = $signed(a) >>> b[3 : 0];
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b1001: begin
			result = (a == b) ? {N{1'b1}} : {N{1'b0}};
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b1010: begin
			result = (a < b) ? {N{1'b1}} : {N{1'b0}};
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b1011: begin
			result = (a > b) ? {N{1'b1}} : {N{1'b0}};
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b1100: begin
			result = a[N/2 : 0] * b[N/2 : 0];
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b1101: begin
			result = (b != 0) ? a/b : {N{1'b0}};
			carry = 1'b0;
			overflow = 1'b0;
		end
		4'b1110: begin
			result = (b != 0) ? a%b : {N{1'b0}};
			carry = 1'b0;
			overflow = 1'b0;
		end
		default: begin
			result = {N{1'b0}};
			carry = 1'b0;
			overflow = 1'b0;
		end
	endcase
	zero = (result == {N{1'b0}}) ? 1'b1 : 1'b0;
	negative = (ctrl == 4'b0001) ? (a[N - 1] ^ b[N - 1] ? ~result[N - 1] : result[N - 1]) : result[N - 1];
end
endmodule
