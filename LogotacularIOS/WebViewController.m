//
//  WebViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PLogoModel.h"
#import "SymmNotifications.h"
#import "PDrawingModel.h"
#import "ToastUtils.h"
#import "PLogoErrorModel.h"
#import <Objection/Objection.h>

@interface WebViewController ()

@property UIWebView* webView;

@end

@implementation WebViewController

- (void) viewDidLoad{
	[self addWebView];
	[self addListeners];
}

- (void) addListeners{
	[[self getEventDispatcher] addListener:SYMM_NOTIF_START toFunction:@selector(draw) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_SYNTAX_CHECK toFunction:@selector(check) withContext:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
}

- (void)check{
	NSString* logo = [[self getLogoModel] get];
	logo = [self clean:logo];
	NSString* fnCall = [NSString stringWithFormat:@"LG.getTree('%@')", logo];
	[self.webView stringByEvaluatingJavaScriptFromString:fnCall];
}

- (void) addWebView{
	self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	NSString* path;
	NSBundle* thisBundle = [NSBundle mainBundle];
	path = [thisBundle pathForResource:@"assets/parser/index" ofType:@"html"];
	NSURL* instructionsURL = [NSURL fileURLWithPath:path];
	NSString* htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	self.webView.delegate = self;
	[self.webView loadHTMLString:htmlString baseURL:instructionsURL];
	[self.view addSubview:self.webView];
}

- (void) iosCallback:(NSDictionary*) jsonObj{
	if ([jsonObj isKindOfClass:[NSDictionary class]]){
		//NSLog(@">>  ios %@ \n\n <<<< ", jsonObj);
		NSDictionary* data = jsonObj[@"data"];
		NSDictionary* error = jsonObj[@"error"];
		NSDictionary* syntaxError = jsonObj[@"syntaxerror"];
		if(error){
			[self error:error];
		}
		else if(syntaxError){
			[self syntaxError:syntaxError];
		}
		else{
			NSString* type = data[@"type"];
			if([type isEqualToString:@"command"]){
				[self receivedCommand:data];
			}
			else if([type isEqualToString:@"end"]){
				[self finished];
			}
		}
	}
}

- (void) finished{
	[[self getDrawingModel] setVal:@NO forKey:DRAWING_ISDRAWING];
}

- (void) error:(NSDictionary*)error{
	[self finished];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_ERROR_HIT withData:error];
}

- (void) syntaxError:(NSDictionary*)syntaxError{
	[self finished];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_SYNTAX_ERROR withData:syntaxError];
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
	[self.webView stringByEvaluatingJavaScriptFromString:fnCall];
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

- (void) draw{
	NSString* logo = [[self getLogoModel] get];
	logo = [self clean:logo];
	NSLog(@"draw %@", logo);
	NSString* fnCall = [NSString stringWithFormat:@"LG.draw('%@')", logo];
	[self.webView stringByEvaluatingJavaScriptFromString:fnCall];
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView{
	JSContext *context =  [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
	context[@"iosCallback"] = ^(NSString* param) {
		NSError* error;
		NSData* data = [param dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		[self iosCallback:jsonObj];
	};
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	NSLog(@"didFailLoadWithError");
}

- (void) removeListeners{
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_START toFunction:@selector(draw) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_SYNTAX_CHECK toFunction:@selector(check) withContext:self];
}

- (void) receivedCommand:(NSDictionary*) data{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CMD_RECEIVED withData:data];
}

- (void) dealloc{
	[self removeListeners];
}

@end
