
LG.SymTable = function(){
	this.blocks = [ ];
	this.functions = {};
};

LG.SymTable.prototype.getCurrentBlock = function(){
	return this.blocks[this.blocks.length - 1];
}

LG.SymTable.prototype.enterBlock = function(){
	var block = { };
	this.blocks.push(block);
};

LG.SymTable.prototype.exitBlock = function(){
	this.blocks.pop();
};

LG.SymTable.prototype.get = function(name){
	var block;
	for(var i = this.blocks.length - 1; i>=0; i--){
		block = this.blocks[i];
		if(block[name]){
			return block[name];
			break;
		}
	}
	return null;
};

LG.SymTable.prototype.add = function(name, val){
	this.getCurrentBlock()[name] = val;
};

LG.SymTable.prototype.addFunction = function(name, argsNode, statementsNode){
	this.functions[name] = {"argsNode":argsNode, "statementsNode":statementsNode};
};

LG.SymTable.prototype.getFunction = function(name){
	return this.functions[name];
};

