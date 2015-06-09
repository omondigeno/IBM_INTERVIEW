//
//  MainViewController.m
//  IBMtaskDW
//
//  Created by Geno on 6/8/15.
//  Copyright (c) 2015 Geno. All rights reserved.
//

#import "MainViewController.h"
#import "CommonViews.h"
#import "Constants.h"
#import "Utils.h"
#import "MmAppDelegate.h"
#import "ViewTags.h"
#import "EColumnChart.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>
#import "JSONKit.h"

@interface MainViewController ()

@property (nonatomic, assign)  CGFloat standardWidth;
@property (nonatomic, strong) NSMutableArray *tabsArray;
@property (nonatomic, strong) NSNumber *tabsSelectedItem;

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (strong, nonatomic) EColumnChart *eColumnChart2;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *data2;
@property (nonatomic, strong) EFloatBox *eFloatBox;
@property (nonatomic, strong) EFloatBox *eFloatBox2;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) EColumn *eColumnSelected2;
@property (nonatomic, strong) UIColor *tempColor;
@property (nonatomic, assign) BOOL columnTapped;
@property (nonatomic, assign) BOOL columnTapped2;
@property (nonatomic, assign) NSInteger currentChart;

@end

@implementation MainViewController
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize eColumnChart = _eColumnChart;
@synthesize data = _data;
@synthesize eColumnSelected = _eColumnSelected;
@synthesize eFloatBox2 = _eFloatBox2;
@synthesize eColumnChart2 = _eColumnChart2;
@synthesize data2 = _data2;
@synthesize eColumnSelected2 = _eColumnSelected2;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    MmNavigationViewController *navigationController = (MmNavigationViewController*)self.parentViewController;
    
    self.navigationItem.titleView = [CommonViews logo:[UIApplication sharedApplication].statusBarOrientation];
    
    self.title = @"Home";
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect wholeScreenRect = [[UIScreen mainScreen] bounds];
    
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        self.standardWidth = screenRect.size.width-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2);
        
    }else{
        self.standardWidth = wholeScreenRect.size.height-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2);
        
    }
        
    [self.view addSubview:[CommonViews imageView:@"activity_background.png" frame:CGRectMake(0.0f, - navigationController.navigationBar.bounds.size.height, screenRect.size.width, screenRect.size.height ) topInset:0 leftInset:0 bottomInset:0 rightInset:0]];
    
    [self setupViews];

}

- (void)setupViews {
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    MmNavigationViewController *navigationController = (MmNavigationViewController*)self.parentViewController;
    
    UILabel *categoryLabel = [CommonViews subtitleLabelView:@"Health Data per County in Kenya" frame:CGRectMake(LAYOUT_LEFT_OUTER_X_POS, 12.0f, screenRect.size.width-((LAYOUT_STANDARD_VIEW_MARGIN_IPHONE+LAYOUT_INNER_CONTAINER_VIEW_MARGIN_IPHONE)*2), LAYOUT_VIEW_HEIGHT)];
    
    [self.view addSubview:categoryLabel];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(LAYOUT_LEFT_OUTER_X_POS, LAYOUT_Y_POSITION_AFTER_TITLE, self.view.frame.size.width-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2), self.view.frame.size.height-LAYOUT_Y_POSITION_AFTER_TITLE - navigationController.navigationBar.bounds.size.height )];
    
    containerView.tag = TAG_ROOT_VIEW;
    
    [self.view addSubview:containerView];
    
    [containerView addSubview:[self setupCategoriesTabs]];
    
    UIView *horizontalTab = (UIView *)[self.view viewWithTag:TAG_HORIZONTAL_TAB];
    
    
    UIView *graphsContainerBg	= [[UIView alloc] initWithFrame:CGRectMake(LAYOUT_LEFT_INNER_X_POS, horizontalTab.frame.origin.y+horizontalTab.frame.size.height, screenRect.size.width-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2), containerView.frame.size.height-horizontalTab.frame.size.height-LAYOUT_STANDARD_VIEW_MARGIN_IPHONE)];
    graphsContainerBg.tag = TAG_GRAPHS_CONTAINER_BG;
    [CommonViews roundView:graphsContainerBg onCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:LAYOUT_CONTENT_BG_CORNER_RADIUS];

    [containerView addSubview:graphsContainerBg];
    
    UIView *graphsContainer	= [[UIView alloc] initWithFrame:CGRectMake(LAYOUT_LEFT_INNER_X_POS, horizontalTab.frame.origin.y+horizontalTab.frame.size.height, screenRect.size.width-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2), containerView.frame.size.height-horizontalTab.frame.size.height-LAYOUT_STANDARD_VIEW_MARGIN_IPHONE)];
    graphsContainer.tag = TAG_GRAPHS_CONTAINER;
    
    [containerView addSubview:graphsContainer];
    
    [graphsContainer addSubview:[self createGraph1]];
    [graphsContainer addSubview:[self createGraph2]];
    
}

