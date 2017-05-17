%% PRACTICE EXPERIMENT PARAMETERS
% 2016-08-17 Created by Julian
% Parameter & screen setup for Practice Experiment. Don't worry too much
% about this stuff, it defines some basic details for running the
% experiment

function Exp = practice_parameters(screen_string)

%% AUXILIARY BUFFER & SYNC-TESTS

Exp.Cfg.SkipSyncTest = 1; % This should be '0' on a properly working NVIDIA video card. '1' skips the SyncTest.
Exp.Cfg.AuxBuffers = 1; % '0' if no Auxiliary Buffers available, otherwise put it into '1'.

%% OTHER GENERAL PARAMETERS

% Title of experiment
Exp.Title = 'Practice Experiment!\n\nclick to begin';

% End of session
Exp.End_Sesh = 'End of Run';

% Size of presentation text
Exp.addParams.textSize = 20;

% Window size (blank is full screen)

if strcmp(screen_string,'full') || strcmp(screen_string,'Full')
    Exp.Cfg.WinSize = [];
else
    Exp.Cfg.WinSize = [10 10 850 750];
end

%% INITIALISE SCREEN
% Screen setup using Psychtoolbox is notoriously clunky in Windows,
% particularly for dual-monitors.

% This relates to the way Windows handles multiple screens (it defines a
% 'primary display' independent of traditional numbering) and numbers
% screens in the reverse order to Linux/Mac. 

% The 'isunix' function should account for the reverse numbering but if
% you're using a second monitor you will need to define a 'primary display'
% using the Display app in your Windows Control Panel. See the psychtoolbox
% system reqs for more info: http://psychtoolbox.org/requirements/#windows

% Select screen:
Exp.Cfg.screens = Screen('Screens');

if isunix
    % Exp.Cfg.screenNumber = min(Exp.Cfg.screens); % Attached monitor
    Exp.Cfg.screenNumber = max(Exp.Cfg.screens); % Main display
else
    % Exp.Cfg.screenNumber = max(Exp.Cfg.screens); % Attached monitor
    Exp.Cfg.screenNumber = min(Exp.Cfg.screens); % Main display
end

% Define colours
Exp.Cfg.Color.white = WhiteIndex(Exp.Cfg.screenNumber);
Exp.Cfg.Color.black = BlackIndex(Exp.Cfg.screenNumber);
Exp.Cfg.Color.gray = round((Exp.Cfg.Color.white + Exp.Cfg.Color.black)/2);

if round(Exp.Cfg.Color.gray) == Exp.Cfg.Color.white
    Exp.Cfg.Color.gray = Exp.Cfg.Color.black;
end

Exp.Cfg.Color.inc = Exp.Cfg.Color.white - Exp.Cfg.Color.gray;

Exp.Cfg.WinColor = Exp.Cfg.Color.gray;

%('OpenWin', WinPtr, WinColour, WinRect, PixelSize, AuxBuffers, Stereo)
[Exp.Cfg.win, Exp.Cfg.windowRect] = Screen('OpenWindow', ...
    Exp.Cfg.screenNumber , Exp.Cfg.WinColor, Exp.Cfg.WinSize, [], 2, 0);

% Find window size
[Exp.Cfg.width, Exp.Cfg.height] = Screen('WindowSize', Exp.Cfg.win);

% Define center X & Y
[Exp.Cfg.xCentre , Exp.Cfg.yCentre] = RectCenter(Exp.Cfg.windowRect);

% Font
Screen('TextFont', Exp.Cfg.win, 'Arial');

% Text size
Screen('TextSize', Exp.Cfg.win, Exp.addParams.textSize);


%% WHEELY CONFIDENT SETUP

% Define rectangles for response collection
Exp.Cfg.frameThickness = 20;

Exp.Cfg.rs = 250; %300;% 216;
Exp.Cfg.rs = 250; % 300;%150;

Exp.Cfg.rect = [0 0 Exp.Cfg.rs Exp.Cfg.rs];
Exp.Cfg.smallrect = [0 0 Exp.Cfg.rs/1.5 Exp.Cfg.rs/4];
Exp.Cfg.bigrect = [0 0 2.25*Exp.Cfg.rs 2*Exp.Cfg.rs];
Exp.Cfg.cleavage = [0 0 Exp.Cfg.rs/4 2*Exp.Cfg.rs];

Exp.Cfg.yoff = 0;

Exp.Cfg.screensize_r = Exp.Cfg.windowRect(4);
Exp.Cfg.screensize_c = Exp.Cfg.windowRect(3);


Exp.Cfg.rectFrame = [0 0 Exp.Cfg.width Exp.Cfg.height]+[Exp.Cfg.screensize_c/2-Exp.Cfg.width/2 Exp.Cfg.screensize_r/2-Exp.Cfg.height/2 Exp.Cfg.screensize_c/2-Exp.Cfg.width/2 Exp.Cfg.screensize_r/2-Exp.Cfg.height/2];
Exp.Cfg.rectFrame = Exp.Cfg.rectFrame + [0 Exp.Cfg.yoff 0 Exp.Cfg.yoff];
Exp.Cfg.rect_{1} = Exp.Cfg.rect + [Exp.Cfg.screensize_c/2-Exp.Cfg.rs/2 Exp.Cfg.screensize_r/2-Exp.Cfg.height/2+Exp.Cfg.frameThickness Exp.Cfg.screensize_c/2-Exp.Cfg.rs/2 Exp.Cfg.screensize_r/2-Exp.Cfg.height/2+Exp.Cfg.frameThickness]; % top quadrant
Exp.Cfg.bigrect_{1}=Exp.Cfg.bigrect + [Exp.Cfg.screensize_c/2-1.125*Exp.Cfg.rs Exp.Cfg.screensize_r/2-Exp.Cfg.rs Exp.Cfg.screensize_c/2-1.125*Exp.Cfg.rs Exp.Cfg.screensize_r/2-Exp.Cfg.rs]; % top quadrant
Exp.Cfg.smallrect_{1}=Exp.Cfg.smallrect + [Exp.Cfg.screensize_c/2-Exp.Cfg.rs/3 Exp.Cfg.screensize_r/2-Exp.Cfg.rs/8 Exp.Cfg.screensize_c/2-Exp.Cfg.rs/3 Exp.Cfg.screensize_r/2-Exp.Cfg.rs/8]; % top quadrant

Exp.Cfg.cleavage_{1}=Exp.Cfg.cleavage + [Exp.Cfg.screensize_c/2-Exp.Cfg.rs/8 Exp.Cfg.screensize_r/2-Exp.Cfg.rs Exp.Cfg.screensize_c/2-Exp.Cfg.rs/8 Exp.Cfg.screensize_r/2-Exp.Cfg.rs];

