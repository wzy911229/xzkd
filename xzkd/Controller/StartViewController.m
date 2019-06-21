//
//  StartViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/3/6.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    //横屏请设置成 @"Landscape"
    
    NSString *viewOrientation = @"Portrait";
    
    NSString *launchImageName = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary* dict in imagesDict)
        
        {
            
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            
                {
                    
                    launchImageName = dict[@"UILaunchImageName"];
                    
                }
            
        }
    
    UIImage * launchImage = [UIImage imageNamed:launchImageName];
    
    //将当前view的背景图设置为启动图片
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:launchImage];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
