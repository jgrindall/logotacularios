
LG.Stack = function(){
	this.s = [ ];
};


LG.Stack.prototype.push = function(n){
	if(this.s.length < LG.Stack.MAX_STACK_SIZE){
		this.s.push(n);
	}
	else if(n > LG.Stack.MAX_FLOAT_SIZE){
		throw new Error("Overflow");
	}
	else{
		throw new Error("Stack size exceeded");
	}
};

LG.Stack.prototype.pop = function(){
	if(this.s.length === 0){
		throw new Error("Stack size empty");
	}
	else{
		var r = this.s.pop();
		return r;
	}
};

LG.Stack.prototype.describe = function(){
	return this.s.toString();
};

LG.Stack.MAX_STACK_SIZE = 1024;
LG.Stack.MAX_FLOAT_SIZE = 100000;