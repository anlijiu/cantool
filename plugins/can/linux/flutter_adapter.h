

struct flutter_can_adapter {
    struct can_operator * _adaptee;
    FlMethodChannel* channel
};

void flutter_can_adapter_initialize(FlMethodChannel* channel);
void flutter_can_adapter_terminate();

