function hist2corr(pearcorr,spearcorr,genename,namesclean)
%compare correlation coefficient methods for various gene correlations
%within the network.

geneind = find(strcmp(genename,namesclean));

figure;
histogram(pearcorr(geneind,:),'BinMethod','Scott',...
    'DisplayStyle','stairs','Normalization','probability'); hold on
histogram(spearcorr(geneind,:),'BinMethod','Scott','DisplayStyle',...
    'stairs','Normalization','probability');
set(gca,'yscale','linear');

legend('Pearson','Spearman')
xlabel('correlation coefficient')
title(['0 hrs run 3b ',genename])
set(gca,'fontsize',14)
xlim([-.5,1])