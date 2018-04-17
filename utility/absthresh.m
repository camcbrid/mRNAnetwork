function Gout = absthresh(G, thresh)
%set all values with absolute value below thresh to 0 and convert remaining
%values to +/-1's

thresh = abs(thresh);

Gout = sparse(G);
Gout(abs(G) < thresh) = 0;
Gout = sign(Gout);
