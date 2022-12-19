load(['..',filesep,'data',filesep,'DWIBEHAV']);
load(['..',filesep,'data',filesep,'DWIBEHAV_RAW']);
for row=2:size(CRcell,1)
    if CRcell{row,9}==1
        % p <.05 *sig
        X=CORR_RAW.(CRcell{row,1}).(CRcell{row,2}).(CRcell{row,3}).(CRcell{row,4}).(CRcell{row,5}).DWI;
        Y=CORR_RAW.(CRcell{row,1}).(CRcell{row,2}).(CRcell{row,3}).(CRcell{row,4}).(CRcell{row,5}).(CRcell{row,6});
        figure;
        plot(X,Y,'*');
        box off
        title([CRcell{row,1},' ',CRcell{row,2},' ',CRcell{row,3},' ',CRcell{row,4},' ',CRcell{row,5},' ',CRcell{row,6}])
    end
end