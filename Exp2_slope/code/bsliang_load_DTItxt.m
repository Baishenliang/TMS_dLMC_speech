function dataout=bsliang_load_DTItxt(filename)
    fileID = fopen(filename,'r');
    formatSpec = '%s ';
    A = textscan(fileID,formatSpec);
    dataout_raw=str2double(A{1,1});
    dataout=dataout_raw(~isnan(dataout_raw));
    fclose(fileID);