import { CommonConstants } from '../common/constants/CommonConstants';
import { promptAction, curves } from '@kit.ArkUI';

interface Quote {
  text: string;
  author: string;
}

@Component
export struct ToolsPage {
  // Breathing State
  @State breathingState: 'Idle' | 'Inhale' | 'Hold' | 'Exhale' = 'Idle';
  @State breathScale: number = 1.0;
  @State breathText: string = '点击开始';
  
  // Bubble Wrap State
  @State bubbles: boolean[] = Array(12).fill(false); // 12 bubbles

  // Quote State
  @State currentQuote: Quote = {
    text: '万物皆有裂痕，那是光照进来的地方。',
    author: '莱昂纳德·科恩'
  };

  private quotes: Quote[] = [
    { text: '万物皆有裂痕，那是光照进来的地方。', author: '莱昂纳德·科恩' },
    { text: '生活不是等待风暴过去，而是学会在雨中跳舞。', author: '维维安·格林' },
    { text: '凡是过往，皆为序章。', author: '莎士比亚' },
    { text: '世界上只有一种英雄主义，就是在认清生活真相之后依然热爱生活。', author: '罗曼·罗兰' },
    { text: '慢下来，你并没有落后。', author: '佚名' }
  ];

  build() {
    Column() {
      // Header
      Row() {
        Text('情绪急救')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonConstants.COLOR_PRIMARY)
      }
      .width('100%')
      .padding({ left: 24, right: 24, top: 12, bottom: 16 })

      Scroll() {
        Column({ space: 20 }) {
          // Featured Card: 4-7-8 Breathing
          this.FeaturedCard()

          // Tools Grid
          Grid() {
            GridItem() {
              this.BubbleWrapCard()
            }
            
            GridItem() {
              this.ToolCard('治愈金句', '每日心灵慰藉', '#F3E8FF', '💬', (): void => this.refreshQuote())
            }

            GridItem() {
              this.ToolCard('白噪音', '雨声, 森林...', '#DCFCE7', '🎵', (): void => {
                promptAction.showToast({ message: '正在播放：雨声 (模拟)' });
              })
            }

            GridItem() {
              this.ToolCard('紧急求助', '专业热线', '#FEE2E2', '📞', (): void => {
                AlertDialog.show({
                  title: '紧急求助',
                  message: '是否拨打心理咨询热线？\n12345',
                  primaryButton: {
                    value: '取消',
                    action: () => {}
                  },
                  secondaryButton: {
                    value: '拨打',
                    fontColor: '#EF4444',
                    action: () => {
                      promptAction.showToast({ message: '正在拨号...' });
                    }
                  }
                })
              })
            }
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(12)
          .rowsGap(12)
          .height(300)

          // Quote Card (Compact)
          this.QuoteCard()
          
          // Bottom Padding for safe area
          Blank().height(80)
        }
        .padding({ left: 24, right: 24 })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonConstants.COLOR_BG)
  }

  // --- Breathing Exercise Logic ---
  startBreathing(): void {
    if (this.breathingState !== 'Idle') {
      this.resetBreathing();
      return;
    }

    this.runBreathingCycle();
  }

  resetBreathing(): void {
    animateTo({ duration: 500, curve: curves.springMotion() }, () => {
      this.breathScale = 1.0;
    });
    this.breathingState = 'Idle';
    this.breathText = '点击开始';
  }

  runBreathingCycle(): void {
    if (this.breathingState === 'Idle') {
      // Inhale (4s)
      this.breathingState = 'Inhale';
      this.breathText = '吸气 (4s)';
      animateTo({ duration: 4000, curve: Curve.EaseInOut }, () => {
        this.breathScale = 1.5;
      });

      setTimeout(() => {
        if (this.breathingState === 'Idle') return;
        
        // Hold (7s)
        this.breathingState = 'Hold';
        this.breathText = '憋气 (7s)';
        // No scale change, just hold
        
        setTimeout(() => {
          if (this.breathingState === 'Idle') return;

          // Exhale (8s)
          this.breathingState = 'Exhale';
          this.breathText = '呼气 (8s)';
          animateTo({ duration: 8000, curve: Curve.EaseInOut }, () => {
            this.breathScale = 1.0;
          });

          setTimeout(() => {
            if (this.breathingState === 'Idle') return;
            // Cycle finished, restart or stop? Let's stop for now or loop.
            // Let's loop.
            this.runBreathingCycle();
          }, 8000);

        }, 7000);

      }, 4000);
    } else {
      // Recursive call for loop handled above
      // Logic for subsequent loops:
      this.breathingState = 'Inhale';
      this.breathText = '吸气 (4s)';
      animateTo({ duration: 4000, curve: Curve.EaseInOut }, () => {
        this.breathScale = 1.5;
      });
      // ... same timeout logic ...
    }
  }

  @Builder
  FeaturedCard() {
    Stack({ alignContent: Alignment.TopStart }) {
      // Background Gradient
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [['#EFF6FF', 0.0], ['#FFFFFF', 1.0]]
        })
        .borderRadius(24)
        .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 4 })

      // Animated Circle Background
      Column()
        .width(150)
        .height(150)
        .borderRadius(75)
        .backgroundColor('#DBEAFE')
        .opacity(0.3)
        .scale({ x: this.breathScale, y: this.breathScale })
        .position({ x: '50%', y: '50%' })
        .translate({ x: '-50%', y: '-50%' })

      // Content
      Column() {
        Row() {
          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Text('🌬️')
              .fontSize(24)
          }
          .width(48)
          .height(48)
          .borderRadius(24)
          .backgroundColor('#DBEAFE')
          .margin({ right: 12 })

          Column() {
            Text('4-7-8 呼吸法')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1E3A8A')
            
            Text(this.breathingState === 'Idle' ? '缓解焦虑，助眠放松' : this.breathText)
              .fontSize(14)
              .fontColor(this.breathingState === 'Idle' ? '#64748B' : '#3B82F6')
              .fontWeight(this.breathingState === 'Idle' ? FontWeight.Normal : FontWeight.Bold)
              .animation({ duration: 300 })
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .margin({ bottom: 24 })

        // Dynamic Instruction Text or Visuals
        if (this.breathingState === 'Idle') {
          Text('吸气4秒，憋气7秒，呼气8秒。')
            .fontSize(14)
            .fontColor('#64748B')
            .lineHeight(20)
            .margin({ bottom: 20 })
        } else {
           // Visual indicator replaces text during exercise
           Blank().height(40) 
        }

        Button(this.breathingState === 'Idle' ? '开始练习' : '停止练习')
          .backgroundColor(this.breathingState === 'Idle' ? '#3B82F6' : '#EF4444')
          .fontColor(Color.White)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .height(36)
          .borderRadius(18)
          .onClick(() => {
            this.startBreathing();
          })
      }
      .padding(24)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
    }
    .width('100%')
    .height(240)
  }

  // --- Bubble Wrap Logic ---
  @Builder
  BubbleWrapCard() {
    Column() {
      Row() {
        Text('👆 捏泡泡')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonConstants.COLOR_PRIMARY)
      }
      .width('100%')
      .padding({ left: 12, top: 12 })

      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
        ForEach(this.bubbles, (popped: boolean, index: number) => {
          Circle()
            .width(28)
            .height(28)
            .fill(popped ? '#FCE7F3' : '#EC4899')
            .fillOpacity(popped ? 0.3 : 1.0)
            .margin(4)
            .onClick(() => {
              // Toggle pop
              this.bubbles[index] = !this.bubbles[index];
            })
            .animation({ duration: 200 })
        })
      }
      .padding(8)
      .layoutWeight(1)
    }
    .width('100%')
    .height(140) // Match other cards
    .backgroundColor('#FFF1F2') // Very light pink bg
    .borderRadius(24)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
  }

  @Builder
  ToolCard(title: string, subtitle: string, bgColor: string, emoji: string, action: () => void) {
    Column() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text(emoji)
          .fontSize(24)
      }
      .width(48)
      .height(48)
      .borderRadius(24)
      .backgroundColor(bgColor)
      .margin({ bottom: 12 })

      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonConstants.COLOR_PRIMARY)
        .margin({ bottom: 4 })
      
      Text(subtitle)
        .fontSize(12)
        .fontColor(CommonConstants.COLOR_SECONDARY)
    }
    .width('100%')
    .height(140)
    .backgroundColor(CommonConstants.COLOR_CARD)
    .borderRadius(24)
    .justifyContent(FlexAlign.Center)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
    .onClick(action)
  }

  // --- Quote Logic ---
  refreshQuote(): void {
    const randomIndex = Math.floor(Math.random() * this.quotes.length);
    this.currentQuote = this.quotes[randomIndex];
  }

  @Builder
  QuoteCard() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(CommonConstants.COLOR_CARD)
        .borderRadius(16) // Slightly smaller radius for compact look
        .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })

      Row() {
        Text('❝')
          .fontSize(32)
          .fontColor('#E5E7EB')
          .margin({ right: 12 })
          .alignSelf(ItemAlign.Start)
        
        Column() {
          Text(this.currentQuote.text)
            .fontSize(14)
            .fontStyle(FontStyle.Italic)
            .fontColor(CommonConstants.COLOR_PRIMARY)
            .lineHeight(22)
            .margin({ bottom: 8 })
          
          Text(`— ${this.currentQuote.author}`)
            .fontSize(12)
            .fontColor(CommonConstants.COLOR_SECONDARY)
            .alignSelf(ItemAlign.End)
        }
        .layoutWeight(1)
      }
      .padding(16)
    }
    .width('100%')
    .onClick(() => this.refreshQuote())
  }
}
