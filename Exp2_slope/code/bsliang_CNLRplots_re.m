function [P,VAL,M,Hss_single]=bsliang_CNLRplots_re(data_in,issham,rmnan,is_stat,perDISRIB,data_in_mask)
    % issham == 1, add sham, iTBS cTBS sham
    % issham == 0. dont add sham, usually iTBS=iTBS-sham, cTBS=cTBS-sham
    % is_stat: 是否进行统计检验
    
    P=[]; VAL=[]; M=[];
    
    data=data_in(:,2:end);
    data_mask=data_in_mask(:,2:end);
    LT_inds=data_in(:,1);
    
    Hss_single=nan(2,4,4);
    
    addpath('global');
    
    % =================================
    %    Left Clear  ||   Right Clear
    % =================================
    %    Left Noise  ||   Right Noise
    % =================================
    
    % 每幅图：
    % ==============================================
    %    Tone iTBS|cTBS  ||   Phon iTBS|cTBS
    % ==============================================
    
    %% load data
    if rmnan
    data(data==bsliang_numNAN)=nan;
    end
    
    Li_CT = data(:,1); Li_CP = data(:,2); Lc_CT = data(:,3); Lc_CP = data(:,4);
    Ri_CT = data(:,5); Ri_CP = data(:,6); Rc_CT = data(:,7); Rc_CP = data(:,8);
    S_CT = data(:,9);  S_CP = data(:,10);
    
    Li_NT = data(:,11); Li_NP = data(:,12); Lc_NT = data(:,13); Lc_NP = data(:,14);
    Ri_NT = data(:,15); Ri_NP = data(:,16); Rc_NT = data(:,17); Rc_NP = data(:,18);
    S_NT = data(:,19);  S_NP = data(:,20);
    
    if ~isempty(data_mask)
        Li_CT_mask = data_mask(:,1); Li_CP_mask = data_mask(:,2); 
        Lc_CT_mask = data_mask(:,3); Lc_CP_mask = data_mask(:,4);
        Ri_CT_mask = data_mask(:,5); Ri_CP_mask = data_mask(:,6);
        Rc_CT_mask = data_mask(:,7); Rc_CP_mask = data_mask(:,8);
        S_CT_mask = data_mask(:,9);  S_CP_mask = data_mask(:,10);

        Li_NT_mask = data_mask(:,11); Li_NP_mask = data_mask(:,12);
        Lc_NT_mask = data_mask(:,13); Lc_NP_mask = data_mask(:,14);
        Ri_NT_mask = data_mask(:,15); Ri_NP_mask = data_mask(:,16);
        Rc_NT_mask = data_mask(:,17); Rc_NP_mask = data_mask(:,18);
        S_NT_mask = data_mask(:,19);  S_NP_mask = data_mask(:,20);
    end

%     load('..\..\1_SPSS_stat\lenLR')
%     L_ind=1:lenLR.left;
%     T_ind=lenLR.left+1:lenLR.left+lenLR.right;

    sgtitles={'Larynx'};
    % 2016版的matlab画不了sgtitle，只能临时用这个代替
    
    %% plots: not sham
    if issham==0
        LT=1;

        Ylims={[-3.5 3.5],[-4.5 3.5]};
        Yticks={[-3.5 -3 -2 -1 1 2 3 3.5],[-4.5 -4 -3 -2 -1 1 2 3 3.5]};

%             dotlim=[0.85 1.15] - 1.5;
        LT_ind=LT_inds==LT;

        dotlim=[0.3125 0.6875] - 1;
        figure
        [ha, ~] = tight_subplot(2, 2,[.15 .04],[.1 .07],[.03 .03]);
        set(gcf,'color','w');
        set(gcf,'unit','centimeter')
        set(gcf,'Position',[0 0 17.4 15])

        sgtitle=sgtitles{LT};

        % left clear
%             subplot(2,2,1)
        axes(ha(1))
        TONE=[Li_CT(LT_ind) Lc_CT(LT_ind)];
        PHON=[Li_CP(LT_ind) Lc_CP(LT_ind)];
        if ~isempty(data_mask)
            TONE_mask = [Li_CT_mask(LT_ind) Lc_CT_mask(LT_ind)];
            PHON_mask=[Li_CP_mask(LT_ind) Lc_CP_mask(LT_ind)];
        else
            TONE_mask = []; PHON_mask = [];
        end
        [P.(sgtitle).left_clear,VAL.(sgtitle).left_clear,M.(sgtitle).left_clear,Hss_single(LT,1,:)]=bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat,perDISRIB([1 2],[1 2],LT,:),TONE_mask,PHON_mask,Ylims{1},Yticks{1});
         % perDISRIB
         % 4*block, 4*turn, 2*LT_ind, Npermute
         % turn： Left iTBS   Left cTBS   Right iTBS   Right cTBS  Sham
         % block：T_CLEAR_ID  P_CLEAR_ID  T_NOISE_ID  P_NOISE_ID

