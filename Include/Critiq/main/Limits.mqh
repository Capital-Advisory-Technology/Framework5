#include <Critiq/common/Logger.mqh>


class Limits {
    protected:
        bool lossLimit;
        bool countLimit;
        bool sessionLimit;
        bool dayOfWeekLimit;

        double lossPercent;
        int lossHours;

        int countAmount;
        string session;
        int dayOfWeek;  // this possibly should be a vector of bool

        

    public:
        Limits(void);
        ~Limits(void);

        void InitDailyLoss(double cLossPercent);
        void InitWeeklyLoss(double cLossPercent);
        
        void InitSession() {};

        // void InitLossLimit(double cLossPercent, int hours);

        // bool LossLimit();
        // bool CountLimit();
        // bool SessionLimit();
        // bool DayOfWeekLimit();

        bool getLimits();

};

Limits::Limits(void) :  lossLimit(false),
                        countLimit(false),
                        sessionLimit(false),
                        dayOfWeekLimit(false),
                        lossPercent(0),
                        countAmount(0),
                        session(""),
                        dayOfWeek(0)
{
}

Limits::~Limits(void)
{
}



bool Limits::getLimits() {
    
    return false;
}
