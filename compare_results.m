clear variables;

% Load 2 result files to compare
a = load('./results/results_5-sweeps_10-22-58_23-10-17.mat');
b = load('./results/results_5-sweeps_13-50-19_10-11-17.mat');

% Calculate mean spectrums for each test
y_a = cell2mat(a.results);
y_b = cell2mat(b.results);
x = a.half_f;
mean_curve_a = mean(y_a,2)';
mean_curve_b = mean(y_b,2)';

% Smooth spectrums
smooth_span = 25;
smoothed_mean_a = smooth(mean_curve_a,smooth_span);
smoothed_mean_b = smooth(mean_curve_b,smooth_span);

% Scale such that max amplitude of mean spectrum A = 0dB
scale_factor = 1/max(smoothed_mean_a);
smoothed_mean_a = scale_factor * smoothed_mean_a;
smoothed_mean_b = scale_factor * smoothed_mean_b;

% Plot 
fontSize = 16;
f = figure('color','w','DefaultAxesFontSize',fontSize);
plot(x, mag2db(smoothed_mean_a), 'k', 'LineWidth', 1);
hold on;
plot(x, mag2db(smoothed_mean_b), 'b', 'LineWidth', 0.2);
set(gca, 'XScale', 'log')
xlabel('Frequency (Hz)','Interpreter','latex');
ylabel('Magnitude (dB)','Interpreter','latex');
set(gca,'TickLabelInterpreter','latex');
legend({'Week 0','Week 3'},'Interpreter','latex');

