module mem
#(
    parameter MEM_SIZE=8*1024,
    parameter MEM_WRD=4,
  parameter NO_LOC = MEM_SIZE/MEM_WRD,
  parameter FILE = ""
)
(
  input  wire                 clk,
  input  wire                 read_en,
  input  wire                 write_en,
  input  wire [31:0] write_address,
  input  wire [31:0]     data,
  input  wire [31:0] read_address,
  input wire Valid_signal,
  output wire ready_signal,
  output wire [7:0] counteraddr,
  output reg  [31:0]     out_data
);

 // memory instantiation
  reg [31:0] memory [0:NO_LOC-1] ;
  reg rsig=1'b1;
  integer i;
  reg [31:0] value_holder_compress;
  // reg [3:0]count=4'b0001;
  integer tempadrs;
  assign ready_signal=rsig;
  reg [7:0] caddr;
  reg [31:0] datarray[0:7];
  reg [3:0] count=4'b0000;
  reg [31:0] current_byte=31'b0;
  
   initial
    begin
      // write sll dsts from file to memory data array
      if (FILE != "")
        
        $readmemh(FILE, memory);

      // intialize to zero if no file provided
      else
        for (i = 8; i < NO_LOC; i = i + 1)
          memory[i] = {31{1'b0}};
        for (integer s=0;s<8;s=s+1)begin
          memory[s]=60;
        end
        for(integer s=4;s<8;s=s+1)begin
        memory[s]=62;
        end
        memory[2]=58;
        memory[4]=61;
        memory[7]=59;
        memory[3]=63;

   end

    always @ (posedge clk)
  begin
    if (write_en) begin
        
            $display("Hello in writing block in mem");
            
            $display("Hello vsignal output %b",rsig);
      memory[write_address] <= data;
      
      
    
    end
    
  end
// the permissible error magnitude is taken as 4
  always @ (posedge clk)
  begin
    if (read_en)begin
      if(read_address<NO_LOC)begin
      
      
        // if(Valid_signal)begin
          
          $display("Hello in reading block in mem");
        tempadrs<=read_address;
         $display("The read address is as follows: %10d",tempadrs);
        // for(integer k=0;k<8;k=k+1)begin
        //   datarray[k]<=memory[tempadrs+k];
        //   $display("Element inserted in array is : %10d",memory[tempadrs+k]);
        // end
        current_byte=memory[tempadrs];
        $display("the current byte is : %10d",current_byte);
        $display("The count vsariable is : %10d",count);
        if (count < 8) begin
           $display("The count vsariable is in cycle issssssss : %10d",count);
        // Counting phase
        if ((memory[tempadrs+count] >= (current_byte - 0)) && (memory[tempadrs+count] <= (current_byte + 0))) begin
          $display("The data to be compressed : %10d",memory[tempadrs+count]);
          count <= count + 1;
          $display("The count vsariable is in cycle 2222iss1w11wssssss : %10d",count);
        end 
        else begin
          count <= 4'b0001;
          current_byte <= memory[tempadrs+count];
        end
      end 
      if(count>=0)begin
        // Output compressed data
        $display("The coiunt of data is : %10d",count);
        $display("The curent byt stored and transgfered wit the cout is : %10d",current_byte);
        out_data <= {count, current_byte[27:0]};
        
        count <= 0;
        current_byte <= 32'b0;
      end

        // rle_compression instance(
        //   .data_in(datarray),
        //   .compressed_data(out_data));

        // $display("The accessed memory location for compression is : %10d",tempadrs);
        // value_holder_compress<=memory[tempadrs];
        
        // // caddr<=0;
        // for(integer i=1;i<8;i=i+1)begin
        //   if(memory[tempadrs+i]<=(value_holder_compress+4) && memory[tempadrs+i]>=(value_holder_compress-4))begin
        //     // $display("INside the for loop !!!!!!!!!");
        //     $display("the value inside loop currently foing on is : %10d",memory[tempadrs+i]);
        //     count=count+1;
        //   end
        // end
        // out_data <= {count,value_holder_compress[27:0]};

        
        //   // else begin
        //   // out_data<={count,value_holder_compress[27:0]};
        //   // caddr<=i;
        //   // value_holder_compress<=memory[tempadrs+i];
        //   // count<=4'b0001;
          
        //   end
        //   $display("The value of count is: %10d",count);
        //   out_data<={count,value_holder_compress[27:0]};

        // // end
        
        // // rsig<=0;
        // // $display("The value issssssssss ready: %10d",ready_signal);
        // end
      end
      else if(read_address>NO_LOC)begin
      $display("The address fetched is out of scope of defined memory");
      end
    
    end
  end
// counteraddr <=caddr;
endmodule