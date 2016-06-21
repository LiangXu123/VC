filename='m2f-xidian-infilter.wav';
[infilter,fs]=audioread(filename);  %录音文件

filename='m2f-xidian-nofilter.wav';
[nofilter,fs]=audioread(filename);  %录音文件

figure,subplot(211),plot(infilter,'b')
subplot(212),plot(nofilter,'k');