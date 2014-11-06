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
	[[self getEventDispatcher] addListener:SYMM_NOTIF_STOP toFunction:@selector(stop) withContext:self];
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
	NSLog(@"ioscallback %@", jsonObj);
	NSString* errorMessage;
	if ([jsonObj isKindOfClass:[NSDictionary class]]){
		NSDictionary* data = jsonObj[@"data"];
		NSDictionary* error = jsonObj[@"error"];
		if(error){
			errorMessage = [NSString stringWithFormat:@"Error on line %@, %@", error[@"line"], error[@"message"]];
			[self error:errorMessage];
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
	[[self getDrawingModel] setVal:[NSNumber numberWithBool:NO] forKey:DRAWING_ISDRAWING];
}

- (void) error:(NSString*)msg{
	[self finished];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PDrawingModel>) getDrawingModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PDrawingModel)];
}

- (void) stop{
	NSLog(@"STOP!");
	NSString* fnCall = @"LG.stop()";
	[self.webView stringByEvaluatingJavaScriptFromString:fnCall];
}

- (void) draw{
	NSString* logo = [[self getLogoModel] get];
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
}

- (void) receivedCommand:(NSDictionary*) data{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_CMD_RECEIVED withData:data];
}

- (void) dealloc{
	[self removeListeners];
}

@end
