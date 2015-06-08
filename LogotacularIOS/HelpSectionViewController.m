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
#import "Assets.h"

@interface HelpSectionViewController ()

@property UIButton* progCopyButton;
@property UITextView* textView;
@property UITextView* topView;
@property (strong) MPMoviePlayerViewController* videoController;
@property UIImageView* imgView;
@property UITapGestureRecognizer* tap;
@property BOOL videoPlaying;
@property NSURL* videoUrl;

@end

@implementation HelpSectionViewController

- (void) addChildren{
	self.videoPlaying = NO;
	[super addChildren];
	[self addText];
	[self addImage];
	[self addTop];
	[self addButton];
}

- (void) addImage{
	self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
	self.imgView.contentMode = UIViewContentModeScaleAspectFit;
	NSString* media = [HelpData getHelpMedia:self.index];
	self.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/%@", media]];
	[self.view addSubview:self.imgView];
	[self.imgView setUserInteractionEnabled:YES];
	self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
	self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
	[self.imgView addGestureRecognizer:self.tap];
}

- (void) onTap{
	[self addMedia];
}

- (void) addMedia{
	NSString* extension = @".mp4";
	NSString* file = [NSString stringWithFormat:@"assets/%@", [HelpData getHelpMovie:self.index]];
	file = [file stringByReplacingOccurrencesOfString:extension withString:@""];
	NSString* path = [[NSBundle mainBundle] pathForResource:file ofType:extension];
	if(self.videoPlaying){
		[self removeVideo];
	}
	if(path){
		self.videoUrl = [NSURL fileURLWithPath:path isDirectory:NO];
		self.videoController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.videoUrl];
		[self.videoController.moviePlayer setShouldAutoplay:YES];
		self.videoController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoController.moviePlayer];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMovie:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.videoController.moviePlayer];
		[self presentViewController:self.videoController animated:NO completion:nil];
		[self.videoController.moviePlayer prepareToPlay];
		[self.videoController.moviePlayer play];
		self.videoPlaying = YES;
	}
}

- (void) layoutAll{
	[super layoutAll];
	[self layoutButton];
	[self layoutText];
	[self layoutImg];
	[self layoutTop];
}

- (void) layoutImg{
	float p = 10;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textView			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-p]];
}

- (void)layoutTop{
	float p = 10;
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeTop multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeLeading multiplier:1.0 constant:p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view					attribute:NSLayoutAttributeHeight multiplier:(1 - HELP_LAYOUT_FRAC) constant:-p]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view				attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-p]];
}

- (void) layoutButton{
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.progCopyButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:185.0]];
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
	self.textView.scrollEnabled = NO;
	self.textView.editable = NO;
	self.textView.font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	self.textView.backgroundColor = [Appearance grayColor];
	[self.view addSubview:self.textView];
	self.textView.textContainerInset = UIEdgeInsetsMake(6, 5, 5, 5);
	NSString* htmlString = [HelpData getHelpContents:self.index];
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
	self.topView.textContainerInset = UIEdgeInsetsMake(6, 5, 5, 5);
	NSString* htmlString = [HelpData getHelpTop:self.index];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
	self.topView.layer.cornerRadius = 10;
	self.topView.layer.masksToBounds = YES;
	self.topView.scrollEnabled = NO;
	self.topView.editable = NO;
	self.topView.attributedText = attributedString;
}

- (void) addButton{
	self.progCopyButton = [UIButton buttonWithType:UIButtonTypeSystem];
	[self.progCopyButton setTitle:@"Load this file!" forState:UIControlStateNormal];
	[self.progCopyButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	[self.progCopyButton setImage:[UIImage imageNamed:RIGHT_ICON] forState:UIControlStateNormal];
	self.progCopyButton.imageEdgeInsets = UIEdgeInsetsMake(0, 136, 0, 0);
	self.progCopyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60);
	[self.view addSubview:self.progCopyButton];
	self.progCopyButton.frame = CGRectZero;
	self.progCopyButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) onClick{
	NSString* file = [HelpData getHelpFile:self.index];
	[[self getEventDispatcher] dispatch:SYMM_NOTIF_LOAD_FROM_HELP withData:file];
	[self exit];
}

- (void) movieFinishedCallback:(NSNotification*)aNotification{
	[self removeVideo];
}

-(void) playMovie:(NSNotification*) notification{
	MPMoviePlayerController *player = self.videoController.moviePlayer;
	if (player.loadState & MPMovieLoadStatePlayable){
		[player play];
	}
}

-(void) removeVideo{
	if (![self.videoController isBeingDismissed]){
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoController.moviePlayer];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:self.videoController.moviePlayer];
		[self dismissMoviePlayerViewControllerAnimated];
		self.videoPlaying = NO;
	}
}

- (void) dealloc{
	[self.progCopyButton removeTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	[self.progCopyButton removeFromSuperview];
	self.progCopyButton = nil;
	[self.textView removeFromSuperview];
	self.textView = nil;
	[self.topView removeFromSuperview];
	self.topView = nil;
	[self.imgView removeFromSuperview];
	self.imgView = nil;
	[self.imgView removeGestureRecognizer:self.tap];
	if(self.videoPlaying){
		[self removeVideo];
	}
}

@end
