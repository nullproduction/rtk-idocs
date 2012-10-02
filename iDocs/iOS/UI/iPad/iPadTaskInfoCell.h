//
//  iPadTaskInfoCell.h
//  iDoc
//
//  Created by Dmitry Likhachev on 2/22/09.
//  Copyright 2009 KORUS Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFSGradientView.h"

@interface iPadTaskInfoCell: UITableViewCell {
	UILabel *taskIdLabel;
    UIImageView *taskNewIcon;
	UILabel *docTypeNameLabel;
	UILabel *taskStageDueDateLabel;	
	UILabel *docDescLabel;
	UIImageView *taskProcessedStatusIcon;
    HFSGradientView *selectionBack;
	
}

- (void)setTaskId:(NSString *)taskId;
- (void)setTaskViewed:(BOOL)isViewed;
- (void)setDocTypeName:(NSString *)docTypeName;
- (void)setTaskStageDueDate:(NSString *)taskStageDueDate withColor:(UIColor *)color;
- (void)setDocDesc:(NSString *)docDesc;
- (void)setTaskProcessedStatusIcon:(NSString *)imageName;
- (void)setTaskProcessed:(BOOL)checked;
@end
