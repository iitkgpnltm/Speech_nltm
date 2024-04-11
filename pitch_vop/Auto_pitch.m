%Edited on 04-08-2022 by RMP automatic pitch transcription label 
%deviation

function[pitch_label_out,out_values_st]=Auto_pitch(epoch_loc,pitch_contour,epoch_strength,fs,time_start,mean_pitch,std_pitch,one_down,two_down,one_up,two_up,pitch_maxval,pitch_minval)

time_start_n=time_start;

%to find time location
time_loc=epoch_loc/fs;

%to find range values
out=find(time_loc>=time_start_n);
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
        out_values_end=1;
        out_values_st=1;
end
end