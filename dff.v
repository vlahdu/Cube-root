module test;

  reg clk, rst,a,b;
  wire [31:0] out;
  wire [31:0] can;
  //wire [31:0]output_z,output_z1,output_z2,output_z3;
  wire r;
  //CubeRoot C(.clk(clk),.rst(rst),.data_a(32'h43480000 ),.data_b(32'h43480000 ),.a(1'b1),.b(1'b1),.out(out),.mid(can),.r(r));
  
  CubeRootCalc CR(.clk(clk),
                  .rst(rst),
                  .data(32'h47c34f80),
                  .result(out));
  
  initial begin
    clk=1;
    rst=1;
    #5 clk=~clk;
    rst=0;
    a=0;
    b=0;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
    a=1;
    #5 clk=~clk;
    #5 clk=~clk;
    b=1;
  while(1)begin
    #5 clk=~clk;
    end
  end

endmodule