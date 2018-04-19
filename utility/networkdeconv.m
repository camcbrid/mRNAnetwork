function [Gsparse,corrmat,params] = networkdeconv(dataclean, mincounts, datatag, ploton)
%run network deconvoution alogrithm 3: "Network deconvolution as a general
%method to distinguish direct dependencies in networks" Feizi Nature 2013.
%Algorithm takes ~40 mins for mRNA dataset with 12000 genes and 1500 cells.

if nargin < 2
    mincounts = min(size(dataclean));
    if nargin < 3
        datatag = '';
        if nargin < 4
            ploton = False;
        end
    end
end

disp(datatag)

%calculate correlation matrix with robust Spearman correlation metric
disp('calculating correlations...'); tic
[corrmat,~] = corr(dataclean','Type','Spearman'); %1644 sec
% corrthresh = corrmat;
% corrthresh(pmat > 0.05) = 0;
toc

%calculate evals with sparse eval decomposition
disp('calculating largest eigenvalues...'); tic
lambdainit = eigs(corrmat,6);
disp(lambdainit)
lambdaP = max(lambdainit);
toc

%scaling correlation matrix
beta = 0.45;    %needs to be < 0.5 so max(abs(eval(Gobs))) < 1
alpha = beta/((1-beta)*lambdaP);
Gobs = alpha*corrmat;

%use sparse eigenvalue decomposition to speed up process
%matrix has at most num_cells non-zero eigenvalues
disp('recalculating eigenvalues...'); tic
[V,D,flg] = eigs(Gobs,mincounts);    %1509 sec
if flg ~= 0
    disp('not all eigenvalues converged')
end
toc

%eliminate indirect edges through network deconvolution
disp('Deconvolving network...'); tic
Dnew = D./(D+1);
Gnew = V*Dnew/V;
Gnew(diag(ones(length(Gnew),1)) == 1) = 0;
Gsym = (Gnew + Gnew')/2;
Gsparse = sparse(sign(Gsym));
toc

%record parameters into struct
params = struct;
params.alpha = alpha;
params.beta = beta;
params.lambda = lambdaP;
params.evals = Dnew(diag(ones(size(Dnew,1))) ~= 0);

corrmat = setdiagzeros(corrmat);

if ploton
    %plot histogram of eigenvalues
    figure(2);
    subplot(121)
    histogram(D(D ~= 0),'BinMethod','Scott',...
        'DisplayStyle','stairs','Normalization','probability'); hold on
    set(gca,'yscale','log');
    title(['Eigenvalue distribution ',datatag])
    ylabel('probability mass')
    xlabel('eigenvalues')
    
    %scatter plot of ordered eigenvalues
    subplot(122)
    plot(D(D ~= 0),'.'); hold on
    title(['Eigenvalues ',datatag])
    ylabel('eigenvalues')
    xlabel('ordering')
    
    %plot histogram of edge weights
    figure(3);
    subplot(121);
    histogram(corrmat(corrmat ~= 0),'BinMethod','Scott',...
        'DisplayStyle','stairs','Normalization','probability'); hold on
    set(gca,'yscale','log');
    title(['correlation matrix ',datatag])
    ylabel('probability mass')
    xlabel('correlation')
    
    subplot(122);
    histogram(Gsym(Gsym ~= 0),'BinMethod','Scott',...
        'DisplayStyle','stairs','Normalization','probability'); hold on
    set(gca,'yscale','log');
    title(['edge distribution ',datatag])
    ylabel('probability mass')
    xlabel('edge weight')
end
