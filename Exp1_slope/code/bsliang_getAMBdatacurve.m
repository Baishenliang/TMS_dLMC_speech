function [outrawdata,curve]=bsliang_getAMBdatacurve(AMB,rawdata)

%     AMBIGUOUS: AMB=3;
%     UNAMBIGUOUS; AMB=[1 5];
%     HALFAMBIGUOUS; AMB=[2 4];
    
    amb_seq=rawdata(:,4);
    inds=zeros(length(AMB),length(amb_seq));
    for amb_ind=1:length(AMB)
        inds(amb_ind,:)=amb_seq==AMB(amb_ind);
    end
    inds_comb=sum(inds,1);
    inds_comb=logical(inds_comb);
    
    outrawdata=rawdata(inds_comb,:);
    
    rawsteps=unique(outrawdata(:,1));
    curve=zeros(1,length(rawsteps));
    for step=rawsteps'
        outrawdata_step=outrawdata(outrawdata(:,1)==step,:);
        curve(step)=mean(outrawdata_step(:,2));
    end
    
end