export enum MoodType {
  ECSTATIC = 'ecstatic',
  HAPPY = 'happy',
  NEUTRAL = 'neutral',
  SAD = 'sad',
  ANGRY = 'angry'
}

export const MOOD_COLORS: Record<MoodType, string> = {
  [MoodType.ECSTATIC]: '#FFD166',
  [MoodType.HAPPY]: '#FFB7B2',
  [MoodType.NEUTRAL]: '#E2F0CB',
  [MoodType.SAD]: '#B5EAD7',
  [MoodType.ANGRY]: '#FF9AA2'
}

export const MOOD_ICONS: Record<MoodType, string> = {
  [MoodType.ECSTATIC]: '🤩',
  [MoodType.HAPPY]: '😊',
  [MoodType.NEUTRAL]: '😐',
  [MoodType.SAD]: '😔',
  [MoodType.ANGRY]: '😡'
}

export const MOOD_LABELS: Record<MoodType, string> = {
  [MoodType.ECSTATIC]: '狂喜',
  [MoodType.HAPPY]: '开心',
  [MoodType.NEUTRAL]: '平淡',
  [MoodType.SAD]: '难过',
  [MoodType.ANGRY]: '愤怒'
}
