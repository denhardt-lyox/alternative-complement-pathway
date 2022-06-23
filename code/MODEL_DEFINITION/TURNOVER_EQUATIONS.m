function TURNOVER_EQUATIONS(model)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reactions for the production and elimination of the elementary complement
% pathway components

%% Erythrocyte turnover
% cell_turnover_1 = addreaction(model, 'null -> Erythrocytes_uM',  'ReactionRate', 'k_pr_erythrocytes', 'Name', 'p_cell_turnover');
% cell_turnover_2 = addreaction(model, 'Erythrocytes_uM -> null',  'ReactionRate', 'Erythrocytes_uM * (k_el_erythrocytes + k_hemolysis)', 'Name', 'e_cell_turnover');

%%% activate these lines if you want non-constant total surface, i.e. if you want constant surface per cell
cell_turnover_3 = addreaction(model, 'null -> [Surface host]',  'ReactionRate', 'k_pr_surface', 'Name', 'p_cell_turnover_Surface');
cell_turnover_4 = addreaction(model, '[Surface host] -> null',  'ReactionRate', '[Surface host] * (k_el_erythrocytes + k_hemolysis)', 'Name', 'e_cell_turnover_Surface');



%% ACP proteins productions
% Production of fluid phase ACP components
p1  = addreaction(model, 'null -> C3',  'ReactionRate', 'k_pr_C3', 'Name', 'p1');
p2  = addreaction(model, 'null -> C5',  'ReactionRate', 'k_pr_C5', 'Name', 'p2'); 
p3  = addreaction(model, 'null -> C6',  'ReactionRate', 'k_pr_C6', 'Name', 'p3');
p4  = addreaction(model, 'null -> C7',  'ReactionRate', 'k_pr_C7', 'Name', 'p4');
p5  = addreaction(model, 'null -> C8',  'ReactionRate', 'k_pr_C8', 'Name', 'p5');
p6  = addreaction(model, 'null -> C9',  'ReactionRate', 'k_pr_C9', 'Name', 'p6');
p7  = addreaction(model, 'null -> B',   'ReactionRate', 'k_pr_B',  'Name', 'p7');
p8  = addreaction(model, 'null -> D',   'ReactionRate', 'k_pr_D',  'Name', 'p8');
p9  = addreaction(model, 'null -> P',   'ReactionRate', 'k_pr_P',  'Name', 'p9');

p10  = addreaction(model, 'null -> I',   'ReactionRate', 'k_pr_I',  'Name', 'p10');
p11  = addreaction(model, 'null -> H',   'ReactionRate', 'k_pr_H',  'Name', 'p11');
p12  = addreaction(model, 'null -> Vn',  'ReactionRate', 'k_pr_Vn', 'Name', 'p12');
p13  = addreaction(model, 'null -> Cn',  'ReactionRate', 'k_pr_Cn', 'Name', 'p13');

% Production of surface-bound ACP components
p14  = addreaction(model, 'null -> CR1',  'ReactionRate', 'k_pr_CR1',  'Name', 'p14');
p15  = addreaction(model, 'null -> DAF',  'ReactionRate', 'k_pr_DAF',  'Name', 'p15');
p16  = addreaction(model, 'null -> CD59', 'ReactionRate', 'k_pr_CD59', 'Name', 'p16');


%% ACP components eliminiations
% Elimination from plasma of fluid phase ACP components
e1  = addreaction(model, 'C3 -> null', 'ReactionRate', 'C3 * k_el_C3', 'Name', 'e1');
e2  = addreaction(model, 'C5 -> null', 'ReactionRate', 'C5 * k_el_C5', 'Name', 'e2');
e3  = addreaction(model, 'C6 -> null', 'ReactionRate', 'C6 * k_el_C6', 'Name', 'e3');
e4  = addreaction(model, 'C7 -> null', 'ReactionRate', 'C7 * k_el_C7', 'Name', 'e4');
e5  = addreaction(model, 'C8 -> null', 'ReactionRate', 'C8 * k_el_C8', 'Name', 'e5');
e6  = addreaction(model, 'C9 -> null', 'ReactionRate', 'C9 * k_el_C9', 'Name', 'e6');
e7  = addreaction(model, 'B  -> null', 'ReactionRate', 'B  * k_el_B',  'Name', 'e7');
e8  = addreaction(model, 'D  -> null', 'ReactionRate', 'D  * k_el_D',  'Name', 'e8');
e9  = addreaction(model, 'P  -> null', 'ReactionRate', 'P  * k_el_P',  'Name', 'e9'); 

