%% Experiment: Usage: Experiment(Images, sorted map, ratios); 
%%Designed for handling 100 by 100 pixels images at 1000 trials.
%% Currently employs a tria dof one white iamge presented, one pink imae presented, and both images presented


function [outputs] = Experiment3(Images, map, ratios)


%experiment_type = 'white';

experiment_options = {'both', 'white-2AFC', 'pink-2AFC'};

%Setup and beginnings
PsychDefaultSetup(2);
InitializePsychSound(1);


%Sound setup
nrchannels=2;
freq = 48000;
repetitions =  1;
beeplength = .25;
waitfordevice =1;

handle =PsychPortAudio('Open', [], 1 , 1, freq , nrchannels);

PsychPortAudio('Volume', handle, 1.0);

reward = MakeBeep(500, beeplength, freq);
wrong = MakeBeep(200, beeplength, freq);


screens = Screen('Screens');

screenNumber = max(screens);

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, BlackIndex(screenNumber)); 

ifi = Screen('GetFlipInterval', window);
[screenX, screenY] = Screen('WindowSize', window);
[xc, yc] = RectCenter(windowRect);


%Read images in 
example_one = imresize(imread('threepioverfour.png'), [100,100]);
example_two = imresize(imread('pioverfour.png'), [100,100]);

Example1ImageText = Screen('MakeTexture', window, example_one);
Example2ImageText = Screen('MakeTexture', window, example_two);
Screen('DrawTexture', window, Example1ImageText, [],[760, 440, 860, 540], 0);
Screen('DrawTexture', window, Example2ImageText, [],[861, 440,961, 540], 0);
Screen('TextSize', window, 20);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'These are gabor filters. The left one is negatively oriented, the right one is positively oriented.', 'center', screenY*.25, WhiteIndex(screenNumber));
Screen('Flip', window);
WaitSecs(3);
DrawFormattedText(window, 'You will be shown one or two images on the screen. \n The task is to select which one has the more visible \n gabor filter and determine which orientation the filter is in.\n Sometimes, we will select the image for you, and highlight the area it appeared in with a white circle . \n', 'center', screenY*.25, WhiteIndex(screenNumber));
Screen('Flip', window);
WaitSecs(5);


%Set trial number
trials =30;
%Set presentation time
time = 0.2;
%Set starting contrast
image_contrast =4000;
image_contrast_initial = 4000;

%Set training to true

%training_counter =0;
%training_trials = 10;


%Initialize keys
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

xCoords = [-40, 40, 0, 0];
yCoords = [0, 0, -40, 40];
allCoords = [xCoords; yCoords];

experiment_type_contrast = ones(6,2)
experiment_type_contrast = image_contrast_initial .* experiment_type_contrast;

%%Third Experiment: Both at Once Run in loop

