import { HomePage } from './HomePage'
import { MinePage } from './MinePage'
import { ProjectPage } from './ProjectPage'
import { TongJiPage } from './TongJiPage'
import { AppState } from '../utils/AppState'
import { router } from '@kit.ArkUI'

interface TabInterface {
  name: string
  icon: ResourceStr
  selectIcon: ResourceStr
  title: string
}

@Entry
@ComponentV2
struct TabsPage {
  @Local currentIndex: number = 0
  @Local list: TabInterface[] = [{
    icon: $r('app.media.siuye'),
    selectIcon: $r('app.media.siuye'),
    name: 'wechat',
    title: '首页',
  }, {
    icon: $r('app.media.xiangmu'),
    selectIcon:  $r('app.media.xiangmu'),
    name: 'connect',
    title: '统计',
  }, {
    icon: $r('app.media.message'),
    selectIcon: $r('app.media.message'),
    name: 'discover',
    title: '社区',
  }, {
    icon:$r('app.media.mine'),
    selectIcon:$r('app.media.mine'),
    name: 'my',
    title: '我的',
  }]

  // 使用 @Local 而不是 @State
  @Local userId: string = ''
  @Local userIdentity: string = ''
  @Local userName: string = ''
  @Local showWelcome: boolean = false  // 新增：控制欢迎信息显示

  aboutToAppear() {
    // 从URL参数获取基础信息 - 使用安全的方式
    const params = router.getParams() as Record<string, string | number | boolean> | undefined;
    if (params) {
      // 使用类型安全的访问方式
      const paramUserId = params['userId'];
      const paramUserIdentity = params['userIdentity'];

      if (typeof paramUserId === 'string') {
        this.userId = paramUserId;
      }
      if (typeof paramUserIdentity === 'string') {
        this.userIdentity = paramUserIdentity;
      }
    }

    // 从全局状态获取用户信息
    const appState = AppState.getInstance();
    const userData = appState.currentUser;
    if (userData) {
      this.userName = userData.name;
      // 显示欢迎信息
      this.showWelcome = true;

      // 3秒后自动隐藏欢迎信息
      setTimeout(() => {
        this.showWelcome = false;
      }, 3000);
    }

    console.log('=== Index页面加载 ===');
    console.log('用户ID:', this.userId);
    console.log('用户身份:', this.userIdentity);
    console.log('用户姓名:', this.userName);
    console.log('全局状态用户:', appState.currentUser);
    console.log('登录状态:', appState.isLoggedIn);
  }

  @Builder CommonTabBar (item: TabInterface) {
    Column() {
      Image(item.name === this.list[this.currentIndex].name ? item.selectIcon : item.icon)
        .width(20)
        .height(20)
      Text(item.title)
        .fontSize(12)
        .fontColor(item.name === this.list[this.currentIndex].name ? "#ff197bc8" : "#2A2929")
        .margin({
          top: 5
        })
    }
  }

  // 构建顶部用户信息栏
  @Builder
  buildUserHeader() {
    Column() {
      // 只在 showWelcome 为 true 时显示欢迎信息
      if (AppState.getInstance().isLoggedIn && this.userName && this.showWelcome) {
        Row() {
          Text(`欢迎，${this.userName}`)
            .fontSize(16)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)

          Text(`(${this.userIdentity})`)
            .fontSize(12)
            .fontColor('#666666')
            .margin({ left: 8 })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .padding(12)
        .backgroundColor('#f8f9fa')
        .borderRadius(8)
        .margin({ bottom: 12 })
      }
    }
    .width('100%')
  }

  build() {
    Column() {
      // 用户信息栏
      this.buildUserHeader()

      Tabs({index:this.currentIndex}) {
        ForEach(this.list, (item: TabInterface,index:number) => {
          TabContent() {
            if (index ===0) {
              HomePage()
            }else if (index ===1){
              ProjectPage()
            }else if (index ===2){
              TongJiPage()
            }else if (index ===3){
              MinePage()
            }
          }
          .tabBar(this.CommonTabBar(item))
        })
      }
      .barPosition(BarPosition.End)
      .layoutWeight(1) // 让Tabs占据剩余空间
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .padding(16)
  }
}