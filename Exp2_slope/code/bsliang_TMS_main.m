function bsliang_TMS_main(is_getshamrepvals)
tic

%     is_getshamrepvals=0;
    % 1- delete values in sham with slope<0, PSE<1 or PSE>5, and extract
    %    exp(mean-2sd) as values to replace the deleted values (only for TMS conditions)
    % 0- directly start fitting
    
if ~is_getshamrepvals
    load(['..',filesep,'data',filesep,'repvals']);
end

leave_out_sizes=1;
boots=1;
permutation_loops=1;

P=[]; VAL=[]; M=[];
save  ..\data\org_result P VAL M leave_out_sizes boots

%%
wb=waitbar(0,'working');
for leave_out_size_i=1:length(leave_out_sizes)
    for permutation_loop=1:permutation_loops
        for boot=1:boots
            %%
            wb=waitbar(((leave_out_size_i-1)*permutation_loops*boots+(permutation_loop-1)*boots+boot)/(length(leave_out_sizes)*permutation_loops*boots),wb,'working');

            addpath('global');

            IDsteps=5;
            rawIDsteps=78*2; % Number of trials in one block
            is_logSlope=1; % 1: log transform ID slopes, 0: do not log transform
            
             if is_logSlope
                logSlpTag=[];
             elseif ~is_logSlope
                logSlpTag='noLog';
             end

            load(['..',filesep,'data',filesep,'DATA']);% load data
            % Get valid index£º %TBS2021
            LT_ind=zeros(1,size(DATA,2));
            for subj=1:size(DATA,2)
                LTc=bsliang_gainORDERnum(subj);
                if ~isempty(LTc) && LTc <=24
                    LT_ind(subj)=1;
                end
                if ~isempty(LTc) && LTc >24
                    LT_ind(subj)=2;
                end
            end

            % DATA structure:

            %  turn£º
            %   stimSITE   NUMBER
            %   Left iTBS    1
            %   Left cTBS    2
            %   Right iTBS   3
            %   Right cTBS   4
            %   Sham         5 

            % block£º
            %   BLOCK	NAME        NUMBER
            %   A       T_CLEAR_ID      1
            %   B       P_CLEAR_ID      2
            %   C       T_NOISE_ID      3
            %   D       P_NOISE_ID      4


           %% preprocessing 1£ºdelecting subjects
            % 1£º testing subject, the first author
            % 215£ºremoved
            rej_INDind=[1 215]; 

            DATA=bsliang_selectINDdata(DATA,rej_INDind,'rej');
            
           %% preprocessing 2£ºtransforming dataset
            TDATA=bsliang_Trandata(DATA); % TDATA: a cell in block *turn *subj(XX)
            bsliang_saveDDMform(TDATA,LT_ind,['..',filesep,'data',filesep,'exp2_DDM.csv']); % save as DDM format

            %% Fitting curves and getting identification slope
             load  ..\data\org_result
             disp('Now processing ID Slope');
             IDfit_begnpara=[0 1 (1-0)/(IDsteps-1) (1+IDsteps)/2];
             indIDfit_begnpara=IDfit_begnpara([3 4]);
             % paras£º 1-lower bound£¬2-upper bound£¬3-slope£¬4-PSE

             % ===================================================
             % step1£ºgain average curves for each condition and do free fitting to
             %        get upper or lower bounds 
            % ===================================================
             IDraw_G=nan(IDsteps,4,size(TDATA,2),size(TDATA,3));
             % step(5)*block(4)*turn(3)*subjs
             for block=1:4
                 for turn=1:size(TDATA,2)
                     for subj=1:size(TDATA,3)
                         if ~isempty(TDATA{block,turn,subj}.half_threshold)
                             IDraw_G(:,block,turn,subj)=TDATA{block,turn,subj}.half_threshold(:,end);
                         end
                     end
                 end
             end

             % curvetype: 1, ID curve
             slopefitTag='IDslope';

             IDraw_G_M=nan(IDsteps,4,size(TDATA,2),2);
             % step(5)*block(4)*turn(3)*LarynxTongue(2)
             IDraw_G_M(:,:,:,1)=mean(IDraw_G(:,:,:,LT_ind==1),4,'omitnan');
             IDraw_G_M=1-IDraw_G_M; %shifting curve
             %step(5)*block(4)*turn(3)

             IDdbs=nan(4,size(TDATA,2),2); %lower bound
             IDubs=IDdbs;%upper bound
             % block(4)*turn(3)*LarynxTongue(2)
             for block=1:4
                 for turn=1:size(TDATA,2)
                     LT=1;
                     paras = lsqcurvefit(@(paras,X) paras(1)+(paras(2)-paras(1))./(1+exp(-1*paras(3)*(X-paras(4)))),IDfit_begnpara,1:IDsteps,IDraw_G_M(:,block,turn,LT)');
                     % paras£º 1-lower bound£¬2-upper bound£¬3-slope£¬4-PSE
                     IDdbs(block,turn,LT)=paras(1); % lower bound
                     IDubs(block,turn,LT)=paras(2); % upper bound
                 end
             end
             IDdbs_subjs=nan(4,size(TDATA,2),size(TDATA,3));
             % block(4)*turn(3)*subjects
             IDubs_subjs=IDdbs_subjs; 
             % appending lower and upper bounds to each condition
             for block=1:4
                 for turn=1:size(TDATA,2)
                     for subj=1:size(TDATA,3)
                         if ~isempty(TDATA{block,turn,subj}.half_threshold) && LT_ind(subj)==1
                             IDdbs_subjs(block,turn,subj)=IDdbs(block,turn,LT_ind(subj));
                             IDubs_subjs(block,turn,subj)=IDubs(block,turn,LT_ind(subj));
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
                         if ~isempty(TDATA{block,turn,subj}.rawdata) && LT_ind(subj)==1
                             disp(['Now fitting subj: ',num2str(subj)]);
                             IDdbs_bt=IDdbs_bt_subjs(subj);
                             IDubs_bt=IDubs_bt_subjs(subj);
                             fitfun=@(paras,X) (IDubs_bt-IDdbs_bt)*(0+1./(1+exp(-1*paras(1)*(X-paras(2)))))+IDdbs_bt
                             step_var=IDraw_step(:,block,turn,subj);
                             resp_var=IDraw_resp(:,block,turn,subj);
                             paras = lsqcurvefit(fitfun,indIDfit_begnpara,step_var,resp_var);
                             if is_getshamrepvals
                                if paras(1)>0 && paras(2)>=1 && paras(2)<=5
                                    IDslop_bt(subj)=paras(1); 
                                end
                             else
                                 if paras(1)>0 && paras(2)>=1 && paras(2)<=5
                                    IDslop_bt(subj)=paras(1); 
                                 elseif paras(1)<=0 || paras(2)<1 || paras(2)>5
                                      if turn == 5 % Sham
                                          IDslop_bt(subj)=nan;
                                      else
                                          IDslop_bt_mask(subj)=1;
                                          if block == 1     %   T_CLEAR_ID CST: 
                                              IDslop_bt(subj)=S_CT_repval;
                                          elseif block == 2   %   P_CLEAR_ID CSP: 
                                              IDslop_bt(subj)=S_CP_repval;
                                          elseif block == 3  %   T_NOISE_ID NST: 
                                              IDslop_bt(subj)=S_NT_repval;
                                          elseif block == 4  %   P_NOISE_ID NSP: 
                                              IDslop_bt(subj)=S_NP_repval;
                                          end
                                      end
                                     disp(['&&&subj = ',num2str(subj),' block = ',num2str(block),'turn = ',num2str(turn),'LT = ',num2str(LT_ind(subj)), ' PSE outlier detected']);
                                 end
                             end
                         end
                     end
                     IDslop(block,turn,:)=IDslop_bt;
                     IDslop_mask(block,turn,:)=IDslop_bt_mask;
                 end
             end
             % È¡log£º
             if is_logSlope
                IDslop_log=log(IDslop);
             elseif ~is_logSlope
                IDslop_log=IDslop;
             end

             % slope 
             % ====================== slope noabs norm =================
%                  [IDslope_NORM_SPSS,IDslope_NORM]=bsliang_norm_lr_out(TDATA,IDslop_log,LT_ind,[slopefitTag,'_CONTRAST','_',logSlpTag],0,0,1); % no abs, norm
%                  [P(leave_out_size_i,permutation_loop,boot).slp_norm,VAL(leave_out_size_i,permutation_loop,boot).slp_norm,M(leave_out_size_i,permutation_loop,boot).slp_norm]=bsliang_CNLRplots_re(IDslope_NORM_SPSS,0,1,1); % yes statistics
             % =========================================================

             % ====================== slope noabs nonorm =================
             [IDslope_NORM_SPSS,IDslope_NORM]=bsliang_norm_lr_out(TDATA,IDslop_log,LT_ind,[slopefitTag,'_CONTRAST','_',logSlpTag],0,0,0); % no abs, no norm
             [IDslope_mask_NORM_SPSS,~]=bsliang_norm_lr_out(TDATA,IDslop_mask,LT_ind,[slopefitTag,'_CONTRAST_mask','_',logSlpTag],0,0,0); % no abs, no norm
             [IDslope_RAW_SPSS,IDslope_RAW]=bsliang_tmssham_lr_out(TDATA,IDslop_log,LT_ind,[slopefitTag,'_RAW','_',logSlpTag],0);
             if is_getshamrepvals
                bsliang_processrawsham(IDslope_RAW_SPSS)
             else
        %      IDslope_NORM_DDindex=bsliang_getDDindex(IDslope_NORM); % get double dissociation index
             % block(C N)*subj(197)
              perDISRIB_IDslop_log=bsliang_generatepermuteDISTRIB(IDslop_log,LT_ind,100000);
              [P(leave_out_size_i,permutation_loop,boot).slp_nonorm,VAL(leave_out_size_i,permutation_loop,boot).slp_nonorm,M(leave_out_size_i,permutation_loop,boot).slp_nonorm,Hss_single]=bsliang_CNLRplots_re(IDslope_NORM_SPSS,0,1,1,perDISRIB_IDslop_log,IDslope_mask_NORM_SPSS); % yes statistics
              [Pss_single,Pss_compare]=bsliang_getPvalues(P.slp_nonorm.Larynx);
              Pss_single_rs=reshape(Pss_single',[],1);
              Pss_compare_rs=reshape(Pss_compare',[],1);
              Pss_output=[Pss_single_rs;Pss_compare_rs];
              Q_fdr_out=mafdr(Pss_output,'BHFDR','true')
             end

        %      bsliang_CNLRplots_re(IDslope_RAW_SPSS,1,1,1)
             % ==========================================================

            save  ..\data\org_result P VAL M leave_out_sizes boots
        end
    end
end
close(wb)
toc