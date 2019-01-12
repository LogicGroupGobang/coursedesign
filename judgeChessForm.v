`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:56:43 01/04/2019 
// Design Name: 
// Module Name:    judgeChessForm 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module judgeChessForm(input wire	[8:0]A,input wire [8:0]B,output wire [2:0]typeOut);
/*
	棋形判断模块。
	A是当前要判断的棋子的布局,B是另一种棋子在这9个位置的布局
*/
integer cnt,addLeft,addRight,zeroLeft,zeroRight,zeroComplementLeft,zeroComplementRight,mark;
integer i;


reg [2:0] type;

initial begin
	type<=0;
end 

reg [2:0] realType; //输出棋形编号,总共8类
assign typeOut=realType;


/*
	一个组合逻辑模块。根据输入的棋子信息,输出棋形编号
	为了表述的统一,下面都统一假设我们现在将要判断的是白棋的棋形
*/
always @ (*)
begin
	realType<=type;

	cnt=1;//cnt记录的是落子点两侧连续的邻接的白棋个数
	zeroLeft=0; //记录从左侧遇到的第一个零开始总共有多少个连续的空位
	zeroRight=0;// 记录从右侧遇到的第一个零开始总共有多少个连续的空位
	addLeft=0; //记录zeroLeft数到头后,又连续的遇到了多少个白棋
	addRight=0;//记录zeroRight数到头后,又连续的遇到了多少个白棋
	zeroComplementLeft=0;//记录addLeft数到头后,又连续的遇到了多少个空位
	zeroComplementRight=0;//记录addRight数到头后,又连续的遇到多少个空位
	mark=0;//棋形判断时用到的状态量
	
	//上面记录的信息都是为了判断棋形的辅助内容,这样可以让我们的棋形判断更形式化一点

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//检测落子点左边的棋子状态
	for(i=3;i>=0;i=i-1)
	begin
		if(mark==0)
			begin
				if(A[i]==0)
					begin
						if(B[i]==0)
							begin
								mark=1;
								zeroLeft=1;
							end
						else mark=3;
					end
				else cnt=cnt+1;
			end
		else if(mark==1)
			begin
				if(A[i]==0&&B[i]==0)zeroLeft=zeroLeft+1;
				else if(A[i]==1)
					begin
						addLeft=1;
						mark=2;
					end
				else mark=3;
			end
		else if(mark==2)
			begin
				if(A[i]==1)addLeft=addLeft+1;				
				else 
					begin
						if(B[i]==0)
							begin
								zeroComplementLeft=1;
								mark=4;
							end
						else mark=3;
					end
			end
		else if(mark==4)
			begin
				if(A[i]==0&&B[i]==0)zeroComplementLeft=zeroComplementLeft+1;
				else mark=3;
			end
	end
	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//检测落子点右边的棋子状态
	mark=0;
	for(i=5;i<=8;i=i+1)
	begin
		if(mark==0)
			begin
				if(A[i]==0)
					begin
						if(B[i]==0)
							begin
								mark=1;
								zeroRight=1;
							end
						else mark=3;
					end
				else cnt=cnt+1;
			end
		else if(mark==1)
			begin
				if(A[i]==0&&B[i]==0)zeroRight=zeroRight+1;
				else if(A[i]==1)
					begin
						addRight=1;
						mark=2;
					end
				else mark=3;
			end
		else if(mark==2)
			begin
				if(A[i]==1)addRight=addRight+1;				
				else 
					begin
						if(B[i]==0)
							begin
								zeroComplementRight=1;
								mark=4;
							end
						else mark=3;
					end
			end
		else if(mark==4)
			begin
				if(A[i]==0&&B[i]==0)zeroComplementRight=zeroComplementRight+1;
				else mark=3;
			end
	end

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	/*
		上面对两个方向的棋子信息做了检测后，相应的数据就记录在了我们一开始介绍的几个变量中。
		根据那一套变量，我们就可以形式化的枚举检测8种棋形了。
		这个过程非常繁杂,我们就不再赘述了。
		在报告中可以看到棋形的示意图和名称。
		对于程序中用到的棋形的编号：
		7 连5
		6 活4
		5 冲4
		4 活3
		3 眠3
		2 活2
		1 眠2
		0 其他
	*/
	
	if(cnt==5)type<=7;
	else if(cnt==4)
		begin
			if(zeroLeft>=1&&zeroRight>=1)type<=6;
			else if(zeroLeft+zeroRight>=1)type<=5;
			else type<=0;
		end	
	else if(cnt==3)
		begin
			if((zeroLeft==1&&addLeft>=1)||(zeroRight==1&&addRight>=1))type<=5;
			else if(zeroLeft+zeroRight<=1)type<=0;
			else if(zeroLeft==0||zeroRight==0)type<=3;
			else if(zeroLeft+zeroRight==2)type<=3;
			else if(zeroLeft+zeroRight>=3)type<=4;
		end
	else if(cnt==2)
		begin
			if((zeroLeft==1&&addLeft>=2)||(zeroRight==1&&addRight>=2))type<=5;
			else if(zeroLeft==1&&addLeft==1)
				begin
					if(zeroRight+zeroComplementLeft==0)type<=0;
					else if(zeroRight==0||zeroComplementLeft==0)type<=3;
					else if(zeroRight+zeroComplementLeft>=2)type<=4;
				end
			else if(zeroRight==1&&addRight==1)
				begin
					if(zeroLeft+zeroComplementRight==0)type<=0;
					else if(zeroLeft==0||zeroComplementRight==0)type<=3;
					else if(zeroLeft+zeroComplementRight>=2)type<=4;
				end
			else if((zeroLeft==2&&addLeft>=1)||(zeroRight==2&&addRight>=1))type<=3;
			else if(zeroLeft==0||zeroRight==0)type<=1;
			else if(zeroLeft+zeroRight>=4)type<=2;
			else if(zeroLeft+zeroRight<3)type<=0;
			else if(zeroLeft+zeroRight==3)type<=1;
		end
	else if(cnt==1)
		begin
			if((zeroLeft==1&&addLeft>=3)||(zeroRight==1&&addRight>=3))type<=5;
			else if(zeroLeft==1&&addLeft>=2)
				begin
					if(zeroRight+zeroComplementLeft==0)type<=0;
					else if(zeroRight==0||zeroComplementLeft==0)type<=3;
					else type<=4;
				end
			else if(zeroRight==1&&addRight>=2)
				begin
					if(zeroLeft+zeroComplementRight==0)type<=0;
					else if(zeroLeft==0||zeroComplementRight==0)type<=3;
					else type<=4;
				end
			else if((zeroLeft==2&&addLeft>=2)||(zeroRight==2&&addRight>=2))type<=3;
			else if(zeroLeft==1&&zeroRight==1&&addLeft>=1&&addRight>=1)type<=3;
			else if((A[4:0]==21&&B[4:0]==0)||(A[8:4]==21&&B[8:4]==0))type<=3;
			else if(zeroLeft==1&&addLeft==1)
				begin
					if(zeroComplementLeft+zeroRight<2)type<=0;
					else if(zeroComplementLeft==0||zeroRight==0)type<=1;
					else if(zeroComplementLeft+zeroRight==2)type<=1;
					else type<=2;
				end
			else if(zeroRight==1&&addRight==1)
				begin
					if(zeroComplementRight+zeroLeft<2)type<=0;
					else if(zeroComplementRight==0||zeroLeft==0)type<=1;
					else if(zeroComplementRight+zeroLeft==2)type<=1;
					else type<=2;
				end
			else if(zeroLeft==2&&addLeft==1)
				begin
					if(zeroComplementLeft+zeroRight==0)type<=0;
					else if(zeroComplementLeft==0||zeroRight==0)type<=1;
					else type<=2;
				end
			else if(zeroRight==2&&addRight==1)
				begin
					if(zeroComplementRight+zeroLeft==0)type<=0;
					else if(zeroComplementRight==0||zeroLeft==0)type<=1;
					else type<=2;
				end
			else if((zeroLeft==3&&addLeft==1)||(zeroRight==3&&addRight==1))type<=1;
			else type<=0;
		end
end



endmodule
