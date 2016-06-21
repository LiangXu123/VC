%计算单帧的基音周期函数,使用的是倒谱法
%Period=GetPitch(Signal,fs,T1)
%入口参数：
%   Signal：单帧信号，标准为列信号
%   fs：原始信号采样频率
%   T1：基音端点检测的参数，即能熵比值，T1大小为门限值
%出口参数：
%   Period：该帧的基音周期值
%2016年3月2日13:56:15
function Period=GetPitch(Signal,fs)
if size(Signal,2)~=1, Signal=Signal'; end                   % 把y转换为每列数据表示一帧语音信号
%Voiced=frame_vad1(Signal,T1);

lmin=fix(fs/500);                           % 基音周期的最小值------见P.207，根据频谱对应关系算出
lmax=fix(fs/60);                            % 基音周期的最大值

%if Voiced==1                             % 是否在有话帧中,SF值为1的帧代表是浊音帧，才进行计算其基音周期
y1=Signal.*hamming(size(Signal,1));           % 取来一帧数据加窗函数
xx=fft(y1);                         % FFT
a=2*log(abs(xx)+eps);               % 取模值和对数
b=ifft(a);                          % 求取倒谱
[R,Lc]=max(b(lmin:lmax));     % 在lmin和lmax区间中寻找最大值
Period=Lc+lmin-1;             % 给出基音周期
%end

%debug begin here
%AA=period-Lc;
%注意：调入无声信号时计算出的基音频率不一定是0

%debug end here

end