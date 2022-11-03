clear all;
close all;

[audio_in,audio_freq_samp1] = audioread('sound.wav');
 
%ALLIGNING THE VALUES TO LENGTH OF AUDIO, AND DF IS THE MINIMUM FREQUENCY RANGE
length_audio = length(audio_in);
df = audio_freq_samp1/length_audio;
 
%CALCULATING FREQUENCY VALUES TO BE ASSIGNED ON THE X-AXIS OF THE GRAPH
frequency_audio = -audio_freq_samp1/2:df:audio_freq_samp1/2-df;


Ts = 1/audio_freq_samp1;
t= (0:length_audio-1)*Ts;

Y = fft(audio_in,1024);
Ym = abs(Y);
f = audio_freq_samp1*(0:511)/1024;

%BY APPLYING FOURIER TRANSFORM TO THE AUDIO FILE
FFT_audio_in = fftshift(fft(audio_in)/length(fft(audio_in)));
 
% PLOTTING
figure(1);
plot(frequency_audio,abs(FFT_audio_in));
title('FFT of input Audio');
xlabel('frequency(HZ)');
ylabel('Amplitude');

figure(2);
plot(t,audio_in);
title('Audio in Time Domain');
xlabel('Time');
ylabel('Amplitude');

figure(3);
plot(f,Ym(1:512));
title('Audio in frequency domain (Hz)');
ylabel('Amplitude(volt)');
xlabel('Frequency(Hz)');

%NOW LETS SEPARATE THE VARIOUS COMPONENTS BY CUTTING IT IN FREQUENCY RANGE
lower_threshold = 150;
upper_threshold = 2500;
 
% WHEN THE VALUES IN THE ARRAY ARE IN THE FREQUENCY RANGE THEN WE HAVE 1 AT
% THAT INDEX AND O FOR OTHERS I.E; CREATING AN BOOLEAN INDEX ARRAY
 
val = abs(frequency_audio)<upper_threshold & abs(frequency_audio)>lower_threshold;
FFT_ins = FFT_audio_in(:,1);
FFT_voc = FFT_audio_in(:,1);
%BY THE LOGICAL ARRAY THE FOURIER IN FREQUENCY RANGE IS KEPT IN VOCALS;AND
%REST IN INSTRUMENTAL AND REST OF THE VALUES TO ZERO
FFT_ins(val) = 0;
FFT_voc(~val) = 0;
 
%NOW WE PERFORM THE INVERSE FOURIER TRANSFORM TO GET BACK THE SIGNAL
FFT_a = ifftshift(FFT_audio_in);
FFT_a11 = ifftshift(FFT_ins);
FFT_a31 = ifftshift(FFT_voc);

%CREATING THE TIME DOMAIN SIGNAL
s1 = ifft(FFT_a11*length(fft(audio_in)));  
s3 = ifft(FFT_a31*length(fft(audio_in)));
 
%WRITING THE FILE
audiowrite('sound_background.wav',s1,audio_freq_samp1);
audiowrite('sound_voice.wav',s3,audio_freq_samp1);

%PLOTTING BG AND VOICE
figure(4);
plot(t,s3);
title('Voice in Time Domain');
xlabel('Time');
ylabel('Amplitude');

Yv = fft(s3,1024);
Yvm = abs(Yv);
figure(5);
plot(f,Yvm(1:512));
title('Voice in frequency domain (Hz)');
ylabel('Amplitude(volt)');
xlabel('Frequency(Hz)');

figure(6);
plot(t,s1);
title('BGM in Time Domain');
xlabel('Time');
ylabel('Amplitude');

Yb = fft(s1,1024);
Ybm = abs(Yb);
figure(7);
plot(f,Ybm(1:512));
title('BGM in frequency domain (Hz)');
ylabel('Amplitude(volt)');
xlabel('Frequency(Hz)');

