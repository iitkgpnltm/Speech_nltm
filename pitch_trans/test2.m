clear all; 
close all;
input_wav='E:\NLTM Project\Tesing_code\APTS_VOP\input_wave\Timit\SA2.WAV.wav';
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
one_down=mean_pitch-(5*std_pitch); 
two_down=mean_pitch-(3*std_pitch);
one_up=mean_pitch+(1.5*std_pitch);
two_up=mean_pitch+(3*std_pitch);
pitch_maxval=max(pitch_contour);
pitch_minval=min(pitch_contour);

time_start_n=0.16;
time_end_n=0.63;
sample_start=(time_start_n*fs);
sample_end=(time_end_n*fs);

%to find range values
out=find(epoch_loc>sample_start & epoch_loc<sample_end);
out_size=length(out);
pitch_start_label='';
pitch_end_label='';

syll_pitch_st=0;
syll_pitch_end=0;
pitch_maxval=max(pitch_contour);
pitch_minval=min(pitch_contour);
out_values_st=0;
out_values_end=0;

if (out_size >0)
syll_pitch_st=pitch_contour(out(1));
syll_pitch_end=pitch_contour(out(out_size));

if (syll_pitch_st>=pitch_minval && syll_pitch_st<one_down) 
    pitch_start_label='VL';
    out_values_st=syll_pitch_st;
elseif (syll_pitch_st>=one_down && syll_pitch_st<mean_pitch)
    pitch_start_label='L';
     out_values_st=syll_pitch_st;
elseif (syll_pitch_st>=mean_pitch && syll_pitch_st<one_up)
   pitch_start_label='H';
   out_values_st=syll_pitch_st;
elseif (syll_pitch_st>=one_up && syll_pitch_st<=pitch_maxval )
   pitch_start_label='VH';
   out_values_st=syll_pitch_st;
end
if (syll_pitch_end>=pitch_minval && syll_pitch_end<one_down)
    pitch_end_label='VL';
      out_values_end=syll_pitch_end;
elseif (syll_pitch_end>=one_down && syll_pitch_end<mean_pitch)
    pitch_end_label='L';
    out_values_end=syll_pitch_end;
elseif (syll_pitch_end>=mean_pitch && syll_pitch_end<one_up)
   pitch_end_label='H';
   out_values_end=syll_pitch_end;
elseif (syll_pitch_end>=one_up && syll_pitch_end<=pitch_maxval) 
   pitch_end_label='VH';
   out_values_end=syll_pitch_end;
end

pitch_label_out=pitch_start_label+"-"+pitch_end_label;
disp(pitch_label_out);
end