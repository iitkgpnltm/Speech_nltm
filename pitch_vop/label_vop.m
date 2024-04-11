%Edited on 04-08-2022 by RMP to merge same labels of automatic pitch transcription 

function label_vop(input_wav)
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

% Syllable calculation vop
[Table_text_out,time_vop]=vop(input_sample,fs,time,N);

%read values from text file
Table_in = Table_text_out;
start_time=Table_in(:,1);
timest_array = table2array(start_time);

%generate pitch labels
m_pc=max(pitch_contour);
s_T=length(timest_array);
final_ans=strings(s_T,1);
pl_val=zeros(s_T,1);
for i=1:s_T
  t_st=timest_array(i,1);
  [label_trans,out_values_st] =Auto_pitch(epoch_loc,pitch_contour,epoch_strength,fs,t_st,mean_pitch,std_pitch,one_down,two_down,one_up,two_up,pitch_maxval,pitch_minval);
  final_ans(i)=label_trans;
  pl_val(i)=out_values_st;
end

%to get values in table format
ti_st_array=zeros(s_T-1,1);
pi_array=strings(s_T-1,1);
ti_end_array=zeros(s_T-1,1);
pl_val_st=zeros(s_T-1,1);
pl_val_end=zeros(s_T-1,1);
for i1=1:s_T-1
ti_st_array(i1)=time_vop(i1);
ti_end_array(i1)=time_vop(i1+1);
pi_array(i1)=final_ans(i1)+"-"+final_ans(i1+1);
pl_val_st(i1)=pl_val(i1);
pl_val_end(i1)=pl_val(i1+1);
end

%to write output table
modi_st=array2table(ti_st_array);
modi_end=array2table(ti_end_array);
modi_label=array2table(pi_array);
modi_table_out=[modi_st modi_end  modi_label];
writetable(modi_table_out,'/var/www/html/nltm/pitch_vop/output_file/Pitch_label.txt','Delimiter','\t'); 


%to get values of time and pitch in array
l_T=length(ti_st_array);
boun_x_s=zeros(l_T,1);
boun_y_s=zeros(l_T,1);
for i3=1:l_T
 boun_x_s(i3)=ti_st_array (i3);
 boun_y_s(i3)=pl_val_st (i3);
 end
boun_x_s(i3+1)=ti_end_array(i3);
boun_y_s(i3+1)=pl_val_end(i3);
 
% ploting the input speech wave and pitch contour
%subplot(2,1,1);
f = figure('visible','off');
plot(time,input_sample);
set(f, 'visible', 'on');
hold on;
stem(time_vop,ones(s_T),'*','r','linewidth',1);
%title('Input speech');
legend('Input speech','VOP');
axis([min(time),max(time),-1.1,1.1]);grid;
set(gca,'YTick', []);
f=gcf;
f.Position(3:4)=[600,200];
saveas(gcf,'/var/www/html/nltm/pitch_vop/output_file/Input speech.jpg','jpg');
close(f);

%subplot(2,1,2);
f = figure('visible','off');
plot(epoch_loc/fs,pitch_contour,'.','markersize',8);
axis([min(time),max(time),10,(m_pc+50)]);grid
%title('Pitch transcription contour');

hold on;
plot(boun_x_s,boun_y_s,'k','linewidth',1.5);
hold on;
mcolor1 = [.83 .05 .18];
plot(boun_x_s,boun_y_s,'.','MarkerSize',12,'Color', mcolor1);
hold on;
mcolor = [.72 .003 .28];
plot([0, max(time)],[one_down, one_down],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time),two_down,'Very low','Color', mcolor);
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
saveas(gcf,'/var/www/html/nltm/pitch_vop/output_file/Pitch Transcription.jpg','jpg');
close(f);
end
