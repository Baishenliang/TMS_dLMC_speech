function bsliang_processrawsham(in_mat,AMB)
%% preprocess
in_mat(in_mat==bsliang_numNAN)=nan;

%% get data
S_CT=in_mat(:,6);
S_CP=in_mat(:,7);
S_NT=in_mat(:,12);
S_NP=in_mat(:,13);

%% remove outliers
[S_CT_rm]=bsliang_rmoutlier3sd_rawsham(S_CT);
[S_CP_rm]=bsliang_rmoutlier3sd_rawsham(S_CP);
[S_NT_rm]=bsliang_rmoutlier3sd_rawsham(S_NT);
[S_NP_rm]=bsliang_rmoutlier3sd_rawsham(S_NP);

%% calculate
S_CT_repval=exp(mean(S_CT_rm,'omitnan')-2*std(S_CT_rm,'omitnan'));
S_CP_repval=exp(mean(S_CP_rm,'omitnan')-2*std(S_CP_rm,'omitnan'));
S_NT_repval=exp(mean(S_NT_rm,'omitnan')-2*std(S_NT_rm,'omitnan'));
S_NP_repval=exp(mean(S_NP_rm,'omitnan')-2*std(S_NP_rm,'omitnan'));

%% calculate
if exist(['..',filesep,'data',filesep,'repvals_',num2str(AMB),'.mat'],'file')
    msgbox('已存在repvals，无法保存');
else save(['..',filesep,'data',filesep,'repvals_',num2str(AMB)],'S_CT_repval','S_CP_repval','S_NT_repval','S_NP_repval')
end