%% MATLAB: Compare waveform features of two audio files (user selects)
clc; clear; close all;

%% Select the first audio file
[file1, path1] = uigetfile('*.wav', 'Select the first audio file');
if isequal(file1,0)
    disp('No file selected. Exiting.'); return;
end
file1_full = fullfile(path1, file1);

%% Select the second audio file
[file2, path2] = uigetfile('*.wav', 'Select the second audio file');
if isequal(file2,0)
    disp('No file selected. Exiting.'); return;
end
file2_full = fullfile(path2, file2);

%% Read audio
[y1, fs1] = audioread(file1_full);
[y2, fs2] = audioread(file2_full);

% If stereo, use left channel only
if size(y1,2) > 1, y1 = y1(:,1); end
if size(y2,2) > 1, y2 = y2(:,1); end

% Resample if sampling rates are different
if fs1 ~= fs2
    y2 = resample(y2, fs1, fs2);
    fs2 = fs1;
end

t1 = (0:length(y1)-1)/fs1;
t2 = (0:length(y2)-1)/fs2;

%% Plot waveforms
figure('Name','Waveform Comparison','Color','w');
subplot(2,1,1);
plot(t1, y1,'r'); grid on;
title([file1 ' Waveform']);
xlabel('Time (s)'); ylabel('Amplitude');

subplot(2,1,2);
plot(t2, y2,'b'); grid on;
title([file2 ' Waveform']);
xlabel('Time (s)'); ylabel('Amplitude');

%% Compute basic features
rms1 = rms(y1);      rms2 = rms(y2);
energy1 = sum(y1.^2); energy2 = sum(y2.^2);
peak1 = max(abs(y1)); peak2 = max(abs(y2));

fprintf('==== Waveform Feature Comparison ====\n');
fprintf('RMS: %s=%.4f, %s=%.4f\n', file1, rms1, file2, rms2);
fprintf('Peak: %s=%.4f, %s=%.4f\n', file1, peak1, file2, peak2);
fprintf('Energy: %s=%.4f, %s=%.4f\n', file1, energy1, file2, energy2);

%% Overlay waveform comparison
figure('Name','Overlay Waveform','Color','w');
plot(t1, y1,'r'); hold on;
plot(t2, y2,'b');
grid on;
xlabel('Time (s)'); ylabel('Amplitude');
title('Overlay Waveform Comparison');
legend(file1, file2);
