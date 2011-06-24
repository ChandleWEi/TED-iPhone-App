/*
 The MIT License
 
 Copyright (c) 2010 Peter Ma
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
//
//  SpeakerDetailController.m
//  TEDxTransmedia
//
//  Created by Nyceane on 8/21/10. Updated by Michael May.
//  Copyright 2010 Peter Ma. All rights reserved.
//

#import "TEDxAlcatrazAppDelegate.h"
#import "SpeakerDetailController.h"
#import "TEDxAlcatrazGlobal.h"
#import "CatchNotesLauncher.h"
#import "Base64.h"

#define kSpeakerHtml @"<html> \
<head> \
<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" /> \
<meta name=\"viewport\" content=\"width=320\" /> \
<style type=\"text/css\"> \
	body { \
		background-color:Black; \
		color:#cccccc; \
		margin: 0; \
		padding: 0; \
		font-weight: normal; \
		font-family: Arial, Helvetica, sans-serif; \
	} \
\
	h2 \
	{ \
		margin-bottom:5px \
	} \
\
	/* Speaker Photo */ \
	.speakerphoto \
	{ \
		width:150px; \
		padding:10px; \
		float:left; \
	} \
\
	.speakertitle \
	{ \
		float:left; \
		clear:right; \
		margin:5px; \
	} \
\
	.speakerdescription \
	{ \
		clear:both; \
		padding:20px; \
	} \
\
	/* Content */ \
	.pages \
	{ \
		padding:15px; \
	} \
\
	span.red \
	{ \
		color:Red; \
	} \
\
	#main \
	{ \
		width:100%; \
		padding:10px; \
	} \
\
	#about \
	{ \
		font-size:40px; \
	} \
\
	/*Phones thats smaller than 480px*/ \
	@media only screen and (max-device-width: 480px) { \
\
	.speakerphoto \
	{ \
		width:140px; \
	} \
\
	.speakertitle \
	{ \
		width:150px; \
	} \
\
	.pageimage \
	{ \
		width:300px; \
	} \
	} \
\
	/*Phones thats smaller than 480px*/ \
	@media only screen and (max-device-width: 320px) { \
\
	.speakerphoto \
	{ \
		width:120px; \
	} \
\
	.speakertitle \
	{ \
		width:130px; \
	} \
\
	.pageimage \
	{ \
		width:280px; \
	} \
	} \
</style> \
</head> \
\
<body> \
<div> \
<img id=\"litProfilePhotoUrl\" class=\"speakerphoto\" src=\"data:image/png;base64,%@\" style=\"border-width:0px;\" /> \
<div class=\"speakertitle\"> \
<h3><span id=\"litSpeakerName\">%@</span></h3> \
<span><i>%@</i></span> \
</div> \
<p class=\"speakerdescription\">%@</p> \
</div> \
</body> \
</html>"

@implementation SpeakerDetailController
@synthesize actionControls, speakerToolBar;
#pragma mark -

-(id)initWithSpeaker:(NSDictionary*)speakerJSONDictionary {
	self = [super initWithNibName:@"SpeakerDetailController" bundle:nil];
	
	if(self) {
		speakerDictionary = [speakerJSONDictionary retain];
		self.hidesBottomBarWhenPushed = YES;
	}
	
	return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setColouredBackgroundForWebView:[UIColor blackColor]];	
	self.navigationItem.title = [TEDxAlcatrazGlobal nameStringFromJSONData:speakerDictionary];

	//Set up WebView, just temporary to improve development speed
	/*NSString *urlAddress =	[NSString stringWithFormat:
							@"http://www.tedxapps.com/mobile/speaker/?SpeakerId=%d",
							[TEDxAlcatrazGlobal speakerIdFromJSONData:speakerDictionary]];
	 */
	//[super loadURLString:urlAddress];
	
	
	
	UIImage *userimage;
	
	if ([[TEDxAlcatrazGlobal tempPathForSpeakerImage:speakerDictionary] isEqualToString:@""]) {
		userimage = [UIImage imageNamed:@"default_user.png"];
	}
	else
	{
		userimage = [TEDxAlcatrazGlobal imageForSpeaker:speakerDictionary];
	}
	
	NSData *imageData = UIImageJPEGRepresentation(userimage, 1.0);
	
	[super loadLocalHTMLString:[NSString stringWithFormat:	kSpeakerHtml, 
								[Base64 encodeBase64WithData:imageData],
								[TEDxAlcatrazGlobal nameStringFromJSONData:speakerDictionary],
								[TEDxAlcatrazGlobal titleFromJSONData:speakerDictionary],
								[TEDxAlcatrazGlobal descriptionFromJSONData:speakerDictionary]]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)createCatchNoteWithText:(NSString*)text
{
	[CatchNotesLauncher createNewNoteWithText:text cursorAt:0 
							  bounceOnSave:@"catchted://catch-return/saved" 
							bounceOnCancel:@"catchted://catch-return/cancelled" 
						fromViewController:self];
}


- (void)addTextNote{
	NSMutableString *notes = [NSMutableString string];
	[notes appendString: [TEDxAlcatrazGlobal nameStringFromJSONData:speakerDictionary]];	
	[notes appendString: @"\nTitle:"];
	[notes appendString: [TEDxAlcatrazGlobal titleFromJSONData:speakerDictionary]];	
	[notes appendString: @"\nBio:"];
	[notes appendString: [TEDxAlcatrazGlobal descriptionFromJSONData:speakerDictionary]];

	[notes appendString: @"\n\nWebsite:"];
	[notes appendString: [TEDxAlcatrazGlobal webSiteFromJSONData:speakerDictionary]];
	
	[notes appendString: @"\n\nTwitter:"];
	[notes appendString: [TEDxAlcatrazGlobal twitterFromJSONData:speakerDictionary]];
	
	[notes appendString: @"\n\nMy Notes:"];	
	
	[notes appendString: @"\n\n\n\n_________________________________\nTags: "];
	[notes appendString: CONFERENCE_TAG];

	[self createCatchNoteWithText:notes];
}

- (void)ShowNotes{
	NSMutableString *tags = [NSMutableString string];
	[tags appendString: CONFERENCE_TAG];

	[CatchNotesLauncher showNotesMatchingText:tags fromViewController:self];
}

- (IBAction)switchNote_Clicked:(id)sender{
	switch (actionControls.selectedSegmentIndex) {
		case 0:
			[self addTextNote];
			break;
		case 1:
			[self ShowNotes];
			break;
	}
	[actionControls setSelectedSegmentIndex:-1];
}


#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -

- (void)dealloc {
	[actionControls release];
	[speakerDictionary release];
	[speakerToolBar release];
    [super dealloc];
}


@end