e10 = addreaction(model, 'I  -> null', 'ReactionRate', 'I  * k_el_I',  'Name', 'e10');
e11 = addreaction(model, 'H  -> null', 'ReactionRate', 'H  * k_el_H',  'Name', 'e11');
e12 = addreaction(model, 'Vn -> null', 'ReactionRate', 'Vn * k_el_Vn', 'Name', 'e12');
e13 = addreaction(model, 'Cn -> null', 'ReactionRate', 'Cn * k_el_Cn', 'Name', 'e13');

% Elimination of surface-bound ACP components (based on erythrocyte turnover)
e14 = addreaction(model, 'CR1   -> null', 'ReactionRate', 'CR1  * (k_el_CR1 + k_hemolysis)',  'Name', 'e14');
e15 = addreaction(model, 'CD59  -> null', 'ReactionRate', 'CD59 * (k_el_CD59 + k_hemolysis)', 'Name', 'e15');
e16 = addreaction(model, 'DAF   -> null', 'ReactionRate', 'DAF  * (k_el_DAF + k_hemolysis)',  'Name', 'e16');

% Clearance of all fluid phase reactants is based on the clearance of C3
e20  = addreaction(model, '[C3(H2O) fluid]      -> null', 'ReactionRate', '[C3(H2O) fluid]    * k_el_C3', 'Name', 'e20');
e21  = addreaction(model, '[C3(H2O)B fluid]     -> null', 'ReactionRate', '[C3(H2O)B fluid]   * k_el_C3', 'Name', 'e21');
e22  = addreaction(model, '[C3(H2O)H fluid]     -> null', 'ReactionRate', '[C3(H2O)H fluid]   * k_el_C3', 'Name', 'e22');
e23  = addreaction(model, '[C3(H2O)CR1 fluid]   -> null', 'ReactionRate', '[C3(H2O)CR1 fluid] * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e23');%k_el_C3
e24  = addreaction(model, '[C3(H2O)Bb fluid]    -> null', 'ReactionRate', '[C3(H2O)Bb fluid]  * k_el_C3', 'Name', 'e24');
e25  = addreaction(model, '[C3(H2O)BbH fluid]   -> null', 'ReactionRate', '[C3(H2O)BbH fluid] * k_el_C3', 'Name', 'e25');
e26  = addreaction(model, '[C3b fluid]          -> null', 'ReactionRate', '[C3b fluid]        * k_el_C3', 'Name', 'e26');
e27  = addreaction(model, '[C3bB fluid]         -> null', 'ReactionRate', '[C3bB fluid]       * k_el_C3', 'Name', 'e27');
e28  = addreaction(model, '[C3bH fluid]         -> null', 'ReactionRate', '[C3bH fluid]       * k_el_C3', 'Name', 'e28');
e29  = addreaction(model, '[C3bCR1 fluid]       -> null', 'ReactionRate', '[C3bCR1 fluid]     * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e29');%k_el_C3
e30  = addreaction(model, '[C3bBb fluid]        -> null', 'ReactionRate', '[C3bBb fluid]      * k_el_C3', 'Name', 'e30');
e31  = addreaction(model, '[C3bBbH fluid]       -> null', 'ReactionRate', '[C3bBbH fluid]     * k_el_C3', 'Name', 'e31');
e32  = addreaction(model, '[C3bBbCR1 fluid]     -> null', 'ReactionRate', '[C3bBbCR1 fluid]   * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e32'); %k_el_C3
e33  = addreaction(model, 'nfC3b                -> null', 'ReactionRate', 'nfC3b              * k_el_C3', 'Name', 'e33');
e34  = addreaction(model, 'nhC3b                -> null', 'ReactionRate', 'nhC3b              * k_el_C3', 'Name', 'e34');

e40  = addreaction(model, 'Ba   -> null', 'ReactionRate', 'Ba *  k_el_Ba',  'Name', 'e40');
e41  = addreaction(model, 'Bb   -> null', 'ReactionRate', 'Bb *  k_el_Bb',  'Name', 'e41');
e42  = addreaction(model, 'C3a  -> null', 'ReactionRate', 'C3a * k_el_C3a', 'Name', 'e42');
e43  = addreaction(model, 'C5a  -> null', 'ReactionRate', 'C5a * k_el_C5a', 'Name', 'e43');

