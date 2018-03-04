//---------------------------------------------------------------------------
// synopsys translate_off
//  /~|-
`include "/afs/eos.ncsu.edu/dist/synopsys2013/syn/dw/sim_ver/DW02_mac.v"  // link to designware Multiplier module   --> "/afs/eos.ncsu.edu/dist/synopsys2013/syn/dw/sim_ver/DW02_mult.v"
// synopsys translate_on
//---------------------------------------------------------------------------
// DUT

module MyDesign (

            //---------------------------------------------------------------------------
            // Control
            //
            output reg                  dut__xxx__finish   ,                             // High when DUT is ready for a 'go'. Deassert after 'go'  
            input  wire                 xxx__dut__go       ,                             // Pulsed

            //---------------------------------------------------------------------------
            // b-vector memory 
            //
            output reg  [ 9:0]          dut__bvm__address  ,                             
            output reg                  dut__bvm__enable   ,                             // High for read
            output reg                  dut__bvm__write    ,                             // Low  for read
            output reg  [15:0]          dut__bvm__data     ,  // write data
            input  wire [15:0]          bvm__dut__data     ,  // read data (do not use?)
            
            //---------------------------------------------------------------------------
            // Input data memory 
            //
            output reg  [ 8:0]          dut__dim__address  ,
            output reg                  dut__dim__enable   ,                             // High for Read and Write
            output reg                  dut__dim__write    ,                             // High for Write
            output reg  [15:0]          dut__dim__data     ,  // write data
            input  wire [15:0]          dim__dut__data     ,  // read data


            //---------------------------------------------------------------------------
            // Output data memory 
            //
            output reg  [ 2:0]          dut__dom__address  ,
            output reg  [15:0]          dut__dom__data     ,  // write data
            output reg                  dut__dom__enable   ,                             // High for Write
            output reg                  dut__dom__write    ,                             // High for Write


            //-------------------------------
            // General
            //
            input  wire                 clk             ,
            input  wire                 reset                                            // Active High

            );

  //---------------------------------------------------------------------------
  //
  //<<<<----  YOUR CODE HERE    ---->>>>
  //
  //`include "v564.vh"
  // 
  //---------------------------------------------------------------------------

/* Initializations */
reg [9:0] clockCount;                                //This counts no of clock cycles that have been finished after the last reset
wire [15:0] zReg0,  zReg1,  zReg2,  zReg3,  zReg4,  zReg5,  zReg6,  zReg7,  zReg8,  zReg9,  zReg10, zReg11, zReg12, zReg13, zReg14, zReg15,  //These are the 64 output vectors from step-1
            zReg16, zReg17, zReg18, zReg19, zReg20, zReg21, zReg22, zReg23, zReg24, zReg25, zReg26, zReg27, zReg28, zReg29, zReg30, zReg31,
            zReg32, zReg33, zReg34, zReg35, zReg36, zReg37, zReg38, zReg39, zReg40, zReg41, zReg42, zReg43, zReg44, zReg45, zReg46, zReg47,
            zReg48, zReg49, zReg50, zReg51, zReg52, zReg53, zReg54, zReg55, zReg56, zReg57, zReg58, zReg59, zReg60, zReg61, zReg62, zReg63;
reg flag1, flag2, flag3, flag4;                     //flag1 signals start of quadrant1, flag 2 is for quadrant2 and so on.

reg [15:0] mReg;                                    // One m-register is used to store the 'm' values from the filter memeory
reg [31:0] oTemp;                                   // Temporary register used to calculate the final output values
reg [15:0] zTemp;                                   // This register temporarily stores the value of 'z' and passes it onto the MAC as input                                 
wire[31:0] oMac;                                    // Wire Output from MAC. Found as 'w' vector in project description
reg [15:0] oReg [7:0];                              // These contain final output values of 'o'. These are stored in SRAM.




/* Main Code */

// Starting code for interfaces
always@(posedge clk)                                
begin
  //Synchronous Reset Logic
  if(reset)                                   //If reset is high, disable everything. Only assert 'finish' signal which in turn asserts 'go' signal
    begin
      dut__xxx__finish <= 1'b1;               
      dut__bvm__enable <= 1'b0;
      dut__dim__enable <= 1'b0;
      dut__dom__enable <= 1'b0;
      clockCount       <= 10'h000;
    end

  else //if(!reset)
   begin
     clockCount <= clockCount + 1'h1;          // Keeps track of no. of clock cycles after a 'go' or reset. Important line  
     if(xxx__dut__go)                          // If 'go' is high, then we start our main code.
       begin
         clockCount       <= 10'h000;          // If this is not done the upcoming hard-coded logic fails as many cycles may pass between reset and xxx__dut__go
         dut__xxx__finish <= 1'b0;             // Stops 'go' from getting 'set' again
         dut__bvm__enable <= 1'b1;             // Enable filter memory
         dut__dim__enable <= 1'b1;             // Enable input memory
         dut__dom__enable <= 1'b0;             // Keep output memory disabled as it is still not needed
         dut__dim__write  <= 1'b0;             // We do not want to write to input or filter SRAM in this program
         dut__bvm__write  <= 1'b0;
       end
     else //if(!xxx__dut_go)
       begin 

       end
   end                
  

