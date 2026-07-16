If (Form event code:C388=On Clicked:K2:4)
	
	var $userPrompt : Text
	$userPrompt:=OBJECT Get name:C1087(Object with focus:K67:3)="User Prompt" ? Get edited text:C655 : Form:C1466.userPrompt
	
	//var $messages:=[]
	//$messages.push({role: "user"; content: $userPrompt})
	
	Form:C1466.continueConversation($userPrompt)
	
End if 