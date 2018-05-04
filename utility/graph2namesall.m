function [namesall] = graph2namesall(G, names, saveon, datacond)

if nargin < 4
    datacond = '';
    if nargin < 3
        saveon = false;
    end
end

if ~issymmetric(G)
    disp('Warning: adjacency matrix not symmetric')
end
datacond = strrep(datacond,' ','_');

n = min(size(G));
%make adjacency matrix upper triangular
G2 = sparse(triu(G));
p = full(sum(sum(abs(G2))));        %number of edges in G

%init
namesall = cell(p,3);
q = 0;      %running counter
disp('creating edge set...')
for ii = 1:n
    neighborhood = names(G2(:,ii) ~= 0);
    if ~isempty(neighborhood)
        m = length(neighborhood);
        generootname = names(ii);
        Gcol = G2(:,ii);
        vals = full(Gcol(G2(:,ii) ~= 0));
        namesall(q+1:q+m,1) = generootname;
        namesall(q+1:q+m,2) = neighborhood;
        namesall(q+1:q+m,3) = num2cell(vals);
        q = m + q;      %update counter
    end
end

%output
if saveon
    disp('saving...')
    %write to txt file
    fileID = fopen(['all_gene_edges',datacond,'.txt'],'w');
    fprintf(fileID,'all gene pairs %s:\r\n',datacond);
    fprintf(fileID,'%s\r\n','');
    for row = 1:size(namesall,1)
        fprintf(fileID,'%s %s %d\r\n',namesall{row,1},namesall{row,2},namesall{row,3});
    end
    fclose(fileID);
else
    %disp(namesall)
end