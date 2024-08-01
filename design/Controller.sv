`timescale 1ns / 1ps

module Controller (
    //Input
    input logic [6:0] Opcode,
    //7-bit opcode field from the instruction

    //Outputs
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic [1:0] MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,  //00: LW/SW; 01:Branch; 10: Rtype
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic Jal,  //0: JAL is not taken; 1: JAL is taken
    output logic Jalr  //0: JALR is not taken; 1: JALR is taken
);

  logic [6:0] R_TYPE, I_TYPE, U_TYPE, J_TYPE, JR_TYPE,LW, SW, BR;

  assign R_TYPE = 7'b0110011;  //add,and
  assign I_TYPE = 7'b0010011;  //addi
  assign LW = 7'b0000011;  //lw
  assign SW = 7'b0100011;  //sw
  assign BR = 7'b1100011;  //beq
  assign U_TYPE = 7'b0110111;  //lui
  assign J_TYPE = 7'b1101111; //Jal
  assign JR_TYPE = 7'b1100111; //Jalr

  assign ALUSrc = (Opcode == LW || Opcode == SW || Opcode == I_TYPE || Opcode == U_TYPE || Opcode == J_TYPE || Opcode == JR_TYPE);
  assign MemtoReg[0] = (Opcode == LW || Opcode == J_TYPE || Opcode == JR_TYPE);
  assign MemtoReg[1] = (Opcode == J_TYPE || Opcode == JR_TYPE);
  assign RegWrite = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == LW || Opcode == U_TYPE || Opcode == J_TYPE || Opcode == JR_TYPE);
  assign MemRead = (Opcode == LW);
  assign MemWrite = (Opcode == SW);
  assign ALUOp[0] = (Opcode == BR || Opcode == JR_TYPE);
  assign ALUOp[1] = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == JR_TYPE);
  assign Branch = (Opcode == BR);
  assign Jal = (Opcode == J_TYPE);
  assign Jalr = (Opcode == JR_TYPE);
endmodule
