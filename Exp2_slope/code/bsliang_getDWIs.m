function DWIs=bsliang_getDWIs(DWI_clust,DWI_clustn,DWI_ind,DWI_indn)
    % 用了新的编程技巧：
    % https://www.mathworks.com/support/search.html/answers/304528-tutorial-why-variables-should-not-be-named-dynamically-eval.html?fq=asset_type_name:answer%20category:support/variables870&page=1
    % 读取DWI数据
    % 【【【已经检查过，DWI数据是跟之前的完全一样的，只不过以前的有好几个0】】】
    % 【【【读取txt数据用的是旧程序：bsliang_load_DTItxt】】】
    rawpath=['..',filesep,'..',filesep,'10_3_5_DTIanalysis',filesep,'DTIvalues_raw',filesep,'redo_stats_20210205'];
    d=dir([rawpath,filesep,'S*']);
    subj_lst=[];
    for i=1:size(d,1)
        subj_lst=[subj_lst,str2double(d(i).name(2:end))];
    end
    subj_lst=sort(subj_lst);
    DWIs=[];

    %% get DWIs
    for clust=1:length(DWI_clust)
        % 对于每个DWI白质束
        IND_TMP=[];
        for ind=1:length(DWI_ind)
            % 对于每个DWI指标（FA,OD,ND）
            SUBJ_TMP=nan(1,max(subj_lst));
            SUBJ_N_TMP=SUBJ_TMP;
            DWI_clustn_par=DWI_clustn{clust};
            DWI_indn_par=DWI_indn{ind};
            parfor par=1:max(subj_lst)
                if par<10
                    subj_fname=['S0',num2str(par)];
                else
                    subj_fname=['S',num2str(par)];
                end
                if sum(subj_lst==par)>0 % 存在这一被试
                    txtpath=[rawpath,filesep,subj_fname,filesep,subj_fname]; 
                    TMP=bsliang_load_DTItxt([txtpath,'_',DWI_clustn_par,'_',DWI_indn_par,'.txt']);
                    SUBJ_TMP(par)=mean(TMP);
                    SUBJ_N_TMP(par)=length(TMP);
                end
            end
            IND_TMP.(DWI_ind{ind})=SUBJ_TMP;
            if ind == 1 % FA，算N
                IND_TMP.N=SUBJ_N_TMP;
            end
        end
        DWIs.(DWI_clust{clust})=IND_TMP;
    end

%% calculate lAF Standard Lateralization Index (SLI)
    for ind=1:length(DWI_ind)
        DWIs.SLIlAF.(DWI_ind{ind})=(DWIs.LlAF.(DWI_ind{ind})-DWIs.RlAF.(DWI_ind{ind}))./(DWIs.LlAF.(DWI_ind{ind})+DWIs.RlAF.(DWI_ind{ind}));
    end
    DWIs.SLIlAF.N=(DWIs.LlAF.N-DWIs.RlAF.N)./(DWIs.LlAF.N+DWIs.RlAF.N);
end
