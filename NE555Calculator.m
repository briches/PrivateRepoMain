% 555 Timer Calculator
% Enter a desired frequency and acceptable duty cycle, and the algorithm
% will attempt to calculate the resistors. 
clear all;
C = 47.4e-9; % 1 nF
f = 0.5e6; % 500 KHz target, hopefully possible
dc = 0.5; % Duty cycle of 0.5;

% Period
T = 1/f;
TH = T * dc;
TL = T * (1-dc);

% Resistors
RB = 100; %TL / 0.69 / C

RA = TH / 0.78 / C;


%% Plot results
RA = linspace(RA - 0.75*RA, RA+3*RA,100);

% Calculate the new high time
TH = RA*0.78*C;

% Low time depends only on R and C
TL = RB * 0.68 * C;

% Total period
T = TH + TL;

% New duty cycle and frequency
dc = TH./T;
f = 1./T;
f = f/(1000); % Convert to kHz

% Plot the frequency and duty cycle for different Ra
figure(1); 
plot(RA/1000,f,'LineWidth', 4);
grid on;
set(gca, 'XMinorGrid','on', 'YMinorGrid','on');
title('Frequency varying with R_A');
xlabel('R_A value, in k\Omega');
ylabel('Frequency, in kHz');

figure(2);
plot(RA/1000,dc*100,'LineWidth', 4);
grid on;
set(gca, 'XMinorGrid','on', 'YMinorGrid','on');
ylim([0,100]);
title('Duty cycle varying with R_A');
xlabel('R_A value, in k\Omega');
ylabel('Duty cycle in %');

