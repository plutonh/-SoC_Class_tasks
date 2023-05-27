`timescale 1ns / 1ps
module tb_fsm_with_stopwatch;
reg             clk , reset_n;
reg 			i_run;
wire 			o_idle;
wire 			o_running;
wire 			o_done;
 
// clk gen
always
    #5 clk = ~clk;

initial begin
//initialize value
$display("initialize value [%d]", $time);
    reset_n = 1;
    clk     = 0;
	i_run 	= 0;

// reset_n gen
$display("Reset! [%d]", $time);
# 100
    reset_n = 0;
# 10
    reset_n = 1;
# 10
@(posedge clk);


$display("Check Idle [%d]", $time);
wait(o_idle);

$display("Start! [%d]", $time);
	i_run = 1;
	#20
	i_run = 0;

$display("Wait Done [%d]", $time);
wait(o_done);

# 100
$display("Finish! [%d]", $time);
$stop;
end

// Call DUT
fsm_with_stopwatch u_fsm_with_stopwatch(
    .clk 			(clk),
    .reset_n 		(reset_n),
	.i_run 			(i_run),
	.o_idle 		(o_idle),
	.o_running 		(o_running),
	.o_done 		(o_done)
    );
endmodule