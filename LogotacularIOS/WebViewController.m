//
//  WebViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "PLogoModel.h"
#import "SymmNotifications.h"
#import "PDrawingModel.h"
#import "ToastUtils.h"
#import "PLogoErrorModel.h"
#import <Objection/Objection.h>
#import "PCommandConsumer.h"

@interface WebViewController ()

@property WKWebView* webView;
@property id <PCommandConsumer> _commandConsumer;
@property WKUserContentController* controller;
@property WKWebViewConfiguration* conf;

@end

@implementation WebViewController

- (void) setCommandConsumer:(id<PCommandConsumer>)commandConsumer{
	self._commandConsumer = commandConsumer;
}

- (void) viewDidLoad{
	[super viewDidLoad];
	[self addWebView];
	[self addListeners];
}

- (void) addListeners{
	[[self getEventDispatcher] addListener:SYMM_NOTIF_PARSE toFunction:@selector(parse) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_SYNTAX_CHECK toFunction:@selector(check) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
}

- (void)check{
	NSString* logo = [[self getLogoModel] get];
	logo = [self clean:logo];
	NSString* fnCall = [NSString stringWithFormat:@"LG.getTree('%@')", logo];
	if(self.webView){
		[self.webView evaluateJavaScript:fnCall completionHandler:^(id _Nullable id, NSError * _Nullable error) {
			//
		}];
	}
}

- (void) addWebView{
	self.conf = [[WKWebViewConfiguration alloc] init];
	self.controller = [[WKUserContentController alloc] init];
	self.conf.userContentController = self.controller;
	[self.controller addScriptMessageHandler:self name:@"iosCallback"];
	
	self.webView = [[WKWebView alloc] initWithFrame:(CGRect)CGRectZero configuration:self.conf];
	NSString* path;
	NSBundle* thisBundle = [NSBundle mainBundle];
	path = [thisBundle pathForResource:@"assets/parser/index2" ofType:@"html"];
	if(path){
		NSURL* instructionsURL = [NSURL fileURLWithPath:path];
		NSString* htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		self.webView.navigationDelegate = self;
		[self.webView loadHTMLString:htmlString baseURL:instructionsURL];
		[self.view addSubview:self.webView];
	}
}

- (void) iosCallbacks:(NSDictionary*) jsonObj{
	
}

- (void) iosCallback:(NSDictionary*) jsonObj{
	if ([jsonObj isKindOfClass:[NSDictionary class]]){
		NSDictionary* error = jsonObj[@"error"];
		NSDictionary* syntaxError = jsonObj[@"syntaxerror"];
		
		if(error){
			[self error:error];
		}
		else if(syntaxError){
			[self syntaxError:syntaxError];
		}
		else{
			NSString* type = jsonObj[@"type"];
			if([type isEqualToString:@"command"]){
				[self receivedCommand:jsonObj];
			}
			else if([type isEqualToString:@"end"]){
				[self finished];
			}
		}
	}
}

- (void) finished{
	[[self getDrawingModel] setVal:@NO forKey:DRAWING_ISDRAWING];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_TRI withData:nil];
}

- (void) error:(NSDictionary*)error{
	[self finished];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_ERROR_HIT withData:error];
}

- (void) syntaxError:(NSDictionary*)syntaxError{
	if(syntaxError == nil || syntaxError == (NSDictionary*) [NSNull null] || [syntaxError count] == 0){
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_SYNTAX_ERROR withData:nil];
	}
	else{
		[self finished];
		[[self getEventDispatcher] dispatch:SYMM_NOTIF_SYNTAX_ERROR withData:syntaxError];
	}
}

- (id<PLogoErrorModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
}

- (void) stop{
	NSString* fnCall = @"LG.stop()";
	if(self.webView){
		[self.webView evaluateJavaScript:fnCall completionHandler:^(id _Nullable id, NSError * _Nullable error) {
			//
		}];
	}
}

- (NSString*) clean:(NSString*)logo{
	const char *chars = [logo UTF8String];
	NSMutableString *escapedString = [NSMutableString string];
	while (*chars){
		if (*chars == '\\'){
			[escapedString appendString:@"\\\\"];
		}
		else if (*chars == '"'){
			[escapedString appendString:@"\\\""];
		}
		else if (*chars < 0x1F || *chars == 0x7F){
			[escapedString appendFormat:@"\\u%04X", (int)*chars];
		}
		else{
			[escapedString appendFormat:@"%c", *chars];
		}
		++chars;
	}
	return escapedString;
}

- (void) parse{
	NSString* logo = [[self getLogoModel] get];
	logo = [self clean:logo];
	NSString* fnCall = [NSString stringWithFormat:@"LG.draw('%@')", logo];
	if(self.webView){
		[self.webView evaluateJavaScript:fnCall completionHandler:^(id _Nullable id, NSError * _Nullable error) {
			//
		}];
	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
	NSLog(@"loaded");
	[self onWebLoaded];
}

- (void)onWebLoaded{
	//WKUserScript* s = [[WKUserScript alloc] initWithSource:@"alert('hi')" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
	//[self.controller addUserScript:s];
	
	//WKUserScript* s2 = [[WKUserScript alloc] initWithSource:@"window.LG.test()" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
	//[self.controller addUserScript:s2];
	//JSContext *context =  [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
	//context[@"iosCallback"] = ^(NSString* param) {
		//NSError* error;
		//NSData* data = [param dataUsingEncoding:NSUTF8StringEncoding];
		//NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		//[self iosCallback:jsonObj];
	//};
	
	
}

- (void) removeListeners{
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_PARSE toFunction:@selector(parse) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SYNTAX_CHECK toFunction:@selector(check) withContext:self];
}

- (void) receivedCommand:(NSDictionary*) data{
	if(self._commandConsumer){
		[self._commandConsumer consume:data];
	}
}

- (void) dealloc{
	[self removeListeners];
	[self.webView removeFromSuperview];
	self.webView = nil;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
	NSLog(@"msg");
	//NSLog(message);
	NSLog(message.name);
	NSLog(message.body);
	
}

@end
