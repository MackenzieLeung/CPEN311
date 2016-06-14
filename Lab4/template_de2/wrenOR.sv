module wrenOR (input clk, input s_array,input shuffle,input encrypt,output wren );

always@(posedge clk)
	begin
		wren <=(s_array | shuffle | encrypt);
	end
	
endmodule