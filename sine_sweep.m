clear variables;

% Number of repeats of the test signal
num_reps = 5;

recObj = audiorecorder(44100,16,1,1);
results = {};

for i = 1:num_reps
    % Read the test signal file
    [y,Fs] = audioread('test_signals/20-20000-hz-log-sweep-5s_start_delay_500ms.wav');
    sound(y,Fs);

    % Record the received signal from the microphone
    recordblocking(recObj, 5.5);

    % Calculate spectrum of recorded signal
    y = getaudiodata(recObj);
    fft_orig = fftshift(fft(y));    
    N = length(y);
    dF = Fs/N;                      
    f = -Fs/2:dF:Fs/2-dF;           
    abs_fft = abs(fft_orig)/N;
    
    [~,zero_idx] = min(abs(f-20));
    keep_half_idxs = zero_idx+1:length(abs_fft);
    half_abs_fft = abs_fft(keep_half_idxs);
    half_f = f(keep_half_idxs);
    
    results{i} = half_abs_fft;
    
    % Plot individual test results
    plot(half_f,half_abs_fft);
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');

    hold on;
end

% Save individual test measured spectrums
mkdir('results');
save_fname = sprintf('results/results_%s-sweeps_%s.mat',int2str(num_reps),datestr(datetime('now'),'HH-MM-SS_dd-mm-yy'));
save(save_fname,'results','half_f');

% Calculate mean and standard deviation of recorded spectrums
y = cell2mat(results);
x = half_f;
mean_curve = mean(y,2)';
top_std = mean(y,2)' + std(y,[],2)';
bottom_std = mean(y,2)' - std(y,[],2)';
% Bit hacky way of making sure we don't get log of negative values
bottom_std(bottom_std<=0) = NaN;
bottom_std = repnan(bottom_std,'linear');

% Smooth spectrum 
smooth_span = 25;
smoothed_mean = smooth(mean_curve,smooth_span);
smoothed_top_std = smooth(top_std,smooth_span);
smoothed_bottom_std = smooth(bottom_std,smooth_span);

% Scale such that the maximum amplitude of mean spectrum is 0dB
scale_factor = 1/max(smoothed_mean);
smoothed_mean = scale_factor * smoothed_mean;
smoothed_top_std = scale_factor * smoothed_top_std;
smoothed_bottom_std = scale_factor * smoothed_bottom_std;

% Plot mean + std above and below spectrums of recorded signals
figure;
plot(x, mag2db(smoothed_mean), 'k', 'LineWidth', 1);
hold on;
plot(x, mag2db(smoothed_top_std), 'b', 'LineWidth', 0.2);
hold on;
plot(x, mag2db(smoothed_bottom_std), 'b', 'LineWidth', 0.2);
set(gca, 'XScale', 'log')
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