counter = [0,0,0,0,0,0];
for i =1:trials,
    choice_allowed = ((randi(2)-1));
    
    
        
    experiment_type_marker = randi(3);
    experiment_type = experiment_options(experiment_type_marker);
    
    if choice_allowed == 0,
           counter(3+experiment_type_marker) = counter(3 + experiment_type_marker) +1;


        stair_case = 3+experiment_type_marker;
    else
      
        counter(experiment_type_marker) = counter(experiment_type_marker) +1;
        stair_case = experiment_type_marker;
    end
    
    %Focus image
	Screen('DrawLines', window, allCoords,5, WhiteIndex(screenNumber),[xc, yc]);
	Screen('Flip', window);

	WaitSecs(1.0);

	first_type = randi(2);
	if first_type ==2, 
		first_noise='pink';
		f=1;
		w=2;
		second_noise='white';
	else 
		first_noise = 'white'; 
		second_noise ='pink';
		f=2;
		w=1;
    end

    %Present image
    if strcmp(experiment_type, 'both')==1,

        first_image = squeeze(Images(f, map(experiment_type_contrast(stair_case, f), f), :, :)); 
        %double(imread(strcat('ImageLibrary/', first_noise, '/Contrast',num2str(image_contrast), '/Image',num2str(randi(1000)), '.png')));
        second_image =squeeze(Images(w, map(experiment_type_contrast(stair_case, w), w), :, :)); 
        % double(imread(strcat('ImageLibrary/', second_noise, '/Contrast',num2str(image_contrast), '/Image',num2str(randi(1000)), '.png')));

    %Pink Only presented
   
    %elseif strcmp(experiment_type, 'pink')==1,
     %   if first_type ==2,
      %      first_image = squeeze(Images(f, map(image_contrast, f), :, :)); 
       %     second_image =squeeze(zeros(100,100)); 
        %else
         %  first_image = zeros(100,100);
          % second_image =squeeze(Images(w, map(image_contrast, w), :, :));
       % end
    %White Only Presented
    %elseif strcmp(experiment_type, 'white')==1
    %    if first_type ==2,
     %       first_image = zeros(100,100);
      %     second_image =squeeze(Images(w, map(image_contrast, w), :, :));
       % else
        %   first_image = squeeze(Images(f, map(image_contrast, f), :, :)); 
        %    second_image =squeeze(zeros(100,100)); 
        %end
    %Two white images presented
    elseif strcmp(experiment_type, 'white-2AFC')==1
        first_noise = 'white';
        second_noise = 'white';
         if first_type ==2,
            first_image =squeeze(Images(w, map((experiment_type_contrast(stair_case, w)+ uint32(normrnd(0,2))), w), :, :));
           second_image =squeeze(Images(w, map(experiment_type_contrast(stair_case, w), w), :, :));
        else
           first_image = squeeze(Images(f, map(experiment_type_contrast(stair_case, f), f), :, :)); 
            second_image =squeeze(Images(f, map((experiment_type_contrast(stair_case, f)+ uint32(normrnd(0,2))), f), :, :)); 
         end
     %Two pink images presented
    elseif strcmp(experiment_type, 'pink-2AFC')==1
        first_noise = 'pink';
        second_noise = 'pink';
         if first_type ==2,
            first_image = squeeze(Images(f, map(experiment_type_contrast(stair_case, f), f), :, :)); 
            second_image =squeeze(Images(f, map((experiment_type_contrast(stair_case, f)+ uint32(normrnd(0,2))), f), :, :)); 
          
        else
          first_image =squeeze(Images(w, map((experiment_type_contrast(stair_case, w)+ uint32(normrnd(0,2))), w), :, :));
           second_image =squeeze(Images(w, map(experiment_type_contrast(stair_case, w), w), :, :));
        end
    end
    

	FirstImageText = Screen('MakeTexture', window, first_image);
	SecondImageText = Screen('MakeTexture', window, second_image);

	first_rotation = 57.2957795*double((randi(2))*pi/2.0);
	second_rotation = 57.2957795*double((randi(2))*pi/2.0);

	Screen('DrawTexture', window, FirstImageText, [],[xc-210, yc-100, xc-10, yc+100], first_rotation);
	Screen('DrawTexture', window, SecondImageText, [],[xc+11, yc-100,xc+211, yc+100], second_rotation);
	Screen('Flip', window);

    %Time presented to subject
	WaitSecs(time);
    
    if strcmp(experiment_type, 'both') || strcmp(experiment_type, 'white-2AFC') || strcmp(experiment_type, 'pink-2AFC'),
        %Queue response
        Screen('TextSize', window, 14);
        Screen('TextFont', window, 'Courier');
        
        if choice_allowed==1,
            
        %   if training_counter< training_trials, 
         %   DrawFormattedText(window, 'Was the left image or the right image clearer? \n Press the left arrow key for left, the right arrow key for the right.', 'center', 'center', WhiteIndex(screenNumber));
          
            %training_counter = training_counter + 1;
            
          % end 
            %Record answers
            
           
            [xCen, yCen] = RectCenter(windowRect);
            
            baseRect = [0,0,200,200];
       
      
                centeredRect = CenterRectOnPointd(baseRect, xCen-120, yCen);
               
                centeredRect2 = CenterRectOnPointd(baseRect, xCen+120, yCen);

          
                rectColor = [1,1,1];
                pen_width = 6;
                Screen('FrameOval', window, rectColor, centeredRect, pen_width);
                  Screen('FrameOval', window, rectColor, centeredRect2, pen_width);
                    Screen('Flip', window);
            WaitSecs(.1);
            [s, keyCode, dS]=KbStrokeWait;
            
            noise_response = 'Not Recorded';
            
            if keyCode(leftKey)
                noise_response = 'First';
                actual_rotation = first_rotation - 57.2957795*(pi/4.0);
                
                 Screen('FrameOval', window, rectColor, centeredRect, pen_width);
                
            elseif keyCode(rightKey)
                noise_response = 'Second';
                actual_rotation = second_rotation - 57.2957795*(pi/4.0);
                 Screen('FrameOval', window, rectColor, centeredRect2, pen_width);
              
            end
        else
            image_to_test = randi(2); %1 for left, 2 for right
            
            [xCen, yCen] = RectCenter(windowRect);
            
            baseRect = [0,0,200,200];
            noise_response = 'machine_selected';
            if image_to_test ==1, 
                machine_response = 'First';
                centeredRect = CenterRectOnPointd(baseRect, xCen-120, yCen);
                 actual_rotation =first_rotation- 57.2957795*(pi/4.0);
            else
                machine_response = 'Second';
                centeredRect = CenterRectOnPointd(baseRect, xCen+120, yCen);
                 actual_rotation = second_rotation- 57.2957795*(pi/4.0);
            end
                rectColor = [1,1,1];
                pen_width = 6;
                Screen('FrameOval', window, rectColor, centeredRect, pen_width);
                %Screen('Flip', window);
            WaitSecs(.1);
            
        end
       
    end

    %if training_counter<training_trials, 
	%Screen('TextSize', window, 14);
	%Screen('TextFont', window, 'Courier');
	%DrawFormattedText(window, 'Was the gabor negatively oriented or positively oriented? \n Press the left arrow key for negative,\n the right arrow key for positive.', 'center', 'center', WhiteIndex(screenNumber));
    %training_counter = training_counter +1;
    %end
	Screen('Flip', window);
	[s, keyCode, dS]=KbStrokeWait;
    
    %Record data 

	orientation_response = 'Not Recorded';
	if keyCode(leftKey)
        %Conversion to degrees for the sake of sanity 
		orientation_response = 57.2957795*((double(1.0)*pi/2.0) -pi/4.0);
    elseif keyCode(rightKey)
		orientation_response = 57.2957795*((double(2.0)*pi/2.0) - pi/4.0);
    end

	%Formalize data
    r = not(abs(round(actual_rotation- orientation_response)/90));

    Trial(stair_case,counter(stair_case)).Experiment_Type = experiment_type;
	Trial(stair_case,counter(stair_case)).First_Noise = first_noise;
	Trial(stair_case,counter(stair_case)).Second_Noise = second_noise;
	Trial( stair_case,counter(stair_case)).First_Contrast = experiment_type_contrast(stair_case, f);
  Trial( stair_case,counter(stair_case)).Second_Contrast = experiment_type_contrast(stair_case, w);
	Trial( stair_case,counter(stair_case)).First_Likelihood = ratios(f, map(experiment_type_contrast(stair_case, f), f));	
	Trial( stair_case,counter(stair_case)).Second_Likelihood = ratios(w, map(experiment_type_contrast(stair_case, w), w));	
	Trial( stair_case,counter(stair_case)).First_Orientation = first_rotation - 57.2957795*(pi/4.0);
	Trial( stair_case,counter(stair_case)).Second_Orientation = second_rotation - 57.2957795*(pi/4.0);
	Trial( stair_case,counter(stair_case)).Noise_Response = noise_response;
	Trial(stair_case, counter(stair_case)).Actual_Rotation = actual_rotation;
	Trial( stair_case,counter(stair_case)).Orientation_Response = orientation_response;
	Trial( stair_case,counter(stair_case)).Orientation_Correct = r;

    
    %Reward sound and staircase 
	if(Trial(stair_case,counter(stair_case)).Orientation_Correct), 
		PsychPortAudio('FillBuffer', handle, [reward; reward]);
		PsychPortAudio('Start', handle, 1, 0, 1);
			WaitSecs(beeplength);
			PsychPortAudio('Stop', handle);
           
        if(counter(stair_case)>1 && Trial(stair_case, counter(stair_case)-1).Orientation_Correct),


            if strcmp(Trial(stair_case, counter(stair_case)).Noise_Response, 'First'),
                       experiment_type_contrast(stair_case, f) = max(experiment_type_contrast(stair_case, f)-25+ uint32(normrnd(0, 2)) , 1);

            elseif strcmp(Trial(stair_case, counter(stair_case)).Noise_Response, 'Second'),
                 experiment_type_contrast(stair_case, w) = max(experiment_type_contrast(stair_case, w)-25+ uint32(normrnd(0, 2)) , 1);

            elseif strcmp(machine_response, 'First'),
                  experiment_type_contrast(stair_case, f) = max(experiment_type_contrast(stair_case, f)-25+ uint32(normrnd(0, 2)) , 1);

              else 
                  experiment_type_contrast(stair_case, w) = max(experiment_type_contrast(stair_case, w)-25+ uint32(normrnd(0, 2)) , 1);
            end
        end
        
    else 
        PsychPortAudio('FillBuffer', handle, [wrong; wrong]);
		PsychPortAudio('Start', handle, 1, 0, 1);
			WaitSecs(beeplength);
			PsychPortAudio('Stop', handle);


	if(counter(stair_case)>1)
        disp('Hello World');
      if strcmp(Trial(stair_case, counter(stair_case)).Noise_Response, 'First'),
         experiment_type_contrast(stair_case, f) =min(experiment_type_contrast(stair_case, f) +25 + uint32(normrnd(0,2)), 11000);

      elseif strcmp(Trial(stair_case, counter(stair_case)).Noise_Response, 'Second'),
         experiment_type_contrast(stair_case, w) = min(experiment_type_contrast(stair_case, w) +25 + uint32(normrnd(0,2)), 11000);
      elseif strcmp(machine_response, 'First'),
          experiment_type_contrast(stair_case, f) =min(experiment_type_contrast(stair_case, f) +25 + uint32(normrnd(0,2)), 11000);

      else 
          experiment_type_contrast(stair_case, w) =min(experiment_type_contrast(stair_case, w) +25 + uint32(normrnd(0,2)), 11000);
    
      end
		end
	end
	
    end


%Finish
outputs = Trial;
PsychPortAudio('Close', handle);
sca;

end

