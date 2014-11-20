self.LG = {};

importScripts("stack.js");
importScripts("symtable.js");

var stack = new LG.Stack();
var symTable = new LG.SymTable();

self.addEventListener('message', function(msg) {
	if(msg.data.type === "tree"){
		visitNode(msg.data.tree);
		stack.clear();
		symTable.clear();
		postMessage({"type":"end"});
	}
}, false);

function visitchildren(node){
	// a general node with children
	var ch = node.children;
	var len = ch.length;
	for(var i = 0; i < len; i++){
		visitNode(ch[i]);
	}
}

function visitstart(node){
	symTable.enterBlock();
	visitchildren(node);
	symTable.exitBlock();
}

function visitinsidestmt(node){
	visitchildren(node);
}
function visitmakestmt(node){
	var ch = node.children;
	var name = ch[0].name;
	visitNode( ch[1] );
	symTable.add(name, stack.pop());
}

function visitfdstmt(node){
	visitchildren(node);
	var amount = stack.pop();
	self.postMessage({ "type":"command", "name":"fd", "amount":amount });
}

function visitpenupstmt(node){
	self.postMessage({ "type":"command", "name":"penup" });
}

function visitpendownstmt(node){
	self.postMessage({ "type":"command", "name":"pendown" });
}

function visitbgstmt(node){
	self.postMessage({ "type":"command", "name":"bg", "color":node.color });
}

function visitthickstmt(node){
	visitchildren(node);
	var thick = stack.pop();
	self.postMessage({ "type":"command", "name":"thick", "amount":thick });
}

function visitcolorstmt(node){
	self.postMessage({ "type":"command", "name":"color", "color":node.color });
}

function visitexpression(node){
	var num  = 0;
	visitchildren(node);
	var l = node.children.length;
	for(var i=0;i<l;i++){
		num += stack.pop();
	}
	stack.push(num);
}

function visitmultexpression(node){
	visitchildren(node);
	var num  = 1;
	var l = node.children.length;
	for(var i=0;i<l;i++){
		num *= stack.pop();
	}
	stack.push(num);
}

function visitdivterm(node){
	visitchildren(node);
	var num = stack.pop();
	if(num === 0){
		runTimeError("Division by zero");
	}
	else{
		stack.push(1/num);
	}
}

function visitrptstmt(node){
	var ch = node.children;
	visitNode( ch[0] );
	var num = stack.pop();
	if(num >= 0 && num === parseInt(num, 10)){
		for(var i = 1;i<=num; i++){
			visitNode(ch[1]);
		}
	}
	else{
		runTimeError("'"+num+"' is not a whole number of times to repeat");
	}
}

function visitunaryexpression(node){
	visitchildren(node);
}

function visitnumberexpression(node){
	visitchildren(node);
}

function visitnumber(node){
	stack.push(node.value);
}

function visitrtstmt(node){
	visitchildren(node);
	var amount = stack.pop();
	self.postMessage({"type":"command", "name":"rt", "amount":amount });
}

function visittimesordivterms(node){
	visitchildren(node);
	var ch = node.children;
	var l = ch.length;
	// now there are 'l' values on the stack.
	var num  = 1;
	for(var i = 0; i < l; i++){
		num *= stack.pop();
	}
	stack.push(num);
}

function visittimesordivterm(node){
	visitchildren(node);
}	

function visittimesterm(node){
	visitchildren(node);
}	

function visitplusorminus(node){
	visitchildren(node);
}

function visitoutsidefnlist(node){
	visitchildren(node);
}

function visitinsidefnlist(node){
	visitchildren(node);
}

function visitplusexpression(node){
	visitchildren(node);
}

function visitusevar(node){
	var num = symTable.get(node.name);
	if(!num){
		runTimeError("Variable '"+node.name+"' not found.");
	}
	else{
		stack.push(num);
	}
}

function visitminusexpression(node){
	visitchildren(node);
	var num = stack.pop();
	stack.push(-1*num);
}

