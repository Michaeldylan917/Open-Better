import { MoodLog } from '../models/MoodLog';
import { MoodType } from '../models/MoodType';
import { MOOD_PRIORITY, MOOD_SCORE } from '../common/constants/MoodConstants';
import { DateUtils } from '../common/utils/DateUtils';

export interface TagStat {
  tag: string;
  count: number;
}

export class MoodService {
  private static instance: MoodService;
  private logs: MoodLog[] = [];
  private listeners: (() => void)[] = [];

  private constructor() {
    // Initial dummy data for testing
    this.initDummyData();
  }

  private initDummyData() {
    const today = new Date().getTime();
    const yesterday = today - 86400000;
    const dayBefore = today - 86400000 * 2;

    this.logs = [
      {
        id: '1',
        timestamp: yesterday,
        mood: MoodType.ECSTATIC,
        note: '终于完成了项目的里程碑，和朋友去吃了火锅，超级满足！🍲✨',
        tags: ['工作', '美食']
      },
      {
        id: '2',
        timestamp: dayBefore,
        mood: MoodType.SAD,
        note: '外面下了一整天的雨，心情也变得湿漉漉的。想家了。',
        tags: ['家庭']
      },
      // Add conflict for today to test priority
      {
        id: '3',
        timestamp: today - 3600000 * 4, // 4 hours ago
        mood: MoodType.HAPPY,
        note: '早上心情不错',
        tags: ['生活']
      },
      {
        id: '4',
        timestamp: today, // Just now
        mood: MoodType.ANGRY, // Angry should prioritize over Happy
        note: '突然遇到一个Bug，很生气',
        tags: ['工作']
      }
    ];
  }

  public static getInstance(): MoodService {
    if (!MoodService.instance) {
      MoodService.instance = new MoodService();
    }
    return MoodService.instance;
  }

  public addChangeListener(callback: () => void): void {
    this.listeners.push(callback);
  }

  public removeChangeListener(callback: () => void): void {
    this.listeners = this.listeners.filter(listener => listener !== callback);
  }

  private notifyListeners(): void {
    this.listeners.forEach(listener => listener());
  }

  public getLogs(): MoodLog[] {
    return this.logs.sort((a, b) => b.timestamp - a.timestamp);
  }

  public getLogById(id: string): MoodLog | undefined {
    return this.logs.find(log => log.id === id);
  }

  public addLog(log: MoodLog): void {
    this.logs.push(log);
    this.notifyListeners();
  }

  public updateLog(log: MoodLog): void {
    const index = this.logs.findIndex(l => l.id === log.id);
    if (index !== -1) {
      this.logs[index] = log;
      this.notifyListeners();
    }
  }
  
  public getLogsByMonth(year: number, month: number): MoodLog[] {
    return this.logs.filter(log => {
      const date = new Date(log.timestamp);
      return date.getFullYear() === year && date.getMonth() === month;
    });
  }

  public getLogsForDay(year: number, month: number, day: number): MoodLog[] {
    return this.logs.filter(log => {
      const date = new Date(log.timestamp);
      return date.getFullYear() === year && date.getMonth() === month && date.getDate() === day;
    }).sort((a, b) => b.timestamp - a.timestamp); // Latest first
  }

  // Get the "Best Day" log for a specific month
  public getBestDay(year: number, month: number): MoodLog | null {
    const monthLogs = this.getLogsByMonth(year, month);
    if (monthLogs.length === 0) return null;

    // Logic:
    // 1. Mood Score (Desc)
    // 2. Has Note (Desc)
    // 3. Note Length (Desc)
    // 4. Timestamp (Desc - Latest)
    monthLogs.sort((a, b) => {
      // 1. Mood Score
      const scoreA = MOOD_SCORE[a.mood] || 0;
      const scoreB = MOOD_SCORE[b.mood] || 0;
      if (scoreA !== scoreB) return scoreB - scoreA;

      // 2. Has Note
      const hasNoteA = a.note && a.note.trim().length > 0 ? 1 : 0;
      const hasNoteB = b.note && b.note.trim().length > 0 ? 1 : 0;
      if (hasNoteA !== hasNoteB) return hasNoteB - hasNoteA;

      // 3. Note Length
      const noteLenA = a.note ? a.note.length : 0;
      const noteLenB = b.note ? b.note.length : 0;
      if (noteLenA !== noteLenB) return noteLenB - noteLenA;

      // 4. Recency
      return b.timestamp - a.timestamp;
    });

    return monthLogs[0];
  }

