
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
	iosCallback({"error":e});
};

LG.onMessage = function(msg){
	iosCallback(JSON.stringify(msg));
};

LG.getTree = function(s){
	var tree;
	try {
		tree = LG.logoParser.parse(s);
	}
	catch(e){
		LG.onMessage({"error":e});
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
};

LG.process = function(tree){
	LG.worker = new Worker("visit.js");
	LG.worker.onmessage =		this.onMessage.bind(this);
	LG.worker.onerror =		this.onError.bind(this);
	LG.worker.postMessage(  {"type":"tree", "tree":tree}  );
};

