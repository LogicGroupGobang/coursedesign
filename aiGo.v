`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:50:00 01/04/2019 
// Design Name: 
// Module Name:    aiGo 
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
module aiGo(reset,clk,humanIn,enable,AIOut,finish,x,y);
/*
	AI部分的底层模块
*/
input wire clk,enable;
input wire reset;
input wire [224:0] humanIn; //人类棋子的摆放
output wire [224:0] AIOut; //AI棋子的摆放
output wire finish; //AI是否已经结束了自己的计算
output reg[3:0]x,y; //AI最近一次选择的位置


reg isFinished; //标志着是否结束的寄存器
reg [224:0]AI; //保存AI的布局的寄存器组
reg [9:0] target; //当前枚举到的棋盘位置
reg empty; //枚举点是否为空
reg [9:0] humanPos; //人类的最大受益点
reg [9:0] aiPos; //AI的最大收益点
reg state; //当前AI模块的状态
reg [31:0] maxAi,maxHm,maxHmForAi,maxAiForHm; //分别记录AI的最大收益,人类的最大收益,AI最大收益处人类的收益,人类收益最大处AI的收益
reg [31:0] sumAi,sumHm; //用来临时的保存每个枚举点四个方向的估值和

/*
	AI模块每一轮都会对每一个空位估值，分别为人类在这里下以及AI在这里下估值。
	对人类的收益估值主要是为了判断是否需要防守，相当于一个交换立场思考的过程。
	由于我们采用的贪心算法，每个方向的估值只有落子点及左右四个点的状态是有意义的。
*/
reg [8:0] aAi,aHm,bAi,bHm,cAi,cHm,dAi,dHm,aAit,aHmt,bAit,bHmt,cAit,cHmt,dAit,dHmt; 
//四个方向上，人类和AI分别作为障碍时的状态
wire [2:0] aTypeAi,aTypeHm,bTypeAi,bTypeHm,cTypeAi,cTypeHm,dTypeAi,dTypeHm;
//四个方向上，人类和AI的棋形
wire [31:0] aValueAi,aValueHm,bValueAi,bValueHm,cValueAi,cValueHm,dValueAi,dValueHm;
//四个方向上，人类和AI的估值
reg firstIn; 
reg firstValid;

assign AIOut[224:0]=AI[224:0];
assign finish=isFinished;


//开启八个棋形判断器，分别判断AI和人类四个方向的棋形
judgeChessForm aAiJudge(aAi,aHmt,aTypeAi);
judgeChessForm aHmJudge(aHm,aAit,aTypeHm);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
judgeChessForm bAiJudge(bAi,bHmt,bTypeAi);
judgeChessForm bHmJudge(bHm,bAit,bTypeHm);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
judgeChessForm cAiJudge(cAi,cHmt,cTypeAi);
judgeChessForm cHmJudge(cHm,cAit,cTypeHm);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
judgeChessForm dAiJudge(dAi,dHmt,dTypeAi);
judgeChessForm dHmJudge(dHm,dAit,dTypeHm);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//开启八个估值器，接受AI/人类四个方向的棋形，给出估值
evaluate aAiEva(aTypeAi,aValueAi);
evaluate aHmEva(aTypeHm,aValueHm);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
evaluate bAiEva(bTypeAi,bValueAi);
evaluate bHmEva(bTypeHm,bValueHm);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
evaluate cAiEva(cTypeAi,cValueAi);
evaluate cHmEva(cTypeHm,cValueHm);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
evaluate dAiEva(dTypeAi,dValueAi);
evaluate dHmEva(dTypeHm,dValueHm);



integer row,col;
integer i,j,k;

//AI模块由时序同步触发或者rest信号异步触发
/*
	AI模块会枚举棋盘上15*15=255个位置。
	我们把整个枚举过程分解到若干个时钟周期钟去做。
	可以理解为一个状态机。
	整个状态机总共有510个状态。
	我们用target和state共同表示。
	其中target用来枚举255个位置。
	state=0的时候，修改输入到棋形判断器的棋子信息。
	state=1的时候，从估值器中取出估值，做最优化筛选。
*/
always @(posedge clk or negedge reset)
begin

	if(!reset)
		begin
			firstIn<=1;
			AI<=0;
			AI[112]<=1;
			isFinished<=0;
		end
	//如果是reset信号被激活，初始化棋盘状态
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	else if(enable)

		begin//1
			if(firstIn==1)
				begin
					x<=7;
					y<=7;
					isFinished<=1;
					firstIn<=0;
				end
			//如果是第一次落子，不用估值，直接在中心落子
			//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			else
				begin//3
					if(isFinished)
						begin
							target<=0;
							isFinished<=0;
							state<=0;
							firstValid<=1;
						end
					 //AI模块在这个时钟脉冲才被拉起,初始化枚举量
					//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					else
						begin
							if(state==0)//state==0,修改输入估值器的棋子信息
								begin
									if(target==225)//枚举结束,进入终止状态
										begin
											if(maxAi>maxHm)//判断进攻还是防守，选择落子点
												begin
													AI[aiPos]<=1;
													x<=aiPos/15;
													y<=aiPos%15;
												end
											else
												begin
													AI[humanPos]<=1;
													x<=humanPos/15;
													y<=humanPos%15;
												end
											 isFinished<=1;
											 target<=0;
											 //结束AI's turn,重置枚举量,发出结束信号
										end
									else 
										begin
											empty<=0;
											if(humanIn[target]==0&&AI[target]==0)//如果枚举点是空的
												begin
													empty<=1;//更新空位标记
													row=target/15;
													col=target%15;
													/*
														下面开始更新四个方向的棋子信息
													*/
														//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  从左到右方向的棋子信息
														for(i=-4;i<=4;i=i+1) 
														if(col+i<0||col+i>14)
															begin
																aHmt[i+4]<=1;
																aAit[i+4]<=1;
																aHm[i+4]<=0;
																aAi[i+4]<=0;
															end
														else 
															begin
																if(i==0)
																	begin
																		aHm[i+4]<=1;
																		aAi[i+4]<=1;
																		aHmt[i+4]<=0;
																		aAit[i+4]<=0;
																	end
																else
																	begin
																		aHm[i+4]<=humanIn[target+i];
																		aHmt[i+4]<=humanIn[target+i];
																		aAi[i+4]<=AI[target+i];
																		aAit[i+4]<=AI[target+i];
																	end
															end
															//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 从上到下的棋子信息
														for(i=-4;i<=4;i=i+1)
														if(row+i<0||row+i>14)
															begin
																bHmt[i+4]<=1;
																bAit[i+4]<=1;
																bHm[i+4]<=0;
																bAi[i+4]<=0;
															end
														else 
															begin
																if(i==0)
																	begin
																		bHm[i+4]<=1;
																		bAi[i+4]<=1;
																		bHmt[i+4]<=0;
																		bAit[i+4]<=0;
																	end
																else
																	begin
																		bHm[i+4]<=humanIn[target+i*15];
																		bHmt[i+4]<=humanIn[target+i*15];
																		bAi[i+4]<=AI[target+i*15];
																		bAit[i+4]<=AI[target+i*15];
																	end
															end
														//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //从左上到右下
														for(i=-4;i<=4;i=i+1)
														if(row+i<0||row+i>14||col+i<0||col+i>14)
															begin
																cHmt[i+4]<=1;
																cAit[i+4]<=1;
																cHm[i+4]<=0;
																cAi[i+4]<=0;
															end
														else 
															begin
																if(i==0)
																	begin
																		cHm[i+4]<=1;
																		cAi[i+4]<=1;
																		cHmt[i+4]<=0;
																		cAit[i+4]<=0;
																	end
																else
																	begin
																		cHm[i+4]<=humanIn[target+i*15+i];
																		cHmt[i+4]<=humanIn[target+i*15+i];
																		cAi[i+4]<=AI[target+i*15+i];
																		cAit[i+4]<=AI[target+i*15+i];
																	end
															end
														//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //从左下到右上
														for(i=-4;i<=4;i=i+1)
														if(row+i<0||row+i>14||col-i<0||col-i>14)
															begin
																dHmt[i+4]<=1;
																dAit[i+4]<=1;
																dHm[i+4]<=0;
																dAi[i+4]<=0;
															end
														else 
															begin
																if(i==0)
																	begin
																		dHm[i+4]<=1;
																		dAi[i+4]<=1;
																		dHmt[i+4]<=0;
																		dAit[i+4]<=0;
																	end
																else
																	begin
																		dHm[i+4]<=humanIn[target+i*15-i];
																		dHmt[i+4]<=humanIn[target+i*15-i];
																		dAi[i+4]<=AI[target+i*15-i];
																		dAit[i+4]<=AI[target+i*15-i];
																	end
															end
														//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
								
												end//xx
												state<=~state; //state反相
												target<=target+1; //枚举量位移
										end//yy	
									end//ZZ
								else    //state==1
									begin//AA
										if(empty==1) //如果枚举点为空,获取估值信息,更新最优点
												begin
													sumAi=aValueAi+bValueAi+cValueAi+dValueAi;
													sumHm=aValueHm+bValueHm+cValueHm+dValueHm;
													//分别将四个方向的估值相加,这里必须要用阻塞赋值
													if(firstValid) //如果是第一次找到有效的枚举点,最优值就是当前枚举点
														begin
															maxAi<=sumAi;
															maxAiForHm<=sumAi;
															maxHm<=sumHm;
															maxHmForAi<=sumHm;
															aiPos<=target-1;
															humanPos<=target-1;
															firstValid<=0;
														end
													else  //否则和之前的最优值比较,更新
														begin
															if(sumAi>maxAi||(sumAi==maxAi&&sumHm>maxHmForAi))
																begin
																	maxAi<=sumAi;
																	maxHmForAi<=sumHm;
																	aiPos<=target-1;
																end
															if(sumHm>maxHm||(sumHm==maxHm&&sumAi>maxAiForHm))
																begin
																	maxHm<=sumHm;
																	maxAiForHm<=sumAi;
																	humanPos<=target-1;
																end
														end
												end
										
												state<=~state;
									end//AA
						end//4
				end//3
		
		
		end//1
end
endmodule 
