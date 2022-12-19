function [outdata]=bsliang_rmoutlier3sd_rawsham(indata)
    % indata is a list
   c=3;
   
   %% 以c个标准差为阈值排除值
   maxindex=indata>=(mean(indata,'omitnan')+c*std(indata,'omitnan'));
   minindex=indata<=(mean(indata,'omitnan')-c*std(indata,'omitnan'));
   outindex=logical(maxindex+minindex);
   indata(outindex)=nan;
   outdata=indata;
end