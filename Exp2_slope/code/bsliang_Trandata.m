function TDATA=bsliang_Trandata(DATA)
    % ��ȡ��ת�����ݵ��������ݵĸ�ʽ
    % ================================
    % DATA structure:
    
    %  turn��
    %   stimSITE   NUMBER
    %   Left iTBS    1
    %   Left cTBS    2
    %   Right iTBS   3
    %   Right cTBS   4
    %   Sham         5 
    
    % block��
    %   BLOCK	NAME        NUMBER
    %   A       T_CLEAR_ID      1
    %   B       P_CLEAR_ID      2
    %   C       T_NOISE_ID      3
    %   D       P_NOISE_ID      4
    
    % ===============================
    % ����ȱʡ���
    % ��1�������ڸñ��ԣ�DATA(subj).Id_DiΪ�գ�
    % ��2�����ڸñ��ԣ�������ȫû����ʽʵ�飬DATA(subj).Id_Di��Ϊ�գ���DATA(subj).Id_Di������data�ֶ�
    % ��3�����ڸñ��ԣ�����û�������turn(Sham)������DATA(subj).Id_Di.data����data(:,:,5)������
    % ��4�����ڸñ��ԣ�����û���������turn(Sham)������DATA(subj).Id_Di.data����data(:,:,4)��data(:,:,5)������
    % ��5�����ڸñ��ԣ�����û�����������turn(Sham)������DATA(subj).Id_Di.data����data(:,:,3)��data(:,:,4)��data(:,:,5)������
    % ��6�����ڸñ��ԣ�����û���ڶ��������turn(Sham)������DATA(subj).Id_Di.data����data(:,:,3)����data(:,:,3)��data(:,:,4)��data(:,:,5)������
    % ��7�����϶������ϣ�����ĳ��blockû�������û��������ֻ�������˲Ż����������DATA(subj).Id_Di.data(1,block,turn)�е�ÿһ���Ϊ�գ�����ʽ��������������һ���ģ�
    % ��������һ��ȱʡ������TDATA���ֳ����Ķ���block�����������EMPTY�����ĸ�ʽ
    EMPTY.rawdata=[];
    EMPTY.half_threshold=[];
    EMPTY.threshold_boundaries=[];
    
    TDATA=cell(4,5,size(DATA,2));
    % TDATA dims: block, turn, subj
    for subj=1:size(DATA,2) 
        for turn=1:size(TDATA,2) %  Left iTBS Left cTBS Right iTBS Right cTBS Sham
            for block=1:size(TDATA,1) % IDTC IDPC IDTN IDPN
                if isempty(DATA(subj).Id_Di)
                    % ȱʡ���1
                    TDATA{block,turn,subj}=EMPTY;
                elseif ~isfield(DATA(subj).Id_Di,'data')
                    % ȱʡ���2
                    TDATA{block,turn,subj}=EMPTY;
                elseif size(DATA(subj).Id_Di.data,3)==4 && turn>4
                    % ȱʡ���3
                    TDATA{block,turn,subj}=EMPTY;
                elseif size(DATA(subj).Id_Di.data,3)==3 && turn>3
                    % ȱʡ���4
                    TDATA{block,turn,subj}=EMPTY;
                elseif size(DATA(subj).Id_Di.data,3)==2 && turn>2
                    % ȱʡ���5
                    TDATA{block,turn,subj}=EMPTY;   
                elseif size(DATA(subj).Id_Di.data,3)==1 && turn>1
                    % ȱʡ���6
                    TDATA{block,turn,subj}=EMPTY;
                else
                    % ȱʡ���7���ȱʡ���
                    TDATA{block,turn,subj}=DATA(subj).Id_Di.data(1,block,turn);
                    disp(subj)
                end
            end
        end
    end
end
