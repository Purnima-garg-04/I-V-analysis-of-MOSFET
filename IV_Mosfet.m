clc; clear; close all;

while true
    try
        % User Inputs for MOSFET Parameters
        type = input('Enter MOSFET type (n for nMOS, p for pMOS): ', 's');
        Vgs = input('Enter Gate-Source Voltage (V): ');
        Vds_min = input('Enter Minimum Drain-Source Voltage (V): ');
        Vds_max = input('Enter Maximum Drain-Source Voltage (V): ');
        n_points = input('Enter Number of Points for Simulation: ');

        % MOSFET Parameters (Default Values)
        Vth = 1; % Threshold Voltage (V)
        K = 1e-3; % Process Transconductance Parameter (A/V^2)

        % Generate Drain-Source Voltage Range
        Vds = linspace(Vds_min, Vds_max, n_points);

        % Compute Drain Current (I_D) Based on MOSFET Region
        Id = zeros(size(Vds));
        for i = 1:length(Vds)
            if Vgs > Vth % If in conduction mode
                if Vds(i) < (Vgs - Vth)
                    Id(i) = K * ((Vgs - Vth) * Vds(i) - 0.5 * Vds(i)^2); % Triode Region
                else
                    Id(i) = 0.5 * K * (Vgs - Vth)^2; % Saturation Region
                end
            end
        end

        % Adjust for pMOS
        if type == 'p'
            Vds = -Vds;
            Id = -Id;
        end

        % Compute Transconductance Gain (gm)
        gm = K * (Vgs - Vth); 

        % Create a New Figure for Each MOSFET Type
        figure;
        hold on;
        title(['MOSFET I-V Characteristics (', upper(type), 'MOS)']);
        xlabel('Drain-Source Voltage (V)');
        ylabel('Drain Current (A)');
        grid on;
        plot(Vds, Id, 'LineWidth', 2);
        legend(['V_{GS} = ', num2str(Vgs), 'V, g_m = ', num2str(gm), ' S']);
        hold off;
        set(gca, 'FontSize', 14, 'LineWidth', 1.5); % Improve visibility
        
    catch
        disp('Exiting the program...');
        break;
    end
end