e50  = addreaction(model, '[hC5b7 fluid]    -> null', 'ReactionRate', '[hC5b7 fluid]    * k_el_C5b_species',  'Name', 'e50');
e51  = addreaction(model, '[iC3b fluid]     -> null', 'ReactionRate', '[iC3b fluid]     * k_el_iC3b',         'Name', 'e51');
e52  = addreaction(model, '[iC3bCR1 fluid]  -> null', 'ReactionRate', '[iC3bCR1 fluid]  * (k_el_SurfaceProtein + k_hemolysis)',         'Name', 'e52'); %k_el_iC3b
e53  = addreaction(model, '[C3dg fluid]     -> null', 'ReactionRate', '[C3dg fluid]     * k_el_C3dg',         'Name', 'e53');
e54  = addreaction(model, '[C5b7 micelle]   -> null', 'ReactionRate', '[C5b7 micelle]   * k_el_C5b_species',  'Name', 'e54');
e55  = addreaction(model, '[C5b8 fluid]     -> null', 'ReactionRate', '[C5b8 fluid]     * k_el_C5b_species',  'Name', 'e55');
e56  = addreaction(model, '[CnC5b7 fluid]   -> null', 'ReactionRate', '[CnC5b7 fluid]   * k_el_C5b_species',  'Name', 'e56');
e57  = addreaction(model, '[VnC5b7 fluid]   -> null', 'ReactionRate', '[VnC5b7 fluid]   * k_el_C5b_species',  'Name', 'e57');
e58  = addreaction(model, '[VnC5b8 fluid]   -> null', 'ReactionRate', '[VnC5b8 fluid]   * k_el_C5b_species',  'Name', 'e58');
e59  = addreaction(model, '[VnC5b9_1 fluid] -> null', 'ReactionRate', '[VnC5b9_1 fluid] * k_el_C5b_species',  'Name', 'e59');
e60  = addreaction(model, '[CnC5b8 fluid]   -> null', 'ReactionRate', '[CnC5b8 fluid]   * k_el_C5b_species',  'Name', 'e60');
e61  = addreaction(model, '[CnC5b9_1 fluid] -> null', 'ReactionRate', '[CnC5b9_1 fluid] * k_el_C5b_species',  'Name', 'e61');
e62  = addreaction(model, '[C5b9_1 fluid]   -> null', 'ReactionRate', '[C5b9_1 fluid]   * k_el_C5b_species',  'Name', 'e62');

