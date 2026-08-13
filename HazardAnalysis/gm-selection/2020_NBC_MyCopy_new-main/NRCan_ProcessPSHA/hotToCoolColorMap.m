function colorLIST = hotToCoolColorMap(n)

% source- https://colorbrewer2.org/
if n ~= 12 && n ~= 11 && n ~= 9 && n ~= 7 && n~= 5
    error('Color map only defined for n = 5, 7, 9, 11, and 12 colors')
end

switch n
    case 12
        % 11+1 diverging hot-to-cool color-scheme
        colorLIST = [165,0,38;
            215,48,39;
            244,109,67;
            253,174,97;
            254,224,144;
            255,255,191;
            224,243,248;
            171,217,233;
            116,173,209;
            69,117,180;
            49,54,149;
            19, 27, 89]; % added manually
    
    case 11
        % 11 diverging hot-to-cool color-scheme
        colorLIST = [165,0,38;
            215,48,39;
            244,109,67;
            253,174,97;
            254,224,144;
            255,255,191;
            224,243,248;
            171,217,233;
            116,173,209;
            69,117,180;
            49,54,149];

    case 9
        % 9 diverging hot-to-cool color-scheme
        colorLIST = [215,48,39;
            244,109,67;
            253,174,97;
            254,224,144;
            255,255,191;
            224,243,248;
            171,217,233;
            116,173,209;
            69,117,180];

    case 7
        % 7 diverging hot-to-cool color-scheme
        colorLIST = [215,48,39;
            252,141,89;
            254,224,144;
            255,255,191;
            224,243,248;
            145,191,219;
            69,117,180];

    case 5
        % 5 diverging hot-to-cool color-scheme
        colorLIST = [215,25,28;
            253,174,97;
            255,255,191;
            171,217,233;
            44,123,182];
end

colorLIST = colorLIST/255;