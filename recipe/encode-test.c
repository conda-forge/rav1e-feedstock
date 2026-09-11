#include <stdio.h>
#include <string.h>
#include <rav1e.h>

int main(void) {
    RaConfig *config = rav1e_config_default();
    RaContext *context;
    RaFrame *frame;
    unsigned char y[64*64], uv[32*32];
    int packets = 0, ended = 0, step;
    if (!config) return 1;
    if (rav1e_config_parse_int(config, "width", 64) < 0 ||
        rav1e_config_parse_int(config, "height", 64) < 0 ||
        rav1e_config_parse_int(config, "speed", 10) < 0 ||
        rav1e_config_parse_int(config, "threads", 1) < 0 ||
        rav1e_config_parse(config, "low_latency", "true") < 0) return 2;
    context = rav1e_context_new(config);
    rav1e_config_unref(config);
    if (!context) return 3;
    frame = rav1e_frame_new(context);
    if (!frame) return 4;
    memset(y, 16, sizeof(y));
    memset(uv, 128, sizeof(uv));
    rav1e_frame_fill_plane(frame, 0, y, sizeof(y), 64, 1);
    rav1e_frame_fill_plane(frame, 1, uv, sizeof(uv), 32, 1);
    rav1e_frame_fill_plane(frame, 2, uv, sizeof(uv), 32, 1);
    if (rav1e_send_frame(context, frame) != RA_ENCODER_STATUS_SUCCESS) return 5;
    rav1e_frame_unref(frame);
    if (rav1e_send_frame(context, NULL) != RA_ENCODER_STATUS_SUCCESS) return 6;
    for (step = 0; step < 100; ++step) {
        RaPacket *packet = NULL;
        RaEncoderStatus status = rav1e_receive_packet(context, &packet);
        if (status == RA_ENCODER_STATUS_LIMIT_REACHED) { ended = 1; break; }
        if (status == RA_ENCODER_STATUS_ENCODED) continue;
        if (status != RA_ENCODER_STATUS_SUCCESS || !packet || !packet->len) return 7;
        ++packets;
        rav1e_packet_unref(packet);
    }
    rav1e_context_unref(context);
    if (!ended || packets != 1) return 8;
    puts("Installed rav1e encoded one 64x64 AV1 frame successfully");
    return 0;
}
