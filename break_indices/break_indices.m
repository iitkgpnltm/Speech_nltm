%Energy of signal edited on 6-09-22 by RMP for break indices using frames

function break_indices(input_wav)
%to get input file
[x, fs] = audioread(input_wav);
N = length(x);
t = (0:N-1)/fs; 
 
%signal frame
frlen = round(20e-3*fs);
hop = round(frlen/2);
[FRM] = framing(x, frlen, hop, fs); 
 
%to determine short term energy and mean
energy_st = sum(FRM.^2);
m_energy_st=mean(energy_st);

% thresholding
l_e=size(FRM,2);
twenty_p=0.2*m_energy_st;
bin_energy=zeros(l_e,1);

%energy values in binary for threshold value
for i1=1:l_e
if(energy_st(i1)<twenty_p)
  bin_energy(i1)=1;
else
  bin_energy(i1)=0;
end
end

%location of frames
fr_st(1)=0;
fr_end(1)=frlen;
for i=2:1:l_e
fr_st(i)=(fr_st(i-1)+hop);
fr_end(i)=(fr_end(i-1)+hop);
end

%to determine break indices 
j=0; k=1;
for i2=1:l_e
  if(bin_energy(i2)==1)
  j=j+1;
  continue
  elseif(j>=3)
  if(bin_energy(i2-1)==1) &&(bin_energy(i2)==0)
  lbfr_st(k)=(fr_st(i2-j))/fs;
  lbfr_end(k)=(fr_end(i2-1))/fs;
  k=k+1;
  j=0;
  end
  end
end
if(bin_energy(i2==l_e))
 if(j>=1)
 lbfr_st(k)=(fr_st(i2-j))/fs;
 lbfr_end(k)=(fr_end(i2))/fs;
 end
end

%to determine difference between values
dif_str=(lbfr_end-lbfr_st);
l_T=length(dif_str);
j=1
for i3=1:l_T
 if(dif_str(i3)>=0.04)
  m_val(j)=dif_str(i3);
  m_st(j)=lbfr_st(i3);
  m_end(j)=lbfr_end(i3);
  j=j+1;
 elseif(dif_str(i3)<0.04)
  j=j;
 end
end

%assigning break indices
le_T=length(m_val);
bi_str=strings(le_T,1);
for i4=1:le_T
 if(m_val(i4)>=0.04 && m_val(i4)<0.1)
  bi_str(i4)='B1';
 elseif(m_val(i4)>=0.1 && m_val(i4)<0.15)
  bi_str(i4)='B2';
 elseif(m_val(i4)>=0.15 && m_val(i4)<0.4)
  bi_str(i4)='B3';
 elseif(m_val(i4)>=0.4)
  bi_str(i4)='B4';
 end
end

%to write in table
st_tab1=(m_st).';
en_tab1=(m_end).';
st_tab=array2table(st_tab1);
en_tab=array2table(en_tab1);
lab_tab=array2table((bi_str));
table_out=[st_tab en_tab lab_tab];
writetable(table_out,'/var/www/html/nltm/break_indices/output_file/break_trans.txt','Delimiter','\t');

%values for ploting
sam_st=m_st.*fs;
sam_end=m_end.*fs;

%to plot values
figure;
f = figure('visible','off');
mcolor=[0.71 0.67 0.96];
plot(t,x,'color',mcolor);
set(f, 'visible', 'on');
axis([min(t),max(t),-1,1]);grid;
hold on;
for i6=1:le_T
 %for plotting purpose 500 samples adjusted
 p_x=m_st(i6);
 p_y=m_end(i6);
 t_x=[(((sam_st(i6)+sam_end(i6))/2)-500)/fs];
 lbl=bi_str(i6);
 text(t_x, 0.65,lbl,'color',[1 0 0]);
 plot([p_x p_y],[0.6 0.6],'k','linewidth',1.5);
end
y_fr1=ones(le_T);
y_fr=0.6*y_fr1;
hold on;
stem(m_st,y_fr ,'k','linewidth',1.5,'linestyle','-','marker','none');
hold on;
stem(m_end, y_fr,'k','linewidth',1.5,'linestyle','-','marker','none');
set(gca,'YTick', []);
f=gcf;
f.Position(3:4)=[600,200];
saveas(gcf,'/var/www/html/nltm/break_indices/output_file/Input speech.jpg','jpg');
close(f);
end
