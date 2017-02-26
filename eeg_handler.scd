/*
	* by Marinos Koutsomichalis (me@marinoskoutsomichalis.com)
	* Heraklion, 10.2016
	* part of Inhibition SuperCollider code
*/

~eeg_handler = Environment.new; 
~eeg_handler.use{
	~get_eeg = { // get and analyse eeg signal
		var features = Dictionary[(\pitch->0),(\centroid->0),(\complexity->0),(\weightedspectralmaximum->0)];
		var file,offset,data,dcshift;
		// clean previous results and get new data
		"rm *wav".systemCmd;
		"reading eeg data over spi..".postln;
		"./read_eeg temp_eeg.wav 1 2".systemCmd;
		// calculate DC OFFSET
		"sox temp_eeg.wav -n stats 2> temp_eeg.stats".systemCmd;
		file = File("temp_eeg.stats","r");
		offset = file.getLine(1024);
		dcshift = offset[offset.find("0")..].asFloat * (-1);
		file.close;
		// remove dc, filter and create fades 
		("sox temp_eeg.wav eeg.wav" ++" lowpass 25 fade 0.1 0 0.1 dcshift "++dcshift).systemCmd;
		// analyse
		~analysis[\run].value("eeg.wav").wait;
		data = ~analysis[\getResults].value().postln;
		features[\pitch] = data[0][0];
		features[\centroid] = data[1][0];
		features[\complexity] = data[2][0];
		features[\weightedspectralmaximum] = data[3][0];
		// clean temporaries
		"rm temp*".unixCmd;
		features; // return features
	};
};
