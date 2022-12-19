function TDATA=bsliang_Trandata(DATA)
    % ��ȡ��ת�����ݵ��������ݵĸ�ʽ
    % ================================
    % DATA structure:
    % turn: L T S
    % block: 
    %   Id_Di	BLOCK	NAME        NUMBER
    %   Id      A       T_CLEAR_ID      1
    %   Id      B       P_CLEAR_ID      2
    %   Id      C       T_NOISE_ID      3
    %   Id      D       P_NOISE_ID      4
    
    % ===============================
    % ����ȱʡ���
    % ��1�������ڸñ��ԣ�DATA(subj).Id_DiΪ�գ�
    % ��2�����ڸñ��ԣ�������ȫû����ʽʵ�飬DATA(subj).Id_Di��Ϊ�գ���DATA(subj).Id_Di������data�ֶ�
    % ��3�����ڸñ��ԣ�����û��������turn(Sham)������DATA(subj).Id_Di.data����data(:,:,3)������
    % ��4�����ڸñ��ԣ�����û���ڶ�����turn(Tongue,Sham)������DATA(subj).Id_Di.data����data(:,:,2)��data(:,:,3)������
    % ��5�����϶������ϣ�����ĳ��blockû�������û��������ֻ�������˲Ż����������DATA(subj).Id_Di.data(1,block,turn)�е�ÿһ���Ϊ�գ�����ʽ��������������һ���ģ�
    % ��������һ��ȱʡ������TDATA���ֳ����Ķ���block�����������EMPTY�����ĸ�ʽ
    EMPTY.rawdata=[];
    EMPTY.half_threshold=[];
    EMPTY.threshold_boundaries=[];
    
    TDATA=cell(4,3,size(DATA,2));
    % TDATA dims: block, turn, subj
    for subj=1:size(DATA,2) 
        for turn=1:3 % L T S
            for block=1:4 % IDTC IDPC IDTN IDPN
                if isempty(DATA(subj).Id_Di)
                    % ȱʡ���1
                    TDATA{block,turn,subj}=EMPTY;
                elseif ~isfield(DATA(subj).Id_Di,'data')
                    % ȱʡ���2
                    TDATA{block,turn,subj}=EMPTY;
                elseif size(DATA(subj).Id_Di.data,3)==2 && turn>2
                    % ȱʡ���3
                    TDATA{block,turn,subj}=EMPTY;
                elseif size(DATA(subj).Id_Di.data,3)==1 && turn>1
                    % ȱʡ���4
                    TDATA{block,turn,subj}=EMPTY;
                else
                    % ȱʡ���5���ȱʡ���
                    TDATA{block,turn,subj}=DATA(subj).Id_Di.data(1,block,turn);
                end
            end
        end
    end
end
