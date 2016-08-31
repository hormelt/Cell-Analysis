classdef mucinData
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Value
    end
    
    methods
        function obj = mucinData(val)
            if size(val,3)>1
                obj.Value = val;
            else
                error('Expecting 3D array')
            end
        end
        function I = intint(obj,plotopt,frames,z)
            if ~exist('plot','var') || isempty(plotopt)
                plotopt = 1;
            end
            if ~exist('frames','var') || isempty(frames)
                frames = 1:size(obj,2);
            end
            if ~exist('z','var') || isempty(z)
                z = 1:size(obj,1);
            end
            [I] = sum(obj.Value(:,:,2),2);
            [I] = I(z);
            if plotopt
                figure; plot(I)
            end
        end
        
    end
    
end