function bsliang_rawplot_conds(IDraw_G,subj_ind)
% subj_ind: 选择被试的编号
% 根据条件画出raw曲线的图（均值和标准误），直观进行比较，同时也是为了验证模型拟合的结果
% IDraw_G
% step(5)*block(4)*turn(3)*subjs

%  turn：
%   stimSITE   NUMBER
%   Left iTBS    1
%   Left cTBS    2
%   Right iTBS   3
%   Right cTBS   4
%   Sham         5 

% block：
%   BLOCK	NAME        NUMBER
%   A       T_CLEAR_ID      1
%   B       P_CLEAR_ID      2
%   C       T_NOISE_ID      3
%   D       P_NOISE_ID      4

% 注意figure的subplot是横着来的

% LEFT CLEAR TONE
FigPAR(1).blocks=1;
FigPAR(1).turns=[1 2 5];
% LEFT CLEAR PHON
FigPAR(2).blocks=2;
FigPAR(2).turns=[1 2 5];
% RIGHT CLEAR TONE
FigPAR(3).blocks=1;
FigPAR(3).turns=[3 4 5];
% RIGHT CLEAR PHON
FigPAR(4).blocks=2;
FigPAR(4).turns=[3 4 5];
% LEFT CLEAR TONE
FigPAR(5).blocks=3;
FigPAR(5).turns=[1 2 5];
% LEFT CLEAR PHON
FigPAR(6).blocks=4;
FigPAR(6).turns=[1 2 5];
% RIGHT CLEAR TONE
FigPAR(7).blocks=3;
FigPAR(7).turns=[3 4 5];
% RIGHT CLEAR PHON
FigPAR(8).blocks=4;
FigPAR(8).turns=[3 4 5];

FigTIT={'LEFT CLEAR TONE','LEFT CLEAR PHON','RIGHT CLEAR TONE','RIGHT CLEAR PHON','LEFT NOISE TONE','LEFT NOISE PHON','RIGHT NOISE TONE','RIGHT NOISE PHON'};

COL_iTBS_TONE=[0 112 192]/255;
COL_iTBS_PHON=[237 125 49]/255;
COL_cTBS_TONE=[189 215 238]/255;
COL_cTBS_PHON=[248 203 173]/255;
COL_Sham=[0.8 0.8 0.8];
    
figure;
for p=1:8
    subplot(2,4,p)
    sub_IDraw_G=IDraw_G(:,FigPAR(p).blocks,FigPAR(p).turns,subj_ind);
    iTBS=squeeze(sub_IDraw_G(:,:,1,:));
    cTBS=squeeze(sub_IDraw_G(:,:,2,:));
    Sham=squeeze(sub_IDraw_G(:,:,3,:));
    iTBSM=mean(iTBS,2,'omitnan');
    cTBSM=mean(cTBS,2,'omitnan');
    ShamM=mean(Sham,2,'omitnan');
    iTBSE=std(iTBS,0,2,'omitnan')./sqrt(bsliang_nonemptycol(iTBS));
    cTBSE=std(cTBS,0,2,'omitnan')./sqrt(bsliang_nonemptycol(cTBS));
    ShamE=std(Sham,0,2,'omitnan')./sqrt(bsliang_nonemptycol(Sham));
%     raw{1}=plot(1:size(sub_IDraw_G,1),iTBS,'Color',[0.9 0.6 0.6]);
%     hold on
%     raw{2}=plot(1:size(sub_IDraw_G,1),cTBS,'Color',[0.6 0.9 0.6]);
%     raw{3}=plot(1:size(sub_IDraw_G,1),Sham,'Color',[0.6 0.6 0.9]);
%     legend(raw{3},{'iTBSraw','cTBSraw','Shamraw'});

    % 1 3 5 7: Tone
    % 2 4 6 8: Phon
    if mod(p,2)%Tone
        COL_iTBS=COL_iTBS_TONE;
        COL_cTBS=COL_cTBS_TONE;
    else %Phon
        COL_iTBS=COL_iTBS_PHON;
        COL_cTBS=COL_cTBS_PHON;
    end
    errorbar(1:size(sub_IDraw_G,1),ShamM,ShamE,'Color',COL_Sham);
    hold on
    errorbar(1:size(sub_IDraw_G,1),iTBSM,iTBSE,'Color',COL_iTBS);
    errorbar(1:size(sub_IDraw_G,1),cTBSM,cTBSE,'Color',COL_cTBS);
    plot(1:size(sub_IDraw_G,1),ShamM,'Color',COL_Sham,'LineWidth',1.5);
    plot(1:size(sub_IDraw_G,1),iTBSM,'Color',COL_iTBS,'LineWidth',1.5);
    plot(1:size(sub_IDraw_G,1),cTBSM,'Color',COL_cTBS,'LineWidth',1.5);
    legend('Sham','iTBS','cTBS');
    set(gca,'XTick',1:5);
    ylim([0 1]);
%     HE=errorbar(repmat(1:size(sub_IDraw_G,1),3,1)',[iTBSM,cTBSM,ShamM],[iTBSE,cTBSE,ShamE]);
    title(FigTIT{p});
    box off
end