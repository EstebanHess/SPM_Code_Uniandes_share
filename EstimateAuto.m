
% Clear all objects from the workspace in order to avoid confusing SPM: 

clearvars

% Create a "file list" of the folder names containing the SPM.mat files. Again technically 'FileList' is an matlab object called 'cell'. 

FileList = struct2cell(dir('RegMulti_Age*'));


% Create an empty character vector. This vector will be used to store the SPM.mat files to the scans in: 

Data_Char = char.empty();

% Store the path to the current working directory in a variable called 'WorkDir': 

WorkDir = pwd

% Create a cell containing the paths to all the SPM.mat files: 

for i = 1:length(FileList)
      FileName_String = strjoin(FileList(1,i));
      Path_Char = [WorkDir '/' FileName_String '/SPM.mat'];
      SPM_mats(i,1) = mat2cell(Path_Char, 1, length(Path_Char));
end


% Store the path to the current working directory in the variable 'root': 

Root = '/Users/stephanehess/Dropbox/MRI_Analysis_corr/'

% Loop through all the SPM.mat files and perform the SPM estimate function on each one of them.
% Note that at the beginning of the loop the folder where the SPM.mat file is stored is set as working directory. At the end of the loop the directory containing these folders is again set as working directory, that way we start in the superordinate directory, step into the folder containing the first SPM.mat file, then step back out again, step into the next folder and so on and so forth: 


for i = 1:length(FileList)

    cd(char(strcat(Root, FileList(1,i))))

    spm('defaults','PET');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.stats.fmri_est.spmmat = SPM_mats(i);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch);
    cd ..


end



