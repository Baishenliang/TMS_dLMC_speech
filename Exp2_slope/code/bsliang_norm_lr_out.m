function [inmat_s_rm_sp_rlr,inmat_s_rm]=bsliang_norm_lr_out(TDATA,inmat,LT_ind,outTag,is_rmsd,is_abs,is_norm)
 % is_rmsd: �Ƿ�ȥ��3SD

 % ��׼������TMS=(rTMS-Sham)/|Sham|������larynx��tongue�����SPSS��ʽ
 % inmat�� block(4)*turn(5)*subj(197)
 % LT_ind��Larynx Tongue index
 % outTag���������SPSS������mat�ļ���
 % is_abs���Ƿ�ȡ(rTMS-Sham)����ֵ������ָʾ������ָʾ����
 % is_norm���Ƿ��Sham����ֵ
 
 % �����inmat_s_rm_sp_rlr - SPSS�ĸ�ʽ
 %       inmat_s_rm - ͬ�������ݣ�����û�зֿ��������ಿ��
 
     % ��׼��
     

    
    %  turn��
    %   stimSITE   NUMBER
    %   Left iTBS    1
    %   Left cTBS    2
    %   Right iTBS   3
    %   Right cTBS   4
    %   Sham         5 
    
     inmat_s=nan(4,size(TDATA,2)-1,size(TDATA,3));
     % block(4)*turn(5-1)*subj(197)
     inmat_s(:,1,:)=inmat(:,1,:)-inmat(:,5,:);
     inmat_s(:,2,:)=inmat(:,2,:)-inmat(:,5,:);
     inmat_s(:,3,:)=inmat(:,3,:)-inmat(:,5,:);
     inmat_s(:,4,:)=inmat(:,4,:)-inmat(:,5,:);
     if is_abs
         out_abs='_abs';
         inmat_s(:,1,:)=abs(inmat_s(:,1,:));
         inmat_s(:,2,:)=abs(inmat_s(:,2,:));
         inmat_s(:,3,:)=abs(inmat_s(:,3,:));
         inmat_s(:,4,:)=abs(inmat_s(:,4,:));
     else
         out_abs='';
     end
     if is_norm
         out_norm='_nrm';
         inmat_s(:,1,:)=inmat_s(:,1,:)./abs(inmat(:,5,:));
         inmat_s(:,2,:)=inmat_s(:,2,:)./abs(inmat(:,5,:));
         inmat_s(:,3,:)=inmat_s(:,3,:)./abs(inmat(:,5,:));
         inmat_s(:,4,:)=inmat_s(:,4,:)./abs(inmat(:,5,:));
     else
         out_norm='';
     end
     outTag=[outTag,out_abs,out_norm];
     
%      inmat_s(:,1,:)=inmat(:,1,:)./inmat(:,3,:);
%      inmat_s(:,2,:)=inmat(:,2,:)./inmat(:,3,:);
     % �ֿ�Larynxȥ��2.5����׼��
     inmat_s_rm=inmat_s;
     if is_rmsd
         cd(['..',filesep,'..',filesep,'..',filesep,'11_TMSEXP_2020',filesep,'10_3_4_bsliang_calculatedDATA']);
         for block=1:4
             for turn=1:size(TDATA,2)-1
                 L_ind=LT_ind==1;
                 % ���������������Եķ�����ԭ������һ��������
                 % ������ֱ���õ�ԭ�������ȥ��2.5sd�Ĵ��롿����
                 [inmat_s_rm(block,turn,L_ind),errind]=bsliang_rmoutlier3sd(inmat_s(block,turn,L_ind));
                 disp(['BLOCK',num2str(block),'TURN',num2str(turn),errind]);
             end
         end
         cd(['..',filesep,'..',filesep,'12_TBSEXP_2021',filesep,'10_3_4_bsliang_recalculateDATA',filesep,'code']);
     end
     % ת����SPSS��ʽ
     % ʵ�飺
     % tutu=[1,2;3,4;5,6;7,8]��
     % tutu=reshape(tutu,1,8)��
     % tutu=1     3     5     7     2     4     6     8
     % �ɼ��������һ�����ŵڶ���
     % 4��block��CT CP NT NP����4��turn��Left iTBS   Left cTBS   Right iTBS   Right cTBS��
     inmat_s_rm_sp=reshape(inmat_s_rm,4*(size(TDATA,2)-1),size(TDATA,3));
     inmat_s_rm_sp=inmat_s_rm_sp';
     % CT CP NT NP
     % ת����֮ǰ��һ��SPSS�����ĸ�ʽ
     Li_CT=inmat_s_rm_sp(:,1);
     Li_CP=inmat_s_rm_sp(:,2);
     Li_NT=inmat_s_rm_sp(:,3);
     Li_NP=inmat_s_rm_sp(:,4);
     Lc_CT=inmat_s_rm_sp(:,5);
     Lc_CP=inmat_s_rm_sp(:,6);
     Lc_NT=inmat_s_rm_sp(:,7);
     Lc_NP=inmat_s_rm_sp(:,8);
     Ri_CT=inmat_s_rm_sp(:,9);
     Ri_CP=inmat_s_rm_sp(:,10);
     Ri_NT=inmat_s_rm_sp(:,11);
     Ri_NP=inmat_s_rm_sp(:,12);
     Rc_CT=inmat_s_rm_sp(:,13);
     Rc_CP=inmat_s_rm_sp(:,14);
     Rc_NT=inmat_s_rm_sp(:,15);
     Rc_NP=inmat_s_rm_sp(:,16);
     S=nan(length(Rc_NP),1);
     inmat_s_rm_sp=[Li_CT Li_CP Lc_CT Lc_CP Ri_CT Ri_CP Rc_CT Rc_CP S S Li_NT Li_NP Lc_NT Lc_NP Ri_NT Ri_NP Rc_NT Rc_NP S S];
     inmat_s_rm_sp(isnan(inmat_s_rm_sp))=bsliang_numNAN;
     % ���larynx��tongue index
     inmat_s_rm_sp_lr=[LT_ind',inmat_s_rm_sp];
     inmat_s_rm_sp_rlr=inmat_s_rm_sp_lr(LT_ind==1,:);
     outmat=inmat_s_rm_sp_rlr;
     save(['..',filesep,'data',filesep,outTag],'inmat_s_rm_sp_rlr')
end