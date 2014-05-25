clc; close all;
%Data in the D: drive
cd 'D:\';

%List available files, pick the file
s = dir('*.TXT');
file_list = {s.name};


%Open the selected file
if length(file_list) < 2
    filename = s.name;
    fid = fopen(filename,'r');
else 
    selection = menu('Select a file',file_list);
    filename = s(selection,1).name;
    fid = fopen(filename,'r');
end

fclose(fid);

csvdata = csvread(filename,1,0);

year = csvdata(:,1);
month = csvdata(:,2);
day = csvdata(:,3);
hour = csvdata(:,4);
minute = csvdata(:,5);
second = csvdata(:,6);
pressure = csvdata(:,7);
temperature = csvdata(:,8);

datemat = datenum(datestr([year month day hour minute second]));
times = [];
for i = 1:length(datemat)
    times(i) = datemat(i);
end

figure(1);
plot(times,temperature);
datetick();

figure(2);
plot(times, pressure/1000);
datetick();

