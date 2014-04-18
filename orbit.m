function [fr] = orbit()
%Orbit sim
clf;
% Gravitational constant
G = 6.67384e-7;

massRange = [1e10 1e25]; % kg?
N = 100;
iterations = 10000;
dt = 1000;
cloudRadius = 1e10;
omega = 0.00000; % m/s tangential
minRange =1e9; % Collision detection radius

particles = struct('mass',zeros(N,1),'position',zeros(N,3),'velocity',zeros(N,3),'exists',ones(N,1));

particles = randomizer(particles, massRange, cloudRadius, omega);

plot3(particles.position(:,1),particles.position(:,2),particles.position(:,3),'k.');
figure(1);
axis([-cloudRadius cloudRadius -cloudRadius cloudRadius]);
view(10,+cloudRadius/2);
for j = 1:iterations

    % Update forces/accelerations/velocity/positions
    for n = 1:N
        if particles.exists(n) == 1
            if N~=1
                force = getForce(particles, n, G);
                accel = force/particles.mass(n,1);
                particles.velocity(n,1) = particles.velocity(n,1) + dt * accel(1);
                particles.velocity(n,2) = particles.velocity(n,2) + dt * accel(2);
                particles.velocity(n,3) = particles.velocity(n,3) + dt * accel(3);
            end
            particles.position(n,1) = particles.position(n,1) + dt * particles.velocity(n,1);
            particles.position(n,2) = particles.position(n,2) + dt * particles.velocity(n,2);
            particles.position(n,3) = particles.position(n,3) + dt * particles.velocity(n,3);
        end
    end
    particles = detectCollision(particles, minRange);
    remove = []; count = 1;
    for n = 1:N
      if particles.exists(n,1) == 0
          remove(count,1) = n;
          count = count + 1;
      end
    end

    if ~isempty(remove)
        disp('Removing these particles: ');
        disp(remove);
    end

    x = setdiff(1:length(particles.position(:,1)),remove);
    y = setdiff(1:length(particles.position(:,2)),remove);
    z = setdiff(1:length(particles.position(:,3)),remove);

    position = particles.position;

    particles = rmfield(particles, 'position');

    x = position(x,1);
    y = position(y,2);
    z = position(z,3);

    particles.position = [];
    particles.position(:,1) = x;
    particles.position(:,2) = y;
    particles.position(:,3) = z;

    N = N-length(remove);
    plot3(particles.position(:,1),particles.position(:,2),particles.position(:,3),'k.');
    axis([-cloudRadius cloudRadius -cloudRadius cloudRadius]);
    camproj('perspective')
    grid on;

    getframe(gcf);
end
end

function [force] = getForce(particles, n, G)
% Finds the force on the nth particle from all the other particles
force = 0;
N = length(particles.position(:,1));
for i = 1:N
    if i ~= n
        if particles.exists(n,1) == 1
            r = [particles.position(i,1) - particles.position(n,1)
                particles.position(i,2) - particles.position(n,2)
                particles.position(i,3) - particles.position(n,3)];
            
            dist = sqrt(r(1)^2 + r(2)^2 + r(3)^2);
            
            r = r/dist;
            
            force = force + (G*particles.mass(n)*particles.mass(i)/dist^2)*r;
        end
    end
end


end

function particles = randomizer(parts, massRange, cloudRadius, omega)
N = length(parts.position(:,1));

M = (massRange(2) - massRange(1))*rand(N,1);

theta = pi*rand(N,1);
phi = 2*pi*rand(N,1);
R = cloudRadius*rand(N,1);

x = R.*sin(theta).*cos(phi);
y = R.*sin(theta).*sin(phi);
z = R.*cos(theta);

vx = R.*cos(theta).*sin(phi)*omega;
vy = -R.*cos(theta).*cos(phi)*omega;


parts.position(:,1) = x;
parts.position(:,2) = y;
parts.position(:,3) = z;
parts.velocity(:,1) = vx;
parts.velocity(:,2) = vy;
parts.mass = M;


particles = parts;
end

function [particles] = detectCollision(particles, minRange)
% Detects if particles are close enough to collide
N = length(particles.position(:,1));

if N ~= 1
    for n = 1:N
        if particles.exists(n) == 1
            min_dist = 0;
            this = 0;

            % Find the minimum distance and record which particle it was to
            for i = 1:N
                if i ~= n
                    r = [particles.position(n,1) - particles.position(i,1)
                        particles.position(n,2) - particles.position(i,2)
                        particles.position(n,3) - particles.position(i,3)];
                    dist = [sqrt(r(1)^2 + r(2)^2 + r(3)^2), i];

                    if min_dist == 0
                        % We just started for this particle
                        min_dist = dist;
                        this = i;
                    elseif dist < min_dist
                        min_dist = dist;
                        this = i;
                    end
                end
            end

            % A collision is detected
            if min_dist < minRange
                survivor = this*(particles.mass(this,1) > particles.mass(n,1)) + ...
                    n*(particles.mass(n,1) > particles.mass(this,1));
                dead = n*(particles.mass(this,1) > particles.mass(n,1)) + ...
                    this*(particles.mass(n,1) > particles.mass(this,1));

                % Combine masses
                particles.mass(survivor,1) = particles.mass(survivor,1) + particles.mass(dead,1);
                % Kill it.
                particles.exists(dead,1) = 0;

                % Combine velocity
                vxnew = (particles.velocity(survivor,1)*particles.mass(survivor,1) + particles.velocity(dead,1)*particles.mass(dead,1))/ ...
                        (particles.mass(survivor,1) + particles.mass(dead,1));
                vynew = (particles.velocity(survivor,2)*particles.mass(survivor,1) + particles.velocity(dead,2)*particles.mass(dead,1))/ ...
                        (particles.mass(survivor,1) + particles.mass(dead,1));
                vznew = (particles.velocity(survivor,3)*particles.mass(survivor,1) + particles.velocity(dead,3)*particles.mass(dead,1))/ ...
                        (particles.mass(survivor,1) + particles.mass(dead,1));
                particles.velocity(survivor,:) = [vxnew,vynew,vznew];
            end
        end
    end
end

end