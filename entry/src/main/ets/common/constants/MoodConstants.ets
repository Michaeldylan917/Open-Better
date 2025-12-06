import { MoodType } from '../../models/MoodType';

// Lower number = Higher Priority for Calendar Display (e.g., Show negative moods first)
export const MOOD_PRIORITY: Record<MoodType, number> = {
  [MoodType.ANGRY]: 1,
  [MoodType.SAD]: 2,
  [MoodType.ECSTATIC]: 3,
  [MoodType.HAPPY]: 4,
  [MoodType.NEUTRAL]: 5
};

// Higher number = Better Mood (for "Best Day" calculation)
export const MOOD_SCORE: Record<MoodType, number> = {
  [MoodType.ECSTATIC]: 5,
  [MoodType.HAPPY]: 4,
  [MoodType.NEUTRAL]: 3,
  [MoodType.SAD]: 2,
  [MoodType.ANGRY]: 1
};
