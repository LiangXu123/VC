%����ȡ�����װ��簴�ձ�������F=1��s�ȱ���ѹ�����õ��µ��װ�����Ӻ���
%Eafter=Adjust_Envelope(Ebefore,F)
%��ڲ�����
%   Ebefore����ȡ�����װ��磬��Ҫ����ѹ�����ӽ���ѹ��
%   F:��������F=1��S��SΪ������������
%���ڲ�����
%   Eafter���ȱ����任����װ���
%2016��3��8��10:47:35
function Eafter=Adjust_Envelope(Ebefore,F)
Enew=zeros(size(Ebefore));
if F>1
    for i=1:1:size(Ebefore,2)   %��֡����
        for n=1:1:size(Ebefore,1)   %�ڵ�֡�ź�����
            if(F*n>=1)&&(F*n<=size(Ebefore,1))
                Enew(n,i)=interp1(1:size(Ebefore,1),Ebefore(:,i),F*n);         %���в�ֵ
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
    for i=1:1:size(Ebefore,2)   %��֡����
        for n=2:1:size(Ebefore,1)   %�ڵ�֡�ź�����
            Enew(n,i)=interp1(1:size(Ebefore,1),Ebefore(:,i),F*n);         %���в�ֵ
        end
        Enew(1,i)=Ebefore(1,i);
    end
    Eafter=Enew;
    
end
end

