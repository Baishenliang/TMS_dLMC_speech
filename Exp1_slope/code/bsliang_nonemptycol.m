function N=bsliang_nonemptycol(data)
% 统计二维矩阵的第一维度每一行非空单元格数量（用于计算standard error）
N=nan(size(data,1),1);
for row=1:size(data,1)
    datacol=data(row,:);
    datacol=datacol(~isnan(datacol));
    N(row)=length(datacol);
end