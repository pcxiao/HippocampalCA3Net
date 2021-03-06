function [f X] = daveFFT_scale (t_input, x_input, scale_freq)

if nargin < 3
    scale_freq = 1;
end

tstep = t_input(2)-t_input(1);
min_t = min(t_input);
max_t = max(t_input);

t = min_t:tstep/scale_freq:max_t;
N = length(t);
dt = tstep/scale_freq;
df = 1/(N*dt);
%t = (0:N-1)*dt;
f = df * (0:N-1);

x = interp1(t_input,x_input,t);
X = 2*pi*fft (x)/N; % This 2*pi scaling produces the correct amplitudes for CTFT
                    % Dividing by N removes the "delta" functions

end