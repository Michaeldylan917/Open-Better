import { FormExtensionAbility, formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { Want, Configuration } from '@kit.AbilityKit';
import { MoodService } from '../services/MoodService';
import { DateUtils } from '../common/utils/DateUtils';
import { MOOD_ICONS, MOOD_LABELS } from '../models/MoodType';

interface WidgetData {
  moodIcon: string;
  moodLabel: string;
  date: string;
  note: string;
}

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    const formData: WidgetData = {
      moodIcon: '☀️',
      moodLabel: '记录心情',
      date: DateUtils.format(new Date().getTime(), 'MM/dd'),
      note: '点击记录第一条心情'
    };
    
    // Update asynchronously
    const formId = want.parameters?.[formInfo.FormParam.IDENTITY_KEY] as string;
    if (formId) {
      this.updateFormData(formId);
    }
    
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string) {
  }

  onUpdateForm(formId: string) {
    this.updateFormData(formId);
  }

  onChangeFormVisibility(newStatus: Record<string, number>) {
  }

  onFormEvent(formId: string, message: string) {
  }

  onRemoveForm(formId: string) {
  }

  onConfigurationUpdate(config: Configuration) {
  }
  
  async updateFormData(formId: string) {
    try {
      await MoodService.getInstance().init(this.context);
      const logs = MoodService.getInstance().getLogs();
      
      let formData: WidgetData;
      
      if (logs.length > 0) {
        const log = logs[0];
        formData = {
          moodIcon: MOOD_ICONS[log.mood],
          moodLabel: MOOD_LABELS[log.mood],
          date: DateUtils.format(log.timestamp, 'MM/dd'),
          note: log.note || 'No note.'
        };
      } else {
        formData = {
           moodIcon: '☀️',
           moodLabel: '记录心情',
           date: DateUtils.format(new Date().getTime(), 'MM/dd'),
           note: '点击记录第一条心情'
        };
      }
      
      const bindingData = formBindingData.createFormBindingData(formData);
      await formProvider.updateForm(formId, bindingData);
      
    } catch (err) {
      console.error(`[EntryFormAbility] Failed to update form: ${JSON.stringify(err)}`);
    }
  }
}