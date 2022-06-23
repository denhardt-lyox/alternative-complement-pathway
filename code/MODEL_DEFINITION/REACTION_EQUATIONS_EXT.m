function REACTION_EQUATIONS_EXTENSION(model)
% additional reactions that have been added to the model based on Zewde
% 2017     

% 25
r25_rev = addreaction(model, '[C3bBbH fluid] -> [C3bBb fluid] + H', 'ReactionRate',... 
                   '[k_m_C3bH] *  [C3bBbH fluid]', 'Name', 'r25_rev'); 
% 42  
r42_rev = addreaction(model, '[C3bBbH host] -> [C3bBb host] + H', 'ReactionRate',... 
                   '[k_m_C3bH] * [C3bBbH host]', 'Name', 'r42_rev');  
% 55
r55_rev = addreaction(model, '[C3bBbC3bH host] -> [C3bBbC3b host] + H', 'ReactionRate',... 
                   '[k_m_C3bH] * [C3bBbC3bH host]', 'Name', 'r55_rev');   
% 26
r26_rev = addreaction(model, '[C3bBbCR1 fluid] -> CR1 + [C3bBb fluid]', 'ReactionRate',... 
                   '[k_m_C3bCR1] *  [C3bBbCR1 fluid]', 'Name', 'r26_rev'); 
% 43     
r43_rev = addreaction(model, '[C3bBbCR1 host] -> [C3bBb host] + CR1', 'ReactionRate',... 
                   '[k_m_C3bCR1] * [C3bBbCR1 host]', 'Name', 'r43_rev');  
% 53     
r53_rev = addreaction(model, '[C3bBbC3bCR1 host] -> [C3bBbC3b host] + CR1', 'ReactionRate',... 
                   '[k_m_C3bCR1] * [C3bBbC3bCR1 host]', 'Name', 'r53_rev');     
% 44     
r44_rev = addreaction(model, '[C3bBbDAF host] -> [C3bBb host] + DAF', 'ReactionRate',... 
                   '[k_m_C3bBbDAF] * [C3bBbDAF host]', 'Name', 'r44_rev');  
% 54     
r54_rev = addreaction(model, '[C3bBbC3bDAF host] -> [C3bBbC3b host] + DAF', 'ReactionRate',... 
                   '[k_m_C3bBbDAF] * [C3bBbC3bDAF host]', 'Name', 'r54_rev');    
% pr21
pr21_rev = addreaction(model, '[C3bBbP host] -> [C3bBb host] + [P]', 'ReactionRate',... 
             '[k_m_C3bP] * [C3bBbP host]', 'Name', 'pr21_rev');  
%          
r40_properdin = addreaction(model, '[C3bBbC3bP host] -> Bb + [C3b host] + [C3b fluid] + P', 'ReactionRate',... 
                   '[k_m_C3bBbC3bP] * [C3bBbC3bP host]', 'Name', 'r40_properdin');     
