clear all; 
close all;
input_wav='E:\NLTM Project\Matlab_Programs\APTS_ZFF\input_wave\sen12.wav';
%to read input speech wave
[input_sample,fs]=audioread(input_wav);
N=length(input_sample);
time=(0:N-1)/fs;

% calculate pitch by using zff method
[epoch_loc,pitch_contour,epoch_strength]=zff_based_pitch_contour(input_sample,fs);

%calculate mean and std deviation
mean_pitch=mean(pitch_contour);
std_pitch=std(pitch_contour);

%fix range for pitch values
one_down=mean_pitch-(std_pitch); 
two_down=mean_pitch-(2*std_pitch);
one_up=mean_pitch+(std_pitch);
two_up=mean_pitch+(2*std_pitch);
pitch_maxval=max(pitch_contour);
pitch_minval=min(pitch_contour);



time_start_n=0;
time_end_n=0.0613;

%to find time location
time_loc=epoch_loc/fs;

%to find range values
out=find(time_loc>=time_start_n&time_loc<=time_end_n);
out_size=length(out);
pitch_start_label='';
syll_pitch_st=0;
pitch_maxval=max(pitch_contour);
pitch_minval=min(pitch_contour);
out_values_st=0;

if (out_size >0)
syll_pitch_st=pitch_contour(out(1));

if (syll_pitch_st>=pitch_minval && syll_pitch_st<one_down) 
    pitch_start_label='VL';
    out_values_st=syll_pitch_st;
elseif (syll_pitch_st>=one_down && syll_pitch_st<mean_pitch)
    pitch_start_label='L';
     out_values_st=syll_pitch_st;
elseif (syll_pitch_st>=mean_pitch && syll_pitch_st<one_up)
   pitch_start_label='H';
   out_values_st=syll_pitch_st;
elseif (syll_pitch_st>=one_up && syll_pitch_st<=pitch_maxval)
   pitch_start_label='VH';
   out_values_st=syll_pitch_st;
end
pitch_label_out=pitch_start_label;
end

if(out_size==0)
        pitch_label_out='NP';
        out_values_st=1;
end