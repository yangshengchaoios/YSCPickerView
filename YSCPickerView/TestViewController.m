//
//  TestViewController.m
//  YSCPickerView
//
//  Created by YangShengchao on 15/4/5.
//  Copyright (c) 2015年 YangShengchao. All rights reserved.
//

#import "TestViewController.h"
#import "YSCPickerView.h"

#define ViewInXib(_xibName, _index)     [[[NSBundle mainBundle] loadNibNamed:(_xibName) owner:nil options:nil] objectAtIndex:(_index)]
#define FirstViewInXib(_xibName)        ViewInXib(_xibName, 0)

#define KeyWindow                       [UIApplication sharedApplication].keyWindow

@interface TestViewController ()

@property (strong, nonatomic) YSCPickerView *yscPickerView;
@property (strong, nonatomic) RegionModel *regionModel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *showDatePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *showTimePickerButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAddressPickerButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view resetFontSizeOfView];
    [self.view resetConstraintOfView];
    self.dateLabel.text = nil;
    self.timeLabel.text = nil;
    self.addressLabel.text = nil;

    self.yscPickerView = FirstViewInXib(@"YSCPickerView");
    self.yscPickerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.yscPickerView];
    
    [UIView makeRoundForView:self.showDatePickerButton withRadius:5];
    [UIView makeBorderForView:self.showDatePickerButton withColor:[UIColor blueColor] borderWidth:1];
    [UIView makeRoundForView:self.showTimePickerButton withRadius:5];
    [UIView makeBorderForView:self.showTimePickerButton withColor:[UIColor blueColor] borderWidth:1];
    [UIView makeRoundForView:self.showAddressPickerButton withRadius:5];
    [UIView makeBorderForView:self.showAddressPickerButton withColor:[UIColor blueColor] borderWidth:1];
    
    WeakSelfType blockSelf = self;
    self.yscPickerView.completionShowBlock = ^{
        CGFloat offsetY = blockSelf.yscPickerView.containerView.height - (blockSelf.view.height - AUTOLAYOUT_LENGTH(260));
        blockSelf.scrollView.contentOffset = CGPointMake(0, MAX(0, offsetY));
    };
    self.yscPickerView.completionHideBlock = ^{
        blockSelf.scrollView.contentOffset = CGPointMake(0, 0);
    };
}

- (IBAction)showDatePickerButtonClicked:(id)sender {
    WeakSelfType blockSelf = self;
    self.yscPickerView.selectingBlock = ^(id selectingObject) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        blockSelf.dateLabel.text = [dateFormatter stringFromDate:(NSDate *)selectingObject];
    };
    [self.yscPickerView setPickerType:YSCPickerTypeDate];
    [self.yscPickerView showPickerView:nil];
}
- (IBAction)showTimePickerButtonClicked:(id)sender {
    WeakSelfType blockSelf = self;
    self.yscPickerView.selectingBlock = ^(id selectingObject) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        blockSelf.timeLabel.text = [dateFormatter stringFromDate:(NSDate *)selectingObject];
    };
    NSDate *initDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-1000];
    [self.yscPickerView setPickerType:YSCPickerTypeTime];
    [self.yscPickerView showPickerView:initDate];
}
- (IBAction)showAddressPickerButtonClicked:(id)sender {
    WeakSelfType blockSelf = self;
    self.yscPickerView.selectingBlock = ^(id selectingObject) {
        blockSelf.regionModel = (RegionModel *)selectingObject;
        blockSelf.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                                       blockSelf.regionModel.province,
                                       blockSelf.regionModel.city,
                                       blockSelf.regionModel.section];
    };
    [self.yscPickerView setPickerType:YSCPickerTypeAddress];
    [self.yscPickerView showPickerView:self.regionModel];
}


@end
