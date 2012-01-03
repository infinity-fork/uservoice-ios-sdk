//
//  UVInfoViewController.m
//  UserVoice
//
//  Created by Scott Rutherford 05/26/10
//  Copyright 2010 UserVoice Inc. All rights reserved.
//

#import "UVInfoViewController.h"
#import "UVConfig.h"
#import "UVSession.h"
#import "UVInfo.h"
#import "UVStyleSheet.h"
#import "UVClientConfig.h"

#define UV_INFO_SECTION_ABOUT 0
#define UV_INFO_SECTION_MOTIVATION 1

@implementation UVInfoViewController

- (void)didRetrieveInfo:(UVInfo *)someInfo {
	[self hideActivityIndicator];
	[UVSession currentSession].info = someInfo;
	[self loadView];
}

#pragma mark ===== UITableViewDataSource Methods =====

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = @"";
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	
	if (indexPath.section == UV_INFO_SECTION_ABOUT) {
		identifier = @"About";
		
	} else if (indexPath.section >= UV_INFO_SECTION_MOTIVATION) {
		identifier = @"Motivation";
	}
	
	return [self createCellForIdentifier:identifier
							   tableView:tableView
							   indexPath:indexPath
								   style:style
							  selectable:NO];
}

- (NSInteger)labelHeightWithText:(NSString *)text {
    return [text sizeWithFont:[UIFont systemFontOfSize:14]
            constrainedToSize:CGSizeMake([UVClientConfig getScreenWidth] - 40, 100000)
                lineBreakMode:UILineBreakModeWordWrap].height;
}

- (UILabel *)labelWithText:(NSString *)text {
	CGFloat screenWidth = [UVClientConfig getScreenWidth];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, (screenWidth-40), [self labelHeightWithText:text])] autorelease];
	label.lineBreakMode = UILineBreakModeWordWrap;	
	label.numberOfLines = 0;
	label.font = [UIFont systemFontOfSize:14];
	label.text = text;
	label.textColor = [UVStyleSheet tableViewHeaderColor];
    return label;
}

- (void)initCellForAbout:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	UILabel *label = [self labelWithText:[UVSession currentSession].info.about_body];
	[cell.contentView addSubview:label];
}

- (void)initCellForMotivation:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	UILabel *label = [self labelWithText:[UVSession currentSession].info.motivation_body];
	[cell.contentView addSubview:label];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

#pragma mark ===== UITableViewDelegate Methods =====

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = (indexPath.section == UV_INFO_SECTION_ABOUT) ? [UVSession currentSession].info.about_body : [UVSession currentSession].info.motivation_body;
    return 20 + [self labelHeightWithText:text];
}

#pragma mark ===== Basic View Methods =====

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	// see if we already have the info object loaded
	if ([UVSession currentSession].info == nil) {
		[self showActivityIndicator];
 		[UVInfo getWithDelegate:self];
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.navigationItem.title = @"UserVoice";
	
	CGRect frame = [self contentFrame];
	
	UITableView *theTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
	theTableView.dataSource = self;
	theTableView.delegate = self;
	//theTableView.backgroundColor = [UIColor clearColor];
    theTableView.backgroundColor = [UVStyleSheet lightBgColor];
	
	self.tableView = theTableView;
	[theTableView release];
	
	self.view = tableView;
}

- (void)viewDidUnload {
	self.tableView = nil;
    [super viewDidUnload];
}

@end
