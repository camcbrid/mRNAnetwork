%run graph construction

addpath utility

%load data
if ~exist('countsclean','var')
    load('mRNAdata.mat');
    if 0
        %read data from txt files
        filename0hrs = 'D17-10078_FinalNormalizedDGE2.txt';
        filename24hrs = 'D17-10079_FinalNormalizedDGE2.txt';
        filename48hrs = 'D17-10080_FinalNormalizedDGE2.txt';
        filenamecell = {filename0hrs,filename24hrs,filename48hrs};
        [namesclean,countsclean,nanogind] = loadcleanmRNA(filenamecell);
        save('mRNAdata.mat','namesclean','countsclean','filenamecell');
        
        %plot raw data histogram
        plot_counts(countsclean);
    end
end

%smallest number of datapoints in any of the datasets
mincounts = size(countsclean{3},2);

%run cross validation
[G0cv,paramscv0,Gtrain0] = networkCV(countsclean{1}, @(x)networkdeconv(x,mincounts,...
    '0 hrs',false), 0.2, 0.8, true);
save('mRNA_network_cv0.mat','C0cv','Gtrain0','paramscv0');
[G24cv,paramscv24,Gtrain24] = networkCV(countsclean{2}, @(x)networkdeconv(x,mincounts,...
    '24 hrs',false), 0.2, 0.8, true);
save('mRNA_network_cv24.mat','G24cv','Gtrain24','paramscv24');
[G48cv,paramscv48,Gtrain48] = networkCV(countsclean{3}, @(x)networkdeconv(x,mincounts,...
    '48 hrs',false), 0.2, 0.8, true);
save('mRNA_network_cv48.mat','G48cv','Gtrain48','paramscv48');

%construction network for each case and perform crossvalidation
[G0,corrmat0,params0] = networkdeconv(countsclean{1}, mincounts, '0 hrs', true);
[G24,corrmat24,params24] = networkdeconv(countsclean{2}, mincounts, '24 hrs', true);
[G48,corrmat48,params48] = networkdeconv(countsclean{3}, mincounts, '48 hrs', true);

%save outputs
fig2 = figure(2);
savefig(fig2,'eval_plt.fig','compact');
close(fig2);
fig3 = figure(3);
%savefig(fig3,'edgedist_plt.fig','compact');
close(fig3);
save('mRNAcorr_deconv_0hrs.mat','G0','corrmat0','params0','namesclean','countsclean')
save('mRNAcorr_deconv_24hrs.mat','G24','corrmat24','params24','namesclean')
save('mRNAcorr_deconv_48hrs.mat','G48','corrmat48','params48','namesclean')

%compare networks
gdiff0_24 = norm(G0 - G24,'fro')^2;
gdiff24_48 = norm(G24 - G48,'fro')^2;
gdiff0_48 = norm(G0 - G48,'fro')^2;

