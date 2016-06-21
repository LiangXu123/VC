%根据变速因子Speed改变语音信号长度的函数
%Change_Speed_Signal=Change_Speed(Original_Signal,Speed)
%入口参数：
%   Original_Signal：单帧语音信号，为列信号
%   Speed：变速因子，Speed大于1则输出语音长度变短，Speed小于1则将语音延长
%出口参数：
%   Change_Speed_Signal：变速后的单帧语音信号，为列信号
%2016年3月18日14:48:26
function Change_Speed_Signal=Change_Speed(Original_Signal,Speed)

Ori_Length=size(Original_Signal,1);
if Speed>=1
    for n=1:1:Ori_Length   %在单帧信号里面按照步骤2进行播放速度改变
        if(floor(Speed*n+0.5)>=1)&&(floor(Speed*n+0.5)<=Ori_Length)
            Change_Speed_Signal(n,1)=Original_Signal(floor(Speed*n+0.5),1);  %Xmp为改变播放速度后的语音帧信号
        end
        if(floor(Speed*n+0.5)>Ori_Length)
            break;
        end
    end
else %Speed<1时
    for n=1:1:Ori_Length*100   %在单帧信号里面按照步骤2进行播放速度改变
        if(floor(Speed*n+0.5)<=Ori_Length)
            if floor(Speed*n+0.5)==0
                Change_Speed_Signal(n,1)=Original_Signal(1,1);
            else
                Change_Speed_Signal(n,1)=Original_Signal(floor(Speed*n+0.5),1);  %Xmp为改变播放速度后的语音帧
            end
        else
            break;
        end
    end
end
end