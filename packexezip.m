targetfolder = 'SCGEATOOL_StandaloneApplication';
if ~isfolder(targetfolder)
    mkdir(targetfolder);
end
copyfile("StandaloneDesktopApp1\output\build\", targetfolder);
cd(targetfolder);
zip('SCGEATOOL_StandaloneApplication.zip', '*.*');
movefile('SCGEATOOL_StandaloneApplication.zip','..\');
cd ..
