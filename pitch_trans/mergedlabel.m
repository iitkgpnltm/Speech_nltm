%Edited on 04-08-2022 by RMP to merge same labels of automatic pitch transcription 

function mergedlabel(input_wav)
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

% Syllable calculation fixed time
[Table_text_out]=syllabifier(input_sample,fs,time,N);

%read values from text file
Table_in = Table_text_out;
start_time=Table_in(:,1);
end_time=Table_in(:,2);
timest_array = table2array(start_time);
timeend_array = table2array(end_time);

%generate pitch labels
m_pc=max(pitch_contour);
s_T=length(timest_array);
final_ans=strings(s_T,1);
pl_val_st=zeros(s_T,1);
pl_val_end=zeros(s_T,1);
for i=1:s_T
  t_st=timest_array(i,1);
  t_end=timeend_array(i,1);
  [label_trans,out_values_st,out_values_end] =Auto_pitch(epoch_loc,pitch_contour,epoch_strength,fs,t_st,t_end,mean_pitch,std_pitch,one_down,two_down,one_up,two_up,pitch_maxval,pitch_minval);
  final_ans(i)=label_trans;
  pl_val_st(i)=out_values_st;
  pl_val_end(i)=out_values_end;
end
prosody_label=array2table( final_ans); 
Table_out=[start_time,end_time,prosody_label];

%to merge equal label states
str=zeros(1);
st_flag=0;
j=1;
k=1;
for i1=1:(s_T-1)
  str(j)=strcmp(final_ans(i1),final_ans(i1+1));       
 if(str(j)==1)
  st_flag=st_flag+1;
  continue
 else
  modi_st_array(k)=timest_array(i1-st_flag);
  modi_end_array(k)=timeend_array(i1);
  modi_pt_label(k)=final_ans(i1);
  modi_pt_st(k)=pl_val_st(i1);
  modi_pt_end(k)=pl_val_end(i1);
  k=k+1;
  st_flag=0;
 end
end
if(i1==s_T-1)
  v1= modi_pt_label(k-1);
  v2=final_ans(i1+1);
  str_c=strcmp(v1,v2);
  if(str_c==0)
   modi_st_array(k)= modi_end_array(k-1);
   modi_end_array(k)=timeend_array(i1+1);
   modi_pt_label(k)=final_ans(i1+1);
   modi_pt_st(k)=pl_val_st(i1+1);
   modi_pt_end(k)=pl_val_end(i1+1);
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
writetable(modi_table_out,'E:\NLTM Project\Tesing_code\APTS_ZFF\output_file\Pitch_label.txt','Delimiter','\t'); 

%to get values of time and pitch in array
ms_T=length(modi_st_array);
es_T=(2*ms_T);
boun_x=zeros(es_T,1);
boun_y=zeros(es_T,1);
j1=1;
for i2=1:ms_T()
 boun_x(j1)=modi_st_array (i2);
 boun_x(j1+1)=modi_end_array(i2);
 boun_y(j1)=modi_pt_st (i2);
 boun_y(j1+1)=modi_pt_end(i2);
 j1=j1+2;
end

% to get values of L, VL, H, VH values for ploting only
x_vl(1)=0; x_l(1)=0; x_h(1)=0; x_vh(1)=0; x_np(1)=0;
y_vl(1)=0; y_l(1)=0; y_h(1)=0; y_vh(1)=0; x_np(1)=0;
v_vl=1;    v_l=1;    v_h=1;    v_vh=1;    v_np=1;
for i3=1:(2*ms_T)
 if(boun_y(i3)>=two_down && boun_y(i3)<one_down)
  x_vl(v_vl)=boun_x(i3);
  y_vl(v_vl)=boun_y(i3);
  v_vl=v_vl+1;
 end
 if(boun_y(i3)>=one_down && boun_y(i3)<mean_pitch)
  x_l(v_l)=boun_x(i3);
  y_l(v_l)=boun_y(i3);
  v_l=v_l+1;
 end
 if(boun_y(i3)>=mean_pitch && boun_y(i3)<one_up)
  x_h(v_h)=boun_x(i3);
  y_h(v_h)=boun_y(i3);
  v_h=v_h+1;
 end
 if(boun_y(i3)>=one_up && boun_y(i3)<=pitch_maxval)
  x_vh(v_vh)=boun_x(i3);
  y_vh(v_vh)=boun_y(i3);
  v_vh=v_vh+1;
 end
 if(boun_y(i3)==1)
  x_np(v_np)=boun_x(i3);
  y_np(v_np)=boun_y(i3);
  v_np=v_np+1;
 end
end

% ploting the input speech wave and pitch contour
subplot(2,1,1);
plot(time,input_sample);
title('Input speech');
axis([min(time),max(time),-1.1,1.1]);grid;

subplot(2,1,2);
plot(epoch_loc/fs,pitch_contour,'.','markersize',8);
axis([min(time),max(time),10,(m_pc+50)]);grid
title('Pitch transcription contour');

hold on;
plot(boun_x,boun_y,'k','linewidth',1.5);

hold on;
mcolor1 = [.83 .05 .18];
plot(x_vl,y_vl,'.','MarkerSize',12,'Color', mcolor1);
plot(x_l,y_l,'.','MarkerSize',12,'Color', mcolor1);
plot(x_h,y_h,'.','MarkerSize',12,'Color', mcolor1); 
plot(x_vh,y_vh,'.','MarkerSize',12,'Color', mcolor1); 
  
hold on;
mcolor = [.72 .003 .28];
plot([0, max(time)],[one_down, one_down],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), one_down,'Very low','Color', mcolor);
mcolor = [.11 .10 .63];
plot([0, max(time)],[mean_pitch, mean_pitch],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), mean_pitch,'Low','Color', mcolor);
mcolor = [.04 .23 .007];
plot([0, max(time)],[one_up, one_up],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), one_up,'High','Color', mcolor);
mcolor = [.92 .08 .03];
plot([0, max(time)],[two_up, two_up],'Color', mcolor,'linestyle','--','linewidth',0.8);
text( max(time), two_up,'Very high','Color', mcolor);
end