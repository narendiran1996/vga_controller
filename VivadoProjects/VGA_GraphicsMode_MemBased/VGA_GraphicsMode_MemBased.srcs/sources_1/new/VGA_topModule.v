`timescale 1ns / 1ps

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
RGBFormat
0 - 16bit (5-6-5)
1 - 8bit
2 - 24bit (8-8-8)
*/


module VGA_topModule
                (
                    input wire clk,
                    input wire rst,

                    output wire [4:0]R,
                    output wire [5:0]G,
                    output wire [4:0]B,
                    output wire hSYNC,
                    output wire vSYNC
                );

parameter IMAGE_WIDTH = 320;
parameter IMAGE_HEIGHT = 180;
parameter MODES = 2;
parameter RGBFormat = 0;

wire [12-1:0]xPixel;
wire [12-1:0]yPixel;
wire pixelDrawing;



VGA_Block       
                #
                (
                    .MODES(MODES)
                )
                VGABlockIns
                (
                    .systemClk_125MHz(clk),
                    .rst(rst),

                    .xPixel(xPixel),
                    .yPixel(yPixel),
                    .pixelDrawing(pixelDrawing),

                    .hSYNC(hSYNC),
                    .vSYNC(vSYNC)
                );

wire [$clog2(IMAGE_HEIGHT*IMAGE_WIDTH)-1:0]VGA_Image_AddressOut;
wire [((RGBFormat == 0) ? 16 : ((RGBFormat==1)? 8 : 24))-1:0]VGA_Image_DataIn;

Address_RGB_Generator
                #
                (
                    .IMAGE_WIDTH(IMAGE_WIDTH),
                    .IMAGE_HEIGHT(IMAGE_HEIGHT),
                    .RGBFormat(RGBFormat)
                )
                ARBINS
                (
                    .VGA_Image_AddressOut(VGA_Image_AddressOut),
                    .VGA_Image_DataIn(VGA_Image_DataIn), 


                    .xPixel(xPixel),
                    .yPixel(yPixel),
                    .pixelDrawing(pixelDrawing),

                    .R(R),
                    .G(G),
                    .B(B)
                );


ImageMemory
                #
                (
                    .IMAGE_WIDTH(IMAGE_WIDTH),
                    .IMAGE_HEIGHT(IMAGE_HEIGHT),
                    .RGBFormat(RGBFormat)
                )
                IMBRamIns
                (
                    .clk(clk),
                    .enable(1'b1),
                    .write_enable(0),
                    .address(VGA_Image_AddressOut),
                    .inputData(0),
                    .outputData(VGA_Image_DataIn)
                );


endmodule
