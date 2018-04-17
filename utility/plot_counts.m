function plot_counts(data_cell)
%plot raw data counts histogram for datasets

n = length(data_cell);

figure(1);
for ii = 1:n
    subplot(1,n,ii);
    histogram(data_cell{ii}(:),'BinMethod','Scott',...
        'Normalization','probability','DisplayStyle','stairs');
    set(gca,'Yscale','log');
    xlabel('normalized counts')
    ylabel('probability mass')
    if ii == 1
        title('0 hrs')
    elseif ii == 2
        title('24 hrs')
    elseif ii == 3
        title('48 hrs')
    end
end
drawnow;