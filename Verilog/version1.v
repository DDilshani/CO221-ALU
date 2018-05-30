
module testbench;

	reg [3:0] A,B;
	reg [2:0] C;
	output [3:0] out;
	reg [4:0] i;
	ALU myALU(out, A,B, C[2], C[1], C[0]);
	
	initial begin
		A <= 4'b1100;
		B <= 4'b0001;
		C <= 3'b110; //
		
		$dumpfile("alu.vcd"); 
		$dumpvars(0, myALU);
		/*

*/

		for(i=0; i<15; i=i+1) begin
			B <= i;
 			A <= i/2;
			#10 $display("Signal=%d (%b)   |   A=%d, B=%d, Out=%d   |   A=%b, B=%b, Out=%b\n", C,C, A,B,out, A,B,out);
	  	end
		
		//#10 $display("A=%b B=%b ===( %b )===> Output=%b \n", A, B, C, out);
	end
endmodule

module ALU(S, A, B, L,M,N);

    input [3:0] A,B;     // Input Registers
    input L, M, N;     // Control Input
    output [3:0] S;      // Output Register
    
	// 4bit wires
	wire [3:0] inA, inB, afterEnA, afterEnB;
	wire [3:0] AandB, AorB, AplusB, AxB;
	
	// 1bit wires
	wire EnA, EnB, ABar, BBar, P, Q, R, cIn,  cOut;
	
	moduleEnA myEnA(EnA, L, M, N);
	moduleEnB myEnB(EnB, L, M, N);
	moduleABar myABar(ABar, L, M, N);
	moduleBBar myBBar(BBar, L, M, N);
	
	moduleCin myCin(cIn, L, M, N);
	
	// AND Module - take bus input if En=1
	busAND myAND1(afterEnA, A, EnA);
	busAND myAND2(afterEnB, B, EnB);
	
	// XOR Module - invert bus input if En=1
	busXOR myXOR1(inA, afterEnA, ABar);
	busXOR myXOR2(inB, afterEnB, BBar);
	
	// -A, -B, A+B, A-B handle from this 4bit Full Adder
	fourBitFullAdder myFullAdder(AplusB,cOut, inA,inB,cIn);
	
	// Bitwise AND operation
	bitwiseAndAB  myAndAB(AandB, A,B);
	
	// Bitwise OR Operation
	bitwiseOrAB myOrAB(AorB, A,B);
	
	// A*B Operation
	
module bitwiseXOR(R, A, B);
	//bitwiseXOR myXOR(AxorB, A,B);
	// Bonus Operation

	input [3:0] A, B;
	output [3:0] AxorB;
    
	//AXORB  = A XOR B
	xor (AxorB[0], A[0], B[0]);
	xor (AxorB[1], A[1], B[1]);
	xor (AxorB[2], A[2], B[2]);
	xor (AxorB[3], A[3], B[3]);
endmodule
	
	
	// Final output switching modules
	modulePQRfromLMN myController(P,Q,R, L,M,N);
	outputSelector myOutput(S, P,Q,R, AplusB, AandB, AorB, AxB, AxB);

endmodule

module bitwiseAndAB(R, A, B);

    input [3:0] A, B;
    output [3:0] R;
    
	// R = A & B
    and (R[0], A[0], B[0]);
    and (R[1], A[1], B[1]);
    and (R[2], A[2], B[2]);
    and (R[3], A[3], B[3]);
    
endmodule

module bitwiseOrAB(R, A, B);

    input [3:0] A, B;
    output [3:0] R;
    
    or (R[0], A[0], B[0]);
    or (R[1], A[1], B[1]);
    or (R[2], A[2], B[2]);
    or (R[3], A[3], B[3]);
    
endmodule

module AmultiplyB(R, A,B);

	input [3:0] A,B;
	output [3:0] R;


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
	not b5 (enA, out1);
	
endmodule 

module moduleEnB(enB, L,M,N);
	input L, M, N;
	output enB;
	wire notL, notM, notN, out2;
	
	// enB = (L'.M'.N')'
	not c1 (notL, L);
	not c2 (notM, M);
	not c3 (notN, N);
	
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
	not c3 (notN, N);
	
	and c4 (ABar, notL, notM, notN);
	
endmodule 

