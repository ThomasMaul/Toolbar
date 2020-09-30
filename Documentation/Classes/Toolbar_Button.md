<!-- Internal class, needed by Toolbar class -->
## Toolbar_Button

Create a new instance for each button you need in your toolbar.
In the constructor new.() you can pass almost all properties of a button.

### mytype
0 for button, 1 for subform/container. 
Not a standard 4D object property
### title
text for button
### name
object name, useable in event method (use OBJECT Get name(Object current))
### prio
Priority, which button to reduce first. Smaller numbers reduced last, highest first
Not a standard 4D object property
### group (text)
When group changes, buttons are separated with a vertical line
Not a standard 4D object property
### icon
relative 4D path to 32x32 png of type 4 state button, such as /RESOURCES/Images/ButtonNew32.png
### icon16 
relative 4D path to 16x16 png of type 4 state button, such as /RESOURCES/Images/ButtonNew16.png
Not a standard 4D object property
### tooltip
text for tip. If not passed it uses button title
### width
Width of button/subform. Default 70
### height 
for button or subform. For button by default 55. Automatically reduced to 30 for small buttons
### popupPlacement
empty or "separated". Separated adds an arrow to support right click options. When used buttons usually needs more width, don't forget to add event "onAlternateClick"
### events (collection)
events when to call the assigned method. You will need "onClick" in almost all cases, for right click also "onAlternateClick"
### style
CSS style name
### method
method to call for event. Pass the name of a project method
### subform
only when type=1. Name of subform to display, such as "SearchPicker"
### dataSource
only when type=1/subform. Assign a data source, for SearchPicker it must be a process text variable, Form.xxx will not work
### dataSourceTypeHint
type for dataSource. For SearchPicker pass "text"


You should not need to call any of these methods yourself for using the Toolbar.
Only use them, if you need to enhance/rewrite functionality.

### check
called when adding a button to a toolbar to check assign default values for missing attributes

### render
render an object in the Toolbar, either a button or a subform, returns the object to be used inside a form

### renderButton
render a button, returns the object to be used inside a form

### renderSubform
render a button, returns the object to be used inside a form

### setStatus
changes the display status, such as from big to small