%             title('Left Clear','FontSize',20);

        % right clear
%             subplot(2,2,2)
        axes(ha(2))
        TONE=[Ri_CT(LT_ind) Rc_CT(LT_ind)];
        PHON=[Ri_CP(LT_ind) Rc_CP(LT_ind)];
        if ~isempty(data_mask)
            TONE_mask=[Ri_CT_mask(LT_ind) Rc_CT_mask(LT_ind)];
            PHON_mask=[Ri_CP_mask(LT_ind) Rc_CP_mask(LT_ind)];
        else
            TONE_mask=[];PHON_mask=[];
        end
        [P.(sgtitle).right_clear,VAL.(sgtitle).right_clear,M.(sgtitle).right_clear,Hss_single(LT,2,:)]=bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat,perDISRIB([1 2],[3 4],LT,:),TONE_mask,PHON_mask,Ylims{1},Yticks{1});
%             title('Right Clear','FontSize',20);

        % left noise
%             subplot(2,2,3)
        axes(ha(3))
        TONE=[Li_NT(LT_ind) Lc_NT(LT_ind)];
        PHON=[Li_NP(LT_ind) Lc_NP(LT_ind)];
        if ~isempty(data_mask)
            TONE_mask=[Li_NT_mask(LT_ind) Lc_NT_mask(LT_ind)];
            PHON_mask=[Li_NP_mask(LT_ind) Lc_NP_mask(LT_ind)];
        else
            TONE_mask=[];PHON_mask=[];
        end
        [P.(sgtitle).left_noise,VAL.(sgtitle).left_noise,M.(sgtitle).left_noise,Hss_single(LT,3,:)]=bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat,perDISRIB([3 4],[1 2],LT,:),TONE_mask,PHON_mask,Ylims{2},Yticks{2});
%             title('Left Noise','FontSize',20);

        % right noise
%             subplot(2,2,4)
        axes(ha(4)) 
        TONE=[Ri_NT(LT_ind) Rc_NT(LT_ind)];
        PHON=[Ri_NP(LT_ind) Rc_NP(LT_ind)];
        if ~isempty(data_mask)
            TONE_mask=[Ri_NT_mask(LT_ind) Rc_NT_mask(LT_ind)];
            PHON_mask=[Ri_NP_mask(LT_ind) Rc_NP_mask(LT_ind)];
        else
            TONE_mask=[];PHON_mask=[];
        end
        [P.(sgtitle).right_noise,VAL.(sgtitle).right_noise,M.(sgtitle).right_noise,Hss_single(LT,4,:)]=bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat,perDISRIB([3 4],[3 4],LT,:),TONE_mask,PHON_mask,Ylims{2},Yticks{2});
%             title('Right Noise','FontSize',20);
    end
    %% plots: include sham
    if issham==1
        LT=1;
        LT_ind=LT_inds==LT;
        dotlim=[0.775 1 1.225] - 1.5;
        figure;
        % left clear
        subplot(2,2,1)
        TONE=[Li_CT(LT_ind) S_CT(LT_ind) Lc_CT(LT_ind)];
        PHON=[Li_CP(LT_ind) S_CP(LT_ind) Lc_CP(LT_ind)];
        bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat);
        title('Left Clear','FontSize',20);

        % right clear
        subplot(2,2,2)
        TONE=[Ri_CT(LT_ind) S_CT(LT_ind) Rc_CT(LT_ind)];
        PHON=[Ri_CP(LT_ind) S_CP(LT_ind) Rc_CP(LT_ind)];
        bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat);
        title('Right Clear','FontSize',20);

        % left noise
        subplot(2,2,3)
        TONE=[Li_NT(LT_ind) S_NT(LT_ind) Lc_NT(LT_ind)];
        PHON=[Li_NP(LT_ind) S_NP(LT_ind) Lc_NP(LT_ind)];
        bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat);
        title('Left Noise','FontSize',20);

        % right noise
        subplot(2,2,4)
        TONE=[Ri_NT(LT_ind) S_NT(LT_ind) Rc_NT(LT_ind)];
        PHON=[Ri_NP(LT_ind) S_NP(LT_ind) Rc_NP(LT_ind)];
        bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat);
        title('Right Noise','FontSize',20);
    end
