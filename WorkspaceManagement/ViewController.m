//
//  ViewController.m
//  Workspace Management
//
//  Created by Lyess on 31/03/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    int floor;
}

@synthesize container;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContainerSwipeGesture];
    
    floor = 1;
    
}

- (void)initContainerSwipeGesture
{
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [container addGestureRecognizer:swipeUp];
    [container addGestureRecognizer:swipeDown];
}

- (void)initContainerAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
}

- (void)swipeUp:(UIGestureRecognizer *)swipe
{
    [self initContainerAnimation];
    
    CGRect frame = container.frame;
    switch (floor)
    {
        case (0):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
            floor = 1;
            break;
        case (1):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.3;
            container.frame = frame;
            floor = 2;
            break;
        case (2):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 3;
            container.frame = frame;
            floor = 3;
            break;
        default:
            NSLog(@"Error");
            break;
    }
}

- (void)swipeDown:(UIGestureRecognizer *)swipe
{
    [self initContainerAnimation];
    
    CGRect frame = container.frame;
    switch (floor) {
        case (1):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
            floor = 0;
            break;
        case (2):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.13;
            container.frame = frame;
            floor = 1;
            break;
        case (3):
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) / 1.3;
            container.frame = frame;
            floor = 1;
            break;
        default:
            NSLog(@"Error");
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end