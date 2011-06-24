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
//  ScheduleController.m
//  TEDxTransmedia
//
//  Created by Nyceane on 8/12/10. Updated by Michael May.
//  Copyright 2010 Peter Ma. All rights reserved.
//

#import "ScheduleController.h"
#import "EventLogic.h"
#import "TEDxAlcatrazGlobal.h"

#define kTEDxAppsEventURL @"http://www.tedxapps.com/mobile/schedule/?EventId=%i"

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


@implementation ScheduleController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    eventAbout = [NSString stringWithFormat:kAboutHtml, [EventLogic getEventAbout:[TEDxAlcatrazGlobal eventIdentifier]]];
    
	[super setColouredBackgroundForWebView:[UIColor blackColor]];	
	[super loadLocalHTMLString:eventAbout];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -

- (void)dealloc {
	[eventAbout release];
    [super dealloc];
}

@end
