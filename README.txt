Author: Cosmin Pitu <pitu.cosmin@gmail.com>, http://bit.ly/dr1ku
        ("Use at your own risk. Please do not use it for evil. Feedback is welcome. Thank you.")
        [http://www.json.org/java/]
				
License: Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
         (http://creativecommons.org/licenses/by-nc-sa/3.0/)
				 
Purpose: Issues multiple 'telnet geo fix <lng, lat>' to the Android Emulator at a given interval.

Caveat: The emulator only parses given (Lng, Lat) (! not usual Lat, Lng !) Pairs to the first decimal (!), 
        so don't be surprised if the accuracy of your fixes is very lousy. Maybe a fix will be issued, who
        knows, check out the Android Bug Tracker, it's a known issue. 
				
Usage: Run 'ruby android_geo_fix_telnet <input file parameter> [cycle time, 15 seconds default]' from a shell.
       You can look within the source for more advanced tweaking such as setting the port and IP for the Emulator.