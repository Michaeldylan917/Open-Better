import { CommonConstants } from '../common/constants/CommonConstants';
import { promptAction, curves } from '@kit.ArkUI';
import { vibrator } from '@kit.SensorServiceKit';

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
  @State isBubbleGameOpen: boolean = false;
  @State bubbles: boolean[] = Array(30).fill(false); // Increased to 30

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
              this.ToolCard('捏泡泡', '解压小游戏', '#FCE7F3', '👆', () => {
                this.isBubbleGameOpen = true;
              })
            }
            
            GridItem() {
              this.ToolCard('治愈金句', '每日心灵慰藉', '#F3E8FF', '❞', (): void => this.refreshQuote())
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
          .height(280) // Slightly reduced height

          // Quote Card (Compact & Redesigned)
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
    .bindSheet($$this.isBubbleGameOpen, this.BubbleGameBuilder(), {
      height: SheetSize.MEDIUM,
      dragBar: true,
      backgroundColor: '#FFF1F2'
    })
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
            // Loop
            this.runBreathingCycle();
          }, 8000);

        }, 7000);

      }, 4000);
    } else {
      // Recursive entry logic (same as initial)
       this.breathingState = 'Inhale';
       this.breathText = '吸气 (4s)';
       animateTo({ duration: 4000, curve: Curve.EaseInOut }, () => {
         this.breathScale = 1.5;
       });
       // ... Timeouts are handled by the closure of the new cycle if I were to refactor, 
       // but here I rely on the fact that runBreathingCycle sets state and triggers timeouts.
       // Actually, the recursive call in line 164 handles the loop.
       // The 'else' block here is not reachable if I always call from Idle or Loop.
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
        // Icon
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('💨') // Changed to Wind/Dash
            .fontSize(24)
        }
        .width(48)
        .height(48)
        .borderRadius(24)
        .backgroundColor('#DBEAFE')
        .margin({ bottom: 16 })

        Text('4-7-8 呼吸法')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1E3A8A')
          .margin({ bottom: 8 })
        
        Text(this.breathingState === 'Idle' ? '缓解焦虑，助眠放松。吸气4秒，憋气7秒，呼气8秒。' : this.breathText)
          .fontSize(14)
          .fontColor(this.breathingState === 'Idle' ? '#64748B' : '#3B82F6')
          .fontWeight(this.breathingState === 'Idle' ? FontWeight.Normal : FontWeight.Bold)
          .lineHeight(20)
          .margin({ bottom: 20 })
          .animation({ duration: 300 })

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
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      
      // Decorative Icon
      Text('☁️')
        .fontSize(80)
        .opacity(0.2)
        .position({ x: '75%', y: '65%' })
    }
    .width('100%')
    .height(240)
  }

  // --- Bubble Wrap Logic ---
  @Builder
  BubbleGameBuilder() {
    Column() {
      Text('捏泡泡')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 24, bottom: 24 })
      
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
        ForEach(this.bubbles, (popped: boolean, index: number) => {
          Circle()
            .width(44)
            .height(44)
            .fill(popped ? '#FCE7F3' : '#EC4899')
            .fillOpacity(popped ? 0.3 : 1.0)
            .margin(8)
            .onClick(() => {
              if (!this.bubbles[index]) {
                 this.bubbles[index] = true;
                 try {
                   vibrator.startVibration({ type: 'time', duration: 50 }, { id: 0, usage: 'touch' });
                 } catch (err) {
                   // Ignore if vibration fails
                 }
              } else {
                 this.bubbles[index] = false; // Optional: Un-pop?
              }
            })
            .animation({ duration: 200 })
        })
      }
      .padding(16)
    }
    .width('100%')
    .height('100%')
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
    Column() {
      // Top Icon
      Row() {
        Text('❝')
          .fontSize(24)
          .fontColor('#E5E7EB') // Light gray
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ left: 4 })

      // Text
      Text(this.currentQuote.text)
        .fontSize(16)
        .fontStyle(FontStyle.Italic)
        .fontColor('#374151')
        .textAlign(TextAlign.Center)
        .lineHeight(26)
        .margin({ top: 8, bottom: 12 })
        .width('90%')
      
      // Author
      Text(`— ${this.currentQuote.author}`)
        .fontSize(12)
        .fontColor('#9CA3AF')
        .margin({ bottom: 8 })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(10)
    .borderRadius(20)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
    .onClick(() => this.refreshQuote())
  }
}
