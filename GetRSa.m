%获取待合成信号下一帧的信号起始点
%Next_RSa=GetRSa(Si,Sri,Ai,Ari,F)
%入口参数：
%   Si：Si=floor(Ss/pi);    %取整数
%   Sri：Sri=mod(Ss,pi);     %取余数
%   Ai：Ai=floor(Sa/pi);
%   Ari：Ari=mod(Sa,pi);
%   Pi:当前帧信号的基音周期
%   F:信号压缩比F=Sa/Ss
%   RSa:当前帧起始点
%出口参数：
%   Next_RSa：时长规整后待合成的下一帧信号的起始点
%2016年3月2日20:43:55

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
    otherwise,   %-0.5<ASri<0.5时
        if ASri<-0.5
            Next_RSa=RSa+Pi*(Ai-1+rsi);
       
        elseif ASri>0.5
            Next_RSa=RSa+Pi*(Ai+1+rsi);
     
        else
            Next_RSa=RSa+Pi*(Ai+rsi);
     
        end
end
end