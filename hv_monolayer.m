function [] = hv_monolayer()
% Interactionless model of gas deposition and off-gassing in high vacuum
% spherical chamber.


%% User Parameters
% Modify these to fit what you need
% Pressure
P = 2e-4; % Pa

% Particle mass number
M = 18; % in multiples of AMU

% Diameter of chamber, in m
D = 0.3; % m

% Temperature of chamber, in Kelvin
T = 300; %K

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Don't edit below here %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Physical Constants
% Don't modify these
% Boltzmann's constant
kb = 1.38e-23;
% Avogadro's Number
NA = 6.02e23;

%% Calculate Additional Parameters
% Volume
Vol = (4/3)*pi*(D/2)^3;
% Number of particles
N = P*Vol/kb/T;
% Real mass
m = M*1.66e-27;
% Velocity
Vel = sqrt(8*kb*T/pi/m);

t_all =  N * Vel * m / P / (4*pi*(D/2)^2)

%% Algorithm
%particles = struct('on_surf',zeros(N,1),'location',zeros(N,3),'velocity',zeros(N,N,N));
%particles = randomStartLocation(particles, D, N);

%plot3(particles.location(:,1),particles.location(:,2),particles.location(:,3),'r.');

end

%% Subfunction: Random start location
function [particles] = randomStartLocation(particles, D, N)
% Fills the struct with random starting locations for all the particles.
% theta polar angle, phi azimuthal angle, r radius
rng('shuffle');

theta = pi * rand(N,1);
phi = 2 * pi * rand(N,1);
r = 0.5 * D * rand(N,1);

x = r .* sin(theta) .* cos(phi);
y = r .* sin(theta) .* sin(phi);
z = r .* cos(theta);

particles.location(:,1) = x;
particles.location(:,2) = y;
particles.location(:,3) = z;
    
end