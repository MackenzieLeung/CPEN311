module freq_selector #(parameter BITS = 16, parameter original_freq = 16'd1136)(input CLK, input fast, input slow, input original, 
																					output logic  [BITS-1:0]freq_divider);

initial freq_divider <= original_freq;
reg originalB;
reg fastB;
reg slowB;

always_ff @(posedge CLK)
begin	
	if(original)
		originalB <= 1'b1;
	else	
		originalB <= 1'b0;
end

always_ff @(posedge CLK)
begin	
	if(fast)
		fastB <= 1'b1;
	else	
		fastB <= 1'b0;
end

always_ff @(posedge CLK)
begin	
	if(slow)
		slowB <= 1'b1;
	else	
		slowB <= 1'b0;
end

	always @(posedge CLK)
		begin
			if(original & !originalB) begin
				freq_divider <= original_freq;
			end else if (fast & !fastB & (freq_divider < 16'b1111_1111_1111_1111)) begin
				freq_divider <= freq_divider + 50;
			end else if (slow & !slowB & (freq_divider > 16'b0000_0000_0000_0000)) begin
				freq_divider <= freq_divider - 50;
			end
		end
	
endmodule

