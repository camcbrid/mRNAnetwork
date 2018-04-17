function [Gcv,params,Gtrain] = networkCV(data, func, p, q, parallelon)
%run cross vaildation on network construction function. Data is matrix with
%datapoints in each column and variables in each row. func is the function
%handle of the graph construction function. p is the percentage of the
%dataset to hold for test data. q is the precentage of output graphs a
%edge needs to appear in to be considered true

%defaults
if nargin < 5
    parallelon = false;
    if nargin < 4
        q = 0.8;
        if nargin < 3
            p = .2;
        end
    end
end

%error correction
if p > 1; p = 1;
elseif p < 0; p = .1;
end
if q > 1; q = 1;
elseif q < 0; q = 0.1;
end

%init
Gtrain = cell(0);
% Gtest = cell(0);

if parallelon
    pool  = parpool(3);
    parfor ii = 1:round(1/p)
        %split data into k pieces
        [traininds, ~] = crossvalind('HoldOut', min(size(data)), p);
        
        %run network construction function on data
        Gtrain{ii} = sparse(func(data(:,traininds)));
        %Gtest{ii} = sparse(func(data(:,testinds)));
    end
    delete(pool);
    pause(5);
else
    for ii = 1:round(1/p)
        %split data into k pieces
        [traininds, ~] = crossvalind('HoldOut', min(size(data)), p);
        
        %run network construction function on data
        Gtrain{ii} = sparse(func(data(:,traininds)));
        %Gtest{ii} = sparse(func(data(:,testinds)));
    end
end

%if an edge appears in q% of the graphs, the edge is true
%Gcv = absthresh(sum(cat(3,Gtrain{:}),3), q*length(Gtrain));

Gtmp = zeros(size(Gtrain{1}));
for ii = 1:length(Gtrain)
    Gtmp = Gtmp + Gtrain{ii};
end
Gcv = sparse(absthresh(Gtmp,q*length(Gtrain)));

%parameters used to run
params = struct;
params.p = p;
params.q = q;
params.func = func;
