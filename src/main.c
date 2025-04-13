#include <android/native_activity.h>
#include <android_native_app_glue.h>
#include <android/log.h>
#include <EGL/egl.h>
#include <GLES3/gl3.h>

#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, "NativeApp", __VA_ARGS__)

void onAppCmd(struct android_app* app, int32_t cmd) {
    switch (cmd) {
        case APP_CMD_INIT_WINDOW:
            LOGI("Window initialized!");
            // Initialize OpenGL or other rendering here
            break;
        case APP_CMD_TERM_WINDOW:
            LOGI("Window terminated!");
            break;
    }
}

void android_main(struct android_app* state) {
    LOGI("Native app started!");

    // Set up command handler
    state->onAppCmd = onAppCmd;

    // Main loop
    int events;
    struct android_poll_source* source;
    while (1) {
        while (ALooper_pollAll(0, NULL, &events, (void**)&source) >= 0) {
            if (source != NULL) {
                source->process(state, source);
            }
            if (state->destroyRequested != 0) {
                LOGI("App destroy requested!");
                return;
            }
        }
        // Add rendering or logic here
    }
}
