function [inmat_s_rm_sp_rlr,inmat_s_rm]=bsliang_tmssham_lr_out(TDATA,inmat,LT_ind,outTag,is_rmsd)
 % is_rmsd: �Ƿ�ȥ��3SD
 
 % ��׼������TMS=(rTMS-Sham)/Sham�����������ԣ����SPSS��ʽ
 % inmat�� block(4)*turn(5)*subj(197)
 % LT_ind��larynx tongue index
 % outTag���������SPSS������mat�ļ���
 
 % �����inmat_s_rm_sp_rlr - SPSS�ĸ�ʽ
 %       inmat_s_rm - ͬ�������ݣ�����û�зֿ�������
 
     % ��׼��
     inmat_s=nan(4,size(TDATA,2),size(TDATA,3));
     inmat_s=inmat; % ���ڲ��ñ�׼��
     % �ֿ�������ȥ��2.5����׼��
     inmat_s_rm=inmat_s;
     if is_rmsd
         cd(['..',filesep,'..',filesep,'..',filesep,'11_TMSEXP_2020',filesep,'10_3_4_bsliang_calculatedDATA']);
         for block=1:4
             for turn=1:size(TDATA,2)
                 L_ind=LT_ind==1;
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
     % 4��block��CT CP NT NP����5��turn��Left iTBS   Left cTBS   Right iTBS   Right cTBS Sham��
     inmat_s_rm_sp=reshape(inmat_s_rm,4*(size(TDATA,2)),size(TDATA,3));
     inmat_s_rm_sp=inmat_s_rm_sp';
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
     S_CT=inmat_s_rm_sp(:,17);
     S_CP=inmat_s_rm_sp(:,18);
     S_NT=inmat_s_rm_sp(:,19);
     S_NP=inmat_s_rm_sp(:,20);
     inmat_s_rm_sp=[Li_CT Li_CP Lc_CT Lc_CP Ri_CT Ri_CP Rc_CT Rc_CP S_CT S_CP Li_NT Li_NP Lc_NT Lc_NP Ri_NT Ri_NP Rc_NT Rc_NP S_NT S_NP];
     inmat_s_rm_sp(isnan(inmat_s_rm_sp))=bsliang_numNAN;
     % ���larynx��tongue index
     inmat_s_rm_sp_lr=[LT_ind',inmat_s_rm_sp];
     % larynx����tongue���£����������ͼ
     inmat_s_rm_sp_rlr=inmat_s_rm_sp_lr(LT_ind==1,:);
     outmat=inmat_s_rm_sp_rlr;
     save(['..',filesep,'data',filesep,outTag],'inmat_s_rm_sp_rlr')
end