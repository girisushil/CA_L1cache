`include "/Users/sushilhome/Desktop/CA_Prject_Final/Cache.v"
`include "/Users/sushilhome/Desktop/CA_Prject_Final/Mem.v"

`timescale 1ns / 1ps

module System;
  reg clk;

  wire [31:0] data_in;
  wire [7:0] counteraddr;
  wire [31:0] data_out;
  wire [31:0] read_address;
  wire        rd_en;
  wire [31:0] write_address;
  wire        wr_en;
  wire validbit;
  wire readybit;
  reg  [31:0] input_address = 0;
  reg  [31:0] input_data = 0;
  reg         loadinstruction = 0;
  reg         storeinstuction = 0;
  wire        cmissstatus;
  wire [31:0] output_data;

  LCache cache_obj (
    .clk(clk),
    .addr(input_address),
    .data_in(input_data),
    .loadins(loadinstruction),
    .storeins(storeinstuction),
    .cache_miss(cmissstatus),
    .datcacpu(output_data),
    .datcamem(data_in),
    .readaddrmem(read_address),
    .read_enable(rd_en),
    .writeaddrmem(write_address),
    .write_enable(wr_en),
    .memdata(data_out),
    .Valid_signal(validbit),
    .ready_signal(readybit),
    .counteraddr(counteraddr)
  );

  defparam cache_obj.CACHE_SIZE = 2*1024;
  defparam cache_obj.SET_ASSOCIATIVITY = 4;
  defparam cache_obj.NUM_SETS = 16;
  defparam cache_obj.LINE_SIZE = 32;
  defparam cache_obj.ADDR_WIDTH = 32;

  mem mem_obj (
    .clk(clk),
    .data(data_in),
    .read_address(read_address),
    .read_en(rd_en),
    .write_address(write_address),
    .write_en(wr_en),
    .out_data(data_out),
    .Valid_signal(validbit),
    .ready_signal(readybit),
    .counteraddr(counteraddr)
  );

  defparam mem_obj.MEM_SIZE = 8*1024;
  defparam mem_obj.MEM_WRD = 4;
  defparam mem_obj.NO_LOC=2048;
  defparam mem_obj.FILE = "";

  integer i;
  initial
  begin
  $dumpfile("Waveform.vcd");
  $dumpvars(0,System);
  
  end
  always
    begin

     

      // This should be a miss
#100;
      input_address <= {29'b0,3'b000};
      input_data <= 2;
      loadinstruction <= 1;
      storeinstuction <= 0;
     

      # 500; // This should be a hit

        input_address <= {29'b0,3'b100};
      input_data <= 2;
      loadinstruction <= 1;
      storeinstuction <= 0;

      //  # 900; // This should be a hit

      //   input_address <= {28'b0,4'b1001};
      // input_data <= 2;
      // loadinstruction <= 1;
      // storeinstuction <= 0;
      #600;

    //   input_address <= 32'h00000008;
    //   input_data <= 32'hBADDBEEF;
    //   loadinstruction <= 0;
    //   storeinstuction <= 1;

    //   # 300; // This should be a miss
    //    input_address <= {31'b0,1'b1};
    //   input_data <= 3;
    //   loadinstruction <= 1;
    //   storeinstuction <= 0;

    //   #400;
    //   input_address <= {30'b0,4'b1011};
    //   input_data <= 3;
    //   loadinstruction <= 1;
    //   storeinstuction <= 0;
      



    //   input_address <= 32'h10000008;
    //   input_data <= 0;
    //   loadinstruction <= 1;
    //   storeinstuction <= 0;

    //   # 100; // This should be a miss

//       input_address <= 32'h20000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss

//       input_address <= 32'h30000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss and eviction

//       input_address <= 32'h40000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss (evicted)

//       input_address <= 32'h00000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a hit

//       input_address <= 32'h30000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss

      

//       input_address <= 32'h00000008;
//       input_data <= 32'hBADDBEEF;
//       loadinstruction <= 0;
//       storeinstuction <= 1;

// # 100; // This should be a hit
//       input_address <= 32'h00000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

      

//       # 100; // This should be a hit

//       input_address <= 32'h0000000B;
//       input_data <= 32'h00000000;
//       loadinstruction <= 0;
//       storeinstuction <= 1;

//       # 100; // This should be a hit

//       input_address <= 32'h0000000C;
//       input_data <= 32'hAAAAAAAA;
//       loadinstruction <= 0;
//       storeinstuction <= 1;

//       # 100; // This should be a miss

//       input_address <= 32'h10000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss

//       input_address <= 32'h00000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss

//       input_address <= 32'h30000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss and eviction

//       input_address <= 32'h40000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss (evicted)

//       input_address <= 32'h00000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a miss

//       input_address <= 32'h10000008;
//       input_data <= 32'hBADDBEEF;
//       loadinstruction <= 0;
//       storeinstuction <= 1;


//       # 100; // This should be a miss

//       input_address <= 32'h00000008;
//       input_data <= 0;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a hit

//       input_address <= 32'h0000000B;
//       input_data <= 32'hBADDBEEF;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a hit

//       input_address <= 32'h0000000C;
//       input_data <= 32'h00000000;
//       loadinstruction <= 1;
//       storeinstuction <= 0;

//       # 100; // This should be a hit

//       input_address <= 32'h0000000F;
//       input_data <= 32'hAAAAAAAA;
//       loadinstruction <= 1;
//       storeinstuction <= 0; 


      $finish;
    end

  initial
  begin
    //$monitor("time=%3d, addr=%1b, din=%1b, rden=%1b, wren=%1b, q=%1b, hit_miss=%1b", $time,input_address,input_data,loadinstruction,storeinstuction,output_data,cmissstatus);
    $monitor("time=%4d | Input Address=%10d | Hit=%b | Output_data to CPU=%08x | valid bit=%b | ready bit=%b" ,$time,input_address,cmissstatus,cache_obj.datcacpu,validbit,readybit);
  end
 
  always
    begin
      clk = 1'b1;
      #5;
      clk = 1'b0;
      #5;
    end
   
endmodule