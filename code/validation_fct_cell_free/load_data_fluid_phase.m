function [bergseth, morad, bexbornC3H2O, bexbornC3b, pangburn, sagar] = load_data_fluid_phase(plot_on)

% molecular weights for conversion from uM to ug/mL
MW = get_MW();

% C3a,  C5a, C3dg, Bb (ug/mL)
bergseth     = groupedData(readtable('../Data/Bergseth.csv', 'Delimiter', ','));
% C3a (ug/mL), C5a (ng/mL) 
morad        = groupedData(readtable('../Data/morad.csv', 'Delimiter', ','));
% C3a (ug/mL)
bexbornC3H2O = groupedData(readtable('../Data/bexborn_C3_H2O.csv', 'Delimiter', ','));
bexbornC3b   = groupedData(readtable('../Data/bexborn_C3b.csv', 'Delimiter', ','));
% percent activity
pangburn     = groupedData(readtable('../Data/pangburn_C3.csv', 'Delimiter', ','));
% C5a (uM) 
sagar        = groupedData(readtable('../Data/Sagar_uM.csv', 'Delimiter', ','));

% Convert all units in ug/mL
sagar.C3a = sagar.C3a * MW.C3a / 1000;
sagar.C5a = sagar.C5a * MW.C5a / 1000;
morad.C5a = morad.C5a / 1000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting
if(plot_on)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure_folder = '../Figures/Figures_validation_data/';
    mkdir(figure_folder)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    h=figure; hold on
    subplot(2, 3, 1);
    hold on
    plot(bergseth.TIME, bergseth.C3a, '-ob'  );
    plot(bergseth.TIME, bergseth.Bb,  '-x'  );
    plot(bergseth.TIME, bergseth.C3dg, '-x'  );
    ylim([0, 200])
    xlabel('Time (hour)');
    ylabel('ug/mL');
    legend('C3a','Bb','C3dg');
    title('Bergseth');

    subplot(2, 3, 4);
    hold on
    plot(bergseth.TIME, bergseth.C5a, '-or'  );
    ylim([0, 5])
    xlabel('Time (hour)');
    ylabel('ug/mL');
    legend('C5a');

    subplot(2, 3, 2);
    hold on
    plot(morad.TIME, morad.C3a, '-ob'  );
    ylim([0, 200])
    xlabel('Time (hour)');
    ylabel('ug/mL');
    title('Morad');

    subplot(2, 3, 5);
    hold on
    plot(morad.TIME, morad.C5a, '-or'  );
    ylim([0, 5])
    xlabel('Time (hour)');
    ylabel('ug/mL');

    subplot(2, 3, 3);
    hold on
    % Data is converted from uM and hours
    plot(sagar.TIME, sagar.C3a, '-ob'  );
    ylim([0, 200])
    xlabel('Time (hour)');
    ylabel('ug/mL');
    title('Sagar');

    subplot(2, 3, 6);
    hold on
    % Data is converted from uM and hours
    plot(sagar.TIME, sagar.C5a, '-or'  );
    ylim([0, 5])
    xlabel('Time (hour)');
    ylabel('ug/mL');

    saveas(h, [figure_folder, 'C3a-C5a.png'], 'png')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    h=figure; hold on
    subplot(1, 2, 1);
    hold on
    plot(bexbornC3H2O.TIME, bexbornC3H2O.C3a_FH_FI, '--ob'  );
    plot(bexbornC3H2O.TIME, bexbornC3H2O.C3a_No_FH_FI, '-ob'  );
    xlabel('Time (hour)');
    ylabel('ug/mL');
    legend('C3a with Factors H and I','C3a without');
    title('Bexborn C3(H2O)');

    subplot(1, 2, 2);
    hold on
    plot(bexbornC3b.TIME, bexbornC3b.C3a_FH_FI, '--ob'  );
    plot(bexbornC3b.TIME, bexbornC3b.C3a_No_FH_FI, '-ob'  );
    xlabel('Time (hour)');
    ylabel('ug/mL');
    %legend('C3a with Factors H and I','C3a');
    title('Bexborn C3b');
    saveas(h, [figure_folder, 'C3a-Bexborn.png'], 'png')

    h=figure; hold on
    hold on
    plot(pangburn.TIME, pangburn.C3,     '-o'  );
    plot(pangburn.TIME, pangburn.C3BD,   '-s'  );
    plot(pangburn.TIME, pangburn.C3IHBD, '-x'  );
    xlabel('Time (hour)');
    ylabel('Percent C3 hemolytic activity');
    legend('C3 and I, H, B, D','C3 and Factors I, H, B, D','Bb');
    title('Pangburn 1981');
    saveas(h, [figure_folder, 'C3-activity-Pangburn_1981.png'], 'png')
    
    close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end
