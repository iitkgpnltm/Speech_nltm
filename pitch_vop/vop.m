
%Edited on 25-07-2022 by RMP for VOP detection
function [Table_text_out,time_vop]=vop(y,fs,time,N)
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
time_vop=round(time_vop1,4);

%to write in table
Table_text=[time_vop];
 Table_text_out=array2table(Table_text); 
end


