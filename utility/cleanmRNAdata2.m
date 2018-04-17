function [namesclean, countsclean] = cleanmRNAdata2(namecell,countscell)
%takes a cell array of arrays of names and a cell array of counts matricies
%and returns a cell array of names that are common in all name arrays and
%the corresponding rows in each counts dataset

%init
countsclean = cell(0);

%find mRNA names that occur in every list and their indicies
[namesclean,indsclean] = intersectcell(namecell);
%output corresponding data rows
for ii = 1:length(countscell)
    countsclean{ii} = countscell{ii}(indsclean{ii},:);
end


function [nameintersect,nameinds] = intersectcell(namecell)
%intersects a cell array containing arrays to intersect and returns a cell
%array containing elements that are common in all arrays and their indicies

nameinds = cell(0);
if length(namecell) > 2
    [nametmp,nameindstmp] = intersectcell(namecell(2:end));
    [nameintersect,inds1,inds2] = intersect(namecell{1},nametmp);
    nameinds{1} = inds1;
    for ii = 1:length(nameindstmp)
        nameinds{ii+1} = nameindstmp{ii}(inds2);
    end
else
    [nameintersect,inds1,inds2] = intersect(namecell{1},namecell{2});
    nameinds = {inds1,inds2};
end
