%Edited on 19-06-2022 by RMP pitch transcription label using mean and graph
% plot
function prosodytrans(input_wav)

% to read input speech file
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
m_pc=max(pitch_contour);
mi_pc=min(pitch_contour);

% Syllable calculation
[Table_text_out]=syllabifier(input_sample,fs,time,N);

%read values from text file
Table_in = Table_text_out;
start_time=Table_in(:,1);
timest_array = table2array(start_time);

%generate pitch labels
s_T=length(timest_array);
final_ans=strings(s_T,1);
pl_val=zeros(s_T,1);
for i=1:s_T-1
  t_st=timest_array(i);
  t_end=timest_array(i+1);
  [label_trans,out_values_st] =Auto_pitch(epoch_loc,pitch_contour,epoch_strength,fs,t_st,t_end,mean_pitch,std_pitch,one_down,two_down,one_up,two_up,m_pc,mi_pc);
  final_ans(i)=label_trans;
  pl_val(i)=out_values_st;
end
final_ans(i+1)=label_trans;
%to get values in table format
ti_st_array=zeros(s_T-1,1);
pi_array=strings(s_T-1,1);
ti_end_array=zeros(s_T-1,1);
pl_val_st=zeros(s_T-1,1);
pl_val_end=zeros(s_T-1,1);
for i1=1:s_T-1
ti_st_array(i1)=timest_array(i1);
ti_end_array(i1)=timest_array(i1+1);
pi_array(i1)=final_ans(i1)+"-"+final_ans(i1+1);
pl_val_st(i1)=pl_val(i1);
pl_val_end(i1)=pl_val(i1+1);
end

%to write table output
prosody_label=array2table(pi_array); 
st_ti_table=array2table(ti_st_array);
end_ti_table=array2table(ti_end_array);
Table_out=[st_ti_table,end_ti_table,prosody_label];
writetable(Table_out, '/var/www/html/nltm/pitch_trans/output_file/Pitch_label.txt','Delimiter','\t'); 

%to get values of time and pitch array
l_T=length(ti_st_array);
boun_x=zeros(l_T,1);
boun_y=zeros(l_T,1);
j=1;
for i3=1:l_T
 boun_x(i3)=ti_st_array(i3);
 boun_y(i3)=pl_val_st(i3);
end
 boun_x(i3+1)=ti_end_array(i3);
 boun_y(i3+1)=pl_val_end(i3);
 
%ploting the wave and pitch contour transcription
%subplot(2,1,1);
f = figure('visible','off');
plot(time,input_sample);
set(f, 'visible', 'on');
axis([min(time),max(time),-1.1,1.1]);grid;
set(gca,'YTick', []);
f=gcf;
f.Position(3:4)=[600,200];
saveas(gcf,'/var/www/html/nltm/pitch_trans/output_file/Input speech.jpg','jpg');
close(f);

% subplot(2,1,2);
f = figure('visible','off');
plot(epoch_loc/fs,pitch_contour,'.','markersize',8);
axis([min(time),max(time),1,(m_pc+50)]);grid
%title('Pitch transcription contour');
hold on;
plot(boun_x,boun_y,'k','linewidth',1.5);
hold on;
mcolor1 = [.83 .05 .18];
plot(boun_x,boun_y,'.','MarkerSize',12,'Color', mcolor1);
hold on;
mcolor = [.72 .003 .28];
plot([0, max(time)],[one_down, one_down],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), two_down,'Very low','Color', mcolor);
mcolor = [.11 .10 .63];
plot([0, max(time)],[mean_pitch, mean_pitch],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), (mean_pitch+one_down)/2,'Low','Color', mcolor);
mcolor = [.04 .23 .007];
plot([0, max(time)],[one_up, one_up],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), (one_up+mean_pitch)/2,'High','Color', mcolor);
mcolor = [.92 .08 .03];
text( max(time), (two_up+one_up)/2,'Very high','Color', mcolor);
set(gca,'YTick', [])
f=gcf; 
f.Position(3:4)=[600,200];
saveas(gcf,'/var/www/html/nltm/pitch_trans/output_file/Pitch Transcription.jpg','jpg');
close(f);
end


