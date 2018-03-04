/*********************************************************************************************

    File name   : sram.v
    Author      : Lee Baker
    Affiliation : North Carolina State University, Raleigh, NC
    Date        : Oct 2017
    email       : lbbaker@ncsu.edu

    Description : Generic SRAM 


*********************************************************************************************/
    
//`timescale 1ns/10ps

module sram     #(parameter  ADDR_WIDTH      = 8   ,
                  parameter  DATA_WIDTH      = 16  )
                (
                //---------------------------------------------------------------
                // 
                input  wire [ADDR_WIDTH-1:0  ]  address     ,
                input  wire [DATA_WIDTH-1:0  ]  write_data  ,
                output reg  [DATA_WIDTH-1:0  ]  read_data   ,
                input  wire                     enable      , 
                input  wire                     write       ,

                input  clock
                );


    //--------------------------------------------------------
    // Associative memory

    bit  [DATA_WIDTH-1 :0  ]     mem     [int] = '{default: 'X};


    //--------------------------------------------------------
    // Read

    always @(*)
      begin
        #4 read_data   =  (enable && ~write) ? mem [address] :
                                               16'hx         ; 
      end

    //--------------------------------------------------------
    // Write

    always @(posedge clock)
      begin
        if (enable && write)
          mem [address] = write_data ;
      end
    //--------------------------------------------------------


endmodule


