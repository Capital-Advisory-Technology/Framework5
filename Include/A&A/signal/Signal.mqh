#include <A&A/common/Enums.mqh>

class Signal {
    public:
        virtual SIGNAL_TYPE getSignal() { return 0; }
        virtual SIGNAL_TYPE getBias() { return 0; }
};