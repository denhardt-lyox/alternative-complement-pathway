function m2 = loadSimBiologyModel_Persistent(filename)
% Make m1 a persistent variable so that it does not
% need to be loaded each time
% Load m1 in if it has not been loaded in yet
% Copyright 2008 MathWorks, Inc.
persistent model_saved
if isempty(model_saved)
sbioloadproject(filename) ;
m2 = model_saved;
% disp('loading')
else
m2 = model_saved;
% disp('already loaded')
end
end