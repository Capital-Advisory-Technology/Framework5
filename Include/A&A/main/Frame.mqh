#include <A&A/backend/RiskManager.mqh>
#include <A&A/backend/PositionManager.mqh>
#include <A&A/signal/Signal.mqh>

class Frame {
    protected:
        Signal *signal;
        RiskManager *riskManager;

    private:
        datetime prevBarTime;
        bool isNewBar();

    public:
        Frame(void);
        ~Frame(void);

        void setSignal(Signal *csignal) { signal = csignal; }
        void setRisk(RiskManager *cRiskManager) { riskManager = cRiskManager; }
        
        void Run();
};

extern Frame *frame; // create pointer to object

void Frame::Run() {

    if (!isNewBar()) return;
    
    // if (!riskManager.checkMaxRisk()) return;

    // if (!profitsys.refresh()) return;

    // if (!limits.refresh()) return;

    // check for signal

    switch (signal.GetSignal()) {
        case SIGNAL_LONG:
            positionManager.orderOpen(riskManager.getOrderParams(ORDER_TYPE_BUY));
        case SIGNAL_SHORT:
            positionManager.orderOpen(riskManager.getOrderParams(ORDER_TYPE_SELL));
        case SIGNAL_IGNORE:
            break;
    }

    /*
        service deals (close, modify), ignore or hard stop
        riskManager.refresh();
        profitSystem.refresh();

        check for limitations, ignore or hard stop
        limits.?
    */
    
    /* 
    then we run engine

        first, service all open deals (modify)

        int result = positionManager.run();
        


        if positionManager allows additional deals ( execution logic)

        second, checking limits (time, loss, max loss)
            if any limit triggered - return
    */
    
    
    // to be added
}

bool Frame::isNewBar() {
    datetime barTime = iTime(_Symbol, _Period, 0);

    if (barTime != prevBarTime) {
        prevBarTime = barTime;
        return true;
    }

    return false;
}

void Frame::Frame(void) { } // constructor

void Frame::~Frame(void) {
    delete signal;
}  // deconstructor