%[text] # SageFetchObj Examples
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] ## !UPDATE!
%[text] Note that IRISWS as discontinued as of 8/26/26.
%[text] ## Data Retrieval - Time Series Data
%[text] Time series data can be retrieved in the miniSeed format via SAGE's fdsnws (FDSN webservice). The class object sageFetchObj retrieves the data directly into the MATLAB workspace without downloading the file itself. To build the appropriate URL for fetching data, fill in the fields in the next section. It is okay to leave a field blank. A table called "request\_info" will be assembled with your specified parameters.
%[text] Call sageFetchObjSageFetch.Timeseries to build s URL for requesting your desired trace/timeseries data. The URL building works in the same way as SAGE's own URL builder, composing a URL string from your input criteria. SageFetch then uses [MATLAB's built-in RESTful web service functions](https://www.mathworks.com/help/matlab/http-interface.html?s_tid=CRUX_lftnav) to bring the requested data directly from the internet into your workspace. This is very similar to how irisFetch operated but without the extra steps of dumping the retrieved data into a java heap and re-parsing it in MATLAB.
%[text] However, in order to interpret the trace data, sageFetchObj calls one of two functions created by [François Beauducel](https://www.mathworks.com/matlabcentral/profile/authors/1195687): [rdmseed](https://www.mathworks.com/matlabcentral/fileexchange/28803-rdmseed-and-mkmseed-read-and-write-miniseed-files?s_tid=prof_contriblnk) or [rdsac](https://www.mathworks.com/matlabcentral/fileexchange/46356-rdsac-and-mksac-read-and-write-sac-seismic-data-file?s_tid=prof_contriblnk). They are available on the MATLAB File Exchange or GitHub. If you do not have at least one of these functions downloaded and installed on the MATLAB path, sageFetchObj will not be able to bring in the data. SageFetchObj will not be bundling the above functions with the rest of its retrieval code, as they belong to François Beauducel, and his repositories should get credit for the function downloads from everyone using them.
%[text] With the above functions and MATLAB's built-in ability to read and save csv (or other) file formats, your basic data access needs should be met! However, we are working on also incorporating options to use SAGE's other services (such as downloading specific event metadata). If you have a specific workflow you need help with or want incorporated into sageFetch's capabilities, please reach out to the owner of the repository where you found this notebook!
%[text] [https://service.earthscope.org/fdsnws/dataselect/docs/1/builder/](https://service.earthscope.org/fdsnws/dataselect/docs/1/builder/) 
%[text] [NSF SAGE: IRISWS: Timeseries: Docs: v. 1: Builder](https://service.iris.edu/irisws/timeseries/docs/1/builder/) 
%%
%[text] ## Example 1: miniSeed
network = 'IU'; %[control:editfield:084d]{"position":[11,15]}
station = 'PET'; %[control:editfield:4690]{"position":[11,16]}
location = '00'; %[control:editfield:8fa6]{"position":[12,16]}
channel = 'BHZ'; %[control:editfield:8561]{"position":[11,16]}
saveFiles = true; %[control:checkbox:1a16]{"position":[13,17]}
starttime = "2025-07-29 22:00:00";
endtime = "2025-07-30 04:00:00";

fileformat = 'miniseed'; %[control:dropdown:0061]{"position":[14,24]}


S = sageFetchObj.Timeseries(network,station,location,channel,starttime,endtime,'fileFormat',fileformat,'saveFiles',saveFiles);
% optional name-value pairs: fileFormat, useAuth, correction
%[text] If you receive this error
%[text] ```matlabCodeExample
%[text] Unrecognized method, property, or field 'ReasonPhrase' for class 'matlab.net.http.StatusCode'.
%[text] 
%[text] Error in sageFetchObj.Timeseries (line 205)
%[text]         error("HTTP request failed: %d %s", resp.StatusCode, char(resp.StatusCode.ReasonPhrase));
%[text]         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%[text] ```
%[text] 
%[text] it means there are no data available that fit your criteria.
%%
%[text] ## Plot your data (example uses miniseed syntax)
%[text] The exact syntax for your plot will depend on if you accessed the data from a miniseed or sac format.
amplitude = S(1).d; % your signal amplitude
T0 = S(1).t; % start time, T0
dt = 0.025; % sampling rate
Name = S(1).ChannelFullName; % desriptive name for your station or channel
RecordStart = S(1).RecordStartTimeISO; % description of when/what date and time your signal is from

%--------------------------------------------------------------%
figure
plot(amplitude)
ylabel('Amplitude')
xlabel('Index')

% Change the x-axis to the appropriate time
t =  datetime(T0,'ConvertFrom','datenum','Format','yyyy-MM-dd HH:mm:ss.SSSSSS');

figure
plot(t,amplitude)
ylabel('Amplitude')
title(strcat(Name, RecordStart))
%[text] 
%[text] If you have multiple traces in your file, you can plot them on adjacent plots by using either tiledlayout or stackedplot. 
% another plot option
figure
h = tiledlayout(3,1);
nexttile
plot(S(1).d);
nexttile
plot(S(5).d)
nexttile
plot(S(17).d)

title(h,'Multiple Plots')
%%
%[text] ## Signal Processing and Analysis (examples uses miniseed syntax)
% Putting all of the traces into one, long file just for this demonstration
% Set up empty time (T) and amplitude (A) variables
T = []; 
A = [];

for i=1:length(S)
    T = [T; (S(i).t)];
    A = [A; S(i).d];    
end

T = datetime(T,'ConvertFrom','datenum','Format','yyyy-MM-dd HH:mm:ss.SSSSSS');

figure
plot(T,A)
ylabel('Amplitude')
title(strcat(Name, ', date:', RecordStart))

% Convert row times to elapsed duration since first sample
dur = T - T(1); % subtract the start time (correct for start time and shift the signal left)
dur1 = seconds(0:dt:(height(T)-1)*dt)';

SignalData = timetable(dur,A);
SignalData1 = timetable(dur1,A);
%%
%[text] Now you can use the "Signal Analyzer" App to process the signal!
signalAnalyzer

%[appendix]{"version":"1.0"}
%---
%[metadata:styles]
%   data: {"heading1":{"color":"#268cdd"},"heading2":{"color":"#edb120"},"referenceBackgroundColor":"#262626"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[control:editfield:084d]
%   data: {"defaultValue":"'IU'","label":"network","run":"Section","valueType":"Char"}
%---
%[control:editfield:4690]
%   data: {"defaultValue":"'PET'","label":"station","run":"Section","valueType":"Char"}
%---
%[control:editfield:8fa6]
%   data: {"defaultValue":"'00'","label":"location","run":"Section","valueType":"Char"}
%---
%[control:editfield:8561]
%   data: {"defaultValue":"'BHZ'","label":"channel","run":"Section","valueType":"Char"}
%---
%[control:checkbox:1a16]
%   data: {"defaultValue":false,"label":"saveFiles","run":"Nothing"}
%---
%[control:dropdown:0061]
%   data: {"defaultValue":"'sac'","itemLabels":["'sac'","'miniseed'"],"items":["'sac'","'miniseed'"],"label":"fileformat","run":"Section"}
%---
