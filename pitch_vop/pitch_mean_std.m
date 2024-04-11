%Edited on 10-06-2022 by RMP pitch transcription label using mean and std
%deviation

close all;
clear all;

% to read input speech file
input_speech='SA1.wav';
[input_sample,fs]=audioread(input_speech);

%calculate pitch by using zff method
[epoch_loc,pitch_contour,epoch_strength]=zff_based_pitch_contour(input_sample,fs);


time_start=0.3709;
time_end=0.3809;


sample_start=time_start*fs;
sample_end=time_end*fs;

sylable_contour=find((epoch_loc>sample_start) & (epoch_loc<sample_end));


%calculate mean and std deviation

mean_pitch=mean(pitch_contour);
std_pitch=std(pitch_contour);

%fis range for pitch values
c1=mean_pitch-std_pitch; 
c2=mean_pitch-(2*std_pitch);
c3=mean_pitch+std_pitch;
c4=mean_pitch+(2*std_pitch);
pitch_outlabel='';
if (time_start>=c2 && time_start<c1)
    pitch_outlabel='VL';
elseif (time_start>=c1 && time_start<mean_pitch)
    pitch_outlabel='L';
elseif (time_start>=mean_pitch && time_start<c3)
    pitch_outlabel='H';
elseif (time_start>=c3 && time_start<=c4)
    pitch_outlabel='VH';
end
disp(pitch_outlabel);

%read label file
table_in=readtable('SA1.txt');

row_1=table_in(:,1);
row_2=table_in(:,2);

table_array1 = table2array(row_1);
table_array2 = table2array(row_2);

size_t=size(table_array1);


