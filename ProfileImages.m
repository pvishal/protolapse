function [smoothLuminance, inLuminance, fnames]  = ProfileImages(infolder)

assert(nargout == 3, 'Need 3 output arguments');
   

%% List files
matchString = '*.jpg';

dirList  = dir(fullfile(infolder , matchString));
imageCount = numel(dirList);

inLuminance = zeros(imageCount,1);
fnames = cell(imageCount,1);

readfile = @(dir, f) imread(fullfile(dir, f));
eta = ETA(tic, imageCount);
for f=1:imageCount
    fnames{f} = dirList(f).name;
    img = double(readfile(infolder , fnames{f}));
    inLuminance(f) = CalcLuminosity(img);
    
    eta.update(); eta.print();
end

fHandle = figure;
plot(inLuminance,'bo-'); hold on; grid on;

smoothLuminance = SmoothenLuminosity(inLuminance, fHandle);

end



