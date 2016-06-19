function smoothed = SmoothLowess(inScatter, factor)

degree = 1;
assert((factor >= 0) && (factor <= 1), 'Factor should be between 0 and 1');

dataCount = numel(inScatter);
hBandwidth = floor(factor*dataCount)/2;
xpoints   = 1:dataCount;
smoothed = zeros(size(dataCount));

% Find a neighbourhood of 'bandwidth' around x0. xmin to xmax
%smoothed = arrayfun(@(x) SinglePointRun(inScatter, hBandwidth, degree, dataCount, x), ...
%    xpoints);
for xo = xpoints
    smoothed(xo) = ...
        SinglePointRun(inScatter, hBandwidth, degree, dataCount, xo);
end

end

function yhat = SinglePointRun(inScatter, hBandwidth, degree, dataCount, xo)
    xmin = max(floor(xo-hBandwidth), 1);
    xmax = min( ceil(xo+hBandwidth), dataCount);
    Nx = xmin:xmax;
    Ny = inScatter(xmin:xmax);
    
    % For the points in the neighbourhood, find the distance and
    % the weights
    dist = abs(Nx-xo)/hBandwidth;
    weights = (1 - dist.^3).^3;
    poly = Regress(Nx, Ny, weights, degree);
    yhat = polyval(poly, xo);    
end

function poly = Regress(x,y,w,degree)
n = length(x);
x = x(:);
y = y(:);
w = w(:);
% get matrices
W = spdiags(w,0,n,n);
A = vander(x);
A(:,1:length(x)-degree-1) = [];
V = A'*W*A;
Y = A'*W*y;
[Q,R] = qr(V,0); 
p = R\(Q'*Y); 
poly = p';		% to fit MATLAB convention
end
