ifneq ($(filter find7 find7op,$(TARGET_DEVICE)),)
    include $(all-subdir-makefiles)

# Symlink firmware from /persist
FIRMWARE_IMAGES := adsp.b00 adsp.b01 adsp.b02 adsp.b03 adsp.b04 adsp.b05 adsp.b06 adsp.b07 adsp.b08 adsp.b09 adsp.b10 adsp.b11 adsp.b12 adsp.mdt \
	mba.b00 mba.mdt \
	modem.b00 modem.b01 modem.b02 modem.b03 modem.b04 modem.b05 modem.b08 modem.b10 modem.b11 modem.b13 modem.b14 modem.b15 modem.b16 modem.b17 modem.b18 modem.b19 modem.b20 modem.b21 modem.b22 modem.b25 modem.b26 modem.b27 modem.mdt \
	wcnss.b00 wcnss.b01 wcnss.b02 wcnss.b04 wcnss.b06 wcnss.b07 wcnss.b08 wcnss.b09 wcnss.mdt \
	widevine.b00 widevine.b01 widevine.b02 widevine.b03 widevine.mdt \
	playread.b00 playread.b01 playread.b02 playread.b03 playread.mdt \
	mc_v2.b00 mc_v2.b01 mc_v2.b02 mc_v2.b03 mc_v2.mdt \
	keymaste.b00 keymaste.b01 keymaste.b02 keymaste.b03 keymaste.mdt \
	isdbtmm.b00 isdbtmm.b01 isdbtmm.b02 isdbtmm.b03 isdbtmm.mdt \
	cmnlib.b00 cmnlib.b01 cmnlib.b02 cmnlib.mdt \
	tqs.b00 tqs.b01 tqs.b02 tqs.b03 tqs.mdt

FIRMWARE_SYMLINKS := $(addprefix $(TARGET_OUT_ETC)/firmware/,$(notdir $(FIRMWARE_IMAGES)))
$(FIRMWARE_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "Firmware link: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /firmware/image/$(notdir $@) $@

ACDB_IMAGES := wcd9320_anc.bin wcd9320_mad_audio.bin wcd9320_mbhc.bin
ACDB_SYMLINKS := $(addprefix $(TARGET_OUT_ETC)/firmware/wcd9320/,$(notdir $(ACDB_IMAGES)))
$(ACDB_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "ACDB link: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /data/misc/audio/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(FIRMWARE_SYMLINKS) $(ACDB_SYMLINKS)

# Create a link for the WCNSS config file, which ends up as a writable
# version in /data/misc/wifi
$(shell mkdir -p $(TARGET_OUT)/etc/firmware/wlan/prima; \
    ln -sf /data/misc/wifi/WCNSS_qcom_cfg.ini \
            $(TARGET_OUT)/etc/firmware/wlan/prima/WCNSS_qcom_cfg.ini)

endif
