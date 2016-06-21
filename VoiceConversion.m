%实现论文3．2.1提出的基于重采样的基频改变算法
%取消论文步骤3中的对采用基于改进二次谱提取基频的时长规整算法调整语音的时长，恢
%复至原始语音的播放速度
%2016年3月17日20:43:01
%%4以后的版本信号操作流程：
%1·（先通过滤波器或者不通过视情况而定）改变语音信号Sn的播放速度
%2·使用二次谱时长规整算法分帧
%3·清浊音检测--正常流程
%%

%%为了方便接将代码封装为函数，先在开始部分初始化需要的入口参数
%clc
clear all;
close all;
tic
%变速因子S,一般设为偶数
filename='yuyin.wav';
Is_Male2Female=1;   %男声转女声标志位，为1表示男声转女声，为0为其他

Speed=1.8;
Change_Envelop=1.5;
overlap_rate=0.4;

LowTimePoint=40;
%%目标语音是女生时Speed大于1
%%目标语音是男声时Speed小于1
[xx,fs]=audioread(filename);  %录音文件
Original_Signal_0=xx(:,1);
%保证输入信号为一列信号
if size(Original_Signal_0,1)==1   %将行信号转换为列信号
    Original_Signal=Original_Signal_0';
end
if mod(size(Original_Signal_0,1),2)==1  %长度为奇数不能对分
    Original_Signal=Original_Signal_0(1:end-1,1);
else
    Original_Signal=Original_Signal_0;
end

frame_time=24;   %想要设定的每帧信号的时长ms为单位，此时设定为每帧信号23ms长，修改帧长时只需要修改此参数！
frame_length=floor(fs/1000*frame_time);
step_inc=floor(frame_length*overlap_rate);              % 分帧的帧长和帧移
if frame_length>=1024
    frame_length=1024;
end

%%预处理
%预计加重滤波器
b=[1 -0.958];
a=[1 0];
Original_Signal=filter(b,a,Original_Signal);
%带通滤波器
%Wn∈[0,1]，其中1对应于0.5fs，fs为采样频率（单位Hz）；在设计模拟滤波器时，Wn采用真实频率，单位为Hz。
%当Wn为二元向量，即Wn = [W1 W2] (W1<W2)时，[b,a] = butter(n,Wn)返回一个2n阶数字带通滤波器，其通带为W1<ω< W2。
WW=fs/2;
Wn=[50 600]/WW;  %通带为50Hz--600Hz   
n=1;    %滤波器阶数
[b1,a1] = butter(n,Wn);
Original_Signal=filter(b1,a1,Original_Signal);
%figure,subplot(211),plot(20*log10(abs(fft(Original_Signal))),'r'),subplot(212),plot(20*log10(abs(fft(Original_Signal1))),'g');
sound(Original_Signal,fs);
%%预处理结束

%%
%第二步开始，改变语音的播放速度，
%%此处改变的是全时域信号的播放速度
Change_Speed_Signal=Change_Speed(Original_Signal,Speed);
%figure,subplot(211),plot(Original_Signal,'r'),subplot(212),plot(Change_Speed_Signal,'g');
%sound(Change_Speed_Signal,fs);
Xmp=GetRecMatrix(Change_Speed_Signal,fs,frame_length,1/Speed);
framenumber=size(Xmp,2); %帧数
%Xmp为分帧后信号，一列为一帧信号,帧长×帧数
for i=1:1:framenumber    %逐帧处理加窗函数
    Xmp(:,i)=Xmp(:,i).*hamming(frame_length);
end
Is_Voiced=Voiced_detect(Xmp,framenumber,fs,overlap_rate*frame_length);  %清浊音检测
freq=(0:frame_length-1)*fs/frame_length;
%figure,subplot(211),plot(Original_Signal,'r');subplot(212),stem(Is_Voiced);
%aa=find(Is_Voiced==1);