  // Get the "Representative" Mood for a specific day (for Calendar display)
  public getDailySummary(year: number, month: number, day: number): MoodLog | null {
    const dayLogs = this.getLogsForDay(year, month, day);
    if (dayLogs.length === 0) return null;

    // Logic:
    // 1. Priority (Angry > Sad > Ecstatic > Happy > Neutral)
    // 2. Recency (Latest first)
    dayLogs.sort((a, b) => {
      const pA = MOOD_PRIORITY[a.mood] || 5;
      const pB = MOOD_PRIORITY[b.mood] || 5;
      
      if (pA !== pB) {
        return pA - pB; // Lower number = Higher Priority
      }
      return b.timestamp - a.timestamp;
    });

    return dayLogs[0];
  }

  public getTopTags(limit: number = 5): TagStat[] {
    const tagCounts: Record<string, number> = {};
    this.logs.forEach(log => {
      if (log.tags) {
        log.tags.forEach(tag => {
          tagCounts[tag] = (tagCounts[tag] || 0) + 1;
        });
      }
    });

    return Object.entries(tagCounts)
      .map((entry): TagStat => ({ tag: entry[0], count: entry[1] }))
      .sort((a, b) => b.count - a.count)
      .slice(0, limit);
  }

  // Analysis: Most frequent tag for a specific mood
  public getTopTagForMood(mood: MoodType): string | null {
    const moodLogs = this.logs.filter(log => log.mood === mood);
    if (moodLogs.length === 0) return null;

    const tagCounts: Record<string, number> = {};
    moodLogs.forEach(log => {
      if (log.tags) {
        log.tags.forEach(tag => {
          tagCounts[tag] = (tagCounts[tag] || 0) + 1;
        });
      }
    });

    const sortedTags = Object.entries(tagCounts).sort((a, b) => b[1] - a[1]);
    if (sortedTags.length > 0) {
      return sortedTags[0][0]; // Return tag name
    }
    return null;
  }

  public getLogsByTag(tag: string): MoodLog[] {
    return this.logs.filter(log => log.tags && log.tags.includes(tag)).sort((a, b) => b.timestamp - a.timestamp);
  }

  public calculateCurrentStreak(): number {
    if (this.logs.length === 0) return 0;

    const uniqueDays = new Set<number>();
    this.logs.forEach(log => {
      const date = new Date(log.timestamp);
      date.setHours(0, 0, 0, 0);
      uniqueDays.add(date.getTime());
    });

    const sortedDays = Array.from(uniqueDays).sort((a, b) => b - a);
    if (sortedDays.length === 0) return 0;

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayTime = today.getTime();
    const yesterdayTime = todayTime - 86400000;

    let streak = 0;
    let lastDate = -1;

    // Check if the streak is active (last log was today or yesterday)
    if (sortedDays[0] === todayTime) {
      streak = 1;
      lastDate = todayTime;
    } else if (sortedDays[0] === yesterdayTime) {
      streak = 1;
      lastDate = yesterdayTime;
    } else {
      return 0;
    }

    for (let i = 1; i < sortedDays.length; i++) {
      if (sortedDays[i] === lastDate - 86400000) {
        streak++;
        lastDate = sortedDays[i];
      } else {
        break;
      }
    }

    return streak;
  }

  public getWorstDay(year: number, month: number): MoodLog | null {
    const monthLogs = this.getLogsByMonth(year, month);
    if (monthLogs.length === 0) return null;

    // Logic:
    // 1. Mood Score (Asc - Lowest first)
    // 2. Has Note (Desc)
    // 3. Note Length (Desc)
    // 4. Recency (Desc)
    monthLogs.sort((a, b) => {
      const scoreA = MOOD_SCORE[a.mood] || 0;
      const scoreB = MOOD_SCORE[b.mood] || 0;
      if (scoreA !== scoreB) return scoreA - scoreB; // Ascending

      const hasNoteA = a.note && a.note.trim().length > 0 ? 1 : 0;
      const hasNoteB = b.note && b.note.trim().length > 0 ? 1 : 0;
      if (hasNoteA !== hasNoteB) return hasNoteB - hasNoteA;

      const noteLenA = a.note ? a.note.length : 0;
      const noteLenB = b.note ? b.note.length : 0;
      if (noteLenA !== noteLenB) return noteLenB - noteLenA;

      return b.timestamp - a.timestamp;
    });

    return monthLogs[0];
  }

  public exportData(): string {
    return JSON.stringify(this.logs, null, 2);
  }
}
