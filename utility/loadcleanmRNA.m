function [namesclean,dataclean,nanogind] = loadcleanmRNA(filenamecell)
%load data from filenames contained in the call array filenamecell. 

tic
%init
namecell = cell(0);
countcell = cell(0);

%load data
disp('loading data...')
for ii = 1:length(filenamecell)
    [namecell{ii},countcell{ii}] = readmRNA(filenamecell{ii});
end

%clean data
[namesclean,dataclean] = cleanmRNAdata2(namecell,countcell);

nanogind = find(not(cellfun(@isempty, strfind(namesclean,'nanog'))));
toc
