module LCache (
  input wire clk,  // Clock
  input  wire loadins, // 1 if ld instruction from cpu in testbecnh
  input  wire storeins, // 1 if st instruction from cpu in testbench
  input wire [31:0] addr, // Memory addr from cpu
  input wire [31:0] data_in, // Data to be written
  input wire [7:0] counteraddr, // counter for stoering dadat
  output wire write_enable, // Write enable signal   KEEP A LOOK AT THIS IF ANYTHING WRONG GOES HERE IN FILE
  output wire read_enable,// Read enable signal
  input  wire [31:0] memdata, // data coming from memory/memdata
  output wire [31:0] datcacpu, // dataflow cache to testbench/cpu/q
  output wire [31:0] datcamem, // dataflow cache to mem/mdout
  input wire ready_signal, // ready signal from slave maon memory
  output wire Valid_signal, // valid signal transferred from cache to slave
  output wire [31:0] writeaddrmem,  // writing addr in memeory
  output wire [31:0] readaddrmem, // reading addr in memory
  output wire cache_miss
);

 // Parameters for the cache
  parameter CACHE_SIZE = 2 * 1024; // Cache size in bytes (2KB)
  parameter LINE_SIZE = 32;        // Cache line size in bytes (32 bytes)
  parameter WORD_SIZE = 4;         // Processor word size in bytes (4 bytes)
  parameter ADDR_WIDTH = 32;       // 32-bit addr format
  parameter SET_ASSOCIATIVITY =4;
  parameter NUM_SETS = CACHE_SIZE / (LINE_SIZE * SET_ASSOCIATIVITY);
  parameter INDEX_WIDTH = $clog2(CACHE_SIZE / (LINE_SIZE * SET_ASSOCIATIVITY));
  parameter OFFSET_WIDTH = $clog2(LINE_SIZE/WORD_SIZE);
  parameter TAG_WIDTH = 32 - INDEX_WIDTH - OFFSET_WIDTH;

        // Internal registers
