function [Pss_single,Pss_compare,Hss_single,Dss_single,Dss_compare]=bsliang_CNLRplots_re(data_in,issham,rmnan,perDISRIB,data_in_mask)
    % issham == 1, add sham, larynx tongue sham
    % issham == 0. dont add sham, usually larynx=larynx-sham, tongue=tongue-sham
    
    data=data_in(:,2:end);
    data_mask=data_in_mask(:,2:end);
    LR_ind=data_in(:,1);
    
    addpath('global');
    
    %% load data
    if rmnan
    data(data==bsliang_numNAN)=nan;
    end
    
    CLT=data(:,1); CLP=data(:,2); CTT=data(:,3); CTP=data(:,4); CST=data(:,5); CSP=data(:,6);
    NLT=data(:,7); NLP=data(:,8); NTT=data(:,9); NTP=data(:,10); NST=data(:,11); NSP=data(:,12);
    
    if ~isempty(data_mask)
        CLT_mask=data_mask(:,1); CLP_mask=data_mask(:,2); CTT_mask=data_mask(:,3);
        CTP_mask=data_mask(:,4); CST_mask=data_mask(:,5); CSP_mask=data_mask(:,6);
        NLT_mask=data_mask(:,7); NLP_mask=data_mask(:,8); NTT_mask=data_mask(:,9);
        NTP_mask=data_mask(:,10); NST_mask=data_mask(:,11); NSP_mask=data_mask(:,12);
    end
    
%     load('..\..\1_SPSS_stat\lenLR')
%     L_ind=1:lenLR.left;
%     R_ind=lenLR.left+1:lenLR.left+lenLR.right;
    L_ind=LR_ind==1;
    R_ind=LR_ind==2;
    
    Pss_single=nan(4,4);
    Dss_single=nan(4,4);
    Hss_single=nan(4,4);
    Pss_compare=nan(4,2);
    Dss_compare=nan(4,2);

    
    %% plots: not sham
    if issham==0
        dotlim=[0.3125 0.6875] - 1;
        [ha, ~] = tight_subplot(2, 2,[.15 .04],[.1 .07],[.03 .03]);
        set(gcf,'color','w');
        set(gcf,'unit','centimeter')
        set(gcf,'Position',[0 0 17.4 15])

        % left clear
        disp('=============Left Clear==================')
%         subplot(2,2,1)
        axes(ha(1))
        TONE=[CLT(L_ind),CTT(L_ind)];
        PHONEME=[CLP(L_ind),CTP(L_ind)];
        if ~isempty(data_mask)
            TONE_mask=[CLT_mask(L_ind),CTT_mask(L_ind)];
            PHONEME_mask=[CLP_mask(L_ind),CTP_mask(L_ind)];
        else
            TONE_mask=[]; PHONEME_mask=[];
        end
        [Pss_single(1,:),Pss_compare(1,:),Hss_single(1,:),Dss_single(1,:),Dss_compare(1,:)]=bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,issham,perDISRIB([1 2],:,1,:),TONE_mask,PHONEME_mask);
%         title('Left Quiet','FontSize',15,'FontName','Arial');

        % right clear
        disp('=============Right Clear==================')
%         subplot(2,2,2)
        axes(ha(2))
        TONE=[CLT(R_ind),CTT(R_ind)];
        PHONEME=[CLP(R_ind),CTP(R_ind)];
        if ~isempty(data_mask)
            TONE_mask=[CLT_mask(R_ind),CTT_mask(R_ind)];
            PHONEME_mask=[CLP_mask(R_ind),CTP_mask(R_ind)];
        else
            TONE_mask=[]; PHONEME_mask=[];
        end
        [Pss_single(2,:),Pss_compare(2,:),Hss_single(2,:),Dss_single(2,:),Dss_compare(2,:)]=bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,issham,perDISRIB([1 2],:,2,:),TONE_mask,PHONEME_mask);
%         title('Right Quiet','FontSize',15,'FontName','Arial');

        % left noise
        disp('=============Left Noise==================')
