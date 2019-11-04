function run(obj,mode,silent)
warning('off','all')
if silent
    [~]=spacar(mode,obj.filename);
else
    spacar(mode,obj.filename);
end
warning('on','all')
%             disp('spacar run succeeded')
end
