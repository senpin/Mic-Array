clear all;close all;
% [s1,fs,bits]=wavread( 'F:\cocktail and tc and pesq\Audio\chen10月24验证测试clean\音频 02_16_01.wav'); %输入无扰信号源 
[s2,fs,bits]=wavread( 'F:\cocktail and tc and pesq\Audio\chen10月24验证测试clean\音频 02_16_01.wav'); %输入无扰信号源 
[s3,fs,bits]=wavread( 'F:\cocktail and tc and pesq\Audio\chen10月24验证测试clean\音频 02_16_01.wav'); %输入无扰信号源 
[s4,fs,bits]=wavread( 'F:\cocktail and tc and pesq\Audio\chen10月24验证测试clean\音频 02_16_01.wav'); %输入无扰信号源 
[s5,fs,bits]=wavread( 'F:\cocktail and tc and pesq\Audio\chen10月24验证测试clean\音频 02_16_01.wav'); %输入无扰信号源 
[s6,fs,bits]=wavread( 'F:\cocktail and tc and pesq\Audio\chen10月24验证测试clean\音频 02_16_01.wav'); %输入无扰信号源 
[s7,fs,bits]=wavread( 'F:\cocktail and tc and pesq\Audio\chen10月24验证测试clean\音频 02_16_01.wav'); %输入无扰信号源 
   s2=s2(1.35*8000:3.35*8000,1);
   s3=s3(1.35*8000:3.35*8000,1);
   s4=s4(1.35*8000:3.35*8000,1);
   s5=s5(1.35*8000:3.35*8000,1);
   s6=s6(1.35*8000:3.35*8000,1);
   s7=s7(1.35*8000:3.35*8000,1);

s1=[s2,s3,s4,s5,s6,s7];
m= 6 ;% array阵元
p=1; %  signal number信号数
N=3000;% recursive number 迭代次数 或快拍数
A=zeros(m,p); % array pattern阵列流型
theta=[60]*pi/180;% the signal from the direction of 30 degree is expected. DOA 30为期望信号方向
phi=[90]*pi/180;
j=sqrt(-1);
%
% s=to_get_s(w,N,p);
% s_rec=get_s_rec(s,m,p,theta);
% S=s_rec; %  output date matrix  .m*N 的阵元输出数据矩阵
%%%%——————————————%% 自适应调节权
y=s1';% input data of GSC;
ad=exp(-j*pi*[0:m-1]'*sin(theta(1))); %steering vector in the direction of expected. 期望信号方向导向矢量
% ad=exp(-j*pi*cos(2*pi*[0:m-1]'/m-theta(2))); 
% a_theta=exp(j*2*pi*R*cos(2*pi*K'/M-theta(iii)*pi/180)*cos(phi(ii)*pi/180)); 
% ed = [sin(90*pi/180)*cos(45*pi/180); sin(90*pi/180)*sin(45*pi/180); cos(90*pi/180)];
% rn=[0:m-1]';
% rn = [rn zeros(m,2)];
% d0 = exp(-j * 2*pi*1000/340 *rn* ed);
c=10;%  condition 波束形成条件
C=ad';
Wc=C'*inv(C*C')*c; %main path weight 主通道固定权
wa(1:m-1,1)=0;  % auxiliary path  辅助通道自适应权
B=get_B(m,theta); % get Block Matrix 得到阻塞矩阵
u=0.000001;
for k=1:N
    yb=conj(B)*y(:,k);  % m-1*1 的列向量
    Zc(k)=Wc.'*y(:,k);
    Za(k)=wa(:,k).'*yb;
    Z(k)=Zc(k)-Za(k);
    wa(:,k+1)=wa(:,k)-u*Z(k)*conj(yb);
end
%%%%------------
%%%main path 主通道
% wop=Wc;
% drawpp(m,wop);
% %%%%auxiliary path 辅助通道
% wop=B'*wa(:,N)
% drawpp(m,wop);
%%array response 总的阵列响应
wop=Wc-B'*wa(:,N);
% drawpp(m,wop);
y=s1*wop;outlen=length(s1(:,1));
t = (0:outlen-1)/fs;
figure
plot(t,s1(:,1));
xlabel('Time (sec)'); ylabel ('Amplitude (V)');
% axis([0 7 -0.2 0.2]);
%  sound(sigArray(:,1));
% y=y/max(abs(y));
figure
plot(t,y);
xlabel('Time (sec)'); ylabel ('Amplitude (V)');
title('Signal y');
% wavwrite(y,fs,'C:\Users\Administrator\Desktop\4阵元\yout91')
wavwrite(y,fs,'F:\cocktail and tc and pesq\Audio\youtgsc.wav');
% plot(yout');