# This file includes all definitions that apply to ALL oppo msm8974 devices,
#
# Everything in this directory will become public

DEVICE_PACKAGE_OVERLAYS := device/oppo/msm8974-common/overlay

COMMON_PATH := device/oppo/msm8974-common

# This device is xhdpi.  However the platform doesn't
# currently contain all of the bitmaps at xhdpi density so
# we do this little trick to fall back to the hdpi version
# if the xhdpi doesn't exist.
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

PRODUCT_PACKAGES += \
    charger_res_images

PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

#Default USB mount
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# Live Wallpapers
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    librs_jni

# Omni Packages
#PRODUCT_PACKAGES += \
#    OmniTorch

# Ramdisk
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/init.oppo.usb.rc:root/init.oppo.usb.rc \
    $(COMMON_PATH)/configs/init.oppo.common.rc:root/init.oppo.common.rc \
    $(COMMON_PATH)/configs/init.qcom.power.rc:root/init.qcom.power.rc \
    $(COMMON_PATH)/configs/ueventd.qcom.rc:root/ueventd.qcom.rc

# Config files for touch and input
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(COMMON_PATH)/configs/keylayout/atmel_mxt_ts.kl:system/usr/keylayout/atmel_mxt_ts.kl \
    $(COMMON_PATH)/configs/keylayout/Vendor_046d_Product_c216.kl:system/usr/keylayout/Vendor_046d_Product_c216.kl \
    $(COMMON_PATH)/configs/keylayout/Vendor_05ac_Product_0239.kl:system/usr/keylayout/Vendor_05ac_Product_0239.kl

# Media config files
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/media_codecs.xml:system/etc/media_codecs.xml \
    $(COMMON_PATH)/media_codecs_performance.xml:system/etc/media_codecs_performance.xml \
    $(COMMON_PATH)/media_profiles.xml:system/etc/media_profiles.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml

# Audio config files
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/audio_policy.conf:system/etc/audio_policy.conf \
    $(COMMON_PATH)/mixer_paths.xml:/system/etc/mixer_paths.xml

# MSM IPC Router security configuration
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/sec_config:system/etc/sec_config

#thermal-engine
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/thermal-engine-8974.conf:system/etc/thermal-engine-8974.conf

# Wifi config
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf \
    $(COMMON_PATH)/configs/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

# Hardware modules to build
PRODUCT_PACKAGES += \
    hwcomposer.msm8974 \
    gralloc.msm8974 \
    copybit.msm8974 \
    memtrack.msm8974 \
    audio.primary.msm8974 \
    audio_policy.msm8974 \
    lights.qcom \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \
    camera-wrapper.msm8974 \
    libaudio-resampler \
    audiod \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    power.msm8974 \
    keystore.msm8974 \
    libshim_camera \
    libshim_wvm

PRODUCT_PACKAGES += \
    libmm-omxcore \
    libdivxdrmdecrypt \
    libOmxVdec \
    libOmxVenc \
    libOmxCore \
    libstagefrighthw \
    libc2dcolorconvert \
    libxml2 \
    libboringssl-compat

#    libOmxAacEnc \
#    libOmxAmrEnc \
#    libOmxEvrcEnc \
#    libOmxQcelp13Enc \

# wifi
PRODUCT_PACKAGES += \
    wcnss_service \
    libwpa_client \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/init.qcom.bt.sh:system/etc/init.qcom.bt.sh

# Device settings
PRODUCT_PACKAGES += \
    Find7Parts

# NFC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
    frameworks/base/nfc-extras/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml

PRODUCT_PACKAGES += \
    Tag \
    com.android.nfc_extras

ifeq ($(TARGET_BUILD_VARIANT),user)
    NFCEE_ACCESS_PATH := $(COMMON_PATH)/configs/nfcee_access.xml
else
    NFCEE_ACCESS_PATH := $(COMMON_PATH)/configs/nfcee_access_debug.xml
endif
PRODUCT_COPY_FILES += \
    $(NFCEE_ACCESS_PATH):system/etc/nfcee_access.xml

# GPS
PRODUCT_PACKAGES += \
    gps.msm8974

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gps/flp.conf:system/etc/flp.conf \
    $(LOCAL_PATH)/gps/gps.conf:system/etc/gps.conf \
    $(LOCAL_PATH)/gps/izat.conf:system/etc/izat.conf \
    $(LOCAL_PATH)/gps/quipc.conf:system/etc/quipc.conf \
    $(LOCAL_PATH)/gps/sap.conf:system/etc/sap.conf

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/power_profiles.xml:system/etc/power_profiles.xml

# Properties

# bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qualcomm.bt.hci_transport=smd

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196608 \
    persist.hwc.mdpcomp.enable=true

# Do not power down SIM card when modem is sent to Low Power Mode.
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.apm_sim_not_pwdn=1

# Ril sends only one RIL_UNSOL_CALL_RING, so set call_ring.multiple to false
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.call_ring.multiple=0

# Ril
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/vendor/lib/libril-qc-qmi-1.so

# Cell Broadcasts
PRODUCT_PROPERTY_OVERRIDES += \
    ro.cellbroadcast.emergencyids=0-65534

PRODUCT_PROPERTY_OVERRIDES += \
    telephony.lteOnGSMDevice=1 \
    ro.telephony.default_network=9

PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0

# Enable AAC 5.1 output
PRODUCT_PROPERTY_OVERRIDES += \
    media.aac_51_output_enabled=true

# Oppo-specific
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.oppo.version=US \
    ro.xxversion=V1.0 \
    ro.bootversion=V1.1

# qcom
PRODUCT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1 \
    media.stagefright.legacyencoder=true \
    media.stagefright.less-secure=true

# Audio Configuration
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qc.sdk.audio.fluencetype=fluence \
    persist.audio.fluence.voicecall=true \
    audio.offload.buffer.size.kb=32 \
    audio.offload.gapless.enabled=true \
    use.voice.path.for.pcm.voip=true \
    audio.offload.video=true \
    av.streaming.offload.enable=false \
    audio.offload.pcm.16bit.enable=true \
    audio.offload.multiple.enabled=false

# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=/vendor/lib/libqti-perfd-client.so

# gps
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qc_nlp_in_use=0 \
    ro.gps.agps_provider=1

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# sensors
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qc.sdk.camera.facialproc=true \
    ro.qc.sdk.gestures.camera=false \
    ro.qti.sdk.sensors.gestures=true \
    ro.qti.sensors.bte=true \
    ro.qti.sensors.gtap=true \
    ro.qti.sensors.vmd=true

# Sensor configuration from Oppo
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/sensor/sap.conf:system/etc/sap.conf

# Inherit from proprietary blobs
$(call inherit-product, vendor/oppo/msm8974-common/msm8974-common-vendor.mk)
