function smoothCurve = SmoothLowPass(factor, curve)

assert(factor <= 1, 'Factor should be less than or equal to 1');

smoothCurve = zeros(size(curve));
smoothCurve(1) = curve(1);
for i = 2:numel(curve)
    smoothCurve(i) = factor*curve(i) + (1-factor)*smoothCurve(i-1);
end

end