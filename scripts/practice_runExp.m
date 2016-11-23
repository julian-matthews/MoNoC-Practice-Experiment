function practice_runExp
%% PRACTICE RSVP EXPERIMENT
% 2016-08-17 Created by Julian
% An intermediate level script for teaching the basics of how we program
% a psychophysics experiment at MoNoC using MATLAB and Psychtoolbox.
%
% You'll need Psychtoolbox installed and added to the MATLAB path
%
% This experiment is conducted in 6 runs split between 2 sessions.
% Each run contains 8 trials (so, 48 trials in total)

%% INPUTS
% The information we collect using the 'input' function below is very
% important for running and analysing our experiment smoothly.
% It defines the subject ID we use to save data and ensures that the
% correct trials are shown to participants for this session & run.
%
% Inputs are defined by the experimenter in MATLAB's 'Command Window'. Here
% we are collecting the subject number, initials, session number, and run:
subj.number = input('Enter subject number, 01-99:\n','s'); % '99'
subj.initials = input('Enter subject initials:\n','s'); % 'JM'
subj.session = input('Session number, 1 or 2:\n','s'); % '1'
subj.run = input('Run number, 1 to 3:\n','s'); % '1'

% We can also use inputs for other things such as controlling presentation
% speed, see where 'subj.speed' is called below:
subj.speed = input('Presentation speed (seconds, default = 0.2):\n'); % 0.2

%% SAVE LOCATIONS
% MATLAB is great for integrating multiple scripts and stimuli to perform
% specific operations (such as analysis or experiments) however, it
% explores surrounding folders based upon the location of the running
% script (the 'Current Folder')
%
% We define locations we expect to find stimuli or save data relative to
% the Current Folder. 
%
% But before we define locations we have to check whether those locations
% exist! The if-loops below check for our data and trial folders and create
% them if they don't exist:

if ~exist('../data/raw','dir')
    mkdir('../data/raw'); % Here I'm making a location for saving raw data
end

if ~exist('../stimuli/preprocessed-trials','dir')
    mkdir('../stimuli/preprocessed-trials'); % ...And a location for trials
end

% Now I can define the location and path for where we save data plus 
% where we have saved experimental trials:

save_location = '../data/raw/';
save_path = [save_location '/' subj.number '_' subj.initials '_' subj.session '_' subj.run];
trial_location = '../stimuli/preprocessed-trials/';

% Add auxiliary files folder to path
addpath('./aux_files/');

%% CHECK IF PREPROCESSED TRIALS EXIST AND CREATE IF NOT
% The presentation times of our experiments can be very important, we don't
% want to waste computing power holding superfluous data in memory.
% As such, we create trials ahead of time using an explicit 'create_trials'
% script.
%
% For ease of use, I've coded the below if-loop to check if preprocessed
% trials exist and, if not, to pass control to the 'create_trials' script
%
% Firstly, we check if trials exist in the 'trial_location' for this
% subject number, session, and run:

if exist([trial_location subj.number '/' ...
        subj.number '_s' subj.session '_r' subj.run '.mat'],'file')
    
    % If the details are found, we end up here.
    
    % Loading text is displayed in the Command Window and we load the data
    load_text = sprintf('Loading trial data for subject #%s\n* Session %s * Run %s *', ...
        subj.number, subj.session, subj.run);
    disp(load_text)
    
    load([trial_location subj.number '/' ...
        subj.number '_s' subj.session '_r' subj.run '.mat'],'TR')
    
else
    
    % If MATLAB can't find the preprocessed trials we end up here.
    
    % It's possible they don't exist or they're saved somewhere else,
    % either way we're going to create them now and continue
    
    tried_text = sprintf('\nAttempted to find trials for subject #%s, session %s, run %s but no luck...', ...
        subj.number, subj.session, subj.run);
    disp(tried_text)
    
    leave_text = sprintf('\nPassing control to practice_create_trials.m');
    disp(leave_text)
    
    % Here we are calling the 'create_trials' script inputting our subject
    % number and the location we wish to save the preprocessed trials
    practice_create_trials(subj.number, trial_location);
    
    % Loading text is displayed in the Command Window and we load the data
    load_text = sprintf('\nLoading trial data for subject #%s\n* Session %s * Run %s *', ...
        subj.number, subj.session, subj.run);
    disp(load_text)
    
    load([trial_location subj.number '/' ...
        subj.number '_s' subj.session '_r' subj.run '.mat'],'TR')
    
