/*
 * Copyright (C) 2012 The Android Open Source Project
 * Copyright (C) 2014 The OmniROM Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <fcntl.h>
#include <dlfcn.h>

#define LOG_TAG "PowerHAL"
#include <utils/Log.h>

#include <hardware/hardware.h>
#include <hardware/power.h>

#include "util.h"

//#define LOG_NDEBUG 0

#define CPUFREQ_SCALING_MAX_PATH "scaling_max_freq"
#define MAX_CPU_PATH "/sys/devices/system/cpu/cpuquiet/cpuquiet_driver/max_cpus"
#define MAX_GPU_PATH "/sys/class/kgsl/kgsl-3d0/max_pwrlevel"
#define MIN_GPU_PATH "/sys/class/kgsl/kgsl-3d0/min_pwrlevel"

// we can handle those tags
#define PROFILE_MAX_CPU_NUM_TAG "maxCpu"
#define PROFILE_MAX_CPU_FREQ_TAG "maxFreq"
#define PROFILE_MAX_GPU_FREQ_TAG "maxGpu"
#define PROFILE_MAX_TAG "max"
#define PROFILE_SEPARATOR ":"

static int max_freq = 0;
static int max_cpus = 0;
static int min_gpu = 0;

static void write_cpuquiet_max(const char* value)
{
    char buf[80];

    if (!strcmp(value, PROFILE_MAX_TAG)) {
        sprintf(buf, "%d", max_cpus);
    } else {
        strcpy(buf, value);
    }
    ALOGV("write %s -> %s", MAX_CPU_PATH, buf);
    sysfs_write(MAX_CPU_PATH, buf);
}

static void write_gpu_max(const char* value)
{
    char buf[80];

    if (!strcmp(value, PROFILE_MAX_TAG)) {
        // hardcoded - we know 0 is the max
        sprintf(buf, "%d", 0);
    } else {
        int max_gpu = atoi(value);
        if (max_gpu > min_gpu) {
            ALOGV("maxGpu value %d > %d", max_gpu, min_gpu);
            sprintf(buf, "%d", 0);
        } else {
            strcpy(buf, value);
        }
    }
    ALOGV("write %s -> %s", MAX_GPU_PATH, buf);
    sysfs_write(MAX_GPU_PATH, buf);
}

static void write_cpufreq_values(const char* key, const char* value)
{
    char cpufreq_path[256];
    int i;
    char buf[80];

    if (!strcmp(value, PROFILE_MAX_TAG)) {
        sprintf(buf, "%d", max_freq);
    } else {
        strcpy(buf, value);
    }

    for (i = 0; i < max_cpus; i++) {
        write_cpufreq_value(i, key, buf);
    }
}

int get_min_gpu(char *gpu, int size) {
    return sysfs_read_buf(MIN_GPU_PATH, gpu, size);
}

static void apply_profile(char* profile)
{
    char *token;
    char *separator = PROFILE_SEPARATOR;
    char max_freq_profile[80];
    char max_cpu_profile[80];
    char max_gpu_profile[80];

    token = strtok(profile, separator);
    while(token != NULL) {
        ALOGV("token %s", token);
        if (!strcmp(token, PROFILE_MAX_CPU_NUM_TAG)) {
            token = strtok(NULL, separator);
            strcpy(max_cpu_profile, token);
        } else if (!strcmp(token, PROFILE_MAX_CPU_FREQ_TAG)) {
            token = strtok(NULL, separator);
            strcpy(max_freq_profile, token);
        } else if (!strcmp(token, PROFILE_MAX_GPU_FREQ_TAG)) {
            token = strtok(NULL, separator);
            strcpy(max_gpu_profile, token);
        }
        token = strtok(NULL, separator);
    }

    ALOGV("max_freq_profile %s", max_freq_profile);
    ALOGV("max_cpu_profile %s", max_cpu_profile);
    ALOGV("max_gpu_profile %s", max_gpu_profile);

    // the API will ignore invalid values so we dont need to check it here
    if (strlen(max_freq_profile) != 0) {
        write_cpufreq_values(CPUFREQ_SCALING_MAX_PATH, max_freq_profile);
    }
    if (strlen(max_cpu_profile) != 0) {
        write_cpuquiet_max(max_cpu_profile);
    }
    if (strlen(max_gpu_profile) != 0) {
        write_gpu_max(max_gpu_profile);
    }
}

static void power_init(struct power_module __unused *module)
{
    ALOGI("%s", __func__);

    char freq[80];
	if(get_max_freq(freq, sizeof(freq))==0){
	    max_freq = atoi(freq);
	}
    ALOGI("max_freq %s %d", freq, max_freq);
    char cpus[80];
	if(get_max_cpus(cpus, sizeof(cpus))==0){
	    if (strlen(cpus) == 3) {
	        max_cpus = atoi(cpus + 2) + 1;
	    }
	}
    ALOGI("max_cpus %s %d", cpus, max_cpus);
    char gpu[80];
	if(get_min_gpu(gpu, sizeof(gpu))==0){
	    min_gpu = atoi(gpu);
	}
    ALOGI("min_gpu %s %d", gpu, min_gpu);
}

static void power_set_interactive(struct power_module __unused *module, int on)
{
    ALOGV("%s %s", __func__, (on ? "ON" : "OFF"));
}

static void power_hint(struct power_module __unused *module, power_hint_t hint,
                       void *data) {
    switch (hint) {
        case POWER_HINT_INTERACTION:
            break;
        case POWER_HINT_VIDEO_ENCODE:
            break;
        case POWER_HINT_POWER_PROFILE:
            ALOGV("POWER_HINT_POWER_PROFILE %s", (char*)data);
            // profile is contributed as string with key value
            // pairs separated with ":"
            apply_profile((char*)data);
            break;
        case POWER_HINT_LOW_POWER:
            // handled by power profiles!
            ALOGV("POWER_HINT_LOW_POWER");
            break;
        default:
             break;
    }
}

static struct hw_module_methods_t power_module_methods = {
    .open = NULL,
};

struct power_module HAL_MODULE_INFO_SYM = {
    .common = {
        .tag = HARDWARE_MODULE_TAG,
        .module_api_version = POWER_MODULE_API_VERSION_0_2,
        .hal_api_version = HARDWARE_HAL_API_VERSION,
        .id = POWER_HARDWARE_MODULE_ID,
        .name = "find7a/s/op power HAL",
        .author = "The OmniROM Project",
        .methods = &power_module_methods,
    },

    .init = power_init,
    .setInteractive = power_set_interactive,
    .powerHint = power_hint,
};
