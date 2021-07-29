module VGA_pixelClockGenerator 
                #
                (
                    parameter DIV_BY = 16'h338F
                )
                (
                    input wire systemClk,
                    input wire rst,
                    output wire pixelClk
                );

reg [$clog2(DIV_BY)-1:0]pix_cnt;
reg pix_stb;

always @(posedge systemClk)
    begin
        if(rst == 1)
            {pix_stb, pix_cnt} <= 0;
        else
            {pix_stb, pix_cnt} <= pix_cnt + DIV_BY;
    end

assign pixelClk = pix_stb;

    
endmodule