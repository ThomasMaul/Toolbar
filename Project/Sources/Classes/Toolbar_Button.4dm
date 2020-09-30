Class constructor
	var $1 : Object
	If ($1#Null:C1517)
		For each ($prop;$1)
			This:C1470[$prop]:=$1[$prop]
		End for each 
	End if 
	
Function check
	// call after creating a new instance to fill all attributes with default values
	
	If (This:C1470.mytype=Null:C1517)  // 0 = button, 1 = subform/container
		This:C1470.mytype:=0
	End if 
	If (This:C1470.title=Null:C1517)
		This:C1470.title:=""
	End if 
	If (This:C1470.icon=Null:C1517)
		This:C1470.icon:=""
	End if 
	If (This:C1470.action=Null:C1517)
		This:C1470.action:=New object:C1471
	End if 
	If (This:C1470.prio=Null:C1517)
		This:C1470.prio:=0
	End if 
	If (This:C1470.order=Null:C1517)
		This:C1470.order:=0
	End if 
	If (This:C1470.name=Null:C1517)
		This:C1470.name:=Generate UUID:C1066
	End if 
	If (This:C1470.mytype=Null:C1517)
		This:C1470.mytype:=0
	End if 
	
	This:C1470.status:=0  // 0 full size, 1 without title, 2 small icon without title, 3 shrink in group
	If (This:C1470.width=Null:C1517)
		This:C1470.width:=70
	End if 
	This:C1470.curWidth:=This:C1470.width
	If (This:C1470.mytype=0)
		If (This:C1470.icon="")
			$width2:=This:C1470.curWidth
		Else 
			If (String:C10(This:C1470.popupPlacement)#"")
				$width2:=50
			Else 
				$width2:=40
			End if 
		End if 
		If (String:C10(This:C1470.icon16)="")
			$width3:=$width2
		Else 
			If (String:C10(This:C1470.popupPlacement)="")
				$width3:=20
			Else 
				$width3:=35
			End if 
		End if 
		If (Num:C11(This:C1470.group)#0)
			$width4:=$width3
		Else 
			$width4:=40
		End if 
		If (Num:C11(This:C1470.prio)=9)
			$width5:=0
		Else 
			$width5:=$width3
		End if 
		This:C1470.widths:=New collection:C1472(This:C1470.width;$width2;$width3;$width4;$width5)
	Else 
		This:C1470.widths:=New collection:C1472(This:C1470.width;This:C1470.width;This:C1470.width;This:C1470.width;This:C1470.width)
	End if 
	
	
Function setStatus
	var $1 : Integer
	// change the status of a button, // 0 full size, 1 without title, 2 small icon without title
	
	This:C1470.status:=$1
	This:C1470.curWidth:=This:C1470.widths[This:C1470.status]
	Case of 
		: (This:C1470.status=1)  // no title
			If (String:C10(This:C1470.tooltip)="")
				This:C1470.tooltip:=This:C1470.title
			End if 
			
	End case 
	
Function render
	var $1;$2 : Integer
	var $3 : Pointer  // boolean, lastbuttonsmall
	var $0 : Object
	// render a button object (x; y; pointer to boolean last displayed size) -> object for json form
	
	Case of 
		: (This:C1470.mytype=0)
			$0:=This:C1470.renderButton($1;$2;$3)
		: (This:C1470.mytype=1)
			$0:=This:C1470.renderSubform($1;$2;$3)
		Else 
			$0:=New object:C1471
	End case 
	
	
Function renderSubform
	var $1;$2 : Integer
	var $3 : Pointer  // boolean, lastbuttonsmall
	var $0 : Object
	// render a subform, called by render()
	
	$x:=$1
	$y:=$2
	$name:=String:C10(This:C1470.name)
	ASSERT:C1129($page[$name]=Null:C1517;"Button name "+$name+" not unique")
	$buttonwidth:=Num:C11(This:C1470.curWidth)
	$buttonobject:=New object:C1471("height";This:C1470.height;"width";$buttonwidth;"left";$x;"top";$y;"type";"subform")
	If (This:C1470.method#Null:C1517)
		$buttonobject.method:=This:C1470.method
		If (This:C1470.events#Null:C1517)
			$buttonobject.events:=This:C1470.events
		Else 
			$buttonobject.events:=New collection:C1472("onLoad";"onDataChange")
		End if 
	End if 
	$buttonobject.dataSourceTypeHint:=This:C1470.dataSourceTypeHint
	$buttonobject.dataSource:=This:C1470.dataSource
	$buttonobject.detailForm:=This:C1470.subform
	$0:=$buttonobject
	
	
Function renderButton
	var $1;$2 : Integer
	var $3 : Pointer  // boolean, lastbuttonsmall
	var $0 : Object
	// render a button, called by render()
	
	$x:=$1
	$y:=$2
	
	$button:=This:C1470
	$name:=String:C10($button.name)
	ASSERT:C1129($page[$name]=Null:C1517;"Button name "+$name+" not unique")
	$buttonwidth:=Num:C11($button.curWidth)
	
	If (This:C1470.height=Null:C1517)
		$height:=65
	Else 
		$heigth:=This:C1470.height
	End if 
	If ($buttonwidth<30)
		$height:=30
	End if 
	$buttonobject:=New object:C1471("height";$height;"width";$buttonwidth;"left";$x;"top";$y;"type";"button";"style";"custom")
	If (($button.title#"") & ($button.status=0))
		$buttonobject.text:=$button.title
	End if 
	If (String:C10($button.class)#"")
		$buttonobject.class:=$button.class
	End if 
	If (String:C10($button.style)#"")
		$buttonobject.style:=$button.style
	End if 
	If (String:C10($button.popupPlacement)#"")
		$buttonobject.popupPlacement:=$button.popupPlacement
	End if 
	If (String:C10($button.icon)#"")
		If ($button.status<=1)
			$buttonobject.icon:=$button.icon
		Else 
			$buttonobject.icon:=String:C10($button.icon16)
			$3->:=True:C214
		End if 
		$buttonobject.iconFrames:=4
	End if 
	If (String:C10($button.tooltip)#"")
		$buttonobject.tooltip:=$button.tooltip
	End if 
	If ($button.shortcut#Null:C1517)
		$buttonobject.shortcutAccel:=$button.shortcut.shortcutAccel
		$buttonobject.shortcutControl:=$button.shortcut.shortcutControl
		$buttonobject.shortcutShift:=$button.shortcut.shortcutShift
		$buttonobject.shortcutAlt:=$button.shortcut.shortcutAlt
		$buttonobject.shortcutKey:=$button.shortcut.shortcutKey
	End if 
	If ($button.method#Null:C1517)
		$buttonobject.method:=$button.method
		If ($button.events#Null:C1517)
			$buttonobject.events:=$button.events
		Else 
			$buttonobject.events:=New collection:C1472("onClick")
		End if 
	End if 
	
	$0:=$buttonobject
	