%         subplot(2,2,3)
        axes(ha(3))
        TONE=[NLT(L_ind),NTT(L_ind)];
        PHONEME=[NLP(L_ind),NTP(L_ind)];
        if ~isempty(data_mask)
            TONE_mask=[NLT_mask(L_ind),NTT_mask(L_ind)];
            PHONEME_mask=[NLP_mask(L_ind),NTP_mask(L_ind)];
        else
            TONE_mask=[]; PHONEME_mask=[];
        end        
        [Pss_single(3,:),Pss_compare(3,:),Hss_single(3,:),Dss_single(3,:),Dss_compare(3,:)]=bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,issham,perDISRIB([3 4],:,1,:),TONE_mask,PHONEME_mask);
%         title('Left Noise','FontSize',15,'FontName','Arial');

        % right noise
        disp('=============Right Noise==================')
%         subplot(2,2,4)
        axes(ha(4))
        TONE=[NLT(R_ind),NTT(R_ind)];
        PHONEME=[NLP(R_ind),NTP(R_ind)];
        if ~isempty(data_mask)
            TONE_mask=[NLT_mask(R_ind),NTT_mask(R_ind)];
            PHONEME_mask=[NLP_mask(R_ind),NTP_mask(R_ind)];
        else
            TONE_mask=[]; PHONEME_mask=[];
        end
        [Pss_single(4,:),Pss_compare(4,:),Hss_single(4,:),Dss_single(4,:),Dss_compare(4,:)]=bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,issham,perDISRIB([3 4],:,2,:),TONE_mask,PHONEME_mask);
%         title('Right Noise','FontSize',15,'FontName','Arial');
    end
    %% plots: include sham
    if issham==1
        dotlim=[0.775 1 1.225] - 1.5;
        figure;
        set(gcf,'color','w');
        % left clear
        subplot(2,2,1)
        TONE=[CLT(L_ind),CST(L_ind),CTT(L_ind)];
        PHONEME=[CLP(L_ind),CSP(L_ind),CTP(L_ind)];
        bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,issham);
%         title('Left Clear','FontSize',20);

        % right clear
        subplot(2,2,2)
        TONE=[CLT(R_ind),CST(R_ind),CTT(R_ind)];
        PHONEME=[CLP(R_ind),CSP(R_ind),CTP(R_ind)];
        bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,issham);
%         title('Right Clear','FontSize',20);


        % left noise
        subplot(2,2,3)
        TONE=[NLT(L_ind),NST(L_ind),NTT(L_ind)];
        PHONEME=[NLP(L_ind),NSP(L_ind),NTP(L_ind)];
        bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,issham);
%         title('Left Noise','FontSize',20);


        % right noise
        subplot(2,2,4)
        TONE=[NLT(R_ind),NST(R_ind),NTT(R_ind)];
        PHONEME=[NLP(R_ind),NSP(R_ind),NTP(R_ind)];
        bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,issham);
%         title('Right Noise','FontSize',20);

    end
end

function [Ps_single,Ps_compare,Hs_single,Ds_single,Ds_compare]=bsliang_CNLRsingleplot(TONE,PHON,dotlim,issham,perDISRIBp,TONE_mask,PHON_mask)
 TONE_mask=[]; PHON_mask=[];
Ylim=[-5 5];
%% COLORS

    % 每幅图：
    % ==============================================
    %    Tone Larynx|Tongue  ||   Phon Larynx|Tongue
    % ==============================================
    
%     COL_Larynx_TONE=[0 112 192]/255;
%     COL_Larynx_PHON=[237 125 49]/255;
%     COL_Tongue_TONE=[189 215 238]/255;
%     COL_Tongue_PHON=[248 203 173]/255;
    COL_Larynx_TONE=[197 158 226]/255;
    COL_Larynx_PHON=[197 158 226]/255;
    COL_Tongue_TONE=[255 255 255]/255;
    COL_Tongue_PHON=[255 255 255]/255;    
    COL_Sham=[0.8 0.8 0.8];
    
    TONEmean=mean(TONE,1,'omitnan');
    PHONmean=mean(PHON,1,'omitnan');
    
    Ps_single=nan(1,4);
    Ds_single=nan(1,4);
    Ps_compare=nan(1,2);
    Ds_compare=nan(1,4);
    
    Hs_single=nan(1,4);
    
