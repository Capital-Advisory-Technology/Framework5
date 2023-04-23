#include <Critiq-Include/common/Logger.mqh>
#include <Critiq-Include/common/Logger.mqh>


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

        void InitLossLimit(double cLossPercent, int hours);

        bool LossLimit();
        bool CountLimit();
        bool SessionLimit();
        bool DayOfWeekLimit();

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

void Limits::InitLossLimit(double cLossPercent, int hours) {
    lossLimit = true;
    lossPercent = cLossPercent;
    lossHours = hours;

    Print("Loss limit set to: ", lossPercent, " in ", lossHours, " hours");
}

bool Limits::LossLimit() {
    // Checks if in defined period of time the loss is greater than the limit
    return false;
}


bool Limits::CountLimit() {
    // Checks if in defined period of time the number of trades is greater than the limit
    return false;
}

bool Limits::SessionLimit() {
    // Checks if in defined period of time the session is greater than the limit
    return false;
}

bool Limits::DayOfWeekLimit() {
    // Checks if in defined period of time the day of the week is greater than the limit
    return false;
}

bool Limits::getLimits() {
    if (lossLimit) {
        if (LossLimit()) {
            return true;
        }
    } else if (countLimit) {
        if (CountLimit()) {
            return true;
        }
    } else if (sessionLimit) {
        if (SessionLimit()) {
            return true;
        }
    } else if (dayOfWeekLimit) {
        if (DayOfWeekLimit()) {
            return true;
        }
    }

    return false;
}
