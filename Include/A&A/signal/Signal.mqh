#include <A&A/common/Enums.mqh>

class Signal {
    protected:
        string path;

    public:
        Signal(void){};
        ~Signal(void){};

        void Init();

        virtual ENUM_SIGNAL_TYPE GetSignal() { return 0; }
        virtual ENUM_SIGNAL_TYPE GetBias() { return 0; }
};