%���ݱ�������Speed�ı������źų��ȵĺ���
%Change_Speed_Signal=Change_Speed(Original_Signal,Speed)
%��ڲ�����
%   Original_Signal����֡�����źţ�Ϊ���ź�
%   Speed���������ӣ�Speed����1������������ȱ�̣�SpeedС��1�������ӳ�
%���ڲ�����
%   Change_Speed_Signal�����ٺ�ĵ�֡�����źţ�Ϊ���ź�
%2016��3��18��14:48:26
function Change_Speed_Signal=Change_Speed(Original_Signal,Speed)

Ori_Length=size(Original_Signal,1);
if Speed>=1
    for n=1:1:Ori_Length   %�ڵ�֡�ź����水�ղ���2���в����ٶȸı�
        if(floor(Speed*n+0.5)>=1)&&(floor(Speed*n+0.5)<=Ori_Length)
            Change_Speed_Signal(n,1)=Original_Signal(floor(Speed*n+0.5),1);  %XmpΪ�ı䲥���ٶȺ������֡�ź�
        end
        if(floor(Speed*n+0.5)>Ori_Length)
            break;
        end
    end
else %Speed<1ʱ
    for n=1:1:Ori_Length*100   %�ڵ�֡�ź����水�ղ���2���в����ٶȸı�
        if(floor(Speed*n+0.5)<=Ori_Length)
            if floor(Speed*n+0.5)==0
                Change_Speed_Signal(n,1)=Original_Signal(1,1);
            else
                Change_Speed_Signal(n,1)=Original_Signal(floor(Speed*n+0.5),1);  %XmpΪ�ı䲥���ٶȺ������֡
            end
        else
            break;
        end
    end
end
end