import { MoodType } from './MoodType';

export interface MoodLog {
  id: string;
  timestamp: number;
  mood: MoodType;
  note?: string;
  tags?: string[];
}
