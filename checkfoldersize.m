function checkfoldersize
oldf = pwd;
mfolder = fileparts(mfilename('fullpath'));
cd(mfolder);
D = dir('toolbox/**/*');  % recursively list all files

% remove '.' and '..'
D = D(~ismember({D.name},{'.','..'}));

% exclude anything with ".git" in the path
% D = D(~contains({D.folder}, '.git'));
D = D(~strcmp({D.name}, '.git') & ~contains({D.folder}, '.git'));

totalBytes = sum([D(~[D.isdir]).bytes]);
bytesToReadable(totalBytes)
cd(oldf);

function sizeStr = bytesToReadable(bytes)
    units = {'B','KB','MB','GB','TB'};
    scale = 1024;
    idx = 1;
    while bytes >= scale && idx < numel(units)
        bytes = bytes / scale;
        idx = idx + 1;
    end
    sizeStr = sprintf('%.2f %s', bytes, units{idx});
end
fprintf('last time Total folder size: %s\n', '445.52 MB');
end