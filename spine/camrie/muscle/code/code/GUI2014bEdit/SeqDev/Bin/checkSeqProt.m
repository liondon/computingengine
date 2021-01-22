function seqOut = checkSeqProt(seqIn)
    
% This function serve to make default the sequence protocols that user did
% not specifiy explicitly.

    try seqIn.AngleIncrement;
    catch exception
        if strcmp(exception.message,'Reference to non-existent field ''AngleIncrement''.')==1
            seqIn.AngleIncrement = 0;
        end;        
    end;
    
    try seqIn.Main.Gfe.increment;
    catch exception
        if strcmp(exception.message,'Reference to non-existent field ''increment''.')==1
            seqIn.Main.Gfe.increment = 0;
        end;        
    end;
    
    try seqIn.Main.Gpe.increment;
    catch exception
        if strcmp(exception.message,'Reference to non-existent field ''increment''.')==1
            seqIn.Main.Gpe.increment = 0;
        end;        
    end;
    
    seqOut = seqIn;
    clear seqIn;
end