`timescale 1ns / 1ps

module datamemory #(
    parameter DM_ADDRESS = 9,
    parameter DATA_W = 32
) (
    input logic clk,
    input logic MemRead,  // comes from control unit
    input logic MemWrite,  // Comes from control unit
    input logic [DM_ADDRESS - 1:0] a,  // Read / Write address - 9 LSB bits of the ALU output
    input logic [DATA_W - 1:0] wd,  // Write Data
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction
    output logic [DATA_W - 1:0] rd  // Read Data
);

  logic [31:0] raddress;
  logic [31:0] waddress;
  logic [31:0] Datain;
  logic [31:0] Dataout;
  logic [ 3:0] Wr;

  Memoria32Data mem32 (
      .raddress(raddress),
      .waddress(waddress),
      .Clk(~clk),
      .Datain(Datain),
      .Dataout(Dataout),
      .Wr(Wr)
  );

  always_ff @(*) begin
    raddress = {{22{1'b0}}, a[8:2], {2{1'b0}}};
    waddress = {{22{1'b0}}, a[8:2], {2{1'b0}}};
    Datain = wd;
    Wr = 4'b0000;

    if (MemRead) begin
      case (Funct3)
        3'b010:  //LW
        rd <= Dataout;
        3'b000: //LB
        case (a[1:0])
          2'b00: rd <= $signed(Dataout[7:0]);
          2'b01: rd <= $signed(Dataout[15:8]);
          2'b10: rd <= $signed(Dataout[23:16]);
          2'b11: rd <= $signed(Dataout[31:24]);
        endcase 
        3'b001: //LH
        case (a[1:0])
          2'b00: rd <= $signed(Dataout[15:0]);
          2'b01: rd <= $signed(Dataout[15:0]);
          2'b10: rd <= $signed(Dataout[31:16]);
          2'b11: rd <= $signed(Dataout[31:16]);
        endcase
        3'b100: //LBU
        case (a[1:0])
          2'b00: rd <= $unsigned(Dataout[7:0]);
          2'b01: rd <= $unsigned(Dataout[15:8]);
          2'b10: rd <= $unsigned(Dataout[23:16]);
          2'b11: rd <= $unsigned(Dataout[31:24]);
        endcase
        default: rd <= Dataout;
      endcase
    end else if (MemWrite) begin
      case (Funct3)
        3'b010: begin  //SW
          Wr <= 4'b1111;
          Datain <= wd;
        end
        3'b000: begin  //SB
          Datain <= wd;
          case (a[1:0])
            2'b00: Wr <= 4'b0001;
            2'b01: Wr <= 4'b0010;
            2'b10: Wr <= 4'b0100;
            2'b11: Wr <= 4'b1000;
          endcase
        end
        3'b001: begin  //SH
          Datain <= wd;
          case (a[1:0])
            2'b00: Wr <= 4'b0011;
            2'b01: Wr <= 4'b0011;
            2'b10: Wr <= 4'b1100;
            2'b11: Wr <= 4'b1100;
          endcase
        end
        default: begin
          Wr <= 4'b1111;
          Datain <= wd;
        end
      endcase
    end
  end

endmodule