- (UIView*) createGraph1 {
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    
    UIView *graphContainer1	= [[UIView alloc] initWithFrame:CGRectMake(LAYOUT_LEFT_INNER_X_POS, LAYOUT_LEVEL_2_VIEW_START_Y_POS, screenRect.size.width-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2), 420.0f)];
    graphContainer1.tag = TAG_GRAPH_1;
    
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    
    NSData *jsonData = [Utils readFileData:@"physicians_density" type:@"json"];
    
    NSArray *dataArray = [jsonDecoder objectWithData:jsonData];
    
    int i = 0;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *data in dataArray)
    {
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%@", [data objectForKey:@"label"]] value:[[data objectForKey:@"value"] floatValue] index:i unit:@""];
        [temp addObject:eColumnDataModel];
        i++;
    }
    _data = [NSArray arrayWithArray:temp];
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(31.0f, LAYOUT_INNER_INNER_CONTAINER_VIEW_MARGIN_IPHONE+20, graphContainer1.frame.size.width - 32.0f, graphContainer1.frame.size.height-20)];
   
    _currentChart = TAG_CHART_1;
    _eColumnChart.tag = TAG_CHART_1;
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    [_eColumnChart setShowHorizontalLabelsWithInteger:NO];
    [_eColumnChart setShowHighAndLowColumnWithColor:NO];
    
    _eColumnChart.backgroundColor = [UIColor clearColor];
    
    [graphContainer1 addSubview: _eColumnChart];
    
    return graphContainer1;
}

- (UIView*) createGraph2 {
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    
    UIView *graphContainer2	= [[UIView alloc] initWithFrame:CGRectMake(LAYOUT_LEFT_INNER_X_POS, LAYOUT_LEVEL_2_VIEW_START_Y_POS, screenRect.size.width-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2), 600)];
    graphContainer2.tag = TAG_GRAPH_2;
    graphContainer2.alpha = 0.0f;
    
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    
    NSData *jsonData = [Utils readFileData:@"nets_n_illness" type:@"json"];
    
    NSArray *dataArray = [jsonDecoder objectWithData:jsonData];
    
    int i = 0;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *data in dataArray)
    {
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%@", [data objectForKey:@"label"]] value:[[data objectForKey:@"value"] floatValue] index:i unit:@"%"];
        [temp addObject:eColumnDataModel];
        i++;
    }
    _data2 = [NSArray arrayWithArray:temp];
    
    _eColumnChart2 = [[EColumnChart alloc] initWithFrame:CGRectMake(31.0f, LAYOUT_INNER_INNER_CONTAINER_VIEW_MARGIN_IPHONE+20, graphContainer2.frame.size.width - 32.0f, graphContainer2.frame.size.height-200)];
    
    _currentChart = TAG_CHART_2;
    _eColumnChart2.tag = TAG_CHART_2;
    [_eColumnChart2 setColumnsIndexStartFromLeft:YES];
    [_eColumnChart2 setDelegate:self];
    [_eColumnChart2 setDataSource:self];
    [_eColumnChart2 setShowHorizontalLabelsWithInteger:NO];
    [_eColumnChart2 setShowHighAndLowColumnWithColor:NO];
    
    _eColumnChart2.backgroundColor = [UIColor clearColor];

    [graphContainer2 addSubview: _eColumnChart2];
    
    UIView *series1  = [[UIView alloc] initWithFrame:CGRectMake(LAYOUT_INNER_INNER_CONTAINER_VIEW_MARGIN_IPHONE, _eColumnChart2.frame.size.height+100, 20, 20)];
    series1.backgroundColor = [UIColor colorWithRed:255.0f/256.0f green:82.0f/256.0f blue:5.0f/256.0f alpha:1.0f];
    [graphContainer2 addSubview:series1];
    
    [graphContainer2 addSubview:[CommonViews labelView:@"Percentage that Slept under a Mosquito Net" frame:CGRectMake(LAYOUT_INNER_INNER_CONTAINER_VIEW_MARGIN_IPHONE+25, _eColumnChart2.frame.size.height+100, 350, 20)]];

    UIView *series2  = [[UIView alloc] initWithFrame:CGRectMake(LAYOUT_INNER_INNER_CONTAINER_VIEW_MARGIN_IPHONE, _eColumnChart2.frame.size.height+125, 20, 20)];
    series2.backgroundColor = [UIColor blackColor];
    [graphContainer2 addSubview:series2];
    
    [graphContainer2 addSubview:[CommonViews labelView:@"Percentage that had Fever or Malaria" frame:CGRectMake(LAYOUT_INNER_INNER_CONTAINER_VIEW_MARGIN_IPHONE+25, _eColumnChart2.frame.size.height+125, 350, 20)]];
    
    return graphContainer2;
}

