module div_by_3_detector (clk, rst, num, state, isdiv_by_3);

// The number of bits in the input
parameter N = 8;
// The state encodings
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

// The input control signals
input clk, rst;
// The input data signal
input [0:N-1] num;

// The output signal that when asserted implies that the
// input number is divisible by 3
output wire isdiv_by_3;
// The state of the FSM
output reg [1:0] state; 

// An internal counter value that counts the number of
// clock cycles passed
reg [3:0] count;

// An internal control signal that keeps track whether
// all the bits of the input has been processed
wire done;

// The output detect signal is very simple. It is asserted
// whenever the FSM is in state S0
assign isdiv_by_3 = (state == S0);

// The done signal is asserted whenever the counter reaches N
assign done = (count == N); 

// The counter which keeps track of how many bits of the 
// input number has been processed till now. The counter
// stops count at N.
always @(posedge clk or posedge rst) begin
    if (rst) count <= 4'b0;	
    else if (~done) count <= count + 1;
end

// The main FSM
always @(posedge clk or posedge rst) begin
    if (rst) state <= S0;
    else if (~done) begin
        case (state)
            S0: if (num[count]==1'b0) state <= S0; 
                else if (num[count]==1'b1) state <= S1;
            S1: if (num[count]==1'b0) state <= S2; 
                else if (num[count]==1'b1) state <= S0;
            S2: if (num[count]==1'b0) state <= S1; 
                else if (num[count]==1'b1) state <= S2;
            default: state <= S0; 
        endcase
    end // end else if
end

endmodule
