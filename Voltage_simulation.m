% Voltage simulation.
% Voltage of a point charge arrangment
function Voltage_simulation()
testQ = 1.602E-19; % Coloumbs

groundStyle = 'infinity';

myK = 1/(4*pi*8.85E-12);

xPoints = -1:0.001:1;
yPoints = -1:0.001:1;

V = zeros(length(xPoints), length(yPoints));

charges = generateCharges('circle',6);

myVar = size(charges)
numCharges = myVar(1)

percent = 0;
count = 0;
total = length(xPoints)*length(yPoints)*numCharges;
% V = (1/4 pi e0) (q1/r1 + q2/r2 + ... )
for i = 1:length(xPoints)
    
    for k = 1:length(yPoints)
        
        for n = 1:numCharges
            
            if checkLocation(n, charges, xPoints(i), yPoints(k)) == 1
                V(i,k) = V(i,k) + charges(n,3)/sqrt((charges(n,1)-xPoints(i))^2 + (charges(n,2)-yPoints(k))^2 );
            else
                V(i,k) = V(i-1,k)/2 + V(i,k-1)/2;
            end
            count = count + 1;
        end
    end
    percent = count/total * 100;
    clc;
    fprintf('%3.1f %% \n', percent);
end



surfc(xPoints,yPoints,V);
shading flat;

end

function charges = generateCharges(selection, accuracy)
%x,y,charge
    testQ = 100*1.602E-19; % Coloumbs
    
    if selection == 'circle'
        radius = 0.2;
        for i = 1:accuracy
            charges(i,1) = radius*sin(i);
            charges(i,2) = radius*cos(i);
            charges(i,3) = testQ;
        end
    end
end

function validLocation = checkLocation(n, charges,x,y)
    validRange = 0.005;
    validLocation = 1;
    if ((abs(x - charges(n,1)) < validRange) && (abs(y - charges(n,2))< validRange))
        validLocation = 0;
    end

end