// Input Address requst	
 
 if(dut__dim__enable)                        
 begin
  case(clockCount) 
   //Quadrant 1 input fetch
   10'h000: begin       flag1 <= 1'h1;       //Quadrant-1 enabled
            dut__dim__address <= 16'h0000;   //Send first Flip-Flopped input to first SRAM
            dut__dim__enable  <= 1'b1;       //Redundant
            end
   10'h001: dut__dim__address <= 16'h0001;   //Keep fetching addresses at every clock count like this. Eg - a00 is brought in from clockCount=0 to 8 and so on
   10'h002: dut__dim__address <= 16'h0002;
   10'h003: dut__dim__address <= 16'h0010;
   10'h004: dut__dim__address <= 16'h0011;
   10'h005: dut__dim__address <= 16'h0012;
   10'h006: dut__dim__address <= 16'h0020;
   10'h007: dut__dim__address <= 16'h0021;
   10'h008: dut__dim__address <= 16'h0022;
   10'h009: dut__dim__address <= 16'h0003;
   10'h00A: dut__dim__address <= 16'h0004;
   10'h00B: dut__dim__address <= 16'h0005;
   10'h00C: dut__dim__address <= 16'h0013;
   10'h00D: dut__dim__address <= 16'h0014;
   10'h00E: dut__dim__address <= 16'h0015;
   10'h00F: dut__dim__address <= 16'h0023;
   10'h010: dut__dim__address <= 16'h0024;
   10'h011: dut__dim__address <= 16'h0025;
   10'h012: dut__dim__address <= 16'h0030;
   10'h013: dut__dim__address <= 16'h0031;
   10'h014: dut__dim__address <= 16'h0032;
   10'h015: dut__dim__address <= 16'h0040;
   10'h016: dut__dim__address <= 16'h0041;
   10'h017: dut__dim__address <= 16'h0042;
   10'h018: dut__dim__address <= 16'h0050;
   10'h019: dut__dim__address <= 16'h0051;
   10'h01A: dut__dim__address <= 16'h0052;
   10'h01B: dut__dim__address <= 16'h0033;
   10'h01C: dut__dim__address <= 16'h0034;
   10'h01D: dut__dim__address <= 16'h0035;
   10'h01E: dut__dim__address <= 16'h0043;
   10'h01F: dut__dim__address <= 16'h0044;
   10'h020: dut__dim__address <= 16'h0045;
   10'h021: dut__dim__address <= 16'h0053;
   10'h022: dut__dim__address <= 16'h0054;
   10'h023: dut__dim__address <= 16'h0055; 
   10'h04F: flag1   <=  1'h0;                 //Signal end of quadrant 1 fetch
   //Qudrant 2 input fetch
   10'h050: begin       flag2 <= 1'h1;
            dut__dim__address <= 16'h0006;
            end
   10'h051: dut__dim__address <= 16'h0007;
   10'h052: dut__dim__address <= 16'h0008;
   10'h053: dut__dim__address <= 16'h0016;
   10'h054: dut__dim__address <= 16'h0017;
   10'h055: dut__dim__address <= 16'h0018;
   10'h056: dut__dim__address <= 16'h0026;
   10'h057: dut__dim__address <= 16'h0027;
   10'h058: dut__dim__address <= 16'h0028;
   10'h059: dut__dim__address <= 16'h0009;
   10'h05A: dut__dim__address <= 16'h000A;
   10'h05B: dut__dim__address <= 16'h000B;
   10'h05C: dut__dim__address <= 16'h0019;
   10'h05D: dut__dim__address <= 16'h001A;
   10'h05E: dut__dim__address <= 16'h001B;
   10'h05F: dut__dim__address <= 16'h0029;
   10'h060: dut__dim__address <= 16'h002A;
   10'h061: dut__dim__address <= 16'h002B;
   10'h062: dut__dim__address <= 16'h0036;
   10'h063: dut__dim__address <= 16'h0037;
   10'h064: dut__dim__address <= 16'h0038;
   10'h065: dut__dim__address <= 16'h0046;
   10'h066: dut__dim__address <= 16'h0047;
   10'h067: dut__dim__address <= 16'h0048;
   10'h068: dut__dim__address <= 16'h0056;
   10'h069: dut__dim__address <= 16'h0057;
   10'h06A: dut__dim__address <= 16'h0058;
   10'h06B: dut__dim__address <= 16'h0039;
   10'h06C: dut__dim__address <= 16'h003A;
   10'h06D: dut__dim__address <= 16'h003B;
   10'h06E: dut__dim__address <= 16'h0049;
   10'h06F: dut__dim__address <= 16'h004A;
   10'h070: dut__dim__address <= 16'h004B;
   10'h071: dut__dim__address <= 16'h0059;
   10'h072: dut__dim__address <= 16'h005A;
   10'h073: dut__dim__address <= 16'h005B; 
   10'h09F: flag2   <=  1'h0;
   //Quadrant 3 input fetch
   10'h0A0: begin       flag3 <= 1'h1;
            dut__dim__address <= 16'h0060;
            end
   10'h0A1: dut__dim__address <= 16'h0061;
   10'h0A2: dut__dim__address <= 16'h0062;
   10'h0A3: dut__dim__address <= 16'h0070;
   10'h0A4: dut__dim__address <= 16'h0071;
   10'h0A5: dut__dim__address <= 16'h0072;
   10'h0A6: dut__dim__address <= 16'h0080;
   10'h0A7: dut__dim__address <= 16'h0081;
   10'h0A8: dut__dim__address <= 16'h0082;
   10'h0A9: dut__dim__address <= 16'h0063;
   10'h0AA: dut__dim__address <= 16'h0064;
   10'h0AB: dut__dim__address <= 16'h0065;
   10'h0AC: dut__dim__address <= 16'h0073;
   10'h0AD: dut__dim__address <= 16'h0074;
   10'h0AE: dut__dim__address <= 16'h0075;
   10'h0AF: dut__dim__address <= 16'h0083;
   10'h0B0: dut__dim__address <= 16'h0084;
   10'h0B1: dut__dim__address <= 16'h0085;
   10'h0B2: dut__dim__address <= 16'h0090;
   10'h0B3: dut__dim__address <= 16'h0091;
   10'h0B4: dut__dim__address <= 16'h0092;
   10'h0B5: dut__dim__address <= 16'h00A0;
   10'h0B6: dut__dim__address <= 16'h00A1;
   10'h0B7: dut__dim__address <= 16'h00A2;
   10'h0B8: dut__dim__address <= 16'h00B0;
   10'h0B9: dut__dim__address <= 16'h00B1;
   10'h0BA: dut__dim__address <= 16'h00B2;
   10'h0BB: dut__dim__address <= 16'h0093;
   10'h0BC: dut__dim__address <= 16'h0094;
   10'h0BD: dut__dim__address <= 16'h0095;
   10'h0BE: dut__dim__address <= 16'h00A3;
   10'h0BF: dut__dim__address <= 16'h00A4;
   10'h0C0: dut__dim__address <= 16'h00A5;
   10'h0C1: dut__dim__address <= 16'h00B3;
   10'h0C2: dut__dim__address <= 16'h00B4;
   10'h0C3: dut__dim__address <= 16'h00B5; 
   10'h0EF: flag3   <=  1'h0;
   //Quadrant 4 input fetch
   10'h0F0: begin       flag4 <= 1'h1;
            dut__dim__address <= 16'h0066;
            end
   10'h0F1: dut__dim__address <= 16'h0067;
   10'h0F2: dut__dim__address <= 16'h0068;
   10'h0F3: dut__dim__address <= 16'h0076;
   10'h0F4: dut__dim__address <= 16'h0077;
   10'h0F5: dut__dim__address <= 16'h0078;
   10'h0F6: dut__dim__address <= 16'h0086;
   10'h0F7: dut__dim__address <= 16'h0087;
   10'h0F8: dut__dim__address <= 16'h0088;
   10'h0F9: dut__dim__address <= 16'h0069;
   10'h0FA: dut__dim__address <= 16'h006A;
   10'h0FB: dut__dim__address <= 16'h006B;
   10'h0FC: dut__dim__address <= 16'h0079;
   10'h0FD: dut__dim__address <= 16'h007A;
   10'h0FE: dut__dim__address <= 16'h007B;
   10'h0FF: dut__dim__address <= 16'h0089;
   10'h100: dut__dim__address <= 16'h008A;
   10'h101: dut__dim__address <= 16'h008B;
   10'h102: dut__dim__address <= 16'h0096;
   10'h103: dut__dim__address <= 16'h0097;
   10'h104: dut__dim__address <= 16'h0098;
   10'h105: dut__dim__address <= 16'h00A6;
   10'h106: dut__dim__address <= 16'h00A7;
   10'h107: dut__dim__address <= 16'h00A8;
   10'h108: dut__dim__address <= 16'h00B6;
   10'h109: dut__dim__address <= 16'h00B7;
   10'h10A: dut__dim__address <= 16'h00B8;
   10'h10B: dut__dim__address <= 16'h0099;
   10'h10C: dut__dim__address <= 16'h009A;
   10'h10D: dut__dim__address <= 16'h009B;
   10'h10E: dut__dim__address <= 16'h00A9;
   10'h10F: dut__dim__address <= 16'h00AA;
   10'h110: dut__dim__address <= 16'h00AB;
   10'h111: dut__dim__address <= 16'h00B9;
   10'h112: dut__dim__address <= 16'h00BA;
   10'h113: dut__dim__address <= 16'h00BB; 
   10'h114: dut__dim__enable  <= 1'b0;        //Disable reading or writing to input SRAM
  endcase
 end

 //Fetch filter vector
 if(dut__bvm__enable)
 begin
  case(clockCount) 
   10'h000: begin 
            dut__bvm__address <= 16'h0000;
            dut__bvm__enable  <= 1'b1;
            end 
   10'h001: dut__bvm__address <= 16'h0001;
   10'h002: dut__bvm__address <= 16'h0002;
   10'h003: dut__bvm__address <= 16'h0003;
   10'h004: dut__bvm__address <= 16'h0004;
   10'h005: dut__bvm__address <= 16'h0005;
   10'h006: dut__bvm__address <= 16'h0006;
   10'h007: dut__bvm__address <= 16'h0007;
   10'h008: dut__bvm__address <= 16'h0008;
   10'h009: dut__bvm__address <= 16'h0010;
   10'h00A: dut__bvm__address <= 16'h0011;
   10'h00B: dut__bvm__address <= 16'h0012;
   10'h00C: dut__bvm__address <= 16'h0013;
   10'h00D: dut__bvm__address <= 16'h0014;
   10'h00E: dut__bvm__address <= 16'h0015;
   10'h00F: dut__bvm__address <= 16'h0016;
   10'h010: dut__bvm__address <= 16'h0017;
   10'h011: dut__bvm__address <= 16'h0018;
   10'h012: dut__bvm__address <= 16'h0020;
   10'h013: dut__bvm__address <= 16'h0021;
   10'h014: dut__bvm__address <= 16'h0022;
   10'h015: dut__bvm__address <= 16'h0023;
   10'h016: dut__bvm__address <= 16'h0024;
   10'h017: dut__bvm__address <= 16'h0025;
   10'h018: dut__bvm__address <= 16'h0026;
   10'h019: dut__bvm__address <= 16'h0027;
   10'h01A: dut__bvm__address <= 16'h0028;
   10'h01B: dut__bvm__address <= 16'h0030;
   10'h01C: dut__bvm__address <= 16'h0031;
   10'h01D: dut__bvm__address <= 16'h0032;
   10'h01E: dut__bvm__address <= 16'h0033;
   10'h01F: dut__bvm__address <= 16'h0034;
   10'h020: dut__bvm__address <= 16'h0035;
   10'h021: dut__bvm__address <= 16'h0036;
   10'h022: dut__bvm__address <= 16'h0037;
   10'h023: dut__bvm__address <= 16'h0038;
   10'h13F: begin
               flag4   <=  1'h0;                 //Signals end of last quadrant                

               dut__bvm__address <= 16'h0040;    //Brings in first m-vector
             end 
  endcase

  //Fetching m-vector
  if(clockCount > 10'h13F && clockCount < 10'h33F)
  begin
    dut__bvm__address <= dut__bvm__address + 1'h1;
    mReg              <= bvm__dut__data;
  end
  else if(clockCount == 10'h33F)
  begin
    mReg              <= bvm__dut__data;
    dut__bvm__enable  <= 1'h0;
  end  
end
  //For writing 'o' to SRAM
  case(clockCount)
   10'h33B: begin
              dut__dom__enable <= 1'h1;        //Enable reading or writing to o-SRAM
              dut__dom__write  <= 1'h1;        //Enable Write to SRAM
              dut__dom__address <= 16'h0000;   //Write registered value in oReg to a registered address 16'h0000 in o-SRAM 
              dut__dom__data    <= oReg[0];
            end
   10'h33C: begin
              dut__dom__address <= 16'h0001;
              dut__dom__data    <= oReg[1];
            end
   10'h33D: begin
              dut__dom__address <= 16'h0002;
              dut__dom__data    <= oReg[2];
            end
   10'h33E: begin
              dut__dom__address <= 16'h0003;
              dut__dom__data    <= oReg[3];
            end
   10'h33F: begin
              dut__dom__address <= 16'h0004;
              dut__dom__data    <= oReg[4];
            end
   10'h340: begin
              dut__dom__address <= 16'h0005;
              dut__dom__data    <= oReg[5];
            end
   10'h341: begin
              dut__dom__address <= 16'h0006;
              dut__dom__data    <= oReg[6];
            end
   10'h342: begin
              dut__dom__address <= 16'h0007;
              dut__dom__data    <= oReg[7];
            end
   10'h343: begin
              dut__dom__write   <= 1'h0;
              dut__dom__enable  <= 1'h0;
              dut__xxx__finish  <= 1'h1;
             end 
  endcase
end




/* Instantiation of quadrants q1,q2,q3,q4 */
inputQuadrant q1  
(
.clock          (clk),
.rst            (reset),
.clockCounter   (clockCount),
.aEnable        (dut__dim__enable),
.bEnable        (dut__bvm__enable),
.bvm__dut__data (bvm__dut__data),
.dim__dut__data (dim__dut__data),
.flag           (flag1),                // Start changing here onwards for each quadrant's instantiation
.z0             (zReg0),
.z1             (zReg16),
.z2             (zReg32),
.z3             (zReg48),
.z4             (zReg1),
.z5             (zReg17),
.z6             (zReg33),
.z7             (zReg49),
.z8             (zReg4),
.z9             (zReg20),
.z10            (zReg36),
.z11            (zReg52),
.z12            (zReg5),
.z13            (zReg21),
.z14            (zReg37),
.z15            (zReg53)
);

inputQuadrant q2  
(
.clock          (clk),
.rst            (reset),
.clockCounter   (clockCount),
.aEnable        (dut__dim__enable),
.bEnable        (dut__bvm__enable),
.bvm__dut__data (bvm__dut__data),
.dim__dut__data (dim__dut__data),
.flag           (flag2),             
.z0             (zReg2),
.z1             (zReg18),
.z2             (zReg34),
.z3             (zReg50),
.z4             (zReg3),
.z5             (zReg19),
.z6             (zReg35),
.z7             (zReg51),
.z8             (zReg6),
.z9             (zReg22),
.z10            (zReg38),
.z11            (zReg54),
.z12            (zReg7),
.z13            (zReg23),
.z14            (zReg39),
.z15            (zReg55)
);

inputQuadrant q3  
(
.clock          (clk),
.rst            (reset),
.clockCounter   (clockCount),
.aEnable        (dut__dim__enable),
.bEnable        (dut__bvm__enable),
.bvm__dut__data (bvm__dut__data),
.dim__dut__data (dim__dut__data),
.flag           (flag3),               
.z0             (zReg8),
.z1             (zReg24),
.z2             (zReg40),
.z3             (zReg56),
.z4             (zReg9),
.z5             (zReg25),
.z6             (zReg41),
.z7             (zReg57),
.z8             (zReg12),
.z9             (zReg28),
.z10            (zReg44),
.z11            (zReg60),
.z12            (zReg13),
.z13            (zReg29),
.z14            (zReg45),
.z15            (zReg61)
);

inputQuadrant q4  
(
.clock          (clk),
.rst            (reset),
.clockCounter   (clockCount),
.aEnable        (dut__dim__enable),
.bEnable        (dut__bvm__enable),
.bvm__dut__data (bvm__dut__data),
.dim__dut__data (dim__dut__data),
.flag           (flag4),         
.z0             (zReg10),
.z1             (zReg26),
.z2             (zReg42),
.z3             (zReg58),
.z4             (zReg11),
.z5             (zReg27),
.z6             (zReg43),
.z7             (zReg59),
.z8             (zReg14),
.z9             (zReg30),
.z10            (zReg46),
.z11            (zReg62),
.z12            (zReg15),
.z13            (zReg31),
.z14            (zReg47),
.z15            (zReg63)
);


/*Step-2: Calculation of 'o' */
always@(posedge clk)
begin
  if(clockCount==10'h140)
  begin
    oTemp <= 10'h000;                      //Accumulate of mac needs to zero initially
    zTemp <= zReg0;                        //Used to input z to mac
  end
  else if(clockCount==10'h141 || clockCount==10'h181 || clockCount==10'h1C1 || clockCount==10'h201 || clockCount==10'h241 || clockCount==10'h281 || clockCount==10'h2C1 || clockCount == 10'h301)
  begin                                   //OR gate is used for calculating all 'o' at different times
    oTemp <= oMac;
    zTemp <= zReg1;
  end
  else if(clockCount==10'h142 || clockCount==10'h182 || clockCount==10'h1C2 || clockCount==10'h202 || clockCount==10'h242 || clockCount==10'h282 || clockCount==10'h2C2 || clockCount == 10'h302)
  begin
    oTemp <= oMac;
    zTemp <= zReg2;
  end
  else if(clockCount==10'h143 || clockCount==10'h183 || clockCount==10'h1C3 || clockCount==10'h203 || clockCount==10'h243 || clockCount==10'h283 || clockCount==10'h2C3 || clockCount == 10'h303)
  begin
    oTemp <= oMac;
    zTemp <= zReg3;
  end
  else if(clockCount==10'h144 || clockCount==10'h184 || clockCount==10'h1C4 || clockCount==10'h204 || clockCount==10'h244 || clockCount==10'h284 || clockCount==10'h2C4 || clockCount == 10'h304)
  begin
    oTemp <= oMac;
    zTemp <= zReg4;
  end
  else if(clockCount==10'h145 || clockCount==10'h185 || clockCount==10'h1C5 || clockCount==10'h205 || clockCount==10'h245 || clockCount==10'h285 || clockCount==10'h2C5 || clockCount == 10'h305)
  begin
    oTemp <= oMac;
    zTemp <= zReg5;
  end
  else if(clockCount==10'h146 || clockCount==10'h186 || clockCount==10'h1C6 || clockCount==10'h206 || clockCount==10'h246 || clockCount==10'h286 || clockCount==10'h2C6 || clockCount == 10'h306)
  begin
    oTemp <= oMac;
    zTemp <= zReg6;
  end
  else if(clockCount==10'h147 || clockCount==10'h187 || clockCount==10'h1C7 || clockCount==10'h207 || clockCount==10'h247 || clockCount==10'h287 || clockCount==10'h2C7 || clockCount == 10'h307)
  begin
    oTemp <= oMac;
    zTemp <= zReg7;
  end
  else if(clockCount==10'h148 || clockCount==10'h188 || clockCount==10'h1C8 || clockCount==10'h208 || clockCount==10'h248 || clockCount==10'h288 || clockCount==10'h2C8 || clockCount == 10'h308)
  begin
    oTemp <= oMac;
    zTemp <= zReg8;
  end
  else if(clockCount==10'h149 || clockCount==10'h189 || clockCount==10'h1C9 || clockCount==10'h209 || clockCount==10'h249 || clockCount==10'h289 || clockCount==10'h2C9 || clockCount == 10'h309)
  begin
    oTemp <= oMac;
    zTemp <= zReg9;
  end
  else if(clockCount==10'h14A || clockCount==10'h18A || clockCount==10'h1CA || clockCount==10'h20A || clockCount==10'h24A || clockCount==10'h28A || clockCount==10'h2CA || clockCount == 10'h30A)
  begin
    oTemp <= oMac;
    zTemp <= zReg10;
  end
  else if(clockCount==10'h14B || clockCount==10'h18B || clockCount==10'h1CB || clockCount==10'h20B || clockCount==10'h24B || clockCount==10'h28B || clockCount==10'h2CB || clockCount == 10'h30B)
  begin
    oTemp <= oMac;
    zTemp <= zReg11;
  end
  else if(clockCount==10'h14C || clockCount==10'h18C || clockCount==10'h1CC || clockCount==10'h20C || clockCount==10'h24C || clockCount==10'h28C || clockCount==10'h2CC || clockCount == 10'h30C)
  begin
    oTemp <= oMac;
    zTemp <= zReg12;
  end
  else if(clockCount==10'h14D || clockCount==10'h18D || clockCount==10'h1CD || clockCount==10'h20D || clockCount==10'h24D || clockCount==10'h28D || clockCount==10'h2CD || clockCount == 10'h30D)
  begin
    oTemp <= oMac;
    zTemp <= zReg13;
  end
  else if(clockCount==10'h14E || clockCount==10'h18E || clockCount==10'h1CE || clockCount==10'h20E || clockCount==10'h24E || clockCount==10'h28E || clockCount==10'h2CE || clockCount == 10'h30E)
  begin
    oTemp <= oMac;
    zTemp <= zReg14;
  end
  else if(clockCount==10'h14F || clockCount==10'h18F || clockCount==10'h1CF || clockCount==10'h20F || clockCount==10'h24F || clockCount==10'h28F || clockCount==10'h2CF || clockCount == 10'h30F)
  begin
    oTemp <= oMac;
    zTemp <= zReg15;
  end
  else if(clockCount==10'h150 || clockCount==10'h190 || clockCount==10'h1D0 || clockCount==10'h210 || clockCount==10'h250 || clockCount==10'h290 || clockCount==10'h2D0 || clockCount == 10'h310)
  begin
    oTemp <= oMac;
    zTemp <= zReg16;
  end
  else if(clockCount==10'h151 || clockCount==10'h191 || clockCount==10'h1D1 || clockCount==10'h211 || clockCount==10'h251 || clockCount==10'h291 || clockCount==10'h2D1 || clockCount == 10'h311)
  begin
    oTemp <= oMac;
    zTemp <= zReg17;
  end
  else if(clockCount==10'h152 || clockCount==10'h192 || clockCount==10'h1D2 || clockCount==10'h212 || clockCount==10'h252 || clockCount==10'h292 || clockCount==10'h2D2 || clockCount == 10'h312)
  begin
    oTemp <= oMac;
    zTemp <= zReg18;
  end
  else if(clockCount==10'h153 || clockCount==10'h193 || clockCount==10'h1D3 || clockCount==10'h213 || clockCount==10'h253 || clockCount==10'h293 || clockCount==10'h2D3 || clockCount == 10'h313)
  begin
    oTemp <= oMac;
    zTemp <= zReg19;
  end
  else if(clockCount==10'h154 || clockCount==10'h194 || clockCount==10'h1D4 || clockCount==10'h214 || clockCount==10'h254 || clockCount==10'h294 || clockCount==10'h2D4 || clockCount == 10'h314)
  begin
    oTemp <= oMac;
    zTemp <= zReg20;
  end
  else if(clockCount==10'h155 || clockCount==10'h195 || clockCount==10'h1D5 || clockCount==10'h215 || clockCount==10'h255 || clockCount==10'h295 || clockCount==10'h2D5 || clockCount == 10'h315)
  begin
    oTemp <= oMac;
    zTemp <= zReg21;
  end
  else if(clockCount==10'h156 || clockCount==10'h196 || clockCount==10'h1D6 || clockCount==10'h216 || clockCount==10'h256 || clockCount==10'h296 || clockCount==10'h2D6 || clockCount == 10'h316)
  begin
    oTemp <= oMac;
    zTemp <= zReg22;
  end
  else if(clockCount==10'h157 || clockCount==10'h197 || clockCount==10'h1D7 || clockCount==10'h217 || clockCount==10'h257 || clockCount==10'h297 || clockCount==10'h2D7 || clockCount == 10'h317)
  begin
    oTemp <= oMac;
    zTemp <= zReg23;
  end
  else if(clockCount==10'h158 || clockCount==10'h198 || clockCount==10'h1D8 || clockCount==10'h218 || clockCount==10'h258 || clockCount==10'h298 || clockCount==10'h2D8 || clockCount == 10'h318)
  begin
    oTemp <= oMac;
    zTemp <= zReg24;
  end
  else if(clockCount==10'h159 || clockCount==10'h199 || clockCount==10'h1D9 || clockCount==10'h219 || clockCount==10'h259 || clockCount==10'h299 || clockCount==10'h2D9 || clockCount == 10'h319)
  begin
    oTemp <= oMac;
    zTemp <= zReg25;
  end
  else if(clockCount==10'h15A || clockCount==10'h19A || clockCount==10'h1DA || clockCount==10'h21A || clockCount==10'h25A || clockCount==10'h29A || clockCount==10'h2DA || clockCount == 10'h31A)
  begin
    oTemp <= oMac;
    zTemp <= zReg26;
  end
  else if(clockCount==10'h15B || clockCount==10'h19B || clockCount==10'h1DB || clockCount==10'h21B || clockCount==10'h25B || clockCount==10'h29B || clockCount==10'h2DB || clockCount == 10'h31B)
  begin
    oTemp <= oMac;
    zTemp <= zReg27;
  end
  else if(clockCount==10'h15C || clockCount==10'h19C || clockCount==10'h1DC || clockCount==10'h21C || clockCount==10'h25C || clockCount==10'h29C || clockCount==10'h2DC || clockCount == 10'h31C)
  begin
    oTemp <= oMac;
    zTemp <= zReg28;
  end
  else if(clockCount==10'h15D || clockCount==10'h19D || clockCount==10'h1DD || clockCount==10'h21D || clockCount==10'h25D || clockCount==10'h29D || clockCount==10'h2DD || clockCount == 10'h31D)
  begin
    oTemp <= oMac;
    zTemp <= zReg29;
  end
  else if(clockCount==10'h15E || clockCount==10'h19E || clockCount==10'h1DE || clockCount==10'h21E || clockCount==10'h25E || clockCount==10'h29E || clockCount==10'h2DE || clockCount == 10'h31E)
  begin
    oTemp <= oMac;
    zTemp <= zReg30;
  end
  else if(clockCount==10'h15F || clockCount==10'h19F || clockCount==10'h1DF || clockCount==10'h21F || clockCount==10'h25F || clockCount==10'h29F || clockCount==10'h2DF || clockCount == 10'h31F)
  begin
    oTemp <= oMac;
    zTemp <= zReg31;
  end
  else if(clockCount==10'h160 || clockCount==10'h1A0 || clockCount==10'h1E0 || clockCount==10'h220 || clockCount==10'h260 || clockCount==10'h2A0 || clockCount==10'h2E0 || clockCount == 10'h320)
  begin
    oTemp <= oMac;
    zTemp <= zReg32;
  end
  else if(clockCount==10'h161 || clockCount==10'h1A1 || clockCount==10'h1E1 || clockCount==10'h221 || clockCount==10'h261 || clockCount==10'h2A1 || clockCount==10'h2E1 || clockCount == 10'h321)
  begin
    oTemp <= oMac;
    zTemp <= zReg33;
  end
  else if(clockCount==10'h162 || clockCount==10'h1A2 || clockCount==10'h1E2 || clockCount==10'h222 || clockCount==10'h262 || clockCount==10'h2A2 || clockCount==10'h2E2 || clockCount == 10'h322)
  begin
    oTemp <= oMac;
    zTemp <= zReg34;
  end
  else if(clockCount==10'h163 || clockCount==10'h1A3 || clockCount==10'h1E3 || clockCount==10'h223 || clockCount==10'h263 || clockCount==10'h2A3 || clockCount==10'h2E3 || clockCount == 10'h323)
  begin
    oTemp <= oMac;
    zTemp <= zReg35;
  end
  else if(clockCount==10'h164 || clockCount==10'h1A4 || clockCount==10'h1E4 || clockCount==10'h224 || clockCount==10'h264 || clockCount==10'h2A4 || clockCount==10'h2E4 || clockCount == 10'h324)
  begin
    oTemp <= oMac;
    zTemp <= zReg36;
  end
  else if(clockCount==10'h165 || clockCount==10'h1A5 || clockCount==10'h1E5 || clockCount==10'h225 || clockCount==10'h265 || clockCount==10'h2A5 || clockCount==10'h2E5 || clockCount == 10'h325)
  begin
    oTemp <= oMac;
    zTemp <= zReg37;
  end
  else if(clockCount==10'h166 || clockCount==10'h1A6 || clockCount==10'h1E6 || clockCount==10'h226 || clockCount==10'h266 || clockCount==10'h2A6 || clockCount==10'h2E6 || clockCount == 10'h326)
  begin
    oTemp <= oMac;
    zTemp <= zReg38;
  end
  else if(clockCount==10'h167 || clockCount==10'h1A7 || clockCount==10'h1E7 || clockCount==10'h227 || clockCount==10'h267 || clockCount==10'h2A7 || clockCount==10'h2E7 || clockCount == 10'h327)
  begin
    oTemp <= oMac;
    zTemp <= zReg39;
  end
  else if(clockCount==10'h168 || clockCount==10'h1A8 || clockCount==10'h1E8 || clockCount==10'h228 || clockCount==10'h268 || clockCount==10'h2A8 || clockCount==10'h2E8 || clockCount == 10'h328)
  begin
    oTemp <= oMac;
    zTemp <= zReg40;
  end
  else if(clockCount==10'h169 || clockCount==10'h1A9 || clockCount==10'h1E9 || clockCount==10'h229 || clockCount==10'h269 || clockCount==10'h2A9 || clockCount==10'h2E9 || clockCount == 10'h329)
  begin
    oTemp <= oMac;
    zTemp <= zReg41;
  end
  else if(clockCount==10'h16A || clockCount==10'h1AA || clockCount==10'h1EA || clockCount==10'h22A || clockCount==10'h26A || clockCount==10'h2AA || clockCount==10'h2EA || clockCount == 10'h32A)  
  begin
    oTemp <= oMac;
    zTemp <= zReg42;
  end
  else if(clockCount==10'h16B || clockCount==10'h1AB || clockCount==10'h1EB || clockCount==10'h22B || clockCount==10'h26B || clockCount==10'h2AB || clockCount==10'h2EB || clockCount == 10'h32B)
  begin
    oTemp <= oMac;
    zTemp <= zReg43;
  end
  else if(clockCount==10'h16C || clockCount==10'h1AC || clockCount==10'h1EC || clockCount==10'h22C || clockCount==10'h26C || clockCount==10'h2AC || clockCount==10'h2EC || clockCount == 10'h32C)
  begin
    oTemp <= oMac;
    zTemp <= zReg44;
  end
  else if(clockCount==10'h16D || clockCount==10'h1AD || clockCount==10'h1ED || clockCount==10'h22D || clockCount==10'h26D || clockCount==10'h2AD || clockCount==10'h2ED || clockCount == 10'h32D)
  begin
    oTemp <= oMac;
    zTemp <= zReg45;
  end
  else if(clockCount==10'h16E || clockCount==10'h1AE || clockCount==10'h1EE || clockCount==10'h22E || clockCount==10'h26E || clockCount==10'h2AE || clockCount==10'h2EE || clockCount == 10'h32E)
  begin
    oTemp <= oMac;
    zTemp <= zReg46;
  end
  else if(clockCount==10'h16F || clockCount==10'h1AF || clockCount==10'h1EF || clockCount==10'h22F || clockCount==10'h26F || clockCount==10'h2AF || clockCount==10'h2EF || clockCount == 10'h32F)
  begin
    oTemp <= oMac;
    zTemp <= zReg47;
  end
  else if(clockCount==10'h170 || clockCount==10'h1B0 || clockCount==10'h1F0 || clockCount==10'h230 || clockCount==10'h270 || clockCount==10'h2B0 || clockCount==10'h2F0 || clockCount == 10'h330)
  begin
    oTemp <= oMac;
    zTemp <= zReg48;
  end
  else if(clockCount==10'h171 || clockCount==10'h1B1 || clockCount==10'h1F1 || clockCount==10'h231 || clockCount==10'h271 || clockCount==10'h2B1 || clockCount==10'h2F1 || clockCount == 10'h331)
  begin
    oTemp <= oMac;
    zTemp <= zReg49;
  end
  else if(clockCount==10'h172 || clockCount==10'h1B2 || clockCount==10'h1F2 || clockCount==10'h232 || clockCount==10'h272 || clockCount==10'h2B2 || clockCount==10'h2F2 || clockCount == 10'h332)
  begin
    oTemp <= oMac;
    zTemp <= zReg50;
  end
  else if(clockCount==10'h173 || clockCount==10'h1B3 || clockCount==10'h1F3 || clockCount==10'h233 || clockCount==10'h273 || clockCount==10'h2B3 || clockCount==10'h2F3 || clockCount == 10'h333)
  begin
    oTemp <= oMac;
    zTemp <= zReg51;
  end
  else if(clockCount==10'h174 || clockCount==10'h1B4 || clockCount==10'h1F4 || clockCount==10'h234 || clockCount==10'h274 || clockCount==10'h2B4 || clockCount==10'h2F4 || clockCount == 10'h334)
  begin
    oTemp <= oMac;
    zTemp <= zReg52;
  end
  else if(clockCount==10'h175 || clockCount==10'h1B5 || clockCount==10'h1F5 || clockCount==10'h235 || clockCount==10'h275 || clockCount==10'h2B5 || clockCount==10'h2F5 || clockCount == 10'h335)
  begin
    oTemp <= oMac;
    zTemp <= zReg53;
  end
  else if(clockCount==10'h176 || clockCount==10'h1B6 || clockCount==10'h1F6 || clockCount==10'h236 || clockCount==10'h276 || clockCount==10'h2B6 || clockCount==10'h2F6 || clockCount == 10'h336)
  begin
    oTemp <= oMac;
    zTemp <= zReg54;
  end
  else if(clockCount==10'h177 || clockCount==10'h1B7 || clockCount==10'h1F7 || clockCount==10'h237 || clockCount==10'h277 || clockCount==10'h2B7 || clockCount==10'h2F7 || clockCount == 10'h337)
  begin
    oTemp <= oMac;
    zTemp <= zReg55;
  end
  else if(clockCount==10'h178 || clockCount==10'h1B8 || clockCount==10'h1F8 || clockCount==10'h238 || clockCount==10'h278 || clockCount==10'h2B8 || clockCount==10'h2F8 || clockCount == 10'h338)
  begin
    oTemp <= oMac;
    zTemp <= zReg56;
  end
  else if(clockCount==10'h179 || clockCount==10'h1B9 || clockCount==10'h1F9 || clockCount==10'h239 || clockCount==10'h279 || clockCount==10'h2B9 || clockCount==10'h2F9 || clockCount == 10'h339)
  begin
    oTemp <= oMac;
    zTemp <= zReg57;
  end
  else if(clockCount==10'h17A || clockCount==10'h1BA || clockCount==10'h1FA || clockCount==10'h23A || clockCount==10'h27A || clockCount==10'h2BA || clockCount==10'h2FA || clockCount == 10'h33A)
  begin
    oTemp <= oMac;
    zTemp <= zReg58;
  end
  else if(clockCount==10'h17B || clockCount==10'h1BB || clockCount==10'h1FB || clockCount==10'h23B || clockCount==10'h27B || clockCount==10'h2BB || clockCount==10'h2FB || clockCount == 10'h33B)
  begin
    oTemp <= oMac;
    zTemp <= zReg59;
  end
  else if(clockCount==10'h17C || clockCount==10'h1BC || clockCount==10'h1FC || clockCount==10'h23C || clockCount==10'h27C || clockCount==10'h2BC || clockCount==10'h2FC || clockCount == 10'h33C)
  begin
    oTemp <= oMac;
    zTemp <= zReg60;
  end
  else if(clockCount==10'h17D || clockCount==10'h1BD || clockCount==10'h1FD || clockCount==10'h23D || clockCount==10'h27D || clockCount==10'h2BD || clockCount==10'h2FD || clockCount == 10'h33D)
  begin
    oTemp <= oMac;
    zTemp <= zReg61;
  end
  else if(clockCount==10'h17E || clockCount==10'h1BE || clockCount==10'h1FE || clockCount==10'h23E || clockCount==10'h27E || clockCount==10'h2BE || clockCount==10'h2FE || clockCount == 10'h33E)
  begin
    oTemp <= oMac;
    zTemp <= zReg62;
  end
  else if(clockCount==10'h17F || clockCount==10'h1BF || clockCount==10'h1FF || clockCount==10'h23F || clockCount==10'h27F || clockCount==10'h2BF || clockCount==10'h2FF || clockCount == 10'h33F)
  begin
    oTemp <= oMac;
    zTemp <= zReg63;
  end
//All 'w' values have been calculated and below we will truncate and store
//these in the output SRAM 
  else if(clockCount==10'h180)  //For calculating first 'o' and initializing parameters for next 'o'
  begin
    oTemp <= 16'h0000;    //This will be used for computing next 'o'
    zTemp <= zReg0;       //Starting 'z' for next 'o'
    if(oMac[31]==1'h0)  oReg[0] <= oMac [31:16];       //oMac or w is same here. If 'w' is positive, o={first 16 bits of w}. Else, o=0 
    else                oReg[0] <= 16'h0000;
  end
  else if(clockCount==10'h1C0)   //Similar as above
  begin
    oTemp <= 16'h0000;
    zTemp <= zReg0;
    if(oMac[31]==1'h0)  oReg[1] <= oMac [31:16];
    else                oReg[1] <= 16'h0000;
  end
  else if(clockCount==10'h200)
  begin
    oTemp <= 16'h0000;
    zTemp <= zReg0;
    if(oMac[31]==1'h0)  oReg[2] <= oMac [31:16];
    else                oReg[2] <= 16'h0000;
  end
  else if(clockCount==10'h240)
  begin
    oTemp <= 16'h0000;
    zTemp <= zReg0;
    if(oMac[31]==1'h0)  oReg[3] <= oMac [31:16];
    else                oReg[3] <= 16'h0000;
  end
  else if(clockCount==10'h280)
  begin
    oTemp <= 16'h0000;
    zTemp <= zReg0;
    if(oMac[31]==1'h0)  oReg[4] <= oMac [31:16];
    else                oReg[4] <= 16'h0000;
  end
  else if(clockCount==10'h2C0)
  begin
    oTemp <= 16'h0000;
    zTemp <= zReg0;
    if(oMac[31]==1'h0)  oReg[5] <= oMac [31:16];
    else                oReg[5] <= 16'h0000;
  end
  else if(clockCount==10'h300)
  begin
    oTemp <= 16'h0000;
    zTemp <= zReg0;
    if(oMac[31]==1'h0)  oReg[6] <= oMac [31:16];
    else                oReg[6] <= 16'h0000;
  end
  else if(clockCount==10'h340)
  begin
    oTemp <= 16'h0000;
    zTemp <= zReg0;
    if(oMac[31]==1'h0)  oReg[7] <= oMac [31:16];
    else                oReg[7] <= 16'h0000;
  end
end

//DesignWare MAC instantiation
DW02_mac #(16,16)  U5 ( .A(mReg), .B(zTemp), .C(oTemp), .TC(1'b1), .MAC(oMac) );

endmodule  //MyDesign ends






/* Instantiation of quadrant module */
module inputQuadrant(
  input wire        clock, 
  input wire        rst,      
  input wire [9:0] clockCounter,
  input wire        flag,        
  input wire        aEnable,
  input wire        bEnable,
  input wire [15:0] bvm__dut__data,  
  input wire [15:0] dim__dut__data,  
  output reg [15:0] z0,
  output reg [15:0] z1,
  output reg [15:0] z2,
  output reg [15:0] z3,
  output reg [15:0] z4,         
  output reg [15:0] z5,          
  output reg [15:0] z6,          
  output reg [15:0] z7,          
  output reg [15:0] z8,         
  output reg [15:0] z9,          
  output reg [15:0] z10,         
  output reg [15:0] z11,         
  output reg [15:0] z12,         
  output reg [15:0] z13,         
  output reg [15:0] z14,         
  output reg [15:0] z15         
);

//Initializations for firstQuadrant
reg  [15:0] aReg [35:0];                               // Shared 4 times, once by each quadrant
reg  [15:0] bReg [35:0];                               // Stores all values of b at once
wire [31:0] cReg0, cReg1, cReg2, cReg3;                // Truncates to z
reg  [15:0] aTemp;                                     // Inputs 'a' to mac
reg  [15:0] bTemp[3:0];                                // inputs 'b' to mac
reg  [31:0] cTemp[3:0];                                // 'A' of M'A'C
reg  [5:0]  clkCount1;                                // Another clock counter. Resets when a quadrant of input memory is fetched

always@(posedge clock)
begin
  if(rst)
  begin
    clkCount1 <= 6'hA0;    //random Value

  end
  else 
  begin
    clkCount1 <= clkCount1 + 1'h1;                   // Used to increment our clock counter (cc)

  end


// Input data (a) storage to registers from SRAM

  if((clockCounter > 10'h000) && (clockCounter < 10'h025) && (aEnable))      // values start to come in at cc=1 and last quadrant value comes in at cc = 36. There is a 1 cycle delay between request and actual read.
    begin   
      aReg[clockCounter-1] <= dim__dut__data;    
      //$display("\n areg[%d]=%d \n", clockCount-1, aReg[clockCount-1]);
    end
  else if(clockCounter == 10'h025)
    begin
      clkCount1 <= 6'h00;                                               
    end
  else if((clockCounter > 10'h050) && (clockCounter < 10'h075) && (aEnable))      // values start to come in at cc=1 and last quadrant value comes in at cc = 36. There is a 1 cycle delay between request and actual read.
    begin   
      aReg[clockCounter-8'h51] <= dim__dut__data;    
    end
  else if(clockCounter == 10'h075)
    begin
      clkCount1 <= 6'h00;                                               
    end
  if((clockCounter > 10'h0A0) && (clockCounter < 10'h0C5) && (aEnable))      // values start to come in at cc=1 and last quadrant value comes in at cc = 36. There is a 1 cycle delay between request and actual read.
    begin   
      aReg[clockCounter-8'hA1] <= dim__dut__data;    
    end
  else if(clockCounter == 10'h0C5)
    begin
      clkCount1 <= 6'h00;                                           
    end
  if((clockCounter > 10'h0F0) && (clockCounter < 10'h115) && (aEnable))      // values start to come in at cc=1 and last quadrant value comes in at cc = 36. There is a 1 cycle delay between request and actual read.
    begin   
      aReg[clockCounter-8'hF1] <= dim__dut__data;    
    end
  else if(clockCounter == 10'h115)
    begin
      clkCount1 <= 6'h00;

    end
     
//end


// Filter data (b) storage to registers

  if((clockCounter > 10'h000) && (clockCounter < 10'h025) && (bEnable))  
    begin
      bReg[clockCounter-1] <= bvm__dut__data;
    end   
  else 
    begin
    end





// Main arithmetic operations
//Flag is used to make sure that these operations do not repeat
  if(clkCount1 == 6'h00 && flag)    //Initially, all cTemp are set to zero, aTemp takes first 'a' and each bTemp takes first element of all [b]
  begin
    cTemp[0] <= 32'h0;
    cTemp[1] <= 32'h0;
    cTemp[2] <= 32'h0;
    cTemp[3] <= 32'h0;

    aTemp    <= aReg[clkCount1];

    bTemp[0] <= bReg[clkCount1];
    bTemp[1] <= bReg[clkCount1 + 8'h09];
    bTemp[2] <= bReg[clkCount1 + 8'h12];
    bTemp[3] <= bReg[clkCount1 + 8'h1B];    
  end
  else if((clkCount1 > 6'h00) && (clkCount1 < 6'h09) && flag)  //Above process is followed for 8 more clock cycles, only cTemp takes MAC output
  begin
    aTemp    <= aReg[clkCount1];

    bTemp[0] <= bReg[clkCount1];
    bTemp[1] <= bReg[clkCount1 + 8'h09];
    bTemp[2] <= bReg[clkCount1 + 8'h12];
    bTemp[3] <= bReg[clkCount1 + 8'h1B]; 

    cTemp[0] <= cReg0;
    cTemp[1] <= cReg1;
    cTemp[2] <= cReg2;
    cTemp[3] <= cReg3;
  end
  else if(clkCount1 == 6'h09 && flag)
  begin
    cTemp[0] <= 32'h0;
    cTemp[1] <= 32'h0;
    cTemp[2] <= 32'h0;
    cTemp[3] <= 32'h0;

    aTemp    <= aReg[clkCount1];

    bTemp[0] <= bReg[clkCount1 - 6'h09];
    bTemp[1] <= bReg[clkCount1];
    bTemp[2] <= bReg[clkCount1 + 6'h09];
    bTemp[3] <= bReg[clkCount1 + 6'h12]; 
   
    if(cReg0[31]==1'h0) z0 <= cReg0 [31:16];                    // If cReg is +ve, take first 16 bits of cReg. Else z=0
    else                z0 <= 16'h0000;
    if(cReg1[31]==1'h0) z1 <= cReg1 [31:16];
    else                z1 <= 16'h0000;
    if(cReg2[31]==1'h0) z2 <= cReg2 [31:16];
    else                z2 <= 16'h0000;
    if(cReg3[31]==1'h0) z3 <= cReg3 [31:16];
    else                z3 <= 16'h0000;
  end
  //Above procedure is repeated for all of the above
  else if((clkCount1 > 6'h09) && (clkCount1 < 6'h12) && flag)
  begin
    aTemp    <= aReg[clkCount1];

    bTemp[0] <= bReg[clkCount1 - 8'h09];
    bTemp[1] <= bReg[clkCount1];
    bTemp[2] <= bReg[clkCount1 + 8'h09];
    bTemp[3] <= bReg[clkCount1 + 8'h12]; 
 
    cTemp[0] <= cReg0;
    cTemp[1] <= cReg1;
    cTemp[2] <= cReg2;
    cTemp[3] <= cReg3;
  end
  else if(clkCount1 == 6'h12 && flag)
  begin
    cTemp[0] <= 32'h0;
    cTemp[1] <= 32'h0;
    cTemp[2] <= 32'h0;
    cTemp[3] <= 32'h0;

    aTemp    <= aReg[clkCount1];

    bTemp[0] <= bReg[clkCount1 - 8'h12];
    bTemp[1] <= bReg[clkCount1 - 8'h09];
    bTemp[2] <= bReg[clkCount1];
    bTemp[3] <= bReg[clkCount1 + 8'h09]; 

    if(cReg0[31]==1'h0) z4 <= cReg0 [31:16];
    else                z4 <= 16'h0000;
    if(cReg1[31]==1'h0) z5 <= cReg1 [31:16];
    else                z5 <= 16'h0000;
    if(cReg2[31]==1'h0) z6 <= cReg2 [31:16];
    else                z6 <= 16'h0000;
    if(cReg3[31]==1'h0) z7 <= cReg3 [31:16];
    else                z7 <= 16'h0000;
  end
  else if((clkCount1 > 6'h12) && (clkCount1 < 6'h1B) && flag)
  begin
    aTemp    <= aReg[clkCount1];

    bTemp[0] <= bReg[clkCount1 - 8'h12];
    bTemp[1] <= bReg[clkCount1 - 8'h09];
    bTemp[2] <= bReg[clkCount1];
    bTemp[3] <= bReg[clkCount1 + 8'h09]; 

    cTemp[0] <= cReg0;
    cTemp[1] <= cReg1;
    cTemp[2] <= cReg2;
    cTemp[3] <= cReg3;
  end
  else if(clkCount1 == 6'h1B && flag)
  begin
    cTemp[0] <= 32'h0;
    cTemp[1] <= 32'h0;
    cTemp[2] <= 32'h0;
    cTemp[3] <= 32'h0;

    aTemp    <= aReg[clkCount1];

    bTemp[0] <= bReg[clkCount1 - 8'h1B];
    bTemp[1] <= bReg[clkCount1 - 8'h12];
    bTemp[2] <= bReg[clkCount1 - 8'h09];
    bTemp[3] <= bReg[clkCount1]; 

    if(cReg0[31]==1'h0) z8 <= cReg0 [31:16];
    else                z8 <= 16'h0000;
    if(cReg1[31]==1'h0) z9 <= cReg1 [31:16];
    else                z9 <= 16'h0000;
    if(cReg2[31]==1'h0) z10<= cReg2 [31:16];
    else                z10<= 16'h0000;
    if(cReg3[31]==1'h0) z11<= cReg3 [31:16];
    else                z11<= 16'h0000;
  end
  else if((clkCount1 > 6'h1B) && (clkCount1 < 6'h24) && flag)
  begin
    aTemp    <= aReg[clkCount1];

    bTemp[0] <= bReg[clkCount1 - 8'h1B];
    bTemp[1] <= bReg[clkCount1 - 8'h12];
    bTemp[2] <= bReg[clkCount1 - 8'h09];
    bTemp[3] <= bReg[clkCount1]; 

    cTemp[0] <= cReg0;
    cTemp[1] <= cReg1;
    cTemp[2] <= cReg2;
    cTemp[3] <= cReg3;
  end
  else if(clkCount1 == 6'h24 && flag)
  begin
    if(cReg0[31]==1'h0) z12<= cReg0 [31:16];
    else                z12<= 16'h0000;
    if(cReg1[31]==1'h0) z13<= cReg1 [31:16];
    else                z13<= 16'h0000;
    if(cReg2[31]==1'h0) z14<= cReg2 [31:16];
    else                z14<= 16'h0000;
    if(cReg3[31]==1'h0) z15<= cReg3 [31:16];
    else                z15<= 16'h0000;
  end

end
 
    
//DesignWare MAC instantiations
DW02_mac #(16,16)  U0 ( .A(aTemp), .B(bTemp[0]), .C(cTemp[0]), .TC(1'b1), .MAC(cReg0) );
DW02_mac #(16,16)  U1 ( .A(aTemp), .B(bTemp[1]), .C(cTemp[1]), .TC(1'b1), .MAC(cReg1) );
DW02_mac #(16,16)  U2 ( .A(aTemp), .B(bTemp[2]), .C(cTemp[2]), .TC(1'b1), .MAC(cReg2) );
DW02_mac #(16,16)  U3 ( .A(aTemp), .B(bTemp[3]), .C(cTemp[3]), .TC(1'b1), .MAC(cReg3) );

endmodule //Quadrant Module ends



