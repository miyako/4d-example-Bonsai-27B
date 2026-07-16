Use (Storage:C1525)
	Storage:C1525.llama:=New shared object:C1526("port"; 8181)
End use 

var $llama : cs:C1710.llama.llama

var $homeFolder : 4D:C1709.Folder
$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".GGUF")
var $file : 4D:C1709.File
var $URL : Text
var $port : Integer
var $huggingface : cs:C1710.event.huggingface
var $huggingfaces : cs:C1710.event.huggingfaces

var $event : cs:C1710.event.event
$event:=cs:C1710.event.event.new()

$event.onError:=Formula:C1597(OnModelDownloaded)
$event.onSuccess:=Formula:C1597(OnModelDownloaded)
$event.onData:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":"+String:C10((This:C1470.range.end/This:C1470.range.length)*100; "###.00%")))
$event.onResponse:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":download complete"))
$event.onTerminate:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; (["process"; $1.pid; "terminated!"].join(" "))))

$port:=Storage:C1525.llama.port

var $folder : 4D:C1709.Folder
var $path; $mmproj; $assistant : Text
var $n_gpu_layers; $threads; $batches; $ubatch_size; $batch_size; $max_position_embeddings : Integer

$folder:=$homeFolder.folder("Bonsai")

$n_gpu_layers:=99
$threads:=6
$batches:=1
$ubatch_size:=512
$batch_size:=2048
$max_position_embeddings:=8192

var $logFile : 4D:C1709.File
$logFile:=$folder.file("llama.log")
$folder.create()
If (Not:C34($logFile.exists))
	$logFile.setContent(4D:C1709.Blob.new())
End if 

var $options : Object

Case of 
	: (False:C215)
		
		$path:="Ternary-Bonsai-8B-Q2_0.gguf"
		$URL:="prism-ml/Ternary-Bonsai-8B-gguf"
		
		$options:={\
			ctx_size: $max_position_embeddings*$batches; \
			batch_size: $batch_size; \
			ubatch_size: $ubatch_size; \
			parallel: $batches; \
			threads: $threads; \
			threads_batch: $threads; \
			threads_http: 2; \
			temp: 1; \
			top_k: 64; \
			top_p: 0.95; \
			n_gpu_layers: $n_gpu_layers; \
			log_disable: False:C215; \
			log_file: $logFile; \
			jinja: True:C214}
		
	: (True:C214)
		
		$path:="Bonsai-27B-Q1_0.gguf"
		$URL:="prism-ml/Bonsai-27B-gguf"
		$mmproj:="Bonsai-27B-mmproj-Q8_0.gguf"
		$assistant:="Bonsai-27B-dspark-Q4_1.gguf"
		
		$options:={\
			ctx_size: $max_position_embeddings*$batches; \
			batch_size: $batch_size; \
			ubatch_size: $ubatch_size; \
			parallel: $batches; \
			threads: $threads; \
			threads_batch: $threads; \
			threads_http: 2; \
			temp: 1; \
			top_k: 64; \
			top_p: 0.95; \
			mmproj: $folder.file($mmproj); \
			spec_type: "draft-mtp"; \
			spec_draft_n_max: 3; \
			spec_draft_model: $folder.file($assistant); \
			n_gpu_layers: $n_gpu_layers; \
			log_disable: False:C215; \
			log_file: $logFile; \
			jinja: True:C214}
		
End case 

$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; [$path; $assistant; $mmproj])
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$llama:=cs:C1710.llama.llama.new($port; $huggingfaces; $homeFolder; $options; $event)