%第三步完成
%%第四步调用子函数完成，便于调试
%%
for i=1:1:framenumber    %逐帧处理
    if Is_Voiced(i)==1  %只对浊音处理
        %Eamp为利用倒谱提取出来的谱包络
        %Xmp的傅里叶变换为Xmpk
        %对每帧浊音数据数据加汉明窗
       % Xmp(:,i)=Xmp(:,i).*hamming(frame_length);
        Xmpk(:,i)=fft(Xmp(:,i));    %信号频谱
        Xampk(:,i)=abs( Xmpk(:,i)); %幅度谱
        Xpmpk(:,i)=angle( Xmpk(:,i));   %相位谱
        Eamp(:,i)=Get_Specture_Envelope(Xampk(:,i),LowTimePoint);
 %       OLD=20*log10(Xampk(:,i));
 %       NEW=20*log10(Eamp(:,i));
 %       figure;plot(OLD(1:end/4),'k'),axis([0 250 -70 10]);
 %       hold on,plot(NEW(1:end/4),'k','LineWidth',2);ylabel('幅值dB');xlabel('频率');
 %       legend('-幅度谱','-提取出的谱包络');
        %只对浊音处理,等比例压扩频谱包络
        Enamp(:,i)=Adjust_Envelope(Eamp(:,i),Change_Envelop);
        OLD=20*log10(Eamp(:,i));
        NEW=20*log10(Enamp(:,i));
        figure;plot(OLD(1:end/4),'k'),axis([0 250 -70 -10]);
        hold on,plot(NEW(1:end/4),'LineWidth',2);ylabel('幅值dB');xlabel('频率');
        legend('-原始谱包络','-修改后谱包络');       title(['调整因子F=',num2str(Change_Envelop)]);

        if Is_Male2Female==1    %男女声频谱倾斜差异补偿方法
            Num=size(find(freq<4000),2);
            Enamp(:,i)=m2f_Compensate(Enamp(:,i),freq,Num,6);
        end
        %  subplot(211),plot(freq,Enamp(:,1),'r');subplot(212),plot(freq,Enamp1(:,1),'g');
        
        
        %去包络谱Gamp
        Gamp(:,i)=Xampk(:,i)./Eamp(:,i);   %计算方法有待探究
        %第六步将新谱包络和原始去包络的残留谱重新合成为新的幅度谱
        Xnampk(:,i)=Enamp(:,i).*Gamp(:,i);
        
        %第七步将新的幅度谱和原始相位谱重新合成为新的短时谱
        Xnmpk(:,i)=Xnampk(:,i).*exp(1i*Xpmpk(:,i));
        %第八步对新的短时谱Xnmp(k)进行反傅立叶变换后得到新的基于帧的时域信号
        Xnmp(:,i)=real(ifft(Xnmpk(:,i)));
        %figure;plot(real(Xnmp(:,i)),'r'),hold on,plot(Xmp(:,i),'g');
    end
end

for i=1:1:framenumber    %逐帧处理
    if Is_Voiced(i)==0  %清音补回,补回的是最原始的信号，使用矩阵窗进行的分帧
        Xnmp(:,i)=Xmp(:,i);
    end
end
%%
%figure;plot(Eamp(:,1),'r'),hold on;plot(Enamp(:,1),'k');title(['变速因子S=',num2str(Speed)]);
%OLA合成测试
Frame=Xnmp;
Ss=frame_length/2;
W=size(Frame,1);
%合成阶段开始
%在合成阶段对各帧加窗
OutSignal=zeros((size(Frame,2)-1)*Ss+W,1);
for i=1:1:(size(Frame,2)-1) %不包括最后一帧
    yy=Frame(:,i).*hamming(size(Frame,1));           % 取来一帧数据加窗函数
    if i==1  %第一帧信号不需要做重叠相加
        OutSignal(1:W)=yy;
    else
        OutSignal((i-1)*Ss+1:(i-1)*Ss+W)=yy+OutSignal((i-1)*Ss+1:(i-1)*Ss+W);
    end
end
OutSignal((size(Frame,2)-1)*Ss+1:(size(Frame,2)-1)*Ss+W)=Frame(size(Frame,2)).*hamming(size(Frame(size(Frame,2)),1))...
    +OutSignal((size(Frame,2)-1)*Ss+1:(size(Frame,2)-1)*Ss+W);
sound(OutSignal,fs);

audiowrite('m2f-xidian-1.wav',OutSignal,fs);

%figure,plot(20*log10(abs(fft(Original_Signal))),'r'),hold on;plot(20*log10(abs(fft(OutSignal))),'b');

toc
%figure,plot(Original_Signal,'r'),hold on;plot(OutSignal,'g'),title('原始时域信号与转换时域信号');
