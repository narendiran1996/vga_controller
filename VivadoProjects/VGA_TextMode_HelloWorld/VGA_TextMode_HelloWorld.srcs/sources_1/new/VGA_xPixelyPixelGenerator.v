`timescale 1ns / 1ps


module VGA_xPixelyPixelGenerator
                #
                (
                    parameter HPIXEL = 640,
                    parameter VPIXEL = 480,
                    parameter PIXEL_LIMIT = 800,
                    parameter LINE_LIMIT = 525
                )
                (
                    input wire [$clog2(PIXEL_LIMIT)-1:0]hCount,
                    input wire [$clog2(LINE_LIMIT)-1:0]vCount,
                    output wire [$clog2(PIXEL_LIMIT)-1:0]xPixel,
                    output wire [$clog2(LINE_LIMIT)-1:0]yPixel,
                    output wire pixelDrawing
                );
    
    
assign pixelDrawing = (hCount < HPIXEL) && (vCount < VPIXEL); 
    
assign xPixel = (pixelDrawing==1) ? hCount : 0;
assign yPixel = (pixelDrawing==1) ? vCount : 0;


endmodule
