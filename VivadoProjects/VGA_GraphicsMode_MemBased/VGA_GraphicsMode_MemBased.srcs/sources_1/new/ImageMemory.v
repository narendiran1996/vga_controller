`timescale 1ns / 1ps

module ImageMemory
                #
                (
                    parameter IMAGE_WIDTH = 320,
                    parameter IMAGE_HEIGHT = 240,
                    parameter RGBFormat = 1
                )
                (
                    input wire clk,
                    input wire rst,

                    input wire [$clog2(IMAGE_HEIGHT*IMAGE_WIDTH)-1:0]address,
                    output reg [(RGBFormat == 0) ? 16 : ((RGBFormat==1)? 8 : 24)-1:0]dataOut
                );


localparam MEMFILELOC = "/mnt/18C846EDC846C928/vga_controller/ImageMemoryFile/MemoryFile.mem";

(* RAM_STYLE="BLOCK" *)
 reg [(RGBFormat == 0) ? 16 : ((RGBFormat==1)? 8 : 24)-1:0]REGMEM[0:(IMAGE_HEIGHT*IMAGE_WIDTH)-1];


initial 
    begin
        $readmemh(MEMFILELOC, REGMEM);
    end

always @(posedge clk) 
    begin
        if (rst == 1) 
            begin
                dataOut <= 0;
            end
        else
            begin
                dataOut <= REGMEM[address];
            end
    end
endmodule
