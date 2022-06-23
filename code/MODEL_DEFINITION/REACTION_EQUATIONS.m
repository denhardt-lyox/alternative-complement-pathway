function REACTION_EQUATIONS(model, C5_concvertase_original)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reactions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initiation (fluid phase)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Equation 1
% 1
r1 = addreaction(model, 'C3 -> [C3(H2O) fluid]', 'ReactionRate', 'C3 * [k_p_C3(H20)]', 'Name', 'r1');
% 2+3
r2 = addreaction(model, '[C3(H2O) fluid] + B <-> [C3(H2O)B fluid]',... 
    'ReactionRate', '[k_p_C3(H20)B]  * [C3(H2O) fluid] * B - [k_m_C3(H20)B] * [C3(H2O)B fluid]', 'Name', 'r2');
% 4
r4 = addreaction(model, '[C3(H2O) fluid] + H <-> [C3(H2O)H fluid]',... 
    'ReactionRate', '[k_p_C3bH] * [C3(H2O) fluid] * H - [k_m_C3bH] * [C3(H2O)H fluid]', 'Name', 'r4');
% 5
r5 = addreaction(model, '[C3(H2O) fluid] + CR1 <-> [C3(H2O)CR1 fluid]',... 
    'ReactionRate', '[k_p_C3bCR1] * [C3(H2O) fluid] * CR1 - [k_m_C3bCR1] * [C3(H2O)CR1 fluid]', 'Name', 'r5');
% 8
r8 = addreaction(model, '[C3(H2O)Bb fluid] -> [C3(H2O) fluid] + Bb', 'ReactionRate',... 
                                '[k_m_C3(H2O)Bb] * [C3(H2O)Bb fluid]', 'Name', 'r8');
% 9
r9 = addreaction(model, '[C3(H2O)BbH fluid] -> H + Bb + [C3(H2O) fluid]', 'ReactionRate',... 
                                '[k_m_C3bBbH decay] * [C3(H2O)BbH fluid]', 'Name', 'r9');

% Equations 2
% 10
r10 = addreaction(model, '[C3(H2O)B fluid] + D -> [C3(H2O)Bb fluid] + Ba + D', 'ReactionRate',... 
'[k_D_cat_C3(H2O)B] * D * [C3(H2O)B fluid] / ([K_D_m_C3(H2O)B] + [C3bB fluid] + [C3(H2O)B fluid] + [C3bB host])',...
'Name', 'r10');   

% Equations 3
r11 = addreaction(model, '[C3(H2O)Bb fluid] + H -> [C3(H2O)BbH fluid]',... 
    'ReactionRate', '[k_p_C3bH] * [C3(H2O)Bb fluid] * H', 'Name', 'r11');

% Equations 4
% 12
% % r12 = addreaction(model, 'nfC3b + H2O -> [C3b fluid]', 'ReactionRate',... 
% %                                 'k_p_fC3b * nfC3b * H2O', 'Name', 'r12');
r12 = addreaction(model, 'nfC3b -> [C3b fluid]', 'ReactionRate',... 
                                'k_p_fC3b * nfC3b', 'Name', 'r12');
% 13
% r13 = addreaction(model, 'nhC3b + H2O -> [C3b fluid]', 'ReactionRate',... 
%                                 'k_p_fC3b * nhC3b * H2O', 'Name', 'r13');
r13 = addreaction(model, 'nhC3b -> [C3b fluid]', 'ReactionRate',... 
                                'k_p_fC3b * nhC3b', 'Name', 'r13');
 % 14                   
r14 = addreaction(model, '[C3b fluid] + B <-> [C3bB fluid]', 'ReactionRate',... 
                   'k_p_C3bB * [C3b fluid] * B - k_m_C3bB * [C3bB fluid]', 'Name', 'r14');
% 15               
r15 = addreaction(model, '[C3b fluid] + H <-> [C3bH fluid]', 'ReactionRate',... 
                   'k_p_C3bH * [C3b fluid] * H - k_m_C3bH * [C3bH fluid]', 'Name', 'r15');              
