module VGA_HSyncGenerator 
                #
                (
                    parameter HPIXEL = 640, 
                    parameter H_FRONT_PORCH = 16, 
                    parameter H_SYNC_PULSE = 96, 
                    parameter H_BACK_PORCH = 48,
                    parameter H_Polarity = 0
                ) 
                (
                    input wire [$clog2(HPIXEL+H_FRONT_PORCH+H_SYNC_PULSE+H_BACK_PORCH)-1:0]hCount,
                    output wire hSYNC
                );


wire temp;
assign temp = ((hCount >= (HPIXEL + H_FRONT_PORCH)) && (hCount < (HPIXEL + H_FRONT_PORCH + H_SYNC_PULSE)));   // active for 96 pix_clock see diagram


// 0-  low during Sync pulse
// 1-  high during Sync pulse
assign hSYNC = (H_Polarity == 0) ? ~temp : temp;
endmodule