- (EasyTableView*)setupCategoriesTabs {
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    CGRect frameRect	= CGRectMake(LAYOUT_LEFT_INNER_X_POS, LAYOUT_LEVEL_2_VIEW_START_Y_POS, screenRect.size.width-((LAYOUT_STANDARD_VIEW_MARGIN_IPHONE)*2), LAYOUT_HORIZONTAL_TAB_BUTTON_HEIGHT);
	EasyTableView *horizontalView	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:2 ofWidth:LAYOUT_HORIZONTAL_TAB_BUTTON_WIDTH_WIDE];
	
	horizontalView.delegate						= self;
	horizontalView.tableView.backgroundColor	= [UIColor clearColor];
	horizontalView.tableView.allowsSelection	= YES;
	horizontalView.tableView.separatorColor		= [UIColor clearColor];
	horizontalView.cellBackgroundColor			= [UIColor clearColor];
	horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleWidth;
    horizontalView.tag = TAG_HORIZONTAL_TAB;
    
    [self setTabsArray: [[NSMutableArray alloc] init]];
    [self.tabsArray addObject:@"Physicians Density"];
    [self.tabsArray addObject:@"Mosquito Nets & Illness"];
    
    [self setTabsSelectedItem:[NSNumber numberWithInteger:0]];
    
    return horizontalView;
    
}

