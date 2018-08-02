function [featurenames54,featurenames51,featurenames36,featurenames33,featurenames17,featurenames12,featurenames11,featurenames51_names_only]=fname
% *.54 is with all 54 features including nnx and SDANN
% *.51 is with nnx (10-30) without SDANN

% *.36 is without nnx (10-30) and including SDANN
% *.33 is without nnx (10-30) and without   SDANN

% *.17 is only 5 min with nnx (10-30) without SDANN 
% *.12 is only 5 min without nnx (10-30) including SDANN
% *.11 is only 5 min without nnx (10-30) wihtout   SDANN

%featurenames51_names_only is for displaying or plotting


featurenames11={'+totpow 5min';...           %1
                       '+VLF 5min';...              %2
                       '+LF 5min';...               %3
                       '+LFnorm 5min';...           %4
                       '+HF 5min';...               %5
                       '+HFnorm 5min';...           %6
                       '+ratioLFHF 5min';...        %7
                       '+SDNN 5min';...             %8
                       '+RMSSD 5min';...            %9
                       '+NN50 5min';...             %10
                       'pNN50 5min';...            %11
 };                      
featurenames12={'+totpow 5min';...           %1
                       '+VLF 5min';...              %2
                       '+LF 5min';...               %3
                       '+LFnorm 5min';...           %4
                       '+HF 5min';...               %5
                       '+HFnorm 5min';...           %6
                       '+ratioLFHF 5min';...        %7
                       '+SDNN 5min';...             %8
                       '+SDANN 5min';...            %9
                       '+RMSSD 5min';...            %10
                       '+NN50 5min';...             %11
                       'pNN50 5min';...            %12
};
featurenames17={'+totpow 5min';...                  %1
                       '+VLF 5min';...              %2
                       '+LF 5min';...               %3
                       '+LFnorm 5min';...           %4
                       '+HF 5min';...               %5
                       '+HFnorm 5min';...           %6
                       '+ratioLFHF 5min';...        %7
                       '+SDNN 5min';...             %8
                       '+RMSSD 5min';...            %9
                       '+NN10 5min';...             %10
                       '+NN20 5min';...             %11
                       '+NN30 5min';...             %12
                       '+NN50 5min';...             %13
                       '+pNN10 5min';...            %14
                       '+pNN20 5min';...            %15
                       '+pNN30 5min';...            %16
                       '+pNN50 5min';...            %17
};
featurenames33={'+totpow 1min'; ...                 %1 
                       '+VLF 1min';...              %2 
                       '+LF 1min';...               %3 
                       '+LFnorm 1min';...           %4 
                       '+HF 1min';...               %5 
                       '+HFnorm 1min';...           %6 
                       '+ratioLFHF 1min';...        %7 
                       '+SDNN 1min';...             %8
                       '+RMSSD 1min';...            %9                 
                       '+NN50 1min';...             %10 
                       '+pNN50 1min';...            %11 
                       '+totpow 3min';...           %12 
                       '+VLF 3min';...              %13 
                       '+LF 3min';...               %14
                       '+LFnorm 3min';...           %15
                       '+HF 3min';...               %16 
                       '+HFnorm 3min';...           %17 
                       '+ratioLFHF 3min';...        %18 
                       '+SDNN 3min';...             %19 
                       '+RMSSD 3min';...            %20 
                       '+NN50 3min';...             %21
                       '+pNN50 3min';...            %22 
                       '+totpow 5min';...           %23
                       '+VLF 5min';...              %24
                       '+LF 5min';...               %25
                       '+LFnorm 5min';...           %26
                       '+HF 5min';...               %27
                       '+HFnorm 5min';...           %28
                       '+ratioLFHF 5min';...        %29
                       '+SDNN 5min';...             %30
                       '+RMSSD 5min';...            %31
                       '+NN50 5min';...             %32
                       'pNN50 5min';...            %33
};
featurenames36={'+totpow 1min'; ...                 %1 
                       '+VLF 1min';...              %2 
                       '+LF 1min';...               %3 
                       '+LFnorm 1min';...           %4 
                       '+HF 1min';...               %5 
                       '+HFnorm 1min';...           %6 
                       '+ratioLFHF 1min';...        %7 
                       '+SDNN 1min';...             %8
                       '+SDANN 1min';...            %9 
                       '+RMSSD 1min';...            %10                 
                       '+NN50 1min';...             %11 
                       '+pNN50 1min';...            %12 
                       '+totpow 3min';...           %13 
                       '+VLF 3min';...              %14 
                       '+LF 3min';...               %15
                       '+LFnorm 3min';...           %16
                       '+HF 3min';...               %17 
                       '+HFnorm 3min';...           %18 
                       '+ratioLFHF 3min';...        %19 
                       '+SDNN 3min';...             %20 
                       '+SDANN 3min';...            %21 
                       '+RMSSD 3min';...            %22 
                       '+NN50 3min';...             %23
                       '+pNN50 3min';...            %24 
                       '+totpow 5min';...           %25
                       '+VLF 5min';...              %26
                       '+LF 5min';...               %27
                       '+LFnorm 5min';...           %28
                       '+HF 5min';...               %29
                       '+HFnorm 5min';...           %30
                       '+ratioLFHF 5min';...        %31
                       '+SDNN 5min';...             %32
                       '+SDANN 5min';...            %33
                       '+RMSSD 5min';...            %34
                       '+NN50 5min';...             %35
                       'pNN50 5min';...             %36
};
featurenames51={'+totpow 1min'; ...                 %1 
                       '+VLF 1min';...              %2 
                       '+LF 1min';...               %3 
                       '+LFnorm 1min';...           %4 
                       '+HF 1min';...               %5 
                       '+HFnorm 1min';...           %6 
                       '+ratioLFHF 1min';...        %7 
                       '+SDNN 1min';...             %8 
                       '+RMSSD 1min';...            %9 
                       '+NN10 1min';...             %10
                       '+NN20 1min';...             %11 
                       '+NN30 1min';...             %12 
                       '+NN50 1min';...             %13 
                       '+pNN10 1min';...            %14
                       '+pNN20 1min';...            %15 
                       '+pNN30 1min';...            %16 
                       '+pNN50 1min';...            %17 
                       '+totpow 3min';...           %18 
                       '+VLF 3min';...              %19 
                       '+LF 3min';...               %20
                       '+LFnorm 3min';...           %21
                       '+HF 3min';...               %22 
                       '+HFnorm 3min';...           %23 
                       '+ratioLFHF 3min';...        %24 
                       '+SDNN 3min';...             %25 
                       '+RMSSD 3min';...            %26
                       '+NN10 3min';...             %27 
                       '+NN20 3min';...             %28 
                       '+NN30 3min';...             %29 
                       '+NN50 3min';...             %30
                       '+pNN10 3min';...            %31 
                       '+pNN20 3min';...            %32 
                       '+pNN30 3min';...            %33 
                       '+pNN50 3min';...            %34 
                       '+totpow 5min';...           %35
                       '+VLF 5min';...              %36
                       '+LF 5min';...               %37
                       '+LFnorm 5min';...           %38
                       '+HF 5min';...               %39
                       '+HFnorm 5min';...           %40
                       '+ratioLFHF 5min';...        %41
                       '+SDNN 5min';...             %42
                       '+RMSSD 5min';...            %43
                       '+NN10 5min';...             %44
                       '+NN20 5min';...             %45
                       '+NN30 5min';...             %46
                       '+NN50 5min';...             %47
                       '+pNN10 5min';...            %48
                       '+pNN20 5min';...            %49
                       '+pNN30 5min';...            %50
                       '+pNN50 5min';...            %51
};
featurenames54={'+totpow 1min'; ...                 %1 
                       '+VLF 1min';...              %2 
                       '+LF 1min';...               %3 
                       '+LFnorm 1min';...           %4 
                       '+HF 1min';...               %5 
                       '+HFnorm 1min';...           %6 
                       '+ratioLFHF 1min';...        %7 
                       '+SDNN 1min';...             %8
                       '+SDANN 1min';...            %9 
                       '+RMSSD 1min';...            %10 
                       '+NN10 1min';...             %11
                       '+NN20 1min';...             %12 
                       '+NN30 1min';...             %13 
                       '+NN50 1min';...             %14 
                       '+pNN10 1min';...            %15
                       '+pNN20 1min';...            %16 
                       '+pNN30 1min';...            %17 
                       '+pNN50 1min';...            %18 
                       '+totpow 3min';...           %19 
                       '+VLF 3min';...              %20 
                       '+LF 3min';...               %21
                       '+LFnorm 3min';...           %22
                       '+HF 3min';...               %23 
                       '+HFnorm 3min';...           %24 
                       '+ratioLFHF 3min';...        %25 
                       '+SDNN 3min';...             %26 
                       '+SDANN 3min';...            %27 
                       '+RMSSD 3min';...            %28 
                       '+NN10 3min';...             %29 
                       '+NN20 3min';...             %30 
                       '+NN30 3min';...             %31 
                       '+NN50 3min';...             %32
                       '+pNN10 3min';...            %33 
                       '+pNN20 3min';...            %34 
                       '+pNN30 3min';...            %35 
                       '+pNN50 3min';...            %36 
                       '+totpow 5min';...           %37
                       '+VLF 5min';...              %38
                       '+LF 5min';...               %39
                       '+LFnorm 5min';...           %40
                       '+HF 5min';...               %41
                       '+HFnorm 5min';...           %42
                       '+ratioLFHF 5min';...        %43
                       '+SDNN 5min';...             %44
                       '+SDANN 5min';...            %45
                       '+RMSSD 5min';...            %46
                       '+NN10 5min';...             %47
                       '+NN20 5min';...             %48
                       '+NN30 5min';...             %49
                       '+NN50 5min';...             %50
                       '+pNN10 5min';...            %51
                       '+pNN20 5min';...            %52
                       '+pNN30 5min';...            %53
                       '+pNN50 5min';...            %54
};
featurenames51_names_only={'totpow_1min '; ...                 %1 
                       'VLF_1min ';...              %2 
                       'LF_1min ';...               %3 
                       'LFnorm_1min ';...           %4 
                       'HF_1min ';...               %5 
                       'HFnorm_1min ';...           %6 
                       'ratioLFHF_1min ';...        %7 
                       'SDNN_1min ';...             %8 
                       'RMSSD_1min ';...            %9 
                       'NN10_1min ';...             %10
                       'NN20_1min ';...             %11 
                       'NN30_1min ';...             %12 
                       'NN50_1min ';...             %13 
                       'pNN10_1min ';...            %14
                       'pNN20_1min ';...            %15 
                       'pNN30_1min ';...            %16 
                       'pNN50_1min ';...            %17 
                       'totpow_3min ';...           %18 
                       'VLF_3min ';...              %19 
                       'LF_3min ';...               %20
                       'LFnorm_3min ';...           %21
                       'HF_3min ';...               %22 
                       'HFnorm_3min ';...           %23 
                       'ratioLFHF_3min ';...        %24 
                       'SDNN_3min ';...             %25 
                       'RMSSD_3min ';...            %26
                       'NN10_3min ';...             %27 
                       'NN20_3min ';...             %28 
                       'NN30_3min ';...             %29 
                       'NN50_3min ';...             %30
                       'pNN10_3min ';...            %31 
                       'pNN20_3min ';...            %32 
                       'pNN30_3min ';...            %33 
                       'pNN50_3min ';...            %34 
                       'totpow_5min ';...           %35
                       'VLF_5min ';...              %36
                       'LF_5min ';...               %37
                       'LFnorm_5min ';...           %38
                       'HF_5min ';...               %39
                       'HFnorm_5min ';...           %40
                       'ratioLFHF_5min ';...        %41
                       'SDNN_5min ';...             %42
                       'RMSSD_5min ';...            %43
                       'NN10_5min ';...             %44
                       'NN20_5min ';...             %45
                       'NN30_5min ';...             %46
                       'NN50_5min ';...             %47
                       'pNN10_5min ';...            %48
                       'pNN20_5min ';...            %49
                       'pNN30_5min ';...            %50
                       'pNN50_5min ';...            %51
};
end