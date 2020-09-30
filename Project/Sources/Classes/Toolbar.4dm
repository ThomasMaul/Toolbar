Class constructor
	This:C1470.buttons:=New collection:C1472
	This:C1470.subformName:=""
	
	
Function add
	var $1 : cs:C1710.Toolbar_Button
	// add a button instance to the toolbar
	
	$1.check()
	If ($1.order=0)
		$1.order:=This:C1470.buttons.length
	End if 
	This:C1470.buttons.push($1)
	
Function getSubform
	var $0 : Object
	var $1 : Text
	// return the button bar as a subform to be embedded. $1 = name of subform area
	
	$buttondistance:=10
	$groupdistance:=5  // also in curWidth
	$y_start:=2
	$y_smallbuttondistance:=20
	
	If (This:C1470.buttons.length>0)
		If (String:C10(This:C1470.subformName)="")
			ASSERT:C1129($1#"";"Subform Object name must not be empty")
			This:C1470.subformName:=$1
		End if 
		
		OBJECT GET COORDINATES:C663(*;This:C1470.subformName;$left;$top;$right;$bottom)
		$width:=$right-$left
		$curWidth:=This:C1470._buttonsCurWidth()
		
		Case of 
			: ($curWidth<$width)  // we have more size, maybe we can grow something?
				This:C1470._enlargeWidthTo($width;$curWidth)
				
			: ($curWidth>$width)  // oops, smaller, we need to shrink
				This:C1470._reduceWidthTo($width;$curWidth)
		End case 
		
		$page:=New object:C1471()
		$x:=$buttondistance
		$y:=$y_start
		
		$buttons:=This:C1470.buttons.orderBy("order asc")
		$curGroup:=""
		$lastbuttonsmall:=False:C215
		$lastbuttonwidth:=0
		For each ($button;$buttons)
			// add vertical bar if new group
			$newgroup:=String:C10($button.group)
			If (($newgroup#"") & ($curGroup#"") & ($curGroup#$newgroup))
				$line:=New object:C1471("type";"line";"top";1;"left";$x-5;"height";90;"stroke";"#A8A8A8")
				$page[$newgroup]:=$line
				$x:=$x+$groupdistance
				$lastbuttonsmall:=False:C215
			End if 
			$curGroup:=$newgroup
			
			If (($button.status=2) & ($lastbuttonsmall))
				$x:=$x-$lastbuttonwidth
				$page[$button.name]:=$button.render($x;$y+$y_smallbuttondistance;->$lastbuttonsmall)
				$lastbuttonsmall:=False:C215
			Else 
				$page[$button.name]:=$button.render($x;$y;->$lastbuttonsmall)
			End if 
			
			$x:=$x+Num:C11($button.curWidth)+$buttondistance
			$lastbuttonwidth:=Num:C11($button.curWidth)+$buttondistance
		End for each 
		
		This:C1470.maxWidth:=$x
		
		// "method";"Toolbar_FormMethod";
		$0:=New object:C1471("windowSizingX";"variable";"windowSizingY";"variable";"rightMargin";1;"bottomMargin";1;"windowMinWidth";0;"windowMinHeight";0;\
			"windowMaxWidth";32767;"windowMaxHeight";32767;\
			"events";New collection:C1472("onResize";"onLoad");\
			"pages";New collection:C1472(Null:C1517;New object:C1471("objects";$page));"destination";"detailScreen")
		
		
	Else 
		$0:=New object:C1471
	End if 
	
Function resize
	// respond do a resize of the displayed area, recalculates the toolbar and assign it
	
	var $sub : Object
	OBJECT GET COORDINATES:C663(*;This:C1470.subformName;$left;$top;$right;$bottom)
	$x:=$right-$left
	If (Num:C11(This:C1470.maxWidth)#0)
		//If ((($x+5)<This.maxWidth) | (($x-5)>This.maxWidth))
		// now redraw buttons if not enough space
		$sub:=This:C1470.getSubform()
		$hash:=This:C1470._getHash($sub)
		If (String:C10(This:C1470.lastHash)#$hash)
			This:C1470.lastHash:=$hash
			OBJECT SET SUBFORM:C1138(*;String:C10(This:C1470.subformName);$sub)
		End if 
		//End if 
	End if 
	
Function _getHash
	var $0;$json : Text
	var $1 : Object
	// internal. Create a hash for the subform rendering, to check if content was changed (because resize) and new display is needed
	
	$json:=JSON Stringify:C1217($1)
	$0:=Generate digest:C1147($json;MD5 digest:K66:1)
	
Function _buttonsCurWidth
	var $0 : Integer
	// internal. Calculates the current width of a button
	
	$groupdistance:=10
	$totalWidth:=0
	$lastgroup:=""
	$groupcounter:=0
	For each ($button;This:C1470.buttons)
		$totalWidth:=$totalWidth+$button.widths[$button.status]
		If ($button.widths[$button.status]#0)
			$totalWidth:=$totalWidth+10  // distance between buttons
		End if 
		If ($lastgroup#String:C10($button.group))
			$lastgroup:=String:C10($button.group)
			$groupcounter:=$groupcounter+1
		End if 
	End for each 
	$0:=$totalWidth+($groupcounter*$groupdistance)
	
Function _reduceWidthTo
	var $1;$2 : Integer
	// internal. Try to reduce the width of a button to the requested size
	
	$requestedWidth:=$1
	$currentWidth:=$2
	$safetycounter:=1000
	
	// first remove title
	While (($currentWidth>=$requestedWidth) & ($safetycounter>0))
		// start with lowestest priority from right
		$bigbuttons:=This:C1470.buttons.query("status=0 and title # ''").orderBy("Prio desc, order desc")
		If ($bigbuttons.length=0)
			$safetycounter:=0
		Else 
			$bigbuttons[0].setStatus(1)
		End if 
		// check result
		$currentWidth:=This:C1470._buttonsCurWidth()
		$safetycounter:=$safetycounter-1  // gave up, avoid deadlock
	End while 
	
	// next try to use 16 icons
	$safetycounter:=1000
	While (($currentWidth>=$requestedWidth) & ($safetycounter>0))
		// start with lowestest priority from right
		$bigbuttons:=This:C1470.buttons.query("status<2 and icon16 # ''").orderBy("Prio desc, order desc")
		If ($bigbuttons.length=0)
			$safetycounter:=0
		Else 
			$bigbuttons[0].setStatus(2)
		End if 
		// check result
		$currentWidth:=This:C1470._buttonsCurWidth()
		$safetycounter:=$safetycounter-1  // gave up, avoid deadlock
	End while 
	
Function _enlargeWidthTo
	var $1;$2 : Integer
	// internal. Try to enlarge the button up to requested width
	
	$requestedWidth:=$1
	$currentWidth:=$2
	$safetycounter:=1000
	
	
	// try larger icon without title
	While (($currentWidth<=$requestedWidth) & ($safetycounter>0))
		// start with highest priority from left
		$smallbuttons:=This:C1470.buttons.query("status>=2").orderBy("Prio asc, order asc")
		If ($smallbuttons.length=0)
			$safetycounter:=0
		Else 
			$smallbuttons[0].setStatus(1)  // make it big
		End if 
		
		// check result
		$currentWidth:=This:C1470._buttonsCurWidth()
		// double check
		If ($currentWidth>$requestedWidth)
			If ($smallbuttons.length#0)
				$smallbuttons[0].setStatus(2)  // make it small again...
			End if 
		End if 
		
		$safetycounter:=$safetycounter-1  // gave up, avoid deadlock
	End while 
	
	$safetycounter:=1000
	// try to add title
	While (($currentWidth<=$requestedWidth) & ($safetycounter>0))
		// start with highest priority from left
		$smallbuttons:=This:C1470.buttons.query("status=1").orderBy("Prio asc, order asc")
		If ($smallbuttons.length=0)
			$safetycounter:=0
		Else 
			$smallbuttons[0].setStatus(0)  // make it big
		End if 
		
		// check result
		$currentWidth:=This:C1470._buttonsCurWidth()
		// double check
		If ($currentWidth>$requestedWidth)
			If ($smallbuttons.length#0)
				$smallbuttons[0].setStatus(1)  // make it small again...
			End if 
		End if 
		
		$safetycounter:=$safetycounter-1  // gave up, avoid deadlock
	End while 
	