#pragma mark EasyTableViewDelegate

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
    return [CommonViews horizontalTabButton:self selector:@selector(handleSelectionTab:) frame:rect];
}

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
	UIButton *button	= (UIButton *)view;
    [button setTitle:[self.tabsArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    if([self.tabsSelectedItem integerValue] != indexPath.row){
        [CommonViews setHorizontalTabButtonBg:button selected:FALSE];
    }else{
        [CommonViews setHorizontalTabButtonBg:button selected:TRUE];
    }
}

- (void) handleSelectionTab:(UIButton *)sender {
    EasyTableView *easyTableView = (EasyTableView *)[self.view viewWithTag:TAG_HORIZONTAL_TAB];
    NSIndexPath *indexPath = [easyTableView indexPathForView:sender];
    
    UIView *graphsContainer = (UIView *)[self.view viewWithTag:TAG_GRAPHS_CONTAINER];
    
    if([self.tabsSelectedItem integerValue] > indexPath.row){
        [self swipeRightOuter:[[graphsContainer subviews] objectAtIndex:indexPath.row] rightTabView:[[graphsContainer subviews] objectAtIndex:[self.tabsSelectedItem integerValue]]];
    }else if([self.tabsSelectedItem integerValue] < indexPath.row){
        [self swipeLeftOuter:[[graphsContainer subviews] objectAtIndex:[self.tabsSelectedItem integerValue]] rightTabView:[[graphsContainer subviews] objectAtIndex:indexPath.row]];
    }
    
    [self setTabsSelectedItem:[NSNumber numberWithInteger:indexPath.row]];
    [easyTableView reloadData];
}

- (void)swipeLeftOuter:(UIView *)leftTabView rightTabView:(UIView *)rightTabView
{
    
    [rightTabView setFrame:CGRectMake(self.standardWidth, rightTabView.frame.origin.y, rightTabView.frame.size.width, rightTabView.frame.size.height)];
    
    [UIView beginAnimations:@"swipeLeft" context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    
    [leftTabView setFrame:CGRectMake(-self.standardWidth, leftTabView.frame.origin.y, leftTabView.frame.size.width, leftTabView.frame.size.height)];
    [rightTabView setFrame:CGRectMake(LAYOUT_LEFT_INNER_X_POS, rightTabView.frame.origin.y, rightTabView.frame.size.width, rightTabView.frame.size.height)];
    leftTabView.alpha = 0.0f;
    rightTabView.alpha = 1.0f;
    
    
    [UIView commitAnimations];
}

- (void)swipeRightOuter:(UIView *)leftTabView rightTabView:(UIView *)rightTabView
{
    
    [leftTabView setFrame:CGRectMake(-self.standardWidth, leftTabView.frame.origin.y, leftTabView.frame.size.width, leftTabView.frame.size.height)];
    
    [UIView beginAnimations:@"swipeRight" context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    
    [rightTabView setFrame:CGRectMake(self.standardWidth, rightTabView.frame.origin.y, rightTabView.frame.size.width, rightTabView.frame.size.height)];
    [leftTabView setFrame:CGRectMake(LAYOUT_LEFT_INNER_X_POS, leftTabView.frame.origin.y, leftTabView.frame.size.width, leftTabView.frame.size.height)];
    leftTabView.alpha = 1.0f;
    rightTabView.alpha = 0.0f;
    
    
    [UIView commitAnimations];
}

/** How many Columns are there in total.*/
- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart
{
    if(eColumnChart.tag== TAG_CHART_1){
    return [_data count];
    }else{
        return [_data2 count];
    }
}

/** How many Columns should be presented on the screen each time*/
- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart
{
    if(eColumnChart.tag== TAG_CHART_1){
        return [_data count];
    }else{
        return [_data2 count];
    }
}

/** The highest value among the whole chart*/
- (EColumnDataModel *)     highestValueEColumnChart:(EColumnChart *) eColumnChart
{
    if(eColumnChart.tag== TAG_CHART_1){
   EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
    }
    else{
        EColumnDataModel *maxDataModel = nil;
        float maxValue = -FLT_MIN;
        for (EColumnDataModel *dataModel in _data2)
        {
            if (dataModel.value > maxValue)
            {
                maxValue = dataModel.value;
                maxDataModel = dataModel;
            }
        }
        return maxDataModel;
    }
}

/** Value for each column*/
- (EColumnDataModel *)     eColumnChart:(EColumnChart *) eColumnChart
                          valueForIndex:(NSInteger)index
{
    if(eColumnChart.tag== TAG_CHART_1){
   if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
    }
    else{
        if (index >= [_data2 count] || index < 0) return nil;
        return [_data2 objectAtIndex:index];
    }
}

- (UIColor *)colorForEColumn:(EColumn *)eColumn
{
    
   if(_currentChart== TAG_CHART_1){
 NSInteger maxIndex, minIndex;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxIndex = dataModel.index;
        }
    }
    float minValue = FLT_MAX;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value < minValue)
        {
            minValue = dataModel.value;
            minIndex = dataModel.index;
        }
    }
    if(eColumn.eColumnDataModel.index == maxIndex){
        return [UIColor blackColor];
    }else if(eColumn.eColumnDataModel.index == minIndex){
        return [UIColor colorWithRed:253.0f/256.0f green:139.0f/256.0f blue:3.0f/256.0f alpha:1.0f];
    }
    return [UIColor colorWithRed:255.0f/256.0f green:82.0f/256.0f blue:5.0f/256.0f alpha:1.0f];
    }
    else{
        if(eColumn.eColumnDataModel.index % 2 == 1){
            return [UIColor blackColor];
        }else{
        return [UIColor colorWithRed:255.0f/256.0f green:82.0f/256.0f blue:5.0f/256.0f alpha:1.0f];
        }
    }
}