% 16
r16 = addreaction(model, '[C3b fluid] + CR1 <-> [C3bCR1 fluid]', 'ReactionRate',... 
                   'k_p_C3bCR1 * [C3b fluid] * CR1 - k_m_C3bCR1 * [C3bCR1 fluid]', 'Name', 'r16'); 
% 17               
r17 = addreaction(model, '[C3bBb fluid] -> Bb + [C3b fluid]', 'ReactionRate',... 
                   'k_m_C3bBb * [C3bBb fluid]', 'Name', 'r17');  
% 18               
r18 = addreaction(model, '[C3bBbH fluid] -> H + Bb + [C3b fluid]', 'ReactionRate',... 
                   '[k_m_C3bBbH decay] * [C3bBbH fluid]', 'Name', 'r18');  
% 19               
r19 = addreaction(model, '[C3bBbCR1 fluid] -> CR1 + Bb +  [C3b fluid]', 'ReactionRate',... 
                   '[k_m_C3bBbCR1 decay] * [C3bBbCR1 fluid]', 'Name', 'r19');  
% 20 
r20 = addreaction(model, '[C3b fluid] + [C3bBb host] <-> [C3bBbC3b host]', 'ReactionRate',... 
                   'k_p_C3bBbC3b * [C3b fluid] * [C3bBb host] - k_m_C3bBbC3b * [C3bBbC3b host]',...
                   'Name', 'r20'); 
% 21                
r21 = addreaction(model, '[C3bBbC3bCR1 host] -> CR1 + [C3b fluid] + [C3b host] + Bb', 'ReactionRate',... 
                   '[k_m_C3bBbCR1 decay] * [C3bBbC3bCR1 host]', 'Name', 'r21');      
% 22                
r22 = addreaction(model, '[C3bBbC3bDAF host] ->  [DAF] + [C3b fluid] + [C3b host] + Bb', 'ReactionRate',... 
                   '[k_m_C3bBbDAF decay] * [C3bBbC3bDAF host]', 'Name', 'r22');        
% 23             
r23 = addreaction(model, '[C3bBbC3bH host] ->  H + [C3b fluid] + [C3b host] + Bb', 'ReactionRate',... 
                   '[k_m_C3bBbH decay] * [C3bBbC3bH host]', 'Name', 'r23'); 
               
% Equations 5
% 24 
r24 = addreaction(model, '[C3bB fluid] + D -> [C3bBb fluid] + Ba + D', 'ReactionRate',... 
'[k_D_cat_C3bB] * D * [C3bB fluid] / ([K_D_m_C3bB] + [C3bB fluid] + [C3(H2O)B fluid] + [C3bB host])',...
'Name', 'r24');   

% Equations 6
% 25
r25 = addreaction(model, '[C3bBb fluid] + H -> [C3bBbH fluid]', 'ReactionRate',... 
                   '[k_p_C3bH] *  H * [C3bBb fluid]', 'Name', 'r25'); 
% 26
r26 = addreaction(model, 'CR1 + [C3bBb fluid] -> [C3bBbCR1 fluid]', 'ReactionRate',... 
                   '[k_p_C3bCR1] *  CR1 * [C3bBb fluid]', 'Name', 'r26'); 
               
% Equations 7
% 27               
r27 = addreaction(model, '[C3] -> [C3a] + [nfC3b]', 'ReactionRate',... 
                   '[k_C3_cat_C3(H2O)Bb] * [C3] * [C3(H2O)Bb fluid] / ([K_C3_m_C3(H2O)Bb] + [C3])',...
                   'Name', 'r27');
% 28               
r28 = addreaction(model, '[C3] + [C3bBb fluid] -> [C3a] + [nfC3b] + [C3bBb fluid]', 'ReactionRate',... 
                   '[k_C3_cat_C3bBb] * [C3] * [C3bBb fluid] / ([K_C3_m_C3bBb] + [C3])',...
                   'Name', 'r28');
% 29               
r29 = addreaction(model, '[nfC3b] + [Surface host] -> [C3b host]', 'ReactionRate',... 
                   '[k_p_C3b_surface] * [nfC3b] * [Surface host]', 'Name', 'r29');
