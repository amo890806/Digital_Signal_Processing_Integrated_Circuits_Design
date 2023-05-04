close all;
clear;
clc;

fid = fopen("snr.txt");
formatSpec = '%d %f';
point = 31;
sizeA = [2 point];
A = fscanf(fid, formatSpec, sizeA);
A = A';
for i=1:point
    V = A(i,:);
    x(i) = V(:,1);
    y(i) = V(:,2);
end

figure
plot(x, y, '-bo','LineWidth', 1)
ylabel('SNR (dB)');
xlabel('word length (bits)');
title('SNR versus Word Length');