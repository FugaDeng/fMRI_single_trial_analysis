function ST_day1(imgdir,scanID,sessNums,resultsDir,behFilePath,subjectID)
% example inputs:
% imgdir = 'D:\Research_local\SchemRep\data_sample\Func\20211208_03365\'
% resultsDir='D:\Research_local\SchemRep\data_sample\singletrial_test_202\'; %%%
% sessNums = {'004', '005', '006'}
% behFilePath = 'D:\Research_local\SchemRep\data_sample\behavFiles\ENC\'
% subjectID = 'S202'

funcImgs={...
    fullfile(imgdir, ['wrabia6_', scanID, '_', sessNums{1}, '_01.nii'] ),...%%%
    fullfile(imgdir, ['wrabia6_', scanID, '_', sessNums{2}, '_01.nii'] ),...%%%
    fullfile(imgdir, ['wrabia6_', scanID, '_', sessNums{3}, '_01.nii'] ),};%%%

funcFrames=5:162; % OK

%%
for i=1:3 %3 runs
    
    tmpdirBase = fullfile(resultsDir,['run' num2str(i)]);
    
    pdata=load(fullfile(behFilePath, [subjectID, '_run', num2str(i), '.mat'] ));
    
    onsets=cell2mat(pdata.pdata.tObjOnset)'; % OK
    durations = repmat(4,length(onsets),1);% OK
    
    assert(length(onsets)==38); % OK
    %
    nuaregr=fullfile(imgdir, ['regressors_', scanID, '_', sessNums{i}, '.mat']);
    % example: 'D:\Research_local\SchemRep\data_sample\Func\20211208_03365\regressors_03365_004.mat';
    if exist(nuaregr,'file')==0
        make_nuanceRegressor(...%'D:\Research_local\SchemRep\data_sample\Func\20211208_03365\rp_abia6_03365_004_01.txt',...
            fullfile(imgdir, ['rp_abia6_', scanID, '_', sessNums{i}, '_01.txt']),...% 
            funcImgs{i},funcFrames,nuaregr)
    end
    %
    if exist(funcImgs{i},'file')==0
        gunzip([ funcImgs{i}, '.gz'])
    end
    
    matlabbatch=ST_base(funcImgs{i},funcFrames,onsets,durations,nuaregr,tmpdirBase); %#ok<NASGU>
    
    save(fullfile([tmpdirBase, 'SPM_jobs.mat']),'matlabbatch')
end
