module pattern_gen(clk, rst, en, sel, pattern, valid);

input clk, rst;
input en;
input [2:0] sel;
output  pattern;
output  valid;

reg pattern;
reg valid;

reg [2:0] cs,ns;
parameter idle=3'b000,pattern0=3'b001,pattern1=3'b010,pattern2=3'b011,pattern3=3'b100,finish=3'b101;

always@(posedge clk or posedge rst)
begin
	if(rst)begin
		cs<=idle;
	end
	else begin 
		cs<=ns;
	end
end			
			
always@(*)begin
	case(cs)
	idle:
	begin
		if(en)//input and state
			ns=pattern0;
		else //choose
			ns=idle;
	end	
	pattern0:ns=pattern1;
	pattern1:ns=pattern2;//cs pattern1 sel[2] valid=1 pattern valid delay one
	pattern2:ns=pattern3;//pattern2 sel[2] valid=1	
	pattern3:ns=finish;//pattern3 sel[1] valid=1
	finish:ns=idle;//finish sel[0] valid=1
	default:ns=idle;		
	endcase
end

always@(posedge clk or posedge rst)begin//pattern
	if(rst)
		pattern<=1'b0;
	else begin
		case(cs)
			idle:pattern<=1'b0;
			pattern0:pattern<=sel[2];
			pattern1:pattern<=sel[2];
			pattern2:pattern<=sel[1];		
			pattern3:pattern<=sel[0];
			finish:pattern<=1'b0;
			default:pattern<=1'b0;		
		endcase
	end
end

always@(posedge clk or posedge rst)begin//valid
	if(rst)
		valid<=1'b0;
	else if(cs!=idle&&cs!=finish)//0 5
		valid<=1'b1;
	else
		valid<=1'b0;
end

endmodule