function visitdefinefnstmt(node){
	var name = node.name;
	var argsNode = node.args;
	var statementsNode = node.stmts;
	symTable.addFunction(name, argsNode, statementsNode);
}

function visitnegate(node){
	visitchildren(node);
	var num = stack.pop();
	stack.push(-1*num);
}

function visitcallfnstmt(node){
	var name = node.name, args = "argument";
	var f = symTable.getFunction(name);
	if(f){
		var numSupplied, numArgs = 0;
		if(f.argsNode){
			numArgs = f.argsNode.children.length;
		}
		numSupplied = node.args.children.length;
		if(numArgs != numSupplied){
			if(numArgs == 0 || numArgs >= 2){
				args += "s"
			}
			runTimeError("Function '"+name+"' has "+numArgs+" "+args+", but you sent "+numSupplied);
		}
		else{
			symTable.enterBlock();
			visitchildren(node.args);
			executeFunction(f);
			symTable.exitBlock();
		}
	}
	else{
		runTimeError("Function '"+name+"' not found");
	}
}

function executeFunction(f){
	var i, vals, len, argNode, varName;
	vals = [ ];
	if(f.argsNode){
		len = f.argsNode.children.length;
		for(i = 0; i <= len - 1; i++){
			vals.push(stack.pop());
		}
	}
	for(i = 0; i <= len - 1; i++){
		argNode = f.argsNode.children[i];
		varName = argNode.name;
		symTable.add(varName, vals[len - 1 - i]);
	}
	visitNode(f.statementsNode);
}

function runTimeError(msg){
	throw new Error(msg);
	self.postMessage({"type":"error", "message":msg });
}

function visitNode(node){
	var t = node.type;
	if(t=="start"){
		visitstart(node);
	}
	else if(t=="insidestmt"){
		visitinsidestmt(node);
	}
	else if(t=="penupstmt"){
		visitpenupstmt(node);
	}
	else if(t=="pendownstmt"){
		visitpendownstmt(node);
	}
	else if(t == "definefnstmt"){
		visitdefinefnstmt(node);
	}
	else if(t == "callfnstmt"){
		visitcallfnstmt(node);
	}
	else if(t=="fdstmt"){
		visitfdstmt(node);
	}
	else if(t=="rtstmt"){
		visitrtstmt(node);
	}
	else if(t=="rptstmt"){
		visitrptstmt(node);
	}
	else if(t=="makestmt"){
		visitmakestmt(node);
	}
	else if(t=="expression"){
		visitexpression(node);
	}
	else if(t=="insidefnlist"){
		visitinsidefnlist(node);
	}
	else if(t=="outsidefnlist"){
		visitoutsidefnlist(node);
	}
	else if(t=="expression"){
		visitexpression(node);
	}
	else if(t=="multexpression"){
		visitmultexpression(node);
	}
	else if(t=="plusorminus"){
		visitplusorminus(node);
	}
	else if(t=="plusexpression"){
		visitplusexpression(node);
	}
	else if(t=="minusexpression"){
		visitminusexpression (node);
	}
	else if(t=="unaryexpression"){
		visitunaryexpression(node);
	}
	else if(t=="timesordivterms"){
		visittimesordivterms(node);
	}
	else if(t=="timesordivterm"){
		visittimesordivterm(node);
	}
	else if(t=="timesterm"){
		visittimesterm(node);
	}
	else if(t=="bgstmt"){
		visitbgstmt(node);
	}
	else if(t=="colorstmt"){
		visitcolorstmt(node);
	}
	else if(t=="plusexpression"){
		visitplusexpression(node);
	}
	else if(t=="multexpression"){
		visitmultexpression(node);
	}
	else if(t=="negate"){
		visitnegate(node);
	}
	else if(t=="numberexpression"){
		visitnumberexpression(node);
	}
	else if(t=="divterm"){
		visitdivterm(node);
	}
	else if(t=="number"){
		visitnumber(node);
	}
	else if(t=="number"){
		visitnumber(node);
	}
	else if(t=="thickstmt"){
		visitthickstmt(node);
	}
	else if(t=="usevar"){
		visitusevar(node);
	}
}

