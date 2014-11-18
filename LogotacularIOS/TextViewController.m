//
//  TextViewController.m
//  LogotacularIOS
//
//  Created by John on 29/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "TextViewController.h"
#import "ImageUtils.h"
#import "Appearance.h"
#import "PLogoModel.h"
#import "PLogoErrorModel.h"
#import "SymmNotifications.h"
#import <CoreText/CoreText.h>
#import "Appearance.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Assets.h"
#import "ErrorObject.h"
#import "Appearance.h"

@interface TextViewController ()

@property UITextView* logoText;
@property UIGestureRecognizer* swipe;
@property UITapGestureRecognizer* exclamTap;
@property NSString* cachedText;
@property float scrollPos;
@property UIImageView* exclamView;
@property UIView* container;
@property UIButton* undoButton;
@property UIButton* redoButton;

@end

@implementation TextViewController

int const TEXT_PADDING = 10;
int const HORIZ_PADDING = 35;
int const EXCLAM_SIZE = 36;

- (void) viewDidLoad{
	[super viewDidLoad];
	self.scrollPos = 0;
	[self addContainer];
	[self addButtons];
	[self addText];
	[self addExclam];
	[self addListeners];
	self.view.alpha = 0.75;
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self layoutText];
	[self layoutContainer];
	[self layoutButtons];
	[self clearError];
}

- (void) addButtons{
	self.undoButton = [UIButton buttonWithType:UIButtonTypeSystem];
	self.redoButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.view addSubview:self.undoButton];
	[self.view addSubview:self.redoButton];
	[self.undoButton setImage:[UIImage imageNamed:UNDO_ICON] forState:UIControlStateNormal];
	[self.redoButton setImage:[UIImage imageNamed:REDO_ICON] forState:UIControlStateNormal];
}

- (void) clearError{
	self.exclamView.frame = CGRectZero;
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_HIDE_POPOVER withData:nil];
}

- (void) addExclam{
	self.exclamView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
	[self.view addSubview:self.exclamView];
	self.exclamView.contentMode = UIViewContentModeScaleAspectFit;
	self.exclamView.image = [UIImage imageNamed:EXCLAM_ICON];
}

- (void) addContainer{
	self.container = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:self.container];
	self.container.backgroundColor = [Appearance grayColor];
	self.container.layer.cornerRadius = 10;
	self.container.layer.masksToBounds = YES;
}

- (void) addListeners{
	[[self getLogoModel] addGlobalListener:@selector(modelChanged) withTarget:self];
	[[self getErrorModel] addListener:@selector(errorChanged) forKey:LOGO_ERROR_ERROR withTarget:self];
	[[self getEventDispatcher] addListener:SYMM_NOTIF_DISMISS_KEY toFunction:@selector(dismissKeyboard) withContext:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide) name:UIKeyboardDidHideNotification object:nil];
	self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(textSwipe:)];
	self.swipe.delegate = self;
	[self.view addGestureRecognizer:self.swipe];
	self.exclamTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapExclam)];
	[self.exclamView setUserInteractionEnabled:YES];
	[self.exclamView addGestureRecognizer:self.exclamTap];
}

- ( void) keyBoardDidHide{
	[self editEnded];
}

-(void)tapExclam{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_SHOW_POPOVER withData:self.exclamView];
}

- (void) drawErrorForStart:(NSInteger)start andEnd:(NSInteger)end{
	float size = 36;
	NSLayoutManager *layoutManager = [self.logoText layoutManager];
	NSTextContainer *textContainer = [self.logoText textContainer];
	NSRange range = NSMakeRange(start, end - start);
	CGRect r = [layoutManager boundingRectForGlyphRange:range inTextContainer:textContainer];
	r = CGRectOffset(r, self.logoText.frame.origin.x, self.logoText.frame.origin.y - self.scrollPos);
	float dy = r.size.height/2 - size/2.0;
	float exclamPos = r.origin.y + dy;
	if(exclamPos < 0){
		exclamPos = 0;
	}
	if(exclamPos > self.view.frame.size.height - 40){
		exclamPos = self.view.frame.size.height - 40;
	}
	self.exclamView.frame = CGRectMake(0, exclamPos, size, size);
	[self animateExclamAt:r.origin.y];
}

- (void) animateExclamAt:(float)y{
	float hiddenAlpha = 0.25;
	float alpha = 1.0;
	float rot = 0.0;
	if(y < 0){
		alpha = hiddenAlpha;
		rot = -90.0;
	}
	else if (y > self.view.frame.size.height - 40){
		alpha = hiddenAlpha;
		rot = 90.0;
	}
	self.exclamView.alpha = alpha;
	self.exclamView.transform = CGAffineTransformMakeRotation(rot*3.14159/180);
}

- (void) modelChanged{
	NSString* text = [[self getLogoModel] get];
	if(![text isEqualToString:[self.logoText text]]){
		[self.logoText setText:text];
	}
}

- (void) layoutText{
	float p = 10;
	self.logoText.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual		toItem:self.container			attribute:NSLayoutAttributeTop			multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual		toItem:self.container			attribute:NSLayoutAttributeLeft			multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual		toItem:self.container			attribute:NSLayoutAttributeBottom		multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoText attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual		toItem:self.container			attribute:NSLayoutAttributeRight		multiplier:1.0 constant:-p]];
}

