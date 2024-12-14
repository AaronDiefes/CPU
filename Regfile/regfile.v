module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here
	wire [31:0] data_readRegOut[0:31];
	wire [31:0] regWriteEnable;
	wire [31:0] regReadEnableA, regReadEnableB;

	assign regWriteEnable = ctrl_writeEnable << ctrl_writeReg;
	assign regWriteEnable[0] = 1'b0;

	genvar i;
	generate 
		for (i = 0; i < 32; i = i + 1) begin
			reg_32bit register(.readOut(data_readRegOut[i]), .writeIn(data_writeReg), .clock(clock), .resetn(ctrl_reset), .writeEnable(regWriteEnable[i]));
		end
	endgenerate

	

	assign regReadEnableA = 1'b1 << ctrl_readRegA;
	assign regReadEnableB = 1'b1 << ctrl_readRegB;

	genvar j;
	generate
		for (j = 0; j < 32; j = j + 1) begin
			tristate_32bit readAVal(.in(data_readRegOut[j]), .oe(regReadEnableA[j]), .out(data_readRegA));
			tristate_32bit readBVal(.in(data_readRegOut[j]), .oe(regReadEnableB[j]), .out(data_readRegB));
		end
	endgenerate



endmodule
