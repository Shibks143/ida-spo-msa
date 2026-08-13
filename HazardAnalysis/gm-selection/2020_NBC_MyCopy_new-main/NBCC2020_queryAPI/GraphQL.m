classdef GraphQL < handle
    %% Simple MATLAB GraphQL client
    % By Pavel Roslovets https://roslovets.guthib.io
    
    properties
        URL string
        Query string
        OperationName string
        Variables string
        WebOptions weboptions
    end
    
    methods
        function obj = GraphQL(url, opts)
            %% Create GraphQL request
            arguments
                url string
                opts.Query string
                opts.OperationName string = strings(0)
                opts.Variables string = strings(0)
                opts.WebOptions weboptions = weboptions
            end
            obj.URL = url;
            obj.Query = opts.Query;
            obj.OperationName = opts.OperationName;
            obj.Variables = opts.Variables;
            obj.WebOptions = opts.WebOptions;
        end
        
        function res = execute(obj)
            %% Execute query
            body = struct('query', obj.Query);
            if ~isempty(obj.OperationName)
                body.operationName = obj.OperationName;
            end
            if ~isempty(obj.Variables)
                body.variables = obj.Variables;
            end
            res = webwrite(obj.URL, body, obj.WebOptions);
        end
        
    end
    
    methods (Static)
        
        function query = encode(data)
            %% Encode object to graphql query string
            d = datetime('now');
            f1 = d.Format;
            d = datetime('today');
            f2 = d.Format;
            dateformat = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'";
            datetime.setDefaultFormats('default', dateformat);
            datetime.setDefaultFormats('defaultdate', dateformat);
            json = jsonencode(data);
            pat = '"' + asManyOfPattern(alphanumericsPattern(1) | "_", 1) + '":';
            fs1 = extract(json, pat);
            fs2 = strip(strip(fs1, ':'), '"') + ":";
            query = char(replace(json, fs1, fs2));
            query = string(query(2:end - 1));
            datetime.setDefaultFormats('default', f1);
            datetime.setDefaultFormats('defaultdate', f2);
        end
        
        function dt = datetime(str)
            %% Convert GraphQL date strings to datetime
            arguments
                str string
            end
            dt = datetime(str, 'InputFormat', "yyyy-MM-dd'T'HH:mm:ss.SS'Z'");
        end
        
        function txt = plainFromClipboard()
            %% Get plain string from clipboard
            txt = clipboard('paste');
            txt = strtrim(string(split(txt, newline)));
            txt(startsWith(txt, "#") | txt == "") = [];
            txt = join(txt, ' ');
        end
        
    end
    
end