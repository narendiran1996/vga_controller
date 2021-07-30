`timescale 1ns / 1ps

module TextMode_textBuffer80x60
                #
                (
                    parameter CHARACTER_SET_COUNT = 20,
                    parameter MEMFILELOC = "/mnt/18C846EDC846C928/vga_controller/ImageMemoryFile/MemoryFile.mem"
                )
                (
                    input wire clk,
                    input wire enable,
                    input wire write_enable,
                    input wire [$clog2(CHARACTER_SET_COUNT)-1:0]inputData,

                    input wire [$clog2(80*60)-1:0]currentCharacterPixelIndex_addressIn,

                    output reg [$clog2(CHARACTER_SET_COUNT)-1:0]currentCharacterIndex_dataOut
                );



(* RAM_STYLE="BLOCK" *)
reg [$clog2(CHARACTER_SET_COUNT)-1:0]REGMEM[0:(80*60)-1];

initial 
    $readmemh(MEMFILELOC, REGMEM);

always @(posedge clk) 
    begin
        if (enable == 1) 
            begin
                if(write_enable == 1)
                    REGMEM[currentCharacterPixelIndex_addressIn] = inputData;
                currentCharacterIndex_dataOut <= REGMEM[currentCharacterPixelIndex_addressIn];
            end
    end
endmodule