module moduleBBar(BBar, L,M,N);
	input L, M, N;
	output BBar;
	wire notL, notN, out2;
	
	// BBar = (L'.N')
	not c1 (notL, L);
	not c3 (notN, N);
	and c4 (out2, notL, notN);
	not c5 (BBar, out2);
endmodule 

module moduleCin(cIn, L,M,N);
	input L,M,N;
	output cIn;
	wire notL, notN, out2;
	
	// cIn = (L'.M.N')'
	not f1(notL, L);
	not f2(notN, N);
	and f3(out2, notL, M, notN);
	not f4(cIn, out2);
	
endmodule 

module modulePQRfromLMN(P,Q,R, L,M,N);
	
	input L,M, N;
	output P, Q, R;
	wire xorMN, notN; 
	
	// P = L.(M (+) N)
	// Q = L.N'
	// R = L.M.N
	
	xor d1 (xorMN, M,N);
	not d2 (notN, N);
	
	and d3 (P, L,xorMN);
	and d4 (Q, L, notN);
	and d5 (R, L,M,N);

endmodule

module outputSelector(S, P,Q,R, AplusB, AandB, AorB, AxB, AmodB);
	// 4bit output selector
	input [3:0] AplusB, AandB, AorB, AxB, AmodB;
	input P,Q,R;
	output [3:0] S;

	oneBitOutputSelector f1(S[0], P,Q,R, AplusB[0], AandB[0], AorB[0], AxB[0], AmodB[0]);
	oneBitOutputSelector f2(S[1], P,Q,R, AplusB[1], AandB[1], AorB[1], AxB[1], AmodB[1]);
	oneBitOutputSelector f3(S[2], P,Q,R, AplusB[2], AandB[2], AorB[2], AxB[2], AmodB[2]);
	oneBitOutputSelector f4(S[3], P,Q,R, AplusB[3], AandB[3], AorB[3], AxB[3], AmodB[3]);
	
endmodule

module oneBitOutputSelector(S, P,Q,R, AplusB, AandB, AorB, AxB, AmodB);
	// 1bit output selector
	input AplusB, AandB, AorB, AxB, AmodB;
	input P,Q,R;
	output S;
	
	wire pBar, qBar, rBar;
	wire AplusB_out, AandB_out, AorB_out, AxB_out, AmodB_out;
	
	not f1(pBar, P);
	not f2(qBar, Q);
	not f3(rBar, R);
	
	and f4(AplusB_out, AplusB, pBar, qBar, rBar);
	and f5(AandB_out, AandB, pBar, Q, rBar);
	and f6(AorB_out, AorB, P, qBar, rBar);
	and f7(AxB_out, AxB, P, Q, rBar);
	and f8(AmodB_out, R);
	
	or f9(S, AplusB_out, AandB_out, AorB_out, AxB_out, AmodB_out);
	
endmodule

//---- 4bit Full Adder ------------------------------------------------------------------

module fourBitFullAdder(AplusB,cOut, inA,inB,cIn);
	input [3:0] inA, inB;
	output [3:0] AplusB;
	
	input cIn;
	output cOut;

	wire w1, w2, w3;
 
	fullAdder add1(inA[0], inB[0], cIn, w1, AplusB[0]);
	fullAdder add2(inA[1], inB[1], w1, w2, AplusB[1]);
	fullAdder add3(inA[2], inB[2], w2, w3, AplusB[2]);
	fullAdder add4(inA[3], inB[3], w3, cOut, AplusB[3]);
endmodule


module fullAdder(A, B, cIn, cOut, S);

	input A,B, cIn;
	output cOut, S;
	wire x,y,z, p;

	halfAdder add1(A,B, x, y);
	halfAdder add2(y, cIn, z, S);
	or u1(cOut, x, z);
	
	/*input A,B,cIn; output S,cOut;
	assign {cOut,S} = A + B + cIn;
	*/
endmodule

module halfAdder(A, B, cOut, S);
	// Get A,B bits and results A+B

	input A,B;
	output cOut, S;

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

	// if (EnA==1) ? Y=xor(Y, 1) : Y= Y
	// Y[i] = X[i] (+) En
    input [3:0] X;
    input En;
    output [3:0] Y;
    
	xor f1(Y[0], X[0], En);
	xor f1(Y[1], X[1], En);
	xor f1(Y[2], X[2], En);
	xor f1(Y[3], X[3], En);
	
endmodule


//---- 4bit multiply  ------------------------------------------------------------------

/* 
This section must be think and write 
*/