end

function [P,VAL,M,Hs_single]=bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,is_stat,perDISRIBp,TONE_mask,PHON_mask,Ylim,Ytick)
    TONE_mask =[]; PHON_mask=[];
    P=[]; VAL=[]; M=[];
    Hs_single=nan(1,4);
%% COLORS

    % 每幅图：
    % ==============================================
    %    Tone iTBS|cTBS  ||   Phon iTBS|cTBS
    % ==============================================
    
%     COL_iTBS_TONE=[0 112 192]/255;
%     COL_iTBS_PHON=[237 125 49]/255;
%     COL_cTBS_TONE=[189 215 238]/255;
%     COL_cTBS_PHON=[248 203 173]/255;
    COL_iTBS_TONE=[112 48 160]/255;
    COL_iTBS_PHON=[112 48 160]/255;
    COL_cTBS_TONE=[197 158 226]/255;
    COL_cTBS_PHON=[197 158 226]/255;
%     COL_iTBS_TONE=[79 79 79]/255;
%     COL_iTBS_PHON=[79 79 79]/255;
%     COL_cTBS_TONE=[207 207 207]/255;
%     COL_cTBS_PHON=[207 207 207]/255;
    COL_Sham=[0.8 0.8 0.8];
    
    TONEmean=mean(TONE,1,'omitnan');
    PHONmean=mean(PHON,1,'omitnan');
    
%     area([-1 0],[Ylim(2),Ylim(2)],'basevalue',Ylim(1),'FaceColor',[189 215 238]/255);
    area([-1 0],[Ylim(2),Ylim(2)],'basevalue',Ylim(1),'FaceColor',[222 235 246]/255,'EdgeColor',[222 235 246]/255);
        hold on
%     area([0 1],[Ylim(2),Ylim(2)],'basevalue',Ylim(1),'FaceColor',[248 203 173]/255);
    area([0 1],[Ylim(2),Ylim(2)],'basevalue',Ylim(1),'FaceColor',[252 233 220]/255,'EdgeColor',[252 233 220]/255);
    
%     bar(-0.5:1:0.5,[TONEmean;zeros(size(TONEmean,1),size(TONEmean,2))],1,'FaceColor',[1 1 1],'EdgeColor',[0 0 0]);
    bsliang_piledbar([TONEmean,PHONmean]);

%     hold on
    
    plot(dotlim,TONE,'-','Color',[0.4 0.4 0.4]);
    if issham==0
        plot(dotlim(1),TONE(:,1),'o','Color',[0 0 0],'MarkerFaceColor',COL_iTBS_TONE);
        if ~isempty(TONE_mask) && sum(TONE_mask(:,1)==1); plot(dotlim(1),TONE(TONE_mask(:,1)==1,1),'o','Color',[1 0 0],'MarkerFaceColor',[1 0 0]);end
        if is_stat; [P.tone_iTBS,VAL.tone_iTBS,M.tone_iTBS,Report,Hs_single(1)]=bsliang_stat_singletest(TONE(:,1),dotlim(1),perDISRIBp(1,1,:),'right');disp(['Tone iTBS:          ',Report]);end
        plot(dotlim(2),TONE(:,2),'o','Color',[0 0 0],'MarkerFaceColor',COL_cTBS_TONE);
        if ~isempty(TONE_mask) && sum(TONE_mask(:,2)==1); plot(dotlim(2),TONE(TONE_mask(:,2)==1,2),'o','Color',[1 0 0],'MarkerFaceColor',[1 0 0]);end
        if is_stat; [P.tone_cTBS,VAL.tone_cTBS,M.tone_cTBS,Report,Hs_single(2)]=bsliang_stat_singletest(TONE(:,2),dotlim(2),perDISRIBp(1,2,:),'left');disp(['Tone cTBS:          ',Report]);end
        if is_stat; [P.tone_icTBS,VAL.tone_icTBS,M.tone_icTBS,Report,~]=bsliang_stat_singletest([TONE(:,1) TONE(:,2)],[dotlim(1) dotlim(2)],[],'right');disp(['Tone iTBS - cTBS:          ',Report]);end
    elseif issham==1
        plot(dotlim(1),TONE(:,1),'o','Color',COL_iTBS_TONE,'MarkerFaceColor',COL_iTBS_TONE);
        plot(dotlim(2),TONE(:,2),'o','Color',COL_Sham,'MarkerFaceColor',COL_Sham);
        plot(dotlim(3),TONE(:,3),'o','Color',COL_cTBS_TONE,'MarkerFaceColor',COL_cTBS_TONE);
    end
    