% r29 = addreaction(model, '[nfC3b] + [Surface host] -> [C3b host]', 'ReactionRate',... 
%                    '[k_p_hC3b] * [nfC3b] * [Surface host]', 'Name', 'r29');
               
               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (ii) Amplification on surface via properdin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Equation 2
% pr1                                   
% Equation 3
% pr2         
% pr3
pr3 = addreaction(model, '[C3bBbP host] -> [P] + [C3b host] + [Bb]', 'ReactionRate',... 
                   '[k_m_C3bBbP] * [C3bBbP host]', 'Name', 'pr3'); 

% Equation 4 (Neutrophil Properdin (Pn surface) on surface)
% pr4
% pr5            
% pr6                            
% pr7                      
% pr8                 
% pr9
% pr10     
% pr11               
% pr12
% pr13                          

% Equation 5 (Nascent C3b)
% pr14
pr14 = addreaction(model, '[C3] + [C3bBbP host] -> [C3a] + [nhC3b] + [C3bBbP host]', 'ReactionRate',... 
      '[k_C3_cat_C3bBbP] * [C3] * [C3bBbP host] / ([K_C3_m_C3bBbP] + [C3])', 'Name', 'pr14');  
  
% pr15
% pr16
pr16 = addreaction(model, '[C3bBbP host] + nhC3b -> [C3bBbC3bP host]', 'ReactionRate',... 
         '[k_p_C3bBbC3b] * [C3bBbP host] * nhC3b', 'Name', 'pr16');       
  
% pr17
% Equation 6
% pr8.1  
% Equation 7
% pr9.1
% pr18 CHECK   
% pr19 CHECK
% pr20 CHECK  

% Equation 9
% pr24
pr24 = addreaction(model, '[C3bBP host] + D -> [C3bBbP host] + Ba + D', 'ReactionRate',... 
     '[k_D_cat_C3bB] * D * [C3bBP host] / ([K_D_m_C3(H2O)B] + [C3bB fluid] + [C3(H2O)B fluid] + [C3bB host]+ [C3bBP host])',...
       'Name', 'pr24');           

% Equation 10         
% pr21
pr21 = addreaction(model, '[C3bBb host] + [P] -> [C3bBbP host]', 'ReactionRate',... 
             '[k_p_C3bP] * [C3bBb host] * [P]', 'Name', 'pr21');  
         
% pr22
% pr22 = need to clarify          

% pr23 
pr23 = addreaction(model, '[C3bBbP host] + [C3b fluid] -> [C3bBbC3bP host]', 'ReactionRate',... 
         '[k_p_C3bBbC3b] * [C3bBbP host] * [C3b fluid]', 'Name', 'pr23');  

% Equation 11
% pr25 
% pr26    
% Equation 12
% pr27       
% pr28    
% Equation 13
% pr29   
% pr30 
    
% Equation 15
pr31 = addreaction(model, '[iC3b host] + [P] <-> [iC3bP host]', 'ReactionRate',... 
            '[k_p_iC3bP] * [iC3b host] * [P] - [k_m_iC3bP] * [iC3bP host]', 'Name', 'pr31');  

   
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (iii) Termination properdin supported
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Equation 1
% pr31.1
pr33_1 = addreaction(model, '[C3bBbC3b host] + P <-> [C3bBbC3bP host]', 'ReactionRate',... 
               '[k_p_C3bP] * [C3bBbC3b host] * P - [k_m_C3bP] * [C3bBbC3bP host]', 'Name', 'pr33_1'); 
 
% Equation 2
pr32  = addreaction(model, '[C3bBbC3bPC5 host] -> [C3bBbC3bC5 host] + P', 'ReactionRate',... 
              '[k_m_C3bP] * [C3bBbC3bPC5 host]', 'Name', 'pr32');
          
% Equation 3
% pr33
pr33 = addreaction(model, '[C3bBbC3bPC5b host] -> [C3bBbC3bC5b host] + P', 'ReactionRate',... 
             '[k_m_C3bP] * [C3bBbC3bPC5b host]', 'Name', 'pr33');   

