#include <Critiq-Include/common/Logger.mqh>

class Limits {
    protected:
        bool lossLimit;
        bool countLimit;
        bool sessionLimit;
        bool dayOfWeekLimit;

        double lossAmount;
        int countAmount;
        string session;
        int dayOfWeek;  // this possibly should be a vector of bools

    public:
        Limits(void);
        ~Limits(void);

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
                        lossAmount(0),
                        countAmount(0),
                        session(""),
                        dayOfWeek(0)
{
}

Limits::~Limits(void)
{
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
    if (lossLimit && LossLimit()) return true;
    if (countLimit && CountLimit()) return true;

    return false;
}
