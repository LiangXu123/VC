%һ����Ů��Ƶ����б���첹������,����������Ů��ʱ����
%Com_spect=m2f_Compensate(Original_spect,theta)
%��ڲ�����
%   Original_spect����Ҫ���޸ĵ��װ���ֵ,Ϊһ������
%   freq:Ƶ��ֵ
%   Num:Ƶ��ֵС��4000�ĸ������ݵĵ���
%   theta:����Ƶ��ֵС��4000Hz���װ�������ƵΪ����˳ʱ����תĳ��С�Ƕ�(��5�ȣ�
%���ڲ�����
%   Com_spect����б���첹������װ���ֵ
%2016��3��17��10:28:13
%%
function Com_spect=m2f_Compensate(Original_spect,freq,Num,theta)
Com_spect=Original_spect;
theta=theta/180*pi; %�ǶȻ���
g=-0.3;
b=1;
a=[1 -2*g -g*g];
Com_spect(1+Num:end)=filter(b,a,Com_spect(1+Num:end));
for k=1:1:Num   %Ƶ��ֵС��4000�Ľ�����ŮƵ����б���첹��
    Com_spect(k+5)=Original_spect(k);
end

g1=0.15
a=[1 0 0];
b=[1 2*g1 g1*g1];
Com_spect(1:Num)=filter(b,a,Com_spect(1:Num));
Com_spect=medfilt1(Com_spect,5);        % 5�����ֵ�˲�


%figure,plot(20*log10(Original_spect),'r'),hold on;plot(20*log10(Com_spect),'k'),xlabel('Ƶ��Hz'),ylabel('��ֵdB');
%��Σ���4000Hz���ϵ��װ������߲����ı�

end
