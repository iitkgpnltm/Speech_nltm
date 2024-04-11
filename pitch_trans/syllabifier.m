%Edited on 16-07-2022 by RMP for syllable boundary of 60ms
function[Table_text_out]=syllabifier(input_sample,fs,time,N)
time_end_val=time(N);
j=1;
for i=0:0.0613:time_end_val
   time_val(j)= i;
        j=j+1;
 end
l_t=length( time_val);
time_val_st=zeros(l_t,1);
% time_val_end=zeros(l_t,1);
for k=1:l_t
     time_val_st(k)= time_val(k);
end
 time_val_st(k+1)=time_end_val;
 
 time_val_s=round(time_val_st,4);
 Table_text=[time_val_s];
 Table_text_out=array2table(Table_text); 
end