%Edited on 04-08-2022 by RMP to merge same labels of automatic pitch transcription 

function mergedlabel(input_wav)
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

%to merge equal values
str=zeros(1);
p_T=length(pi_array);
st_flag=0;
j=1;
k=1;
for i2=1:(p_T-1)
  str(j)=strcmp(pi_array(i2),pi_array(i2+1));       
 if(str(j)==1)
  st_flag=st_flag+1;
  continue
 else
  modi_st_array(k)=ti_st_array(i2-st_flag);
  modi_end_array(k)=ti_end_array(i2);
  modi_pt_label(k)=pi_array(i2);
  modi_pt_st(k)=pl_val_st(i2-st_flag);
  modi_pt_end(k)=pl_val_end(i2);
  k=k+1;
  st_flag=0;
 end
end
if(i2==p_T-1)
  v1= pi_array(i2);
  v2=pi_array(i2+1);
  str_c=strcmp(v1,v2);
  if(str_c==1)
   modi_st_array(k)= modi_end_array(k-1);
   modi_end_array(k)=ti_end_array(i2+1);
   modi_pt_label(k)=pi_array(i2+1);
   modi_pt_st(k)=pl_val_st(k);
   modi_pt_end(k)=pl_val_end(i2+1);    
  elseif(str_c==0)
   modi_st_array(k)= ti_st_array(i2+1);
   modi_end_array(k)=ti_end_array(i2+1);
   modi_pt_label(k)=pi_array(i2+1);
   modi_pt_st(k)=pl_val_st(i2+1);
   modi_pt_end(k)=pl_val_end(i2+1);    
  end
end

%to write modified output table
modi_11=modi_st_array.';
modi_21=modi_end_array.';
modi_31=modi_pt_label.';
modi_st=array2table(modi_11);
modi_end=array2table(modi_21);
modi_label=array2table(modi_31);
modi_table_out=[modi_st modi_end  modi_label];
writetable(modi_table_out,'E:\NLTM Project\Tesing_code\APTS_VOP\output_file\Pitch_label.txt','Delimiter','\t'); 


%to get values of time and pitch in array
l_T=length(modi_st_array);
boun_x_s=zeros(l_T,1);
boun_y_s=zeros(l_T,1);
for i3=1:l_T
 boun_x_s(i3)=modi_st_array (i3);
 boun_y_s(i3)=modi_pt_st (i3);
 end
boun_x_s(i3+1)=modi_end_array(i3);
 boun_y_s(i3+1)=modi_pt_end(i3);
 
% ploting the input speech wave and pitch contour
subplot(2,1,1);
plot(time,input_sample);
hold on;
stem(time_vop,ones(s_T),'*','r','linewidth',1);
title('Input speech');
legend('Input speech','VOP');
axis([min(time),max(time),-1.1,1.1]);grid;

subplot(2,1,2);
plot(epoch_loc/fs,pitch_contour,'.','markersize',8);
axis([min(time),max(time),10,(m_pc+50)]);grid
title('Pitch transcription contour');

hold on;
plot(boun_x_s,boun_y_s,'k','linewidth',1.5);
hold on;
mcolor1 = [.83 .05 .18];
plot(boun_x_s,boun_y_s,'.','MarkerSize',12,'Color', mcolor1);
hold on;
mcolor = [.72 .003 .28];
plot([0, max(time)],[one_down, one_down],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), one_down/2,'Very low','Color', mcolor);
mcolor = [.11 .10 .63];
plot([0, max(time)],[mean_pitch, mean_pitch],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), (mean_pitch+one_down)/2,'Low','Color', mcolor);
mcolor = [.04 .23 .007];
plot([0, max(time)],[one_up, one_up],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), (one_up+mean_pitch)/2,'High','Color', mcolor);
mcolor = [.92 .08 .03];
text( max(time), (two_up+one_up)/2,'Very high','Color', mcolor);
end