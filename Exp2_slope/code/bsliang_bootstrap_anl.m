function bsliang_bootstrap_anl()
load ..\data\bootstrap
% indexs={'slp_nonorm','slp_norm','pse_norm','pse_nonorm'};
indexs={'slp_nonorm','pse_nonorm'};
regions={'Larynx','Tongue'};
conds={'left_clear','right_clear','left_noise','right_noise'};
tasks={'tone_iTBS','tone_cTBS','tone_icTBS','phon_iTBS','phon_cTBS','phon_icTBS'};
VAL=squeeze(VAL);
P=squeeze(P);
nLOO=size(VAL,1);
nBOOT=size(VAL,2);
alpha=0.05/4;

for index=1:length(indexs)
    for region=1:length(regions)
        for cond=1:length(conds)
            for task=1:length(tasks)
                Pi=nan(nLOO,nBOOT);
                VALi=Pi;
                for LOOi=1:nLOO
                    for BOOTi=1:nBOOT
                        Pi(LOOi,BOOTi)=P(LOOi,BOOTi).(indexs{index}).(regions{region}).(conds{cond}).(tasks{task});
                        VALi(LOOi,BOOTi)=VAL(LOOi,BOOTi).(indexs{index}).(regions{region}).(conds{cond}).(tasks{task});
                    end
                end
                mean_Pi=mean(Pi,2,'omitnan');
                std_Pi=std(Pi','omitnan')/sqrt(nBOOT);
                mean_VALi=mean(VALi,2,'omitnan');
                std_VALi=std(VALi','omitnan')/sqrt(nBOOT);
                
                if min(mean_Pi)<alpha
                    figure;
                    subplot(1,2,1);
                    errorbar(leave_out_sizes,mean_Pi,std_Pi);
                    xlabel('leave N out');
                    ylabel('P-value');
                    title(strrep([indexs{index},' ',regions{region},' ',conds{cond},' ',tasks{task}],'_',' '));
                    set(gca,'XTick',[1 3 5 7]);
                    hold on
                    plot(leave_out_sizes([1 end]),[alpha alpha],'r--');
                    plot(leave_out_sizes([1 end]),[alpha/4 alpha/4],'g--');
                    subplot(1,2,2);
                    errorbar(leave_out_sizes,mean_VALi,std_VALi);
                    ylabel('T/Z-value');
                    set(gca,'XTick',[1 3 5 7]);
                end
%                 pause;
%                 close all
            end
        end
    end
end