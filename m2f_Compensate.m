%一种男女声频谱倾斜差异补偿方法,仅在男声变女声时调用
%Com_spect=m2f_Compensate(Original_spect,theta)
%入口参数：
%   Original_spect：需要被修改的谱包络值,为一列数据
%   freq:频率值
%   Num:频率值小于4000的该列数据的点数
%   theta:，对频率值小于4000Hz的谱包络以零频为顶点顺时针旋转某个小角度(如5度）
%出口参数：
%   Com_spect：倾斜差异补偿后的谱包络值
%2016年3月17日10:28:13
%%
function Com_spect=m2f_Compensate(Original_spect,freq,Num,theta)
Com_spect=Original_spect;
theta=theta/180*pi; %角度换算
g=-0.3;
b=1;
a=[1 -2*g -g*g];
Com_spect(1+Num:end)=filter(b,a,Com_spect(1+Num:end));
for k=1:1:Num   %频率值小于4000的进行男女频谱倾斜差异补偿
    Com_spect(k+5)=Original_spect(k);
end

g1=0.15
a=[1 0 0];
b=[1 2*g1 g1*g1];
Com_spect(1:Num)=filter(b,a,Com_spect(1:Num));
Com_spect=medfilt1(Com_spect,5);        % 5点的中值滤波


%figure,plot(20*log10(Original_spect),'r'),hold on;plot(20*log10(Com_spect),'k'),xlabel('频率Hz'),ylabel('幅值dB');
%其次，将4000Hz以上的谱包络曲线不做改变

end
