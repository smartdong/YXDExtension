//
//  YXDFilterView.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDFilterView.h"
#import "UIImage+YXDExtension.h"
#import "UIButton+YXDExtension.h"

@interface YXDFilterViewData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray<NSString *> *rowTitles;

@property (nonatomic, assign) BOOL hasSpecialRow;
@property (nonatomic, strong) NSString *specialRowTitle;

@end

@implementation YXDFilterViewData

@end

static NSString *kCellIdentifier                        = @"cell";
static const CGFloat kAnimationDuration                 = 0.15f;

static const CGFloat kYXDFilterViewDefaultRowHeight     = 50.f;
static const NSInteger kYXDFilterViewDefaultFontSize    = 14;

#define kYXDFilterViewDefaultNormalTitleColor           [UIColor lightGrayColor]
#define kYXDFilterViewDefaultSelectedTitleColor         [UIColor orangeColor]

@interface YXDFilterView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) __kindof UIView *superView;
@property (nonatomic, weak) id<YXDFilterViewDelegate> delegate;

@property (nonatomic, strong) UIControl *backgroundView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *headerButtons;
@property (nonatomic, strong) NSMutableArray<YXDFilterViewData *> *sectionsData;

@property (nonatomic, assign) NSInteger currentSelectedSection;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,NSNumber *> *selectedRowsMap;// section : selected index (special row == -1)

@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@end

@implementation YXDFilterView

#pragma mark - Filter View Methods

+ (instancetype)filterViewWithSuperView:(__kindof UIView *)superView delegate:(id<YXDFilterViewDelegate>)delegate {
    if (!superView || !delegate) {
        return nil;
    }
    
    YXDFilterView *filterView = [[YXDFilterView alloc] initWithFrame:CGRectMake(0, 0, superView.bounds.size.width, kYXDFilterViewDefaultRowHeight)];
    filterView.superView = superView;
    filterView.delegate = delegate;
    filterView.backgroundColor = [UIColor whiteColor];
    [filterView reload];
    [superView addSubview:filterView];
    [superView bringSubviewToFront:filterView];
    return filterView;
}

- (void)reload {
    if ([self.delegate respondsToSelector:@selector(numberOfSectionsInFilterView:)]) {
        self.sectionCount = [self.delegate numberOfSectionsInFilterView:self];
    } else {
        self.sectionCount = 1;
    }
    
    if (self.sectionCount < 1) {
        NSLog(@"%@ error : section count < 1 .",self.class);
        return;
    }
    
    //初始化数据
    [self dataInit];
    
    //重新调整自己的高度
    self.frame = CGRectMake(0, 0, self.superView.frame.size.width, self.rowHeight);
    
    //删除之前的按钮
    if (self.headerButtons) {
        for (UIButton *btn in self.headerButtons) {
            [btn removeFromSuperview];
        }
        [self.headerButtons removeAllObjects];
    } else {
        self.headerButtons = [NSMutableArray array];
    }
    
    //创建按钮
    CGFloat widthSum = 0;//记录当前按钮总宽度
    UIImage *originImage = [UIImage imageNamed:@"img_filterview_downarrow"];
    UIImage *normalImage = [originImage tintWithColor:self.normalTitleColor];
    UIImage *selectedImage = [originImage tintWithColor:self.selectedTitleColor];
    
    for (NSInteger section = 0; section < self.sectionCount; section++) {
        //每个按钮的宽度
        CGFloat widthPer = 0;
        
        if ([self.delegate respondsToSelector:@selector(filterView:headerWidthPercentageInSection:)]) {
            widthPer = [self.delegate filterView:self headerWidthPercentageInSection:section];
        }
        
        if ((widthPer <= 0) || (widthPer > 1)) {
            widthPer = 1. / self.sectionCount;
        }
        
        //创建按钮
        CGFloat buttonWidth = self.frame.size.width * widthPer;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(widthSum, 0, buttonWidth, self.frame.size.height)];
        widthSum += buttonWidth;
        button.tag = section;
        button.titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        [button setTitle:self.sectionsData[section].title forState:UIControlStateNormal];
        [button setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        [button setImage:normalImage forState:UIControlStateNormal];
        [button setImage:selectedImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.adjustsImageWhenHighlighted = NO;
        [button setImageAlignment:UIButtonImageAlignmentRight];
        [self addSubview:button];
        [self.headerButtons addObject:button];
    }
    
    //创建背景遮罩
    if (!self.backgroundView) {
        self.backgroundView = [[UIControl alloc] initWithFrame:self.superView.bounds];
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.backgroundView addTarget:self action:@selector(backgroundViewTouchAction) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundView.hidden = YES;
        [self.superView insertSubview:self.backgroundView belowSubview:self];
    } else {
        self.backgroundView.frame = self.superView.bounds;
    }
    
    //创建选项 tableview
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.hidden = YES;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [self.superView insertSubview:self.tableView aboveSubview:self];
    } else {
        self.tableView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0);
    }
    
    [self reset];
}

