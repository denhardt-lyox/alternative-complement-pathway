function y = sigmoidal_fun(parameter,xdata,par)
%%%% calculates percent hemolysis as a function of number of C9 molecues /
%%%% cell
%%%% assumes sigmoidal dose response on a log scale of x!
%%%% ideally should take an array of EC50 values, not implemented right now
% par.LB - lower boundary
% par.UB - upper boundary
% parameter - 2D vector with first element being EC50 and 2nd element being gamma
% xdata - C9 number of molecules/cell as vector or single numeric 
% y - Percent hemolysis at given parameters and number of C9 molecules
y = par.LB + ((par.UB - par.LB)./(1 + exp((log(parameter(1)) - log(xdata)).*parameter(2))));
end