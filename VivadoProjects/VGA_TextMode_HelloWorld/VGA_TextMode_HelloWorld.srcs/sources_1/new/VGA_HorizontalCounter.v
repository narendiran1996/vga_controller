module VGA_HorizontalCounter
                #
                (
                    parameter PIXEL_LIMIT = 800-1
                )
                (
                    input wire pixelClk,
                    input wire rst, 
                    output reg [$clog2(PIXEL_LIMIT)-1:0]hCount,
                    output wire EndOfLine
                );

assign EndOfLine = (hCount == PIXEL_LIMIT);


always@(posedge pixelClk)
//always@(rst or posedge pixelClk)
	begin
		if((rst == 1) || (hCount == PIXEL_LIMIT))
			hCount <= 0;
		else
			hCount <= hCount +  1;
	end


endmodule
    
