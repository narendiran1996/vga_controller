module VGA_VSyncGenerator 
                #
                (
                    parameter VPIXEL = 480,
                    parameter V_FRONT_PORCH = 10,
                    parameter V_SYNC_PULSE = 2, 
                    parameter V_BACK_PORCH = 33,
                    parameter V_Polarity = 0
                ) 
                (
                    input wire [$clog2(VPIXEL+V_FRONT_PORCH+V_SYNC_PULSE+V_BACK_PORCH)-1:0]vCount,
                    output wire vSYNC
                );

wire temp;
assign temp = ((vCount >= (VPIXEL + V_FRONT_PORCH)) && (vCount < (VPIXEL + V_FRONT_PORCH + V_SYNC_PULSE))); // active for 2 pix_clock see diagram


// 0-  low during Sync pulse
// 1-  high during Sync pulse
assign vSYNC = (V_Polarity == 0) ? ~temp : temp;

endmodule