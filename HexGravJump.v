module HexGravJump (
    input [17:0] SW,
    input [3:0] KEY,
    input wire CLOCK_50,
	 output reg [7:0] LEDG,
    output reg [6:0] HEX0, 
	 output reg [6:0] HEX1, 
	 output reg [6:0] HEX2, 
	 output reg [6:0] HEX3, 
	 output reg [6:0] HEX4, 
	 output reg [6:0] HEX5, 
	 output reg [6:0] HEX6,
	 output reg [6:0] HEX7
    );
	
	
	parameter [4:0] IDLE 	= 5'b00001;
	parameter [4:0] select1 = 5'b00010;
	parameter [4:0] check1 	= 5'b00011;
	parameter [4:0] select2 = 5'b00100;
	parameter [4:0] check2	= 5'b00101;
	parameter [4:0] select3 = 5'b00110;
	parameter [4:0] check3 	= 5'b00111;
	parameter [4:0] select4 = 5'b01000;
	parameter [4:0] check4 	= 5'b01001;
	parameter [4:0] select5 = 5'b01010;
	parameter [4:0] check5	= 5'b01011;
	parameter [4:0] select6 = 5'b01100;
	parameter [4:0] check6 	= 5'b01101;
	parameter [4:0] select7 = 5'b01110;
	parameter [4:0] lose 	= 5'b10000;
	parameter [4:0] win 		= 5'b10001;
	
	reg [4:0] s;
	reg [4:0] ns;
	
	reg [34:0] count;
	reg [34:0] dout;
	
	
	// Switches between states
	always @(posedge CLOCK_50 or posedge SW[17]) begin
		if (SW[17]) begin
			s <= IDLE;
		end else begin
			if (count < 25000000) begin
				count <= count + 1;
			end else begin
				s <= ns;
			end
		end
	end
	

	always @(posedge CLOCK_50) begin
		if (dout < 25000000) begin
			dout <= dout + 1;
			//s <= ns;
		end else begin
			dout <= 0;
		// Next state logic
			case (s)
				IDLE: if (SW[1] == 1) begin
							ns <= select1;
						end else begin
							ns <= IDLE;
						end
					
				select1: ns <= check1;
			
				check1: 	if (SW[0] == 1) begin
								ns <= select2;
							end else begin
								ns <= lose;
							end
						
				select2: ns <= check2;
			
				check2: if (SW[0] == 0) begin
								ns <= select3;
							end else begin
								ns <= lose;
							end
						
				select3: ns <= check3;
			
				check3: if (SW[0] == 0) begin
								ns <= select4;
							end else begin
								ns <= lose;
							end
						
				select4: ns <= check4;
			
				check4: if (SW[0] == 1) begin
								ns <= select5;
							end else begin
								ns <= lose;
							end
						
				select5: ns <= check5;
			
				check5: if (SW[0] == 1) begin
								ns <= select6;
							end else begin
								ns <= lose;
							end
						
				select6: ns <= check6;
			
				check6: if (SW[0] == 0) begin
								ns <= win;
							end else begin
								ns <= lose;
							end
						
				select7: ns <= win;
			
				lose: ns <= lose;
			
				win: ns <= win;
			
				default: ns  = IDLE;
			
			endcase
		end
	end
	
	always @(*) begin
		
		// DEBUGGING SWITCHES
		
		if (SW[0] == 1) begin
			LEDG[0] = 1;
		end else begin
			LEDG[0] = 0;
		end
		if (SW[1] == 1) begin
			LEDG[1] = 1;
		end else begin
			LEDG[1] = 0;
		end
		if (SW[17]) begin
			LEDG[4] = 1;
		end else begin
			LEDG[4] = 0;
		end
		
		
		if (s == IDLE) begin
			
			// 1111110 TOP
			// 1110111 BOTTOM
			
			// 1111111 FULL BLANK
			// 1111001 EDGE PEICE
			
			HEX7 = 7'b1111111;                           
			HEX6 = 7'b1110111;
			HEX5 = 7'b1110111;
			HEX4 = 7'b1111110;
			HEX3 = 7'b1111110;
			HEX2 = 7'b1110111;
			HEX1 = 7'b1110111;
			HEX0 = 7'b1111110;
		
		end if (s == select1) begin
			
			if (SW[0] == 0) begin
							HEX7 = 7'b1110111; //select
							
							HEX6 = 7'b1110111;
							HEX5 = 7'b1110111;
							HEX4 = 7'b1111110;
							HEX3 = 7'b1111110;
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end if (SW[0] == 1) begin
							HEX7 = 7'b1111110; //select
							
							HEX6 = 7'b1110111;
							HEX5 = 7'b1110111;
							HEX4 = 7'b1111110;
							HEX3 = 7'b1111110;
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end
			
		end if (s == select2 || s == check1) begin
			
			if (SW[0] == 0) begin
							HEX7 = 7'b1111001;
							HEX6 = 7'b1110111; //select
							
							HEX5 = 7'b1110111;
							HEX4 = 7'b1111110;
							HEX3 = 7'b1111110;
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end if (SW[0] == 1) begin
							HEX7 = 7'b1111001;
							HEX6 = 7'b1111110; //select
							
							HEX5 = 7'b1110111;
							HEX4 = 7'b1111110;
							HEX3 = 7'b1111110;
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end
			
		end if (s == select3 || s == check2) begin
			
			if (SW[0] == 1) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111001;
							HEX5 = 7'b1111110; //select
							
							HEX4 = 7'b1111110;
							HEX3 = 7'b1111110;
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end if (SW[0] == 0) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111001;
							HEX5 = 7'b1110111; //select
							
							HEX4 = 7'b1111110;
							HEX3 = 7'b1111110;
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end
			
		end if (s == select4 || s == check3) begin
			
			if (SW[0] == 1) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111111;
							HEX5 = 7'b1111001;
							HEX4 = 7'b1111110; //select
							
							HEX3 = 7'b1111110;
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end if (SW[0] == 0) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111111;
							HEX5 = 7'b1111001;
							HEX4 = 7'b1110111; //select
							
							HEX3 = 7'b1111110;
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end
			
		end if (s == select5 || s == check4) begin
			
			if (SW[0] == 0) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111111;
							HEX5 = 7'b1111111;
							HEX4 = 7'b1111001;
							HEX3 = 7'b1110111; //select
							
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end if (SW[0] == 1) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111111;
							HEX5 = 7'b1111111;
							HEX4 = 7'b1111001;
							HEX3 = 7'b1111110; //select
							
							HEX2 = 7'b1110111;
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end
			
		end if (s == select6 || s == check5) begin
			
			if (SW[0] == 0) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111111;
							HEX5 = 7'b1111111;
							HEX4 = 7'b1111111;
							HEX3 = 7'b1111001;
							HEX2 = 7'b1110111; //select
							
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end if (SW[0] == 1) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111111;
							HEX5 = 7'b1111111;
							HEX4 = 7'b1111111;
							HEX3 = 7'b1111001;
							HEX2 = 7'b1111110; //select
							
							HEX1 = 7'b1110111;
							HEX0 = 7'b1111110;
			end
			
		end if (s == select7 || s == check6) begin
			
			if (SW[0] == 1) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111111;
							HEX5 = 7'b1111111;
							HEX4 = 7'b1111111;
							HEX3 = 7'b1111111;
							HEX2 = 7'b1111001;
							HEX1 = 7'b1111110; //select
							
							HEX0 = 7'b1111110;
							
			end if (SW[0] == 0) begin
							HEX7 = 7'b1111111;
							HEX6 = 7'b1111111;
							HEX5 = 7'b1111111;
							HEX4 = 7'b1111111;
							HEX3 = 7'b1111111;
							HEX2 = 7'b1111001;
							HEX1 = 7'b1110111; //select
							
							HEX0 = 7'b1111110;
							
			end
		
		// Winning BABY
		end if (s == win) begin
			HEX7 = 7'b1111110;                            
			HEX6 = 7'b1111110;
			HEX5 = 7'b1000011; //    |_|
			HEX3 = 7'b1111110;   
			HEX4 = 7'b1110001; //       _|
			HEX2 = 7'b1111110; 
			HEX1 = 7'b1111110;  
			HEX0 = 7'b1111110;
		
		// Loser Loser
		end if (s == lose) begin
			HEX7 = 7'b1110111;
			HEX6 = 7'b1110111;
			HEX3 = 7'b1000111; //L
			HEX2 = 7'b1000000; //O 
			HEX1 = 7'b0010010; //S
			HEX0 = 7'b0000110; //E
			HEX5 = 7'b1110111;
			HEX4 = 7'b1110111;
		end
	end

endmodule
