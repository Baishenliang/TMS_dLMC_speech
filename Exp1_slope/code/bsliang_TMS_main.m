function bsliang_TMS_main(ambtag,is_getshamrepvals)
%     clear all
%     close all
    
%     ambtag='ambiguous';
    
    if isequal(ambtag,'unambiguous')
        AMB=[1 5];
    elseif isequal(ambtag,'halfambiguous')
        AMB=[2 4];
    elseif isequal(ambtag,'ambiguous')
        AMB=3;
    end
    
%     is_getshamrepvals=0;
    % 1- delete values in sham with slope<0, PSE<1 or PSE>5, and extract
    %    exp(mean-2sd) as values to replace the deleted values (only for TMS conditions)
    % 0- directly start fitting
    if ~is_getshamrepvals
         load(['..',filesep,'data',filesep,'repvals_',num2str(AMB)]);
    end
    
    addpath('global');
    
    IDsteps=5;
    rTMSversion='2020'; %2020: online triple-pulse rTMS 2020
    is_logSlope=1; % 1: log transform ID slopes, 0: do not log transform
    
     if is_logSlope
        logSlpTag=[];
     elseif ~is_logSlope
        logSlpTag='noLog';
     end
    
    load(['..',filesep,'data',filesep,'DATA']);% load data
    
    % get index of left or right hemisphere stimulation£º  
    LR_ind=zeros(1,size(DATA,2));
    for subj=1:size(DATA,2)
        LRc=bsliang_gainORDERnum(subj);
        if ~isempty(LRc) && LRc <=24
            LR_ind(subj)=1;
        end
        if ~isempty(LRc) && LRc >24
            LR_ind(subj)=2;
        end
    end
    
    % DATA structure:
    % turn: L T S (rTMS 2020)
    % block: 
    %   Id_Di	BLOCK	NAME        NUMBER
    %   Id      A       T_CLEAR_ID      1
    %   Id      B       P_CLEAR_ID      2
    %   Id      C       T_NOISE_ID      3
    %   Id      D       P_NOISE_ID      4
    
    %% preprocessing 1£ºdelecting subjects
    rej_INDind=[1 9 56 114 121 6 10 55 59 70]; % These subjects were not included in the current experiment
    DATA=bsliang_rejINDdata(DATA,rej_INDind);
    
    %% preprocessing 2£ºtransforming dataset
    TDATA=bsliang_Trandata(DATA); % TDATA: a cell in block *turn *subj(XX)
    
    bsliang_saveDDMform(TDATA,LR_ind,['..',filesep,'data',filesep,'exp1_DDM.csv']); % save as DDM format
    
    %% Fitting curves and getting identification slope
    
     fixed_asymptote=1; % fixing asymptote?
     % 0-no, do free fitting; 1-yes, use group parameters as asymptotes
    
     disp('Now processing ID Slope');
     %setting initial values£º
     IDfit_begnpara=[0 1 (1-0)/(IDsteps-1) (1+IDsteps)/2];
     if fixed_asymptote
        indIDfit_begnpara=IDfit_begnpara([3 4]);
     else
        indIDfit_begnpara=IDfit_begnpara([3 4 2 1]);
     end
     % paras£º 1-lower bound£¬2-upper bound£¬3-slope£¬4-PSE
     
     % ===================================================================
     % step1£ºgain average curves for each condition and do free fitting to
     %        get upper or lower bounds 
     % ===================================================================
     IDraw_G=nan(IDsteps,4,size(TDATA,2),size(TDATA,3));
     % step(5)*block(4)*turn(3)*subj(197)
     for block=1:4
         for turn=1:size(TDATA,2)
             for subj=1:size(TDATA,3)
                 if ~isempty(TDATA{block,turn,subj}.half_threshold)
                     [outrawdata_tmp,curve_tmp]=bsliang_getAMBdatacurve(AMB, TDATA{block,turn,subj}.rawdata);
                     TDATA{block,turn,subj}.rawdata = outrawdata_tmp;
                     TDATA{block,turn,subj}.half_threshold(:,end) = curve_tmp';
                     IDraw_G(:,block,turn,subj)=TDATA{block,turn,subj}.half_threshold(:,end);
                 end
             end
         end
     end
     rawIDsteps=size(outrawdata_tmp,1); 
 
     IDraw_G_M=nan(IDsteps,4,size(TDATA,2),2);
     % step(5)*block(4)*turn(3)*LeftRight(2)
     IDraw_G_M(:,:,:,1)=mean(IDraw_G(:,:,:,LR_ind==1),4,'omitnan'); % Left
     IDraw_G_M(:,:,:,2)=mean(IDraw_G(:,:,:,LR_ind==2),4,'omitnan'); % Right
     IDraw_G_M=1-IDraw_G_M; %shifting curve
     %step(5)*block(4)*turn(3)
     % get upper or lower bounds
     IDdbs=nan(4,size(TDATA,2),2); %lower bounds
     IDubs=IDdbs;%upper bounds
     % block(4)*turn(3)*LeftRight(2)
     LR_IDbs=1:2;
     
     for block=1:4
         for turn=1:size(TDATA,2)
             for LR=LR_IDbs
                 paras = lsqcurvefit(@(paras,X) paras(1)+(paras(2)-paras(1))./(1+exp(-1*paras(3)*(X-paras(4)))),IDfit_begnpara,1:IDsteps,IDraw_G_M(:,block,turn,LR)');
                 % paras£º 1-lower bound£¬2-upper bound£¬3-slope£¬4-PSE
                 IDdbs(block,turn,LR)=paras(1); % lower bound
                 IDubs(block,turn,LR)=paras(2); % upper bound
             end
         end
     end
     
     IDdbs_subjs=nan(4,size(TDATA,2),size(TDATA,3)); 
     % block(4)*turn(3)*subjects
     IDubs_subjs=IDdbs_subjs; 
     % appending lower and upper bounds to each condition
     for block=1:4
         for turn=1:size(TDATA,2)
             for subj=1:size(TDATA,3)
                 if ~isempty(TDATA{block,turn,subj}.half_threshold)
                     IDdbs_subjs(block,turn,subj)=IDdbs(block,turn,LR_ind(subj));
                     IDubs_subjs(block,turn,subj)=IDubs(block,turn,LR_ind(subj));
                 end
             end
         end
     end
     
     
     % ===================================================
     % step2: fitting individual curves and get slopes
     % ===================================================    
     IDraw_step=nan(rawIDsteps,4,size(TDATA,2),size(TDATA,3));
     IDraw_resp=nan(rawIDsteps,4,size(TDATA,2),size(TDATA,3));
     % trial(156)*block(4)*turn(3)*subj(197)
     for block=1:4
         for turn=1:size(TDATA,2)
             for subj=1:size(TDATA,3)
                 if ~isempty(TDATA{block,turn,subj}.rawdata)
                     IDraw_step(:,block,turn,subj)=TDATA{block,turn,subj}.rawdata(:,1);
                     IDraw_resp(:,block,turn,subj)=TDATA{block,turn,subj}.rawdata(:,2);
                 end
             end
         end
     end
     IDraw_resp=1-IDraw_resp; 
     IDslop=nan(4,size(TDATA,2),size(TDATA,3)); 
     IDslop_mask=IDslop; 
     % block(TC PC TN PN)*turn(L T S)*subj(197)
     for block=1:4
         for turn=1:size(TDATA,2)
             IDdbs_bt_subjs=squeeze(IDdbs_subjs(block,turn,:));
             IDubs_bt_subjs=squeeze(IDubs_subjs(block,turn,:));
             IDslop_bt=nan(1,size(TDATA,3));
             IDslop_bt_mask=zeros(1,size(TDATA,3));
             for subj=1:size(TDATA,3)
                 if ~isempty(TDATA{block,turn,subj}.rawdata)
                     disp(['Now fitting subj: ',num2str(subj)]);
                     IDdbs_bt=IDdbs_bt_subjs(subj);
                     IDubs_bt=IDubs_bt_subjs(subj);
                     if fixed_asymptote
                         fitfun=@(paras,X) (IDubs_bt-IDdbs_bt)*(0+1./(1+exp(-1*paras(1)*(X-paras(2)))))+IDdbs_bt;
                     elseif ~fixed_asymptote
                         fitfun=@(paras,X) (paras(3)-paras(4))*(0+1./(1+exp(-1*paras(1)*(X-paras(2)))))+paras(4);
                     end
                     
                     paras = lsqcurvefit(fitfun,indIDfit_begnpara,IDraw_step(:,block,turn,subj),IDraw_resp(:,block,turn,subj));

                     if is_getshamrepvals
                        if paras(1)>0 && paras(2)>=1 && paras(2)<=5
                            IDslop_bt(subj)=paras(1); 
                            IDPSE_bt(subj)=paras(2); 
                        end
                     else
                         if paras(1)>0 && paras(2)>=1 && paras(2)<=5
                            IDslop_bt(subj)=paras(1); 
                            IDPSE_bt(subj)=paras(2); 
                         elseif paras(1)<=0 || paras(2)<1 || paras(2)>5
                              if turn == 3
                                  IDslop_bt(subj)=nan;
                              else
                                  IDslop_bt_mask(subj)=1;
                                  if block == 1     
                                      %   T_CLEAR_ID CST: 
                                      IDslop_bt(subj)=S_CT_repval;
                                  elseif block == 2
                                      %   P_CLEAR_ID CSP: 
                                      IDslop_bt(subj)=S_CP_repval;
                                  elseif block == 3
                                      %   T_NOISE_ID NST: 
                                      IDslop_bt(subj)=S_NT_repval;
                                  elseif block == 4 
                                      %   P_NOISE_ID NSP: 
                                      IDslop_bt(subj)=S_NP_repval;
                                  end
                              end
                             disp(['&&&subj = ',num2str(subj),' block = ',num2str(block),'turn = ',num2str(turn),'LR = ',num2str(LR_ind(subj)), ' PSE outlier detected']);
                         end
                     end
                 end
             end
             IDslop(block,turn,:)=IDslop_bt;
             IDslop_mask(block,turn,:)=IDslop_bt_mask;
             IDPSE(block,turn,:)=IDPSE_bt;
         end
     end
     % log£º
     if is_logSlope
        IDslop_log=log(IDslop);
        IDPSE_log=IDPSE;
     elseif ~is_logSlope
        IDslop_log=IDslop;
        IDPSE_log=IDPSE;
     end
     
     spss_Tag='2020';
    
     % ID slope 

     [IDslope_NORM_SPSS,IDslope_NORM]=bsliang_norm_lr_out(TDATA,IDslop_log,LR_ind,['IDslope_NORM_',spss_Tag,'_',logSlpTag],0,0); % £¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡
     [IDslope_mask_NORM_SPSS,~]=bsliang_norm_lr_out(TDATA,IDslop_mask,LR_ind,['IDslope_CONTRAST_mask','_',logSlpTag],0,0); % no abs, no norm
     [IDslope_RAW_SPSS,IDslope_RAW]=bsliang_tmssham_lr_out(TDATA,IDslop_log,LR_ind,['IDslope_RAW_',spss_Tag,'_',ambtag],0);
     if is_getshamrepvals
        bsliang_processrawsham(IDslope_RAW_SPSS,AMB)
     else     
     
     % do permutation
     perDISRIB_IDslop_log=bsliang_generatepermuteDISTRIB(IDslop_log,LR_ind,100000);
     % perDISRIB_IDslop_log: blocks(4)*turns(2)*LR(2)*Npermute
     % plotting
     [Pss_single,Pss_compare,~]=bsliang_CNLRplots_re(IDslope_NORM_SPSS,0,1,perDISRIB_IDslop_log,IDslope_mask_NORM_SPSS);
     % statistics
     Pss_single_rs=reshape(Pss_single',[],1);
     Pss_compare_rs=reshape(Pss_compare',[],1);
     Pss_output = [Pss_single_rs;Pss_compare_rs];
     [q_fdr_left] = mafdr( [Pss_single_rs([1 2 3 4 9 10 11 12]);Pss_compare_rs([1 2 5 6])],'BHFDR','true');
     [q_fdr_right] = mafdr( [Pss_single_rs([5 6 7 8 13 14 15 16]);Pss_compare_rs([3 4 7 8])],'BHFDR','true');
     q_fdr_output = [q_fdr_left([1 2 3 4]);q_fdr_right([1 2 3 4]);...
                     q_fdr_left([5 6 7 8]);q_fdr_right([5 6 7 8]);...
                     q_fdr_left([9 10]);q_fdr_right([9 10]);...
                     q_fdr_left([11 12]);q_fdr_right([11 12])];
     q_fdr_output
     end
     restoredefaultpath
end