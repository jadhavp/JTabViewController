//
//  JTabViewController.h
//  Pods
//
//  Created by Pramod Jadhav on 20/06/16.
//
//

#import <UIKit/UIKit.h>

@interface JTabViewController : UIViewController

/**
 *  Height of tab bar view containing tab bar buttons, its default value is 44.0f
 */
@property (nonatomic, assign) CGFloat tabBarHeight;

/**
 *  Font for tab bar buttons, default value is systemfont with size 16.0f
 */
@property (nonatomic, assign) UIFont * tabBarButtonFont;

/**
 *  Background color of each tab bar button
 */
@property (nonatomic, assign) UIColor * tabBarButtonBgColor;

/**
 *  Tab button text color
 */
@property (nonatomic, assign) UIColor * tabBarButtonTextColor;

/**
 *  Color of selection bar below bar button
 */
@property (nonatomic, assign) UIColor * selectionBarColor;

/**
 *  Instanciate JTabViewController with tab viewcontrollers & text for each tab bar button
 *  if viewControllers & tabTitles count are different it will fail to create JTabViewController instance
 *  @param viewControllers Array of any types of viewcontroller
 *  @param tabTitles       Array of title string for Tab bar buttons
 *
 *  @return instance of JTabViewController
 */
- (instancetype)initWitViewControllers:(NSArray *)viewControllers
                             tabTitles:(NSArray *)tabTitles;

@end
