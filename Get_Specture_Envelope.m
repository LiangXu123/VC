%���õ�����ȡ�װ����Ӻ���
%Get_Specture_Envelope:%���Ĺ�ʽ3.22 
%Specture_Envelope=Get_Specture_Envelope(X)
%��ڲ�����
%   X��Ϊ��֡���źž�����������P�ı��ٶȺ�ķ����׾������һ��Ϊһ֡�ź�,֡����֡��
%   LowPoint:��Ƶ���ϴ������Ŀ��
%���ڲ�����
%   Specture_Envelope����ȡ���ĸ�֡�������װ���
%2016��3��8��10:47:35

function Specture_Envelope=Get_Specture_Envelope(X,LowPoint)
%��ʱ�����ݾ���ѡȡ����1024���FFT����ʱ����ʱ���Ĵ���ȡ44��
wlen=size(X,1);  % ֡��   
Ham=zeros(wlen,1);
framenumber=size(X,2);
for i=1:1:framenumber  %��֡����
    xx=X(:,i);                                         % ����һ֡����
    Mam(:,i)=ifft(log(xx));
    Ham(1:LowPoint)=Mam(1:LowPoint);                 
    Ham(end-LowPoint+2:end)=Mam(end-LowPoint+2:end);    
    Specture_Envelope(:,i)=abs(exp(fft(Ham)));    %���Ĺ�ʽ3.22   
end
end