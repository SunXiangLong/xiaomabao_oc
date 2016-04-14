//
//  MBCheckBox.m
//  XiaoMaBao
//
//  Created by 郝人 on 15/9/25.
//  Copyright (c) 2015年 HuiBei. All rights reserved.
//
#import "MBCheckBox.h"


@implementation MBCheckBox
@synthesize label,icon,value,delegate;
-( id )initWithFrame:( CGRect ) frame
{
    if ( self =[ super initWithFrame : frame ]) {
        icon =[[ UIImageView alloc ] initWithFrame :
               CGRectMake ( 10 , 0 , frame . size . height , frame . size . height )];
        [ self setStyle : CheckButtonStyleDefault ]; // 默认风格为方框（多选）样式
        //self.backgroundColor=[UIColor grayColor];
        [ self addSubview : icon ];
        label =[[ UILabel alloc ] initWithFrame : CGRectMake ( icon . frame . size . width + 24 , 0 ,
                                                              frame . size . width - icon . frame . size . width - 24 ,
                                                              frame . size . height )];
        label . backgroundColor =[ UIColor clearColor ];
        label . font =[ UIFont fontWithName : @"Arial" size : 20 ];
        label . textColor =[ UIColor
                            colorWithRed : 0xf9 / 255.0
                            green : 0xd8 / 255.0
                            blue : 0x67 / 255.0
                            alpha : 1 ];
        label . textAlignment = UITextAlignmentLeft ;
        [ self addSubview : label ];
        [ self addTarget : self action : @selector ( clicked ) forControlEvents :UIControlEventTouchUpInside ];
    }
    return self ;
}
-( CheckButtonStyle )style{
    return style ;
}
-( void )setStyle:( CheckButtonStyle )st{
    style =st;
    switch ( style ) {
        case CheckButtonStyleDefault :
        case CheckButtonStyleBox :
            checkname = @"checked.png" ;
            uncheckname = @"unchecked.png" ;
            break ;
        case CheckButtonStyleRadio :
            checkname = @"radio.png" ;
            uncheckname = @"unradio.png" ;
            break ;
        default :
            break ;
    }
    [ self setChecked : checked ];
}
-( BOOL )isChecked{
    return checked ;
}
-( void )setChecked:( BOOL )b{
    if (b!= checked ){
        checked =b;
    }
    if ( checked ) {
        [ icon setImage :[ UIImage imageNamed : checkname ]];
    } else {
        [ icon setImage :[ UIImage imageNamed : uncheckname ]];
    }
}
-( void )clicked{
    [ self setChecked :! checked ];
    if ( delegate != nil ) {
        SEL sel= NSSelectorFromString ( @"checkButtonClicked" );
        if ([ delegate respondsToSelector :sel]){
            [ delegate performSelector :sel];
        } 
    }
}
-( void )dealloc{
    value = nil ; delegate = nil ;
}
@end
