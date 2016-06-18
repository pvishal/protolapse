function luminosity = CalcLuminosity(img)

lumImg = 0.27*img(:,:,1) + 0.67*img(:,:,2) + 0.06*img(:,:,3);
lumImg(lumImg<10) = 10;
lumImg = log(lumImg);
luminosity = mean(lumImg(:));

end