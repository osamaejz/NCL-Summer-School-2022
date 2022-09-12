
%loading edf file
EEG = pop_biosig('sample.edf','channels',[1:38]);

%loading EEG Channel location file
EEG = pop_chanedit(EEG , 'lookup' , 'E:\\eeglab_current\\eeglab2020_0\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp' , 'load',{'C:\Users\Dell\Desktop\Standard-10-10-Cap38.ced' , 'filetype' , 'autodetect'});

%Location where you want to save your data
save_location = 'C:\Users\Dell\Desktop\New folder';

%Saving dataset in .set file to desired location
pop_saveset(EEG, 'mydata', save_location);

% Welch Periodogram
fs = 500; %smapling rate
windowLength = fs*4; % for 4 seconds window
noverlap = windowLength/2; % for 50% overlap
nfft = windowLength; % signal size for fourier transform 

for j=1:38;
    [power(j,:),f] = pwelch(EEG.data(j,:),windowLength,noverlap,nfft,fs);
    
    %defining EEG bands limit
    delta = find(f>=0 & f<4);
    theta = find(f>=4 & f<8);
    alpha = find(f>=8 & f<12);
    lower_alpha = find(f>=8 & f<10);
    upper_alpha = find(f>=10 & f<12);
    beta = find(f>=12 & f<30);
    lower_beta = find(f>=12 & f<18);
    mid_beta = find(f>=18 & f<21);
    upper_beta = find(f>=21 & f<30);
    gamma = find(f>=30 & f<200);
    
    %Calculating mean values of all channels
    meanallchan(j,:) = mean(power(j,:));
    
    %calculationg relative power
    relativepower(j,:) = power(j,:)/meanallchan(j,:);
    
    %EEG bands segregation
    rp_delta (j,:) = relativepower (j,delta(:,:));
    rp_theta (j,:) = relativepower (j,theta(:,:));
    rp_alpha (j,:) = relativepower (j,alpha(:,:));
    rp_lower_alpha (j,:) = relativepower (j,lower_alpha(:,:));
    rp_upper_alpha (j,:) = relativepower (j,upper_alpha(:,:));
    rp_beta (j,:) = relativepower (j,beta(:,:));
    rp_lower_beta (j,:) = relativepower (j,lower_beta(:,:));
    rp_mid_beta (j,:) = relativepower (j,mid_beta(:,:));
    rp_upper_beta (j,:) = relativepower (j,upper_beta(:,:));
    rp_gamma (j,:) = relativepower (j,gamma(:,:));

    
    %Relative EEG Bands mean 
    rp_delta_mean(j,:) = mean(relativepower (j,delta(:,:)));
    rp_theta_mean(j,:) = mean(relativepower (j,theta(:,:)));
    rp_alpha_mean(j,:) = mean(relativepower (j,alpha(:,:)));
    rp_lower_alpha_mean(j,:) = mean(relativepower (j,lower_alpha(:,:)));
    rp_upper_alpha_mean(j,:) = mean(relativepower (j,upper_alpha(:,:)));
    rp_beta_mean(j,:) = mean(relativepower (j,beta(:,:)));
    rp_lower_beta_mean(j,:) = mean(relativepower (j,lower_beta(:,:)));
    rp_mid_beta_mean(j,:) = mean(relativepower (j,mid_beta(:,:)));
    rp_upper_beta_mean(j,:) = mean(relativepower (j,upper_beta(:,:)));
    rp_gamma_mean(j,:) = mean(relativepower (j,gamma(:,:)));

end


plot(f,relativepower(:,:));
xlabel('Frequency Resolution');
ylabel('Frequency power');
title('Power Spectrumof relative power');

%loading channel location file in .mat
load locs38.mat

%Ploting topoplots
std_chantopo({rp_alpha_mean(:,:)},'chanlocs', a, 'titles', {'alpha'})

std_chantopo({rp_lower_alpha_mean(:,:) rp_alpha_mean(:,:) rp_theta_mean(:,:)},'chanlocs', a, 'titles', {'Lower Alpha',  'Alpha', 'Theta'})

