%���õ�����ȡ�װ����Ӻ���
%Get_Specture_Envelope_9:����ʹ�õ��ǽ̿���ĵ��׷�
%Specture_Envelope=Get_Specture_Envelope_9(X)
%��ڲ�����
%   X��Ϊ��֡���źž�����������P�ı��ٶȺ�ķ����׾������һ��Ϊһ֡�ź�,֡����֡��
%   LowPoint:��ʱ������
%���ڲ�����
%   Specture_Envelope����ȡ���ĸ�֡�������װ���
%2016��3��8��10:47:35

function Specture_Envelope=Get_Specture_Envelope_9(X,LowPoint)
%��ʱ�����ݾ���ѡȡ����1024���FFT����ʱ����ʱ���Ĵ���ȡ44��

framenumber=size(X,2);
for i=1:1:framenumber  %��֡����
    xx=X(:,i);                                         % ����һ֡����
    wlen=length(xx);                                  % ֡��
    cepstL=LowPoint;                                        % ��Ƶ���ϴ������Ŀ��
    Mam(:,i)=ifft(log(xx));
    cepst=zeros(wlen,1);
    cepst(1:cepstL)=Mam(1:cepstL);                 % ��ʽ(9-2-5)����
    cepst(end-cepstL+2:end)=Mam(end-cepstL+2:end);    
    %Specture_Envelope(:,i)=abs(exp(fft(cepst)));    %���Ĺ�ʽ3.22   
    Specture_Envelope(:,i)=real(fft(cepst));         %�̿���ھ��¹�ʽ
end

end