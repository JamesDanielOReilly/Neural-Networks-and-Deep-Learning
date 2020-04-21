function y = nncallbk(demo,command)
%NNCALLBK Neural Network Design utility function.

% NNCALLBK(DEMO,COMMAND)
%   DEMO - Name of demo.
%   COMMAND - Command.
% Returns string of form: DEMO('COMMAND').

% Copyright 1995-2015 Martin T. Hagan and Howard B. Demuth
% First Version, 8-31-95.

y = sprintf('%s(''%s'')',demo,command);
