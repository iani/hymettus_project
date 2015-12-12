/*
Place this file in the folder whose path is indicated by: 

Platform.userAppSupportDir

This will execute the file each time that you recompile the library. 


Altenatively, you can execute the lines below  manually. 

*/

(
Server.default.boot;
FreqScope ();
Server.default.scope.window.bounds = Rect (0, 350, 300, 300)
);