%     area([-1 0],[Ylim(2),Ylim(2)],'basevalue',Ylim(1),'FaceColor',[189 215 238]/255);
    area([-1 0],[Ylim(2),Ylim(2)],'basevalue',Ylim(1),'FaceColor',[222 235 246]/255,'EdgeColor',[222 235 246]/255);
        hold on
%     area([0 1],[Ylim(2),Ylim(2)],'basevalue',Ylim(1),'FaceColor',[248 203 173]/255);
    area([0 1],[Ylim(2),Ylim(2)],'basevalue',Ylim(1),'FaceColor',[252 233 220]/255,'EdgeColor',[252 233 220]/255);
    
%     bar(-0.5:1:0.5,[TONEmean;zeros(size(TONEmean,1),size(TONEmean,2))],1,'FaceColor',[1 1 1],'EdgeColor',[0 0 0]);
    bsliang_piledbar([TONEmean,PHONmean]);
    
    hold on
    
    plot(dotlim,TONE,'-','Color',[0.4 0.4 0.4]);
    if issham==0
        plot(dotlim(1),TONE(:,1),'o','Color',[0 0 0],'MarkerFaceColor',COL_Larynx_TONE);
        if ~isempty(TONE_mask) && sum(TONE_mask(:,1)==1); plot(dotlim(1),TONE(TONE_mask(:,1)==1,1),'o','Color',[1 0 0],'MarkerFaceColor',[1 0 0]);end
        plot(dotlim(2),TONE(:,2),'o','Color',[0 0 0],'MarkerFaceColor',COL_Tongue_TONE);
        if ~isempty(TONE_mask) && sum(TONE_mask(:,2)==1); plot(dotlim(2),TONE(TONE_mask(:,2)==1,2),'o','Color',[1 0 0],'MarkerFaceColor',[1 0 0]);end
        [Report,Ps_single(1),Hs_single(1),Ds_single(1)]=bsliang_stat_singletest(TONE(:,1),dotlim(1),perDISRIBp(1,1,:),'left');
        % 因为目前只能输出Wilcoxon的，因为都是非正态
        disp(['Tone Larynx:          ',Report]);
        [Report,Ps_single(2),Hs_single(2),Ds_single(2)]=bsliang_stat_singletest(TONE(:,2),dotlim(2),perDISRIBp(1,2,:),'left');
        disp(['Tone Tongue:          ',Report]);
        [Report,Ps_compare(1),~,Ds_compare(1)]=bsliang_stat_singletest([TONE(:,1) TONE(:,2)],[dotlim(1) dotlim(2)],[],'left');
        disp(['Tone Larynx - Tongue: ',Report]);
    elseif issham==1
        plot(dotlim(1),TONE(:,1),'o','Color',COL_Larynx_TONE,'MarkerFaceColor',COL_Larynx_TONE);
        plot(dotlim(2),TONE(:,2),'o','Color',COL_Sham,'MarkerFaceColor',COL_Sham);
        plot(dotlim(3),TONE(:,3),'o','Color',COL_Tongue_TONE,'MarkerFaceColor',COL_Tongue_TONE);
    end
    
