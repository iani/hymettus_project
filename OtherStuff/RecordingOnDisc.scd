
//: Run this to prepare a new file for recording: 

Server.default.prepareForRecord;

//: Then run this to start the recording

Server.default.record;

//: Then run this to stop recording (DO NOT FORGET TO STOP RECORDING - YOUR DISC MAY BECOME FULL).

Server.default.stopRecording;

//: The file where the recording goes is found in: 

thisProcess.platform.recordingsDir;