% Equation 4
% pr34
pr34 = addreaction(model, '[C3bBbC3bPC5bC6 host] -> [C3bBbC3bC5bC6 host] + P', 'ReactionRate',... 
             '[k_m_C3bP] * [C3bBbC3bPC5bC6 host]', 'Name', 'pr34'); 
         
% Equation 5
% pr35
pr35 = addreaction(model, '[C3bBbC3bPC5bC6 host] + C7 -> [C3bBbC3bP host] + [hC5b7 fluid]', 'ReactionRate',... 
             '[k_p_C5b7] * [C3bBbC3bPC5bC6 host] * C7', 'Name', 'pr35');         
     
% pr37
pr37 = addreaction(model, '[C3bBbC3bPC5b host] -> [C3bBbC3bP host] + C5b', 'ReactionRate',... 
              '[k_m_C5b] * [C3bBbC3bPC5b host]', 'Name', 'pr37');          
         
          
if C5_concvertase_original == 1
    % pr36 (is 56 on host)                               
    pr36 = addreaction(model, '[C3bBbC3bP host] + C5 <-> [C3bBbC3bPC5 host]', 'ReactionRate',... 
           '[k_p_C3bBbC3bC5] * [C3bBbC3bP host] * C5 - [k_m_C3bBbC3bC5] * [C3bBbC3bPC5 host]',...
           'Name', 'pr36');     
    
    % pr38 (is 59 on host)  CHECK rate  k_C5_cat_C3bBbC3b versus  k_cat_C3bBbC3bC5        
    pr38 = addreaction(model, '[C3bBbC3bPC5 host] -> C5a + [C3bBbC3bPC5b host]', 'ReactionRate',... 
        '[k_C5_cat_C3bBbC3b] * [C3bBbC3bPC5 host]', 'Name', 'pr38');          
else
    pr38 = addreaction(model, '[C3bBbC3bP host]  + C5 -> C5a + [C3bBbC3bPC5b host]', 'ReactionRate',... 
       '[k_C5_cat_C3bBbC3b] * [C3bBbC3bP host] * C5 / ([K_C5_m_C3bBbC3b] + C5)',...
                   'Name', 'pr38');                 
end          
          
% Equation 10
% pr39
pr39 = addreaction(model, '[C3bBbC3bPC5b host] + C6 <-> [C3bBbC3bPC5bC6 host]', 'ReactionRate',... 
    '[k_p_C3bBbC3bC5bC6] * [C3bBbC3bPC5b host] * C6 - [k_m_C3bBbC3bC5bC6] * [C3bBbC3bPC5bC6 host]', 'Name', 'pr39'); 
           
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (iv) Regulation (host cell and fluid state)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Equation 4
% 30
r30 = addreaction(model, '[C3] + [C3bBb host] -> [C3a] + [nhC3b] + [C3bBb host]', 'ReactionRate',... 
                   '[k_C3_cat_C3bBb] * [C3] * [C3bBb host] / ([K_C3_m_C3bBb] + [C3])', 'Name', 'r30');
% 31           
r31 = addreaction(model, '[nhC3b] + [Surface host] -> [C3b host]', 'ReactionRate',... 
                   '[k_p_hC3b] * [nhC3b] * [Surface host] * 15.6', 'Name', 'r31');
% r31 = addreaction(model, '[nhC3b] + [Surface host] -> [C3b host]', 'ReactionRate',... 
%                    '[k_p_hC3b] * [nhC3b] * [Surface host]', 'Name', 'r31');
               
% 32             
r32 = addreaction(model, '[nhC3b] + [C3bBb host] -> [C3bBbC3b host]', 'ReactionRate',... 
                   '[k_p_C3bBbC3b] * [nhC3b] * [C3bBb host]', 'Name', 'r32');
% Equation 5               
% 33            
r33 = addreaction(model, '[hC5b7 fluid] + [Surface host] + [Surface host] + [Surface host] + [Surface host] ->  [C5b7 host] ', 'ReactionRate',... 
                   '[k_p_C5b7 surface] * [hC5b7 fluid] * [Surface host] * 1.4', 'Name', 'r33');
               
