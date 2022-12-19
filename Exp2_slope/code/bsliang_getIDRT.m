function RTs=bsliang_getIDRT(rawdata)
    steps=unique(rawdata(:,1));
    RTs=nan(1,length(steps));
    for step=steps'
        rttmp=rawdata(rawdata(:,1)==step,3);
        rttmp(rttmp>1.5)=nan;
        rttmp(rttmp<0.2)=nan;
        RTs(step)=mean(rttmp,'omitnan');
    end