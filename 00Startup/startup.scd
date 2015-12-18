/*
Place this file in the folder whose path is indicated by: 

Platform.userAppSupportDir

This will execute the file each time that you recompile the library. 


Altenatively, you can execute the lines below  manually. 

*/

/* 
NOTE:
If you get an error message regarding server sample rate not matching,
and not being able to boot, and if the sampling rate is 48000. 
then uncomment the following line: 

*/

// Server.default.options.sampleRate = 48000;

// NOTE 2: Keep the line above where it is. Do not move it below the boot command.

(
Server.default.outDevice = 2;
Server.default.options.numOutputBusChannels = 22;
Server.default.boot;
{ FreqScope () }.defer (0.1); // for versions < 3.7 defer is needed. In 3.7 this is fixed.
Server.default.scope.window.bounds = Rect (0, 350, 300, 300)
);

