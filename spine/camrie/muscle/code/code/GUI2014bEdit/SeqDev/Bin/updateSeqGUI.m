function seqTypeChange = updateSeqGUI(hMatSize_Pop,hMatSize_Edit,hFOV_Pop,hFOV_Edit,seqType)

        global seqTypeOld;
        
        if (strcmp(seqTypeOld,seqType)~=1)
            switch seqType
                case '_r' % Radial
                    % % % Display the FOV edit.
                    set(hFOV_Pop,'String','FOV(mm)','Value',1);
                    % % % Display the FOV edit.
                    set(hFOV_Edit,'String','300','Value',300);
                    % FOV_Callback(source,eventdata,[300,300]);
                    FOV_output = 300;

                    % % % Display the MatSize edit.
                    set(hMatSize_Pop,'String','Resolution|Spokes','Value',1);
                    % % % Display the MatSize edit.
                    set(hMatSize_Edit,'String','128','Value',[128,201]);
                    MatSize_output = [128,201];

                case '_p' % Propeller

                case '_c' % Cartesian or Any other novel sequence type.
                    % % % Display the FOV edit.
                    set(hFOV_Pop,'String','FOV FE(mm)|FOV PE(mm)','Value',1);
                    % % % Display the FOV edit.
                    set(hFOV_Edit,'String','300','Value',[300,300]);
                    FOV_output = [300,300];

                    % % % Display the MatSize edit.
                    set(hMatSize_Pop,'String','MatSize FE|MatSize PE','Value',1);
                    % % % Display the MatSize edit.
                    set(hMatSize_Edit,'String','128','Value',[128,128]);
                    MatSize_output = [128,128];
            end;
            seqTypeOld = seqType;
            seqTypeChange = 1;
        else
            seqTypeChange = 0;
        end;
end