function [names,counts] = readmRNA(txtfilename)

if nargin < 1
    txtfilename = 'D17-10078_FinalNormalizedDGE2.txt';
end

%load data
root = pwd;
cd experimental_data
fid = fopen(txtfilename);
numcols = fgetl(fid);
C = textscan(fid,['%s',repmat('%f',1,length(strsplit(numcols,' ')))],...
    'delimiter',' ','Headerlines',0,'emptyvalue',nan,'collectoutput',1);
fclose(fid);
cd(root)

names = lower(erase(C{1},'"'));
counts = C{2};