- (void) layoutContainer{
	self.container.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeTop			multiplier:1.0 constant:TEXT_PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeLeft			multiplier:1.0 constant:TEXT_PADDING + HORIZ_PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual	toItem:self.view			attribute:NSLayoutAttributeBottom		multiplier:1.0 constant:-TEXT_PADDING]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeRight		multiplier:1.0 constant:0]];
}

- (void) layoutButtons{
	self.undoButton.translatesAutoresizingMaskIntoConstraints = NO;
	self.redoButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeBottom				multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeCenterX				multiplier:1.0 constant:-50.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual		toItem:nil					attribute:NSLayoutAttributeNotAnAttribute		multiplier:0.0 constant:50.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual		toItem:nil					attribute:NSLayoutAttributeNotAnAttribute		multiplier:0.0 constant:30.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.redoButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeBottom				multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.redoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual		toItem:self.view			attribute:NSLayoutAttributeCenterX				multiplier:1.0 constant:-5.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.redoButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual		toItem:nil					attribute:NSLayoutAttributeNotAnAttribute		multiplier:0.0 constant:50.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.redoButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual		toItem:nil					attribute:NSLayoutAttributeNotAnAttribute		multiplier:0.0 constant:30.0]];
}

- (void) textSwipe:(id) sender{
	[self hide];
	[self dismissKeyboard];
}

-(void)addText{
	self.logoText = [[UITextView alloc] initWithFrame:self.view.frame];
	self.logoText.editable = YES;
	self.logoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.logoText.autocorrectionType = UITextAutocorrectionTypeNo;
	self.logoText.delegate = self;
	self.logoText.allowsEditingTextAttributes = YES;
	self.logoText.backgroundColor = [UIColor clearColor];
	[self.logoText setFont:[Appearance monospaceFontOfSize:SYMM_FONT_SIZE_MED]];
	self.logoText.textColor = [UIColor whiteColor];
	[self.view addSubview:self.logoText];
	self.logoText.textContainer.lineFragmentPadding = 0;
	self.logoText.textContainerInset = UIEdgeInsetsZero;
}

- (void) textViewDidChange:(UITextView *)textView{
	[self checkChanged];
}

- (void) errorChanged{
	NSString* text = [[self getLogoModel] get];
	ErrorObject* errorObj = (ErrorObject*)[[self getErrorModel] getVal:LOGO_ERROR_ERROR];
	NSInteger k = 0;
	NSInteger start = 0;
	NSInteger end = 0;
	if(errorObj){
		NSInteger intLine = [[errorObj getLine] integerValue];
		NSArray* comps = [text componentsSeparatedByString:@"\n"];
		while(k <= intLine - 2){
			start += [(NSString*)comps[k] length] + 1; //for the newline
			k++;
		}
		end = start + [(NSString*)comps[k] length];
		[self drawErrorForStart:start andEnd:end];
	}
	else{
		[self clearError];
	}
}

- (void) show{
	[self move:YES];
}

- (void) hide{
	[self move:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
	[[self getErrorModel] setVal:nil forKey:LOGO_ERROR_ERROR];
	self.cachedText = [self.logoText text];
}

- (void)textViewDidEndEditing:(UITextView*)textView{
	[self editEnded];
}

- (void)editEnded{
	[self errorChanged];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerEdit) object:nil];
	[self triggerEdit];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerCheck) object:nil];
	[self triggerCheck];
	[self performSelector:@selector(errorChanged) withObject:self afterDelay:0.5];
}

- (void) triggerCheck{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_SYNTAX_CHECK withData:nil];
}

- (void) triggerEdit{
	NSString* text = self.logoText.text;
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_TEXT_EDITED withData:text];
}

- (void) checkChanged{
	NSString* text = self.logoText.text;
	if(![self.cachedText isEqualToString:text]){
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerEdit) object:nil];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerCheck) object:nil];
		[self performSelector:@selector(triggerEdit) withObject:nil afterDelay:0.5];
		[self performSelector:@selector(triggerCheck) withObject:nil afterDelay:2.5];
	}
}

- (id<PLogoModel>) getLogoModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoModel)];
}

- (id<PLogoModel>) getErrorModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PLogoErrorModel)];
}

- (void) dismissKeyboard{
	[self.logoText resignFirstResponder];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGesture{
	return NO;
}

- (void) move:(BOOL)show{
	float x1t;
	float time = 0.5;
	float x0 = self.view.frame.size.width/2;
	float x1 = x0 + self.view.frame.size.width;
	if(show){
		x1t = x1;
		x1 = x0;
		x0 = x1t;
		time = 0.2;
	}
	[ImageUtils bounceAnimateView:self.view from:x0 to:x1 withKeyPath:@"position.x" withKey:@"textBounce" withDelegate:nil withDuration:time withImmediate:NO];
}

- (void) removeListeners{
	[self.view removeGestureRecognizer:self.swipe];
	[[self getLogoModel] removeGlobalListener:@selector(modelChanged) withTarget:self];
	[[self getEventDispatcher] removeListener:SYMM_NOTIF_DISMISS_KEY toFunction:@selector(dismissKeyboard) withContext:self];
	[[self getErrorModel] removeListener:@selector(errorChanged) forKey:LOGO_ERROR_ERROR withTarget:self];
	[self.exclamView removeGestureRecognizer:self.exclamTap];
	[self.exclamView setUserInteractionEnabled:NO];
	self.exclamTap = nil;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
	self.scrollPos = scrollView.contentOffset.y;
	[self errorChanged];
}

-(void) dealloc{
	[self removeListeners];
}

@end

