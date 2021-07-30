`timescale 1ns / 1ps

module VGA_TextMode_topModule
                (
                    input wire clk,
                    input wire rst,
                    
                    output wire [4:0]R, 
                    output wire [5:0]G, 
                    output wire [4:0]B,

                    output wire hSYNC,
                    output wire vSYNC
                );
                
                
                
localparam CHARACTER_SET_COUNT = 256;
localparam CHARACTER_ROM_MEMLOC = "/mnt/18C846EDC846C928/vga_controller/TextModeMemoryFiles/CharacterROM_ASCII.mem";
localparam CHARACTER_BUFFER_MEMLOC = "/mnt/18C846EDC846C928/vga_controller/TextModeMemoryFiles/characterBuffer80x60.mem";

wire [$clog2(640)-1:0]xPixel;
wire [$clog2(480)-1:0]yPixel;
wire pixelDrawing;

VGA_Block
                #
                (
                    .MODES(0) // finixing to 640 x 480 for 80 x60 text buffer
                )
                VGABLOCKIns
                (
                    .systemClk_125MHz(clk),
                    .rst(rst),

                    .xPixel(xPixel),
                    .yPixel(yPixel),
                    .pixelDrawing(pixelDrawing),


                    .hSYNC(hSYNC),
                    .vSYNC(vSYNC)
                );

wire [$clog2(80*60)-1:0]currentCharacterPixelIndex;
wire [$clog2(64)-1:0]characterXY;

TextMode_indexGenerator TMindexGenIns
                (
                    .xPixel(xPixel),
                    .yPixel(yPixel),

                    .currentCharacterPixelIndex(currentCharacterPixelIndex),
                    .characterXY(characterXY)
                );

wire [$clog2(CHARACTER_SET_COUNT)-1:0]currentCharacterIndex;

TextMode_textBuffer80x60
                #
                (
                    .CHARACTER_SET_COUNT(CHARACTER_SET_COUNT),
                    .MEMFILELOC(CHARACTER_BUFFER_MEMLOC)
                )
                TMtextBuffIns
                (
                    .clk(clk),
                    .enable(1),
                    .write_enable(0),
                    .inputData(0),

                    .currentCharacterPixelIndex_addressIn(currentCharacterPixelIndex),

                    .currentCharacterIndex_dataOut(currentCharacterIndex)
                );

wire [64-1:0]currentCharacter;

TextMode_characterROM
                #
                (
                    .CHARACTER_SET_COUNT(CHARACTER_SET_COUNT),
                    .MEMFILELOC(CHARACTER_ROM_MEMLOC)
                )
                TMcharacterROMIns
                (
                    .clk(clk),
                    .enable(1),

                    .chracterIndex_addressIn(currentCharacterIndex),
                    .currentCharacter_dataOut(currentCharacter)
                );

wire [16-1:0]currentPixel;
assign currentPixel = (pixelDrawing == 1) ? 16'h0000 | {16{currentCharacter[characterXY]}} : 0;

assign R = (pixelDrawing) ? currentPixel[15:11] : 0;
assign G = (pixelDrawing) ? currentPixel[10:5] : 0;
assign B = (pixelDrawing) ? currentPixel[4:0] : 0;

endmodule
