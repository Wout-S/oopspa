function runmode(obj,mode,as,silent)
% run mode with default options
if isempty(obj.iterstep)
    switch mode
        case 1
            obj.iterstep=[10 2];
        case 3
            obj.iterstep=[];
        case 10
            obj.iterstep=[];
    end
end
if isempty(obj.timestep)
    switch mode
        case 1
            obj.timestep=[5 1000];
        case 3
            obj.timestep=[];
        case 10
            obj.timestep=[];
    end
end
if as % autosolve
    %reset dyne
    for i=1:numel(obj.elements)
        obj.elements(i).dyne=obj.elements(i).flex;
        obj.elements(i).rlse=[];
    end
    writedatfile(obj,mode)
    %                 warning('off','all')
    run(obj,0,true)
    %                 warning('on','all')
    autosolve(obj)
end
writedatfile(obj,mode)
run(obj,mode,silent);
end