classdef nndArray
  
  % Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
  
  properties
    values = {};
  end
  
  methods
    function x = nndArray(v)
      for i=length(v):-1:1
        vi = v{i};
        if numel(vi) ~= 1
          vi = num2cell(vi);
          v = [v(1:(i-1)) vi v((i+1):end)];
        end
      end
      x.values = v;
    end
    
    function y = subsref(x,subscripts)
      subs = subscripts(1).subs;
      y = x.values(subs{1});
      if numel(y) == 1
        y = y{1};
      else
        y = [y{:}];
      end
    end
    
    function x = subsasgn(x,subscripts,v)
      subs = subscripts(1).subs;
      if numel(v) == 1
        x.values{subs{1}} = v;
      else
        x.values(subs{1}) = mat2cell(v);
      end
    end
    
    function y = cat(x,varargin)
      arrays = [{x} varargin];
      y = nndArray(cat(2,cellfun(@(a) a.values,arrays,'UniformOutput',false)));
    end
    
    function x = append(x,varargin)
      x.values = [x.values varargin];
    end
    
    function len = length(x)
      len = length(x.values);
    end
  end
end