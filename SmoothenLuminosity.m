function smoothLuminance = SmoothenLuminosity(inLuminance, fHandle)


%if nargin == 1
%    interactive = false;
%elseif nargin == 2
%    interactive = true;
%else
%    error('Wrong number of arguments');
%end

%smootheningMethods = {'lowpass', 'loess'};
%methodIdx = true;
method = 'lowpass';
factor = 0.5;

figure(fHandle);

smoothCurve = SmoothLowPass(factor, inLuminance);
sCurveHandle = plot(smoothCurve, 'r');
title(sprintf('%s, %d', method, factor));

inputChar='q';

% Warning: Clumsy code ahead
while(~strcmpi(inputChar,'d'))
    inputChar = sprintf('%c',getkey);
    
    if strcmpi(inputChar,'m');
        if strcmpi(method, 'lowpass')
            method = 'loess';
            factor = 6;
        elseif strcmpi(method, 'loess')
            method = 'lowpass';
            factor = 1;
        end
    elseif strcmpi(inputChar, 'a')
        if strcmpi(method, 'lowpass')
            factor = max(factor/2, 0);
        elseif strcmpi(method, 'loess')
            factor = min(factor*2, 50);
        end
    elseif strcmpi(inputChar, 's')
        if strcmpi(method, 'lowpass')
            factor = min(factor*2, 1);
        elseif strcmpi(method, 'loess')
            factor = max(factor/2, 0);
        end
    end
    
    if strcmpi(method, 'lowpass')
        delete(sCurveHandle);
        smoothCurve = SmoothLowPass(factor, inLuminance);
    elseif strcmpi(method, 'loess')
        delete(sCurveHandle);
        smoothCurve = SmoothLowess(inLuminance, factor);
    end
    
    sCurveHandle = plot(smoothCurve, 'r');
    title(sprintf('%s, %d', method, factor));
    
end

smoothLuminance = smoothCurve;

end



