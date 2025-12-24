@Entry
@Component
export struct TongJiPage {
  @State currentTab: number = 0
  tabTitles: string[] = ['全部', '经验分享', '考试咨询', '院校信息']



  //全部
  @Builder
  buildAllContent() {
    Column({space:10}){

      Scroll(){
        Column(){
          Column(){
            Row(){
              Image($r('app.media.touxiang'))
                .width(38)
                .height(38)
                .borderRadius(19)


              Column({space:2}){
                Text('路人甲')
                  .fontWeight(700)
                  .fontSize(13)
                Text('清华大学 计算机系')
                  .fontSize(10)
                  .fontColor('#6B7280')
              }
              .padding({left:10})
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .height('100%')
              .width(150)


              Row().width(70)
              Text('2小时前')
                .fontSize(11)
                .fontColor('#6B7280')
            }
            .padding({left:5,right:5})
            .height(60)
            // .backgroundColor(Color.Pink)
            .width('100%')

            Row(){
              Text('分享我的保研经验 - 如何在大三提前准备')
                .fontWeight(700)
                .fontSize(15)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({bottom:10})


            Row(){
              Text('大家好，我是来自清华大学计算机系的大四学生。今天想和大家分享' +
                '一下我在准备保研过程中的一些')
                .fontSize(14)
                .fontColor('#4B5563')
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')

            Row({space:10}){

              Row(){
                Text('保研经验')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(45)

              Row(){
                Text('计算机专业')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(50)

              Row(){
                Text('清华大学')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(45)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({top:10})


            Row(){
              Row({space:15}){
                Row({space:2}){
                  Image($r('app.media.xihuan'))
                    .width(15)
                  Text('128')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
                Row({space:2}){
                  Image($r('app.media.pinglun'))
                    .width(13)
                  Text('36')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
                Row({space:2}){
                  Image($r('app.media.yuedu'))
                    .width(15)
                  Text('89')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
              }


              Image($r('app.media.zhaunfa'))
                .width(20)
            }
            .margin({top:10})
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
          }
          .padding(10)
          .borderRadius(10)
          .height(200)
          .backgroundColor(Color.White)
          .width('100%')
          .margin({top:10})


          Column(){
            Row(){
              Image($r('app.media.HacKer'))
                .width(38)
                .height(38)
                .borderRadius(19)


              Column({space:2}){
                Text('路人乙')
                  .fontWeight(700)
                  .fontSize(13)
                Text('北京大学 金融学院')
                  .fontSize(10)
                  .fontColor('#6B7280')
              }
              .padding({left:10})
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .height('100%')
              .width(150)


              Row().width(70)
              Text('5小时前')
                .fontSize(11)
                .fontColor('#6B7280')
            }
            .padding({left:5,right:5})
            .height(60)
            // .backgroundColor(Color.Pink)
            .width('100%')

            Row(){
              Text('金融专业保研经验总结')
                .fontWeight(700)
                .fontSize(15)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({bottom:10})


            Row(){
              Text('作为一名金融专业的学生，我深知保研过程中的种种挑战。在这里，我想分享一下自己是如何准备夏')
                .fontSize(14)
                .fontColor('#4B5563')
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')

            Row({space:10}){

              Row(){
                Text('金融专业')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(45)

              Row(){
                Text('北京大学')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(50)

              Row(){
                Text('夏令营')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(45)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({top:10})


            Row(){
              Row({space:15}){
                Row({space:2}){
                  Image($r('app.media.xihuan'))
                    .width(15)
                  Text('156')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
                Row({space:2}){
                  Image($r('app.media.pinglun'))
                    .width(13)
                  Text('42')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
                Row({space:2}){
                  Image($r('app.media.yuedu'))
                    .width(15)
                  Text('103')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
              }


              Image($r('app.media.zhaunfa'))
                .width(20)
            }
            .margin({top:10})
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
          }
          .padding(10)
          .borderRadius(10)
          .height(200)
          .backgroundColor(Color.White)
          .width('100%')
          .margin({top:10})


          Column(){
            Row(){
              Image($r('app.media.LSXL'))
                .width(38)
                .height(38)
                .borderRadius(19)


              Column({space:2}){
                Text('路人丙')
                  .fontWeight(700)
                  .fontSize(13)
                Text('复旦大学 生物医学工程')
                  .fontSize(10)
                  .fontColor('#6B7280')
              }
              .padding({left:10})
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .height('100%')
              .width(150)


              Row().width(70)
              Text('8小时前')
                .fontSize(11)
                .fontColor('#6B7280')
            }
            .padding({left:5,right:5})
            .height(60)
            // .backgroundColor(Color.Pink)
            .width('100%')

            Row(){
              Text('生医工保研上岸复旦 - 经验分享')
                .fontWeight(700)
                .fontSize(15)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({bottom:10})


            Row(){
              Text('我的保研经历比较曲折，但最终还是成功上岸了复旦大学生物医学工程专业。期间积累了不少经验，')
                .fontSize(14)
                .fontColor('#4B5563')
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')

            Row({space:10}){

              Row(){
                Text('生医工')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(45)

              Row(){
                Text('复旦大学')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(50)

              Row(){
                Text('面试经验')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(45)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({top:10})


            Row(){
              Row({space:15}){
                Row({space:2}){
                  Image($r('app.media.xihuan'))
                    .width(15)
                  Text('89')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
                Row({space:2}){
                  Image($r('app.media.pinglun'))
                    .width(13)
                  Text('28')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
                Row({space:2}){
                  Image($r('app.media.yuedu'))
                    .width(15)
                  Text('67')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
              }


              Image($r('app.media.zhaunfa'))
                .width(20)
            }
            .margin({top:10})
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
          }
          .padding(10)
          .borderRadius(10)
          .height(200)
          .backgroundColor(Color.White)
          .width('100%')
          .margin({top:10})



          Column(){
            Row(){
              Image($r('app.media.LUO'))
                .width(38)
                .height(38)
                .borderRadius(19)


              Column({space:2}){
                Text('路人丁')
                  .fontWeight(700)
                  .fontSize(13)
                Text('浙江大学 电子信息')
                  .fontSize(10)
                  .fontColor('#6B7280')
              }
              .padding({left:10})
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
              .height('100%')
              .width(150)


              Row().width(70)
              Text('12小时前')
                .fontSize(11)
                .fontColor('#6B7280')
            }
            .padding({left:5,right:5})
            .height(60)
            // .backgroundColor(Color.Pink)
            .width('100%')

            Row(){
              Text('浙大电子信息夏令营经验帖')
                .fontWeight(700)
                .fontSize(15)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({bottom:10})


            Row(){
              Text('分享一下参加浙大今年夏令营的经验。重点准备了英语口语展示和专业课复习，结合了自己的科研项')
                .fontSize(14)
                .fontColor('#4B5563')
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')

            Row({space:10}){

              Row(){
                Text('电子信息')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(45)

              Row(){
                Text('浙江大学')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(50)

              Row(){
                Text('优营')
                  .fontSize(9)
                  .fontColor('#757575')
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor('#DEDEDE')
              .height(22)
              .width(45)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .margin({top:10})


            Row(){
              Row({space:15}){
                Row({space:2}){
                  Image($r('app.media.xihuan'))
                    .width(15)
                  Text('134')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
                Row({space:2}){
                  Image($r('app.media.pinglun'))
                    .width(13)
                  Text('45')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
                Row({space:2}){
                  Image($r('app.media.yuedu'))
                    .width(15)
                  Text('92')
                    .fontSize(12)
                    .fontColor('#4B5563')
                }
              }


              Image($r('app.media.zhaunfa'))
                .width(20)
            }
            .margin({top:10})
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
          }
          .padding(10)
          .borderRadius(10)
          .height(200)
          .backgroundColor(Color.White)
          .width('100%')
          .margin({top:10})

        }
      }

    }
    .padding({left:10,right:10})
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  // 经验分享内容
  @Builder
  buildScienceContent() {
    Column() {
      Column(){
        Row(){
          Image($r('app.media.touxiang'))
            .width(38)
            .height(38)
            .borderRadius(19)


          Column({space:2}){
            Text('路人A')
              .fontWeight(700)
              .fontSize(13)
            Text('2025年09月25日')
              .fontSize(10)
              .fontColor('#6B7280')
          }
          .padding({left:10})
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .height('100%')
          .width(150)


          // Row().width(70)
          // Text('2小时前')
          //   .fontSize(11)
          //   .fontColor('#6B7280')
        }
        .padding({left:5,right:5})
        .height(60)
        // .backgroundColor(Color.Pink)
        .width('100%')

        Row(){
          Row(){
            Text('竞赛获奖')
              .fontSize(9)
              .fontColor('#757575')
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(12)
          .backgroundColor('#DEDEDE')
          .height(22)
          .width(45)
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .margin({bottom:10})


        Row(){
          Text('在大三上学期，我参加了“互联网+”大学生创新创业大赛，经过半年的准备和努力，最终获得了国家级铜奖。这个奖项为我的保研申请加了2分，对我最')
            .fontSize(14)
            .fontColor('#4B5563')
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')

        Row({space:10}){
          Image($r('app.media.jia'))
            .width(15)
          Text('加分：2.0')
            .fontSize(11)
            .fontColor('#5B5B5B')
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .margin({top:10})


        Row(){
          Row({space:15}){
            Row({space:2}){
              Image($r('app.media.xihuan'))
                .width(15)
              Text('128')
                .fontSize(12)
                .fontColor('#4B5563')
            }
            Row({space:2}){
              Image($r('app.media.pinglun'))
                .width(13)
              Text('36')
                .fontSize(12)
                .fontColor('#4B5563')
            }
            Row({space:2}){
              Image($r('app.media.yuedu'))
                .width(15)
              Text('89')
                .fontSize(12)
                .fontColor('#4B5563')
            }
          }


          Image($r('app.media.zhaunfa'))
            .width(20)
        }
        // .margin({top:10})
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
      }
      .padding(10)
      .borderRadius(10)
      .height(200)
      .backgroundColor(Color.White)
      .width('100%')
      .margin({top:10})


      Column(){
        Row(){
          Image($r('app.media.HacKer'))
            .width(38)
            .height(38)
            .borderRadius(19)


          Column({space:2}){
            Text('路人B')
              .fontWeight(700)
              .fontSize(13)
            Text('2025年09月25日')
              .fontSize(10)
              .fontColor('#6B7280')
          }
          .padding({left:10})
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .height('100%')
          .width(150)


          // Row().width(70)
          // Text('2小时前')
          //   .fontSize(11)
          //   .fontColor('#6B7280')
        }
        .padding({left:5,right:5})
        .height(60)
        // .backgroundColor(Color.Pink)
        .width('100%')

        Row(){
          Row(){
            Text('科研成果')
              .fontSize(9)
              .fontColor('#757575')
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(12)
          .backgroundColor('#DEDEDE')
          .height(22)
          .width(45)
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .margin({bottom:10})


        Row(){
          Text('大二暑假开始跟随导师进行科研项目研究，经过一年的努力，成功发表了一篇SCI三区论文。这个成果为我的保研申请加了3分，是我成功保研至清')
            .fontSize(14)
            .fontColor('#4B5563')
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')

        Row({space:10}){
          Image($r('app.media.jia'))
            .width(15)
          Text('加分：3.0')
            .fontSize(11)
            .fontColor('#5B5B5B')
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .margin({top:10})


        Row(){
          Row({space:15}){
            Row({space:2}){
              Image($r('app.media.xihuan'))
                .width(15)
              Text('128')
                .fontSize(12)
                .fontColor('#4B5563')
            }
            Row({space:2}){
              Image($r('app.media.pinglun'))
                .width(13)
              Text('36')
                .fontSize(12)
                .fontColor('#4B5563')
            }
            Row({space:2}){
              Image($r('app.media.yuedu'))
                .width(15)
              Text('89')
                .fontSize(12)
                .fontColor('#4B5563')
            }
          }


          Image($r('app.media.zhaunfa'))
            .width(20)
        }
        // .margin({top:10})
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
      }
      .padding(10)
      .borderRadius(10)
      .height(200)
      .backgroundColor(Color.White)
      .width('100%')
      .margin({top:10})


    }
    .padding({left:10,right:10})
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('100%')
    // .justifyContent(FlexAlign.Center)
    // .alignItems(HorizontalAlign.Center)
  }

  // 考试咨询内容
  @Builder
  buildLiteratureContent() {
    Column() {
      Text('考试咨询类消息')
        .fontSize(16)
        .fontColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 院校信息内容
  @Builder
  buildManagementContent() {
    Column() {
      Text('院校信息类消息')
        .fontSize(16)
        .fontColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }







  build() {
    Column() {
      // 搜索框
      Row() {
        Search({
          value: '搜索话题、资源...',
          placeholder: '搜索话题、资源...'
        })
          .fontColor('#ccc')
          .textFont({ size: 12, style: FontStyle.Normal })
          .height(35)
          .backgroundColor(Color.White)
          .placeholderFont({ size: 7, family: null, style: FontStyle.Italic })
          // .searchIcon({ size: 15, color: Color.Black, src: '/image/sous.svg' })
          .layoutWeight(1)
      }
      .height(60)
      .padding({ left: 10, right: 10 })
      .width('100%')



      // 可左右滑动的Tabs栏
      Scroll() {
        Row() {
          ForEach(this.tabTitles, (title: string, index: number) => {
            Column() {
              Text(title)
                .fontSize(14)
                .fontColor(this.currentTab === index ? Color.White : Color.Black)
                .padding({ left: 16, right: 16, top: 10, bottom: 10 })
            }
            .backgroundColor(this.currentTab === index ? '#909090' : Color.White)
            .borderRadius(3)
            .margin({ right: 8 })
            .onClick(() => {
              this.currentTab = index
            })
          })
        }
        .padding(10)
        .width('100%')
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off) // 隐藏滚动条
      .width('100%')
      .height(60)



      // 内容区域
      Column() {
        if (this.currentTab === 0) {
          this.buildAllContent()
        } else if (this.currentTab === 1) {
          this.buildScienceContent()
        } else if (this.currentTab === 2) {
          this.buildLiteratureContent()
        } else if (this.currentTab === 3) {
          this.buildManagementContent()
        }
      }
      .layoutWeight(1)
      .width('100%')
    }
    .backgroundColor('#f1f1f1')
    .height('100%')
    .width('100%')
  }
}