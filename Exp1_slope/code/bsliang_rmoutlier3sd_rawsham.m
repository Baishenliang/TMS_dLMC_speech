function [outdata]=bsliang_rmoutlier3sd_rawsham(indata)
    % indata is a list
   c=3;
   
   %% ��c����׼��Ϊ��ֵ�ų�ֵ
   maxindex=indata>=(mean(indata,'omitnan')+c*std(indata,'omitnan'));
   minindex=indata<=(mean(indata,'omitnan')-c*std(indata,'omitnan'));
   outindex=logical(maxindex+minindex);
   indata(outindex)=nan;
   outdata=indata;
end