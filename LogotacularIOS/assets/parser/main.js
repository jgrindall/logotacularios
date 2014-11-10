
LG.stop = function(){
	alert("stopping!");
	try{
		LG.worker.terminate();
	}
	catch(e){
		
	}
	LG.active = false;
};

LG.onError = function(e){
	var s = JSON.stringify({"error":e});
	if(window.iosCallback){
		iosCallback(s);
	}
	else{
		console.log("to ios "+s);
	}
};

LG.onMessage = function(msg){
	var s = JSON.stringify(msg);
	if(window.iosCallback){
		iosCallback(s);
	}
	else{
		console.log("to ios "+s);
	}
};

LG.getTree = function(logo){
	var tree;
	try {
		tree = LG.logoParser.parse(logo);
	}
	catch(e){
		LG.onMessage({"syntaxerror":e});
		return;
	}
	LG.onMessage({"syntaxerror":null});
	return tree;
};

LG.draw = function(logo){
	var tree;
	tree = LG.getTree(logo);
	if(tree){
		try{
			LG.active = true;
			LG.process(tree);
		}
		catch(e){
			LG.onMessage({"error":e});
		}
	}
};

LG.process = function(tree){
	LG.worker = new Worker("visit.js");
	LG.worker.onmessage =	this.onMessage.bind(this);
	LG.worker.onerror =		this.onError.bind(this);
	LG.worker.postMessage(  {"type":"tree", "tree":tree}  );
};