/** When finger single taped the column*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
             didSelectColumn:(EColumn *) eColumn
{
    if(eColumnChart.tag== TAG_CHART_1){
    if(!_columnTapped || eColumn.eColumnDataModel.index != _eColumnSelected.eColumnDataModel.index){
        _columnTapped = YES;
        CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
        CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
        if (_eFloatBox)
        {
            [_eFloatBox removeFromSuperview];
            _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
            _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:eColumn.eColumnDataModel.unit title:eColumn.eColumnDataModel.label];
            [_eFloatBox setTextColor:[UIColor blackColor]];
            [_eFloatBox setBackgroundColor:[UIColor whiteColor]];
            [eColumnChart addSubview:_eFloatBox];
        }
        else
        {
            _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:eColumn.eColumnDataModel.unit title:eColumn.eColumnDataModel.label];
            _eFloatBox.alpha = 0.0;
            [_eFloatBox setTextColor:[UIColor blackColor]];
            [_eFloatBox setBackgroundColor:[UIColor whiteColor]];
            [eColumnChart addSubview:_eFloatBox];
            
        }
        eFloatBoxX = eColumn.frame.origin.x -  _eFloatBox.frame.size.width + (eColumn.frame.size.width * 2) ;
        eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 1.0;
            
        } completion:^(BOOL finished) {
        }];
    }else{
        _columnTapped = NO;
        if (_eFloatBox)
        {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                _eFloatBox.alpha = 0.0;
                _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
            } completion:^(BOOL finished) {
                [_eFloatBox removeFromSuperview];
                _eFloatBox = nil;
            }];
            
        }
    }
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor whiteColor];
    }else{
        if(!_columnTapped2 || eColumn.eColumnDataModel.index != _eColumnSelected2.eColumnDataModel.index){
            _columnTapped2 = YES;
            CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
            CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
            if (_eFloatBox2)
            {
                [_eFloatBox2 removeFromSuperview];
                _eFloatBox2.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox2.frame.size.width, _eFloatBox2.frame.size.height);
                _eFloatBox2 = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:eColumn.eColumnDataModel.unit title:eColumn.eColumnDataModel.label];
                [_eFloatBox2 setTextColor:[UIColor blackColor]];
                [_eFloatBox2 setBackgroundColor:[UIColor whiteColor]];
                [eColumnChart addSubview:_eFloatBox2];
            }
            else
            {
                _eFloatBox2 = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:eColumn.eColumnDataModel.unit title:eColumn.eColumnDataModel.label];
                _eFloatBox2.alpha = 0.0;
                [_eFloatBox2 setTextColor:[UIColor blackColor]];
                [_eFloatBox2 setBackgroundColor:[UIColor whiteColor]];
                [eColumnChart addSubview:_eFloatBox2];
                
            }
            eFloatBoxX = eColumn.frame.origin.x -  _eFloatBox2.frame.size.width + (eColumn.frame.size.width * 2) ;
            eFloatBoxY -= (_eFloatBox2.frame.size.height + eColumn.frame.size.width * 0.25);
            _eFloatBox2.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox2.frame.size.width, _eFloatBox2.frame.size.height);
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                _eFloatBox2.alpha = 1.0;
                
            } completion:^(BOOL finished) {
            }];
        }else{
            _columnTapped2 = NO;
            if (_eFloatBox2)
            {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                    _eFloatBox2.alpha = 0.0;
                    _eFloatBox2.frame = CGRectMake(_eFloatBox2.frame.origin.x, _eFloatBox2.frame.origin.y + _eFloatBox2.frame.size.height, _eFloatBox2.frame.size.width, _eFloatBox2.frame.size.height);
                } completion:^(BOOL finished) {
                    [_eFloatBox2 removeFromSuperview];
                    _eFloatBox2 = nil;
                }];
                
            }
        }
        if (_eColumnSelected2)
        {
            _eColumnSelected2.barColor = _tempColor;
        }
        _eColumnSelected2 = eColumn;
        _tempColor = eColumn.barColor;
        eColumn.barColor = [UIColor whiteColor];
    }
}

/** When finger enter specific column, this is dif from tap*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidEnterColumn:(EColumn *) eColumn
{
 
}

/** When finger leaves certain column, will tell you which column you are leaving*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidLeaveColumn:(EColumn *) eColumn
{
    NSLog(@"Finger did leave %d", eColumn.eColumnDataModel.index);
}

/** When finger leaves wherever in the chart, will trigger both if finger is leaving from a column */
- (void) fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.navigationItem.titleView = [CommonViews logo:toInterfaceOrientation];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        self.standardWidth = screenRect.size.width-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2);
        
    }else{
        self.standardWidth = screenRect.size.height-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2);
        
    }
    
    [self adjustLayout:toInterfaceOrientation];
}
- (void)adjustLayout:(UIInterfaceOrientation)toInterfaceOrientation {
    
    UIView *graphsContainerBg = (UIView *)[self.view viewWithTag:TAG_GRAPHS_CONTAINER_BG];
    graphsContainerBg.frame = CGRectMake(graphsContainerBg.frame.origin.x, graphsContainerBg.frame.origin.y, self.standardWidth, graphsContainerBg.frame.size.height);
    [CommonViews roundView:graphsContainerBg onCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:LAYOUT_CONTENT_BG_CORNER_RADIUS];
    
    UIView *graphsContainer = (UIView *)[self.view viewWithTag:TAG_GRAPHS_CONTAINER];
    graphsContainer.frame = CGRectMake(graphsContainer.frame.origin.x, graphsContainer.frame.origin.y, self.standardWidth, graphsContainer.frame.size.height);
    
    UIView *graphContainer1 = (UIView *)[self.view viewWithTag:TAG_GRAPH_1];
graphContainer1.frame = CGRectMake(graphContainer1.frame.origin.x, graphContainer1.frame.origin.y, self.standardWidth, graphContainer1.frame.size.height);
    
    [_eColumnChart removeFromSuperview];
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(_eColumnChart.frame.origin.x, _eColumnChart.frame.origin.y, graphContainer1.frame.size.width - 32.0f, _eColumnChart.frame.size.height)];
    
    _currentChart = TAG_CHART_1;
    _eColumnChart.tag = TAG_CHART_1;
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    [_eColumnChart setShowHorizontalLabelsWithInteger:NO];
    [_eColumnChart setShowHighAndLowColumnWithColor:NO];
    
    _eColumnChart.backgroundColor = [UIColor clearColor];
    
    [graphContainer1 addSubview: _eColumnChart];
    
    UIView *graphContainer2 = (UIView *)[self.view viewWithTag:TAG_GRAPH_2];
