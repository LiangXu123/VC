filename='m2f-xidian-infilter.wav';
[infilter,fs]=audioread(filename);  %¼���ļ�

filename='m2f-xidian-nofilter.wav';
[nofilter,fs]=audioread(filename);  %¼���ļ�

figure,subplot(211),plot(infilter,'b')
subplot(212),plot(nofilter,'k');