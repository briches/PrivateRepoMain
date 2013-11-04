xoutside = 0.001:0.0001:0.006; % from 1 to 6 mm
xinside = 0:0.0001:0.001; % from 0 to 1 mm

rBeam = 0.001; %meters
epsilon0 = 8.8543E-12; %constant

Eoutside = (rho * rBeam^2)./ (2 .* xoutside * epsilon0);
Einside = xinside.*(rho /(2 * epsilon0));

Voutside = ((rho * rBeam^2) / (2 * epsilon0)) * log(0.006./xoutside);
Vinside = (rho/(2*epsilon0))*(rBeam^2 * log(0.006/rBeam) - (xinside.^2)./2 + (rBeam^2)/2);

subplot(2,1,1);
plot(xoutside, Eoutside);
hold;
subplot(2,1,1);
title('Electric Field');
plot(xinside, Einside);

subplot(2,1,2);
plot(xoutside,Voutside);
title('Voltage');
hold;
subplot(2,1,2);
plot(xinside, Vinside);




