/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    //Fetch stage
    wire [63:0] fd_Out;

    //Decode stage
    wire [127:0] dx_Out;

    //Execute stage
    wire [95:0] xm_Out;

    //Memory stage
    wire [95:0] mw_Out;

    //latches need to be on falling edges
    
    //FETCH STAGRE
    wire [31:0] PC_In, PC_Out;

    //need to update on falling edge
    reg_32bit PC(.readOut(PC_Out), .writeIn(PC_In), .clock(~clock), .resetn(reset), .writeEnable(1'b1));

    //currently increments PC by 1
    alu PC_increment(.data_operandA(PC_Out), .data_operandB(32'b1), .ctrl_ALUopcode(5'b0), .ctrl_shiftamt(), .data_result(PC_In), .isNotEqual(), .isLessThan(), .overflow());

    assign address_imem = PC_Out;

    reg_64bit fd_latch(.readOut(fd_Out), .writeIn({address_imem, q_imem}), .clock(~clock), .resetn(reset), .writeEnable(1'b1));

    //DECODE STAGE

    wire [31:0] fd_ins;

    assign fd_ins = fd_Out[31:0];
    //should these be outputs to use in order to be able to use these in my execute stage?
    wire is_R_type;
    wire is_addi;
    // is_I_type, is_J_type;
    // wire is_sw, is_lw, is_j, is_bne, is_jal, is_jr, is_blt, is_bex, is_setx;
    // wire [4:0] rs, rt;

    //USE WHATEVER IS NEEDED IN EACH STAGE IN PIPELINE
    assign is_R_type = fd_ins[31:27] == 5'b0;
    // assign is_I_type = is_addi | is_sw | is_lw | is_bne | is_blt;
    // assign is_J_type = is_j | is_jal | is_jr | is_bex | is_setx;
    
    assign is_addi = fd_ins[31:27] == 5'b00101;

    assign is_sw = fd_Out[31:27] == 5'b00111;
    // assign is_lw = fd_Out[31:27] == 5'b10000;
    
    // assign is_j = fd_Out[31:27] == 5'b00001;
    // assign is_bne = fd_Out[31:27] == 5'b00010;
    // assign is_jal = fd_Out[31:27] == 5'b00011;
    // assign is_jr = fd_Out[31:27] == 5'b00100;
    // assign is_blt = fd_Out[31:27] == 5'b00110;

    // assign is_bex = fd_Out[31:27] == 5'b10110;
    // assign is_setx = fd_Out[31:27] == 5'b10101;

    //only works for R-type
    assign ctrl_readRegA = is_R_type | is_addi ? fd_ins[21:17] : 5'b0;
    assign ctrl_readRegB = is_R_type ? fd_ins[16:12] : 5'b0;

    reg_Nbit #(.WIDTH(128)) dx_latch(.readOut(dx_Out), .writeIn({fd_Out[63:32], data_readRegA, data_readRegB, fd_ins}), .clock(~clock), .resetn(reset), .writeEnable(1'b1));

    //EXECUTE STAGE

    wire [31:0] dx_ins;
    wire [31:0] sign_extended_immediate, data_operandA, data_operandB;
    wire [4:0] alu_op, ctrl_shiftamt;
    wire [16:0] i_type_immediate;

    wire execute_is_addi;

    wire [31:0] alu_out;
    wire [31:0] b_out;
    wire less_than, not_equal, overflow;

    assign dx_ins = dx_Out[31:0];
    assign data_operandA = dx_Out[95:64];

    assign i_type_immediate = dx_ins[16:0];
    
    assign sign_extended_immediate[31:17] = {15{i_type_immediate[16]}};
    assign sign_extended_immediate[16:0] = i_type_immediate;
    
    assign execute_is_addi = dx_ins[31:27] == 5'b00101;
    assign is_bne = dx_ins[31:27] == 5'b00010;
    assign is_blt = dx_ins[31:27] == 5'b00110;
    

    mux_2 #(.WIDTH(32)) operand_B_select(.select(execute_is_addi), .in0(dx_Out[63:32]), .in1(sign_extended_immediate), .out(data_operandB));
    
    mux_2 #(.WIDTH(5)) operation_select(.select(execute_is_addi), .in0(dx_ins[6:2]), .in1(5'b0), .out(alu_op));
    
    mux_2 #(.WIDTH(5)) shift_amount_select(.select(execute_is_addi), .in0(dx_ins[11:7]), .in1(5'b0), .out(ctrl_shiftamt));


    alu execute_alu(.data_operandA(data_operandA), .data_operandB(data_operandB), .ctrl_ALUopcode(alu_op), .ctrl_shiftamt(ctrl_shiftamt), .data_result(alu_out), .isNotEqual(not_equal), .isLessThan(less_than), .overflow(overflow));
    assign b_out = data_operandB;

    //need to implement logic for bne, blt, anything else that uses alu

    reg_Nbit #(.WIDTH(96)) xm_latch(.readOut(xm_Out), .writeIn({alu_out, b_out, dx_Out[31:0]}), .clock(~clock), .resetn(reset), .writeEnable(1'b1));

    //MEMORY STAGE
    wire [31:0] xm_o, xm_b, xm_ins;
    wire mem_is_sw,mem_is_lw;
    

    assign mem_is_sw = fd_Out[31:27] == 5'b00111;
    assign mem_is_lw = fd_Out[31:27] == 5'b10000;

    //only works for arithmetic ops
    assign xm_o = xm_Out[95:64];
    assign xm_b = xm_Out[63:32];
    assign xm_ins = xm_Out[31:0];

    reg_Nbit #(.WIDTH(96)) mw_latch(.readOut(mw_Out), .writeIn({xm_o, xm_b, xm_ins}), .clock(~clock), .resetn(reset), .writeEnable(1'b1));

    //WRITEBACK STAGE
    wire arithmetic_rd_write;
    wire [31:0] mw_ins;



    assign mw_ins = mw_Out[31:0];

    assign data_writeReg = mw_Out[95:64];
    
    assign arithmetic_rd_write = 1'b1;
    
    assign ctrl_writeEnable = arithmetic_rd_write;

    //NOTE: DOES NOT WORK FOR J1
    assign ctrl_writeReg = mw_ins[26:22];
    
endmodule
