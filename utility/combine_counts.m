function countsout = combine_counts(countscell, indscell)

countsout = cell(length(indscell),1);
%loop across indicies to put in each big array
for jj = 1:length(indscell)
    %concatenate multiple data sets into one
    for ii = indscell{jj}
        countsout{jj} = [countsout{jj},countscell{ii}];
    end
end