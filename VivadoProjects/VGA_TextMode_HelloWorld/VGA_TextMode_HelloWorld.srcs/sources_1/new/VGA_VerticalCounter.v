module VGA_VerticalCounter
                #
                (
                    parameter LINE_LIMIT = 525-1
                )
                (
                    input wire pixelClk,
                    input wire rst, 
                    input wire Enable,
                    output reg [$clog2(LINE_LIMIT)-1:0]vCount
                );


always@(posedge pixelClk)
//always@(rst or  posedge pixelClk)
	begin
		if(rst == 1)
			vCount <= 0;
		else
            begin
                if(Enable == 1)
                    begin
                        if(vCount == LINE_LIMIT)
                            vCount <= 0;
                        else
                            vCount <= vCount +  1;
                    end
            end
	end

    
endmodule
    
