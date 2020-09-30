<!-- Toolbar class - dynamical button toolbar used in a subform -->
## Toolbar class

Allows to create a button toolbar which automatically adapts the button size to avaiable form size, responding to resizing.
Buttons are normally be displayed large (32x32) with title, 
when window size is too small, title is removed (and added as tip if there is no tip assigned),
when window size still too small, displayed in small (16x16), if needed stacked (two small buttons above each other)

Buttons can be grouped, priority for resizing can be set. Lowest priority are resized first, else from right to left.

Buttons can have a separator icon (small arrow to respond to right click with a popup menu for more actions)

Additionally to buttons subforms are useable, such as the query widget.

The result is an object, directly useable in OBJECT SET SUBFORM.

## Usage

Create a new toolbar instance using .new().
I recommend to store it in a Form.property

Add your buttons using .add
When all buttons add, use 

```
$sub:=Form.toolbar.getSubform("toolbarname")
```

Finally assign it to your subform using
```
OBJECT SET SUBFORM(*;"toolbarname";$sub)
```

In on resize event of the main form call .resize()
```
: (Form event code=On Resize)
    Form.toolbar.resize()
```
    
### .add($buttoninstance)
Add a new button to your toolbar.

Example:
```
Form.toolbar:=cs.Toolbar.new() 
$button:=cs.Toolbar_Button.new(New object("name";"search";"group";"100";"prio";"1";
"title";"Search";
"icon";"/RESOURCES/Images/ButtonSearch32.png";
"icon16";"/RESOURCES/Images/ButtonSearch16.png";
"events";new collection("onClick");
"method";"handleMyButtonClick"
))
Form.toolbar.add($button)
$button:=cs.Toolbar_Button.new(New object("name";"new";"group";"100";"prio";"5";
"title";"New";
"icon";"/RESOURCES/Images/ButtonNew32.png";
"icon16";"/RESOURCES/Images/ButtonNew16.png";
"events";new collection("onClick");
"method";"handleMyButtonClick"
))
Form.toolbar.add($button)
```

### getSubform
When you have added all buttons, this call will return the build object directly useable in the subform

Example:
```
$sub:=Form.toolbar.getSubform("buttonsubform")
OBJECT SET SUBFORM(*;"buttonsubform";$sub)
```

### resize
call in on resize event to trigger redraw/responsive size

Example
```
: (Form event code=On Resize)
    Form.toolbar.resize()
```