//   cache memory
 reg [(LINE_SIZE*8)-1:0] cache_data1[0:NUM_SETS-1];
 reg [(LINE_SIZE*8)-1:0] cache_data2 [0:NUM_SETS-1];
 reg [(LINE_SIZE*8)-1:0] cache_data3 [0:NUM_SETS-1];
 reg [(LINE_SIZE*8)-1:0] cache_data4 [0:NUM_SETS-1];
 reg [TAG_WIDTH-1:0] tag [0:SET_ASSOCIATIVITY-1][0:NUM_SETS-1]; // tag associated with the sets in cache block
 reg valid [0:SET_ASSOCIATIVITY-1][0:NUM_SETS-1]; // valid bit indicating the filling of memory at each addr
 integer i,j;
 
  initial
  for(i=0;i<SET_ASSOCIATIVITY;i=i+1)begin
    for(j=0;j<NUM_SETS;j=j+1)begin
        valid[i][j]=0;
    end
  end

 reg cmiss=1'b0;
  reg [31:0] datcpu={32{1'b0}};
  reg [31:0] dcachemem= {32{1'b0}};
  reg [31:0] memwraddr={32{1'b0}};
  reg wenable=1'b0;
  reg [2:0] temp;
  integer ctemp;
  reg vsig=1'b1;
  reg [31:0] tdat;
  reg [31:0] decompress_data;

// output assignments of internal registers
assign cache_miss = cmiss;
assign read_enable = !((valid[0][addr[6:3]] && (tag[0][addr[6:3]] == addr[31:7])) ||  (valid[1][addr[6:3]] && (tag[1][addr[6:3]] == addr[31:7])) ||  (valid[2][addr[6:3]] && (tag[2][addr[6:3]] == addr[31:7])) ||  (valid[3][addr[6:3]] && (tag[3][addr[6:3]] == addr[31:7])));
assign write_enable = wenable;
assign datcamem = dcachemem;
assign readaddrmem = {addr[31:7],addr[6:3],3'b000};
assign writeaddrmem = memwraddr;
assign datcacpu = datcpu;
assign Valid_signal=vsig;

// cases for considering miss and hit
reg receivereq=1'b1;
always @(posedge clk)
begin	
	if(receivereq)begin
			// reseting the write enable signal to zero
			wenable <= 0;
            temp=addr[2:0];
            $display("Offset value is: %10d",temp);
			// set cmiss register
			cmiss <= ((valid[0][addr[6:3]] && (tag[0][addr[6:3]] == addr[31:7])) ||  (valid[1][addr[6:3]] && (tag[1][addr[6:3]] == addr[31:7])) ||  (valid[2][addr[6:3]] && (tag[2][addr[6:3]] == addr[31:7])) ||  (valid[3][addr[6:3]] && (tag[3][addr[6:3]] == addr[31:7])));
			// invalid input given with no write and no read
			if(~loadins && ~storeins) receivereq<=1;

			else if(tag[0][addr[6:3]] == addr[31:7])
			begin
				// read hit
				if(loadins) datcpu <=cache_data1[addr[6:3]][(31+temp*31)-:32];
				// write hit
				else if(storeins)
				begin
					datcpu = {32{1'b0}};
					cache_data1[addr[6:3]][(31+temp*31)-:32] <= data_in;
					
				end
			end
			
			
			else if(tag[1][addr[6:3]] == addr[31:7])
			begin
				// read hit
				if(loadins) datcpu<=cache_data2[addr[6:3]][(31+temp*31)-:32];
				// write hit
				else if(storeins)
				begin
					datcpu = {32{1'b0}};
					cache_data2[addr[6:3]][(31+temp*31)-:32] <= data_in;
					
				end
			end
			
			
			else if(tag[2][addr[6:3]] == addr[31:7])
			begin
				// read hit
				if(loadins) datcpu <= cache_data3[addr[6:3]][(31+temp*31)-:32];
				// write hit
				else if(storeins)
				begin
					datcpu = {32{1'b0}};
					cache_data3[addr[6:3]][(31+temp*31)-:32] <= data_in;
					
				end
			
			end
			
			
			else if(tag[3][addr[6:3]] == addr[31:7])
			begin
				// read hit
				if(loadins) datcpu <=cache_data4[addr[6:3]][(31+temp*31)-:32];
				// write hit
				else if(storeins)
				begin
					datcpu = {32{1'b0}};
					cache_data4[addr[6:3]][(31+temp*31)-:32] <= data_in;
					
				end
			end
			
			// miss 
			else receivereq <= 1'b0;
		end
	
		else begin
			// miss block 
			if(~valid[0][addr[6:3]]  )
			begin
                // if(ready_signal)begin
                    

                 // integer ctemp;
                 
                $display("Inside Block 1");
                // // while(counteraddr<8)begin
                    $display("!!!!!!!!The out data from memory is : %10d",memdata);
                decompress_data<=memdata;
                ctemp<=decompress_data[31:28];
                tdat<={4'b0000,decompress_data[27:0]};
                $display("The value of received data is : %10d",tdat);
                $display("The value of received count of respective data received is : %10d",ctemp);
                for(integer s=0;s<ctemp;s=s+1)begin
                cache_data1[addr[6:3]][(31+(s)*31)-:32]<=tdat;
                $display("The corresponding uncomoressed data for 8 4bytes is : %10d",tdat);
                end
                // // end
               
                
				
                // // end
                // tag[0][addr[6:3]] <= addr[31:7];
                // valid[0][addr[6:3]] <= 1;
                // cache_data1[addr[6:3]] <= memdata;
            
				
				tag[0][addr[6:3]] <= addr[31:7];
				valid[0][addr[6:3]] <= 1;
               
			end

			else if(~valid[1][addr[6:3]] )
			begin
                
                // if(ready_signal)begin
                    
                $display("Inside Block 2");
                // // while(counteraddr<8)begin
                  
                decompress_data<=memdata;
                ctemp<=decompress_data[31:28];
                tdat<={4'b0000,decompress_data[27:0]};
                $display("The value of received data is : %10d",tdat);
                $display("The value of received count of respective data received is : %10d",ctemp);
                for(integer s=0;s<ctemp;s=s+1)begin
                cache_data2[addr[6:3]][(31+(s)*31)-:32]<=tdat;
                $display("The corresponding uncomoressed data for 8 4bytes is : %10d",tdat);
                end
                
                // // end
                // // integer ctemp;
                
                // // end
                
				// tag[1][addr[6:3]] <= addr[31:7];
				// valid[1][addr[6:3]] <= 1;
                // cache_data2[addr[6:3]] <= memdata;
            
				
				tag[1][addr[6:3]] <= addr[31:7];
				valid[1][addr[6:3]] <= 1;
			end

			else if(~valid[2][addr[6:3]])
			begin
                // integer ctemp;
                
                // if(ready_signal)begin
                    
                
                $display("Inside Block 3");
                // // while(counteraddr<8)begin
                decompress_data<=memdata;
                ctemp<=decompress_data[31:28];
                tdat<={4'b0000,decompress_data[27:0]};
                $display("The value of received data is : %10d",tdat);
                $display("The value of received count of respective data received is : %10d",ctemp);
                for(integer s=0;s<ctemp;s=s+1)begin
                cache_data3[addr[6:3]][(31+(s)*31)-:32]<=tdat;
                $display("The corresponding uncomoressed data for 8 4bytes is : %10d",tdat);
                end
                
                // // end
                
                // // end
                
				// tag[2][addr[6:3]] <= addr[31:7];
				// valid[2][addr[6:3]] <= 1;
                // cache_data3[addr[6:3]] <= memdata;
            
				
				tag[2][addr[6:3]] <= addr[31:7];
				valid[2][addr[6:3]] <= 1;
			end

			else if(~valid[3][addr[6:3]] )
			begin

                // integer ctemp;
           
                // if(ready_signal)begin
                    
                
                $display("Inside Block 4");
                // // while(counteraddr<8)begin
                decompress_data<=memdata;
                ctemp<=decompress_data[31:28];
                tdat<={4'b0000,decompress_data[27:0]};
                $display("The value of received data is : %10d",tdat);
                $display("The value of received count of respective data received is : %10d",ctemp);
                for(integer s=0;s<ctemp;s=s+1)begin
                cache_data4[addr[6:3]][(31+(s)*31)-:32]<=tdat;
                $display("The corresponding uncomoressed data for 8 4bytes is : %10d",tdat);
                end
                
                // // end
                
                // // end
               
				// tag[3][addr[6:3]] <= addr[31:7];
				// valid[3][addr[6:3]] <= 1;
                // cache_data4[addr[6:3]] <= memdata;
            
				
				tag[3][addr[6:3]] <= addr[31:7];
				valid[3][addr[6:3]] <= 1;
			end
            else receivereq <= 1'b1;
		end


end

endmodule
