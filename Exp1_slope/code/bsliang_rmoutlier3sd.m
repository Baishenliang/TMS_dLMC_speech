function [outdata,errind]=bsliang_rmoutlier3sd(indata)
    % indata is a list
   c_extrm=10;
   c=2.5;
   
   %% 排除特别极端的值
   errind=[];
    while 1
       finished_minextreme=0;
       finished_maxextreme=0;
         
       indata_rm_min=indata(indata>min(indata));
       m_rm_min=mean(indata_rm_min,'omitnan');
       s_rm_min=std(indata_rm_min,'omitnan');
       indata_rm_max=indata(indata<max(indata));
       m_rm_max=mean(indata_rm_max,'omitnan');
       s_rm_max=std(indata_rm_max,'omitnan');
   
   % 排除极端最小值
       if min(indata) <= m_rm_min-s_rm_min*c_extrm
           errind=[errind,'extrem detected, <',num2str(c_extrm),'SD '];
           indata(indata==min(indata))=nan;
       else
            finished_minextreme=1;
       end

       % 排除极端最大值
       if max(indata) >= m_rm_max+s_rm_max*c_extrm
           errind=[errind,'extrem detected, >',num2str(c_extrm),'SD'];
           indata(indata==max(indata))=nan;
       else
            finished_maxextreme=1;
       end
       
       if finished_minextreme*finished_maxextreme==1
           break;
       end
   end
   
   %% 以c个标准差为阈值排除值
   maxindex=indata>=(mean(indata,'omitnan')+c*std(indata,'omitnan'));
   minindex=indata<=(mean(indata,'omitnan')-c*std(indata,'omitnan'));
   outindex=logical(maxindex+minindex);
   indata(outindex)=nan;
   outdata=indata;
end