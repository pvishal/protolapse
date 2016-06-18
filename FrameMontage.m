function montageList = framemontage(folderLeft, folderRight, output)

if nargout > 0
    remember = true;
else
    remember = false;
end

%% List files
matchString = '*.jpg';

dirLeft  = dir(fullfile(folderLeft , matchString));
dirRight = dir(fullfile(folderRight, matchString));
assert(numel(dirLeft)==numel(dirRight), ...
    'Number of images in both the folders must be the same');

fileCount = numel(dirLeft);
if remember
    montageList = cell(fileCount, 1);
end

readfile = @(dir, f) imread(fullfile(dir, f));
savefile = @(img, name) imwrite(img, fullfile(output, name));
for f=1:fileCount
    imgL = readfile(folderLeft , dirLeft(f).name);
    imgR = readfile(folderRight, dirRight(f).name);
    if f==1
        imsize = size(imgL);
        imgWidth = imsize(2);
        sepWidth = floor(imgWidth/1000);
        leftEnd = imgWidth/2 - sepWidth;
        rightStart = imgWidth/2 + sepWidth;
    end
    
    montage = doMontage(imgL, imgR, imsize, leftEnd, rightStart);
    if remember
        montageList{f} = montage;
    end
    savefile(montage, dirLeft(f).name);
    
    fprintf('%i\n', f);
end



end

function themontage = doMontage(imgl, imgr, imsize, leftEnd, rightStart)

themontage = repmat(uint8(0),imsize);
themontage(:,1:leftEnd,:) = imgl(:,1:leftEnd,:);
themontage(:,rightStart:end,:) = imgr(:,rightStart:end,:);

end
