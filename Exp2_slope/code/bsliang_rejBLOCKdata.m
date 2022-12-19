function DDATA=bsliang_rejBLOCKdata(TDATA,rej_ind)
% block水平删数据
    EMPTY.rawdata=[];
    EMPTY.half_threshold=[];
    EMPTY.threshold_boundaries=[];
    for i=1:size(rej_ind,1)
        % rej_ind → ROW1: subj, ROW2: condition, ROW3: turn
        block_rej=rej_ind(i,2);
        turn_rej=rej_ind(i,3);
        subj_rej=rej_ind(i,1);
        TDATA{block_rej,turn_rej,subj_rej}=EMPTY;
    end
    DDATA=TDATA;
end