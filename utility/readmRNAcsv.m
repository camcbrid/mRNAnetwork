function [counts,names] = readmRNAcsv(filename)

cd experimental_data
[counts,names] = xlsread(filename);
cd ..