function [B1pFileName,B1pFileAddr,index] = B1pTxFileNameGUI(Tx,filePath,fileName,Mag,Phs,FA)
    
    global tempBool;  
    
    tempBool = 0;
    
    hGap = 2;
    vGap = 3;

    hTxFileNameDlg = figure('Visible','on','MenuBar','none','Name','Tx Array Setup',...
        'NumberTitle','off','Position',[100,30,320,15+30*(2+Tx)],'Resize','off',...
        'Toolbar','none','Color',[1,1,1],'WindowStyle','modal');
    movegui(hTxFileNameDlg,'center');
    
    % set to be modal

    temp001 = 215; temp002 = 30*(1.5+Tx);
    uicontrol(hTxFileNameDlg,'Style','text','string','Mag','Position',[temp001 temp002 30 13],'BackgroundColor',[1,1,1]);
    uicontrol(hTxFileNameDlg,'Style','text','string','Phs','Position',[temp001+30+hGap temp002 30 13],'BackgroundColor',[1,1,1]);
    uicontrol(hTxFileNameDlg,'Style','text','string','RF FA','Position',[temp001+30+30+2*hGap temp002 30 13],'BackgroundColor',[1,1,1]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Tx#    FileName     Browse     Mag   Phs    RF_FA
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    temp001 = 190;
    global hTxOk;
    hTxOk = uicontrol(hTxFileNameDlg,'Style','pushButton','String','OK',...
        'Position',[temp001 temp002-(Tx+1)*30 60 13+6],'Callback',{@TxOK_Callback},'Enable','off');
    uicontrol(hTxFileNameDlg,'Style','pushButton','String','Cancel',...
        'Position',[temp001+60 temp002-(Tx+1)*30 60 13+6],'Callback',{@TxCancel_Callback});
    
    temp001 = 10; 
    for n=1:Tx
        temphFileName = ['hTxFileName',num2str(n)];
        eval([temphFileName '= uicontrol(hTxFileNameDlg,''Style'',''pushButton'',''String'',[''Coil'',num2str(n)],''Position'',[temp001 temp002-n*30 50 13+6]);']);
        temphFileNameEdit = ['hTxFileNameEdit',num2str(n)];
        eval(['global ',temphFileNameEdit]);
        eval([temphFileNameEdit '= uicontrol(hTxFileNameDlg,''Style'',''edit'',''Position'',[temp001+50+hGap temp002-30*n 150 13+6],''Enable'',''inactive'',''BackgroundColor'',[1,1,1]);']);
        if ~strcmp(fileName,'')
            eval(['set(',temphFileNameEdit,',''UserData'',[filePath{n},fileName{n}],''String'',fileName{n},''FontAngle'',''normal'');']);
        else
            eval(['set(',temphFileNameEdit,',''UserData'','''',''String'',''B1+ Filename'',''FontAngle'',''italic'');']);
        end;
        temphMag = ['hTxMag',num2str(n)];
        eval([temphMag ' = uicontrol(hTxFileNameDlg,''Style'',''edit'',''Position'',[temp001+50+150+3*hGap temp002-30*n 30 13+6],''String'',num2str(Mag(n)),''Enable'',''inactive'');']);
        temphPhs = ['hTxPhs',num2str(n)];
        eval([temphPhs '= uicontrol(hTxFileNameDlg,''Style'',''edit'',''Position'',[temp001+50+150+30+4*hGap temp002-30*n 30 13+6],''String'',num2str(Phs(n)),''Enable'',''inactive'');']);
        temphFA = ['hTxFA',num2str(n)];
        eval([temphFA '= uicontrol(hTxFileNameDlg,''Style'',''edit'',''Position'',[temp001+50+150+30+30+5*hGap temp002-30*n 30 13+6],''String'',num2str(rem(Mag(n)*FA,360)),''Enable'',''inactive'');']);
        
        eval(['set(',temphFileName,',''CallBack'',{@TxFileName_Callback,',temphFileNameEdit,',Tx});']);
        
        if n==Tx
            tempStr = get(eval(['hTxFileNameEdit',num2str(n)]),'Userdata');
            tempBool = ~strcmp(tempStr,'');
            if tempBool == 1
                set(hTxOk,'Enable','on');
            end;
        end;
    end;

    clear temphFileName temphFileNameEdit temphMag temphPhs temphFA;
   
    uiwait(gcf);
    if tempBool == 0
        B1pFileName = fileName; B1pFileAddr = filePath; index = 0;
    else
        for n=1:Tx
           temphFileNameEdit = ['hTxFileNameEdit',num2str(n)];
           tempStr = eval(['get(hTxFileNameEdit',num2str(n),',''UserData'');']);
           [tempPath,tempName] = addrCvrt(tempStr);
           eval(['B1pFileAddr{',num2str(n),'} = tempPath;']);
           eval(['B1pFileName{',num2str(n),'} = tempName;']);
        end
        index = 1;
        clear tempStr;
    end
    
    if gcf == hTxFileNameDlg
        close(gcf);
    end;
end

function TxFileName_Callback(source,eventdata,hTxFileNameEdit,Tx)
    global hTxOk fileAddr;
    
    cd (fileAddr);
    
    for n=1:Tx
        temphFileNameEdit = ['hTxFileNameEdit',num2str(n)];
        eval(['global ',temphFileNameEdit]);
    end;
    
    [fileName,pathName,index]=uigetfile({'*.bfld','B1 Plus File (*.bfld)';'*.*','All Fiiles (*.*)'},'OPEN: B1 Plus File');
    if index == 1
        set(hTxFileNameEdit,'UserData',[pathName,fileName],'String',fileName,'FontAngle','normal');
        
        tempBool = 1;
        for n=1:Tx
            tempStr = get(eval(['hTxFileNameEdit',num2str(n)]),'Userdata');
            tempBool = tempBool * ~strcmp(tempStr,'');
        end
        if tempBool == 1
            set(hTxOk,'Enable','on');
        end;
        
        fileAddr = pathName;
    end;
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