- (void)reset {
    self.selectedRowsMap = [NSMutableDictionary dictionary];
    
    [self backgroundViewTouchAction];
    
    [self.headerButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitle:self.sectionsData[idx].title forState:UIControlStateNormal];
        obj.selected = NO;
    }];
}

- (NSInteger)selectedRowInSection:(NSInteger)section {
    NSNumber *rowIndex = [self.selectedRowsMap objectForKey:@(section)];
    if (rowIndex) {
        return [rowIndex integerValue];
    }
    return NSNotFound;
}

#pragma mark - Private

- (void)dataInit {
    if ([self.delegate respondsToSelector:@selector(rowHeightForFilterView:)]) {
        self.rowHeight = [self.delegate rowHeightForFilterView:self];
    } else {
        self.rowHeight = kYXDFilterViewDefaultRowHeight;
    }
    
    if ([self.delegate respondsToSelector:@selector(titleFontSizeForFilterView:)]) {
        self.titleFontSize = [self.delegate titleFontSizeForFilterView:self];
    } else {
        self.titleFontSize = kYXDFilterViewDefaultFontSize;
    }
    
    if ([self.delegate respondsToSelector:@selector(normalTitleColorForFilterView:)]) {
        self.normalTitleColor = [self.delegate normalTitleColorForFilterView:self];
    } else {
        self.normalTitleColor = kYXDFilterViewDefaultNormalTitleColor;
    }
    
    if ([self.delegate respondsToSelector:@selector(selectedTitleColorForFilterView:)]) {
        self.selectedTitleColor = [self.delegate selectedTitleColorForFilterView:self];
    } else {
        self.selectedTitleColor = kYXDFilterViewDefaultSelectedTitleColor;
    }
    
    self.sectionsData = [NSMutableArray arrayWithCapacity:self.sectionCount];
    
    for (NSInteger section = 0; section < self.sectionCount; section++) {
        YXDFilterViewData *data = [YXDFilterViewData new];
        data.title = [self.delegate filterView:self titleForHeaderInSection:section];
        
        NSInteger rowCount = [self.delegate filterView:self numberOfRowsInSection:section];
        if (rowCount > 0) {
            data.rowTitles = [NSMutableArray arrayWithCapacity:rowCount];
            for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
                [data.rowTitles addObject:([self.delegate filterView:self titleForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:section]]?:@"")];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(filterView:specialRowTitleInSection:)]) {
            NSString *specialRowTitle = [self.delegate filterView:self specialRowTitleInSection:section];
            if (specialRowTitle.length) {
                data.hasSpecialRow = YES;
                data.specialRowTitle = specialRowTitle;
            }
        }
        
        [self.sectionsData addObject:data];
    }
}

- (void)backgroundViewTouchAction {
    [self setTableViewHidden:YES];
    [self setBackgroundViewHidden:YES];
    
    [self.headerButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self setButton:obj arrowUp:NO];
    }];
}

- (void)headerButtonAction:(UIButton *)button {
    if (button.selected && !self.backgroundView.hidden) {
        [self backgroundViewTouchAction];
        return;
    }
    
    [self.headerButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        [self setButton:obj arrowUp:NO];
    }];
    
    button.selected = YES;
    [self setButton:button arrowUp:YES];
    
    self.currentSelectedSection = button.tag;
    
    [self setTableViewHidden:NO];
    [self setBackgroundViewHidden:NO];
    
    [self.tableView reloadData];
}

