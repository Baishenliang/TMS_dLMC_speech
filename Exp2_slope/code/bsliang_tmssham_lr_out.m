function [inmat_s_rm_sp_rlr,inmat_s_rm]=bsliang_tmssham_lr_out(TDATA,inmat,LT_ind,outTag,is_rmsd)
 % is_rmsd: 是否去除3SD
 
 % 标准化（△TMS=(rTMS-Sham)/Sham），分左右脑，输出SPSS格式
 % inmat： block(4)*turn(5)*subj(197)
 % LT_ind：larynx tongue index
 % outTag：输出用于SPSS分析的mat文件名
 
 % 输出：inmat_s_rm_sp_rlr - SPSS的格式
 %       inmat_s_rm - 同样的内容，但是没有分开左右脑
 
     % 标准化
     inmat_s=nan(4,size(TDATA,2),size(TDATA,3));
     inmat_s=inmat; % 现在不用标准化
     % 分开左右脑去除2.5个标准差
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
     % 转换成SPSS格式
     % 实验：
     % tutu=[1,2;3,4;5,6;7,8]；
     % tutu=reshape(tutu,1,8)；
     % tutu=1     3     5     7     2     4     6     8
     % 可见是排完第一列再排第二列
     % 4个block（CT CP NT NP），5个turn（Left iTBS   Left cTBS   Right iTBS   Right cTBS Sham）
     inmat_s_rm_sp=reshape(inmat_s_rm,4*(size(TDATA,2)),size(TDATA,3));
     inmat_s_rm_sp=inmat_s_rm_sp';
     % 转换成之前下一步SPSS分析的格式
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
     % 添加larynx和tongue index
     inmat_s_rm_sp_lr=[LT_ind',inmat_s_rm_sp];
     % larynx在上tongue在下，方便后续作图
     inmat_s_rm_sp_rlr=inmat_s_rm_sp_lr(LT_ind==1,:);
     outmat=inmat_s_rm_sp_rlr;
     save(['..',filesep,'data',filesep,outTag],'inmat_s_rm_sp_rlr')
end