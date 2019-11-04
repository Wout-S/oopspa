function perturb(obj)
mode=3;
newfn=[obj.filename '_3'];
copyfile([obj.filename '.dat'],[newfn '.dat'])
warning('off','all')
[~]=spacar(mode,newfn);
warning('on','all')
p.filename=newfn;
obj.perturbdata=rawdata(p);
end