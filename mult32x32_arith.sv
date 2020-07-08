// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
	logic [7:0] a_Out = 8'd0; 
	logic [15:0] b_Out = 15'd0; 
	logic [23:0] MultOut = 24'd0; 
	logic [63:0] muxShiftOut = 64'd0; 
	logic [63:0] adderOut = 64'd0;
	
	// a mux
	always_comb begin
		case (a_sel)
			2'd0: a_Out = a[7:0];
			2'd1: a_Out = a[15:8];
			2'd2: a_Out = a[23:16];
			2'd3: a_Out = a[31:24];
			default: a_Out =  8'd0;
		endcase
	end
	
	// b mux
	always_comb begin
		case (b_sel)
			2'd0: b_Out = b[15:0];
			2'd1: b_Out = b[31:16];
			default: b_Out = 15'd0;
		endcase
	end
	
	// 16x8 multiplication
	always_comb begin
		MultOut = b_Out * a_Out;
	end
	
	// shift mux
	always_comb begin
		case (shift_sel)
			3'd0: muxShiftOut = MultOut;
			3'd1: muxShiftOut = MultOut << 8;
			3'd2: muxShiftOut = MultOut << 16;
			3'd3: muxShiftOut = MultOut << 24;
			3'd4: muxShiftOut = MultOut << 32;
			3'd5: muxShiftOut = MultOut << 40;
			default: muxShiftOut = 64'd0;
		endcase
	end
	
	// 64-bit adder
	always_comb begin
		adderOut = muxShiftOut + product;
	end
	
	// product register
	always_ff @(posedge clk, posedge reset) begin
		if (reset == 1) begin
			product = 64'd0;
		end
		else begin
			if (clr_prod == 1) begin
				product = 64'd0;
			end
			else if (upd_prod == 1) begin
				product = adderOut;
			end
		end
	end		
	
// End of your code

endmodule
