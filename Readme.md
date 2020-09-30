# Toolbar class

Two classes to handle resizeable/responsive button toolbar.
When window is large, full size buttons with title are displayed. Button groups are separated with a vertical line.

If window is not large enough, based on priority and order, title is removed and displayed as tip.

If window is still not big enough, smaller icons are used, finally two buttons are set on top of each other.

The class support buttons, buttons with alternate action (arrow beside the button) and subforms, such as Search picker.

## Install
- copy content of Project/Sources/Classes into your Sources/Classes
- copy content of Documentation/Classes into your Documentation/Classes

## Usage
after Installation use 4D's explorer and select Toolbar or Toolbar_Button class to see documentation or read here:

[Toolbar Class documentation](Documentation/Classes/Toolbar.md)

[Toolbar_Button Class documentation](Documentation/Classes/Toolbar_Button.md)

## Example
Too see the behavior in action, download [Example](Example/Library.zip)
It is using the "Library" demo database from 4D v17, converted to v18 R3, exported to project, then adding the classes as explained above.
Finally added "small" buttons (duplicating existing 48x48 buttons and resize them to 24x24).

The "students" form was modified to use the toolbar buttons. Open, then resize the window to see the result:

Full size window:
![Full size window](https://github.com/ThomasMaul/Toolbar/blob/master/Documentation/Screenshots/VeryBig.png "Full Size")

Big window:
![Big window](https://github.com/ThomasMaul/Toolbar/blob/master/Documentation/Screenshots/Big.png "Big window")

Medium window:
![Medium window](https://github.com/ThomasMaul/Toolbar/blob/master/Documentation/Screenshots/Medium.png "Medium window")

Small window:
![Small window](https://github.com/ThomasMaul/Toolbar/blob/master/Documentation/Screenshots/Small.png "Small window")

Very small window:
![Very small window](https://github.com/ThomasMaul/Toolbar/blob/master/Documentation/Screenshots/VerySmall.png "Very small window")

## Note
- require 4D v18 R3 or newer
- require your application to be in project mode
