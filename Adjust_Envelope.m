%对提取出的谱包络按照比例因子F=1／s等比例压扩，得到新的谱包络的子函数
%Eafter=Adjust_Envelope(Ebefore,F)
%入口参数：
%   Ebefore：提取出的谱包络，需要根据压缩因子进行压扩
%   F:比例因子F=1／S，S为语音变速因子
%出口参数：
%   Eafter：等比例变换后的谱包络
%2016年3月8日10:47:35
function Eafter=Adjust_Envelope(Ebefore,F)
Enew=zeros(size(Ebefore));
if F>1
    for i=1:1:size(Ebefore,2)   %逐帧处理
        for n=1:1:size(Ebefore,1)   %在单帧信号里面
            if(F*n>=1)&&(F*n<=size(Ebefore,1))
                Enew(n,i)=interp1(1:size(Ebefore,1),Ebefore(:,i),F*n);         %进行插值
            elseif(floor(F*n)>size(Ebefore,1))
                Last_N=n;
                break;
            end
        end
        Enew(Last_N+1:end,i)=Ebefore(Last_N+1:end,i);
    end
    Eafter=Enew;
elseif F==1
    Eafter=Ebefore;
elseif F<1
    for i=1:1:size(Ebefore,2)   %逐帧处理
        for n=2:1:size(Ebefore,1)   %在单帧信号里面
            Enew(n,i)=interp1(1:size(Ebefore,1),Ebefore(:,i),F*n);         %进行插值
        end
        Enew(1,i)=Ebefore(1,i);
    end
    Eafter=Enew;
    
end
end

