function [] = quantumSolve(vspace,N,State)
% Solves for the allowed energies (first version just eigenvalues) and
% corresponding wavefunctions for a given (arbitrary) potential. Certain
% selectable examples exist.
% Inputs: (none need to be specified)
%
%   vspace
%       an array containing the potential you wish to test. The
%       number of points in vspace is the 'discreteness' of the space; you want
%       to have more points to be more accurate.
%
%   N 
%       the number of basis functions to include in the solution. Higher
%       numbers correspond to higher available spatial resolution, and accurate
%       high energy values
%
%   State 
%       The specific state you want to view. Can be any interger from
%       1 to N
clc; clf;

if nargin == 0
    clear; 
    res = 1000;
    [basis,vspace] = getProblem(res);
    N = input('Accuracy (interger > 0) : '); N = max(1,floor(N));
    State = uint16(input('Energy level to be displayed : ')); State = min(N,floor(State));
else
    res = length(vspace);
    basis = 'sinusoid';
end
if nargin == 1
    N = input('Accuracy (interger > 0) : '); N = max(1,floor(N));
    State = uint16(input('Energy level to be displayed : ')); State = min(N,floor(State));
end
if nargin == 2
    State = uint16(input('Energy level to be displayed : ')); State = min(N,floor(State));
end

% Solve the problem and deal with MATLAB's mysterious ways.
[eigenVectors, eigenValues,~] = solver(N,vspace,basis);
[eigenVectors,eigenValues] = sortVectors(eigenVectors,eigenValues);

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Plot results %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Eigenvalues
figure(1)
plot(1:N,eigenValues,'ksquare');

% Plot Psi squared
Psi = zeros(1,res);
xspace = linspace(0,1,res);

for n = 1:N
   Psi = Psi + sqrt(2)*eigenVectors(n,State).*sin(n*pi.*xspace);
end

figure(2);
hold on; grid on;
PsiSq = Psi.*conj(Psi);
vspace = vspace.*max(abs(PsiSq))/max(abs(vspace));
plot(xspace,vspace,'r-');
plot(xspace,PsiSq,'k-');


end

function [eigenVectors, eigenValues, H] = solver(N,vspace,basis)
% Integrates the basis functions to find the general Hamiltonian for the
% basis function expansion method. As of the first version, it does not
% implement any algorithmic improvements, and iterates through every 
% integral so that arbitrary potentials may be considered. Note that this
% may make solving for higher energy solutions hard, unless the number of
% basis states selected is small.
switch basis
    case 'sinusoid'
        divs = length(vspace);
        
        % Hamiltonian Matrix
        H = zeros(N);
        
        % Sinusoidal basis functions
        bfs = zeros(N,divs);
        xspace = linspace(0,1,divs);
        for n = 1:N
            bfs(n,:) = sqrt(2)*sin(n*pi*xspace);
        end
   
        % Solve the integral. This is a damn good approx
        for i = 1:N
            for j = 1:N
                H(i,j) = (i==j)*j^2 + discreteIntegrate(vspace.*bfs(i,:).*bfs(j,:),1/divs);
            end
        end
        
        [eigenVectors, eigenValues] = eig(H,'nobalance');
        % Sinusoid methods complete.
        
    case 'sorbital'
        % Soon.
        
    case 'porbital'
        % Not quite as soon.
        
end
end

function [basisFunctions, vspace] = getProblem(divs)
% Ask the user to select a problem type. Probably these aren't all
% supported.
% Returns
% 1. basisFunctions
%   - a string specifying the basis functions to be used.
% 2. constants
%   - An array containing the relavent constants to the potential

universe = menu('Choose a universe to embed your potential in','Infinite Square','Periodic BCs');

switch (universe)
    case 1
        potential = menu('Select a potential to embed in the universe','Empty','Harmonic Oscillator','Finite Well','Double Finite Well', 'Half Harmonic Oscillator');
    case 2
        potential = menu('Select a potential to embed in the universe','1D Atomic');
end

if universe == 1
    % Infinite square. The basis functions are easy.
    % u_n(x) = sqrt(2/a) sin(n*pi*x/a)
    basisFunctions = 'sinusoid';
    switch potential
        case 1
            %Empty infinite well
            vspace = zeros(1,divs);
        case 2
            %Harmonic oscillator. Assume walls at 0, 1. 
            x = input('Enter an well strength, p = hw/E0: ');
            divspace = linspace(0,1,divs);
            vspace = (x*pi/2)^2 * (divspace - 1/2).^2;
        case 3
            %Finite well
            depth = input('Enter the depth of the well (eV): ');
            width = input('Enter the width of the well, as a fraction of the total width: ');
            width = abs(width);depth=abs(depth);width=min(1,width);
            vspace = zeros(1,divs);
            vspace(1,(divs/2-width*divs/2):(divs/2+width*divs/2)) = depth;
        case 4
            %Double finite well
            depth = input('Enter the depth of the well (eV): ');
            width = input('Enter the width of the well, as a fraction of the total width: ');
            width = abs(width);width=min(0.5,width);
            vspace = zeros(1,divs);
            vspace(1,(divs/4-width*divs/2):(divs/4+width*divs/2)) = depth;
            vspace(1,(3*divs/4-width*divs/2):(3*divs/4+width*divs/2)) = depth;
        case 5
            % Half harmonic oscillator
            x = input('Enter an well strength, p = hw/E0: ');
            divspace = linspace(0,0.5,divs/2);
            vspace = (x*pi/2)^2 * (divspace).^2;
            vspace(divs/2:divs) = 0;
    end
elseif universe == 2
        basisFunctions = 'sorbital';
end
end

function result = discreteIntegrate(vector,dx)
% Simple integrate function for discrete "functions"
result = sum(vector);
result = result * dx;
end

function [eigenVectorsSorted,eigenValuesSorted] = sortVectors(eigenVectors,eigenValues)
% Make sure that MATLAB isn't being an absolute ass and returning mixed up
% eigenvectors/values
% Sort Vectors
eigenValues = diag(eigenValues);
eigenValuesSorted = sort(eigenValues(:,1));

% For each move in the Values, make corresponding move in Vectors
for i = 1:length(eigenValues)
   [a,b] = find(eigenValues == eigenValuesSorted(i));
   
   % Move vector
   eigenVectorsSorted(:,i) = eigenVectors(:,a);
end

end
