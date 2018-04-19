function deglistall = plotdeg(Gcell,datatagcell)

deglistall = cell(0);
deglistpos = cell(0);
deglistneg = cell(0);

figure(4); clf;
%edges in aggregate
subplot(2,2,[1,2]);
for ii = 1:length(Gcell)
    deglistall{ii} = sum(Gcell{ii} ~= 0);
    histogram(log10(deglistall{ii}),'binmethod','Scott','normalization',...
        'probability','displaystyle','stairs'); hold on
end
hold off;
set(gca,'yscale','linear')
xlabel('log_{10}(node degree)')
ylabel('probability mass')
legend(datatagcell,'Location','Best')
title('all edges')

%positive edges only
subplot(2,2,3);
for ii = 1:length(Gcell)
    deglistpos{ii} = sum(Gcell{ii} > 0);
    histogram(log10(deglistpos{ii}),'binmethod','Scott','normalization',...
        'probability','displaystyle','stairs'); hold on
end
hold off;
set(gca,'yscale','linear')
xlabel('log_{10}(node degree)')
ylabel('probability mass')
legend(datatagcell,'Location','Best')
title('positive edges')

%negative edges only
subplot(2,2,4);
for ii = 1:length(Gcell)
    deglistneg{ii} = sum(Gcell{ii} < 0);
    histogram(log10(deglistneg{ii}),'binmethod','Scott','normalization',...
        'probability','displaystyle','stairs'); hold on
end
hold off;
set(gca,'yscale','linear')
xlabel('log_{10}(node degree)')
ylabel('probability mass')
legend(datatagcell,'Location','Best')
title('negative edges')