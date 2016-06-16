/*
* Copyright (C) 2016 The OmniROM Project
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
*/
package org.omnirom.device;

import android.content.Context;
import android.hardware.input.InputManager;
import android.os.Handler;
import android.os.Message;
import android.os.SystemClock;
import android.provider.Settings;
import android.util.Log;
import android.view.InputDevice;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;

import com.android.internal.os.DeviceKeyHandler;
import com.android.internal.util.ArrayUtils;

public class N3KeyHandler extends KeyHandler {

    private static final String TAG = N3KeyHandler.class.getSimpleName();
    private static final boolean DEBUG = false;

    // Supported scancodes
    private static final int KEY_BACK_BUTTON = 120;

    private EventHandler mEventHandler;

    public N3KeyHandler(Context context) {
        super(context);
        mEventHandler = new EventHandler();
    }

    private class EventHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            KeyEvent event = (KeyEvent) msg.obj;
            switch(event.getScanCode()) {
            case KEY_BACK_BUTTON:
                int keyCode = Settings.System.getInt(mContext.getContentResolver(),
                    Settings.System.BUTTON_EXTRA_KEY_MAPPING, 0);
                if (keyCode != 0) {
                    if (DEBUG) Log.i(TAG, "KEY_BACK_BUTTON -> " + keyCode);
                    triggerVirtualKeypress(keyCode);
                }
                break;
            }
        }
    }

    @Override
    public boolean canHandleKeyEvent(KeyEvent event) {
        if (event.getScanCode() == KEY_BACK_BUTTON) {
            return true;
        }
        return super.canHandleKeyEvent(event);
    }

    @Override
    public boolean handleKeyEvent(KeyEvent event) {
        if (event.getAction() != KeyEvent.ACTION_UP) {
            return false;
        }

        if (event.getScanCode() == KEY_BACK_BUTTON) {
            if (DEBUG) Log.i(TAG, "scanCode=" + event.getScanCode());
            if (!mEventHandler.hasMessages(GESTURE_REQUEST)) {
                Message msg = getMessageForKeyEvent(event);
                mEventHandler.sendMessage(msg);
            }
            return true;
        }
        return super.handleKeyEvent(event);
    }

    private Message getMessageForKeyEvent(KeyEvent keyEvent) {
        Message msg = mEventHandler.obtainMessage(GESTURE_REQUEST);
        msg.obj = keyEvent;
        return msg;
    }

    private void triggerVirtualKeypress(final int keyCode) {
        InputManager im = InputManager.getInstance();
        long now = SystemClock.uptimeMillis();

        final KeyEvent downEvent = new KeyEvent(now, now, KeyEvent.ACTION_DOWN,
                keyCode, 0, 0, KeyCharacterMap.VIRTUAL_KEYBOARD, 0,
                KeyEvent.FLAG_FROM_SYSTEM, InputDevice.SOURCE_KEYBOARD);
        final KeyEvent upEvent = KeyEvent.changeAction(downEvent,
                KeyEvent.ACTION_UP);

        im.injectInputEvent(downEvent,
                InputManager.INJECT_INPUT_EVENT_MODE_ASYNC);
        im.injectInputEvent(upEvent, InputManager.INJECT_INPUT_EVENT_MODE_ASYNC);
    }
}

