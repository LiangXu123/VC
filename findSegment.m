%�����л��κ���
%soundSegment=findSegment(express)
%��ڲ�����
%   express�����ر�ֵ��������ֵ��֡��֡���
%���ڲ�����
%   soundSegment���л��εĽṹ�壬�ýṹ���������������
%       begin���л��εĿ�ʼ�˵㣬ֵΪ��ڲ�����ĳ��ֵ
%       end���л��εĽ����˵㣬ֵΪ��ڲ�����ĳ��ֵ���������֡�����л��εĻ�begin��endֵ֮��Խ�󣬶��������л�֡��begin=end
%       duration��end-begin+1�Ĳ�����ʾ����л��γ����˼�֡,���������л�֡��duration=1
%2016��3��1��20:38:32
function soundSegment=findSegment(express)
if express(1)==0
    voicedIndex=find(express);                     % Ѱ��express��Ϊ1��λ��
else
    voicedIndex=express;
end

soundSegment = [];
k = 1;
soundSegment(k).begin = voicedIndex(1);            % ���õ�һ���л��ε���ʼλ��
for i=1:1:length(voicedIndex)-1
	if (voicedIndex(i+1)-voicedIndex(i)>1)         % �����л��ν���,��������ֵ֮�����1��˵���˶������л��ν�����
		soundSegment(k).end = voicedIndex(i);      % ���ñ����л��εĽ���λ��
		soundSegment(k+1).begin = voicedIndex(i+1);% ������һ���л��ε���ʼλ��  
		k = k+1;
	end
end
soundSegment(k).end = voicedIndex(end);            % ���һ���л��εĽ���λ��
%���ˣ��Ѿ�����ڲ�����֡�������ֵ����Ϊ���л��εĽṹ��

% ����ÿ���л��εĳ���
for i=1 :k
    soundSegment(i).duration=soundSegment(i).end-soundSegment(i).begin+1;
end
