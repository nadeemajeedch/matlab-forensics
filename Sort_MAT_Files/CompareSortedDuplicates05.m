In_Base='/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/';
FolderIn='07/Tw';
NameSuffix='_Tw';

SortedOutDir=['/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/SortedOut/' FolderIn '/'];
mkdir(SortedOutDir);

Out_Base='/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/';
FolderOut='07 - Using noise inconsistencies for blind image forensics/';
Quality=75;
Rescale=false;

FinalOutputFolder=[Out_Base FolderOut num2str(Quality) '_' num2str(Rescale) '/'];

InList=dir([In_Base FolderIn '/*.mat']);

DuplicatesFolderBase='/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/Duplicates/';
DuplicatesDir=[DuplicatesFolderBase FolderIn '/'];
mkdir(DuplicatesDir);

for ii=1:length(InList)
    Loaded=load([In_Base FolderIn '/' InList(ii).name]);
    if strcmp(Loaded.Name(1:3),'D:\')
        Slashes=strfind(Loaded.Name,'\');
    else
        Slashes=strfind(Loaded.Name,'/');
    end
    Loaded.Name=strrep(Loaded.Name,'\','/');
    if ~isempty(Slashes)>0
        FinalSlash=Slashes(end);
        
        Dots=strfind(Loaded.Name,'.');
        FinalDot=Dots(end);
        
        OutBaseInd=strfind(Loaded.Name,'TwJPEG/')+7;
        
        SubFolderStructure=Loaded.Name(OutBaseInd:FinalSlash);
        if ~exist([FinalOutputFolder SubFolderStructure], 'dir')
            mkdir([FinalOutputFolder SubFolderStructure]);
        end
        
        
        PlainName=Loaded.Name(FinalSlash+1:FinalDot-1);
        PlainName=strrep(PlainName,NameSuffix,'');
        PlainName=[PlainName Loaded.Name(FinalDot:end)];
        
        
        BinMask=Loaded.BinMask;
        Name=[SubFolderStructure PlainName];
        Result=Loaded.Result;
        
        if ~exist([FinalOutputFolder SubFolderStructure PlainName '.mat'],'file')
            %save([FinalOutputFolder SubFolderStructure PlainName '.mat'], 'BinMask', 'Name', 'Result', 'Quality', 'Rescale', '-v7.3');
            %system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' SortedOutDir]);
            disp('unique!');
        else
            LExist=load([FinalOutputFolder SubFolderStructure PlainName '.mat']);
            
            if ~sum(sum(LExist.Result==Loaded.Result)) && ~sum(sum(LExist.Result{2,1}==Loaded.Result{2,1})) && ~sum(sum(LExist.Result{1,2}==Loaded.Result{1,2})) && ~sum(sum(LExist.Result{2,2}==Loaded.Result{2,2})) && ~sum(sum(LExist.Result{3,1}==Loaded.Result{3,1})) && ~sum(sum(LExist.Result{3,2}==Loaded.Result{3,2})) && ~sum(sum(LExist.Result{4,1}==Loaded.Result{4,1})) && ~sum(sum(LExist.Result{4,2}==Loaded.Result{4,2})) && ~sum(sum(LExist.Result{5,1}==Loaded.Result{5,1})) && ~sum(sum(LExist.Result{5,2}==Loaded.Result{5,2}))
                system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' DuplicatesDir]);
            else
                %system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' DuplicatesDir]);
                %system(['mv ' strrep(FinalOutputFolder,' ','\ ') SubFolderStructure PlainName '.mat' ' ' DuplicatesDir]);
                disp(['File not identical! ' FinalOutputFolder SubFolderStructure PlainName '.mat']);
            end
        end
        
    else
        disp(['No slashes! ' Loaded.Name]);
        system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' '/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/Unsorted/']);
    end
end