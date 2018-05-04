function pltcorrmathist(corrmatcell, datatagcell)
%plot correlation matrix histograms

figure; hold on

for ii = 1:length(corrmatcell)
    histogram(corrmatcell{ii}(corrmatcell{ii} ~= 0),'BinMethod','Scott',...
        'normalization','pdf','displaystyle','stairs');
end
set(gca,'yscale','log')
xlabel('correlation')
ylabel('probability density')
set(gca,'fontsize',14)
xlim([-1,1])
legend(datatagcell,'location','best')
