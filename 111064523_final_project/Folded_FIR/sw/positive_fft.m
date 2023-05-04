function [X, freq] = positive_fft(x, Fs)
    N = length(x);
    k = 0:N-1;
    T = N/Fs;
    freq = k/T;
    X = fft(x)/N;
    
    cutOff = ceil(N/2);
    
    X = X(1:cutOff);
    freq = freq(1:cutOff);
end