% Equation 6                         
r34 = addreaction(model, '[C3b host] + CR1 <->  [C3bCR1 host]', 'ReactionRate',... 
                   '[k_p_C3bCR1] * [C3b host] * CR1 - [k_m_C3bCR1] * [C3bCR1 host]', 'Name', 'r34');           
r35 = addreaction(model, '[C3b host] + H <->  [C3bH host]', 'ReactionRate',... 
                   '[k_p_C3bH_surf] * [C3b host] * H - [k_m_C3bH] * [C3bH host]', 'Name', 'r35');                           
r36 = addreaction(model, '[C3b host] + B <->  [C3bB host]', 'ReactionRate',... 
                   '[k_p_C3bB] * [C3b host] * B - [k_m_C3bB] * [C3bB host]', 'Name', 'r36');              
r37 = addreaction(model, '[C3bBbH host] -> H + Bb + [C3b host]', 'ReactionRate',... 
                   '[k_m_C3bBbH decay] * [C3bBbH host]', 'Name', 'r37');              
r37_0 = addreaction(model, '[C3bBb host] -> Bb + [C3b host]', 'ReactionRate',... 
                   '[k_m_C3bBb] * [C3bBb host]', 'Name', 'r37_0');                                           
r38 = addreaction(model, '[C3bBbCR1 host] -> CR1 + Bb +  [C3b host]', 'ReactionRate',... 
                   '[k_m_C3bBbCR1 decay] * [C3bBbCR1 host]', 'Name', 'r38');                           
r39 = addreaction(model, '[C3bBbDAF host] -> DAF + Bb + [C3b host]', 'ReactionRate',... 
                   '[k_m_C3bBbDAF decay] * [C3bBbDAF host]', 'Name', 'r39');                           
r40 = addreaction(model, '[C3bBbC3b host] -> Bb + [C3b host] + [C3b fluid]', 'ReactionRate',... 
                   '[k_m_C3bBbC3b] * [C3bBbC3b host]', 'Name', 'r40');               
% Equation 7               
% 41     
r41 = addreaction(model, '[C3bB host] + D -> [C3bBb host] + Ba + D', 'ReactionRate',... 
       '[k_D_cat_C3bB] * D * [C3bB host] / ([K_D_m_C3(H2O)B] + [C3bB fluid] + [C3(H2O)B fluid] + [C3bB host]+ [C3bBP host])',...
       'Name', 'r41');  

% Equation 8               
% 42     
r42 = addreaction(model, '[C3bBb host] + H -> [C3bBbH host]', 'ReactionRate',... 
                   '[k_p_C3bH_surf] * [C3bBb host] * H', 'Name', 'r42');    
% 43     
r43 = addreaction(model, '[C3bBb host] + CR1 -> [C3bBbCR1 host]', 'ReactionRate',... 
                   '[k_p_C3bCR1] * [C3bBb host] * CR1', 'Name', 'r43');   
 % 44     
r44 = addreaction(model, '[C3bBb host] + DAF -> [C3bBbDAF host]', 'ReactionRate',... 
                   '[k_p_C3bBbDAF] * [C3bBb host] * DAF', 'Name', 'r44');                          
% Equation 12               
% 45        
r45 = addreaction(model, '[C3bCR1 host] + I -> CR1 + [iC3b host] + I', 'ReactionRate',... 
       '[k_FI_cat_C3bH] * I * [C3bCR1 host] / ([K_FI_m_C3bH] + [C3bH fluid] + [C3bCR1 fluid] + [iC3bCR1 fluid] + [C3bH host] + [C3bCR1 host] + [iC3bCR1 host])',...
       'Name', 'r45');             
% Equation 13               
% 46
r46 = addreaction(model, '[iC3b host] + CR1 <-> [iC3bCR1 host]', 'ReactionRate',... 
                   '[k_p_iC3bCR1] * [iC3b host] * CR1 - [k_m_iC3bCR1] * [iC3bCR1 host]', 'Name', 'r46'); 
