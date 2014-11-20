//
//  FileCell.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileCell.h"
#import "Appearance.h"
#import "ImageUtils.h"

@interface FileCell()

@property UIImageView* imageView;
@property UILabel* textView;
@property UIView* coverView;
@property NSArray* coverConstraints;

@end

@implementation FileCell

int top = 35;

- (void)prepareForReuse{
	[super prepareForReuse];
	[self updateViews];
}

-  (void) setIsSelected:(BOOL)isSelected{
	_isSelected = isSelected;
	[self updateViews];
}

-  (void) setImage:(UIImage*)img{
	_image = img;
	[self updateViews];
}

-  (void) setFilename:(NSString *)filename{
	_filename = filename;
	[self updateViews];
}

- (void) removeImg{
	if(self.imageView){
		[self.imageView removeFromSuperview];
		self.imageView = nil;
	}
}

- (void) removeText{
	if(self.textView){
		[self.textView removeFromSuperview];
		self.textView = nil;
	}
}

- (void) layoutCover{
	if(self.coverConstraints && [self.coverConstraints count]>=1){
		[self removeConstraints:self.coverConstraints];
		self.coverConstraints = @[];
	}
	float w = [_image size].width;
	float h = [_image size].height;
	CGSize imageSize = CGSizeMake(self.frame.size.width, self.frame.size.height - top);
	CGRect rect = [ImageUtils getRectForRatio:(w/h) inSize:imageSize];
	NSLayoutConstraint* c0 = [NSLayoutConstraint constraintWithItem:self.coverView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView			attribute:NSLayoutAttributeTop multiplier:1.0 constant:rect.origin.y];
	NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:self.coverView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imageView		attribute:NSLayoutAttributeLeading multiplier:1.0 constant:rect.origin.x];
	NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:self.coverView	attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil						attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:rect.size.width];
	NSLayoutConstraint* c3 = [NSLayoutConstraint constraintWithItem:self.coverView	attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil					attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:rect.size.height];
	self.coverConstraints = @[c0, c1, c2, c3];
	[self addConstraints:self.coverConstraints];
}

-  (void) addCoverView{
	if(!self.coverView){
		self.coverView = [[UIView alloc] initWithFrame:CGRectZero];
		self.coverView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.66];
		[self addSubview:self.coverView];
		self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
	}
}

-  (void) addImageView{
	if(!self.imageView){
		self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.imageView];
		self.imageView.backgroundColor = [UIColor clearColor];
		self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self				attribute:NSLayoutAttributeTop multiplier:1.0 constant:top]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView	attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
	}
}

-  (void) addTextView{
	if(!self.textView){
		self.textView = [[UILabel alloc] initWithFrame:self.frame];
		[self.textView setTextAlignment:NSTextAlignmentCenter];
		[self.textView setFont:[Appearance fontOfSize:SYMM_FONT_SIZE_MED]];
		[self.textView setTextColor:[UIColor whiteColor]];
		[self addSubview:self.textView];
		self.textView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView	attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self				attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView	attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView	attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self			attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView	attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil			attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:top]];
	}
}

- (void) updateViews{
	[self addImageView];
	[self addTextView];
	[self addCoverView];
	[self.imageView setImage:_image];
	[self.textView setText:_filename];
	self.alpha = (self.isSelected ? 1 : 0.7);
	self.textView.alpha = (self.isSelected ? 1 : 0.5);
	self.coverView.hidden = self.isSelected;
	[self layoutCover];
}

- (void) dealloc{
	[self removeImg];
	[self removeText];
}

@end