%     bar(-0.5:1:0.5,[zeros(size(PHONmean,1),size(PHONmean,2));PHONmean],1,'FaceColor',[1 1 1],'EdgeColor',[0 0 0]);

    plot(dotlim+1,PHON,'-','Color',[0.4 0.4 0.4]);
    if issham==0
        plot(dotlim(1)+1,PHON(:,1),'o','Color',[0 0 0],'MarkerFaceColor',COL_iTBS_PHON);
        if ~isempty(PHON_mask) && sum(PHON_mask(:,1)==1); plot(dotlim(1)+1,PHON(PHON_mask(:,1)==1,1),'o','Color',[1 0 0],'MarkerFaceColor',[1 0 0]);end
        if is_stat; [P.phon_iTBS,VAL.phon_iTBS,M.phon_iTBS,Report,Hs_single(3)]=bsliang_stat_singletest(PHON(:,1),dotlim(1)+1,perDISRIBp(2,1,:),'right'); disp(['Phon iTBS:          ',Report]);end;
        plot(dotlim(2)+1,PHON(:,2),'o','Color',[0 0 0],'MarkerFaceColor',COL_cTBS_PHON);
        if ~isempty(PHON_mask) && sum(PHON_mask(:,2)==1); plot(dotlim(2)+1,PHON(PHON_mask(:,2)==1,2),'o','Color',[1 0 0],'MarkerFaceColor',[1 0 0]);end
        if is_stat; [P.phon_cTBS,VAL.phon_cTBS,M.phon_cTBS,Report,Hs_single(4)]=bsliang_stat_singletest(PHON(:,2),dotlim(2)+1,perDISRIBp(2,2,:),'left'); disp(['Phon cTBS:          ',Report]);end;
        if is_stat; [P.phon_icTBS,VAL.phon_icTBS,M.phon_icTBS,Report,~]=bsliang_stat_singletest([PHON(:,1) PHON(:,2)],[dotlim(1)+1 dotlim(2)+1],[],'right');disp(['Phon iTBS - cTBS:          ',Report]);end
    elseif issham==1
        plot(dotlim(1)+1,PHON(:,1),'o','Color',COL_iTBS_PHON,'MarkerFaceColor',COL_iTBS_PHON);
        plot(dotlim(2)+1,PHON(:,2),'o','Color',COL_Sham,'MarkerFaceColor',COL_Sham);
        plot(dotlim(3)+1,PHON(:,3),'o','Color',COL_cTBS_PHON,'MarkerFaceColor',COL_cTBS_PHON);
    end
    
    
    % 分开tone和phoneme画bar图是为了万一要对两种bars分别赋色，代码见下面：
    %         bars=get(gca,'Children');
    %     if issham==0
    %         iTBS=bars(2);
    %         cTBS=bars(1);
    %     elseif issham==1
    %         iTBS=bars(3);
    %         Sham=bars(2);
    %         cTBS=bars(1);
    %     end
    %     set(iTBS,'EdgeAlpha',0);
    %     if colorr == 1
    %         set(iTBS,'FaceColor',COL_iTBS_TONE)
    %     else
    %         set(iTBS,'FaceColor',COL_iTBS_PHON)
    %     end
    %     set(cTBS,'EdgeAlpha',0)
    %     if colorr ==1
    %         set(cTBS,'FaceColor',COL_cTBS_TONE)
    %     else
    %         set(cTBS,'FaceColor',COL_cTBS_PHON)
    %     end
    %     if issham==1
    %         set(Sham,'EdgeAlpha',0);
    %         set(Sham,'FaceColor',COL_Sham);
    %     end
    
    
    mindata=min([mean(TONE,'omitnan')-3*std(TONE,'omitnan'),mean(PHON,'omitnan')-3*std(PHON,'omitnan'),min(TONE),min(PHON)]);
    maxdata=max([mean(TONE,'omitnan')+3*std(TONE,'omitnan'),mean(PHON,'omitnan')+3*std(PHON,'omitnan'),max(TONE),max(PHON)]);
    rangedata=maxdata-mindata;
    aveargedata=(maxdata+mindata)*0.5;
    ylimm=[aveargedata-0.55*rangedata,aveargedata+0.55*rangedata];
    ylim(ylimm)

    set(gca,'FontSize',15) 
    set(gca,'XTick',[-0.7 0.7]);
    set(gca,'YTick',Ytick);