- (void)setButton:(UIButton *)button arrowUp:(BOOL)arrowUp {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (arrowUp) {
        transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        button.imageView.transform = transform;
    }];
}

- (void)setTableViewHidden:(BOOL)hidden {
    CGRect frame = self.tableView.frame;
    
    if (hidden) {
        frame.size.height = 0;
    } else {
        self.tableView.hidden = hidden;
        
        NSInteger rowCount = self.sectionsData[self.currentSelectedSection].rowTitles.count + (self.sectionsData[self.currentSelectedSection].hasSpecialRow?1:0);
        CGFloat height = rowCount * self.rowHeight;
        CGFloat maxHeight = self.superView.bounds.size.height - self.tableView.frame.origin.y - self.rowHeight;
        if (height > maxHeight) {
            height = maxHeight;
            self.tableView.scrollEnabled = YES;
            [self.tableView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0];
        } else {
            self.tableView.scrollEnabled = NO;
        }
        frame.size.height = height;
    }
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.tableView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.tableView.hidden = hidden;
                     }];
}

- (void)setBackgroundViewHidden:(BOOL)hidden {
    if (self.backgroundView.hidden == hidden) {
        return;
    }
    
    if (!hidden) {
        self.backgroundView.hidden = hidden;
    }
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.backgroundView.alpha = hidden?0:1;
                     }
                     completion:^(BOOL finished) {
                         self.backgroundView.hidden = hidden;
                     }];
}

#pragma mark - Table View Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self backgroundViewTouchAction];
    
    YXDFilterViewData *data = self.sectionsData[self.currentSelectedSection];
    
    //设置标题
    NSString *buttonTitle = nil;
    if (data.hasSpecialRow) {
        if (indexPath.row == 0) {
            buttonTitle = data.title;
        } else {
            buttonTitle = data.rowTitles[indexPath.row - 1];
        }
    } else {
        buttonTitle = data.rowTitles[indexPath.row];
    }
    [self.headerButtons[self.currentSelectedSection] setTitle:buttonTitle forState:UIControlStateNormal];
    
    //记录选择的 row index
    [self.selectedRowsMap setObject:@(data.hasSpecialRow?(indexPath.row-1):indexPath.row) forKey:@(self.currentSelectedSection)];
    
    if ([self.delegate respondsToSelector:@selector(filterView:didSelectRowAtIndexPath:isSpecialRow:)]) {
        if (data.hasSpecialRow) {
            if (indexPath.row == 0) {
                [self.delegate filterView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:self.currentSelectedSection] isSpecialRow:YES];
            } else {
                [self.delegate filterView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:self.currentSelectedSection] isSpecialRow:NO];
            }
        } else {
            [self.delegate filterView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:self.currentSelectedSection] isSpecialRow:NO];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
    
    YXDFilterViewData *data = self.sectionsData[self.currentSelectedSection];
    NSNumber *selectedRowIndex = [self.selectedRowsMap objectForKey:@(self.currentSelectedSection)];
    
    NSString *title = nil;
    UIColor *color = nil;
    
    if (data.hasSpecialRow) {
        if (indexPath.row == 0) {
            title = data.specialRowTitle;
        } else {
            title = data.rowTitles[indexPath.row - 1];
        }
        
        if (selectedRowIndex && (selectedRowIndex.integerValue == (indexPath.row - 1))) {
            color = self.selectedTitleColor;
        } else {
            color = self.normalTitleColor;
        }
    } else {
        title = data.rowTitles[indexPath.row];
        
        if (selectedRowIndex && (selectedRowIndex.integerValue == indexPath.row)) {
            color = self.selectedTitleColor;
        } else {
            color = self.normalTitleColor;
        }
    }
    
    cell.textLabel.text = title;
    cell.textLabel.textColor = color;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsCount = self.sectionsData[self.currentSelectedSection].rowTitles.count;
    if (self.sectionsData[self.currentSelectedSection].hasSpecialRow) {
        rowsCount++;
    }
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

@end
