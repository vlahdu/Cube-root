
module CubeRootCalc(clk,rst,data,result);
  input clk,rst;
  input [31:0]data;
  output reg[31:0]result;
  reg [31:0]epsilon=32'h3a83126f;

 
 localparam [2:0] 
    startState = 3'b000,
    midState   = 3'b001,
    mid3State  = 3'b010,
    errorState = 3'b011,
    compState  = 3'b100,
    finish     = 3'b101,
    startEnd   = 3'b110;
    
 reg[2:0] state_reg, state_next;

always @(posedge clk, posedge rst)
begin
    if(rst) 
        begin
        state_reg <= startState;
        end
    else 
        begin
        state_reg <= state_next;
        end
end

//=================================== 
//=
//=================================== 
//calculating mid
//input
reg [31:0]start,en;
reg a,b;
//output
wire[31:0] wire1;
wire[31:0] mid;
wire Add_stb,mid_stb,ex;
reg esAdd,h;
reg[31:0] Ain,Bin;

        
 Addition_Subtraction Add(
        .a(Ain),
        .b(Bin),
        .add_sub_signal(1'b0),
        .exception(ex),
        .res(wire1)      
);
        
 multiplier divide(
        .input_a(wire1),
        .input_b(32'h3f000000),
        .input_a_stb(1'b1),
        .input_b_stb(1'b1),
        .output_z_ack(1'b1),
        .clk(clk),
        .rst(rst),
        .output_z(mid),
        .output_z_stb(mid_stb),
        .input_a_ack(),
        .input_b_ack()); 


//=================================== 
//=
//=================================== 
//calculating mid3
wire [31:0]wire2;
wire [31:0]mid3;
wire mult_stb0,mult_stb;

reg [31:0]MID;
reg MID_stb;
  multiplier MULT(
        .input_a(MID),
        .input_b(MID),
        .input_a_stb(MID_stb),
        .input_b_stb(MID_stb),
        .output_z_ack(1'b1),
        .clk(clk),
        .rst(rst),
        .output_z(wire2),
        .output_z_stb(mult_stb0),
        .input_a_ack(),
        .input_b_ack());
        
  multiplier MULT1(
        .input_a(wire2),
        .input_b(MID),
        .input_a_stb(mult_stb0),
        .input_b_stb(MID_stb),
        .output_z_ack(1'b1),
        .clk(clk),
        .rst(rst),
        .output_z(mid3),
        .output_z_stb(mult_stb),
        .input_a_ack(),
        .input_b_ack());
//=================================== 
//=
//===================================
//calculation error
//input
reg [31:0] SUB1,SUB2,MID3,ERROR;
reg wire_sub;
//output
wire sub_stb; 
wire [31:0]error;

  adder SUB(
        .input_a(SUB1),
        .input_b(SUB2),
        .input_a_stb(wire_sub),
        .input_b_stb(wire_sub),
        .output_z_ack(1'b1),
        .clk(clk),
        .rst(rst),
        .output_z(error),
        .output_z_stb(sub_stb),
        .input_a_ack(),
        .input_b_ack());
        
//=================================== 
//=
//===================================
always @(clk)begin
  esAdd = 1'b1;

end

always @(state_reg, clk)
  begin
    state_next = state_reg;

    case(state_reg)
        startState :begin
          if(data[31]) begin
            state_next = finish;
            $display("Not a number");
          end else begin
          start =0;
          en =data;
          Ain=start;
          Bin=en;
          $display("start end %h",en);
          $display("start start %h",start);
          $display("==================");
          state_next = midState;
        end       
        end
        midState   :begin

            if(mid>0) begin
              MID=mid;
              $display("MID %h",MID);
              Ain=32'b0;
              Bin=32'b0;
            state_next = mid3State;
          end

        end
        mid3State  :begin
          MID_stb = 1'b1;

          if(mult_stb)begin
            MID3=mid3;
            $display("MID3 %h",MID3);
            MID_stb = 1'b0;
            state_next = errorState;
          end
        end
        errorState :begin
          if(data > MID3)begin
                SUB1=data;
                SUB2={1'b1,MID3[30:0]};
          end else begin
                SUB2={1'b1,data[30:0]};
                SUB1=MID3;
          end

          wire_sub =1'b1;
          if(sub_stb)begin
            ERROR=error;
            $display("ERROR %h",ERROR);
            wire_sub =1'b0;
            state_next = compState;
          end
        end
        compState  :begin
          if(ERROR<epsilon)begin
            state_next = finish;
          end else begin
             state_next = startEnd;
             result = MID;
          end
        end
        finish     :begin
          result = MID;
        end
        startEnd   :begin
          if(MID3>data) begin
            en = MID;
          end else begin
            start = MID;
          end
          
          Ain=start;
          Bin=en;
          $display("final end %h",en);
          $display("final start %h",start);
          $display("==================");
          state_next = midState;
        end
    endcase





    // case(state_reg)
    //     startState: begin 
    //             start =0;
    //             en =data;
    //             state_next = firstState;       
    //       end
    //       firstState: begin
    //                   a=1'b1;
    //                   b=1'b1;
    //                   if(r) begin
                       
    //                        RES=res;
    //                        MID=mid;
    //                        a=1'b0;
    //                        b=1'b0;
    //                        en=32'b0;
    //                        start=32'b0;
    //                         $display("RES %h",RES);
    //                         $display("MID %h",MID);
    //                   state_next = secondState;
    //                    end
    //       end
    //     secondState:
    //         begin
    //           if(data > RES)begin 
    //             sub1=data;
    //             sub2={1'b1,RES[30:0]};
    //           end else begin
    //             sub2={1'b1,data[30:0]};
    //             sub1=RES;
    //           end
              
    //           wire_sub=1'b1;
    //         if(sub_stb) begin
    //           ERROR=error;
    //           $display("ERROR %h",ERROR);
    //           wire_sub=1'b0;
    //           state_next = thirdState; 
    //         end 
    //         end
    //     thirdState:
    //         begin
    //          //$display("mid %h",mid);
    //          //$display("error %h",error);  
    //          $display("start %h",start);
    //          $display("end %h",en);
    //          $display("==================");
    //           if(ERROR <epsilon)begin
    //             state_next = fourthState;
    //           end else if(RES>data) begin
    //             en = MID;
    //             state_next = firstState;
    //           end else begin
    //             start = MID;
    //             state_next = firstState;
    //           end
    //           if(start ==en) begin
    //              state_next = fourthState;
    //           end
    //       end
    //     fourthState:
    //         begin
    //           result =mid;
    //       end
            
  
    // endcase
   
end
  
endmodule
  