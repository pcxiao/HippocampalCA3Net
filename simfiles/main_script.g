
//Please address feedback or comments to David Stanley, Boston University.
//Email is my last name followed by my first initial at bu dot edu.

// Various tweaks - for model tuning
setrand -sprng			// The standard numerical recipies RNG doesn't work!
int test_synapses = 0
	int cell2test = 3 	//1=pyr; 2=bc; 3=olm; 4=msg
	int noise_off = 0
	if (test_synapses); noise_off = 1; end
int test_bkgnd_syn = 0
	int include_msg_aff_input = 1
	if (test_bkgnd_syn); no_synapses = 1; end
	if (test_bkgnd_syn); small_net = 1; end

int enable_olm2bc_synapse = 0


// Menne stuff
include network41.g // network functions and randomizations (modified from Kerstin Menne's scripts)





// Load constats, cell prototypes, and output functions
include constants_HN.g
include tweaks_constants.g				// Circadian functions. Needs to come after constants, before prototypes
include prot_msgaba.g				// Make basket, olm, and msg cells from Hajos 2004 paper
include prot_b.g
include prot_olm.g
include prot_traub91.g				// Pyramidal cell from Traub 1991
include tweaks_cells.g				// Circadian functions. Needs to come after prototypes
include output_dav.g

// Set up cell arrays
include synapse_objects.g	// Create library of synaptic objects
include create_arrays_HN.g	// Add synaptic channels, create cell arrays
include randomize_HN.g
include electrodes_HN.g


// Add synapses
include connect_syn_functions.g	// Supporting functions
include connect_synapses.g
int n_msg_surviving = percent_msg_intact * n_of_msg
for (i=n_msg_surviving;i<{n_of_msg};i=i+1)		// Disable 'dead' msg cells
	disable /msg_arr/msg[{i}]
end

if (n_of_pyr > 1); spike_rec_setup {sim_time} 3 "pyr" {n_of_pyr}; end
if (n_of_olm > 1); spike_rec_setup {sim_time} 3 "olm" {n_of_olm}; end
if (n_of_bc > 1); spike_rec_setup {sim_time} 3 "bc" {n_of_bc}; end
if (n_of_msg > 1); spike_rec_setup {sim_time} 3 "msg" {n_of_msg}; end
if (n_of_e90 > 1); spike_rec_setup {sim_time} 2 "e90" {n_of_e90}; end


check  // only issues warnings that compartments taken over by hsolve would
         // not get issued for simulation
reset


//str loop_chan
//foreach loop_chan ( {el /pyr/#/AMPA,/pyr/#/NMDA,/pyr/#/GABA_A,/pyr/#/GABA_B} )
//	disable {loop_chan}
//end


//include connection_stats.g
include plot_graphics.g				// for plot_graphics commands.
include write_everything_totals		// for plot_graphs commands.


if (plot_on)
	plot_graphics "/pyr_arr/pyr[]" "/form4"
	plot_graphics "/bc_arr/bc[]" "/form5"
	plot_graphics "/olm_arr/olm[]" "/form6"
	plot_graphics "/msg_arr/msg[]" "/form7"

	if (test_synapses || test_bkgnd_syn)
//		plot_graphs "/pyr_arr/pyr/basal_4" "/graphs6" "deleteme6" 1 1
//		plot_graphs "/pyr_arr/pyr/apical_18" "/graphs6" "deleteme6" 1 1
//		plot_graphs "/pyr_arr/pyr/soma" "/graphs1" "deleteme2" 1 1
//		plot_graphs "/bc_arr/bc/soma" "/graphs1" "deleteme2" 1 1
//		plot_graphs "/olm_arr/olm/soma" "/graphs1" "deleteme2" 1 1
		//plot_graphs "/msg_arr/msg/soma" "/graphs1" "deleteme4" 1 1
	end
end

reset
reset

////////////// This is not used. For testing only ///////////////////
include PID_thresh.g
int PID_time = 1.0
if (test_synapses || test_bkgnd_syn)

	if (cell2test == 1)
		//disable /pyr_arr/pyr[1]; disable /pyr_arr/pyr[0]
		plot_graphs "/pyr_arr/pyr/soma" "/graphs1" "deleteme2" 1 1
		PID_thresh "/pyr_arr/pyr/soma" 0.1 {PID_time} -0.065 0 1 1 "nosave"
		ce /pyr_arr/pyr/soma
		step 160000
	end
	if (cell2test == 2)
		disable /pyr_arr/pyr[1]; disable /pyr_arr/pyr[0]
		plot_graphs "/bc_arr/bc/soma" "/graphs1" "deleteme2" 1 1
		PID_thresh "/bc_arr/bc/soma" 0.1 {PID_time} -0.065 0 1 1 "nosave"
		ce /bc_arr/bc/soma
		step 160000
	end
	if (cell2test == 3)
		disable /pyr_arr/pyr[1]; disable /pyr_arr/pyr[0]
		plot_graphs "/olm_arr/olm/soma" "/graphs1" "deleteme2" 1 1
		PID_thresh "/olm_arr/olm/soma" 0.1 {PID_time} -0.065 0 1 1 "nosave"
		ce /olm_arr/olm/soma
		step 160000
	end
	
	sim_time = sim_time - PID_time
	
end

// This is used to generate some files containing code metadata, which are later read in by Matlab.
echo %Circadian values log >> {gp}{pp}{sp}/circvalfile.m
echo SCN_val({tindex}) = {SCN_val}";" >> {gp}{pp}{sp}/circvalfile.m
echo mel_val({tindex}) = {mel_val}";" >> {gp}{pp}{sp}/circvalfile.m
echo EC_val({tindex}) = {EC_val}";" >> {gp}{pp}{sp}/circvalfile.m
echo ACh_val({tindex}) = {ACh_val}";" >> {gp}{pp}{sp}/circvalfile.m
	echo ACh_level({tindex}) = {ACh_level}";" >> {gp}{pp}{sp}/circvalfile.m
	echo ACh_accom_scale({tindex}) = {ACh_accom_scale}";" >> {gp}{pp}{sp}/circvalfile.m
	echo ACh_Esyn_scale({tindex}) = {ACh_Esyn_scale}";" >> {gp}{pp}{sp}/circvalfile.m
	echo ACh_Isyn_scale({tindex}) = {ACh_Isyn_scale}";" >> {gp}{pp}{sp}/circvalfile.m
	echo ACh_pyr_inj({tindex}) = {ACh_pyr_inj}";" >> {gp}{pp}{sp}/circvalfile.m
	echo ACh_bc_inj({tindex}) = {ACh_bc_inj}";" >> {gp}{pp}{sp}/circvalfile.m
	echo ACh_olm_inj({tindex}) = {ACh_olm_inj}";" >> {gp}{pp}{sp}/circvalfile.m
echo Ca_val({tindex}) = {Ca_val}";" >> {gp}{pp}{sp}/circvalfile.m
echo percent_msg_intact({tindex}) = {percent_msg_intact}";" >> {gp}{pp}{sp}/circvalfile.m
echo percent_ACh_intact({tindex}) = {percent_ACh_intact}";" >> {gp}{pp}{sp}/circvalfile.m



step {sim_time} -t
spike_rec_save

//include connection_stats.g

exit
