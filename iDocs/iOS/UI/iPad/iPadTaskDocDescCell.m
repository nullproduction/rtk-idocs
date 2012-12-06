//
//  iPadTaskDocDescCell.m
//  iDoc
//
//  Created by Dmitry Likhachev on 1/31/10.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import "iPadTaskDocDescCell.h"
#import "Constants.h"
#import "iPadThemeBuildHelper.h"

@implementation iPadTaskDocDescCell

- (id)initWithStyle:(UITableViewCellStyle)UITableViewCellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		docTypeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 5.0f, self.contentView.bounds.size.width - 18.0f, 15.0f)];
		docTypeNameLabel.hidden = NO;
		docTypeNameLabel.opaque = YES;
		docTypeNameLabel.enabled = YES;
		docTypeNameLabel.textAlignment = UITextAlignmentLeft;
		docTypeNameLabel.textColor = [iPadThemeBuildHelper commonTextFontColor1];	
		docTypeNameLabel.font = [UIFont boldSystemFontOfSize:constMediumFontSize];
		docTypeNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		docTypeNameLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:docTypeNameLabel];
		
		docDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 22.0f, self.contentView.bounds.size.width - 18.0f, 43.0f)];
		docDescLabel.hidden = NO;
		docDescLabel.opaque = YES;
		docDescLabel.enabled = YES;
		docDescLabel.numberOfLines = 3;
		docDescLabel.lineBreakMode = UILineBreakModeTailTruncation;
		docDescLabel.textAlignment = UITextAlignmentLeft;
		docDescLabel.textColor = [iPadThemeBuildHelper commonTextFontColor2];		
		docDescLabel.font = [UIFont systemFontOfSize:constMediumFontSize];
		docDescLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;			
		docDescLabel.backgroundColor = [UIColor clearColor];
		[[self contentView] addSubview:docDescLabel];		
    }
    return self;
}

- (void)setDocTypeName:(NSString *)docTypeName {
	docTypeNameLabel.text = docTypeName;	
}

- (void)setDocDesc:(NSString *)docDesc {
	docDescLabel.text = docDesc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {	
	[docTypeNameLabel release];
	[docDescLabel release];
    
    [super dealloc];
}


@end
