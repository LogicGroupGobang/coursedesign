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
	AI���ֵĵײ�ģ��
*/
input wire clk,enable;
input wire reset;
input wire [224:0] humanIn; //�������ӵİڷ�
output wire [224:0] AIOut; //AI���ӵİڷ�
output wire finish; //AI�Ƿ��Ѿ��������Լ��ļ���
output reg[3:0]x,y; //AI���һ��ѡ���λ��


reg isFinished; //��־���Ƿ�����ļĴ���
reg [224:0]AI; //����AI�Ĳ��ֵļĴ�����
reg [9:0] target; //��ǰö�ٵ�������λ��
reg empty; //ö�ٵ��Ƿ�Ϊ��
reg [9:0] humanPos; //�������������
reg [9:0] aiPos; //AI����������
reg state; //��ǰAIģ���״̬
reg [31:0] maxAi,maxHm,maxHmForAi,maxAiForHm; //�ֱ��¼AI���������,������������,AI������洦���������,�����������AI������
reg [31:0] sumAi,sumHm; //������ʱ�ı���ÿ��ö�ٵ��ĸ�����Ĺ�ֵ��

/*
	AIģ��ÿһ�ֶ����ÿһ����λ��ֵ���ֱ�Ϊ�������������Լ�AI�������¹�ֵ��
	������������ֵ��Ҫ��Ϊ���ж��Ƿ���Ҫ���أ��൱��һ����������˼���Ĺ��̡�
	�������ǲ��õ�̰���㷨��ÿ������Ĺ�ֵֻ�����ӵ㼰�����ĸ����״̬��������ġ�
*/
reg [8:0] aAi,aHm,bAi,bHm,cAi,cHm,dAi,dHm,aAit,aHmt,bAit,bHmt,cAit,cHmt,dAit,dHmt; 
//�ĸ������ϣ������AI�ֱ���Ϊ�ϰ�ʱ��״̬
wire [2:0] aTypeAi,aTypeHm,bTypeAi,bTypeHm,cTypeAi,cTypeHm,dTypeAi,dTypeHm;
//�ĸ������ϣ������AI������
wire [31:0] aValueAi,aValueHm,bValueAi,bValueHm,cValueAi,cValueHm,dValueAi,dValueHm;
//�ĸ������ϣ������AI�Ĺ�ֵ
reg firstIn; 
reg firstValid;

assign AIOut[224:0]=AI[224:0];
assign finish=isFinished;


//�����˸������ж������ֱ��ж�AI�������ĸ����������
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

//�����˸���ֵ��������AI/�����ĸ���������Σ�������ֵ
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

//AIģ����ʱ��ͬ����������rest�ź��첽����
/*
	AIģ���ö��������15*15=255��λ�á�
	���ǰ�����ö�ٹ��̷ֽ⵽���ɸ�ʱ��������ȥ����
	�������Ϊһ��״̬����
	����״̬���ܹ���510��״̬��
	������target��state��ͬ��ʾ��
	����target����ö��255��λ�á�
	state=0��ʱ���޸����뵽�����ж�����������Ϣ��
	state=1��ʱ�򣬴ӹ�ֵ����ȡ����ֵ�������Ż�ɸѡ��
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
	//�����reset�źű������ʼ������״̬
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
			//����ǵ�һ�����ӣ����ù�ֵ��ֱ������������
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
					 //AIģ�������ʱ������ű�����,��ʼ��ö����
					//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					else
						begin
							if(state==0)//state==0,�޸������ֵ����������Ϣ
								begin
									if(target==225)//ö�ٽ���,������ֹ״̬
										begin
											if(maxAi>maxHm)//�жϽ������Ƿ��أ�ѡ�����ӵ�
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
											 //����AI's turn,����ö����,���������ź�
										end
									else 
										begin
											empty<=0;
											if(humanIn[target]==0&&AI[target]==0)//���ö�ٵ��ǿյ�
												begin
													empty<=1;//���¿�λ���
													row=target/15;
													col=target%15;
													/*
														���濪ʼ�����ĸ������������Ϣ
													*/
														//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  �����ҷ����������Ϣ
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
															//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ���ϵ��µ�������Ϣ
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
														//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //�����ϵ�����
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
														//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //�����µ�����
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
												state<=~state; //state����
												target<=target+1; //ö����λ��
										end//yy	
									end//ZZ
								else    //state==1
									begin//AA
										if(empty==1) //���ö�ٵ�Ϊ��,��ȡ��ֵ��Ϣ,�������ŵ�
												begin
													sumAi=aValueAi+bValueAi+cValueAi+dValueAi;
													sumHm=aValueHm+bValueHm+cValueHm+dValueHm;
													//�ֱ��ĸ�����Ĺ�ֵ���,�������Ҫ��������ֵ
													if(firstValid) //����ǵ�һ���ҵ���Ч��ö�ٵ�,����ֵ���ǵ�ǰö�ٵ�
														begin
															maxAi<=sumAi;
															maxAiForHm<=sumAi;
															maxHm<=sumHm;
															maxHmForAi<=sumHm;
															aiPos<=target-1;
															humanPos<=target-1;
															firstValid<=0;
														end
													else  //�����֮ǰ������ֵ�Ƚ�,����
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
