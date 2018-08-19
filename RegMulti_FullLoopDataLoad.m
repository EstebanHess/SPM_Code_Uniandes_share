% Clear all objects from the workspace in order to avoid confusing SPM: 

clearvars

% Set the directory where the MRI scans are stored as your working directory: 

cd /Documents/Neuroscience/ProyectoBaez


% Each MRI scan is stored in a folder. Get all the folder names and store them in a "list". 
%The technically correct term for this list is actually 'cell'. The command 'struct2cell' makes sure that we obtain a cell. 

FileList = struct2cell(dir('suj_*'));

% Create an empty character vector. This vector will be used to store the paths to the scans in: 

Data_Char = char.empty();

% Store the path to the current working directory in a variable called 'WorkDir': 

WorkDir = pwd

% Loop through the FileList (which is a structure called cell) and extract all the folder names and convert them to a character string (or character vector? I am not sure. Anyway the command 'class(FileName_String)' should yield the answer 'char'). 
% This character string 'FileName_String' is then strung together with the name of the working directory and the filename of the scan such that the complete path to the scan file results. 
% Finally this path ('Path_Char') is then added to a vector (or list?) of character strings 'Data_Char' (the empty vector we previously created - now it is no longer empty of course). In the end the paths ot all scans should be stored in Data_Char. 

for i = 1:length(FileList)
      FileName_String = strjoin(FileList(1,i));
      Path_Char = [WorkDir '/' FileName_String '/smwc1T1.nii,1'];
      Data_Char(i,:) = Path_Char;
end


% Get the dimensions (numer of rows and columns) of Data_Char (we will use them right afterwards: 

Size_Data_Char = size(Data_Char);

% Right now the paths to all the scan files are stored in Data_Char, which is a character vector of sorts (or a list of character strings).
% We need to convert it into a matlab object called 'cell'. Specify the dimensions of this cell using the dimensions of Data_Char (see above): 

Data = mat2cell(Data_Char, ones(1,Size_Data_Char(1)), Size_Data_Char(2));



% Set the first and the last scan file that you want to select: 

index1 = find(strcmp(Data, '/Documents/Neuroscience/ProyectoBaez/suj_100/smwc1T1.nii,1'));

index2 = find(strcmp(Data, '/Documents/Neuroscience/ProyectoBaez/suj_411/smwc1T1.nii,1'));


% Create an empty cell array 'Scans_init': 

Scans_init = {},


% Loop through 'Data' and extract the scans you need and store them in 'Scans_init'.

for i = 1:(index2-index1 + 1)
      Scans_init(i,1) = Data(index1 + i -1);
end

Scans_init


% Change the working directory to where you want to store the results of the analysis: 

cd /Users/stephanehess/Dropbox/MRI_Analysis_corr/

Root = '/Users/stephanehess/Dropbox/MRI_Analysis_corr/'

% Set list of names of the variables you want to test for a correlation with the VBM-MRI data: 


List_CovariateNames = [string('MS_FP_tot') string('MS_Miedo') string('MS_Alegria') string('MS_Neutro') string('MS_Asco') string('MS_Enojo') string('MS_Sorpresa') string('MS_Tristeza') string('MS_Caras_tot') string('Mini_SEA_tot') string('Ojos_17') string('Tasit_Miedo') string('Tasit_Tristeza') string('Tasit_Asco') string('Tasit_Enojo') string('Tasit_Sorpresa') string('Tasit_tot')];


% Load the covariates: 

load Covariates_Completed.txt

% Load the global values: 

load TIV_FTD_CTR_AD_2.txt



%Create a loop to loop through all the variables that you want to test: 


for i = 1:length(List_CovariateNames)

% Select the rows corresponding to the scans from the variable to be tested in the ith round (the variable i stands for the column number in the data frame and thus loops through the variables in the data frame. 2 is added to i because the first two columns contain the age and the ACE variables) Also select the corresponding global values: 

      Covariate1 = Covariates_Completed(1:37,i + 2);

      %Global_vals = Global_vals_init(1:37);
      Global_vals = TIV_FTD_CTR_AD_2(1:37);

% Select the age variable from the Covariate data frame: 

      Age = Covariates_Completed(1:37, 1);


% Identify the numbers of rows where data are missing and store that number in the variable "row" ("col" is actually not needed here):      

      [row1, col1] = find(isnan(Covariate1));


%The apostroph in " row' " turns the column vector into a row vector:

      row = row1'

% Eliminate the rows corresponding to the missing values from the Covariate1 and the Age data: 

      Covariate1(row) = [];

      Age(row) = [];

% Eliminate the rows corresponding to the missing values in the behavioral data from Scans: 

      Scans = Scans_init; 

      Scans(row) = [];      


% The same rows also have to be eliminated from the global values: 

      Global_vals(row) = [];



      spm('defaults', 'PET');
      spm_jobman('initcfg');


      %-----------------------------------------------------------------------
      % Job saved on 05-Jul-2017 00:22:11 by cfg_util (rev $Rev: 6460 $)
      % spm SPM - SPM12 (6906)
      % cfg_basicio BasicIO - Unknown
      %-----------------------------------------------------------------------

      matlabbatch{1}.spm.stats.factorial_design.dir = {'/Users/stephanehess/Dropbox/MRI_Analysis_corr'};
      %%
      matlabbatch{1}.spm.stats.factorial_design.des.mreg.scans = Scans;
      %%
      %%
      matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(1).c = Covariate1;

      %%
      matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(1).cname = 'BehavioralData';
      matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(1).iCC = 5;
      %%
      matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(2).c = Age;
      %%
      matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(2).cname = 'Age';
      matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(2).iCC = 5;
      matlabbatch{1}.spm.stats.factorial_design.des.mreg.incint = 1;
      matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
      matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
      matlabbatch{1}.spm.stats.factorial_design.masking.tm.tma.athresh = 0.2;
      matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
      matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
      %%
      matlabbatch{1}.spm.stats.factorial_design.globalc.g_user.global_uval = Global_vals;
      %%
      matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
      matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 2;

      spm_jobman('run', matlabbatch);


      % Create the folder names to be used for the folders where the spm.mat data files will be stored: 

      FolderName = char(strcat(Root, 'RegMulti_Age_', List_CovariateNames(i)))

      % Create a new directory inside your working directory with the folder name defined above: 

      mkdir(FolderName)

      % Move the SPM.mat file created in the ith round into the new directory created in the same round: 

      movefile('/Users/stephanehess/Dropbox/MRI_Analysis_corr/SPM.mat', FolderName)

      % End of the loop (the variable i jumps to the next variable and the process inside the loop starts again): 

end