% Equation 14  
% 47               
r47 = addreaction(model, '[C3bH host] + I -> H + [iC3b host] + I', 'ReactionRate',... 
       '[k_FI_cat_C3bH] * I * [C3bH host] / ([K_FI_m_C3bH] + [C3bH fluid] + [C3bCR1 fluid] + [iC3bCR1 fluid] + [C3bH host] + [C3bCR1 host] + [iC3bCR1 host])',...
       'Name', 'r47');             
% Equation 15  
% 48  
r48 = addreaction(model, '[iC3bCR1 host]  + I -> CR1 + [C3dg host] + I', 'ReactionRate',... 
       '[k_FI_cat_C3bH] * I * [iC3bCR1 host] / ([K_FI_m_C3bH] + [C3bH fluid] + [C3bCR1 fluid] + [iC3bCR1 fluid] + [C3bH host] + [C3bCR1 host] + [iC3bCR1 host])',...
       'Name', 'r48');             
% Equation 17  
% 49  
r49 = addreaction(model, '[C3bH fluid] + I -> H + [iC3b fluid] + I', 'ReactionRate',... 
       '[k_FI_cat_C3bH] * I * [C3bH fluid] / ([K_FI_m_C3bH] + [C3bH fluid] + [C3bCR1 fluid] + [iC3bCR1 fluid] + [C3bH host] + [C3bCR1 host] + [iC3bCR1 host])',...
       'Name', 'r49');             
% Equation 18  
% 50  
r50 = addreaction(model, '[iC3b fluid] + CR1 <-> [iC3bCR1 fluid]', 'ReactionRate',... 
                   '[k_p_iC3bCR1] * [iC3b fluid] * CR1 - [k_m_iC3bCR1] * [iC3bCR1 fluid]',...
                   'Name', 'r50');
% 51  
r51 = addreaction(model, '[C3bCR1 fluid] + I -> CR1 + [iC3b fluid] + I', 'ReactionRate',... 
       '[k_FI_cat_C3bH] * I * [C3bCR1 fluid] / ([K_FI_m_C3bH] + [C3bH fluid] + [C3bCR1 fluid] + [iC3bCR1 fluid] + [C3bH host] + [C3bCR1 host] + [iC3bCR1 host])',...
       'Name', 'r51');             
% Equation 20    
% 52  
r52 = addreaction(model, '[iC3bCR1 fluid] + I -> CR1 + [C3dg fluid] + I', 'ReactionRate',... 
       '[k_FI_cat_C3bH] * I * [iC3bCR1 fluid] / ([K_FI_m_C3bH] + [C3bH fluid] + [C3bCR1 fluid] + [iC3bCR1 fluid] + [C3bH host] + [C3bCR1 host] + [iC3bCR1 host])',...
       'Name', 'r52');             
     
% Equation 24    
% 53     
r53 = addreaction(model, '[C3bBbC3b host] + CR1  -> [C3bBbC3bCR1 host]', 'ReactionRate',... 
                   '[k_p_C3bCR1] * [C3bBbC3b host] * CR1', 'Name', 'r53'); 
% 54     
r54 = addreaction(model, '[C3bBbC3b host] + DAF  -> [C3bBbC3bDAF host]', 'ReactionRate',... 
                   '[k_p_C3bBbDAF] * [C3bBbC3b host] * DAF', 'Name', 'r54');                
% 55     
r55 = addreaction(model, '[C3bBbC3b host] + H  -> [C3bBbC3bH host]', 'ReactionRate',... 
                   '[k_p_C3bH_surf] * [C3bBbC3b host] * H', 'Name', 'r55');                

% 57     
r57 = addreaction(model, '[C3bBbC3bC5b host]  -> C5b + [C3bBbC3b host]', 'ReactionRate',... 
                   '[k_m_C5b] * [C3bBbC3bC5b host]', 'Name', 'r57');                
% 58 CHECK: CHANGED k_p_C5bC6C7 = k_p_C5b7.    
r58 = addreaction(model, '[C3bBbC3bC5bC6 host] + C7 -> [C3bBbC3b host] + [hC5b7 fluid]', 'ReactionRate',... 
                   '[k_p_C5b7] * [C3bBbC3bC5bC6 host] * C7', 'Name', 'r58');   
