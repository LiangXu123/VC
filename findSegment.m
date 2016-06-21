%查找有话段函数
%soundSegment=findSegment(express)
%入口参数：
%   express：能熵比值大于门限值的帧的帧序号
%出口参数：
%   soundSegment：有话段的结构体，该结构体包含三个参数：
%       begin：有话段的开始端点，值为入口参数的某个值
%       end：有话段的结束端点，值为入口参数的某个值，连续多个帧都是有话段的话begin和end值之差越大，独立单个有话帧则begin=end
%       duration：end-begin+1的差，结果表示这个有话段持续了几帧,独立单个有话帧则duration=1
%2016年3月1日20:38:32
function soundSegment=findSegment(express)
if express(1)==0
    voicedIndex=find(express);                     % 寻找express中为1的位置
else
    voicedIndex=express;
end

soundSegment = [];
k = 1;
soundSegment(k).begin = voicedIndex(1);            % 设置第一组有话段的起始位置
for i=1:1:length(voicedIndex)-1
	if (voicedIndex(i+1)-voicedIndex(i)>1)         % 本组有话段结束,相邻索引值之差大于1，说明此段连续有话段结束。
		soundSegment(k).end = voicedIndex(i);      % 设置本组有话段的结束位置
		soundSegment(k+1).begin = voicedIndex(i+1);% 设置下一组有话段的起始位置  
		k = k+1;
	end
end
soundSegment(k).end = voicedIndex(end);            % 最后一组有话段的结束位置
%到此，已经将入口参数的帧序号索引值翻译为了有话段的结构体

% 计算每组有话段的长度
for i=1 :k
    soundSegment(i).duration=soundSegment(i).end-soundSegment(i).begin+1;
end
