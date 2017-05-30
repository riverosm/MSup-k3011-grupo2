pkg load control
pkg load signal

gs = tf([1 2], [1 2 3])
zeros = roots(gs.num{1})
polos = roots(gs.den{1})
Zer= zero (gs)
Pol=pole(gs)
[Zer,Pol,k]=tf2zp([5 2],[1 4 20])


#A=zp(Zer,Pol,k);
#sysout (A)

#pzmap(gs)
           
% create figure and panel on it
#f = figure;
% create a button group
#gp = uibuttongroup (f, "Position", [ 0 0.5 1 1])
% create a buttons in the group
#b1 = uicontrol (gp, "style", "radiobutton", ...
#                "string", "Choice 1", ...
#                "Position", [ 10 150 100 50 ]);
#b2 = uicontrol (gp, "style", "radiobutton", ...
#                "string", "Choice 2", ...
#                "Position", [ 10 50 100 30 ]);
#% create a button not in the group
#b3 = uicontrol (f, "style", "radiobutton", ...
#                "string", "Not in the group", ...
#                "Position", [ 10 50 100 50 ]);
                
#e1 = uicontrol (f, "style", "edit", "string", "editable text", "position",[10 60 300 40]);
                
#btn = questdlg ("Close Octave?", "Some fancy title", "Yes", "No", "No");
#if (strcmp (btn, "Yes"))
#  exit ();
#endif


% create an empty dialog window titled 'Dialog Example'
h = dialog ("name", "Dialog Example");

e1 = uicontrol (h, "style", "edit", "string", "editable text", "position",[10 60 300 40]);

e2 = uicontrol (h, "style", "listbox", "string", "editable text", "position",[40 80 300 40]);

% create a button (default style)
b = uicontrol (h, "string", "OK", "position",[10 10 100 40], "callback","delete(gcf)");

% wait for dialog to resume or close
uiwait (h);