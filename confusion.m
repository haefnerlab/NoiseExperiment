%%confusion: Computes the confusion matrix for an Experiment output. 
function[L] = confusion(E)

	for i=1:500
		if strcmp(E(i).Noise_Response, E(i).First_Noise)
			E(i).Actual_Orientation = E(i).FirstOrientation;
		else
			E(i).Actual_Orientation = E(i).SecondOrientation;
		end
	end

	%%Calculate Confusion Matrix. 
	pink_confusion_matrix = zeros(2, 2);
	white_confusion_matrix = zeros(2,2);

	for i=1:500
		if (strcmp(E(i).Noise_Response, 'pink'))
			if(abs(E(i).Actual_Orientation - 45) <1)
				if(abs(E(i).Orientation_Response - 45) <1)
				
					pink_confusion_matrix(1,1) = pink_confusion_matrix(1,1) +1;
				else
				
					pink_confusion_matrix(1,2) = pink_confusion_matrix(1,2) +1;
				end
			else
				if(abs(E(i).Orientation_Response-135) < 1)
					
					pink_confusion_matrix(2,2) = pink_confusion_matrix(2,2) +1;
				end
				if(abs(E(i).Orientation_Response-45) <1)
				
					pink_confusion_matrix(2,1) = pink_confusion_matrix(2,1) +1;
				end
			end
		else
			if(abs(E(i).Actual_Orientation - 45)<1)
				if(abs(E(i).Orientation_Response-45) <1)
					white_confusion_matrix(1,1) = white_confusion_matrix(1,1) +1;
				else
					white_confusion_matrix(1,2) = white_confusion_matrix(1,2) +1;
				end
			else
				if(abs(E(i).Orientation_Response - 135) < 1)
					white_confusion_matrix(2,2) = white_confusion_matrix(2,2) +1;
				else
					white_confusion_matrix(2,1) = white_confusion_matrix(2,1) +1;
				end
			end			
	end
	L.E =E;
	L.pink_confusion_matrix = pink_confusion_matrix;
	L.white_confusion_matrix = white_confusion_matrix;
end
