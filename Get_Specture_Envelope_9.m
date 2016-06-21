%利用倒谱提取谱包络子函数
%Get_Specture_Envelope_9:代表使用的是教科书的倒谱法
%Specture_Envelope=Get_Specture_Envelope_9(X)
%入口参数：
%   X：为分帧后信号经过变速因子P改变速度后的幅度谱矩阵矩阵，一列为一帧信号,帧长×帧数
%   LowPoint:低时窗点数
%出口参数：
%   Specture_Envelope：提取出的各帧语音的谱包络
%2016年3月8日10:47:35

function Specture_Envelope=Get_Specture_Envelope_9(X,LowPoint)
%低时窗根据经验选取，，1024点的FFT计算时，低时窗的窗宽取44点

framenumber=size(X,2);
for i=1:1:framenumber  %逐帧处理
    xx=X(:,i);                                         % 读入一帧数据
    wlen=length(xx);                                  % 帧长
    cepstL=LowPoint;                                        % 倒频率上窗函数的宽度
    Mam(:,i)=ifft(log(xx));
    cepst=zeros(wlen,1);
    cepst(1:cepstL)=Mam(1:cepstL);                 % 按式(9-2-5)计算
    cepst(end-cepstL+2:end)=Mam(end-cepstL+2:end);    
    %Specture_Envelope(:,i)=abs(exp(fft(cepst)));    %论文公式3.22   
    Specture_Envelope(:,i)=real(fft(cepst));         %教科书第九章公式
end

end