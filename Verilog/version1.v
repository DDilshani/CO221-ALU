
module ALU;

	reg [3:0]A, [3:0]B;
	reg [2:0]C;
	output Out;
	
	// 4bit wires
	wire [3:0] AandB, AorB, inA inB, afterEnA, afterEnB;
	
	// 1bit wires
	wire EnA, EnB, ABar, BBar, P, Q, R;
	
	andAB (AandB, A,B);
	orAB (AorB, A,B);
	
	moduleEnA(EnA, C[2], C[1], C[0]);
	moduleEnB(EnB, C[2], C[1], C[0]);
	moduleABar(ABar, C[2], C[1], C[0]);
	moduleBBar(BBar, C[2], C[1], C[0]);
	
	modulePQRfromLMN (P,Q,R, L,M,N)
	initial begin
		A <= 4'b1100;
		B <= 4'b0001;
		Ctrl <= 3'b000; // -A
		
		$dumpfile("alu.vcd"); 
		$dumpvars(0, myFullAdder);
	end
endmodule

module andAB(R, A, B);
    input [3:0] A, B;
    output [3:0] R;
    
	// S = A & B
    and (R[0], A[0], B[0]);
    and (R[1], A[1], B[1]);
    and (R[2], A[2], B[2]);
    and (R[3], A[3], B[0]);
    
endmodule

module orAB(R, A, B);
    input [3:0] A, B;
    output [3:0] R;
    
    or (R[0], A[0], B[0]);
    or (R[1], A[1], B[1]);
    or (R[2], A[2], B[2]);
    or (R[3], A[3], B[3]);
    
endmodule

module selectOutput(Out, P,Q, AplusB, AandB)

endmodule

//---- Control Unit ------------------------------------------------------------------

module moduleEnA(enA, L,M,N);
	input L, M, N;
	output enA;
	wire notL, notM, notN, out1;
	
	// enA = (L'.M'.N)'
	not b1 (notL, L);
	not b2 (notM, M);
	
	and b4 (out1, notL, notM, N);
	not b5 (enA, out1)
	
endmodule 

module moduleEnB(enB, L,M,N);
	input L, M, N;
	output enB;
	wire notL, notM, notN;
	
	// enB = (L'.M'.N')'
	not c1 (notL, L);
	not c2 (notM, M);
	not c3 (notn, N);
	
	and c4 (out2, notL, notM, notN);
	not c5 (enB, out2);

endmodule 

module moduleABar(ABar, L,M,N);
	input L, M, N;
	output ABar;
	wire notL, notM, notN;
	
	// ABar = (L'.M'.N')
	not c1 (notL, L);
	not c2 (notM, M);
	not c3 (notn, N);
	
	and c4 (ABar, notL, notM, notN);
	
endmodule 

module moduleBBar(BBar, L,M,N);
	// BBar = (L'.N')
	
	input L, N;
	output BBar;
	wire notL, notN;
	
	not c1 (notL, L);
	not c3 (notn, N);
	
	and c4 (BBar, notL, notN);
	
endmodule 

module moduleCin(cIn, L,M,N);
	input L,M,N;
	output cIn;
	wire notL, notN;
	
	// cIn = (L'.M.N')
	
	not f1(notL, L);
	not f2(notN, N);
	
	and f3(cIn, notL, M, notN);
	
endmodule 

module modulePQRfromLMN(P,Q,R, L,M,N);
	
	input L,M, N;
	output P, Q, R;
	wire xorMN, notN, 
	
	// P = L.(M (+) N)
	// Q = L.N'
	// R = L.M.N
	
	xor d1(xorMN, M,N);
	not d2(notN, N);
	
	and d3(P, L,xorMN);
	and d4(Q, L, notN);
	and d5(R, L,M,N);

endmodule

//---- 4bit Full Adder ------------------------------------------------------------------

module fourBitFullAdder(AplusB, inA, inB);
	input [3:0] inA, inB;
	output [3:0] AplusB;
	
endmodule

module oneBitFullAdder(S,cOut, A,B,cIn);
	input A, B, cIn;
	output S, cOut;
	wire masterCOut, masterS, slaveCOut;
	
	oneBitHalfAdder masterFA(masterS,masterCOut,  A, B);
	oneBitHalfAdder masterFA(S,slaveCOut,  A, B);
endmodule

module oneBitHalfAdder(S,cOut, A,B,cOut);
	input A, B, cIn;
	output S, cOut;
	
	// cOut = A+B
	// S = A (+) B
	
	and u1(cOut, A,B);
	xor u2(S, A,B);

endmodule


//---- support Modules for 4bit fullAdder ----------------------------------------------

module busAND(Y, X, En);
    input [3:0] X;
    input En;
    output [3:0] Y;
    
    // if (EnA==1) ? Y=X : Y= 4'b0000
	// Y[i] = X[i] and En
	
	and f1(Y[0], X[0], En);
	and f1(Y[1], X[1], En);
	and f1(Y[2], X[2], En);
	and f1(Y[3], X[3], En);
	
endmodule

module busXOR(Y, X, En);

    input [3:0] X;
    input En;
    output [3:0] Y;
    
    // if (EnA==1) ? Y=xor(Y, 1) : Y= Y
	// Y[i] = X[i] (+) En
	
	
	
endmodule


//---- 4bit multiply  ------------------------------------------------------------------

/* 
This section must be think and write 
*/
