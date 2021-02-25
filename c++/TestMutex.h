//
//  TestMutex.h
//  HelloWorld-mobile
//
//  Created by mac on 2021/2/25.
//

#ifndef TestMutex_h
#define TestMutex_h

#include <stdio.h>

USING_NS_CC;

class TestMutex : public cocos2d::Layer
{
    int total;//总量
    int selled;//卖出量
public:
    static cocos2d::Scene* createScene();
    virtual bool init();
    CREATE_FUNC(TestMutex);
    
    void threadA();
    void threadB();
};


#endif /* TestMutex_h */
