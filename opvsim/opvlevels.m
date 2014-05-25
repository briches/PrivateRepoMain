function [] = opvlevels()
    clf;
    %% User inputs
    % Energies in the region, widths of regions in nm
    energy = [-4.7, 100; ...
              -5.2, 20; ...
              -4.3, 50; ...
              -3.31, 50; ...
              -3, 20; ...
              -2.7, 100];
          
    % Quality
    N = 1000; % Positive interger, number of spatial divisions
    
    % Total time to run for, in femtoseconds
    simulationTime = 1e6;
    
    % Timestep, in femtoseconds
    dt = 1;
    
    %% Physical constants
    nm = 1e-9; % meters
    hbar = 4.1356e-15; % eV*s
    me = 9.11e-31; % kg
    q = 1.602e-19; % elementary charge
    
     %% Read data for AM1.5G spectrum
    wavelength = open('wavelength.mat');
    irradiance = open('irradiance.mat');
    wavelength = wavelength.wavelength;
    irradiance = irradiance.irradiance;
    spectrum = [wavelength, irradiance];
    PD = fitdist(irradiance, 'normal');
   
    %% Potential and initial wavefunction
    % Potential energy generated from user inputs
    [U, structureSize] = generatePotential(energy, N);
    U = U.';
    % x, k axis
    dt = dt * 1e-15;
    simulationTime = simulationTime * 1e-15;
    dk = 2*pi/structureSize; % Momentum step
    km = N * dk; % Max momentum
    ka = 20; % Momentum Spread
    x = linspace(0, structureSize, N)';
    k = linspace(0, +km, N)';
    
    % Spatial discretness
    dx = x(2)-x(1);
    
    % Initial wavefunctions
    electrons = struct('ID', [], 'Alive', [], 'psi', [], 'evolve', []);
    
    % New electrons
    newEnergy = getRandomEnergyPhoton(PD, spectrum);
    electrons = generateElectron(electrons, 50, 3, structureSize, N, U, dt, hbar);
    electrons = generateElectron(electrons, 75, 2.3, structureSize, N, U, dt, hbar);
    
%     %% TDSE
%     
%     %Fin-dif Laplacian and Hamiltonian
%     e = ones(N,1); 
%     Lap = spdiags([e -2*e e],[-1 0 1],N,N)/dx^2;
%     H = -(1/2)*Lap + spdiags(U,0,N,N);
%     
%     % Time displacement operator E = exp(-iHdT/hbar)
%     E = expm(-1i*full(H)*dt/hbar);
%     
%     iterations = simulationTime/dt;
%     for i = 1:iterations
%         % TDSE
%         psi = E*psi;
%         % Plot results
%         multiPlot(1, x, psi.*conj(psi), x, U/q, ymax);
%         psi = smooth(psi,2);
%     end
end

%% Generate Electron
% Creates a new electron at a given location and energy
function electrons = generateElectron(electrons, location, energy, structureSize, N, U, dt, hbar)
    dk = 2*pi/structureSize; % Momentum step
    km = N * dk; % Max momentum
    ka = 20; % Momentum Spread
    x = linspace(0, structureSize, N)';
    dx = x(2) - x(1);
    k = linspace(0, +km, N)';
    k0 = sqrt(2 * energy);
    const = location/2/k0;

    % Get the new ID
    numElectrons = length(electrons.ID);
    newID = numElectrons + 1;
    
    % Append the new ID
    electrons.ID = [electrons.ID, newID];
    electrons.Alive(electrons.ID(newID)) = 1;
    
    % Create a wavefunction with the desired energy
    phi = exp(-ka*(k-k0).^2).*exp(-1i*const*k.^2); 
    psi = ifft(phi);
    psi = psi/sqrt(psi'*psi*dx);
    
    % Change direction randomly
    if randi([0,1]) == 1
        psi = conj(psi);
    end
    
    % Create the time evolution operator
    % Fin-dif Laplacian and Hamiltonian
    e = ones(N,1); 
    Lap = spdiags([e -2*e e],[-1 0 1],N,N)/dx^2;
    H = -(1/2)*Lap + spdiags(U,0,N,N);
    
    % Time displacement operator E = exp(-iHdT/hbar)
    E = expm(-1i*full(H)*dt/hbar);
    electrons.psi = [electrons.psi, psi]
    %psi = conj(psi);
    %avgE = norm(phi'*0.5*diag(k.^2,0)*phi*dk/(phi'*phi*dk))
end

%% Get new photon
% Uses AM1.5G spectrum as a probability density to pull a new photon energy
function [energy] = getRandomEnergyPhoton(spectrum)
    
end

%% Generate Potential
% Generates the potential energy function representing the given data
function [U,structureSize] = generatePotential(energy, quality)
    % Set up the matrix
    U = zeros(1, quality);
    
    % Get the size in nm of the structure;
    num = size(energy);
    num = num(1); % number of films
    structureSize = 0;
    for i = 1:num
        structureSize = structureSize + energy(i,2);
    end
    
    % Divide up the potential into the regions
    currentDivider = 1;
    for i = 1:num
        nextDivider = floor(quality*(energy(i,2) / structureSize))+currentDivider;
        if i == num
            nextDivider = quality;
        end
        U(1,currentDivider:nextDivider) = energy(i,1);
        currentDivider = nextDivider;
    end
end

%% Utility plot function
% Plots functions with independant y-axes but shared x-axes in the same
% MATLAB figure. 
function [] = multiPlot(figureNum,x1, y1, x2, y2, ymax)
    figure(figureNum);
    cla reset
    line(x1, y1, 'Color', 'r');
    haxes1 = gca;
    set(haxes1, 'xtick', [], ...
        'xticklabel', [], ...
        'ytick', [], ...
        'yticklabel', [], ...
        'YColor', 'r');
    ylim([0, ymax]);
    
    
    haxes1_pos = get(haxes1,'Position'); % store position of first axes
    haxes2 = axes('Position',haxes1_pos,...
              'XAxisLocation','top',...
              'YAxisLocation','right',...
              'Color','none');
          
    line(x2,y2,'Parent',haxes2,'Color','k')
end

%% Normalize
% Normalizes a given discretized function
function psi = normalize(psi, dx)
    summa = dx * sum(psi.*conj(psi)); 
    weight = sqrt(1/summa);
    psi = psi * weight;
end
