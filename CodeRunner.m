
#import "CodeRunner.h"

@interface CodeRunner ()

@property JSContext context;


@end

@implementation CodeRunner : NSObject

- (void)init: (NSArray*) fileNames){
	//[self bindClasses];
	self = [super init];
	if (self) {
		[self makeContext:fileNames];
		//self.loadFiles(fileNames: fileNames);
		//self._consumer = consumer;
		//self.setStatus(s: "ready");
	}
	return self;
	
}

- (void) makeContext: (NSArray*) fileNames{
	self.context = [[JSContext alloc] initWithVirtualMachine:[JSVirtualMachine alloc] init];
	let consoleLog: @convention(block) (String) -> Void = { message in
		print("console.log " + message);
	}
	self.context.exceptionHandler = { context, exception in
		print("error: \(exception)");
	};
	self.context.globalObject.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol)!)

}




@end



/*
import Foundation
import SceneKit
import QuartzCore
import JavaScriptCore
import UIKit

@objc
class CodeRunner : NSObject, PCodeRunner {

	internal var events: EventDispatcher?

	private var context: JSContext!
	private let serialQueue = DispatchQueue(label: "codeRunnerSerialQueue" + UUID().uuidString);
	private let mutexLock = Mutex();
	private var _consumer:PCodeConsumer!;
	private var _status:String = "new";
	
	enum CodeRunnerError : Error {
		case RuntimeError(String)
	}
	
	required init(fileNames:[String], consumer:PCodeConsumer){
		super.init();
		self.events = Vent();
		self.makeContext(fileNames: fileNames);
		self.loadFiles(fileNames: fileNames);
		self._consumer = consumer;
		self.setStatus(s: "ready");
	}
	
	private func setStatus(s:String){
		self._status = s;
		self.events?.dispatchEvent(Event(type: "change:status", data:s));
	}
	
	private func loadFile(fileName:String){
		do {
			let path:String = Bundle.main.path(forResource: fileName, ofType: "js")!;
			let contents = try String(contentsOfFile:path, encoding: String.Encoding.utf8);
			_ = self.context.evaluateScript(contents);
		}
		catch (let error) {
			print("Error while processing script file: \(error)");
		}
	}
	
	private func loadFiles(fileNames:[String]){
		for fileName:String in fileNames{
			self.loadFile(fileName:fileName);
		}
	}
	
	private func makeContext(fileNames:[String]){
		self.context = JSContext(virtualMachine: JSVirtualMachine());
		let consoleLog: @convention(block) (String) -> Void = { message in
			print("console.log " + message);
		}
		self.context.exceptionHandler = { context, exception in
			print("error: \(exception)");
		};
		self.context.globalObject.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol)!)
	}
	
	private func bindConsumer(){
		let lockedConsumerBlock:@convention(block)(String, String) ->Void = {type, data in
			let allowedStates:[String] = ["running", "pausing", "paused", "waking"];
			if(allowedStates.index(of: self._status) == nil){
				print("broken...", self._status);
			}
			else{
				self.mutexLock.locked {
					if(self._status == "running" && self.hasConsumer()){
						if(type == "end"){
							self.setStatus(s:"ready");
						}
						else{
							self._consumer.consume(type: type, data:data);
						}
					}
				}
			}
		}
		let castBlock:Any! = unsafeBitCast(lockedConsumerBlock, to: AnyObject.self);
		self.context.globalObject.setObject(castBlock, forKeyedSubscript: "consumer" as (NSCopying & NSObjectProtocol)!);
	}
	
	private func unbindConsumer(){
		self.context.globalObject.setObject(nil, forKeyedSubscript: "consumer" as (NSCopying & NSObjectProtocol)!);
	}
	
	private func hasConsumer() -> Bool{
		let c = self.context.globalObject.objectForKeyedSubscript("consumer");
		if(c == nil || c?.toString() == "undefined"){
			return false;
		}
		return true;
	}
	
	public func run(fnName:String, arg:String) {
		if(self._status == "ready"){
			self.setStatus(s: "about to run");
			if(!self.hasConsumer()){
				self.bindConsumer();
			}
			serialQueue.async{
				if(self._status == "about to run"){
					self.setStatus(s: "running");
				}
				let fn = self.context.objectForKeyedSubscript(fnName);
				_ = fn?.call(withArguments: [arg]);
			}
		}
	}
	
	public func end(){
		let fn = self.context.objectForKeyedSubscript("end");
		_ = fn?.call(withArguments: []);
		self.unbindConsumer();
		self.setStatus(s: "ready");
	}
	
	public func sleep(){
		if(self._status == "running"){
			self.setStatus(s: "pausing");
			print("1");
			self.mutexLock.lock();
			print("2");
			self.setStatus(s: "paused");
			print("3");
		}
	}
	
	public func wake(){
		if(self._status == "paused"){
			self.setStatus(s: "waking");
			self.mutexLock.unlock();
			self.setStatus(s: "running");
		}
	}
}

 */
