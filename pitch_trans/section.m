filename = '1.wav'; 
inputRange = 4000:4200;
[Y, Fs]=audioread(filename, [inputRange(1) inputRange(end)]);
timeAxis=inputRange/Fs;
plot(timeAxis, Y);