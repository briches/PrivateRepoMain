function [] = VoltageFEM(iterations)
if nargin == 0, iterations = 20; end

clc;
xSize = 100;
ySize = 50;
V = zeros(xSize,ySize);


for i = 1:ySize
    V(xSize, i) = 1;
end


for run = 1:iterations
    for i = 2:xSize-1
        for k = 2:ySize -1
            V(i,k) = (V(i+1,k) + V(i-1,k) + V(i,k+1) + V(i,k-1))/4;
        end
    end
end

surf(V)

end

