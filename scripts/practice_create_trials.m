%% PRACTICE CREATE_TRIALS SCRIPT
% 2016-08-17 Created by Julian
% This is the create_trials script for our practice experiment.

% It takes the ixnput of a subject number and creates 48 trials worth of our
% experiment split over 2 sessions of 3 runs (6 files in total)

% These files are saved in the preprocessed location defined in the runExp
% script.

% Don't worry too much about this script, it runs automatically. Am happy
% to help describe it if you're interested.

function practice_create_trials(subject_number, save_location)

session_number = 2;
run_number = 3;

% Divisible by 4 or 8 for even distribution of sides
trial_number = 8;

% Display some text
begin = sprintf('\nReticulating splines:');
disp(begin)

% Load 15 images from each of the categories
image_num = 15;
categories = {'animals' 'famous' 'flowers' 'landmarks' 'persons' 'vehicles'};

% Create a file that contains the image data
add_image = 0;
for catg = 1:length(categories)
    for image = 1:image_num
        
        scene_dir = '../stimuli/natural-images/';
        
        temp = imread([scene_dir categories{catg} num2str(image) '.jpg'],...
            'jpg');
        
        add_image = add_image + 1;
        
        img_dat{add_image} = temp;
        
    end
end

disp('Splines reticulated, constructing trials:')

for sesh_num = 1:session_number
    
    image_perm = randperm(length(img_dat));
    
    for image = 1:length(img_dat)
        test_images(image) = img_dat(image_perm(image));
    end
    
    % Select out random probe & distractor for 5 trials
    img_count = 1;
    
    for run_num = 1:run_number
        for tr = 1:trial_number
            
            TR(tr).imgDat_distractor = test_images{img_count};
            
            img_count = img_count + 1;
            
            TR(tr).imgDat_probe = test_images{img_count};
            
            img_count = img_count + 1;
            
        end
        
        Runs(run_num).TR = TR;
        
    end
    
    Sessions(sesh_num).Runs = Runs;
    
    % Make thingo of remaining images
    
    ball_count = 0;
    
    for image = img_count:length(test_images)
        ball_count = ball_count + 1;
        ballast_images(ball_count) = test_images(image);
    end
    
    %% SET DETAILS
    
    for run_num = 1:run_num
        
        new_perm = randperm(length(ballast_images));
        
        for image = 1:length(ballast_images)
            trial_images(image) = ballast_images(new_perm(image));
        end
        
        img_count = 0;
        
        % Select from probe condition (-1 -2 -3 -4) [positions 5 4 3 2]
        probe_pos = zeros(1,trial_number);
        probe_pos(1:trial_number/4) = -1;
        probe_pos(((trial_number/4)*1+1):(trial_number/4)*2) = -2;
        probe_pos(((trial_number/4)*2+1):(trial_number/4)*3) = -3;
        probe_pos((trial_number/4)*3+1:end) = -4;
        probe_pos = Shuffle(probe_pos);
        
        % Select side for distractor vs. probe response (DP vs. PD)
        response_pos = zeros(1,trial_number);
        response_pos(1:trial_number/2) = 1; % Distractor on left, probe right
        response_pos((trial_number/2)+1:end) = -1; % Probe on left, distractor right
        response_pos = Shuffle(response_pos);
        
        for tr = 1:trial_number
            
            % Randomised probe lag for this trial (counterbalanced)
            TR(tr).probe_lag = probe_pos(tr);
            
            % Randomised response screen for this trial (counterbalanced)
            TR(tr).response_side = response_pos(tr);
            
            % Save distractor & probe images
            TR(tr).imgDat_distractor = Sessions(1).Runs(run_num).TR(tr).imgDat_distractor;
            
            TR(tr).imgDat_probe = Sessions(1).Runs(run_num).TR(tr).imgDat_probe;
            
            TR(tr).trial_vector = cell(1,6);
            
            for lag = 1:5
                img_count = img_count + 1;
                TR(tr).trial_vector{lag} = trial_images{img_count};
            end
            
            % Save the soon-to-be replaced probe-position face into the
            % "target" position
            TR(tr).trial_vector{6} = TR(tr).trial_vector{6 + TR(tr).probe_lag};
            
            % Substitute in probe texture at right location
            TR(tr).trial_vector{6 + TR(tr).probe_lag} = TR(tr).imgDat_probe;
            
        end
        
        Run(run_num).TR = TR;
        
    end
    
    Session(sesh_num).Run = Run;
    
end

if ~exist([save_location subject_number],'dir');
    mkdir('../stimuli/preprocessed-trials/', subject_number);
end

disp('*')

for teh_session = 1:session_number
    
    sesh_string = mat2str(teh_session);
    
    for teh_run = 1:run_number
        
        run_string = mat2str(teh_run);
        TR = Session(teh_session).Run(teh_run).TR;
        
        path = [save_location subject_number '/' ...
            subject_number '_s' sesh_string '_r' run_string];
        
        save([path '.mat'], 'TR');
        
    end
end

%% PRINT MESSAGE TO INDICATE SAVE

total_trials = session_number*run_number*trial_number;

the_end = sprintf('\nPractice Experiment: Created %d sessions of %d runs for subject #%s',...
    session_number,run_number,subject_number);
the_trials = sprintf('There''s %d trials per run so %d in total',...
    trial_number, total_trials);

disp(the_end)
disp(the_trials)

end
