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

function visitarcstmt(node){
	visitchildren(node);
	var amount1 = stack.pop();
	var amount2 = stack.pop();
	self.postMessage({ "type":"command", "name":"arc", "angle":amount1, "radius":amount2 });
}

function visitbkstmt(node){
	visitchildren(node);
	var amount = stack.pop();
	self.postMessage({ "type":"command", "name":"fd", "amount": -1 * amount });
}

function visitpenupstmt(node){
	self.postMessage({ "type":"command", "name":"penup" });
}

function visithomestmt(node){
	self.postMessage({ "type":"command", "name":"home" });
}

function visitpendownstmt(node){
	self.postMessage({ "type":"command", "name":"pendown" });
}

function visitbgstmt(node){
	var colorIndex;
	if(node.color.type === 'colorname'){
		self.postMessage({ "type":"command", "name":"bg", "colorname":node.color.name });
	}
	else if(node.color.type === 'colorindex'){
		visitNode(node.color.children[0]);
		colorIndex = stack.pop();
		self.postMessage({ "type":"command", "name":"bg", "colorindex":colorIndex });
	}
}

function visitthickstmt(node){
	visitchildren(node);
	var thick = stack.pop();
	self.postMessage({ "type":"command", "name":"thick", "amount":thick });
}

function visitbooleanstmt(node){
	var toEval = node.toEval;
	visitNode( toEval );
	var istrue = stack.pop();
	if(istrue === 1){
		visitchildren( node.iftrue );
	}
}

function visitstopstmt(node){
	throw new Error("stop");
}

function visitcompoundbooleanstmt(node){
	var toEval = node.toEval;
	visitNode( toEval );
	var istrue = stack.pop();
	if(istrue === 1){
		visitchildren( node.iftrue );
	}
	else{
		visitchildren( node.iffalse );
	}
}

function visitbooleanval(node){
	var ch = node.children;
	visitNode( ch[0] );
	visitNode( ch[1] );
	var op = node.op;
	var rhs = stack.pop();
	var lhs = stack.pop();
	lhs = parseFloat(lhs, 10);
	rhs = parseFloat(rhs, 10);
	if(op === "=" && lhs === rhs){
		stack.push(1);
	}
	else if(op === "<" && lhs < rhs){
		stack.push(1);
	}
	else if(op === ">" && lhs > rhs){
		stack.push(1);
	}
	else if(op === "<=" && lhs <= rhs){
		stack.push(1);
	}
	else if(op === ">=" && lhs >= rhs){
		stack.push(1);
	}
	else if(op === "!=" && lhs !== rhs){
		stack.push(1);
	}
	else{
		stack.push(0);
	}
}

function visitcolorstmt(node){
	var colorIndex;
	if(node.color.type === 'colorname'){
		self.postMessage({ "type":"command", "name":"color", "colorname":node.color.name });
	}
	else if(node.color.type === 'colorindex'){
		visitNode(node.color.children[0]);
		colorIndex = stack.pop();
		self.postMessage({ "type":"command", "name":"color", "colorindex":colorIndex });
	}
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
		for(var i = 0; i <= num - 1; i++){
			symTable.add("repcount", i);
			try{
				visitNode(ch[1]);
			}
			catch(e){
				if(e.message === "stop"){
					break;
				}
				else{
					runTimeError(e.message);
				}
			}
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
	if(node.value === "random"){
		stack.push(Math.floor(Math.random() * 100));
	}
	else{
		stack.push(node.value);
	}
}

function visitrtstmt(node){
	visitchildren(node);
	var amount = stack.pop();
	amount = amount % 360;
	self.postMessage({"type":"command", "name":"rt", "amount":amount });
}

function visitltstmt(node){
	visitchildren(node);
	var amount = stack.pop();
	amount = amount % 360;
	self.postMessage({"type":"command", "name":"rt", "amount": -1 * amount });
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
	if(num === null || num === undefined){
		runTimeError("Variable '"+node.name+"' not found.");
	}
	else{
		stack.push(num);
	}
}

function visitsetxy(node){
	visitchildren(node);
	var amountY = stack.pop();
	var amountX = stack.pop();
	self.postMessage({ "type":"command", "name":"setxy", "amountX":amountX, "amountY":amountY });
}

function visitlabelstmt(node){
	var child, contents;
	child = node.children[0];
	if(typeof child === 'object' && child.type && child.type === "expression"){
		visitNode(child);
		contents = stack.pop();
		contents = parseFloat(contents, 10);
		contents = Number(contents.toFixed(4));
		contents = "" + contents;
	}
	else{
		contents = child; // a string
	}
	if(contents.length > 16){
		contents = contents.substring(0, 16);
	}
	self.postMessage({ "type":"command", "name":"label", "contents": contents});
}

function visitsqrtexpression(node){
	visitchildren(node);
	var amount = stack.pop();
	if(amount >= 0){
		stack.push(Math.sqrt(amount));
	}
	else{
		runTimeError("You took the square root of a negative number");
	}
}

function visitsinexpression(node){
	visitchildren(node);
	var amount = stack.pop();
	stack.push(Math.sin(amount*Math.PI/180));
}

function visitcosexpression(node){
	visitchildren(node);
	var amount = stack.pop();
	stack.push(Math.cos(amount*Math.PI/180));
}

function visittanexpression(node){
	visitchildren(node);
	var amount = stack.pop();
	stack.push(Math.tan(amount*Math.PI/180));
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
	var name = node.name, args = "input argument";
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
			try{
				executeFunction(f);
			}
			catch(e){
				if(e.message === "stop"){
					console.log("caught stop");
				}
				else{
					runTimeError(e.message);
				}
			}
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
	else if(t=="homestmt"){
		visithomestmt(node);
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
	else if(t=="arcstmt"){
		visitarcstmt(node);
	}
	else if(t=="bkstmt"){
		visitbkstmt(node);
	}
	else if(t=="rtstmt"){
		visitrtstmt(node);
	}
	else if(t=="ltstmt"){
		visitltstmt(node);
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
	else if(t=="booleanstmt"){
		visitbooleanstmt(node);
	}
	else if(t=="stopstmt"){
		visitstopstmt(node);
	}
	else if(t=="compoundbooleanstmt"){
		visitcompoundbooleanstmt(node);
	}
	else if(t=="booleanval"){
		visitbooleanval(node);
	}
	else if(t=="usevar"){
		visitusevar(node);
	}
	else if(t=="setxy"){
		visitsetxy(node);
	}
	else if(t=="sqrtexpression"){
		visitsqrtexpression(node);
	}
	else if(t=="sinexpression"){
		visitsinexpression(node);
	}
	else if(t=="cosexpression"){
		visitcosexpression(node);
	}
	else if(t=="tanexpression"){
		visittanexpression(node);
	}
	else if(t=="labelstmt"){
		visitlabelstmt(node);
	}
}

