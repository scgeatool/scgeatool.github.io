I=imread('aaa846wx501h - Copy (2) - Copy.jpg');
imshow(I)
file='aaa846wx501h - Copy (2) - Copy.jpg';
base64string = base64file(file);


s1='<svg fill="none" height="287" viewBox="0 0 846 287" width="846" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><pattern id="a" height="1" patternContentUnits="objectBoundingBox" width="1"><image height="501" transform="scale(.00118203 .00199601)" width="846" xlink:href="data:image/jpeg;base64,';

s2='"/></pattern><rect fill="url(#a)" height="501" rx="12" width="846"/></svg>';
fid=fopen('hero-image2.svg','w');
fprintf(fid,'%s\n%s\n%s',s1,base64string,s2);
fclose(fid);
