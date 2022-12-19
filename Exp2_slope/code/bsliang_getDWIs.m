function DWIs=bsliang_getDWIs(DWI_clust,DWI_clustn,DWI_ind,DWI_indn)
    % �����µı�̼��ɣ�
    % https://www.mathworks.com/support/search.html/answers/304528-tutorial-why-variables-should-not-be-named-dynamically-eval.html?fq=asset_type_name:answer%20category:support/variables870&page=1
    % ��ȡDWI����
    % �������Ѿ�������DWI�����Ǹ�֮ǰ����ȫһ���ģ�ֻ������ǰ���кü���0������
    % ��������ȡtxt�����õ��Ǿɳ���bsliang_load_DTItxt������
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
        % ����ÿ��DWI������
        IND_TMP=[];
        for ind=1:length(DWI_ind)
            % ����ÿ��DWIָ�꣨FA,OD,ND��
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
                if sum(subj_lst==par)>0 % ������һ����
                    txtpath=[rawpath,filesep,subj_fname,filesep,subj_fname]; 
                    TMP=bsliang_load_DTItxt([txtpath,'_',DWI_clustn_par,'_',DWI_indn_par,'.txt']);
                    SUBJ_TMP(par)=mean(TMP);
                    SUBJ_N_TMP(par)=length(TMP);
                end
            end
            IND_TMP.(DWI_ind{ind})=SUBJ_TMP;
            if ind == 1 % FA����N
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
