function outLum = ApplyCompensation(inFolder, fnames, compensation, outFolder)

imageCount = numel(fnames);
outLum = zeros(size(fnames));

readfile = @(dir, f) imread(fullfile(dir, f));
savefile = @(img, name) imwrite(img, fullfile(outFolder, name));
eta = ETA(tic, imageCount);
for f=1:imageCount
    img = double(readfile(inFolder , fnames{f}));
    imgComp = img.*exp(compensation(f));
    imgComp(imgComp > 255) = 255;
    %imgComp(imgComp < 0) = 0;
    
    outLum(f) = CalcLuminosity(imgComp);
    savefile(uint8(imgComp), fnames{f});
    
    
    eta.update(); eta.print();
end

end