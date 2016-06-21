%实现论文中提出的时间规整算法
%对信号进行时长规整
%2016年3月2日10:57:55
function Frame=GetRecMatrix(Original_Signal,fs,framelength,F)

if size(Original_Signal,1)==1   %信号为单行信号,则转换为单列信号
    Original_Signal=Original_Signal';
end
Original_Signal_Length=size(Original_Signal,1);

W=framelength;  %W为论文中使用的点数
Ss=W/2;     %OLA算法一般固定Ss，根据F大小调整Sa
Sa=F*Ss;

Frame(1:W,1)=Original_Signal(1:W);
p(1)=GetPitch(Frame(1:W,1),fs);  %矩阵
S1=floor(Ss/p(1));    %取整数
Sr1=mod(Ss,p(1));     %取余数
A1=floor(Sa/p(1));
Ar1=mod(Sa,p(1));
RSa(1)=0;       %用矩阵记录RSa起点
RSa(2)=GetRSa(S1,Sr1,A1,Ar1,p(1),F,RSa(1));   %当前帧为第一帧，最后一个参数为当前帧的起点,第一帧的起点是0


for i=2:1:Original_Signal_Length
    if (W+RSa(i))>=Original_Signal_Length       %最后一帧
        Frame(1:(Original_Signal_Length-RSa(i)),i)=Original_Signal(1+RSa(i):end);   %注意最后一帧数据的长度
        break;
    else
        Frame(1:W,i)=Original_Signal(1+RSa(i):W+RSa(i));
        p(i)=GetPitch(Frame(1:W,i),fs);  %矩阵
        S=floor(Ss/p(i));    %取整数
        Sr=mod(Ss,p(i));     %取余数
        
        Different=i*Sa-RSa(i);
        A=floor(Different/p(i));
        Ar=mod(Different,p(i));
        RSa(i+1)=GetRSa(S,Sr,A,Ar,p(i),F,RSa(i));
    end
end
%分解阶段完成
end