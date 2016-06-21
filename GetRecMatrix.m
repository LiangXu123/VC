%ʵ�������������ʱ������㷨
%���źŽ���ʱ������
%2016��3��2��10:57:55
function Frame=GetRecMatrix(Original_Signal,fs,framelength,F)

if size(Original_Signal,1)==1   %�ź�Ϊ�����ź�,��ת��Ϊ�����ź�
    Original_Signal=Original_Signal';
end
Original_Signal_Length=size(Original_Signal,1);

W=framelength;  %WΪ������ʹ�õĵ���
Ss=W/2;     %OLA�㷨һ��̶�Ss������F��С����Sa
Sa=F*Ss;

Frame(1:W,1)=Original_Signal(1:W);
p(1)=GetPitch(Frame(1:W,1),fs);  %����
S1=floor(Ss/p(1));    %ȡ����
Sr1=mod(Ss,p(1));     %ȡ����
A1=floor(Sa/p(1));
Ar1=mod(Sa,p(1));
RSa(1)=0;       %�þ����¼RSa���
RSa(2)=GetRSa(S1,Sr1,A1,Ar1,p(1),F,RSa(1));   %��ǰ֡Ϊ��һ֡�����һ������Ϊ��ǰ֡�����,��һ֡�������0


for i=2:1:Original_Signal_Length
    if (W+RSa(i))>=Original_Signal_Length       %���һ֡
        Frame(1:(Original_Signal_Length-RSa(i)),i)=Original_Signal(1+RSa(i):end);   %ע�����һ֡���ݵĳ���
        break;
    else
        Frame(1:W,i)=Original_Signal(1+RSa(i):W+RSa(i));
        p(i)=GetPitch(Frame(1:W,i),fs);  %����
        S=floor(Ss/p(i));    %ȡ����
        Sr=mod(Ss,p(i));     %ȡ����
        
        Different=i*Sa-RSa(i);
        A=floor(Different/p(i));
        Ar=mod(Different,p(i));
        RSa(i+1)=GetRSa(S,Sr,A,Ar,p(i),F,RSa(i));
    end
end
%�ֽ�׶����
end