//
//  MultistagePickerView.m
//  iSee
//
//  Created by 刘琛 on 2019/2/25.
//  Copyright © 2019年 刘琛. All rights reserved.
//

#import "MultistagePickerView.h"
#import "MultistagePickerModel.h"

@interface MultistagePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewButtom;

@property (copy, nonatomic) MultistagePickerViewSuccessBlock success;
@property (copy, nonatomic) MultistagePickerViewFailureBlock fail;

//全部数据列表
@property (nonatomic, strong) NSArray *totalArray;
//项目组的数量
@property (nonatomic, assign) NSInteger componentCount;

//保存选中的数据
@property (nonatomic, strong) NSMutableArray *selectedArray;

//1-2-1 0-0-0
@property (nonatomic, strong) NSString *selectedStr;

//选中行的数组
@property (nonatomic, strong) NSMutableArray *selectedCoordinateArray;
@end


@implementation MultistagePickerView

//显示方法
+ (void)ShowMultistagePickerInView:(UIView *)view dataList:(NSArray *)dataList success:(MultistagePickerViewSuccessBlock)success failure:(MultistagePickerViewFailureBlock)fail {
    
    MultistagePickerView *multistageView = [[[NSBundle mainBundle] loadNibNamed:@"MultistagePickerView" owner:nil options:nil] firstObject];
    multistageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    multistageView.totalArray = dataList;
    multistageView.success = success;
    multistageView.fail = fail;
    [view addSubview:multistageView];
    [multistageView show];
    
}

+ (void)ShowMultistagePickerInView:(UIView *)view dataList:(NSArray *)dataList selectedStr:(NSString *)selectedStr success:(MultistagePickerViewSuccessBlock)success failure:(MultistagePickerViewFailureBlock)fail {
    
    MultistagePickerView *multistageView = [[[NSBundle mainBundle] loadNibNamed:@"MultistagePickerView" owner:nil options:nil] firstObject];
    multistageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    multistageView.selectedStr = selectedStr;
    multistageView.totalArray = dataList;
    multistageView.success = success;
    multistageView.fail = fail;
    [view addSubview:multistageView];
    [multistageView show];
    
}

#pragma mark 页面初始化

- (void)awakeFromNib {
    [super awakeFromNib];
    _componentCount = 0;
    _picker.delegate = self;
    _picker.dataSource = self;
    _selectedArray = [NSMutableArray array];
    _selectedCoordinateArray = [NSMutableArray array];
}


#pragma mark 数据源

- (void)setTotalArray:(NSArray *)totalArray {
    _totalArray = totalArray;
    self.componentCount = [self getCountFromArray:_totalArray];
    [self setDefaultSelectedArray];
    [self.picker reloadAllComponents];
}

- (void)setDefaultSelectedArray {
    NSArray *array = [MultistagePickerModel mj_objectArrayWithKeyValuesArray:_totalArray];
    _selectedCoordinateArray = [NSMutableArray arrayWithArray:[_selectedStr componentsSeparatedByString:@"-"]];
    [_selectedArray removeAllObjects];
    if (_selectedCoordinateArray.count < _componentCount) {
        for (int i = 0; i < _componentCount; i++) {
            if (i >= _selectedCoordinateArray.count) {
                [_selectedCoordinateArray addObject:@"0"];
            }
        }
    }
    
    for (int i = 0; i < _selectedCoordinateArray.count; i++) {
        if (i == 0) {
            MultistagePickerModel *first = array[i];
            [_selectedArray addObject:first];
        }else {
            MultistagePickerModel *model = _selectedArray.lastObject;
            MultistagePickerModel *nextModel = model.child[i];
            [_selectedArray addObject:nextModel];
        }
    }
}


#pragma mark picker代理

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _totalArray.count;
    }else {
        MultistagePickerModel *model = _selectedArray[component - 1];
        return model.child.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _componentCount;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSDictionary *firstDic = _totalArray[row];
        return firstDic[@"configName"];
    }else {
        MultistagePickerModel *model = _selectedArray[component];
        return model.configName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        MultistagePickerModel *model = [MultistagePickerModel mj_objectWithKeyValues:_totalArray[row]];
        [_selectedArray replaceObjectAtIndex:0 withObject:model];
        [_selectedCoordinateArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld", (long)row]];
    }else {
        MultistagePickerModel *model = _selectedArray[component - 1];
        MultistagePickerModel *selectedModel = model.child[row];
        [_selectedArray replaceObjectAtIndex:component withObject:selectedModel];
        [_selectedCoordinateArray replaceObjectAtIndex:component withObject:[NSString stringWithFormat:@"%ld", (long)row]];
    }
    if (component != _componentCount - 1) {
        [self resetSelectePickerViewStates:component];
    }
}

- (void)resetSelectePickerViewStates:(NSInteger) component {
    if (component < _selectedArray.count - 1) {
        for (NSInteger i = component + 1; i < _selectedCoordinateArray.count; i++) {
            MultistagePickerModel *model = _selectedArray[i - 1];
            //后续排列复位
            [_selectedCoordinateArray replaceObjectAtIndex:i withObject:@"0"];
            [_selectedArray replaceObjectAtIndex:i withObject:model.child.firstObject];
            [_picker reloadComponent:i];
            [_picker selectRow:[_selectedCoordinateArray[i] integerValue] inComponent:i animated:YES];
        }
    }
}

#pragma mark 页面显示隐藏

- (void)show {
    
    [self layoutIfNeeded];
    
    self.baseViewButtom.constant = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
    for (int i = 0; i < _selectedCoordinateArray.count; i++) {
        [_picker selectRow:[_selectedCoordinateArray[i] integerValue] inComponent:i animated:YES];
    }
}

- (void)dismiss {
    self.baseViewButtom.constant = -235;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark 按钮点击事件
- (IBAction)cancelButtonAction:(id)sender {
    if (self.fail) {
        self.fail();
    }
    [self dismiss];
}
- (IBAction)okButtonAction:(id)sender {
    if (self.success) {
        self.success([_selectedCoordinateArray componentsJoinedByString:@"-"], [self getResultArray]);
    }
    [self dismiss];
}

- (NSArray *)getResultArray {
    NSMutableArray *array = [NSMutableArray array];
    for (MultistagePickerModel *model in _selectedArray) {
        [array addObject:model.configCode];
    }
    return [NSArray arrayWithArray:array];
}

#pragma mark 判断Dic是否包含Key

- (BOOL)dictionaryContainKeyString:(NSDictionary *) dic KeyString:(NSString *) keyString {
    if([[dic allKeys] containsObject:keyString]) {
        
        id obj = [dic objectForKey:keyString];// judge NSNull
        
        return ![obj isEqual:[NSNull null]];
        
    }else {
        return NO;
    }
}

- (NSInteger)getCountForDic:(NSDictionary *) dic {
    
    NSArray *children = dic[@"child"];
    if (children == nil || children.count == 0) {
        return 1;
    }
    NSInteger maxCount = 0;
    for (NSDictionary *dic  in children) {
        maxCount = MAX([self getCountForDic:dic] + 1, maxCount);
    }
    return maxCount;
}

- (NSInteger)getCountFromArray:(NSArray *) array {
    if (array.count == 0) {
        return 0;
    }
    NSInteger maxCount = 1;
    for (NSDictionary *dic in array) {
        if ([self dictionaryContainKeyString:dic KeyString:@"child"]) {
            NSArray *children = dic[@"child"];
            maxCount = MAX([self getCountFromArray:children] + 1, maxCount);
        }
    }
    return maxCount;
}


@end
