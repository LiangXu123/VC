%���㵥֡�Ļ������ں���,ʹ�õ��ǵ��׷�
%Period=GetPitch(Signal,fs,T1)
%��ڲ�����
%   Signal����֡�źţ���׼Ϊ���ź�
%   fs��ԭʼ�źŲ���Ƶ��
%   T1�������˵���Ĳ����������ر�ֵ��T1��СΪ����ֵ
%���ڲ�����
%   Period����֡�Ļ�������ֵ
%2016��3��2��13:56:15
function Period=GetPitch(Signal,fs)
if size(Signal,2)~=1, Signal=Signal'; end                   % ��yת��Ϊÿ�����ݱ�ʾһ֡�����ź�
%Voiced=frame_vad1(Signal,T1);

lmin=fix(fs/500);                           % �������ڵ���Сֵ------��P.207������Ƶ�׶�Ӧ��ϵ���
lmax=fix(fs/60);                            % �������ڵ����ֵ

%if Voiced==1                             % �Ƿ����л�֡��,SFֵΪ1��֡����������֡���Ž��м������������
y1=Signal.*hamming(size(Signal,1));           % ȡ��һ֡���ݼӴ�����
xx=fft(y1);                         % FFT
a=2*log(abs(xx)+eps);               % ȡģֵ�Ͷ���
b=ifft(a);                          % ��ȡ����
[R,Lc]=max(b(lmin:lmax));     % ��lmin��lmax������Ѱ�����ֵ
Period=Lc+lmin-1;             % ������������
%end

%debug begin here
%AA=period-Lc;
%ע�⣺���������ź�ʱ������Ļ���Ƶ�ʲ�һ����0

%debug end here

end