%     bar(-0.5:1:0.5,[zeros(size(PHONmean,1),size(PHONmean,2));PHONmean],1,'FaceColor',[1 1 1],'EdgeColor',[0 0 0]);
  
    plot(dotlim+1,PHON,'-','Color',[0.4 0.4 0.4]);
    if issham==0
        plot(dotlim(1)+1,PHON(:,1),'o','Color',[0 0 0],'MarkerFaceColor',COL_Larynx_PHON);
        if ~isempty(PHON_mask) && sum(PHON_mask(:,1)==1); plot(dotlim(1)+1,PHON(PHON_mask(:,1)==1,1),'o','Color',[1 0 0],'MarkerFaceColor',[1 0 0]);end
        plot(dotlim(2)+1,PHON(:,2),'o','Color',[0 0 0],'MarkerFaceColor',COL_Tongue_PHON);
        if ~isempty(PHON_mask) && sum(PHON_mask(:,2)==1); plot(dotlim(2)+1,PHON(PHON_mask(:,2)==1,2),'o','Color',[1 0 0],'MarkerFaceColor',[1 0 0]);end
        [Report,Ps_single(3),Hs_single(3),Ds_single(3)]=bsliang_stat_singletest(PHON(:,1),dotlim(1)+1,perDISRIBp(2,1,:),'left');
        disp(['Phon Larynx:          ',Report]);
        [Report,Ps_single(4),Hs_single(4),Ds_single(4)]=bsliang_stat_singletest(PHON(:,2),dotlim(2)+1,perDISRIBp(2,2,:),'left');
        disp(['Phon Tongue:          ',Report]);
        [Report,Ps_compare(2),~,Ds_compare(2)]=bsliang_stat_singletest([PHON(:,1) PHON(:,2)],[dotlim(1)+1 dotlim(2)+1],[],'left');
        disp(['Phon Larynx - Tongue: ',Report]);
    elseif issham==1
        plot(dotlim(1)+1,PHON(:,1),'o','Color',COL_Larynx_PHON,'MarkerFaceColor',COL_Larynx_PHON);
        plot(dotlim(2)+1,PHON(:,2),'o','Color',COL_Sham,'MarkerFaceColor',COL_Sham);
        plot(dotlim(3)+1,PHON(:,3),'o','Color',COL_Tongue_PHON,'MarkerFaceColor',COL_Tongue_PHON);
    end
    
    
    % 分开tone和phoneme画bar图是为了万一要对两种bars分别赋色，代码见下面：
    %         bars=get(gca,'Children');
    %     if issham==0
    %         Larynx=bars(2);
    %         Tongue=bars(1);
    %     elseif issham==1
    %         Larynx=bars(3);
    %         Sham=bars(2);
    %         Tongue=bars(1);
    %     end
    %     set(Larynx,'EdgeAlpha',0);
    %     if colorr == 1
    %         set(Larynx,'FaceColor',COL_Larynx_TONE)
    %     else
    %         set(Larynx,'FaceColor',COL_Larynx_PHON)
    %     end
    %     set(Tongue,'EdgeAlpha',0)
    %     if colorr ==1
    %         set(Tongue,'FaceColor',COL_Tongue_TONE)
    %     else
    %         set(Tongue,'FaceColor',COL_Tongue_PHON)
    %     end
    %     if issham==1
    %         set(Sham,'EdgeAlpha',0);
    %         set(Sham,'FaceColor',COL_Sham);
    %     end
    
    try
        mindata=min([mean(TONE,'omitnan')-3*std(TONE,'omitnan'),mean(PHON,'omitnan')-3*std(PHON,'omitnan'),min(TONE),min(PHON)]);
        maxdata=max([mean(TONE,'omitnan')+3*std(TONE,'omitnan'),mean(PHON,'omitnan')+3*std(PHON,'omitnan'),max(TONE),max(PHON)]);
        rangedata=maxdata-mindata;
        aveargedata=(maxdata+mindata)*0.5;
        ylimm=[aveargedata-0.55*rangedata,aveargedata+0.6*rangedata];
        ylim(ylimm)
    catch
        ylim([-1 1])
    end

    set(gca,'FontSize',12) 
    set(gca,'FontName','Arial') 
    set(gca,'XTick',[-0.5 0.5])
    set(gca,'XTickLabel',{});
    set(gca,'YTick',[-5 -4 -3 -2 -1 1 2 3 4 5]);
%     set(gca,'YTick',[-1.4 -1.0 -0.6 -0.2 0.2 0.6 1 1.4])
%     set(gca,'YTickLabels',{'-14','-10','-6','-2','2','6','10','14'});
    ylim(Ylim);
%     set(gca,'XTickLabels',{'Tone','Consonant'},'FontSize',15,'FontName','Arial','FontColor','k')
    ax = gca; % Get handles to axis.
    ax.YAxisLocation = 'origin';
    box off
    set(gca,'layer','top')
    t=0:0:0;
    set(gca,'xtick',t);
    set(gca,'xcolor',[1,1,1]);
    

