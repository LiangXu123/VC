%ʵ������3��2.1����Ļ����ز����Ļ�Ƶ�ı��㷨
%ȡ�����Ĳ���3�еĶԲ��û��ڸĽ���������ȡ��Ƶ��ʱ�������㷨����������ʱ������
%����ԭʼ�����Ĳ����ٶ�
%2016��3��17��20:43:01
%%4�Ժ�İ汾�źŲ������̣�
%1������ͨ���˲������߲�ͨ��������������ı������ź�Sn�Ĳ����ٶ�
%2��ʹ�ö�����ʱ�������㷨��֡
%3�����������--��������
%%

%%Ϊ�˷���ӽ������װΪ���������ڿ�ʼ���ֳ�ʼ����Ҫ����ڲ���
%clc
clear all;
close all;
tic
%��������S,һ����Ϊż��
filename='yuyin.wav';
Is_Male2Female=1;   %����תŮ����־λ��Ϊ1��ʾ����תŮ����Ϊ0Ϊ����

Speed=1.8;
Change_Envelop=1.5;
overlap_rate=0.4;

LowTimePoint=40;
%%Ŀ��������Ů��ʱSpeed����1
%%Ŀ������������ʱSpeedС��1
[xx,fs]=audioread(filename);  %¼���ļ�
Original_Signal_0=xx(:,1);
%��֤�����ź�Ϊһ���ź�
if size(Original_Signal_0,1)==1   %�����ź�ת��Ϊ���ź�
    Original_Signal=Original_Signal_0';
end
if mod(size(Original_Signal_0,1),2)==1  %����Ϊ�������ܶԷ�
    Original_Signal=Original_Signal_0(1:end-1,1);
else
    Original_Signal=Original_Signal_0;
end

frame_time=24;   %��Ҫ�趨��ÿ֡�źŵ�ʱ��msΪ��λ����ʱ�趨Ϊÿ֡�ź�23ms�����޸�֡��ʱֻ��Ҫ�޸Ĵ˲�����
frame_length=floor(fs/1000*frame_time);
step_inc=floor(frame_length*overlap_rate);              % ��֡��֡����֡��
if frame_length>=1024
    frame_length=1024;
end

%%Ԥ����
%Ԥ�Ƽ����˲���
b=[1 -0.958];
a=[1 0];
Original_Signal=filter(b,a,Original_Signal);
%��ͨ�˲���
%Wn��[0,1]������1��Ӧ��0.5fs��fsΪ����Ƶ�ʣ���λHz���������ģ���˲���ʱ��Wn������ʵƵ�ʣ���λΪHz��
%��WnΪ��Ԫ��������Wn = [W1 W2] (W1<W2)ʱ��[b,a] = butter(n,Wn)����һ��2n�����ִ�ͨ�˲�������ͨ��ΪW1<��< W2��
WW=fs/2;
Wn=[50 600]/WW;  %ͨ��Ϊ50Hz--600Hz   
n=1;    %�˲�������
[b1,a1] = butter(n,Wn);
Original_Signal=filter(b1,a1,Original_Signal);
%figure,subplot(211),plot(20*log10(abs(fft(Original_Signal))),'r'),subplot(212),plot(20*log10(abs(fft(Original_Signal1))),'g');
sound(Original_Signal,fs);
%%Ԥ�������

%%
%�ڶ�����ʼ���ı������Ĳ����ٶȣ�
%%�˴��ı����ȫʱ���źŵĲ����ٶ�
Change_Speed_Signal=Change_Speed(Original_Signal,Speed);
%figure,subplot(211),plot(Original_Signal,'r'),subplot(212),plot(Change_Speed_Signal,'g');
%sound(Change_Speed_Signal,fs);
Xmp=GetRecMatrix(Change_Speed_Signal,fs,frame_length,1/Speed);
framenumber=size(Xmp,2); %֡��
%XmpΪ��֡���źţ�һ��Ϊһ֡�ź�,֡����֡��
for i=1:1:framenumber    %��֡����Ӵ�����
    Xmp(:,i)=Xmp(:,i).*hamming(frame_length);
end
Is_Voiced=Voiced_detect(Xmp,framenumber,fs,overlap_rate*frame_length);  %���������
freq=(0:frame_length-1)*fs/frame_length;
%figure,subplot(211),plot(Original_Signal,'r');subplot(212),stem(Is_Voiced);
%aa=find(Is_Voiced==1);

%���������
%%���Ĳ������Ӻ�����ɣ����ڵ���
%%
for i=1:1:framenumber    %��֡����
    if Is_Voiced(i)==1  %ֻ����������
        %EampΪ���õ�����ȡ�������װ���
        %Xmp�ĸ���Ҷ�任ΪXmpk
        %��ÿ֡�����������ݼӺ�����
       % Xmp(:,i)=Xmp(:,i).*hamming(frame_length);
        Xmpk(:,i)=fft(Xmp(:,i));    %�ź�Ƶ��
        Xampk(:,i)=abs( Xmpk(:,i)); %������
        Xpmpk(:,i)=angle( Xmpk(:,i));   %��λ��
        Eamp(:,i)=Get_Specture_Envelope(Xampk(:,i),LowTimePoint);
 %       OLD=20*log10(Xampk(:,i));
 %       NEW=20*log10(Eamp(:,i));
 %       figure;plot(OLD(1:end/4),'k'),axis([0 250 -70 10]);
 %       hold on,plot(NEW(1:end/4),'k','LineWidth',2);ylabel('��ֵdB');xlabel('Ƶ��');
 %       legend('-������','-��ȡ�����װ���');
        %ֻ����������,�ȱ���ѹ��Ƶ�װ���
        Enamp(:,i)=Adjust_Envelope(Eamp(:,i),Change_Envelop);
        OLD=20*log10(Eamp(:,i));
        NEW=20*log10(Enamp(:,i));
        figure;plot(OLD(1:end/4),'k'),axis([0 250 -70 -10]);
        hold on,plot(NEW(1:end/4),'LineWidth',2);ylabel('��ֵdB');xlabel('Ƶ��');
        legend('-ԭʼ�װ���','-�޸ĺ��װ���');       title(['��������F=',num2str(Change_Envelop)]);

        if Is_Male2Female==1    %��Ů��Ƶ����б���첹������
            Num=size(find(freq<4000),2);
            Enamp(:,i)=m2f_Compensate(Enamp(:,i),freq,Num,6);
        end
        %  subplot(211),plot(freq,Enamp(:,1),'r');subplot(212),plot(freq,Enamp1(:,1),'g');
        
        
        %ȥ������Gamp
        Gamp(:,i)=Xampk(:,i)./Eamp(:,i);   %���㷽���д�̽��
        %�����������װ����ԭʼȥ����Ĳ��������ºϳ�Ϊ�µķ�����
        Xnampk(:,i)=Enamp(:,i).*Gamp(:,i);
        
        %���߲����µķ����׺�ԭʼ��λ�����ºϳ�Ϊ�µĶ�ʱ��
        Xnmpk(:,i)=Xnampk(:,i).*exp(1i*Xpmpk(:,i));
        %�ڰ˲����µĶ�ʱ��Xnmp(k)���з�����Ҷ�任��õ��µĻ���֡��ʱ���ź�
        Xnmp(:,i)=real(ifft(Xnmpk(:,i)));
        %figure;plot(real(Xnmp(:,i)),'r'),hold on,plot(Xmp(:,i),'g');
    end
end

for i=1:1:framenumber    %��֡����
    if Is_Voiced(i)==0  %��������,���ص�����ԭʼ���źţ�ʹ�þ��󴰽��еķ�֡
        Xnmp(:,i)=Xmp(:,i);
    end
end
%%
%figure;plot(Eamp(:,1),'r'),hold on;plot(Enamp(:,1),'k');title(['��������S=',num2str(Speed)]);
%OLA�ϳɲ���
Frame=Xnmp;
Ss=frame_length/2;
W=size(Frame,1);
%�ϳɽ׶ο�ʼ
%�ںϳɽ׶ζԸ�֡�Ӵ�
OutSignal=zeros((size(Frame,2)-1)*Ss+W,1);
for i=1:1:(size(Frame,2)-1) %���������һ֡
    yy=Frame(:,i).*hamming(size(Frame,1));           % ȡ��һ֡���ݼӴ�����
    if i==1  %��һ֡�źŲ���Ҫ���ص����
        OutSignal(1:W)=yy;
    else
        OutSignal((i-1)*Ss+1:(i-1)*Ss+W)=yy+OutSignal((i-1)*Ss+1:(i-1)*Ss+W);
    end
end
OutSignal((size(Frame,2)-1)*Ss+1:(size(Frame,2)-1)*Ss+W)=Frame(size(Frame,2)).*hamming(size(Frame(size(Frame,2)),1))...
    +OutSignal((size(Frame,2)-1)*Ss+1:(size(Frame,2)-1)*Ss+W);
sound(OutSignal,fs);

audiowrite('m2f-xidian-1.wav',OutSignal,fs);

%figure,plot(20*log10(abs(fft(Original_Signal))),'r'),hold on;plot(20*log10(abs(fft(OutSignal))),'b');

toc
%figure,plot(Original_Signal,'r'),hold on;plot(OutSignal,'g'),title('ԭʼʱ���ź���ת��ʱ���ź�');
