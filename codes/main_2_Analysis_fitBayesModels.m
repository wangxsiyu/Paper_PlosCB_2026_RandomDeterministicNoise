main_0_setup
%% main bayes
files = {'bayes_2noise.mat', 'bayes_2noise_all.mat'};
suffix = {'','_all'};
for fi = 1:2
    d = load(fullfile(fullfile('../data',ver), files{fi})).(['bayes_data', suffix{fi}]);
    wj.setup_data_dir(d, outputdir);
    wjinfo = EEbayes_analysis(d, nchains);
    wj.setup(wjinfo.modelfile, wjinfo.params, struct, ['DetRanNoise' suffix{fi}]);
    wj.run;
end
%% model no bias
% data = load(fullfile('../data', 'bayes_2noise.mat')).(['bayes_data']);
% data.modelname = ['2noisemodel_nobias'];
% wj.setup_data_dir(data, outputdir);
% wjinfo = EEbayes_analysis(data, nchains);
% wj.setup(wjinfo.modelfile, wjinfo.params, wjinfo.init0, ['DetRanNoise_nobias']);
% wj.run;
%% model paironly
d = load(fullfile(fullfile('../data',ver), 'bayes_2noise_paironly.mat')).(['bayes_data_paironly']);
d.modelname = ['2noisemodel'];
wj.setup_data_dir(d, outputdir);
wjinfo = EEbayes_analysis(d, nchains);
wj.setup(wjinfo.modelfile, wjinfo.params, struct, ['DetRanNoise_paironly']);
wj.run;
%% reduced model
files = {'bayes_2noise_dRonly.mat', 'bayes_2noise_0model.mat', 'bayes_2noise_dIonly.mat'};
suffix = {'_dRonly','_0model','_dIonly'};
for fi = 1:1 % just the first one
    d = load(fullfile(fullfile('../data',ver), files{fi})).(['bayes_data', suffix{fi}]);
    wj.setup_data_dir(d, outputdir);
    wjinfo = EEbayes_analysis(d, nchains);
    wj.setup(wjinfo.modelfile, wjinfo.params, struct, ['DetRanNoise' suffix{fi}]);
    wj.run;
end
%% main bayes (2 condition/dIvar models, see model names)
% set of models
% 1cond vs 2cond
% dI vs dIvar
suffix = {'', '_dIvar', '_nonhierarchical', '_2cond', '_2cond_dIvar', '_2cond_dIvar_both', '_2cond_dRonly', '_2cond_nobias', ...
    'B_2cond','C_2cond','D_2cond','E_2cond','F_2cond','_2cond_nonhierarchical'};% reviewer fit non-hierarchical
for fi = 1:length(suffix)
    main_0_setup;
    d = load(fullfile('../data/all', 'bayesdata.mat')).(['bayesdata']);
    d.modelname = sprintf('2noisemodel%s', suffix{fi});
    wj.setup_data_dir(d, outputdir);
    wjinfo = EEbayes_analysis(d, nchains);
    wj.setup(wjinfo.modelfile, wjinfo.params, struct, ['DetRanNoiseR1' suffix{fi}]);
    wj.run;
end

%% test convergence
main_0_setup;
nchains = 4; % How Many Chains?
nburnin = 0; % How Many Burn-in Samples?
nsamples = 5000; % How Many Recorded Samples?
wj.setup_params(nchains, nburnin, nsamples);
d = load(fullfile('../data/all', 'bayesdata.mat')).(['bayesdata']);
d.modelname = '2noisemodel_2cond';
wj.setup_data_dir(d, outputdir);
wjinfo = EEbayes_analysis(d, nchains);
wj.setup(wjinfo.modelfile, wjinfo.params, struct, 'DetRanNoiseR1_convergence');
wj.run;