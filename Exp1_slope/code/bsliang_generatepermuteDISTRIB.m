function perDISRIB=bsliang_generatepermuteDISTRIB(inmat,LR_ind,Npermute)

    perDISRIB=nan(4,2,2,Npermute); % 4*block, 2*turn, 2*LR_ind, Npermute
    % inmat:  block(4)*turn(3)*subj(197)
    
    % permute inmat
    wb=waitbar(0,'permuting');
    for nper=1:Npermute
        wb=waitbar(nper/Npermute,wb,'permuting');
        for turn = 1:2
            
            inmatp=inmat; % do permitation
            for subj=1:size(inmatp,3) % for each subj
                for block=1:4
                    TMP_ind=[turn 3];
                    TEM_PER=inmatp(block,TMP_ind(randperm(2)),subj);
                    inmatp(block,TMP_ind,subj)=TEM_PER;
                end
            end
            
            inmatp_contrast=inmatp(:,turn,:)-inmatp(:,3,:); % store results
            for block=1:4
                for LR=1:2
                    perDISRIB(block,turn,LR,nper)=mean(squeeze(inmatp_contrast(block,1,LR_ind==LR)),'omitnan');
                end
            end
            
        end
    end
    close(wb)

