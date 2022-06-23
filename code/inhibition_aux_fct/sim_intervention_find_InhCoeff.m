function IC_out = sim_intervention_find_InhCoeff(drug_vec, response_vec, ... 
                    reference_response, IC)
% function estimates the IC for a dose response curve based on linear 
% interpolation between the two closest points
%
% Args:
% dose_vec          : vector with the drug concentrations ("x-values")
% response_vec      : vector with the response values ("y-values")
% reference_response: response to which should be normalized, i.e. which
%                     should correspond to 100%
% IC_to_calculate   : IC value which should be calculated, given in
%                     percent, e.g. 50 for IC50 or 95 for IC95;
%                     can be a vector
%
% Output
% IC_out            : estimated drug conc. at which response == IC
%                     if IC is a vector, IC_out will be vector with
%                     length = length(IC)

% scale response to 100%
response_vec = response_vec./reference_response * 100;

for n = 1:length(IC)
    % substract IC value -> yvalue to find corresponds to 0 
    response_vec_scaled = response_vec - (100 - IC(n));

    % if one has the value already in the dose response curve
    if find(response_vec_scaled == 0)
        IC_out = drug_vec(response_vec_scaled == 0);
    else % otherwise.
        % find sign swtich in scaled response vector
        idx_signSwitch = find(diff(response_vec_scaled >=0));
        if length(idx_signSwitch) == 1
            % linear interpolation between the two points around the sign
            % switch
            % on linear scale
            slope     = (response_vec_scaled(idx_signSwitch+1) - response_vec_scaled(idx_signSwitch)) / (drug_vec(idx_signSwitch+1) - drug_vec(idx_signSwitch));
            intercept = response_vec(idx_signSwitch) - slope * drug_vec(idx_signSwitch);
            IC_out(n) = ((100 - IC(n)) - intercept) / slope;
            % on log10 sclae
%             slope     = (response_vec_scaled(idx_signSwitch+1) - response_vec_scaled(idx_signSwitch)) / (log10(drug_vec(idx_signSwitch+1)) - log10(drug_vec(idx_signSwitch)));
%             intercept = response_vec(idx_signSwitch) - slope * log10(drug_vec(idx_signSwitch));
%             IC_out(n) = 10^(((100 - IC(n)) - intercept) / slope); 
        elseif length(idx_signSwitch) > 1
            error('no unique sign switch in dose response for calculation of IC, response seems to oscillate or similiar')
        elseif isempty(idx_signSwitch)
            % all response values are either above or below the IC
            % i.e. the drug effect is either too strong or too weak
            % the response does not cross the IC
            IC_out(n) = NaN;
        end
    end
end
end