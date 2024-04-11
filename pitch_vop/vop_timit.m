clc;
clear all;
close all;
%Edited on 22-08-2022 by RMP for VOP detection for comparision with timit

%to read input file
input_wav='E:\NLTM Project\Tesing_code\APTS_VOP\input_wave\Timit\SX444.WAV.wav';
[y,fs]=audioread(input_wav);
N = length(y);
q=18;
time=(0:N-1)/fs;

%filtering
p=4000/q;
x(1,:)=bandpass(y(:,1),[15 p],fs);
for i=2:q
 x(i,:)=bandpass(y(:,1),[(i-1)*p i*p],fs);
end

%halfwave rectifier
for i=1:q
 for j=1:N
  if x(i,j)<0
   a(i,j)=0;
  else
   a(i,j)=x(i,j);
  end
 end
end

%lowpass filtering
for i=1:q
 lp(i,:)=lowpass(a(i,:),28,fs,'Steepness',0.95);
%     lp(i,:)=smooth(lp(i,:),50*fs/1000);
end

%normalise
for i=1:q
 dw(i,:)=lp(i,:)./max(lp(i,:));
end

%fft window
ham=hamming(20);
for i=1:q
 temp=dw(i,:);
 temp=buffer(temp,20,19);
 temp=temp.*(ham*ones(1,length(temp)));
 temp=fft(temp,40);
 temp = sum(abs(temp(4:16,:)));
 temp1(i,:)=temp;
end

%enhancement
temp1=sum(temp1);
temp1=resample(temp1,80,fs);
temp1=resample(temp1,fs,80);
temp1=temp1/max(temp1);
temp1=filtfilt(hamming(1600),1,temp1);
y1=diff(temp1);
y2=buffer(y1,160,159);
y3=sum(y2);
y4=y3;
y4(y3<0)=0;
Fogd=diff(gausswin(800));
y5=filter(Fogd,1,y4);

%VOP enhancing and removing close peaks
y5=y5./max(y5);
y5(y5<0)=0;
y5(y5<0.1)=0;
y5=smooth(y5,320);
[pks, vop]=findpeaks(y5);
l_v=length(vop);
t_vop=zeros(l_v,1);

% to find VOP time location
for k1=1:length(vop)
 t_vop(k1)=vop(k1)/fs;
end
time_vop1=t_vop;
time_vop=round(time_vop1,2);

% to get value from timit and compare it
table_phn=readtable('E:\NLTM Project\Tesing_code\APTS_VOP\input_wave\Timit\SX444_phn.txt');
row_1=table_phn(:,1);
row_2=table_phn(:,2);
row_3=table_phn(:,3);
vowel={'iy','ih','eh','ey','ae','aw','ay','ah','ao','oy','ow','uh','uw','ux','er','ax','ix','axr','ax-h'};
sam_st=table2array(row_1);
sam_end=table2array(row_2);
v_loc=table2array(row_3);
j1=1;
vl_v=length(v_loc);
for i1=1:vl_v
cmp_out=ismember(v_loc(i1),vowel);
if(cmp_out==1)
  vo_reg(j1)=sam_st(i1);
  j1=j1+1;
end  
end
ti_reg=vo_reg./fs;
s_ti=size(ti_reg);
 % to plot vop values
y_vop=ones(size(pks));
yp_vop=0.2*y_vop;
y_timit=ones(s_ti);
yp_timit=0.2* y_timit;
plot(time,y);
title('Input speech');
axis([min(time),max(time),-0.2,0.2]);grid;
hold on;
stem(time_vop,yp_vop,'*','k','linewidth',1);
stem(ti_reg,yp_timit,'*','r','linewidth',1,'linestyle','--');
