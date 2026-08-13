clear; clc
%% The following script queries NRCan's API for specified location, Vs30, 
% return period, and intensity measure, and returns hazard values in a table
% author- Prakash S Badal, UBC Okanagan
% Date- 04-01-2022

% NBCC (2020) Hazard web tool is out. source- https://earthquakescanada.nrcan.gc.ca/hazard-alea/interpolat/nbc2020-cnb2020-en.php
% Define endpoint URL
NRCanUrl = 'https://www.earthquakescanada.nrcan.gc.ca/api/canshm/graphql';

% Compose query (Vancouver City Hall)
% queryStr1 = ['query{NBC2020(latitude: 49.25, longitude: -123.12)' ...
%     '{X450: siteDesignationsXv(vs30: 450, ' ...
%     'poe50: [2.0, 5.0, 10.0])' ...
%     '{sa0p2 sa0p5 sa1p0 sa2p0 sa5p0 sa10p0 pga pgv}}}'];

% Compose query (Victoria)
queryStr1 = ['query{NBC2020(latitude: 48.43, longitude: -123.37)' ...
    '{X450: siteDesignationsXv(vs30: 450, ' ...
    'poe50: [2.0, 5.0, 10.0])' ...
    '{sa0p2 sa0p5 sa1p0 sa2p0 sa5p0 pga pgv}}}'];

% query = 'query{jobs{title,locationNames,postedAt}}';
% Create GraphQL object with predefined web options
g = GraphQL(NRCanUrl, 'Query', queryStr1);
% Execute query
res = g.execute();
% Find the Vs30 variable name by searching for the pattern in the query
pattern = "X" + digitsPattern(3);
vs30varName = string(extract(queryStr1, pattern));
% Extract data
hazData = struct2table(res.data.NBC2020.(vs30varName));
disp(hazData);
