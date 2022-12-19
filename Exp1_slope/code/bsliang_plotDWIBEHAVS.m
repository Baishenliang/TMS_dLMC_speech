load(['..',filesep,'data',filesep,'DWIBEHAV']);
load(['..',filesep,'data',filesep,'DWIBEHAV_RAW']);
for row=2:size(CRcell,1)
    if CRcell{row,10}==1
        % p <.01 *sig
        X=CORR_RAW.(CRcell{row,1}).(CRcell{row,2}).(CRcell{row,3}).(CRcell{row,4}).(CRcell{row,5}).DWI;
        Y=CORR_RAW.(CRcell{row,1}).(CRcell{row,2}).(CRcell{row,3}).(CRcell{row,4}).(CRcell{row,5}).(CRcell{row,6});
        figure;
        plot(X,Y,'*');
        hold on
        plot([min(X),max(X)],[0 0],'r--');
        box off
        title([CRcell{row,1},' ',CRcell{row,2},' ',CRcell{row,3},' ',CRcell{row,4},' ',CRcell{row,5},' ',CRcell{row,6}])
    end
end