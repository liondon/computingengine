function [TxMagMat, TxPhsMat,index] = TxMagPhsGUI(Tx,Mag,Phs,FA)
    
    global tempBool
    tempBool = 0;
    
    hGap = 2;
    vGap = 3;

    hTxMagPhsDlg = figure('Visible','on','MenuBar','none','Name','Tx Array',...
        'NumberTitle','off','Position',[100,30,190,15+30*(2+Tx)],'Resize','off',...
        'Toolbar','none','Color',[1,1,1],'WindowStyle','modal');
    movegui(hTxMagPhsDlg,'center');
    
    % set to be modal

    temp001 = 65; temp002 = 30*(1.5+Tx);
    uicontrol(hTxMagPhsDlg,'Style','text','string','Mag','Position',[temp001 temp002 30 13],'BackgroundColor',[1,1,1]);
    uicontrol(hTxMagPhsDlg,'Style','text','string','Phs','Position',[temp001+30+hGap temp002 30 13],'BackgroundColor',[1,1,1]);
    uicontrol(hTxMagPhsDlg,'Style','text','string','RF FA','Position',[temp001+30+30+2*hGap temp002 30 13],'BackgroundColor',[1,1,1]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Tx#    FileName     Browse     Mag   Phs    RF_FA
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    temp001 = 10; 
    for n=1:Tx
        eval('uicontrol(hTxMagPhsDlg,''Style'',''Text'',''String'',[''Coil'',num2str(n)],''Position'',[temp001 temp002-n*30 50 13+3],''BackgroundColor'',[1,1,1]);');
        temphMag = ['hTxMag',num2str(n)];
        eval([temphMag ' = uicontrol(hTxMagPhsDlg,''Style'',''edit'',''Position'',[temp001+50+3*hGap temp002-30*n 30 13+6],''String'',num2str(Mag(n)),''BackgroundColor'',[1,1,1]);']);
        temphPhs = ['hTxPhs',num2str(n)];
        eval([temphPhs '= uicontrol(hTxMagPhsDlg,''Style'',''edit'',''Position'',[temp001+50+30+4*hGap temp002-30*n 30 13+6],''String'',num2str(Phs(n)),''BackgroundColor'',[1,1,1]);']);
        temphFA = ['hTxFA',num2str(n)];
        eval([temphFA '= uicontrol(hTxMagPhsDlg,''Style'',''edit'',''Position'',[temp001+50+30+30+5*hGap temp002-30*n 30 13+6],''String'',num2str(rem(Mag(n)*FA,360)),''Enable'',''inactive'');']);
        
        eval(['set(',temphMag,',''CallBack'',{@TxMag_Callback,',temphMag,',',temphFA,',FA});']);
        eval(['set(',temphPhs,',''CallBack'',{@TxPhs_Callback,',temphPhs,'});']);
    end;

    clear temphMag temphPhs temphFA;

    temp001 = 75;
    uicontrol(hTxMagPhsDlg,'Style','pushButton','String','OK',...
        'Position',[temp001 temp002-(Tx+1)*30 45 13+6],'Callback',{@TxOK_Callback});
    uicontrol(hTxMagPhsDlg,'Style','pushButton','String','Cancel',...
        'Position',[temp001+45 temp002-(Tx+1)*30 45 13+6],'Callback',{@TxCancel_Callback});

    uiwait(gcf);
    if tempBool == 0
        TxMagMat = Mag;    TxPhsMat = Phs; index = 0;
    else
        for n=1:Tx
           temphMag = ['hTxMag',num2str(n)];
           eval(['TxMagMat(',num2str(n),') = str2double(get(',temphMag,',''String''));']);
           temphPhs = ['hTxPhs',num2str(n)];
           eval(['TxPhsMat(',num2str(n),') = str2double(get(',temphPhs,',''String''));']);
        end
        index = 1;
    end
    
    if gcf == hTxMagPhsDlg
        close(gcf);
    end;
end

function TxMag_Callback(source,eventdata,hTxMag,hTxFA,FA)
    mag = str2double(get(hTxMag,'String'));
    if mag < 0
        mag = mag * -1;
        set(hTxMag,'String',num2str(mag));
    end;
    set(hTxFA,'String',num2str(rem(FA*mag,360)));
end

function TxPhs_Callback(source,eventdata,hTxPhs)
    phs = str2double(get(hTxPhs,'String'));
    set(hTxPhs,'String',num2str(rem(phs,360)));
end

function TxOK_Callback(source,eventdata)
    global tempBool;
    
    tempBool = 1;
    
    uiresume(gcbf);
end

function TxCancel_Callback(source,eventdata)
    global tempBool;
    
    tempBool = 0;
    
    uiresume(gcbf);
end