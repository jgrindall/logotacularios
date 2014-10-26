
LG.stop = function(){
	//this.worker.terminate();
};

LG.onError = function(e){
	window.alert("onError " + e);
	iosCallback("onError " + e);
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
		alert("getTree error " + e.message);
	}
	return tree;
};

LG.draw = function(logo){
	var tree;
	tree = LG.getTree(logo);
	if(tree){
		try{
			LG.process(tree);
		}
		catch(e){
			alert("error2 " + e);
		}
	}
	return tree;
};

LG.process = function(tree){
	var worker = new Worker("visit.js");
	worker.onmessage =		this.onMessage.bind(this);
	worker.onerror =		this.onError.bind(this);
	worker.postMessage(  {"type":"tree", "tree":tree}  );
};

