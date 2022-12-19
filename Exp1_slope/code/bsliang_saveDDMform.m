function bsliang_saveDDMform(TDATA,group_indx,save_path)
    % 读取和转换数据到处理数据的格式
    % ================================
    % DATA structure:
    % turn: L T S
    % block: 
    %   Id_Di	BLOCK	NAME        NUMBER
    %   Id      A       T_CLEAR_ID      1
    %   Id      B       P_CLEAR_ID      2
    %   Id      C       T_NOISE_ID      3
    %   Id      D       P_NOISE_ID      4
    turn_types={'LMC','TMC','Sham'};
    Block_types={'Tone','Cons','Tone','Cons';...
                 'Clear','Clear','Noise','Noise'};
    
%     save_path=['..',filesep,'data',filesep,'DDM.csv'];
    
    subj_idx=[];
    group_idx={};
    turn_type={};
    task_type={};
    snr_type={};
    trial_num=[];
    step_att=[];
    response=[];
    rt=[];
    step_unatnd=[];
    
    for subj=1:size(TDATA,3) 
        for turn=1:3 % L T S
            for block=1:4 % IDTC IDPC IDTN IDPN
                if ~isempty(TDATA{block,turn,subj}.half_threshold)
                    
                    Datatmp=[];
                    Datatmp=TDATA{block,turn,subj}.rawdata;
                    sizetmp=size(Datatmp,1);
                    
                    subj_idx_mat=[];
                    group_idx_mat=[];
                    turn_type_mat=[];
                    task_type_mat=[];
                    snr_type_mat=[];
                    trial_num_mat=[];
                    step_att_mat=[];
                    response_mat=[];
                    rt_mat=[];
                    step_unatnd_mat=[];
                    
                    subj_idx_mat=repmat(subj,sizetmp,1);
                    if group_indx(subj)==1; gidx={'Left'}; else gidx={'Right'}; end;
                    group_idx_mat=repmat(gidx,sizetmp,1);
                    turn_type_mat=repmat(turn_types(turn),sizetmp,1);
                    task_type_mat=repmat(Block_types(1,block),sizetmp,1);
                    snr_type_mat=repmat(Block_types(2,block),sizetmp,1);
                    trial_num_mat=1:sizetmp;
                    step_att_mat=Datatmp(:,1);
                    response_mat=Datatmp(:,2);
                    rt_mat=Datatmp(:,3);
                    step_unatnd_mat=Datatmp(:,4);
                    
                    subj_idx=[subj_idx;subj_idx_mat];
                    group_idx=[group_idx;group_idx_mat];
                    turn_type=[turn_type;turn_type_mat];
                    task_type=[task_type;task_type_mat];
                    snr_type=[snr_type;snr_type_mat];
                    trial_num=[trial_num;trial_num_mat'];
                    step_att=[step_att;step_att_mat];
                    response=[response;response_mat];
                    rt=[rt;rt_mat];
                    step_unatnd=[step_unatnd;step_unatnd_mat];
                                        
                end
            end
        end
    end
    response=1-response;
    T=table(subj_idx,group_idx,turn_type,task_type,snr_type,trial_num,step_att,response,rt,step_unatnd);
    writetable(T,save_path);
end