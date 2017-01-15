//
//  FileManager.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "FacebookService.h"
#import "AppDelegate.h"
#import "ToastUtils.h"
#import "Appearance.h"
#import "MenuViewController.h"
#import "PMenuModel.h"
#import "ImageUtils.h"
#import "Assets.h"
#import "SymmNotifications.h"
#import "Appearance.h"
#import "AlertManager.h"
#import "SignatureViewController.h"
#import "DrawPageViewController.h"
#import "PFileModel.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

typedef void (^CompletionType)(UIImage*);

@interface FacebookService ()

@property AbstractOverlayController* alert;
@property (readwrite,nonatomic,copy) CompletionType completion;

@end

@implementation FacebookService

NSString* const BASE64 = @"data:image/png;base64,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";

+ (id)sharedInstance {
    static FacebookService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

- (void) clickButtonAt:(NSInteger)i withPayload:(id)payload{
	[AlertManager removeAlert];
	if(i == 2){
		// ok
		UIImage* screengrab;
		NSDictionary* dict = (NSDictionary*)payload;
		if(dict){
			BOOL show = [dict[@"show"] boolValue];
			NSString* name = dict[@"name"];
			if(show){
				screengrab = [[FacebookService sharedInstance] getScreenshotWithOptions:@{@"name":name}];
			}
			else{
				screengrab = [[FacebookService sharedInstance] getScreenshotWithOptions:@{}];
			}
		}
		self.completion(screengrab);
	}
	self.completion = nil;
	self.alert = nil;
}

- (void) getScreenshotWithCompletion:(CompletionType) completion{
	AppDelegate* del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
	NSDictionary* options = @{@"buttons":@[@"Ok", TICK_ICON, @"Cancel", CLEAR_ICON], @"title":@"Add your name?"};
	self.alert = [AlertManager addAlert:[SignatureViewController class] intoController:del.rootViewController withDelegate:self withOptions:options];
	self.completion = completion;
}

- (UIImage*) getScreenshotWithOptions:(NSDictionary*)options{
	UIImage* screengrab;
	AppDelegate* del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
	UIFont* font = [Appearance fontOfSize:SYMM_FONT_SIZE_MED];
	UINavigationBar* bar = del.rootViewController.navigationController.navigationBar;
	NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	style.alignment = NSTextAlignmentCenter;
	NSDictionary* attr = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor whiteColor]};
	NSDictionary* d = [Appearance getGrayRGBA];
	float rgb = [[d objectForKey:@"r"] floatValue];
	float a = [[d objectForKey:@"a"] floatValue];
	id<PFileModel> model = [self getFileModel];
	NSString* filename = [model getVal:FILE_FILENAME];
	BOOL real = [[model getVal:FILE_REAL] boolValue];
	if(!real){
		filename = @"'Unsaved file'";
	}
	if(options && options[@"name"] && ((NSString*)options[@"name"]).length >= 1){
		filename = [NSString stringWithFormat:@"'%@' by %@", filename, options[@"name"]];
	}
	CGSize size = bar.frame.size;
	bar.alpha = 0.0001;
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	UIGraphicsBeginImageContext(screenRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	[window.layer renderInContext:ctx];
	CGContextSetRGBFillColor(ctx, rgb, rgb, rgb, a);
	CGRect r = CGRectMake(0.0, 0.0, size.width, size.height);
	CGContextFillRect(ctx, r);
	[filename drawInRect:CGRectMake(0, 3.0, size.width, bar.frame.size.height) withAttributes:attr];
	screengrab = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	bar.alpha = 1;
	return screengrab;
}

- (id<PFileModel>) getFileModel{
	return [[JSObjection defaultInjector] getObject:@protocol(PFileModel)];
}

- (NSString*) getUrl{
	return @"http://bit.ly/1UaC5LH";
}

- (NSString*) getMessageFb{
	return @"Check out what I made learning to code with Logotacular. #logotacular";
}

- (NSString*) getMessageTwitter{
	NSString* text = @"Look what I made learning to code with Logotacular! #logotacular";
	return [NSString stringWithFormat:@"%@ %@", text, [self getUrl]];
}

- (UIViewController*) getViewController{
	AppDelegate* del = (AppDelegate *)[UIApplication sharedApplication].delegate;
	return del.window.rootViewController;
}

- (void) postToSocialNetwork:(UIImage*)img withText:(NSString*) text withCallback:(void(^)(FacebookResults result))callback withServiceType:(NSString *)serviceType{
	UIViewController* presenter = [self getViewController];
	if(!presenter){
		return;
	}
	if([SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController* controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
		[controller setInitialText:text];
        [controller addURL:[NSURL URLWithString:[self getUrl]]];
        [controller addImage:img];
		[controller setCompletionHandler:^(SLComposeViewControllerResult result) {
			if(result == SLComposeViewControllerResultCancelled){
				callback(FacebookResultCancelled);
			}
			else if(result == SLComposeViewControllerResultDone){
				callback(FacebookResultOk);
			}
			[Appearance popupNavigationControllerClosed];
		}];
		[presenter presentViewController:controller animated:YES completion:^{
			[Appearance popupNavigationControllerOpened];
		}];
	}
	else{
		callback(FacebookResultNoFacebook);
	}
}

- (void) postImageToTwitter:(UIImage*)img withCallback:(void(^)(FacebookResults result))callback{
	[self postToSocialNetwork:img withText:[self getMessageTwitter] withCallback:callback withServiceType:SLServiceTypeTwitter];
}

- (void) postImageToFacebook:(UIImage*)img withCallback:(void(^)(FacebookResults result))callback{
	[self postToSocialNetwork:img withText:[self getMessageFb] withCallback:callback withServiceType:SLServiceTypeFacebook];
}

- (void) email:(UIImage*)screengrab{
	if([MFMailComposeViewController canSendMail]) {
		UIViewController* presenter = [self getViewController];
		if(!presenter){
			return;
		}
		UIColor* blue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
		NSData* jpegData = UIImageJPEGRepresentation(screengrab, 1.0);
		MFMailComposeViewController* mailCont = [[MFMailComposeViewController alloc] init];
		[[mailCont navigationBar] setTintColor:blue];
		mailCont.mailComposeDelegate = self;
		[mailCont setSubject:@"Check out what I made using Logotacular"];
		NSString* fileName = @"logotacular";
		fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
		[mailCont addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
		NSString* url = [self getUrl];
		NSString* body = [NSString stringWithFormat:@"<html><body><p>I've been using the <a href='%@'>Logotacular app</a> to learn about coding - check out what I've done!</p><p><a href='%@'><img src='%@'></img></a></p></body></html>", url, url, BASE64];
		[mailCont setMessageBody:body isHTML:YES];
		[presenter presentViewController:mailCont animated:YES completion:^{
			[[UIApplication sharedApplication] keyWindow].tintColor = blue;
		}];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissViewControllerAnimated:YES completion:nil];
	[[UIApplication sharedApplication] keyWindow].tintColor = [UIColor whiteColor];
}

@end

