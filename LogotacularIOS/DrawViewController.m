//
//  ViewController.m
//  JSTest
//
//  Created by John on 25/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "DrawViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PaintView.h"
#import "ImageUtils.h"
#import "Appearance.h"
#import "TextView.h"
#import "ButtonList.h"

@interface DrawViewController ()

@property UIWebView* webView;
@property UIActivityIndicatorView* spinner;
@property TextView* logoText;
@property PaintView* paintView;
@property UILabel* label;
@property UIButton* button;
@property ButtonList* buttonList;

@end

@implementation DrawViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self addWebView];
	[self addPaint];
	[self addLabel];
	[self addText];
	[self addNavButtons];
	self.title = @"Unsaved file *";
}

-(UIBarButtonItem*) getButton:(NSString*) imageUrl withAction:(SEL)action{
	UIImage* img = [UIImage imageNamed:imageUrl];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.bounds = CGRectMake(0, 0, 30, 30);
	btn.frame = CGRectMake(-15, 0, 80, 30);
	[btn setImage:img forState:UIControlStateNormal];
	UIView* container =[[UIView alloc] initWithFrame:CGRectMake(0,0,60,30)];
	[btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	[container addSubview:btn];
	UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:container];
	return buttonItem;
}

-(void)addNavButtons{
	UIBarButtonItem* b0 = [self getButton:@"assets/icons/add63.png" withAction:@selector(onClick0)];
	UIBarButtonItem* b1 = [self getButton:@"assets/icons/arrow408.png" withAction:@selector(onClick0)];
	UIBarButtonItem* b2 = [self getButton:@"assets/icons/arrow421.png" withAction:@selector(onClick0)];
	UIBarButtonItem* b3 = [self getButton:@"assets/icons/bulb11.png" withAction:@selector(onClick0)];
	UIBarButtonItem* b4 = [self getButton:@"assets/icons/floppy9.png" withAction:@selector(onClick0)];
	UIBarButtonItem* b5 = [self getButton:@"assets/icons/folder59.png" withAction:@selector(onClick0)];
	UIBarButtonItem* b6 = [self getButton:@"assets/icons/list26.png" withAction:@selector(onClick1)];
	UIBarButtonItem* b7 = [self getButton:@"assets/icons/play33.png" withAction:@selector(onClick0)];
	UIBarButtonItem* b8 = [self getButton:@"assets/icons/waste2.png" withAction:@selector(onClick0)];
	self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:b0, b1, b2, b3, b4, nil];
	self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:b5, b6, b7, b8, nil];
	self.buttonList = [[ButtonList alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
	[self.view addSubview:self.buttonList];
}

-(void)addButton{
	self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	[self.button setTitle:@"Click" forState:UIControlStateNormal];
	self.button.frame = CGRectMake(480.0, 110.0, 160.0, 40.0);
	[self.view addSubview:self.button];
}

-(void)addLabel{
	self.label = [[UILabel alloc] initWithFrame:CGRectMake(300, 200, 100, 30)];
	[self.view addSubview:self.label];
}

-(void)layoutPaint{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.paintView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view			attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.paintView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view		attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.paintView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view		attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.paintView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view		attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

-(void)addPaint{
	self.paintView = [[PaintView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.paintView];
	[self layoutPaint];
}

- (void) layoutText{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:0.6667 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide	attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

-(void)addText{
	self.logoText = [[TextView alloc] initWithFrame:CGRectZero];
	[self.logoText setText:@"rpt 400  fd(400)  rt(160)  endrpt"];
	[self.view addSubview:self.logoText];
	self.logoText.translatesAutoresizingMaskIntoConstraints = NO;
	UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(textSwipe:)];
	swipe.delegate = self;
	[self.logoText addGestureRecognizer:swipe];
	[self layoutText];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGesture{
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:touch.view];
	int dx = self.view.frame.size.width - location.x;
	if(abs(dx < 80)){
		[self showText];
	}
}

- (void) showText{
	[self moveText:YES];
}

- (void) hideText{
	[self moveText:NO];
}

- (void) moveText:(BOOL)show{
	float x1t;
	float time = 1.0;
	float x0 = self.view.frame.size.width - self.logoText.frame.size.width/2;
	float x1 = x0 + self.logoText.frame.size.width;
	if(show){
		x1t = x1;
		x1 = x0;
		x0 = x1t;
		time = 0.25;
	}
	[ImageUtils bounceAnimateView:self.logoText from:x0 to:x1 withKeyPath:@"position.x" withKey:@"textBounce" withDelegate:nil withDuration:time withImmediate:NO];
}

- (void) textSwipe:(id) sender{
	[self hideText];
}

-(void)onClick{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

-(void)onClick0{
	[self.paintView reset];
	NSString* logo = [self.logoText getText];
	NSString* fnCall = [NSString stringWithFormat:@"LG.draw('%@')", logo];
	id tree = [self.webView stringByEvaluatingJavaScriptFromString:fnCall];
}

-(void)onClick1{
	
}

-(void)onClick2{
	
}

-(void) addWebView{
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

- (void) executeCommand:(NSDictionary*) data{
	[self.paintView execute:data];
}

- (void) iosCallback:(NSDictionary*) jsonObj{
	if ([jsonObj isKindOfClass:[NSDictionary class]]){
		NSDictionary* data = jsonObj[@"data"];
		NSString* type = data[@"type"];
		if([type isEqualToString:@"command"]){
			[self executeCommand:data];
		}
	}
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
	NSLog(@" didFailLoadWithError");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