end

function [Report,P,h,d]=bsliang_stat_singletest(data,Xpos,perDISRIBpp,testtail)
%      perDISRIBpp=[];
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
        Report=[MeanTag,' = ',num2str(round(M,3)),', t(',num2str(STATS.df),') = ', num2str(round(STATS.tstat,3)),' p = ',num2str(P,3),' Cohen''s d = ',num2str(round(d,3))];
    else
        sigstar='*';%np';
        if c==1; [P,htest, STATS]= signrank(data,'alpha',0.05,'tail',testtail); % Wilcoxon test % ttest Bonferroni adjusted 
        elseif c==2; [P,htest, STATS]= signrank(data(:,1),data(:,2),'alpha',0.05,'tail',testtail); end
        try
            VAL=STATS.zval;
        catch
            VAL=nan;
        end
        Report=[MeanTag,' = ',num2str(round(M,3)),', Z = ',num2str(VAL),', Ranksum = ',num2str(round(STATS.signedrank,3)),', p = ',num2str(P),' Cohen''s d = ',num2str(round(d,3))];
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
            %text(Xpos,Ypos,sigstar,'HorizontalAlignment','center','Color',[0 0 0],'FontSize',20);
        elseif c==2
%             plot(Xpos, [max(Ypos) max(Ypos)]+0.5, 'k-');  % 加了的话就是画一条黑色横线
            %text(mean(Xpos),max(Ypos)+1,sigstar,'HorizontalAlignment','center','Color',[0 0 0],'FontSize',20); 
        end 
    end
end
    
    
% 2020版很丑很丑的作图代码
% function bsliang_CNLRsingleplot(TONE,PHONEME,dotlim,colorr,issham)
% %% COLORS
% 
%     COL_Larynx_TONE=[0 112 192]/255;
%     COL_Larynx_PHON=[237 125 49]/255;
%     COL_Tongue_TONE=[189 215 238]/255;
%     COL_Tongue_PHON=[248 203 173]/255;
%     COL_Sham=[0.8 0.8 0.8];
%     
% %% 单幅图
%     TONEmean=mean(TONE,1,'omitnan');
%     PHONEMEmean=mean(PHONEME,1,'omitnan');
%     bar(1:2,[TONEmean;PHONEMEmean],1);
%     
%     mindata=min(min([TONE;PHONEME]));
%     maxdata=max(max([TONE;PHONEME]));
%     rangedata=maxdata-mindata;
%     aveargedata=(maxdata+mindata)*0.5;
%     ylimm=[aveargedata-0.55*rangedata,aveargedata+0.55*rangedata];
% %     if ylimm(1)<0
% %         ylimm(1)=0;
% %     end
%     
%     hold on
% %     dotlim=[0.775 1 1.225];
% 
%     set(gca,'FontSize',15) 
%     set(gca,'XTickLabels',{'声调','声母'},'FontSize',20)
% %     ylabel('RT');
%     box off
%     bars=get(gca,'Children');
%     if issham==0
%         Larynx=bars(2);
%         Tongue=bars(1);
%     elseif issham==1
%         Larynx=bars(3);
%         Sham=bars(2);
%         Tongue=bars(1);
%     end
%     set(Larynx,'EdgeAlpha',0);
%     if colorr == 1
%         set(Larynx,'FaceColor',COL_Larynx_TONE)
%     else
%         set(Larynx,'FaceColor',COL_Larynx_PHON)
%     end
%     set(Tongue,'EdgeAlpha',0)
%     if colorr ==1
%         set(Tongue,'FaceColor',COL_Tongue_TONE)
%     else
%         set(Tongue,'FaceColor',COL_Tongue_PHON)
%     end
%     if issham==1
%         set(Sham,'EdgeAlpha',0);
%         set(Sham,'FaceColor',COL_Sham);
%     end
% 
%     plot(dotlim,TONE,'ko');
%     plot(dotlim,TONE,'k-');
% 
%     plot(dotlim+1,PHONEME,'ko');
%     plot(dotlim+1,PHONEME,'k-');
%     
%     ylim(ylimm)
% 
% end