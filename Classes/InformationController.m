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
//  InformationController.m
//  TEDxTransmedia
//
//  Created by Nyceane on 8/12/10. Updated by Michael May.
//  Copyright 2010 Peter Ma. All rights reserved.
//

#import "InformationController.h"
#import "ArchivedViewController.h"
#import "MapController.h"
#import "TEDxAlcatrazGlobal.h"
#import "EventLogic.h"

#define kTEDxMailToSubject @"TEDConference App"
#define kTEDxMailToBody @"Dear Programmer"
#define kTEDxMailToURL @"mailto:%@?subject=iPhone TED Question&body=Dear TED Organiser"


#define kAboutHtml @"<html> \
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
.speakerphoto \
{ \
width:140px; \
} \
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
.speakerphoto \
{ \
width:120px; \
} \
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
<div class=\"pages\"> \
%@ \
</div> \
</body> \
</html>"

@implementation InformationController

@synthesize btnContact, btnCurrent, btnArchive;

#pragma mark -

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Delegate callbacks

- (void)actionMailTo:(NSString*)to subject:(NSString*)subject body:(NSString*)body  {
	if([MFMailComposeViewController canSendMail]) {		
		MFMailComposeViewController* mcvc = [[MFMailComposeViewController alloc] init];
		
		[mcvc setToRecipients:[NSArray arrayWithObject:to]];
		[mcvc setSubject:subject];
        
        [mcvc setSubject:[NSString stringWithFormat:@"%@ for iOS version %@",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]]];
        
		[mcvc setMessageBody:body isHTML:NO];
		[mcvc setMailComposeDelegate:self];

		[self presentModalViewController:mcvc animated:YES];
	} else {
		NSString *mailTo = [NSString stringWithFormat:kTEDxMailToURL, [TEDxAlcatrazGlobal emailAddress]];
		NSString *mailToEncoded = [mailTo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailToEncoded]];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
	
	if(error != nil && error.code != NSUserCancelledError) {
		UIAlertView *mailFailureAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Send Email"
																   message:[error localizedDescription]
																  delegate:nil
														 cancelButtonTitle:@"OK" 
														 otherButtonTitles:nil];
		
		[mailFailureAlert show];
		
		[mailFailureAlert release];
	}
	
	[controller release];
}

#pragma mark -

-(IBAction)btnEmail_Clicked {
	[self actionMailTo:[TEDxAlcatrazGlobal emailAddress] subject:kTEDxMailToSubject body:kTEDxMailToBody];
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    eventAbout = [NSString stringWithFormat:kAboutHtml, [EventLogic getEventAbout:[TEDxAlcatrazGlobal eventIdentifier]]];
    
	[super setColouredBackgroundForWebView:[UIColor blackColor]];	
	[super loadLocalHTMLString:eventAbout];
    
    
    self.navigationItem.title = [TEDxAlcatrazGlobal eventName];
    self.navigationItem.leftBarButtonItem = btnArchive;
    self.navigationItem.rightBarButtonItem = btnContact;
    [pool drain];
}

-(IBAction)btnArchived_Clicked
{
    ArchivedViewController *archivedViewController = [[ArchivedViewController alloc] init];
    [self.navigationController pushViewController:archivedViewController animated:YES];
    [archivedViewController release];
}

#pragma mark -

- (void)dealloc {
	[eventAbout release];
    [btnCurrent release];
    [btnArchive release];
    [super dealloc];
}

@end