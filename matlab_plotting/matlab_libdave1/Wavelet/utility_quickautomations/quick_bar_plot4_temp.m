

% stats_suffix = '.general_beta_est.beta_est';

include_error = 1;

sf_temp = stats_suffix;
name_arr = {'ic1syngap'; 'ic2syngap'; 'ic3syngap'; 'ic4syngap'; 'ic5gapsyn'; 'ic6gapsyn'; 'ic7gapsyn'; 'ic9gapsyn'};
batch_avg;
icsyngap_avg = abs(avg);
% icsyngap_sterr = sterr;
icsyngap_sterr = max(sterr,avg_spread);

name_arr = {'ic5gap'; 'ic6gap'; 'ic7gap'; 'ic9gap'};
batch_avg;
ic_unblk_avg = abs(avg);
% ic_unblk_sterr = sterr;
ic_unblk_sterr = max(sterr,avg_spread);

if (invert_plot)
    sf_temp = [sf_temp '*-1']; 
end

figure;
% eval (['bar_set = [icsyngap_avg; fb0_onlyion' sf_temp '; ic_unblk_avg; fb1s_stoch' sf_temp '];'])
eval (['bar_set = [icsyngap_avg; fb0_inj4em12' sf_temp '; ic_unblk_avg; fb1s_stoch' sf_temp ...
                '; fb2s_defstoch' sf_temp ...
                '; fb5s_stoch_noAMPA' sf_temp ...
                '; fb2s_det' sf_temp ...
                '; fb2sonly_defstoch' sf_temp ...
                '; fb4sonly_det' sf_temp ...
                '];'])
bar (bar_set,'w');
hold on;


if (include_error)
    
    sf_temp = stats_suffix;
    sf_temp = [sf_temp 'err'];

    eval (['errorbar_set = [icsyngap_sterr; fb0_inj4em12' sf_temp '; ic_unblk_sterr; fb1s_stoch' sf_temp ...
                    '; fb2s_defstoch' sf_temp ...
                    '; fb5s_stoch_noAMPA' sf_temp ...
                    '; fb2s_det' sf_temp ...
                    '; fb2sonly_defstoch' sf_temp ...
                    '; fb4sonly_det' sf_temp ...
                    '];'])

    errorbar (bar_set,errorbar_set,'ko');
else
    errorbar (bar_set, [icsyngap_sterr; 0; ic_unblk_sterr;0;0;0;0;0;0] ,'ko');
end


xlabel_arr = {'e syngap';'fb0_inj4em12';'e acsf';'ms acsf'; 'ms acsf2'; 'ms acsf noAMPA'; 'md acsf'; 'ms onlysyn'; 'md onlysyn'};
set(gca,'XTick',1:length(xlabel_arr))
set(gca,'XTickLabel',xlabel_arr, 'FontSize', 8)
title('Probability Density Function');