end

%% OPEN SCREEN AND PREPARE Psychtoolbox PARAMETERS
% We can change the size of the experiment window using this string.
% 'full' will employ the whole screen but will cover our experiment window
% 'small' will open an offset screen, stick with this if unsure
screen_size = 'small'; % 'small' or 'full'

% The practice_parameters function will now be called to "open" our window
% using Psychtoolbox. Don't worry too much about this one, it prepares our
% experiment for use with this screen and allows us to call and assign
% things to it using 'Exp'
Exp = practice_parameters(screen_size);

%% SOME FINAL DEFINITIONS
% We're almost ready to get started! Let's define the number of trials by
% checking how many we loaded:
total_trials = length(TR);

% Fixation cross presentation time (seconds)
fixation_time = 0.5; % 500ms

% Time each image is presented (seconds)
flip_time = subj.speed; % 200ms default, this is defined as an input above

%% FIXATION CROSS SETTINGS

%Set colour, width, length etc.
CrossColour = 0;  %255 = white
CrossL = 15;
CrossW = 3;

%Set start and end points of lines
Lines = [-CrossL, 0; CrossL, 0; 0, -CrossL; 0, CrossL];
CrossLines = Lines';

%% FIRST SCREEN
% Here we go! This presents our opening window and title. We have to click
% to continue.

% Anything starting with 'Exp' was defined in the 'practice_parameters'
% function.
% We define what we want to happen to our screen then 'flip' the result so
% these three lines tell us that we want to fill the screen with the
% colour black, present some text in the middle of the screen, and then
% 'flip' the result to the experiment window
Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.black);
DrawFormattedText(Exp.Cfg.win,Exp.Title,'center','center',Exp.Cfg.Color.white);
Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);

% ...And this little while-loop waits for a mouse-click or button-press before we
% continue
while (1)
    [~,~,buttons] = GetMouse(Exp.Cfg.win);
    if buttons(1) || KbCheck
        break;
    end
end

WaitSecs(0.25);

%% THE EXPERIMENT
% This is the real thing. What we define here is going to repeat for
% 'total_trials' number of times.

