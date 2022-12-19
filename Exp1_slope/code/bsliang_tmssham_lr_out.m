function [inmat_s_rm_sp_rlr,inmat_s_rm]=bsliang_tmssham_lr_out(TDATA,inmat,LR_ind,outTag,is_rmsd)
 % is_rmsd: �Ƿ�ȥ��3SD
 
 % ��׼������TMS=(rTMS-Sham)/Sham�����������ԣ����SPSS��ʽ
 % inmat�� block(4)*turn(3)*subj(197)
 % LR_ind��������index
 % outTag���������SPSS������mat�ļ���
 
 % �����inmat_s_rm_sp_rlr - SPSS�ĸ�ʽ
 %       inmat_s_rm - ͬ�������ݣ�����û�зֿ�������
 
     % ��׼��
     inmat_s=nan(4,size(TDATA,2),size(TDATA,3));
     % block(4)*turn(3-1)*subj(197)
%      inmat_s(:,1,:)=(inmat(:,1,:)-inmat(:,3,:))./abs(inmat(:,3,:));
%      inmat_s(:,2,:)=(inmat(:,2,:)-inmat(:,3,:))./abs(inmat(:,3,:));
%      inmat_s(:,1,:)=inmat(:,1,:)./inmat(:,3,:);
%      inmat_s(:,2,:)=inmat(:,2,:)./inmat(:,3,:);
     inmat_s=inmat; % ���ڲ��ñ�׼��
     % �ֿ�������ȥ��2.5����׼��
     inmat_s_rm=inmat_s;
     if is_rmsd
%          cd(['..',filesep,'..',filesep,'10_3_4_bsliang_calculatedDATA']);
         for block=1:4
             for turn=1:size(TDATA,2)
                 L_ind=LR_ind==1;
                 R_ind=LR_ind==2;
                 % ���������������Եķ�����ԭ������һ��������
                 % ������ֱ���õ�ԭ�������ȥ��2.5sd�Ĵ��롿����
                 [inmat_s_rm(block,turn,L_ind),errind]=bsliang_rmoutlier3sd(inmat_s(block,turn,L_ind));
                 disp(['BLOCK',num2str(block),'TURN',num2str(turn),errind]);
                 [inmat_s_rm(block,turn,R_ind),errind]=bsliang_rmoutlier3sd(inmat_s(block,turn,R_ind));
                 disp(['BLOCK',num2str(block),'TURN',num2str(turn),errind]);
             end
         end
%          cd(['..',filesep,'10_3_4_bsliang_recalculateDATA',filesep,'code']);
     end
     % ת����SPSS��ʽ
     % ʵ�飺
     % tutu=[1,2;3,4;5,6;7,8]��
     % tutu=reshape(tutu,1,8)��
     % tutu=1     3     5     7     2     4     6     8
     % �ɼ��������һ�����ŵڶ���
     inmat_s_rm_sp=reshape(inmat_s_rm,4*(size(TDATA,2)),size(TDATA,3));
     inmat_s_rm_sp=inmat_s_rm_sp';
     % LTC LPC LTN LPN TTC TPC TTN TPN STC SPC STN SPN
     % ת����֮ǰ��һ��SPSS�����ĸ�ʽ
     CLT=inmat_s_rm_sp(:,1);
     CLP=inmat_s_rm_sp(:,2);
     NLT=inmat_s_rm_sp(:,3);
     NLP=inmat_s_rm_sp(:,4);
     CTT=inmat_s_rm_sp(:,5);
     CTP=inmat_s_rm_sp(:,6);
     NTT=inmat_s_rm_sp(:,7);
     NTP=inmat_s_rm_sp(:,8);
     CST=inmat_s_rm_sp(:,9);
     CSP=inmat_s_rm_sp(:,10);
     NST=inmat_s_rm_sp(:,11);
     NSP=inmat_s_rm_sp(:,12);
     
%      S=nan(length(CLT),1);
     inmat_s_rm_sp=[CLT,CLP,CTT,CTP,CST,CSP,NLT,NLP,NTT,NTP,NST,NSP];
     inmat_s_rm_sp(isnan(inmat_s_rm_sp))=bsliang_numNAN;
     % ���������index
     inmat_s_rm_sp_lr=[LR_ind',inmat_s_rm_sp];
     % ���������������£����������ͼ
     inmat_s_rm_sp_rlr=[inmat_s_rm_sp_lr(LR_ind==1,:);inmat_s_rm_sp_lr(LR_ind==2,:)];
     outmat=inmat_s_rm_sp_rlr;
%      save(['..',filesep,'data',filesep,outTag],'inmat_s_rm_sp_rlr')
end