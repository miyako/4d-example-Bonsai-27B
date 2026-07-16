Class extends _Agent

Class constructor($resultObjectName : Text; $startObjectName : Text; $continueObjectName : Text; $promptObjectName : Text)
	
	Super:C1705("http://127.0.0.1:"+String:C10(Storage:C1525.llama.port)+"/v1"; $resultObjectName; $startObjectName; $continueObjectName; $promptObjectName)