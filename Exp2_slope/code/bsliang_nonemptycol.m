function N=bsliang_nonemptycol(data)
% ͳ�ƶ�ά����ĵ�һά��ÿһ�зǿյ�Ԫ�����������ڼ���standard error��
N=nan(size(data,1),1);
for row=1:size(data,1)
    datacol=data(row,:);
    datacol=datacol(~isnan(datacol));
    N(row)=length(datacol);
end