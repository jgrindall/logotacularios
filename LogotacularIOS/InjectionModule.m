//
//  InjectionModule.m
//  LogotacularIOS
//
//  Created by John on 27/10/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "InjectionModule.h"
#import "Logger.h"
#import "PLogger.h"
#import "CommandMap.h"
#import "PCommandMap.h"
#import "EventDispatcher.h"
#import "PEventDispatcher.h"
#import "Models.h"
#import "Colors.h"

@interface InjectionModule ()

@property id<PLogger> logger;
@property id<PEventDispatcher> eventDispatcher;
@property id<PCommandMap> commandMap;
@property id<PFileModel> fileModel;
@property id<PProcessingModel> procModel;
@property id<PDrawingModel> drawingModel;
@property id<PLogoModel> logoModel;
@property id<PMenuModel> menuModel;
@property id<POptionsModel> optionsModel;
@property id<PLogoErrorModel> logoErrorModel;
@property id<PFileBrowserModel> browserModel;
@property id<PImgBrowserModel> imgBrowserModel;
@property id<PImgListModel> imgListModel;
@property id<PFileListModel> fileListModel;
@property id<PScreenGrabModel> screenGrabModel;
@property id<PTurtleModel> turtleModel;
@property id<PTextVisibleModel> textVisModel;
@property id<PBgModel> bgModel;

@end

@implementation InjectionModule

- (void)configure {
	[self bindClasses];
}

- (void) bindClasses{
	[self bindUtils];
	[self bindCommandMap];
	[self bindEventDispatcher];
	[self bindModels];
	[self addListeners];
}

- (void) bindUtils{
	self.logger = [[Logger alloc] init];
	[self bind:self.logger toProtocol:@protocol(PLogger)];
}

- (void) bindCommandMap{
	self.commandMap = [[CommandMap alloc] init];
	[self bind:self.commandMap toProtocol:@protocol(PCommandMap)];
}

- (void) bindEventDispatcher{
	self.eventDispatcher = [[EventDispatcher alloc] init];
	[self bind:self.eventDispatcher toProtocol:@protocol(PEventDispatcher)];
}

- (void) addListeners{
	[self.bgModel addListener:@selector(changeBg) forKey:BG_COLOR withTarget:self];
}

- (void) changeBg{
	UIColor* c0 = [Colors getColorForString:[self.bgModel getVal:BG_COLOR]];
	CGFloat r = 0.0, g = 0.0, b = 0.0, a = 1.0;
	BOOL conv = [c0 getRed: &r green: &g blue: &b alpha: &a];
	if(conv){
		float avg = (r + g + b)/3.0;
		if(avg < 128.0){
			[self.optionsModel setToLight];
		}
		else{
			[self.optionsModel setToDark];
		}
	}
}

- (void) bindModels{
	self.fileModel = [[FileModel alloc] init];
	[self bind:self.fileModel toProtocol:@protocol(PFileModel)];
	self.procModel = [[ProcessingModel alloc] init];
	[self bind:self.procModel toProtocol:@protocol(PProcessingModel)];
	self.drawingModel = [[DrawingModel alloc] init];
	[self bind:self.drawingModel toProtocol:@protocol(PDrawingModel)];
	self.logoModel = [[LogoModel alloc] init];
	[self bind:self.logoModel toProtocol:@protocol(PLogoModel)];
	self.menuModel = [[MenuModel alloc] init];
	[self bind:self.menuModel toProtocol:@protocol(PMenuModel)];
	self.optionsModel = [[OptionsModel alloc] init];
	[self bind:self.optionsModel toProtocol:@protocol(POptionsModel)];
	self.logoErrorModel = [[LogoErrorModel alloc] init];
	[self bind:self.logoErrorModel toProtocol:@protocol(PLogoErrorModel)];
	self.browserModel = [[FileBrowserModel alloc] init];
	[self bind:self.browserModel toProtocol:@protocol(PFileBrowserModel)];
	self.imgBrowserModel = [[ImgBrowserModel alloc] init];
	[self bind:self.imgBrowserModel toProtocol:@protocol(PImgBrowserModel)];
	self.imgListModel = [[ImgListModel alloc] init];
	[self bind:self.imgListModel toProtocol:@protocol(PImgListModel)];
	self.fileListModel = [[FileListModel alloc] init];
	[self bind:self.fileListModel toProtocol:@protocol(PFileListModel)];
	self.screenGrabModel = [[ScreenGrabModel alloc] init];
	[self bind:self.screenGrabModel toProtocol:@protocol(PScreenGrabModel)];
	self.turtleModel = [[TurtleModel alloc] init];
	[self bind:self.turtleModel toProtocol:@protocol(PTurtleModel)];
	self.textVisModel = [[TextVisibleModel alloc] init];
	[self bind:self.textVisModel toProtocol:@protocol(PTextVisibleModel)];
	self.bgModel = [[BgModel alloc] init];
	[self bind:self.bgModel toProtocol:@protocol(PBgModel)];
}

@end
