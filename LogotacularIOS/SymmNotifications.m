//
//  SymmNotifications.m
//  Symmetry
//
//  Created by John on 19/05/2014.
//  Copyright (c) 2014 jgrindall. All rights reserved.
//

#import "SymmNotifications.h"

@implementation SymmNotifications

NSString* const SYMM_NOTIF_SHOW_SPINNER =		@"Symm::showSpinner";
NSString* const SYMM_NOTIF_CLEAR_QUEUE =		@"Symm::clrQueue";
NSString* const SYMM_NOTIF_HIDE_SPINNER =		@"Symm::hideSpinner";
NSString* const SYMM_NOTIF_CLICK_CAMERA =		@"Symm:clickCam";
NSString* const SYMM_NOTIF_CLICK_MENU =			@"Symm::menu";
NSString* const SYMM_NOTIF_CLICK_GRID_MENU =	@"Symm::gridmenu";
NSString* const SYMM_NOTIF_HIDE_MENU =			@"Symm::hideMenu";
NSString* const SYMM_NOTIF_HIDE_GRID_MENU =		@"Symm::hideGridMenu";
NSString* const SYMM_NOTIF_CLICK_PLAY =			@"Symm::clickPlay";
NSString* const SYMM_NOTIF_CLICK_TUT =			@"Symm::clickTut";
NSString* const SYMM_NOTIF_CLICK_NEW =			@"Symm::clickNew";
NSString* const SYMM_NOTIF_START =				@"Symm::start";
NSString* const SYMM_NOTIF_RESTART =			@"Symm::restart";
NSString* const SYMM_NOTIF_RESTART_QUEUE =		@"Symm::restartQueue";
NSString* const SYMM_NOTIF_PARSE =				@"Symm::parse";
NSString* const SYMM_NOTIF_TRI =				@"Symm::triangle";
NSString* const SYMM_NOTIF_HIDE_TRI =			@"Symm::hidetriangle";
NSString* const SYMM_NOTIF_CLICK_RESET_ZOOM =	@"Symm::resetZoom";
NSString* const SYMM_NOTIF_CLICK_WIPE =			@"Symm::wipe";
NSString* const SYMM_NOTIF_CLICK_TRI =			@"Symm::tri";
NSString* const SYMM_NOTIF_CLICK_GRID =			@"Symm::grid";
NSString* const SYMM_NOTIF_STOP =				@"Symm::stop";
NSString* const SYMM_NOTIF_CLICK_EXAMPLES =		@"Symm::clickExamples";
NSString* const SYMM_NOTIF_CLICK_REF =			@"Symm::clickRef";
NSString* const SYMM_NOTIF_SHARE =				@"Symm::share";
NSString* const SYMM_NOTIF_CLICK_HELP =			@"Symm::clickHelp";
NSString* const SYMM_NOTIF_RESET =				@"Symm::reset";
NSString* const SYMM_NOTIF_UNDO =				@"Symm::undo";
NSString* const SYMM_NOTIF_REDO =				@"Symm::redo";
NSString* const SYMM_NOTIF_INSERT_CHAR =		@"Symm::insertchar";
NSString* const SYMM_NOTIF_DO_INSERT_CHAR =		@"Symm::doinsertchar";
NSString* const SYMM_NOTIF_LOAD =				@"Symm::load";
NSString* const SYMM_NOTIF_RESET_ZOOM =			@"Symm::resetzoom";
NSString* const SYMM_NOTIF_SAVE =				@"Symm::save";
NSString* const SYMM_NOTIF_CLICK_SAVE_AS =		@"Symm::saveas";
NSString* const SYMM_NOTIF_CLEAR =				@"Symm::clear";
NSString* const SYMM_NOTIF_DISMISS_KEY =		@"Symm::dismissKey";
NSString* const SYMM_NOTIF_CLICK_OPEN =			@"Symm::clickOpen";
NSString* const SYMM_NOTIF_CLICK_IMG =			@"Symm::clickImg";
NSString* const SYMM_NOTIF_LOAD_FILES =			@"Symm::loadFiles";
NSString* const SYMM_NOTIF_LOAD_IMGS =			@"Symm::loadImgs";
NSString* const SYMM_NOTIF_PERFORM_OPEN =		@"Symm::performOpen";
NSString* const SYMM_NOTIF_PERFORM_OPEN_IMG =	@"Symm::performOpenImg";
NSString* const SYMM_NOTIF_PERFORM_DEL =		@"Symm::performDel";
NSString* const SYMM_NOTIF_PERFORM_DEL_IMG =	@"Symm::performDelImg";
NSString* const SYMM_NOTIF_PERFORM_ADD_IMG =	@"Symm::performAddImg";
NSString* const SYMM_NOTIF_PERFORM_SAVE =		@"Symm::performSave";
NSString* const SYMM_NOTIF_DRAWING_STARTED =	@"Symm::drawStarted";
NSString* const SYMM_NOTIF_DRAWING_FINISHED =	@"Symm::drawFinished";
NSString* const SYMM_NOTIF_PERFORM_SAVE_AS =	@"Symm::performSaveAs";
NSString* const SYMM_NOTIF_CLICK_SAVE =			@"Symm:clickSave";
NSString* const SYMM_NOTIF_SHOW_FILENAME =		@"Symm::showFilename";
NSString* const SYMM_NOTIF_SHOW_FILENAME_AS =	@"Symm::showFilenameAs";
NSString* const SYMM_NOTIF_TEXT_EDITED =		@"Symm:textEdited";
NSString* const SYMM_NOTIF_FILE_LOADED =		@"Symm:fileLoaded";
NSString* const SYMM_NOTIF_IMG_LOADED =			@"Symm:imgLoaded";
NSString* const SYMM_NOTIF_SCREENGRAB =			@"Symm:screengrab";
NSString* const SYMM_NOTIF_CHECK_SAVE =			@"Symm:checkSave";
NSString* const SYMM_NOTIF_PERFORM_NEW =		@"Symm:performNew";
NSString* const SYMM_NOTIF_SAVED =				@"Symm:saved";
NSString* const SYMM_NOTIF_ERROR_HIT =			@"Symm:errorHit";
NSString* const SYMM_NOTIF_SYNTAX_ERROR =		@"Symm:syntaxError";
NSString* const SYMM_NOTIF_SYNTAX_CHECK =		@"Symm:syntaxCheck";
NSString* const SYMM_NOTIF_SHOW_POPOVER =		@"Symm:showPopover";
NSString* const SYMM_NOTIF_HIDE_POPOVER =		@"Symm:hidePopover";
NSString* const SYMM_NOTIF_CHANGE_PAGE =		@"Symm:changePage";
NSString* const SYMM_NOTIF_PERFORM_FILE_SETUP =	@"Symm:performFileSetup";
NSString* const SYMM_NOTIF_LOAD_FROM_HELP =		@"Symm:loadFromHelp";
NSString* const SYMM_NOTIF_EDIT_FONT_SIZE =		@"Symm:editFontSize";
NSString* const SYMM_NOTIF_EDIT_GRID_TYPE =		@"Symm:editGridType";
NSString* const SYMM_NOTIF_EDIT_GRID_OPACITY =	@"Symm:editGridOpacity";

@end
