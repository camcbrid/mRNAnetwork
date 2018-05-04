function neighborhoodnames = graph2names(G, names, gene, saveon, datacond)
%output all gene names connected to a gene according to the graph G. G
%is a square adjacency symmetric matrix, names is a cell arry containing
%all names of genes and is the same length as the dimensions of G, gene is
%either a string appearing in names or an index of the desired gene in
%names. saveon is a bool and switches whether the output is written to a
%txt file or displayed in the workspace, and fnameout is the filename to
%save the txt file.

%defaults
if nargin < 5
    datacond = 'test.txt';
    if nargin < 4
        saveon = false;
        if nargin < 3
            gene = 'nanog';
        end
    end
end

%input error handling
if ischar(gene)
    geneind = find(strcmp(gene,names));
elseif isnumeric(gene)
    if gene < length(names) && gene > 0
        geneind = round(gene);
    else
        geneind = 1;
    end
else; disp('Error: gene is not a name or index number'); geneind = 1;
end
if strcmp(datacond(end-3:end),'.txt')
    datacond = datacond(1:end-4);
end
datacond = strrep(datacond,' ','_');

%compute names from graph
if issymmetric(G)
    %adjacency matrix is directed
    %find nonzero indicies of the row belonging to geneind
    neighborhoodnames = names(G(geneind,:) ~= 0);
else
    %adjacency matrix is directed
    warning('adjency matrix not symmetric')
    
    neighborhoodnamesout = names(G(geneind,:) ~= 0); %out edges
    neighborhoodnamesin = names(G(:,geneind) ~= 0); %in edges
    
    %output inteserction of in edges and out edges
    neighborhoodnames = intersect(neighborhoodnamesout,neighborhoodnamesin);
end

%output
disp(names(geneind))
if saveon
    %write to txt file
    fileID = fopen([gene,'_neigh',datacond,'.txt'],'w');
    fprintf(fileID,'%s\r\n',[names{geneind},' neighborhood ', datacond,':']);
    fprintf(fileID,'%s\r\n','');
    for row = 1:size(neighborhoodnames,1)
        fprintf(fileID,'%s\r\n',[neighborhoodnames{row,:}]);
    end
    fclose(fileID);
else
    disp(neighborhoodnames)
end
