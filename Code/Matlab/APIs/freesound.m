function [] = freesound()

dataDir = './data/freesound/';

%-The elements of the Freesound API call
base_url = 'http://www.freesound.org/api/sounds/search';
api_key  = 'api_key=1395cec077e84d27b1f71d6e16410ffe';
query    = 'q=';
and      = '&';
quest    = '?';
format   = 'format=json';
type     = 'f=type:wav';

maxDur = 120;

%-The queries
q1 = 'bird';
q2 = 'bird+urban';
q3 = 'city';
q4 = 'street';

queries = {q1,q2,q3,q4};

k = 1;
numOfQueries = length(queries);

for i = 1:numOfQueries   
    %-Construct the url
    catUrl = strcat(base_url, quest, api_key, and, query, ...
        queries{i}, and, type, and, format);

    %-Read the url
    url = urlread(catUrl);
    
    %Read in the json-struct: this will return all of the query results in
    %Matlab struct format
    json_struct = parse_json_two(url);
    
    numRecordings = length(json_struct.sounds);
    
    %-Loop through the results sounds in the struct
    for h = 1:numRecordings  
        
        %-Get the struct
        metadata = json_struct.sounds{h};
        
        metadata.label = queries(i);
        
        %-Get the actual sound data and write to file
        sound_url  = metadata.serve;
        sound_type = metadata.type;
        soundUrl   = [sound_url, quest, api_key];
        
        theFile = [dataDir, metadata.original_filename];
        
        urlwrite(soundUrl, theFile);
        
        theDir = sprintf('%s', theFile);
        
        %-Save the struct for the file
        save(theDir, 'metadata');
        
    end
    
end

%-Save the labels to a file
save 'soundData.mat' soundData;

end