function copyDepsWithStructure(mainFile, sourceRoot, destRoot)

if nargin < 1, mainFile = 'scgeatoolApp.mlapp'; end
if nargin < 2, sourceRoot = 'D:\GitHub\scGEAToolbox_dev'; end
if nargin < 3, destRoot = 'D:\GitHub\scGEAToolbox_prj\toolbox'; end

addpath(sourceRoot);
% copyDepsWithStructure('scgeatoolApp.mlapp', 'D:\GitHub\scGEAToolbox', 'D:\GitHub\scGEAToolbox_prj\toolbox');
% copyDepsWithStructure('myFunction.m', 'C:\MyProject', 'C:\MyProject_deps');

    [fList, ~] = matlab.codetools.requiredFilesAndProducts(mainFile);
    for i = 1:numel(fList)
        src = fList{i};
        if ~startsWith(src, sourceRoot), continue; end
        assert(startsWith(src, sourceRoot), ...
            'File %s is outside source root %s', src, sourceRoot);
        rel = src(length(sourceRoot)+2:end); % +2 to skip filesep
        dest = fullfile(destRoot, rel);
        ddir = fileparts(dest);
        if ~exist(ddir, 'dir')
            mkdir(ddir);
        end
        copyfile(src, dest);
        % fprintf('copyfile(%s, %s);\n', src, dest);
    end
    disp('dependencies copy is done.')

    dlist = ["doc", "assets", "external", "docs"];
    copyDirectories(dlist, sourceRoot, destRoot);
    disp('doc assets external docs are done.')

    exampleDataFolder = fullfile(destRoot, 'example_data');
    if ~exist(exampleDataFolder, 'dir')
        mkdir(exampleDataFolder);
    end    
    flist = ["example_data\new_example_sce.mat", "info.xml", "DesktopToolset.xml", "online_landing.m"];
    copyFiles(flist, sourceRoot, destRoot);
    disp('example_data is done.')


    sourceFolder1 = "C:\ProgramData\MATLAB\SupportPackages\R2025a\toolbox\matlab\quantum\";
    sourceFolder = fileparts(fileparts(which('hGate')));
        assert(isfolder(sourceFolder))
        assert(isequal(sourceFolder1, [sourceFolder,'\']))
    destinationFolder = fullfile(destRoot, 'external','quantum');
    [status, msg, msgID] = copyfile(sourceFolder, destinationFolder, 'f');
    assert(status == 1, ...
        'Failed to copy folder "%s" to "%s": %s (ID: %s)', ...
        sourceFolder, destinationFolder, msg, msgID);
    disp('quantum is done.')

    
    updateContents('scGEAToolbox_prj\toolbox\');
    updateContents('scGEAToolbox_dev');
    disp('Content.m is done.')
    
    rmpath(sourceRoot);

    pfiles = ["ml_geneagent.m"];
    for pk = 1:length(pfiles)
        currentf = fullfile(destRoot,"+run",pfiles(pk));
        pcode(currentf,'-inplace');
        movefile(currentf, tempdir);
    end
    disp('pcode is done.')
end


function copyFiles(flist, s, d)
    for k = 1:length(flist)
        infile = fullfile(s, flist(k));
        assert(isfile(infile))
        oufile = fullfile(d, flist(k));            
        copyfile(infile, oufile, 'f');
        assert(isfile(oufile))
    end
end

function copyDirectories(dlist, s, d)
    for k = 1:length(dlist)
        infold = fullfile(s, dlist(k));
        oufold = fullfile(d, dlist(k));
        assert(isfolder(infold))
        [status, msg, msgID] = copyfile(infold, oufold, 'f');
        assert(status == 1, ...
            'Failed to copy folder "%s" to "%s": %s (ID: %s)', ...
            infold, oufold, msg, msgID);
        assert(isfolder(oufold))
    end
end


function updateContents(foldername)
    a=pwd;
    cd(foldername);
    % cd scGEAToolbox_prj\toolbox\
    % cd scGEAToolbox
    version = pkg.i_get_versionnum;
    d = dir('*.m');
    d(strcmp({d.name}, 'Contents.m')) = [];
    fid = fopen('Contents.m','w');
    fprintf(fid, '%% scGEAToolbox - Single-Cell Gene Expression Analysis Toolbox\n');
    fprintf(fid, '%% Version %s %s\n', version, datestr(now, 'dd-mmm-yyyy'));
    fprintf(fid, '%%\n%% Functions\n');
    for k = 1:numel(d)
        fname = d(k).name;
        h = help(fname(1:end-2));
        hline = regexp(h, '\n', 'split');
        first = strtrim(hline{1});
        fprintf(fid, '%%   %-25s - %s\n', fname(1:end-2), first);
    end
    fclose(fid);
    cd(a);
end
