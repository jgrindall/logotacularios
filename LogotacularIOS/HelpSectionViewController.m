//
//  HelpSectionViewController.m
//  LogotacularIOS
//
//  Created by John on 10/11/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "HelpSectionViewController.h"
#import "SymmNotifications.h"
#import "HelpData.h"
#import "Appearance.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HelpLayout.h"

@interface HelpSectionViewController ()

@property UIButton* progCopyButton;
@property UITextView* textView;
@property UITextView* topView;
@property MPMoviePlayerController* videoController;
@property BOOL videoLoaded;

@end

@implementation HelpSectionViewController

- (void) clearMedia{
	[self.videoController stop];
}

- (void) addChildren{
	[super addChildren];
	[self addText];
	[self addTop];
	[self addButton];
}

- (void)loadMedia{
	[super loadMedia];
	if(!self.videoLoaded){
		NSString* path = [[NSBundle mainBundle] pathForResource:@"assets/help0" ofType:@"mov"];
		NSURL* url = [NSURL fileURLWithPath:path];
		[self.videoController setContentURL:url];
		[self.videoController prepareToPlay];
		self.videoLoaded = YES;
	}
}

- (void) addMedia{
	if(self.videoController){
		return;
	}
	self.videoController = [[MPMoviePlayerController alloc] init];
	float p = 10;
	float w = self.view.frame.size.width;
	float h = self.view.frame.size.height;
	self.view.backgroundColor = [UIColor clearColor];
	self.videoController.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.videoController.view setFrame:CGRectMake (w*(1 - HELP_LAYOUT_FRAC) + p, h*(1 - HELP_LAYOUT_FRAC) + p, w*HELP_LAYOUT_FRAC - 2*p, h*HELP_LAYOUT_FRAC - 2*p)];
	UIColor* bg = [UIColor orangeColor];
	self.videoController.backgroundView.backgroundColor = bg;
	self.videoController.view.backgroundColor = bg;
	for(UIView* v in self.videoController.view.subviews) {
		v.backgroundColor = bg;
	}
	for(UIView* v in self.videoController.backgroundView.subviews) {
		v.backgroundColor = bg;
	}
	[self.view addSubview:self.videoController.view];
}

- (void) layoutAll{
	[super layoutAll];
	[self layoutButton];
	[self layoutText];
	[self layoutVideo];
	[self layoutTop];
}

- (void) layoutVideo{
	if(!self.videoController || !self.topView || !self.textView){
		return;
	}
	float p = 10;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.videoController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.videoController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textView				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.videoController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.videoController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-p]];
}

- (void)layoutTop{
	float p = 10;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTop multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeHeight multiplier:(1 - HELP_LAYOUT_FRAC) constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-p]];
}

- (void) layoutButton{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:200.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textView			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.textView		attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

- (void) layoutText{
	float p = 10;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeLeading multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view						attribute:NSLayoutAttributeWidth multiplier:(1 - HELP_LAYOUT_FRAC) constant:-p]];
}

- (void) addText{
	self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
	self.textView.translatesAutoresizingMaskIntoConstraints = NO;
	self.textView.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.textView.backgroundColor = [Appearance grayColor];
	[self.view addSubview:self.textView];
	self.textView.textContainerInset = UIEdgeInsetsMake(10, 8, 8, 8);
	NSString* htmlString = [HelpData getContents:self.index];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
	self.textView.layer.cornerRadius = 10;
	self.textView.layer.masksToBounds = YES;
	self.textView.attributedText = attributedString;
}

- (void) addTop{
	self.topView = [[UITextView alloc] initWithFrame:CGRectZero];
	self.topView.translatesAutoresizingMaskIntoConstraints = NO;
	self.topView.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.topView.backgroundColor = [Appearance grayColor];
	[self.view addSubview:self.topView];
	self.topView.textContainerInset = UIEdgeInsetsMake(10, 8, 8, 8);
	NSString* htmlString = [HelpData getTop:self.index];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
	self.topView.layer.cornerRadius = 10;
	self.topView.layer.masksToBounds = YES;
	self.topView.attributedText = attributedString;
}

- (void) addButton{
	self.progCopyButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.progCopyButton setTitle:@"Load this file!" forState:UIControlStateNormal];
	[self.progCopyButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.progCopyButton];
	self.progCopyButton.frame = CGRectMake(50, 50, 100, 50);
	self.progCopyButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) onClick{
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_LOAD_FROM_HELP withData:[NSNumber numberWithInteger:self.index]];
	[self exit];
}

@end