% Elimination of surface-bound downstream proteins (based on erythrocyte turnover)
e70   = addreaction(model, '[C3bBb host]          -> [Surface host]', 'ReactionRate',   '[C3bBb host]          * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e70');
e71   = addreaction(model, '[C3bBbC3b host]       -> [Surface host]', 'ReactionRate',   '[C3bBbC3b host]       * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e71');
e72   = addreaction(model, '[C3bBbC3bCR1 host]    -> [Surface host]', 'ReactionRate',   '[C3bBbC3bCR1 host]    * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e72');
e73   = addreaction(model, '[C3b host]            -> [Surface host]', 'ReactionRate',   '[C3b host]            * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e73');
e74   = addreaction(model, '[C3bBbC3bDAF host]    -> [Surface host]', 'ReactionRate',   '[C3bBbC3bDAF host]    * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e74');
e75   = addreaction(model, '[C3bBbC3bH host]      -> [Surface host]', 'ReactionRate',   '[C3bBbC3bH host]      * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e75');
e76   = addreaction(model, '[C3bBbP host]         -> [Surface host]', 'ReactionRate',   '[C3bBbP host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e76');
e77   = addreaction(model, '[C3bBbC3bP host]      -> [Surface host]', 'ReactionRate',   '[C3bBbC3bP host]      * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e77');
e78   = addreaction(model, '[C3bBP host]          -> [Surface host]', 'ReactionRate',   '[C3bBP host]          * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e78');
e79   = addreaction(model, '[iC3b host]           -> [Surface host]', 'ReactionRate',   '[iC3b host]           * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e79');
e80   = addreaction(model, '[iC3bP host]          -> [Surface host]', 'ReactionRate',   '[iC3bP host]          * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e80');
e81   = addreaction(model, '[C3bBbC3bPC5 host]    -> [Surface host]', 'ReactionRate',   '[C3bBbC3bPC5 host]    * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e81');
e82   = addreaction(model, '[C3bBbC3bC5 host]     -> [Surface host]', 'ReactionRate',   '[C3bBbC3bC5 host]     * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e82');
e83   = addreaction(model, '[C3bBbC3bPC5b host]   -> [Surface host]', 'ReactionRate',   '[C3bBbC3bPC5b host]   * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e83');
e84   = addreaction(model, '[C3bBbC3bC5b host]    -> [Surface host]', 'ReactionRate',   '[C3bBbC3bC5b host]    * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e84');
e85   = addreaction(model, '[C3bBbC3bPC5bC6 host] -> [Surface host]', 'ReactionRate',   '[C3bBbC3bPC5bC6 host] * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e85');
e86   = addreaction(model, '[C3bBbC3bC5bC6 host]  -> [Surface host]', 'ReactionRate',   '[C3bBbC3bC5bC6 host]  * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e86');
e87   = addreaction(model, '[C5b7 host]           -> [Surface host]', 'ReactionRate',   '[C5b7 host]           * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e87');
e88   = addreaction(model, '[C3bCR1 host]         -> [Surface host]', 'ReactionRate',   '[C3bCR1 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e88');
e89   = addreaction(model, '[C3bH host]           -> [Surface host]', 'ReactionRate',   '[C3bH host]           * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e89');
e90   = addreaction(model, '[C3bB host]           -> [Surface host]', 'ReactionRate',   '[C3bB host]           * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e90');
e91   = addreaction(model, '[C3bBbH host]         -> [Surface host]', 'ReactionRate',   '[C3bBbH host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e91');
e92   = addreaction(model, '[C3bBbCR1 host]       -> [Surface host]', 'ReactionRate',   '[C3bBbCR1 host]       * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e92');
e93   = addreaction(model, '[C3bBbDAF host]       -> [Surface host]', 'ReactionRate',   '[C3bBbDAF host]       * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e93');
e94   = addreaction(model, '[iC3bCR1 host]        -> [Surface host]', 'ReactionRate',   '[iC3bCR1 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e94');
e95   = addreaction(model, '[C3dg host]           -> [Surface host]', 'ReactionRate',   '[C3dg host]           * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e95');
e96   = addreaction(model, '[C5b8 host]           -> [Surface host]', 'ReactionRate',   '[C5b8 host]           * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e96');
e97   = addreaction(model, '[C5b9_1 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_1 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e97');
e98   = addreaction(model, '[C5b9_2 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_2 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e98');
e99   = addreaction(model, '[C5b9_3 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_3 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e99');
e100  = addreaction(model, '[C5b9_4 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_4 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e100');
e101  = addreaction(model, '[C5b9_5 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_5 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e101');
e102  = addreaction(model, '[C5b9_6 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_6 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e102');
e103  = addreaction(model, '[C5b9_7 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_7 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e103');
e104  = addreaction(model, '[C5b9_8 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_8 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e104');
e105  = addreaction(model, '[C5b9_9 host]         -> [Surface host]', 'ReactionRate',   '[C5b9_9 host]         * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e105');
e106  = addreaction(model, '[C5b9_10 host]        -> [Surface host]', 'ReactionRate',   '[C5b9_10 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e106');
e107  = addreaction(model, '[C5b9_11 host]        -> [Surface host]', 'ReactionRate',   '[C5b9_11 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e107');
e108  = addreaction(model, '[C5b9_12 host]        -> [Surface host]', 'ReactionRate',   '[C5b9_12 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e108');
e109  = addreaction(model, '[C5b9_13 host]        -> [Surface host]', 'ReactionRate',   '[C5b9_13 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e109');
e110  = addreaction(model, '[C5b9_14 host]        -> [Surface host]', 'ReactionRate',   '[C5b9_14 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e110');
e111  = addreaction(model, '[C5b9_15 host]        -> [Surface host]', 'ReactionRate',   '[C5b9_15 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e111');
e112  = addreaction(model, '[C5b9_16 host]        -> [Surface host]', 'ReactionRate',   '[C5b9_16 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e112');
e113  = addreaction(model, '[C5b9_17 host]        -> [Surface host]', 'ReactionRate',   '[C5b9_17 host]        * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e113');
e114  = addreaction(model, '[MAC host]            -> [Surface host]', 'ReactionRate',   '[MAC host]            * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e114');
e115  = addreaction(model, '[CD59C5b9_1 host]     -> [Surface host]', 'ReactionRate',   '[CD59C5b9_1 host]     * (k_el_SurfaceProtein + k_hemolysis)', 'Name', 'e115');


e132  = addreaction(model, 'C5drug          -> null', 'ReactionRate',   'C5drug      * k_el_Drug', 'Name', 'e132');
e133  = addreaction(model, '[C5drug C5]     -> null', 'ReactionRate',   '[C5drug C5] * k_el_Drug', 'Name', 'e133');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%