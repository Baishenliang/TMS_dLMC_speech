function bsliang_permutation_anl()
addpath('E:\eeglab2021\functions\statistics') % getting fdr function from eeglab
% analysis for permutation
load ..\data\org_result
Morg=squeeze(M);
clear M
load ..\data\permutation
M=squeeze(M);

% indexs={'slp_nonorm','slp_norm','pse_norm','pse_nonorm'};
indexs={'slp_nonorm','pse_nonorm'};
regions={'Larynx','Tongue'};
conds={'left_clear','right_clear','left_noise','right_noise'};
tasks={'tone_iTBS','tone_cTBS','tone_icTBS','phon_iTBS','phon_cTBS','phon_icTBS'};
nBOOT=size(M,2);
alpha=0.05;

for index=1:length(indexs)
    for region=1:length(regions)
        ps=nan(1,16);
        ps_index=1;
        
        % calculating p-vals
        for permute_loop=1:4
            %  turn：
            %   permute_loop          permute_cond                        conds                         tasks
            %   1                  Left_iTBS vs Sham           {'left_clear','left_noise'}           {'tone_iTBS','phon_iTBS'}
            %   2                  Left_cTBS vs Sham           {'left_clear','left_noise'}           {'tone_cTBS','phon_cTBS'}
            %   3                  Right_iTBS vs Sham          {'right_clear','right_noise'}         {'tone_iTBS','phon_iTBS'}
            %   4                  Right_cTBS vs Sham          {'right_clear','right_noise'}         {'tone_cTBS','phon_cTBS'}
            switch permute_loop
                case 1
                    conds={'left_clear','left_noise'}; tasks={'tone_iTBS','phon_iTBS'};
                case 2
                    conds={'left_clear','left_noise'}; tasks={'tone_cTBS','phon_cTBS'};
                case 3
                    conds={'right_clear','right_noise'}; tasks={'tone_iTBS','phon_iTBS'};
                case 4
                    conds={'right_clear','right_noise'}; tasks={'tone_cTBS','phon_cTBS'};
            end
            for cond=1:length(conds)
                for task=1:length(tasks)
                    Mi=nan(1,nBOOT);
                    for BOOTi=1:nBOOT
                        Mi(BOOTi)=M(permute_loop,BOOTi).(indexs{index}).(regions{region}).(conds{cond}).(tasks{task});
                        Morgi=Morg.(indexs{index}).(regions{region}).(conds{cond}).(tasks{task});
                    end
                    Mi_Morgi=[Mi,Morgi];
                    if Morgi<mean(Mi,'omitnan')
                        Mi_Morgi=sort(Mi_Morgi);
                        rank=find(Mi_Morgi==Morgi);
                        p=(rank+1)/(nBOOT+2);
                    elseif Morgi>mean(Mi,'omitnan')
                        Mi_Morgi=sort(Mi_Morgi,'descend');
                        rank=find(Mi_Morgi==Morgi);
                        p=(rank+1)/(nBOOT+2);
                    end
                    ps(ps_index)=p;
                    ps_index=ps_index+1;
                      if p < alpha
                        figure; hist(Mi); hold on; plot(Morgi,0,'ro');
                        title(strrep([indexs{index},' ',regions{region},' ',conds{cond},' ',tasks{task},' p = ',num2str(p)],'_',' '));
                      end
                end
            end
        end
        
        % do fdr
        [p_fdr,~]=fdr(ps,0.05);
        disp(p_fdr);
        
        % plotting
        % 因为没有任何p值过得了fdr（16个p值），所以就没有再做下去
    end
end