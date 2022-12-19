function bsliang_TMS_main    
    % 重复验证计算：主程序
    clear all
    close all
   
    addpath('global');
    addpath(genpath('D:\重要资料_20190604\博一下学期\脑电\思影脑电20200720\siyingEEGT_20200720\6EEGT_day1\toolboxes\eeglab14_1_1b\eeglab14_1_1b'))
    
    % 输入一些参数：
    IDsteps=5;
    rawIDsteps=78; % 一个IDblock的trial数
    load(['..',filesep,'data',filesep,'DATA']);% load data
    % 获取左右脑index：
    cd(['..',filesep,'..',filesep,'10_3_3_TMS_experiment_IDDI',filesep,'10_3_2_TMS_experiment_IDDI_2020']);
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
    cd(['..',filesep,'..',filesep,'10_3_4_bsliang_recalculateDATA',filesep,'code']);
    
    % DATA structure:
    % turn: L T S
    % block: 
    %   Id_Di	BLOCK	NAME        NUMBER
    %   Id      A       T_CLEAR_ID      1
    %   Id      B       P_CLEAR_ID      2
    %   Id      C       T_NOISE_ID      3
    %   Id      D       P_NOISE_ID      4
    %    Di     A       T_CLEAR_DI      5
    %    Di     B       P_CLEAR_DI      6
    %    Di     C       T_NOISE_DI      7
    %    Di     D       P_NOISE_DI      8
    
    %% 预处理1：个体水平删被试
    % 1： 测试被试，不计入数据分析
    % 9： 三次阈值不一样
    % 56： 阈值不是90%RMT
    % 114：舌部阈值时低于90%RMT
    % 121：阈值不是90%RMT
    rej_INDind=[1 9 56 114 121 6 10 55 59 70]; % 后5个是去年的被试
    DATA=bsliang_rejINDdata(DATA,rej_INDind);
    
    %% 预处理2：将原始数据格式转换成方便分析的格式，统一缺失值表示形式
    TDATA=bsliang_Trandata(DATA); % TDATA为block(8)*turn(3)*subj(197)的cell
    
    %% 预处理3：block水平删被试
    % 删除的blocks是根据之前在正式数据处理里面单个被试作图看
    % 选出来的，这里不给出看单个被试的代码
%     rej_IDs=[5,4,1;...
%          5,4,3;...             
%          17,4,1;...
%          17,4,2;...
%          17,4,3;...
%          50,4,1;...
%          50,4,3;...
%          66,4,1;...
%          66,4,3;...
%          75,4,2;...
%          75,4,3;...
%          88,4,1;...
%          88,4,2;...
%          88,4,3;...
%          93,4,2;...
%          93,4,3;...
%          102,4,1;...
%          102,4,3;...
%          111,4,2;...
%          111,4,3;...
%          112,4,1;...
%          112,4,2;...
%          112,4,3;...
%          115,1,1;...
%          115,3,1;...
%          115,1,2;...
%          115,3,2;...
%          115,1,3;...
%          115,3,3;...
%          116,1,1;...
%          116,2,1;...
%          116,3,1;...
%          116,4,1;...
%          116,1,2;...
%          116,2,2;...
%          116,3,2;...
%          116,4,2;...       
%          116,1,3;...
%          116,2,3;...
%          116,3,3;...
%          116,4,3;...  
%          119,4,1;...
%          119,4,3;...
%          121,4,1;...
%          121,4,2;...
%          121,4,3;...
%          124,4,2;...
%          140,4,1;...
%          140,4,3;...
%          150,1,2;...
%          150,2,2;...
%          150,4,1;...
%          150,4,3;...
%          158,4,1;...
%          158,4,2;...
%          158,4,3;...
%          159,4,1;...
%          192,4,1;...
%          192,4,3]; 

%     rej_IDs=[115,4,3;
%             44,4,3]; % 这是后来杜老师加上去的，但是非常biased，就为了删outliers而删outliers，不够均衡。
     % ROW1: subj, ROW2: condition, ROW3: turn
     
       load rej_IDs_rejwaves
       TDATA=bsliang_rejBLOCKdata(TDATA,rej_IDs);
     
     %% 数据处理1：计算ID Slope
     disp('Now processing ID Slope');
     %设定拟合初始值：
     IDfit_begnpara=[0 1 (1-0)/(IDsteps-1) (1+IDsteps)/2];
     % paras： 1-下边界，2-上边界，3-斜率，4-主观相等点
     
     % ===================================================
     % 第一步：计算每个条件的平均曲线并进行无上下界自由拟合
     % ===================================================
     IDraw_G=nan(IDsteps,4,size(TDATA,2),size(TDATA,3));
     % step(5)*block(4)*turn(3)*subj(197)
     % block数量为4是因为只算ID
     for block=1:4
         for turn=1:size(TDATA,2)
             for subj=1:size(TDATA,3)
                 if ~isempty(TDATA{block,turn,subj}.half_threshold)
                     IDraw_G(:,block,turn,subj)=TDATA{block,turn,subj}.half_threshold(:,end);
                 end
             end
         end
     end
     IDraw_G_M=mean(IDraw_G,4,'omitnan');
      IDraw_G_M=1-IDraw_G_M; %曲线方向转换，从%step1转换为%step5
     %step(5)*block(4)*turn(3)
     % 画图看看
