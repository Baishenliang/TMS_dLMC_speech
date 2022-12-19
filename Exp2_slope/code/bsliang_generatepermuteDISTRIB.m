function perDISRIB=bsliang_generatepermuteDISTRIB(inmat,LT_ind,Npermute)

    perDISRIB=nan(4,4,2,Npermute); % 4*block, 4*turn, 2*LT_ind, Npermute
    % inmat:  block(4)*turn(5)*subj(197)
    % turn£º Left iTBS   Left cTBS   Right iTBS   Right cTBS  Sham
    % block£ºT_CLEAR_ID  P_CLEAR_ID  T_NOISE_ID  P_NOISE_ID
    
    % permute inmat
     wb=waitbar(0,'permuting');
    for nper=1:Npermute
         wb=waitbar(nper/Npermute,wb,'permuting');
        for turn = 1:4
            
            inmatp=inmat; % do permitation
            for subj=1:size(inmatp,3) % for each subj
                for block=1:4
                    TMP_ind=[turn 5];
                    TEM_PER=inmatp(block,TMP_ind(randperm(2)),subj);
                    inmatp(block,TMP_ind,subj)=TEM_PER;
                end
            end
            
            inmatp_contrast=inmatp(:,turn,:)-inmatp(:,5,:); % store results
            for block=1:4
                for LT=1:2
                    perDISRIB(block,turn,LT,nper)=mean(squeeze(inmatp_contrast(block,1,LT_ind==LT)),'omitnan');
                end
            end
            
        end
    end
     close(wb)

