function DDATA=bsliang_rejINDdata(DATA,rej_ind)
% �������ɾ����
    for ind=rej_ind
        DATA(ind).par_info=[];
        DATA(ind).def_range=[];
        DATA(ind).practice=[];
        DATA(ind).Id_Di=[];
    end
    DDATA=DATA;
end