%      figure;
%      for block=1:4
%          subplot(2,2,block);
%          plot(1:5,squeeze(IDraw_G_M(:,block,:)));
%      end
     % 按组自由拟合，求出曲线下上界：
     IDdbs=nan(4,size(TDATA,2)); %下边界
     IDubs=IDdbs;%上边界
     % block(4)*turn(3)
     for block=1:4
         for turn=1:size(TDATA,2)
             paras = lsqcurvefit(@(paras,X) paras(1)+(paras(2)-paras(1))./(1+exp(-1*paras(3)*(X-paras(4)))),IDfit_begnpara,1:IDsteps,IDraw_G_M(:,block,turn)');
             % paras： 1-下边界，2-上边界，3-斜率，4-主观相等点
             IDdbs(block,turn)=paras(1); % 下边界
             IDubs(block,turn)=paras(2); % 上边界
         end
     end
     
     % ===================================================
     % 第二步：拟合每个被试的曲线，求出斜率
     % ===================================================    
     IDraw_step=nan(rawIDsteps,4,size(TDATA,2),size(TDATA,3));
     IDraw_resp=nan(rawIDsteps,4,size(TDATA,2),size(TDATA,3));
     % trial(78)*block(4)*turn(3)*subj(197)
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
     IDraw_resp=1-IDraw_resp; %曲线方向转换，从%step1转换为%step5
     IDslop=nan(4,size(TDATA,2),size(TDATA,3)); %斜率
     % block(TC PC TN PN)*turn(L T S)*subj(197)
     indIDfit_begnpara=IDfit_begnpara([3 4]);
     for block=1:4
         for turn=1:size(TDATA,2)
             IDdbs_bt=IDdbs(block,turn);
             IDubs_bt=IDubs(block,turn);
             IDslop_bt=nan(1,size(TDATA,3));
             parfor subj=1:size(TDATA,3)
                 if ~isempty(TDATA{block,turn,subj}.rawdata)
                     disp(['Now fitting subj: ',num2str(subj)]);
                    %  方法1：传统方法
%                        paras = lsqcurvefit(@(paras,X) IDdbs_bt+IDubs_bt./(1+exp(-1*paras(1)*(X-paras(2)))),indIDfit_begnpara,IDraw_step(:,block,turn,subj),IDraw_resp(:,block,turn,subj));
                    %  方法2：上下边界写在规定上下界上，不太行
%                      paras = lsqcurvefit(@(paras,X) paras(3)+paras(4)./(1+exp(-1*paras(1)*(X-paras(2)))),[indIDfit_begnpara 0 1],IDraw_step(:,block,turn,subj),IDraw_resp(:,block,turn,subj),IDdbs_bt,IDubs_bt);
                    %  方法3：上下边界设置为0 1
%                       paras = lsqcurvefit(@(paras,X) paras(3)+paras(4)./(1+exp(-1*paras(1)*(X-paras(2)))),[indIDfit_begnpara 0 1],IDraw_step(:,block,turn,subj),IDraw_resp(:,block,turn,subj),0,1);
                    %  方法4：全自由拟合
%                       paras = lsqcurvefit(@(paras,X) paras(3)+paras(4)./(1+exp(-1*paras(1)*(X-paras(2)))),[indIDfit_begnpara 0 1],IDraw_step(:,block,turn,subj),IDraw_resp(:,block,turn,subj));
                    %  方法5：传统方法+[0 1]强制边界
%                        paras = lsqcurvefit(@(paras,X) IDdbs_bt+IDubs_bt./(1+exp(-1*paras(1)*(X-paras(2)))),indIDfit_begnpara,IDraw_step(:,block,turn,subj),IDraw_resp(:,block,turn,subj),0,1);
                    %  方法6：真正的上下边界
                       paras = lsqcurvefit(@(paras,X) (IDubs_bt-IDdbs_bt)*(0+1./(1+exp(-1*paras(1)*(X-paras(2)))))+IDdbs_bt,indIDfit_begnpara,IDraw_step(:,block,turn,subj),IDraw_resp(:,block,turn,subj));
                    % 【【【与原始程序不一样的地方：没有根据主观相等点删数据】】】
                     % paras： 1-斜率，2-主观相等点
                     % 【【【bugs：原本的数据对斜率取了绝对值，这会导致一些反过来的斜率也纳进来了】】】
%                      paras(1)=paras(1)*(-1); % 最后报告斜率是个正值
%                      if turn==3 && paras(1)>0.5846 
                     % %
                     % 0.5846是这样算的：simulate10000个随机反应的被试，算出slopes分布的均值和标准差，三个标准差就是0.5846（其实就是标准正态分布的三个标准差？）
%                         IDslop_bt(subj)=paras(1); 
%                      elseif paras(1)>0
%                         IDslop_bt(subj)=paras(1); 
%                      end
                     if paras(1)>0
                        IDslop_bt(subj)=paras(1); 
                     end
                 end
             end
             IDslop(block,turn,:)=IDslop_bt;
         end
     end
     % 取log：
       IDslop_log=log(IDslop);
      
%       IDslop_log(:,:,IDslop_log(4,2,:)-IDslop_log(4,3,:)>1)=nan;
     
%      % 20210220:新方法——对于sham没有异常但其它异常的被试
%      zeroslopes=[124,4,2;
%                 150,1,2;
%                 150,2,2;
%                 159,4,1];
%      % ROW1: subj, ROW2: block, ROW3: turn
%      for zl=1:size(zeroslopes,1)
%          IDslop_log(zeroslopes(zl,2),zeroslopes(zl,3),zeroslopes(zl,1))=0;
%      end
     
     % 标准化、区分左右脑及输出【【【SPSS计算用的其实是原来的SPSS代码哈】】】
     [IDslope_NORM_SPSS,IDslope_NORM]=bsliang_norm_lr_out(TDATA,IDslop_log,LR_ind,'IDslope_NORM',1);
     [IDslope_RAW_SPSS,IDslope_RAW]=bsliang_tmssham_lr_out(TDATA,IDslop_log,LR_ind,'IDslope_RAW',1);
     IDslope_NORM_DDindex=bsliang_getDDindex(IDslope_NORM); % get double dissociation index
     % block(C N)*subj(197)
     % 作图：【【【这是改良了原来程序的作图代码】】】
%      bsliang_CNLRplots_re(IDslope_NORM_SPSS,0,1)
%      bsliang_CNLRplots_re(IDslope_RAW_SPSS,1,1)

     %% 数据处理2：仅提取判断和非判断维度trials的正确率
     IDCLEARACC=nan(4,size(TDATA,2),size(TDATA,3));
     % trial(78)*block(4)*turn(3)*subj(197)
     for block=1:4
         for turn=1:size(TDATA,2)
             for subj=1:size(TDATA,3)
                 if ~isempty(TDATA{block,turn,subj}.rawdata)
                     IDCLEARACC(block,turn,subj)=bsliang_getCLEARACC(TDATA{block,turn,subj}.rawdata,2);
                 end
             end
         end
     end
     [IDCLEARACC_NORM_SPSS,IDCLEARACC_NORM]=bsliang_norm_lr_out(TDATA,IDCLEARACC,LR_ind,'IDCLEARACC_NORM',0);
     [IDCLEARACC_RAW_SPSS,IDCLEARACC_RAW]=bsliang_tmssham_lr_out(TDATA,IDCLEARACC,LR_ind,'IDCLEARACC_RAW',0);     
%       bsliang_CNLRplots_re(IDCLEARACC_NORM_SPSS,0,1)
%       bsliang_CNLRplots_re(IDCLEARACC_RAW_SPSS,1,1)

%% 数据处理3：计算DI RT
     disp('Now processing DI RT');
     DI_RT=nan(4,size(TDATA,2),size(TDATA,3));
     % block(4)*turn(3)*subj(197)
     % 【【【BUG：之前算出刺激Tongue会影响DI反应时的，其实影响的是范畴边界点的反应时】】】
     for block=5:8
         for turn=1:size(TDATA,2)
             for subj=1:size(TDATA,3)
                 if ~isempty(TDATA{block,turn,subj}.rawdata)
%                      DI_RT_stepind_22=TDATA{block,turn,subj}.rawdata(:,1)==22;
%                      DI_RT_stepind_24=TDATA{block,turn,subj}.rawdata(:,1)==24;
%                      DI_RT_stepind_42=TDATA{block,turn,subj}.rawdata(:,1)==42;
%                      DI_RT_stepind_44=TDATA{block,turn,subj}.rawdata(:,1)==44;
%                      DI_RT_stepind=logical(DI_RT_stepind_22+DI_RT_stepind_24+DI_RT_stepind_42+DI_RT_stepind_44);
% %                      DI_RT_stepind=logical(DI_RT_stepind_24+DI_RT_stepind_42);%如果只考虑24和42也是能做出结果的，不过可以加上22和44，结果会更显著
%                      DI_RT(block-4,turn,subj)=mean(TDATA{block,turn,subj}.rawdata(DI_RT_stepind,3));
                    DI_RT(block-4,turn,subj)=mean(TDATA{block,turn,subj}.rawdata(:,3));
                 end
             end
         end
     end
     % 标准化、区分左右脑及输出
     [DIRT_NORM_SPSS,DIRT_NORM]=bsliang_norm_lr_out(TDATA,DI_RT,LR_ind,'DIRT_NORM',1);
     % 作图：【【【这是改良了原来程序的作图代码】】】
%       bsliang_CNLRplots_re(DIRT_NORM_SPSS,0,1)
     
     %% DWI-行为关联
%     DWI_clust={'LlAF','RlAF','LRpreCG','LRBA','LRIPL','LRpAC'}; %要读取的纤维束
%     DWI_clustn={'LlAF','RlAF','lr_preCG','LRBA','LRIPL','LRpAC'}; %要读取的纤维束文件名
    DWI_clust={'LlAF','RlAF','LRpreCG','LRBA','LRIPL'}; %要读取的纤维束
    DWI_clustn={'LlAF','RlAF','lr_preCG','LRBA','LRIPL'}; %要读取的纤维束文件名
    DWI_ind={'FA','NDI','ODI'}; % 要读取的指标
    DWI_indn={'fa','nd','od'}; % 要读取的指标的文件名
    isdwi_raw=inputdlg('请选择是否需要从rawdata读取DWI，如果已有结果，请写0（不需要读取）,如果无结果或者要重新读取，请写1（需要读取)');
    isdwi=logical(str2double(isdwi_raw{1}));
    if isdwi
         DWIs=bsliang_getDWIs(DWI_clust,DWI_clustn,DWI_ind,DWI_indn);
         save(['..',filesep,'data',filesep,'DWIs'],'DWIs');
     else
         load(['..',filesep,'data',filesep,'DWIs'])
     end
     
%      DWI_clust_any={'LRpreCG','LRBA','LRIPL','LRpAC','SLIlAF'}; %要分析的纤维束
%      DWI_clust_any={'LRpreCG','SLIlAF','LRBA'}; %要分析的纤维束
     DWI_clust_any={'LlAF','RlAF','LRpreCG','SLIlAF'}; %要分析的纤维束
     DWI_ind_any={'FA','NDI','ODI','N'}; % 要分析的指标
    
     HEMIs={'LEFT','RIGHT'};
     BLOCKs={'TC','PC','TN','PN','DDiC','DDiN'};
     TURNs={'Larynx','Tongue','DDi'};
     TASKs={'IDSLOPE','DIRT'};
     BLOCKs_DDind={'DDiC','DDiN'};
     
     CORR_RESOULT=[];
     CORR_RAW=[];
     
     % CORR_RESOULT每一行：hemi,clust,ind,block,turn,1,R_TMP,P_TMP,P_TMP<0.05,P_TMP<0.01
     for hemi=1:2
         % 1: 左脑，2：右脑
         for clust=1:length(DWI_clust_any)
             % 对每一个白质束
            for ind=1:length(DWI_ind_any)
                % 对每个指标
                DWI_TMP=DWIs.(DWI_clust_any{clust}).(DWI_ind_any{ind})(LR_ind==hemi)';
                RAWTMP=[];
                for block=1:4
                    for turn=1:2
                        
                        RAWTMP.DWI=DWI_TMP';
                        
                        IDslope_NORM_TMP=squeeze(IDslope_NORM(block,turn,LR_ind==hemi));
                        [R_TMP,P_TMP]=corr(DWI_TMP,IDslope_NORM_TMP,'rows','complete');
                        CORR_RESOULT=[CORR_RESOULT;hemi,clust,ind,block,turn,1,R_TMP,P_TMP,P_TMP<0.05,P_TMP<0.01]; % 1代表IDSLOPE
                        
                        RAWTMP.(TASKs{1})=IDslope_NORM_TMP';
                        
                        DIRT_NORM_TMP=squeeze(DIRT_NORM(block,turn,LR_ind==hemi));
                        [R_TMP,P_TMP]=corr(DWI_TMP,DIRT_NORM_TMP,'rows','complete');
                        CORR_RESOULT=[CORR_RESOULT;hemi,clust,ind,block,turn,2,R_TMP,P_TMP,P_TMP<0.05,P_TMP<0.01]; % 1代表IDSLOPE

                        RAWTMP.(TASKs{2})=DIRT_NORM_TMP';
                        
                        CORR_RAW.(HEMIs{hemi}).(DWI_clust_any{clust}).(DWI_ind_any{ind}).(BLOCKs{block}).(TURNs{turn})=RAWTMP;
                    end
                end
                RAWTMP=[];
                for block_DDind=1:2

                    RAWTMP.DWI=DWI_TMP';

                    IDslope_DDind_TMP=squeeze(IDslope_NORM_DDindex(block_DDind,LR_ind==hemi));
                    [R_TMP,P_TMP]=corr(DWI_TMP,IDslope_DDind_TMP','rows','complete');
                    CORR_RESOULT=[CORR_RESOULT;hemi,clust,ind,block_DDind+4,3,1,R_TMP,P_TMP,P_TMP<0.05,P_TMP<0.01]; % 1代表IDSLOPE

                    RAWTMP.(TASKs{1})=IDslope_DDind_TMP';

                    CORR_RAW.(HEMIs{hemi}).(DWI_clust_any{clust}).(DWI_ind_any{ind}).(BLOCKs_DDind{block_DDind}).(TURNs{3})=RAWTMP;
                end
             end
         end
     end
     save(['..',filesep,'data',filesep,'DWIBEHAV_RAW'],'CORR_RAW');
     
     % FDR校正
     % 目前的策略是，对于每个数据中的每个白质不同指标进行FDR（也就是做N FA ODI NDI）
     CORR_RESOULT(:,11)=nan;
     for hemi=1:2
         for clust=1:length(DWI_clust_any)
%             for ind=1:length(DWI_ind_any)
                for block=1:6
                    for turn=1:3
                        for task=1:2
                         % CORR_RESOULT每一行：hemi,clust,ind,block,turn,1,R_TMP,P_TMP,P_TMP<0.05,P_TMP<0.01
                            hemi_ind=CORR_RESOULT(:,1)==hemi;
                            clust_ind=CORR_RESOULT(:,2)==clust;
%                             ind_ind=CORR_RESOULT(:,3)==ind;
                            block_ind=CORR_RESOULT(:,4)==block;
                            turn_ind=CORR_RESOULT(:,5)==turn;
                            task_ind=CORR_RESOULT(:,6)==task;
                            correct_ind=logical(hemi_ind.*clust_ind.*block_ind.*turn_ind.*task_ind);
                            if ~sum(correct_ind)==0
                                [~,p_masked]=fdr(CORR_RESOULT(correct_ind,8),0.05);
                                CORR_RESOULT(correct_ind,11)=p_masked;
                            end
                        end
                    end
                end
          end
     end
     
     % 输出
     CR=CORR_RESOULT;
     CRcell=cell(size(CR,1)+1,size(CR,2));
     CRcell{1,1}='HEMI';
     CRcell{1,2}='CLUST';
     CRcell{1,3}='INDEX';
     CRcell{1,4}='BLOCK';
     CRcell{1,5}='TURN';
     CRcell{1,6}='BEHAV';
     CRcell{1,7}='RHO';
     CRcell{1,8}='P';
     CRcell{1,9}='P<.05';
     CRcell{1,10}='P<.01';
     CRcell{1,11}='PFDR<.05';
     for crow=1:size(CR,1)
          % CORR_RESOULT每一行：hemi,clust,ind,block,turn,1,R_TMP,P_TMP,P_TMP<0.05,P_TMP<0.01
          CRcell{crow+1,1}=HEMIs{CR(crow,1)};
          CRcell{crow+1,2}=DWI_clust_any{CR(crow,2)};
          CRcell{crow+1,3}=DWI_ind_any{CR(crow,3)};
          CRcell{crow+1,4}=BLOCKs{CR(crow,4)};
          CRcell{crow+1,5}=TURNs{CR(crow,5)};
          CRcell{crow+1,6}=TASKs{CR(crow,6)};
          for ccol=7:size(CR,2)
              CRcell{crow+1,ccol}=CR(crow,ccol);
          end
     end
     save(['..',filesep,'data',filesep,'DWIBEHAV'],'CRcell');
     
     % bsliang_plotDWIBEHAVS %给显著的相关作图
     
     restoredefaultpath
end