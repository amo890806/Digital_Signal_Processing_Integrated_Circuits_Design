Fs = 8000; %Sampling rate = 8kHz
N = 40000;   %Sample size

fid_in = fopen("input_24bits.txt");
A = fscanf(fid_in, "%f", N);
data_in = A';

coeff = [0.0159927387500675,0.0233035047394512,0.00455365658760152,-0.0234430155604574,-0.0188705906470356,0.0259271439404412,0.0435339122438407,-0.0156456401744842,-0.0854358037876625,-0.0256470761733608,0.189652255614199,0.395083481417485,0.395083481417485,0.189652255614199,-0.0256470761733608,-0.0854358037876625,-0.0156456401744842,0.0435339122438407,0.0259271439404412,-0.0188705906470356,-0.0234430155604574,0.00455365658760152,0.0233035047394512,0.0159927387500675]

data_out = conv(data_in, coeff);

figure
subplot(2, 1, 1);
[DATA_IN, din_freq_range] = positive_fft(data_in, Fs);
stem(din_freq_range, abs(DATA_IN));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
axis([0 4000 0 0.025]);

subplot(2, 1, 2);
[DATA_OUT, dout_freq_range] = positive_fft(data_out, Fs);
stem(dout_freq_range, abs(DATA_OUT));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
axis([0 4000 0 0.025]);

figure
subplot(2, 1, 1);
plot(data_in);
xlabel('Before Filtration');
axis([1 40000 -1.5 1.5]);

subplot(2, 1, 2);
plot(data_out);
xlabel('After Filtration');
axis([1 40023 -1.5 1.5]);

%output file
% fid_coeff = fopen('coeff.txt', 'wt');
% fid_out = fopen('output_24bits.txt', 'wt');
% for i=1:24
%     fprintf(fid_coeff, '%f\n', coeff(i));
% end
% 
% for i=1:40023
%     fprintf(fid_out, '%f\n', data_out(i));
% end