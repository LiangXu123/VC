%���رȷ�ʵ�������źŵĶ˵���
%Is_Voiced=Voiced_detect(y,frame_number,T1,miniL)
%��ڲ�����
%   y����֡��������źţ�֡����֡��
%   frame_number��֡��
%���ڲ�����
%   Is_Voiced���л�֡���λ����С��1��֡�����󣬸�֡�ж�Ϊ�л�֡��SF��֡�������ֵ��Ϊ1���޻�ֵ֡��Ϊ0
%2016��3��18��15:02:55
function Is_Voiced=Voiced_detect(y,frame_number,fs,inc)
if size(y,2)~=frame_number, y=y'; end                   % ��yת��Ϊÿ�����ݱ�ʾһ֡�����ź�
%���¼���ʱ֡�ź�y����Ķ���һ��Ϊһ֡������Ϊ֡��
wlen=size(y,1);                               % ȡ��֡��
Is_Voiced=zeros(1,frame_number);              %����������־λ��1������������0������

aparam=2;                                    % ���ò���
IS=0.25;                                % ����ǰ���޻��γ���
NIS=fix((IS*fs-wlen)/inc +1);           % ��ǰ���޻���֡��

for i=1:frame_number
    Sp = abs(fft(y(:,i)));                   % FFT�任ȡ��ֵ
    Sp = Sp(1:wlen/2+1);	                 % ֻȡ��Ƶ�ʲ���
    Esum(i) = log10(1+sum(Sp.*Sp)/aparam);   % �����������ֵ
    prob = Sp/(sum(Sp));		             % �������
    H(i) = -sum(prob.*log(prob+eps));        % ������ֵ
    Ef(i) = sqrt(1 + abs(Esum(i)/H(i)));     % �������ر�
end   

Enm=multimidfilter(Ef,10);                   % ƽ���˲� 
Me=max(Enm);                                 % Enm���ֵ
eth=mean(Enm(1:NIS));                        % ��ʼ��ֵeth
Det=Me-eth;                                  % ���ֵ��������ֵ
T1=0.05*Det+eth;
T2=0.1*Det+eth;
Is_Voiced=vad_param1D(Enm,T1,T2); % �����رȷ���˫���޶˵���
