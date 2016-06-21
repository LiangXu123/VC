%��ȡ���ϳ��ź���һ֡���ź���ʼ��
%Next_RSa=GetRSa(Si,Sri,Ai,Ari,F)
%��ڲ�����
%   Si��Si=floor(Ss/pi);    %ȡ����
%   Sri��Sri=mod(Ss,pi);     %ȡ����
%   Ai��Ai=floor(Sa/pi);
%   Ari��Ari=mod(Sa,pi);
%   Pi:��ǰ֡�źŵĻ�������
%   F:�ź�ѹ����F=Sa/Ss
%   RSa:��ǰ֡��ʼ��
%���ڲ�����
%   Next_RSa��ʱ����������ϳɵ���һ֡�źŵ���ʼ��
%2016��3��2��20:43:55

function Next_RSa=GetRSa(Si,Sri,Ai,Ari,Pi,F,RSa)
ASri=(Ari-Sri)/Pi;
rsi=Sri/Pi;

switch ASri
    case -0.5
        if F>1
            Next_RSa=RSa+Pi*(Ai-1+rsi);
   
        else
            Next_RSa=RSa+Pi*abs(ASri)+Ai;
   
        end
    case 0.5
        if F>1
            Next_RSa=Ai-Pi*abs(ASri)+RSa;
          
        else
            Next_RSa=RSa+Pi*(Ai+1+rsi);
        
        end
    otherwise,   %-0.5<ASri<0.5ʱ
        if ASri<-0.5
            Next_RSa=RSa+Pi*(Ai-1+rsi);
       
        elseif ASri>0.5
            Next_RSa=RSa+Pi*(Ai+1+rsi);
     
        else
            Next_RSa=RSa+Pi*(Ai+rsi);
     
        end
end
end