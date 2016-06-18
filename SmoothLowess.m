% LOWESS-smoothing of equispaced data
% Input: List of y-values to be smoothed ("noisy") and bandwidth
% Output: List of smoothed y-values ("smoothy)
function [smoothy] = SmoothLowess(noisy, bandwidth)
    n = length(noisy);          % Number of y-values
    smoothy = zeros([1 n]);     % Empty array of length n to store result

    % For all points in "noisy", do a local linear weighted regression
    for i=1:n
        % Initialize temporary variables
        A = 0;
        B = 0;
        C = 0;
        D = 0;
        E = 0;

        % Calculate span of values to be included in the regression
        jmin = floor(i-bandwidth/2);
        jmax = ceil(i+bandwidth/2);
        if jmin < 1
            jmin = 1;
        end
        if jmax > n
           jmax = n; 
        end

        % For all the values in the span, compute the weight and then
        % the linear fit
        for j=jmin:jmax
            w = weight(i,j, bandwidth/2);
            x = j;
            y = noisy(j);

            A = A + w*x;
            B = B + w*y;
            C = C + w*x^2;
            D = D + w*x*y;
            E = E + w;
        end

        % Calculate a (slope) and b (offset) for the linear fit
        a = (A*B-D*E)/(A^2 - C*E);
        b = (A*D-B*C)/(A^2 - C*E);

        % Calculate the smoothed value by the formula y=a*x+b (x <- i)
        smoothy(i) = a*i+b;
    end

    return
end

% The tricube weight function
function w = weight(i,j,d)
    w = ( 1-abs((j-i)/d)^3)^3;
    if w < 0
        w = 0;
    end
    return
end