for trial = 1:total_trials
    
    % First, let's hide the cursor
    HideCursor;
    
    % Now, to save on computing power for the trial, let's create all our
    % textures at this point.
    %
    % The code below will 'make' textures for the probe image, distractor
    % image, and trial textures based upon those defined by the
    % 'practice_create_trials' script
    Probe_Tex = Screen('MakeTexture',Exp.Cfg.win, TR(trial).imgDat_probe);
    Distr_Tex = Screen('MakeTexture',Exp.Cfg.win, TR(trial).imgDat_distractor);
    
    % We 'place' the trial textures in this Trial_Tex variable
    Trial_Tex = zeros(1,size(TR(trial).trial_vector,2));
    
    for imgDat = 1:size(TR(trial).trial_vector,2)
        Trial_Tex(imgDat) = Screen('MakeTexture',Exp.Cfg.win, TR(trial).trial_vector{imgDat});
    end
    
    %% FIXATION CROSS
    
    % Now, let's colour the screen gray
    Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
    Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
    
    % ... And show the fixation cross for 'fixation_time' amount of seconds
    time_remaining = fixation_time;
    targetSecs = GetSecs;
    
    % This while-loop will 'flip' until time_remaining is equal to zero
    while time_remaining > 0
        
        Screen('DrawLines', Exp.Cfg.win, CrossLines, CrossW, CrossColour,...
            [Exp.Cfg.xCentre, Exp.Cfg.yCentre]);
        
        Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
        
        time_elapsed = GetSecs - targetSecs;
        time_remaining = fixation_time - time_elapsed;
        
    end
    
    %% PRESENT STREAM OF IMAGES
    % For each image, we flip the appropriate texture for 'flip_time'
    % seconds
    
    for image = 1:length(TR(trial).trial_vector)
        
        % Prepare while-loop timing
        time_remaining = flip_time; % Defined above
        startSecs = GetSecs; % Checks the current computer clock
        
        %% FLIP IMAGE TO SCREEN
        while time_remaining > 0
            
            Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
            Screen('DrawTexture', Exp.Cfg.win, Trial_Tex(image));
            Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
            
            time_elapsed = GetSecs - startSecs; % Check time
            time_remaining = flip_time - time_elapsed; % Remove from time_remaining
            
        end
        
    end
    
    % Blank screen for 80ms before presenting response wheel
    Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
    Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
    
    WaitSecs(0.08);
    
    %% DRAW RESPONSE SCREEN
    % At this point, all of our image textures have been shown so let's
    % present the response wheel so we can register a decision
    
    % Firstly, let's show the cursor again
    ShowCursor;
    
    % Now, we 'flip' the response wheel to our screen and wait a moment to
    % ensure people don't accidentally click (this stuff happens very
    % quickly)
    [Exp, TR] = response_screen(Exp,TR,trial,Probe_Tex,Distr_Tex,0);
    WaitSecs(.3);
    
    %% REGISTER A RESPONSE
    % We set up a while-loop that will break once we register a click
    clicks = 0;
    
    while clicks == 0
        
        [x,y] = getMouseResponse(); % This waits until a click is made
        
        % This stuff is a little confusing but it checks whether a click
        % went inside one of the boxes that are built into the confidence
        % wheel
        for m = 1 : size(Exp.polyL, 1)
            idxs_left(m) = inpolygon(x,y,squeeze(Exp.polyL(m,1,:)),squeeze(Exp.polyL(m,2,:)));
            
            idxs_right(m) = inpolygon(x,y,squeeze(Exp.polyR(m,1,:)),squeeze(Exp.polyR(m,2,:)));
        end
        
        idx_pos_left = find(idxs_left == 1);
        idx_pos_right = find(idxs_right == 1);
        
        % Left boxes click
        if length(idx_pos_left) == 1 %~isempty(idx_pos_left)
            keyid = -1;
            keyid2 = idx_pos_left;
            
            clicks = 1;
            
            % Paint selected box blue
            Screen('FillPoly', Exp.Cfg.win, [0 0 255], squeeze(Exp.polyL(idx_pos_left,:,:))',1);
            for wait = 1:10
                Screen('Flip', Exp.Cfg.win,  [], Exp.Cfg.AuxBuffers);
            end
            
        end
        
        if length(idx_pos_right) == 1 %~isempty(idx_pos_right)
            keyid = 1;
            keyid2 = idx_pos_right;
            
            clicks= 1;
            
            % Paint selected box blue
            Screen('FillPoly', Exp.Cfg.win, [0 0 255], squeeze(Exp.polyR(idx_pos_right,:,:))',1);
            for wait = 1:10
                Screen('Flip', Exp.Cfg.win,  [], Exp.Cfg.AuxBuffers);
            end
            
        end
    end
    
    % ... And we use this to check the accuracy of the response
    if keyid == -1
        response = 'left';
    elseif keyid == 1
        response = 'right';
    end
    
    if TR(trial).response_side < 0 % Probe on left
        trialType = 'left';
    else % Probe on right
        trialType = 'right';
    end
    
    %% SAVE RESPONSES AFTER EACH TRIAL, SIDE AND CONFIDENCE
    
    TR(trial).keyid = keyid;
    TR(trial).response = strcmp(response, trialType);
    TR(trial).confidence = keyid2;
    
    % And we save the response to our 'data' folder under the subject
    % number, initial, session, and run
    save([save_path '.mat'], 'TR');
    
    %% TRIAL COMPLETE
    % At this stage this trial is complete, we've presented the images and
    % collected a response which has been saved to the appropriate
    % location. This process is repeated for 'total_trials' number of times
    % before continuing below
    
end

%% ALMOST FINISHED
% Now the wrap-up, we present the 'End of Run' text, save, and close the
% screen
Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
DrawFormattedText(Exp.Cfg.win,Exp.End_Sesh,'center','center',Exp.Cfg.Color.black);
Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);

% Save the trial data one final time and the settings information for
% analysis
save([save_path '.mat'], 'TR');
save([save_path '_Settings.mat'], 'Exp', 'subj');

WaitSecs(0.5); % Wait a amoment

% ...And close the screen
Screen('CloseAll');

%% LET'S ANALYSE
% Just so we can immediately examine this data, let's prompt some quick
% analysis here

examine_yes = input('\nWould you like to examine results? (y/n)\n','s'); % 'y'

if strcmp(examine_yes,'y') || strcmp(examine_yes,'Y')
    confidence = [TR(:).confidence]
    response_accuracy = [TR(:).response]
    mean_accuracy = mean(response_accuracy)
    mean_confidence = mean(confidence)
else
    suit_yourself = '\nSuit yourself!';
    disp(suit_yourself)
    cheers_emoticon = sprintf('\n\\{''3''}/\n');
    disp(cheers_emoticon)
end

end