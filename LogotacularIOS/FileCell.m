//
//  FileCell.m
//  Symmetry
//
//  Created by John on 20/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FileCell.h"
#import "Appearance.h"

@interface FileCell()

@property UIImageView* imageView;
@property UILabel* textView;

@end

@implementation FileCell

- (void)prepareForReuse{
	[super prepareForReuse];
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

-  (void) addImageView{
	if(!self.imageView){
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.imageView];
	}
}

-  (void) addTextView{
	if(!self.textView){
		self.textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
		[self.textView setTextAlignment:NSTextAlignmentCenter];
		[self.textView setFont:[Appearance fontOfSize:SYMM_FONT_SIZE_SMALL]];
		[self.textView setTextColor:[UIColor whiteColor]];
		[self addSubview:self.textView];
	}
}

- (void) updateViews{
	[self addImageView];
	[self addTextView];
	[self.imageView setImage:_image];
	[self.textView setText:_filename];
}

- (void) dealloc{
	[self removeImg];
	[self removeText];
}

@end
