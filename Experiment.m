%% Experiment: Usage: Experiment(Images, sorted map, ratios); 
%%Designed for handling 100 by 100 pixels images at 1000 trials.

function [outputs] = Experiment(Images, map, ratios)

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
DrawFormattedText(window, 'You will be shown two images on the screen. \n The task is to select which one has the more visible gabor filter and which orientation it is in.', 'center', screenY*.25, WhiteIndex(screenNumber));
Screen('Flip', window);
WaitSecs(3);


%Set trial number
trials = 500;

%Set starting contrast
image_contrast =3000;


%Initialize keys
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

xCoords = [-40, 40, 0, 0];
yCoords = [0, 0, -40, 40];
allCoords = [xCoords; yCoords];


%Run in loop
for i =1:trials,

    %Focus image
	Screen('DrawLines', window, allCoords,5, WhiteIndex(screenNumber),[xc, yc]);
	Screen('Flip', window);

	WaitSecs(1);

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
	first_image = squeeze(Images(f, map(image_contrast, f), :, :)); %double(imread(strcat('ImageLibrary/', first_noise, '/Contrast',num2str(image_contrast), '/Image',num2str(randi(1000)), '.png')));
	second_image =squeeze(Images(w, map(image_contrast, w), :, :)); % double(imread(strcat('ImageLibrary/', second_noise, '/Contrast',num2str(image_contrast), '/Image',num2str(randi(1000)), '.png')));

	FirstImageText = Screen('MakeTexture', window, first_image);
	SecondImageText = Screen('MakeTexture', window, second_image);

	first_rotation = 57.2957795*double((randi(2))*pi/2.0);
	second_rotation = 57.2957795*double((randi(2))*pi/2.0);

	Screen('DrawTexture', window, FirstImageText, [],[xc-210, yc-100, xc-10, yc+100], first_rotation);
	Screen('DrawTexture', window, SecondImageText, [],[xc+11, yc-100,xc+211, yc+100], second_rotation);
	Screen('Flip', window);

	WaitSecs(.5);

    %Queue response
	Screen('TextSize', window, 14);
	Screen('TextFont', window, 'Courier');
	DrawFormattedText(window, 'Was the left image or the right image clearer? \n Press the left arrow key for left, the right arrow key for the right.', 'center', 'center', WhiteIndex(screenNumber));

	Screen('Flip', window);
	[s, keyCode, dS]=KbStrokeWait;


	%Record answer
	noise_response = 'Not Recorded';
	if keyCode(leftKey)
		noise_response = first_noise;
		actual_rotation = first_rotation - 57.2957795*(pi/4.0);
	else
		noise_response = second_noise;
		actual_rotation = second_rotation - 57.2957795*(pi/4.0);
	end

	Screen('TextSize', window, 14);
	Screen('TextFont', window, 'Courier');
	DrawFormattedText(window, 'Was the gabor negatively oriented or positively oriented? \n Press the left arrow key for negative,\n the right arrow key for positive.', 'center', 'center', WhiteIndex(screenNumber));

	Screen('Flip', window);
	[s, keyCode, dS]=KbStrokeWait;
    
    %Record data 

	orientation_response = 'Not Recorded';
	if keyCode(leftKey)
        %Conversion to degrees for the sake of sanity 
		orientation_response = 57.2957795*((double(1.0)*pi/2.0) -pi/4.0);
	else
		orientation_response = 57.2957795*((double(2.0)*pi/2.0) - pi/4.0);
	end

	%Formalize data
	Trial(i).First_Noise = first_noise;
	Trial(i).Second_Noise = second_noise;
	Trial(i).Contrast = image_contrast;
	Trial(i).First_Likelihood = ratios(1, map(image_contrast, 1));	
	Trial(i).Second_Likelihood = ratios(2, map(image_contrast, 2));	
	Trial(i).First_Orientation = first_rotation - 57.2957795*(pi/4.0);
	Trial(i).Second_Orientation = second_rotation - 57.2957795*(pi/4.0);
	Trial(i).Noise_Response = noise_response;
	Trial(i).Actual_Rotation = actual_rotation;
	Trial(i).Orientation_Response = orientation_response;
	Trial(i).Orientation_Correct = not(abs(actual_rotation- orientation_response)/90.0);

    
    %Reward sound and staircase 
	if(Trial(i).Orientation_Correct)
		PsychPortAudio('FillBuffer', handle, [reward; reward]);
		PsychPortAudio('Start', handle, 1, 0, 1);
			WaitSecs(beeplength);
			PsychPortAudio('Stop', handle);
		if(i>1 && Trial(i-1).Orientation_Correct)
			image_contrast = max(image_contrast-25+ uint32(normrnd(0, 2)) , 1);
			
		end

	else 

		if(i>1)
			image_contrast = min(image_contrast +25 + uint32(normrnd(0,2)), 11000);
		end
	end
	
end

%Finish
outputs = Trial;
PsychPortAudio('Close', handle);
sca;
end