import { ModelStoreWithHistory } from 'src/types';
import { UiStateStore, Size } from 'src/types';
import { useScene } from 'src/hooks/useScene';

export interface State {
  model: ModelStoreWithHistory;
  scene: ReturnType<typeof useScene>;
  uiState: UiStateStore;
  rendererRef: HTMLElement;
  rendererSize: Size;
  isRendererInteraction: boolean;
}

export type ModeActionsAction = (state: State) => void;

export type ModeActions = {
  entry?: ModeActionsAction;
  exit?: ModeActionsAction;
  mousemove?: ModeActionsAction;
  mousedown?: ModeActionsAction;
  mouseup?: ModeActionsAction;
};
