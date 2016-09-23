
LG.stop = function(){
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
	var s;
	if(msg.data){
		s = JSON.stringify(msg.data);
	}
	else{
		s = JSON.stringify(msg);
	}
	if(window.iosCallback){
		iosCallback(s);
	}
	else{
		console.log("to ios "+s);
	}
};

LG.preProcess = function(logo){
	logo = logo.replace(/;[^\n\r]+\n/g, "");
	logo = logo.replace(/#[^\n\r]+\n/g, "");
	logo = logo.replace(/\/\/[^\n\r]+\n/g, "");
	return logo;
};

LG.getTree = function(logo){
	var tree;
	logo = LG.preProcess(logo);
	try {
		tree = LG.logoParser.parse(logo);
	}
	catch(e){
		LG.onMessage({"syntaxerror":e});
		return;
	}
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
	LG.onMessage({"type":"end"});
};

LG.process = function(tree){
	LG.cleanup();
	LG.worker = new Worker("visit.js");
	LG.worker.onmessage =	this.onMessage.bind(this);
	LG.worker.onerror =		this.onError.bind(this);
	LG.worker.postMessage(  {"type":"tree", "tree":tree}  );
};

LG.cleanup = function(){
	if(LG.worker){
		try{
			LG.worker.onmessage =	null;
			LG.worker.onerror =		null;
			LG.worker.terminate();
			LG.worker = null;
		}
		catch(e){
			
		}
	}
};