% Equation 28                   
% 59 CHECK
% CHANGE: MM  enzymatic reaction k_kcat_C3bBbC3bC5 not found in paramter list 
if C5_concvertase_original == 1
    % 56     
    r56 = addreaction(model, '[C3bBbC3b host] + C5  <-> [C3bBbC3bC5 host]', 'ReactionRate',... 
                   '[k_p_C3bBbC3bC5] * [C3bBbC3b host] * C5 - [k_m_C3bBbC3bC5] * [C3bBbC3bC5 host]',...
                   'Name', 'r56'); 
    r59 = addreaction(model, '[C3bBbC3bC5 host] -> C5a + [C3bBbC3bC5b host]', 'ReactionRate',... 
                   '[k_C5_cat_C3bBbC3b] * [C3bBbC3bC5 host]', 'Name', 'r59');          
else
    r59 = addreaction(model, '[C3bBbC3b host]  + C5 -> C5a + [C3bBbC3bC5b host]', 'ReactionRate',... 
                   '[k_C5_cat_C3bBbC3b] * [C3bBbC3b host] * C5 / ([K_C5_m_C3bBbC3b] + C5)',...
                   'Name', 'r59');                 
end
% Equation 29                   
% 60   
r60 = addreaction(model, '[C3bBbC3bC5b host] + C6 <-> [C3bBbC3bC5bC6 host]', 'ReactionRate',... 
                   '[k_p_C3bBbC3bC5bC6] * [C3bBbC3bC5b host] * C6 - [k_m_C3bBbC3bC5bC6] * [C3bBbC3bC5bC6 host]',...
                   'Name', 'r60');                                                         
% Equation 31                   
% 62   
r62 = addreaction(model, '[hC5b7 fluid] -> C5b7 micelle', 'ReactionRate',... 
                   '[k_p_C5b7 micelle] * [hC5b7 fluid]', 'Name', 'r62');      
% 63
r63 = addreaction(model, '[hC5b7 fluid] + C8 <-> [C5b8 fluid]', 'ReactionRate',... 
                   '[k_p_C5b8] * [hC5b7 fluid] * C8 - [k_m_C5b8] * [C5b8 fluid]', 'Name', 'r63');                 
% 64   
r64 = addreaction(model, '[hC5b7 fluid] + Cn <-> [CnC5b7 fluid]', 'ReactionRate',... 
                   '[k_p_CnC5b7] * [hC5b7 fluid] * Cn - [k_m_CnC5b7] * [CnC5b7 fluid]', 'Name', 'r64');                         
% 65   
r65 = addreaction(model, '[hC5b7 fluid] + Vn <-> [VnC5b7 fluid]', 'ReactionRate',... 
                   '[k_p_VnC5b7] * [hC5b7 fluid] * Vn - [k_m_VnC5b7] * [VnC5b7 fluid]', 'Name', 'r65');    
% Equation 32 
% 66  
r66 = addreaction(model, '[C5b7 host] + C8 -> [C5b8 host]', 'ReactionRate',... 
                   '[k_p_C5b8] * [C5b7 host] * C8', 'Name', 'r66');                
