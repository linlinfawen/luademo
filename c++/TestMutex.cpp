//
//  TestMutex.cpp
//  HelloWorld-mobile
//
//  Created by mac on 2021/2/25.
//

#include "TestMutex.h"
#include <thread>

std::mutex _mutex;
Scene* TestMutex::createScene()
{
    auto scene = Scene::create();
    auto layer = TestMutex::create();
    scene->addChild(layer);
    return scene;
}

bool TestMutex::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
    total = 50;
    selled = 0;

    std::thread t1(&TestMutex::threadA,this);
    t1.detach();

    std::thread t2(&TestMutex::threadB,this);
    t2.detach();

    return true;
}
void TestMutex::threadA()
{
    while (selled<total)
    {
        // 加锁
        _mutex.lock();
        selled++;
        std::this_thread::sleep_for(std::chrono::seconds(1));
        log("threadA %d",selled);
        // 解锁
        _mutex.unlock();
    }
}

void TestMutex::threadB()
{
    while (selled<total)
    {
        _mutex.lock();
        selled++;
        std::this_thread::sleep_for(std::chrono::seconds(1));
        
        log("threadB %d",selled);
        _mutex.unlock();
    }
}
