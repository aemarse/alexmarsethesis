function [] = xeno_canto()

dataDir = './data/xeno_canto/';

species = {
    'Ring-billed+gull', 
    'Great+egret'
    'Common+yellowthroat',
    'Red-winged+blackbird',
    'Ruddy+duck',
    'Double-crested+cormorant',
    'Mallard',
    'Mute+swan',
    'House+finch',
    'Tufted+titmouse',
    'Black-capped+chickadee',
    'Red-bellied+woodpecker',
    'Downy+woodpecker',
    'Black-and-white+warbler',
    'American+redstart',
    'Magnolia+warbler',
    'Baltimore+oriole',
    'Northern+cardinal',
    'Blue+jay',
    'Chimney+swift',
    'White-throated+sparrow',
    'Song+sparrow',
    'American+robin',
    'Mourning+dove',
    'House+sparrow',
    'Red-tailed+hawk',
    'Rock+dove',
    'American+crow',
    'Common+grackle'
    };

species = species(1:2);

numSpecies = size(species,2);

s_baseUrl = 'http://www.xeno-canto.org/api/recordings.php';
s_extUrl  = '?query=';

for i = 1:length(species)
    
    %-Craft the url to be called
    s_theUrl  = [s_baseUrl s_extUrl species{i}];
    
    %-Read the url
    url = urlread(s_theUrl);
    
    %-Read in the json-struct
    json_struct = parse_json_two(url);
    
    %-Figure out how many recordings we are getting
    numRecordings = str2num(json_struct.numRecordings);
    
    %-Loop through the recordings
    for h = 1:numRecordings
        
        %-Save them to a struct
        metadata = json_struct.recordings{h};

        %-Make the soundFile name
        soundFile = [dataDir metadata.gen ' ' metadata.sp '_' ...
            metadata.en '_' metadata.id];
    
        %-Write the audio file
        urlwrite(metadata.file, sprintf('%s.wav', soundFile));
    
        theDir = sprintf('%s', soundFile);
        
        %-Save the struct for the file
        save(theDir, 'metadata');
        
    end
    
end

end