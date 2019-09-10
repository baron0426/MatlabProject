function FREQ_INFO = musicAnalyze(app, file)
[music, fs] = audioread(file);
sizee = length(music);
[yupper,ylower] = envelope(music,floor(fs/8),'peak'); %the order of FIR is an experience number
axis_t = linspace(0,(sizee-1)/fs,sizee);
env = yupper - ylower;
plot(axis_t, yupper-ylower);
[~, loc] = findpeaks(env);
loc2 = [0 loc' sizee];
loc2size = length(loc2);
app.setStart();
FREQ_INFO = zeros(loc2size-1,20);
for k = 1:1:loc2size-1
   while 1
       if(app.decision==2)
            dist = loc2(k+1) - loc2(k);
            start = loc2(k)+1 + 0.3*dist;
            start = floor(start);
            ending = loc2(k+1) - 0.3*dist;
            ending = floor(ending);
            sample = music(start:ending);
            out = findFreq(sample, fs);
       elseif(app.decision == 1)
            FREQ_INFO(k,1:min(20,length(out))) = out(1:min(20,length(out)));
            break;
       elseif(app.decision == 0)
            break;
       end
       uiwait(app.UIFigure);
    end
    app.decision = 2;

end
FREQ_INFO( ~any(FREQ_INFO,2), : ) = [];
app.setOK();
end