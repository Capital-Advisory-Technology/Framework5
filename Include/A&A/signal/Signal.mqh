#include <A&A/common/Enums.mqh>

class Signal {
    protected:
        string path;

    public:
        Signal(void){};
        ~Signal(void){};

        void Init();

        virtual SIGNAL_TYPE getSignal() { return 0; }
        virtual SIGNAL_TYPE getBias() { return 0; }
};