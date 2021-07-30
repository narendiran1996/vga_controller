`timescale 1ns / 1ps

module TextMode_characterROM
                #
                (
                    parameter CHARACTER_SET_COUNT = 27,
                    parameter MEMFILELOC = ""
                )
                (
                    input wire clk,
                    input wire enable,

                    input wire [$clog2(CHARACTER_SET_COUNT)-1:0]chracterIndex_addressIn,
                    output reg [64-1:0]currentCharacter_dataOut
                );

(* RAM_STYLE="BLOCK" *)
reg [64-1:0]REGMEM[0:(CHARACTER_SET_COUNT)-1];

initial 
    $readmemb(MEMFILELOC, REGMEM);

always @(posedge clk) 
    begin
        if (enable == 1) 
            begin
                currentCharacter_dataOut <= REGMEM[chracterIndex_addressIn];
            end
    end

endmodule
