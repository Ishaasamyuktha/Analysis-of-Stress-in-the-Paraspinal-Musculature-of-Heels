clear all;
close all;
clc;
X = csvread('/Users/ishaasamyuktha/Desktop/Heels Project/srija/heel stand 1.csv');
X1 = X(:,1);
X1=detrend(X1);
X2 = X(:,2);
X2=detrend(X2);
%X3 = X(:,3);
fs=1000;
freq = 0:(fs/length(X)):fs/2;
t = 0:length(X)-1;
t = 0.01*t;
figure(1);
subplot(331);
plot(t,X);
xlim manual;
xlim([0 10]);
ylim manual;
ylim([-0.05 0.05]);
title('raw emg');

%fft
f=fft(X);
figure(1);
subplot(332);
plot(abs(f));
xlim manual;
xlim([0 600]);
% ylim manual;
% ylim([0 20]);
title('fft 1');

%psd
freq=0:(fs/length(X)):fs/2;
subplot(333);
plot(freq,abs(f(1:length(freq)))/385);
xlim manual;
xlim([0 600]);
ylim manual;
ylim([0 0.05]);
title('psd of raw signal');

%plotting channels
subplot(334);
plot(t,X1);
xlim manual;
xlim([0 100]);
ylim manual;
ylim([-0.1 0.1])
title('ch-1');
subplot(335);
plot(t,X2);
xlim manual;
xlim([0 100]);
ylim manual;
ylim([-0.1 0.1])
title('ch-2');
fs=1000;

% %%denoise
% xd = wdenoise(X1,3,'Wavelet','db3',...
%     'DenoisingMethod','UniversalThreshold',...
%     'ThresholdRule','Soft',...
%     'NoiseEstimate','LevelDependent');
% figure(1);
% subplot(336);
% plot(xd);
% xlim manual;
% xlim([0 100]);
% % ylim manual;;
% % ylim([-0.1 0.1]);
% title('Denoised Signal ch1')
%
% xd1 = wdenoise(X2,3,'Wavelet','db3',...
%     'DenoisingMethod','UniversalThreshold',...
%     'ThresholdRule','Soft',...
%     'NoiseEstimate','LevelDependent');
% figure(1);
% subplot(337);
% plot(xd1);
% xlim manual;
% xlim([0 100]);
% % ylim manual;
% % ylim([-0.1 0.1]);
% title('Denoised Signal ch2');

%% bpf for emg
w1=10/1000; w2=150/1000;
wn=[w1 w2];
[b,a]=butter(4,wn);
emg5=filtfilt(b,a,X1);
figure(1);
subplot(338);
plot(emg5);
xlim manual;
xlim([0 5000]);
ylim manual;
ylim([-0.05 0.05]);
title('band pass filter-ch1');
xlabel('time');
ylabel('amplitude');

w1=4*2/1000; w2=498*2/1000;
wn=[w1 w2];
[b,a]=butter(4,wn);
emg6=filtfilt(b,a,X2);
figure(1);
subplot(339);
plot(emg6);
xlim manual;
xlim([0 3000]);
ylim manual;
ylim([-0.05 0.05]);
title('band pass filter-ch2');
xlabel('time');
ylabel('amplitude');


%% notch
w1=48/1000;w2=52/1000;
wn=[w1 w2];
[c,d]=butter(4,wn,'stop');
emg7=filtfilt(c,d,emg5);
figure(2);
subplot(331);
plot(emg7);
%xlim manual;
%xlim([0 400]);
title('notch filter- ch1');
xlabel('time');
ylabel('amplitude');

f1=fft(emg7);
figure(2);
subplot(335);
plot(abs(f1));
xlim manual;
xlim([0 60]);
% ylim manual;
% ylim([0 20]);
title('fft ch1 after notch');


w1=48/1000;w2=52/1000;
wn=[w1 w2];
[c,d]=butter(4,wn,'stop');
emg8=filtfilt(c,d,emg6);
figure(2);
subplot(332);
plot(emg8);
%xlim manual;
%xlim([0 400]);
title('notch filter- ch2');
xlabel('time');
ylabel('amplitude');
f=fft(emg8);
figure(2);
subplot(333);
plot(abs(f));
xlim manual;
xlim([0 60]);
ylim manual;
ylim([0 20]);
title('fft ch2 after notch');
%psd
freq=0:(fs/length(emg8)):fs/2;
figure(2);
subplot(334);
plot(freq,abs(f(1:length(freq)))/385);

xlim manual;
xlim([0 60]);
ylim manual;
ylim([0 0.05]);
title('psd of raw signal');
title('fft 1');

%% %moving average filter ch1
B = 1/10*ones(10,1);
Y1 = filter(B,1,emg7);
figure(8);
subplot(331);
plot(t,Y1);
xlabel('time in seconds');
ylabel('amplitude in mv');title('moving average filtererd signal ch1');
subplot(332);
periodogram(Y1);


%ma fft
c2=fft(Y1);
figure(8);
subplot(333);
plot(freq,abs(c2(1:length(freq))));
xlim([0 200]);
xlabel('frequency in hz');
ylabel('amplitude in mv');
title('moving average filter- fft ch1');

% ma ch2
B = 1/10*ones(10,1);
Y2 = filter(B,1,emg8);
figure(8);
subplot(334);
plot(t,Y2);
xlim([0 200]);
xlabel('time in seconds');
ylabel('amplitude in mv');title('moving average filtererd signal ch2');
subplot(335);
periodogram(Y2);



%ma fft
c2=fft(Y2);
figure(8);
subplot(336);
plot(freq,abs(c2(1:length(freq))));
xlim([0 200]);
xlabel('frequency in hz');
ylabel('amplitude in mv');
title('moving average filter- fft ch2');


%% segments
 t1=1;
 t2=100;
 i=1;
 freq=zeros(1,13);
 while t2<=12200
     new_seg=emg7(t1:min(t2,length(emg7)));
     freq(i)=rms(new_seg);
     t1=t1+100;
     t2=t2+100;
     i=i+1;
 end
 t1=0:length(freq)-1;
 figure(7);
 subplot(221);
 plot(t1,freq);
 
 
 % channel 2
 t1=1;
 t2=100;
 i=1;
 freq=zeros(1,13);
 while t2<=12200
     new_seg=emg8(t1:min(t2,length(emg8)));
     freq(i)=rms(new_seg);
     t1=t1+100;
     t2=t2+100;
     i=i+1;
 end
 t1=0:length(freq)-1;
 figure(7);
 subplot(222);
 plot(t1,freq);

 %% mean and rms value
r=rms(Y1);
s=rms(Y2);
disp('rms of ch1');
disp(r);
disp('rms of ch2');
disp(s);


x=mean(abs(Y1));
y=mean(abs(Y2));
disp('mean of ch1');
disp(x);
disp('mean of ch2');
disp(y);


