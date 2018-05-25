module ALU;
    initial begin
        $display ("Welcome to JDoodle!!!");
      
    end
endmodule


module andAB(R, A, B);

    input [3:0] A, B;
    output [3:0] R;
    
    // S = A & B
    
endmodule

module orAB(R, A, B);

    input [3:0] A, B;
    output [3:0] R;
    
    // S = A | B
    
endmodule

module selectOutput(Out, P,Q, AplusB, AandB)

//---- Control Unit ------------------------------------------------------------------

module moduleEnA(enA, L,M,N);
	// enA = (L'.M'.N)'

endmodule 

module moduleEnB(enB, L,M,N);
	// enB = (L'.M'.N')'

endmodule 

module moduleABar(enA, L,M,N);
	// ABar = (L'.M'.N')

endmodule 

module moduleBBar(enB, L,M,N);
	// BBar = (L'.N')

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
	
	xor f1(xorMN, M,N);
	not f2(notN, N);
	
	and f3(P, L,xorMN);
	and f4(Q, L, notN);
	and f5(R, L,M,N);

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

