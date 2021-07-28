`timescale 1ns / 1ps

module ImageMemory
                #
                (
                    parameter IMAGE_WIDTH = 400,
                    parameter IMAGE_HEIGHT = 200,
                    parameter RGBFormat = 0,
                    
                    parameter RAMWIDTH = ((RGBFormat == 0) ? 16 : ((RGBFormat==1)? 8 : 24)),
                    parameter RAMADDBITS = $clog2(IMAGE_HEIGHT*IMAGE_WIDTH),
                    parameter INIT_END_ADDR = IMAGE_WIDTH*IMAGE_HEIGHT
                )
                (
                    input wire clk,
                    input wire enable,
                    input wire write_enable,
                    input wire [RAMADDBITS-1:0]address,
                    input wire [RAMWIDTH-1:0]inputData,
                    output reg [RAMWIDTH-1:0]outputData
                );


localparam MEMFILELOC = "/mnt/18C846EDC846C928/vga_controller/ImageMemoryFile/MemoryFile.mem";

(* RAM_STYLE="BLOCK" *)
 reg [RAMWIDTH-1:0]REGMEM[0:(2**RAMADDBITS)-1];


initial 
        $readmemh(MEMFILELOC, REGMEM, 0, INIT_END_ADDR);

always @(posedge clk) 
    begin
        if (enable == 1) 
            begin
                if(write_enable == 1)
                    REGMEM[address] = inputData;
                outputData <= REGMEM[address];
            end
    end
endmodule
