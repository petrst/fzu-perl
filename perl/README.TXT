	##########################################
	#    This is DOOMSDAY.PL v. 0.2 README   #
	#         Y2k-1 (C) Petr Sturc           #
	# This program is free software; you can #
	# redistribute it and/or modify it under # 
	# the same terms as Perl itself.         #
	##########################################


	1. What is doomsday.pl?
	It is simple,small script intended to help you to practise
	"Doomsday Rule".


	2. OK. And what is it "Doomsday Rule"?
	It is clever and fast algorithm for calculation day-of-week
	for any given datum. It is simple enough to do all
	calculations in your heads. More info you find on:
	http://www.math.mtu.edu/~swgraham/Pub/Doomsday/DoomsdayIntro.html

	3.What I need to run it?
	You need 1 computer (at least :-) and Perl interpreter.  This
	can you download from http://www.perl.com or if you have
	Micro$oft Windows go to http://www.activestate.com.  If you
	want Tk version you should have Tk library. You will find it
	on the same sites as Perl. There is possible to compile also
	binary version, but it will have 2MB. But you can ask me.

	4. What are console and Tk versions?
	"Console" means version for character (non-graphics) consoles
	or terminals. It communicate with user through command line
	interface. Tk use famous GUI (graphics user interface) to
	create small windows through which it communicate with user.
	Tk version works either in X-Windows or on Win32 platforms.


	5. How to start?
	At first check, whether path to perl interpreter in first line
	of script is correct. This is necessary only for UNIX
	platforms. Actual path to your perl you can find typing
	command "which perl". At second set doomsday.pl to be executable
	("chmod u+x doomsday.pl"). Then simply run doomsday.pl.
	Windows does not have #! mechanism and you have to call "perl
	doomsday.pl". I prefer to start it from "StartUp folder" in
	Windows or from .bashrc (or .tcshrc, .cshrc,..) on UNIX.


	6. How to type answer?
	Simply type the English name of day, like Monday, Tuesday...
	First letter is UPPERCASE. In last version three-letters
	abbreviations (Mon,Tue,..) are allowed. Also Czech name and
	its two-letters abbreviations (Pondeli=Po,..) were added.


        7. How can I choose range of centuries which will be practised?
	Now only way is to change source code. Look for lines
	containing "$from=<NUMBER>;" and "$to=<NUMBER>;". This will be
	facilitated in next version.


	8. It doesn't work!
	Send me a message to <sturc@fzu.cz>


        9. Why is here so many gramatical mistakes?
	English is not ma native tongue. Help me.

	Petr Sturc, March 18 Y2K-1
