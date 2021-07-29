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

module BasicOperation_AddressGenerator
                #
                (
                    parameter IMAGE_WIDTH = 400,
                    parameter IMAGE_HEIGHT = 200,
                    parameter RGBFormat = 0
                )
                (
                    output wire [$clog2(IMAGE_HEIGHT*IMAGE_WIDTH)-1:0]VGA_Image_AddressOut,
                    input wire [((RGBFormat == 0) ? 16 : ((RGBFormat==1)? 8 : 24))-1:0]VGA_Image_DataIn,                        

                    input wire [1:0]rot_sw, 
                    input wire [1:0]scala_sw,

                    input wire [12-1:0]xPixel,
                    input  wire [12-1:0]yPixel,
                    input wire pixelDrawing,

                    output wire [4:0]R,
                    output wire [5:0]G,
                    output wire [4:0]B
                );

reg [12-1:0]newX, newY;

reg [12-1:0]XLIMIT, YLIMIT, scaleX, scaleY , SCALE_XLIMIT, SCALE_YLIMIT;



always@(*)
    begin
        case(scala_sw)
            2'b00: 
                begin
                    SCALE_XLIMIT = IMAGE_WIDTH;
                    SCALE_YLIMIT = IMAGE_HEIGHT;
                    scaleX = xPixel;
                    scaleY = yPixel;
                end
            2'b01: 
                begin
                    SCALE_XLIMIT = IMAGE_WIDTH >> 1;
                    SCALE_YLIMIT = IMAGE_HEIGHT >> 1;
                    scaleX = xPixel << 1;
                    scaleY = yPixel << 1;
                end
            2'b10: 
                begin
                    SCALE_XLIMIT = IMAGE_WIDTH << 1;
                    SCALE_YLIMIT = IMAGE_HEIGHT << 1;
                    scaleX = xPixel >> 1;
                    scaleY = yPixel >> 1;
                end
            2'b11: 
                begin
                    SCALE_XLIMIT = IMAGE_WIDTH;
                    SCALE_YLIMIT = IMAGE_HEIGHT;
                    scaleX = xPixel;
                    scaleY = yPixel;
                end
            default:
                begin
                    SCALE_XLIMIT = IMAGE_WIDTH;
                    SCALE_YLIMIT = IMAGE_HEIGHT;
                    scaleX = xPixel;
                    scaleY = yPixel; 
                end            
        endcase
    end


always@(*)
    begin
        case(rot_sw)
            2'b00: 
                begin
                    XLIMIT = SCALE_XLIMIT;
                    YLIMIT = SCALE_YLIMIT;
                    newX = scaleX;
                    newY = scaleY;
                end
            2'b01: 
                begin
                    YLIMIT = SCALE_XLIMIT;
                    XLIMIT = SCALE_YLIMIT;
                    newX = scaleY;
                    newY = (IMAGE_HEIGHT - scaleX);
                end
            2'b10: 
                begin
                    YLIMIT = SCALE_XLIMIT;
                    XLIMIT = SCALE_YLIMIT;
                    newX = (IMAGE_WIDTH - scaleY);
                    newY = scaleX;
                end
            2'b11: 
                begin
                    XLIMIT = SCALE_XLIMIT;
                    YLIMIT = SCALE_YLIMIT;
                    newX = (IMAGE_WIDTH - scaleX);
                    newY = (IMAGE_HEIGHT - scaleY);
                end
            default:
                begin
                    XLIMIT = SCALE_XLIMIT;
                    YLIMIT = SCALE_YLIMIT;
                    newX = 12'hx;
                    newY = 12'hx; 
                end            
        endcase
    end

// 12-bits chosen to satisfy maximum frequency
wire [12-1:0]rowIndx;
wire [12-1:0]colIndx;





assign rowIndx = newY;
assign colIndx = newX;

assign VGA_Image_AddressOut = (rowIndx * IMAGE_WIDTH) + colIndx;



wire [5-1:0]pixelOutR, pixelOutB;
wire [6-1:0]pixelOutG;


wire [5-1:0]RVal, BVal;
wire [6-1:0]GVal;

assign RVal = (RGBFormat == 0) ? VGA_Image_DataIn[15:11] : ((RGBFormat==1)? VGA_Image_DataIn[7:3] : VGA_Image_DataIn[23:19]);
assign GVal = (RGBFormat == 0) ? VGA_Image_DataIn[10:5] : ((RGBFormat==1)? VGA_Image_DataIn[7:2] : VGA_Image_DataIn[15:10]);
assign BVal = (RGBFormat == 0) ? VGA_Image_DataIn[4:0] : ((RGBFormat==1)? VGA_Image_DataIn[7:3] : VGA_Image_DataIn[7:3]);

assign pixelOutR = ((xPixel<XLIMIT) & (yPixel<YLIMIT))  ? RVal : 0;
assign pixelOutG = ((xPixel<XLIMIT) & (yPixel<YLIMIT))  ? GVal : 0;
assign pixelOutB = ((xPixel<XLIMIT) & (yPixel<YLIMIT))  ? BVal : 0;


assign R = (pixelDrawing) ? pixelOutR : 0;
assign G = (pixelDrawing) ? pixelOutG : 0;
assign B = (pixelDrawing) ? pixelOutB : 0;

endmodule