% Equation 33 
% 67  
r67 = addreaction(model, '[C5b8 host] + C9 -> [C5b9_1 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b8 host] * C9', 'Name', 'r67');  
               
               
r67_1 = addreaction(model, '[C5b9_1 host] + C9 -> [C5b9_2 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_1 host] * C9', 'Name', 'r67_1');                
r67_2 = addreaction(model, '[C5b9_2 host] + C9 -> [C5b9_3 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_2 host] * C9', 'Name', 'r67_2'); 
r67_3 = addreaction(model, '[C5b9_3 host] + C9 -> [C5b9_4 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_3 host] * C9', 'Name', 'r67_3');                 
r67_4 = addreaction(model, '[C5b9_4 host] + C9 -> [C5b9_5 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_4 host] * C9', 'Name', 'r67_4');                
r67_5 = addreaction(model, '[C5b9_5 host] + C9 -> [C5b9_6 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_5 host] * C9', 'Name', 'r67_5');               
r67_6 = addreaction(model, '[C5b9_6 host] + C9 -> [C5b9_7 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_6 host] * C9', 'Name', 'r67_6');                 
r67_7 = addreaction(model, '[C5b9_7 host] + C9 -> [C5b9_8 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_7 host] * C9', 'Name', 'r67_7');                 
r67_8 = addreaction(model, '[C5b9_8 host] + C9 -> [C5b9_9 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_8 host] * C9', 'Name', 'r67_8');   
r67_9 = addreaction(model, '[C5b9_9 host] + C9 -> [C5b9_10 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_9 host] * C9', 'Name', 'r67_9');               
r67_10= addreaction(model, '[C5b9_10 host] + C9 -> [C5b9_11 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_10 host] * C9', 'Name', 'r67_10');  
r67_11= addreaction(model, '[C5b9_11 host] + C9 -> [C5b9_12 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_11 host] * C9', 'Name', 'r67_11');                
r67_12= addreaction(model, '[C5b9_12 host] + C9 -> [C5b9_13 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_12 host] * C9', 'Name', 'r67_12'); 
r67_13= addreaction(model, '[C5b9_13 host] + C9 -> [C5b9_14 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_13 host] * C9', 'Name', 'r67_13');               
r67_14= addreaction(model, '[C5b9_14 host] + C9 -> [C5b9_15 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_14 host] * C9', 'Name', 'r67_14'); 
r67_15= addreaction(model, '[C5b9_15 host] + C9 -> [C5b9_16 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_15 host] * C9', 'Name', 'r67_15');  
r67_16= addreaction(model, '[C5b9_16 host] + C9 -> [C5b9_17 host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_16 host] * C9', 'Name', 'r67_16');               
               
% Equation 34 
% 68  CHECK. it was changed from original set up
r68 = addreaction(model, '[C5b9_17 host] + C9 -> [MAC host]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b9_17 host] * C9', 'Name', 'r68'); 
% 69                
r69 = addreaction(model, '[C5b9_1 host] + CD59 <-> [CD59C5b9_1 host]', 'ReactionRate',... 
                   '[k_p_CD59C5b9] * [C5b9_1 host] * CD59 - [k_m_CD59C5b9] * [CD59C5b9_1 host]', 'Name', 'r69');                  
% Equation 37 
% 70  
r70 = addreaction(model, '[VnC5b7 fluid] + C8 <-> [VnC5b8 fluid]', 'ReactionRate',... 
                   '[k_p_VnC5b8] * [VnC5b7 fluid] * C8 - [k_m_VnC5b8] * [VnC5b8 fluid]', 'Name', 'r70');
% Equation 38 
% 71  
r71 = addreaction(model, '[VnC5b8 fluid] + C9 <-> [VnC5b9_1 fluid]', 'ReactionRate',... 
                   '[k_p_VnC5b9] * [VnC5b8 fluid] * C9 - [k_m_VnC5b9] * [VnC5b9_1 fluid]', 'Name', 'r71');               
% Equation 40 
% 72  
r72 = addreaction(model, '[CnC5b7 fluid] + C8 <-> [CnC5b8 fluid]', 'ReactionRate',... 
                   '[k_p_CnC5b8] * [CnC5b7 fluid] * C8 - [k_m_CnC5b8] * [CnC5b8 fluid]', 'Name', 'r72');  
% Equation 41 
% 73  
r73 = addreaction(model, '[CnC5b8 fluid] + C9 <-> [CnC5b9_1 fluid]', 'ReactionRate',... 
                   '[k_p_CnC5b9] * [CnC5b8 fluid] * C9 - [k_m_CnC5b9] * [CnC5b9_1 fluid]', 'Name', 'r73');  
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              
%(v) Complement Proteins (host cell and fluid state)
% The following reaction should have been in (iv) of Zewde              
% Equation 17 
r74 = addreaction(model, '[C5b8 fluid] + C9 <-> [C5b9_1 fluid]', 'ReactionRate',... 
                   '[k_p_C5b9] * [C5b8 fluid] * C9 - [k_m_C5b9] * [C5b9_1 fluid]', 'Name', 'r74');               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 