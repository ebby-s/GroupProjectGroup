module arm_alu
(
	input [15:0] rd_data,
	input [15:0] rs_data,
	input [15:0] inst,
	input [2:0] state,
	output [15:0] d_out,
	output wen,
	output ldr,
	output reg_mux
);
	wire arm, cin;
	wire exec1, exec2;
	reg [15:0] sum;

	assign arm = inst[15];
	assign cin = inst[11];
	assign exec1 = state[1];
	assign exec2 = state[2];

	always @(*)
		begin
			case (inst[14:12])
				3'b000 : sum = rd_data + rs_data; // add
				3'b001 : sum = rd_data + ~rs_data + 1; // sub
				3'b010 : sum = rs_data + cin; // mov
				3'b011 : sum = {1'b0,rs_data[15:1]}; // lsr
				3'b100 : sum = rs_data + 16'hFFFF; // dec
				3'b101 : sum = rd_data[0] && {rs_data[15:0]} +
				rd_data[1] && {rs_data[14:0], 1'h0} +
				rd_data[2] && {rs_data[13:0], 2'h0} +
				rd_data[3] && {rs_data[12:0], 3'h0} +
				rd_data[4] && {rs_data[11:0], 4'h0} +
				rd_data[5] && {rs_data[10:0], 5'h00} +
				rd_data[6] && {rs_data[9:0], 6'h00} +
				rd_data[7] && {rs_data[8:0], 7'h00} +
				rd_data[8] && {rs_data[7:0], 8'h00} +
				rd_data[9] && {rs_data[6:0], 9'h000} +
				rd_data[10] && {rs_data[5:0], 10'h000} +
				rd_data[11] && {rs_data[4:0], 11'h000} +
				rd_data[12] && {rs_data[3:0], 12'h000} +
				rd_data[13] && {rs_data[2:0], 13'h0000} +
				rd_data[14] && {rs_data[1:0], 14'h0000} +
				rd_data[15] && {rs_data[0], 15'h0000};
				default : sum = rd_data;
			endcase;
		end

	// assign values to outputs
   assign ldr = inst[15] & inst[14] & inst[13] & ~inst[12];
	assign wen = exec1 & arm | ldr & exec2;
	assign d_out = sum[15:0];
	assign reg_mux = ~inst[15] & ~inst[14] & inst[13];

endmodule

	
	