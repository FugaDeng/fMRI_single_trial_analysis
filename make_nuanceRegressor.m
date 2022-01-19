function make_nuanceRegressor(motionfName,imgName,timepoints,saveName)

%% this function adds white matter and csf signal to the motion regressor and keeps
% the timepoints you are interested (i.e., removes the first few volumes)

%%
% add white matter and CSF signals here
%%

fID=fopen(motionfName);
R=fscanf(fID,'%d %f',[6 Inf]);
R=R';
R=R(timepoints,:);
fclose(fID);

%% CHANGE THIS SECTION WHEN MOVING TO CLUSTER
addpath('D:\MATLABlib\NIfTI_toobox') %!!
wmask=load_nii('D:\Research_local\SchemRep\data_sample\resample_atlases\WhiteMask_3mm_53x63x52.nii');
wmask=wmask.img;
csfmask=load_nii('D:\Research_local\SchemRep\data_sample\resample_atlases\CsfMask_3mm_53x63x52.nii');
csfmask=csfmask.img;
%%


fimg=load_nii(imgName);fimg=fimg.img;

R2=zeros(length(timepoints),2);
for i=1:length(timepoints)
    tmp=fimg(:,:,:,timepoints(i));
    R2(i,1)=mean(tmp(wmask~=0));
    R2(i,2)=mean(tmp(csfmask~=0));
end

R=[R,R2];

save(saveName,'R');
