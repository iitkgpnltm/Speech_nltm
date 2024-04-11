%Edited on 19-06-2022 by RMP pitch transcription label using mean and graph
% plot
function prosodytrans(input_wav)

% to read input speech file
input_speech=input_wav;
[input_sample,fs]=audioread(input_speech);
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

% Syllable calculation
[Table_text_out]=syllabifier(input_sample,fs,time,N);

%read values from text file
Table_in = Table_text_out;
start_time=Table_in(:,1);
end_time=Table_in(:,2);
timest_array = table2array(start_time);
timeend_array = table2array(end_time);

%generate pitch labels
m_pc=max(pitch_contour);
s_T=size(timest_array);
final_ans=strings(s_T(1),1);
pl_val_st=zeros(s_T(1),1);
pl_val_end=zeros(s_T(1),1);
for i=1:s_T(1)
    t_st=timest_array(i,1);
    t_end=timeend_array(i,1);
    [label_trans,out_values_st,out_values_end] =Auto_pitch(epoch_loc,pitch_contour,epoch_strength,fs,t_st,t_end,mean_pitch,std_pitch,one_down,two_down,one_up,two_up,pitch_maxval,pitch_minval);

    final_ans(i)=label_trans;
    pl_val_st(i)=out_values_st;
    pl_val_end(i)=out_values_end;
end
%to get values of time and pitch array
es_T(1)=(2*s_T(1));
boun_x=zeros(es_T(1),1);
boun_y=zeros(es_T(1),1);
j=1;
for i=1:s_T(1)
    
    boun_x(j)=timest_array (i,1);
    boun_x(j+1)=timeend_array(i,1);
    boun_y(j)=pl_val_st (i);
    boun_y(j+1)=pl_val_end(i);
    j=j+2;
end
prosody_label=array2table( final_ans); 
Table_out=[start_time,end_time,prosody_label];
 writetable( Table_out, 'E:\NLTM Project\Matlab_Programs\Demo_internet\output_file\Pitch transcription label.txt','Delimiter','\t'); 
%type 'Table_out_SA1.txt';  

%ploting the wave and pitch
% subplot(2,1,1);
plot(time,input_sample);
%title('Input speech');
% axis([min(time),max(time),-1.1,1.1]);grid;
set(gca,'XTick',[], 'YTick', []);
fig=gcf;
fig.Position(3:4)=[800,200];
saveas(gcf,'E:\NLTM Project\Matlab_Programs\Demo_internet\output_file\Input speech.jpg','jpg');

%  subplot(2,1,2);
 plot(epoch_loc/fs,pitch_contour,'.','markersize',8);
 %title('Pitch transcription contour');

 % plot(epoch_loc/fs,pitch_contour);
% axis([min(time),max(time),10,(m_pc+100)]);grid
% hold on;
% grayColor = [.7 .7 .7];
% for i=1:2:(2*s_T)
% %  plot([boun_x(i) boun_x(i)],[m_pc boun_y(i)] ,'Color', grayColor,'linewidth',1.5);
%  plot([boun_x(i) boun_x(i)],[(m_pc+100) 0] ,'Color', grayColor,'linewidth',1.5);
% %  axis([min(time),max(time),10,400]);grid
% % disp(i);
% end

hold on;
 plot(boun_x,boun_y,'k','linewidth',1.5);
 hold on;
for i=1:(2*s_T)
    if(boun_y(i)>=two_down & boun_y(i)<one_down) |(boun_y(i)<=pitch_minval)
      mcolor = [.72 .003 .28];
      plot(boun_x(i),boun_y(i),'^','MarkerSize',10,'Color', mcolor);
    end
    if(boun_y(i)>=one_down & boun_y(i)<mean_pitch)
      mcolor = [.11 .10 .63];
      plot(boun_x(i),boun_y(i),'^','MarkerSize',10,'Color', mcolor);
    end
     if(boun_y(i)>=mean_pitch & boun_y(i)<one_up)
      mcolor = [.04 .23 .007];
      plot(boun_x(i),boun_y(i),'^','MarkerSize',10,'Color', mcolor);
     end
     if(boun_y(i)>=one_up & boun_y(i)<=two_up )| (boun_y(i)<=pitch_maxval)
       mcolor = [.92 .08 .03];
       plot(boun_x(i),boun_y(i),'^','MarkerSize',10,'Color', mcolor);
      end
end
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
 set(gca,'XTick',[], 'YTick', [])
saveas(gcf,'E:\NLTM Project\Matlab_Programs\Demo_internet\output_file\Pitch Transcription.jpg','jpg');

