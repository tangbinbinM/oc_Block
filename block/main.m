//
//  main.m
//  block
//
//  Created by yg on 2017/8/2.
//  Copyright © 2017年 TBB. All rights reserved.
//

#import <Foundation/Foundation.h>
int fun(int x){
    NSLog(@"在函数fun中");
    return ++x;
}
//Block
void test1(){
    //定义函数指针
    int (*pfa)(int);
    pfa = fun;//指向函数
    int r1 = pfa(10);//调用函数
    NSLog(@"r1=%d",r1);
    //定义block变量
    int (^bfa)(int);
    //将一个Block赋值给这个变量
    bfa = ^int(int x){
        NSLog(@"bfa中");
        return ++x;
    };
    int r2 = bfa(10);
    NSLog(@"r2=%d",r2);
}
void test2(){
    //定义Block变量并赋值
    int mul = 5;
    int (^block1)(int) = ^int(int n){
        //在Block中访问外面的变量
        return n*mul;
    };
    int r = block1(10);
    NSLog(@"r=%d",r);
    //不带参的Block,()可以省略
    int (^block2)() = ^int{
        return mul * 10;
    };
    block2();//调用无参Block
    //Block的返回值类型是可以省略的
    int (^block3)(int) = ^(int x){
        return x * mul;
    };
    block3(10);
    int (^block4)() = ^{
        return mul * 10;
    };
    block4();
    //Block自然可以带多个参数
    int (^add)(int,int) = ^(int a, int b){
        return a + b;
    };
    add(10, 20);//30
}
//在Block中访问外部变量
void test4()
{
    NSString *firstName = @"Daniel";//Block外部变量
    NSString *(^getFullName)(NSString *) = ^(NSString *lastName){
        //外部变量在Block内部默认是只读的,不可改变
        //firstName = @"Meimei";
        //在Block中访问的外部变量会被直接复制进来。所以在Block中访问的是外部变量的副本。
        return [firstName stringByAppendingString:lastName];
    };
    NSString *fullName = getFullName(@" Guo");
    NSLog(@"%@", fullName);
    
    firstName = @"Meimei";
    fullName = getFullName(@" Guo");
    NSLog(@"%@", fullName);
}
//在Block中修改修改外部变量的值
void test5()
{
    __block int i = 10;//可以在block中修改
    int (^count)(void) = ^{
        i += 1;
        return i;
    };
    NSLog(@"%d", count());
    NSLog(@"%d", count());
    NSLog(@"%d", count());
    NSLog(@"%d", count());
}

//Block的内存情况
static int(^maxInBlock)(int,int) = ^(int x, int y){
    return x>y?x:y;
};//这个Block在全局区分配空间
void test6()
{
    int i = 1000;
    int j = 1;
    void (^blk)(void);
    void (^blkInHeap)(void);
    blk = ^{printf("%d, %d\n", i, j);};//blk指向的Block在栈中
    //blkInHeap = Block_copy(blk);//blkInHeap指向的Block在堆中(Block_copy是在MRC下将block拷贝到堆中)
    blkInHeap = [blk copy];//blkInHeap指向的Block在堆中
    NSLog(@"maxInBlock:%d",maxInBlock(10,20));
}
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        test6();
    }
    return 0;
}
