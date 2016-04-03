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

import android.content.res.Resources;
import android.content.Intent;
import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceScreen;
import android.preference.TwoStatePreference;
import android.view.MenuItem;

public class DeviceSettings extends PreferenceActivity  {

    public static final String KEY_DOUBLE_TAP_SWITCH = "double_tap";
    public static final String KEY_CAMERA_SWITCH = "camera";
    public static final String KEY_TORCH_SWITCH = "torch";
    public static final String KEY_VIBSTRENGTH = "vib_strength";
    public static final String KEY_OCLICK_CATEGORY = "oclick_category";
    public static final String KEY_OCLICK = "oclick";

    private TwoStatePreference mDoubleTapSwitch;
    private TwoStatePreference mTorchSwitch;
    private TwoStatePreference mCameraSwitch;
    private VibratorStrengthPreference mVibratorStrength;
    private Preference mOClickPreference;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getActionBar().setDisplayHomeAsUpEnabled(true);

        addPreferencesFromResource(R.xml.main);

        mDoubleTapSwitch = (TwoStatePreference) findPreference(KEY_DOUBLE_TAP_SWITCH);
        mDoubleTapSwitch.setEnabled(DoubleTapSwitch.isSupported());
        mDoubleTapSwitch.setChecked(DoubleTapSwitch.isEnabled(this));
        mDoubleTapSwitch.setOnPreferenceChangeListener(new DoubleTapSwitch());

        mTorchSwitch = (TwoStatePreference) findPreference(KEY_TORCH_SWITCH);
        mTorchSwitch.setEnabled(TorchGestureSwitch.isSupported());
        mTorchSwitch.setChecked(TorchGestureSwitch.isEnabled(this));
        mTorchSwitch.setOnPreferenceChangeListener(new TorchGestureSwitch());

        mCameraSwitch = (TwoStatePreference) findPreference(KEY_CAMERA_SWITCH);
        mCameraSwitch.setEnabled(CameraGestureSwitch.isSupported());
        mCameraSwitch.setChecked(CameraGestureSwitch.isEnabled(this));
        mCameraSwitch.setOnPreferenceChangeListener(new CameraGestureSwitch());

		mVibratorStrength = (VibratorStrengthPreference) findPreference(KEY_VIBSTRENGTH);
        mVibratorStrength.setEnabled(VibratorStrengthPreference.isSupported());

        final boolean oclickEnabled = getResources().getBoolean(R.bool.config_has_oclick);
        PreferenceCategory oclickCategory = (PreferenceCategory) findPreference(KEY_OCLICK_CATEGORY);
        if (!oclickEnabled) {
            getPreferenceScreen().removePreference(oclickCategory);
        }
        mOClickPreference = (Preference) findPreference(KEY_OCLICK);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
        case android.R.id.home:
            finish();
            return true;
        default:
            break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {
        if (preference == mOClickPreference) {
            Intent i = new Intent(Intent.ACTION_MAIN).setClassName("org.omnirom.omniclick","org.omnirom.omniclick.OClickControlActivity");
            startActivity(i);
            return true;
        }
        return super.onPreferenceTreeClick(preferenceScreen, preference);
    }
}
