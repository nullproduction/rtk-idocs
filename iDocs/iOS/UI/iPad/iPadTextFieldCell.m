//
//  iPadTextFieldCell.m
//  iDoc
//
//  Created by mark2 on 7/5/11.
//  Copyright 2011 KORUS Consulting. All rights reserved.
//

#import "iPadTextFieldCell.h"
#import "Constants.h"

@implementation iPadTextFieldCell

@dynamic placeholderText, valueText, valueTag, delegate;

- (void)setPlaceholderText:(NSString *)text{
    valueEditField.placeholder = text;
}
- (void)setValueText:(NSString *)text{
    valueEditField.text = text;
}
- (NSString *)valueText{
    return valueEditField.text;
}

- (int)valueTag{
    return  valueEditField.tag;
}

- (void)setValueTag:(int)newValueTag{
    valueEditField.tag = newValueTag;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate{
    valueEditField.delegate = delegate;
}
- (id<UITextFieldDelegate>)delegate{
    return valueEditField.delegate;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor clearColor];        
        self.selectionStyle = UITableViewCellSelectionStyleNone;        
        self.clipsToBounds = YES;

		backgroundTiledView = [[iPadPanelBodyBackgroundView alloc] initWithPrefix:@"modal_popup_background" suffix:@"_subbody" tileSize:15];
		backgroundTiledView.userInteractionEnabled = NO;
        backgroundTiledView.frame = self.contentView.bounds;
		[self.contentView addSubview:backgroundTiledView];
		[self.contentView sendSubviewToBack:backgroundTiledView];
        
        valueEditField = [[UITextField alloc] initWithFrame:CGRectInset(self.contentView.bounds,10,15)];
        valueEditField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        valueEditField.font = [UIFont systemFontOfSize:constXLargeFontSize];
        [self.contentView addSubview:valueEditField];
        
    }
    return self;
}
- (void)dealloc {
    valueEditField = nil;
    backgroundTiledView = nil;
    [super dealloc];
}
@end
