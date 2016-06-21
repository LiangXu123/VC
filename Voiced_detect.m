%能熵比法实现语音信号的端点检测
%Is_Voiced=Voiced_detect(y,frame_number,T1,miniL)
%入口参数：
%   y：分帧后的语音信号，帧长×帧数
%   frame_number：帧数
%出口参数：
%   Is_Voiced：有话帧标记位。大小是1×帧数矩阵，该帧判定为有话帧则将SF该帧的序号列值置为1，无话帧值置为0
%2016年3月18日15:02:55
function Is_Voiced=Voiced_detect(y,frame_number,fs,inc)
if size(y,2)~=frame_number, y=y'; end                   % 把y转换为每列数据表示一帧语音信号
%以下计算时帧信号y代表的都是一列为一帧，行数为帧长
wlen=size(y,1);                               % 取得帧长
Is_Voiced=zeros(1,frame_number);              %清浊音检测标志位，1代表是浊音，0是清音

aparam=2;                                    % 设置参数
IS=0.25;                                % 设置前导无话段长度
NIS=fix((IS*fs-wlen)/inc +1);           % 求前导无话段帧数

for i=1:frame_number
    Sp = abs(fft(y(:,i)));                   % FFT变换取幅值
    Sp = Sp(1:wlen/2+1);	                 % 只取正频率部分
    Esum(i) = log10(1+sum(Sp.*Sp)/aparam);   % 计算对数能量值
    prob = Sp/(sum(Sp));		             % 计算概率
    H(i) = -sum(prob.*log(prob+eps));        % 求谱熵值
    Ef(i) = sqrt(1 + abs(Esum(i)/H(i)));     % 计算能熵比
end   

Enm=multimidfilter(Ef,10);                   % 平滑滤波 
Me=max(Enm);                                 % Enm最大值
eth=mean(Enm(1:NIS));                        % 初始均值eth
Det=Me-eth;                                  % 求出值后设置阈值
T1=0.05*Det+eth;
T2=0.1*Det+eth;
Is_Voiced=vad_param1D(Enm,T1,T2); % 用能熵比法的双门限端点检测
