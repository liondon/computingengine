function varargout = SeqInterfaceOutCMD(tempStr,tempNum,TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice,TI)

    errStr = 0;


    if nargout == 1

        switch tempNum
            case {4,7}
                interSeqData =  eval([tempStr,'(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice,TI)']);
                
            case {1,2,3,5,8,9,10,11}
                interSeqData =  eval([tempStr,'(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)']);
                
            case 6
                interSeqData =  eval([tempStr,'(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)']);
        end
        
        varargout{1} = interSeqData;
        
    else

           
        switch tempNum
            case {4,7}
%                 seqTypeChange = updateSeqGUI(hMatSize_Pop,MatSize.handle,hFOV_Pop,FOV.handle,'_c');
%                 if seqTypeChange == 1
%                     MatSize.value = get(MatSize.handle,'value');
%                     FOV.value = get(FOV.handle,'value');
%                 end;
                [minTE,minTR,minTI] = eval([tempStr,'(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice,TI)']);
                
                varargout{3} = minTI;        
                
%                 if str2double(get(TI.handle,'String')) < minTI
%                     set(TI.handle,'String',num2str(round(minTI*10000)/10000));
%                 end;
                
            case {1,2,3,5,8,9,10,11}
%                 seqTypeChange = updateSeqGUI(hMatSize_Pop,MatSize.handle,hFOV_Pop,FOV.handle,'_c');
%                 if seqTypeChange == 1
%                     MatSize.value = get(MatSize.handle,'value');
%                     FOV.value = get(FOV.handle,'value');
%                 end;
                [minTE,minTR] = eval([tempStr,'(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)']);
                
            case 6
%                 seqTypeChange = updateSeqGUI(hMatSize_Pop,MatSize.handle,hFOV_Pop,FOV.handle,'_r');
%                 if seqTypeChange == 1
%                     MatSize.value = get(MatSize.handle,'value');
%                     FOV.value = get(FOV.handle,'value');
%                 end;
                [minTE,minTR] = eval([tempStr,'(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)']);
                
%                 varargout{3} = minTI;
%                 if str2double(get(TI.handle,'String')) < minTI
%                     set(TI.handle,'String',num2str(round(minTI*10000)/10000));
%                 end;
        end
        
        varargout{1} = minTE;
        varargout{2} = minTR;

    end
 
%     if errStr==1
%         errordlg('Error in SeqInterfaceOut.m.');
%     end;

end