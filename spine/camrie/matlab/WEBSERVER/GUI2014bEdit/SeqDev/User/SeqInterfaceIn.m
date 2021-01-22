function varargout = SeqInterfaceIn(varargin)
    switch nargout
        case 0
            switch varargin{1}
                case 1
                    set(varargin{2},'Enable','off');
                case 2
                    set(varargin{2},'Enable','off');
                case 3
                    set(varargin{2},'Enable','off');
                case 4
                    set(varargin{2},'Enable','on');
                case 5
                    set(varargin{2},'Enable','off');
                case 6
                    set(varargin{2},'Enable','off');
                case 7
                    set(varargin{2},'Enable','on');
                case 8
                    set(varargin{2},'Enable','off');
                case {9,10,11}
                    set(varargin{2},'Enable','off');
            end;
        case 1
            varargout{1} = {'GRE','SE','GRE_EPI','GRE_TI','StimEchoFID','GRE_r','GRE_EPI_TI','GRE_ktPts',};
    end;
end