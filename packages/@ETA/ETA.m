classdef ETA < handle
    properties
        tstart
        total
    end
    
    properties(Access = private)
       progress
       text
    end
    
    methods
        
        function eta = ETA(tstart, total, text)
            eta.tstart = tstart;
            eta.total = total;
            if (nargin == 3)
                eta.text = text;
            else
                eta.text = '(calculating ETA)';
            end
            eta.progress = 0;
            
            fprintf( '%s', eta.text);
        end
        
        function dispText = print(obj)
            
            % Create the display text based on the ETA
            tLoop = toc(obj.tstart);
            f = obj.progress/obj.total;
            tSec    = 1/24/3600;
            tMin    = 60*tSec;
            tRem    = (tLoop*(1 - f)/f)*tSec;
            tNow    = now;
            
            if( tRem == Inf )
                dispText = sprintf( '0%% complete. ETA incalculable.\n' );
                
            elseif( tRem == 0 )
                dispText = sprintf( 'Done\n' );
                
            elseif( tRem < tMin )
                %         eta = datestr( tRem, 'ss');
                dispText = sprintf( '%d%% complete. ETA in %d seconds.\n' ...
                    , round(f*100) ...
                    , ceil(tRem/tSec) ...
                    );
                
            else
                if( floor(tRem+tNow) > floor(tNow) )
                    etastr = datestr( now + tRem, 'mmm dd, HH PM' );
                else
                    etastr = datestr( now + tRem, 15 );
                end
                dispText = sprintf( '%d%% complete. ETA is %s\n' ...
                    , round(f*100) ...
                    , etastr ...
                    );
            end
            
            % Arrange to erase the old text and print the new one
            bkspTxt = repmat( sprintf('\b'), 1, numel(obj.text));
            fprintf('%s', [bkspTxt, dispText]);
            
            obj.text = dispText;
            
        end
        
        function update(obj)
           lastprogress = obj.progress;
           curprogress  = lastprogress + 1;
           
           obj.progress = curprogress;
        end
        
    end
    
end