%     set(gca,'YTickLabels',{'-1.5','-1','-0.75','-0.50','-0.25','0.25','0.50','0.75','1','1.5'});
    ylim(Ylim);
%     set(gca,'XTickLabels',{'Tone','Phon'},'FontSize',20)
    ax = gca;
    ax.YAxisLocation = 'origin';
    box off
    set(gca,'layer','top')
    
    t=0:0:0;
    set(gca,'xtick',t);
    set(gca,'xcolor',[1,1,1]);

end

function [P,VAL,M,Report,h]=bsliang_stat_singletest(data,Xpos,perDISRIBpp,testtail)
% perDISRIBpp=[];
try
    c=size(data,2);
    Ypos = mean(data,'omitnan')+3*std(data,'omitnan');
    % one sample statistics test
    if c==1; h = kstest(data); M = mean(data,'omitnan'); MeanTag='M';d=computeCohen_d(data, 0, 'independent');
    elseif c==2; h(1) = kstest(data(:,1));  h(2) = kstest(data(:,2)); M = mean(data(:,1)-data(:,2),'omitnan'); MeanTag='MD';d=computeCohen_d(data(:,1),data(:,2), 'paired');end
%     disp(['Size', num2str(size(data,1))]);
    if ~isempty(perDISRIBpp) % 存在置换分布，进行置换检验
        sigstar='*';
        [htest,P,VAL] = bsliang_permutationtest(M,squeeze(perDISRIBpp)',0.05,testtail);
        Report=[MeanTag,' = ',num2str(round(M,3)),', rank = ', num2str(VAL),' p = ',num2str(P,3),' Cohen''s d = ',num2str(round(d,3))];
    elseif 0%~sum(h) || size(data,1)>30 % 符合正态分布或大样本
        % normal distributed
        sigstar='*';
        if c==1; [htest,P,~,STATS] = ttest(data,0,'alpha',0.05,'tail',testtail);% ttest Bonferroni adjusted
        elseif c==2; [htest,P,~,STATS] = ttest(data(:,1),data(:,2),'alpha',0.05,'tail',testtail); end
        try
            VAL=STATS.tstat;
        catch
            VAL=nan;
        end
        Report=[MeanTag,' = ',num2str(round(M,2)),', t(',num2str(STATS.df),') = ', num2str(round(STATS.tstat,2)),' p = ',num2str(P,2),' Cohen''s d = ',num2str(round(d,2))];
    else
        sigstar='*';%np';
        if c==1; [P,htest, STATS]= signrank(data,'alpha',0.05,'tail',testtail); % Wilcoxon test % ttest Bonferroni adjusted 
        elseif c==2; [P,htest, STATS]= signrank(data(:,1),data(:,2),'alpha',0.05,'tail',testtail); end
        try
            VAL=STATS.zval;
        catch
            VAL=nan;
        end
        Report=[MeanTag,' = ',num2str(round(M,2)),', Z = ',num2str(VAL),', Signrank = ',num2str(round(STATS.signedrank,2)),', p = ',num2str(P),' Cohen''s d = ',num2str(round(d,2))];
        % 这个ranksum的补0不一定是正确的操作
    end
    if htest
        if P >.01 && P <.05
            sigstar=sigstar;
        elseif P>.001 && P<.01
            sigstar=[sigstar sigstar];
        elseif P<.001
            sigstar=[sigstar sigstar sigstar];
        end
        if c==1; 
%             text(Xpos,Ypos,sigstar,'HorizontalAlignment','center','Color',[0 0 0],'FontSize',20);
        elseif c==2; 
%             plot(Xpos, [max(Ypos) max(Ypos)]+0.2, 'k-');
%             text(mean(Xpos),max(Ypos)+0.7,sigstar,'HorizontalAlignment','center','Color',[0 0 0],'FontSize',20); 
        end 
    end
catch
    P=1;
    VAL=0;
    M=0;
    Report=[]; 
end
end