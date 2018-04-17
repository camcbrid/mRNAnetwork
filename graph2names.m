function neighborhoodnames = graph2names(G,geneind,namesclean)

if issymmetric(G)
    %find nonzero indicies of the row belonging to geneind
    inds = find(G(geneind,:));
    neighborhoodnames = namesclean(inds);
    
    %display output
    disp(namesclean(geneind))
    disp(neighborhoodnames)
end