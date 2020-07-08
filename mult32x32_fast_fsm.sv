// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msb_is_0,       // Indicates MSB of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

// Put your code here
// Declaring the FSM states
	typedef enum { A, B, C, D, E, F, G, H, I } sm_type;
	
	// Declaring signals for the next and current states
	sm_type current_state;
	sm_type next_state;
	
	// FSM synchoronous procedural block
	always_ff @(posedge clk, posedge reset) begin
		if(reset == 1'b1) begin
			current_state <= A;
		end
		else begin
			current_state <= next_state;
		end
	end
	
	always_comb begin
		// define defaults
		next_state = current_state;
		busy = 1'b1;
		upd_prod = 1'b1;
		clr_prod = 1'b0;
		case (current_state)
			A: begin
				if(start == 0) begin
					next_state = A;
					busy = 1'b0;
					a_sel = 2'd0; // dont care
					b_sel = 0; // dont care
					shift_sel = 3'd0; // dont care
					upd_prod = 1'b0;
					clr_prod = 1'b0;
				end
				else begin
					next_state = B;
					busy = 1'b0;
					a_sel = 2'd0; // dont care
					b_sel = 0; // dont care
					shift_sel = 3'd0; // dont care
					upd_prod = 1'b0;
					clr_prod = 1'b1;
				end
			end
			B: begin
				next_state = C;
				a_sel = 2'd0; 
				b_sel = 0; 
				shift_sel = 3'd0;
			end
			C: begin
				next_state = D;
				a_sel = 2'd1; 
				b_sel = 0; 
				shift_sel = 3'd1;
			end
			D: begin
				if(a_msb_is_0 == 0 && b_msw_is_0 == 0) next_state = E;
				if(a_msb_is_0 == 0 && b_msw_is_0 == 1) next_state = E;
				if(a_msb_is_0 == 1 && b_msw_is_0 == 0) next_state = F;
				if(a_msb_is_0 == 1 && b_msw_is_0 == 1) next_state = A;
				a_sel = 2'd2; 
				b_sel = 0; 
				shift_sel = 3'd2;
			end
			E: begin
				if(a_msb_is_0 == 0 && b_msw_is_0 == 0) next_state = F;
				if(a_msb_is_0 == 0 && b_msw_is_0 == 1) next_state = A;
				if(a_msb_is_0 == 1 && b_msw_is_0 == 0) next_state = F;
				a_sel = 2'd3; 
				b_sel = 0; 
				shift_sel = 3'd3;
			end
			F: begin
				next_state = G;
				a_sel = 2'd0; 
				b_sel = 1; 
				shift_sel = 3'd2;
			end
			G: begin
				next_state = H;
				a_sel = 2'd1; 
				b_sel = 1; 
				shift_sel = 3'd3;
			end
			H: begin
				if(a_msb_is_0 == 0 && b_msw_is_0 == 0) next_state = I;
				if(a_msb_is_0 == 1 && b_msw_is_0 == 0) next_state = A;
				a_sel = 2'd2; 
				b_sel = 1; 
				shift_sel = 3'd4;
			end
			I: begin
				next_state = A;
				a_sel = 2'd3; 
				b_sel = 1; 
				shift_sel = 3'd5;
			end
		endcase
	end


// End of your code

endmodule
