`timescale 1ns / 1ps
// tinyvga.com/vga-timing/
// https://ez.analog.com/cfs-file/__key/communityserver-discussions-components-files/331/vesa_5F00_dmt_5F00_1.12.pdf
/*
MODES
0 - 640x480
1 - 800x600
2 - 1024x768
*/



/*
RGBForma
0 - 16bit (5-6-5)
1 - 8bit
2 - 24bit (8-8-8)
*/


module VGA_Block
                #
                (
                    parameter MODES = 0,

                    // localparam DIV_BY = 16'h338F;// obtainted because
                    // see the output to get better understanding
                    /* the clk was 125 MHZ, but we need 25.175MHZ, so divited by 4.96;
                    so we use (2^16)/4.96=0x338F to get the requried divieded strobe
                    resource: https://zipcpu.com/blog/2017/06/02/generating-timing.html */
                    parameter DIV_BY = (MODES == 0) ? 16'h338F : ((MODES == 1) ? 16'h51EC : ((MODES == 2) ? 16'h851F : 16'hAF1B )),

                    parameter HPIXEL = (MODES == 0) ? 640 : ((MODES == 1) ? 800: ((MODES == 2) ? 1024 : 1366)),
                    parameter H_FRONT_PORCH = (MODES == 0) ? 16 : ((MODES == 1) ? 40: ((MODES == 2) ? 24 : 70)),
                    parameter H_SYNC_PULSE = (MODES == 0) ? 96 : ((MODES == 1) ? 128: ((MODES == 2) ? 136 : 143)),
                    parameter H_BACK_PORCH = (MODES == 0) ? 48 : ((MODES == 1) ? 88: ((MODES == 2) ? 160 : 213)),

                    parameter VPIXEL = (MODES == 0) ? 480 : ((MODES == 1) ? 600: ((MODES == 2) ? 768 : 768)),
                    parameter V_FRONT_PORCH = (MODES == 0) ? 10 : ((MODES == 1) ? 1: ((MODES == 2) ? 3 : 3)),
                    parameter V_SYNC_PULSE = (MODES == 0) ? 2 : ((MODES == 1) ? 4: ((MODES == 2) ? 6 : 3)),
                    parameter V_BACK_PORCH = (MODES == 0) ? 33 : ((MODES == 1) ? 23: ((MODES == 2) ? 29 : 24)),

                    parameter H_Polarity = (MODES == 0) ? 0: ((MODES == 1) ? 1 : ((MODES == 2) ? 0 : 1)),
                    parameter V_Polarity = (MODES == 0) ? 0: ((MODES == 1) ? 1 : ((MODES == 2) ? 0 : 1)),

                    parameter PIXEL_LIMIT = HPIXEL + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH,
                    parameter LINE_LIMIT = VPIXEL + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH
                )
                (
                    input wire systemClk_125MHz,
                    input wire rst,

                    output wire [$clog2(PIXEL_LIMIT)-1:0]xPixel,
                    output wire [$clog2(LINE_LIMIT)-1:0]yPixel,
                    output wire pixelDrawing,


                    output wire hSYNC,
                    output wire vSYNC
                );



wire pixelClk, EndOfLine;


wire [$clog2(PIXEL_LIMIT)-1:0]hCount;
wire [$clog2(LINE_LIMIT)-1:0]vCount;

VGA_pixelClockGenerator 
                #
                (
                    .DIV_BY(DIV_BY)
                )
                VGApixelClockGneratorIns
                (
                    systemClk_125MHz,
                    rst,
                    pixelClk
                );


VGA_HorizontalCounter
                #
                (
                    .PIXEL_LIMIT(PIXEL_LIMIT-1)
                )
                HCounterIns
                (
                    pixelClk,
                    rst, 
                    hCount,
                    EndOfLine
                );

VGA_HSyncGenerator 
                #
                (
                    .HPIXEL(HPIXEL), 
                    .H_FRONT_PORCH(H_FRONT_PORCH), 
                    .H_SYNC_PULSE(H_SYNC_PULSE), 
                    .H_BACK_PORCH(H_BACK_PORCH),
                    .H_Polarity(H_Polarity)
                ) 
                HSyncGenIns
                (
                    hCount,
                    hSYNC
                );

VGA_VerticalCounter
                #
                (
                    .LINE_LIMIT(LINE_LIMIT-1)
                )
                VerticalCOuntins
                (
                    pixelClk,
                    rst, 
                    EndOfLine,
                    vCount
                );


VGA_VSyncGenerator 
                #
                (
                    .VPIXEL(VPIXEL),
                    .V_FRONT_PORCH(V_FRONT_PORCH),
                    .V_SYNC_PULSE(V_SYNC_PULSE),
                    .V_BACK_PORCH(V_BACK_PORCH),
                    .V_Polarity(V_Polarity)
                ) 
                VsyngenIns
                (
                    vCount,
                    vSYNC
                );


VGA_xPixelyPixelGenerator
                #
                (
                    .HPIXEL(HPIXEL),
                    .VPIXEL(VPIXEL),
                    .PIXEL_LIMIT(PIXEL_LIMIT),
                    .LINE_LIMIT(LINE_LIMIT)
                )
                xPixelyPixelGeneratorIns
                (
                    hCount,
                    vCount,
                    xPixel,
                    yPixel,
                    pixelDrawing
                );

endmodule
