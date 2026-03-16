% cd 'C:\Users\sks\Desktop'
% 
% system('if not exist prakash1 mkdir prakash1')


% function mkdir_if_not_exist(dirpath)
function psb_mkdir_if_not_exist(dirpath)
% dirpath = 'C:\Users\sks\Desktop\sks7';
    if dirpath(end) ~= '\', dirpath = [dirpath '\']; end
    if (exist(dirpath, 'dir') == 0), mkdir(dirpath); end
end