graphContainer2.frame = CGRectMake(graphContainer2.frame.origin.x, graphContainer2.frame.origin.y, self.standardWidth, graphContainer2.frame.size.height);
    
    [_eColumnChart2 removeFromSuperview];
    _eColumnChart2 = [[EColumnChart alloc] initWithFrame:CGRectMake(_eColumnChart2.frame.origin.x, _eColumnChart2.frame.origin.y, graphContainer2.frame.size.width - 32.0f, _eColumnChart2.frame.size.height)];
    
    _currentChart = TAG_CHART_2;
    _eColumnChart2.tag = TAG_CHART_2;
    [_eColumnChart2 setColumnsIndexStartFromLeft:YES];
    [_eColumnChart2 setDelegate:self];
    [_eColumnChart2 setDataSource:self];
    [_eColumnChart2 setShowHorizontalLabelsWithInteger:NO];
    [_eColumnChart2 setShowHighAndLowColumnWithColor:NO];
    
    _eColumnChart2.backgroundColor = [UIColor clearColor];
    
    [graphContainer2 addSubview: _eColumnChart2];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   UIApplication* application = [UIApplication sharedApplication];
   
    MmAppDelegate *appDelegate = (MmAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.window.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:166.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [appDelegate setNavigationBarBg];
    self.navigationItem.titleView = [CommonViews logo:[UIApplication sharedApplication].statusBarOrientation];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
 if(application.statusBarOrientation == UIInterfaceOrientationPortrait || application.statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        self.standardWidth = screenRect.size.width-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2);
        
    }else{
        self.standardWidth = screenRect.size.height-(LAYOUT_STANDARD_VIEW_MARGIN_IPHONE*2);
        
    }
    [self adjustLayout:application.statusBarOrientation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // You do not need this method if you are not supporting earlier iOS Versions
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
