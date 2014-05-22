
clc
format compact
addpath(genpath(fullfile('..','matlab_libdave1')))
addpath('./funcs_supporting')


if ~(exist('set_values','var'))
    set_values = 1;
end

if set_values
    
% % %     Choose the path you want % % %
%     path_ld = pwd; path_ld = [path_ld '/t0'];                                             % For loading data from working directory (useful if using Octave!)
%     path_ld=fullfile('..','..','simfiles','dataset_temp','0_test_smallnet_6am','t6');     % For loading data generated by current simulation
    path_ld=fullfile('..','..','simfiles','dataset_sample','0_test_fullnet_6am','t6');    % For loading pre-generated data that comes with this package

    
    % These variables can be customized to affect the plotting output
    plot_on = 1;
    dt = 5e-4;
    raster = 0;
    plot_matrix_on = 1;
    get_kappa = 1;
    max_traces = 10;
    datashift = 0;
        % If raster = 0, can set these!
            plot_traces=1;
            plot_autocorr=0;
    celltype = 'psoma';
        

end


% % % % %  Should not need to change anything below here.

if raster == 1
    raster_or_train = 'raster_';
else
    raster_or_train = 'sptr_';
end

%     % This is no longer used!
% if strcmp(celltype ,'psoma'); range=1:8; end
% if strcmp(celltype ,'b'); range=1:100; end
% if strcmp(celltype ,'msg'); range=1:100; end
% if strcmp(celltype ,'olm'); range=1:50; end



X = load_files2mat (path_ld, raster_or_train, celltype);

binning_int=1e-2; % 10 milliseconds (Hajos et al, 2004)
[rows cols] = size(X);
range_max = 1:cols;
if get_kappa; K = get_me_kappa ([path_ld '/' 'raster_' celltype '%d.dat'],range_max, binning_int); end
colour_array = ['brgcymkbrgcymkbrgcymkbrgcymkbrgcymkbrgcymkbrgcymkbrgcymkbrgcymk'];
if raster == 0
    if plot_traces
        
%         for j = 1:min(max_traces, length(range_max));
%             t = (0:size(X,1)-1)*dt;
%             cell1 = X(:,j);
%         end
        t = (0:size(X,1)-1)*dt;
        plotmat = X(:,1:min(max_traces, length(range_max)));
        if plot_on; figure;
            opt_strct.shift = datashift;
            plot_matrix(t,plotmat,opt_strct);
            t_rawtrace = t; pm_rawtrace = plotmat;
        
			hold on;
			size(t)
			size(plotmat)
%			plot(t,mean(plotmat'),'LineWidth',4);
			
            xlabel('t (sec)'); ylabel ('Vm (V)');
            X = load_files2mat (path_ld, 'raster_', celltype);
            [rows cols] = size(X);
		    Xall = reshape(X, rows*cols, 1);
		    binsize = 0.02;
		    nbins = round((max(Xall)-min(Xall))/binsize);
		    [n xout] = hist(Xall,nbins);
		    t = xout(2:end);
		    data=n(2:end);
		    data = data ./ binsize ./ size(X,2);	% Normalize to get in terms of average firing rate per cell per second
			title (['Celltype ' celltype ' Kappa = ' num2str(K*100) '%' ' Mean firing rate ' num2str(mean(data)) '.']);

            
        end
    end
    
    if plot_autocorr
        plotmat = [];
        for j = 1:min(max_traces, length(range_max));
            t = (0:size(X,1)-1)*dt;
            cell1 = X(:,j);
            [xout, tout] = davexcorr (t,cell1,cell1,1,0);
            plotmat = [plotmat xout];
        end
        if plot_on; figure; plot(tout, plotmat); end
        
    end

elseif raster == 1

    % Plot spike time histogram
    [rows cols] = size(X);
    Xall = reshape(X, rows*cols, 1);
    binsize = 0.02;
    nbins = round((max(Xall)-min(Xall))/binsize);
    [n xout] = hist(Xall,nbins);
    t = xout(2:end);
    data=n(2:end);

%     figure; plot(xout(2:end),n(2:end),'b');
    if plot_on;
    	data = data ./ binsize ./ size(X,2);	% Normalize to get in terms of average firing rate per cell per second
        figure; bar(t,data);
        starting_time = 0;
        [temp_val temp_ind] = find (xout > starting_time, 1, 'first');
        %axis([starting_time 4 0 max(n(temp_ind:end))]);
        xlabel('Time (s)');
        ylabel('Average instantaneous firing rate');
        title(['Firing histogram; Kappa = ' num2str(K*100) '%' ' Mean firing rate ' num2str(mean(data)) '.']);
        

        
    end
end


if plot_matrix_on
	
	if plot_on
		X_pyr = load_files2mat (path_ld, 'raster_', 'psoma'); N_pyr = size(X_pyr,2);
		X_bc = load_files2mat (path_ld, 'raster_', 'b'); N_bc = size(X_bc,2);
		X_olm = load_files2mat (path_ld, 'raster_', 'olm'); N_olm = size(X_olm,2);
		X_msg = load_files2mat (path_ld, 'raster_', 'msg'); N_msg = size(X_msg,2);
        figure;
        hold on; X = X_pyr; x=repmat(1:size(X,2),size(X,1),1); plot(X(:),x(:),'b.')
        hold on; X = X_bc; x=repmat((1:size(X,2)) + N_pyr,size(X,1),1); plot(X(:),x(:),'r.')
        hold on; X = X_olm; x=repmat((1:size(X,2)) + N_pyr + N_bc,size(X,1),1); plot(X(:),x(:),'g.')
        hold on; X = X_msg; x=repmat((1:size(X,2)) + N_pyr + N_bc + N_olm,size(X,1),1); plot(X(:),x(:),'m.')
        legend ('pyr','bc','olm','msg')
        xlabel('time (s)'); ylabel('cell number');
	end
end


