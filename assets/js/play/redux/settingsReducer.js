import _ from "underscore";
import { createReducer } from "reduxsauce";

import {Types} from "./actions";

const INITITAL_STATE = {
  open: false,
  font: "Monaco",
  fontSize: 16,
  lineHeight: 1.5,
}

export const settingsSetFont = (state, action) => {
  return {...state, font: action.font};
};

export const settingsSetFontSize = (state, action) => {
  return {...state, fontSize: parseInt(action.fontSize)};
};

export const settingsSetLineHeight = (state, action) => {
  return {...state, lineHeight: parseFloat(action.lineHeight)};
};

export const settingsToggle = (state, action) => {
  return {...state, open: !state.open};
};

export const HANDLERS = {
  [Types.SETTINGS_SET_FONT]: settingsSetFont,
  [Types.SETTINGS_SET_FONT_SIZE]: settingsSetFontSize,
  [Types.SETTINGS_SET_LINE_HEIGHT]: settingsSetLineHeight,
  [Types.SETTINGS_TOGGLE]: settingsToggle,
}

export const settingsReducer = createReducer(INITITAL_STATE, HANDLERS);
