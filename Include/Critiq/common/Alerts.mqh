#define ALERT_AMNT 9

class Alerts {
    protected:  
        bool alertOn;
        double priceLevels[ALERT_AMNT];

    public:
        Alerts(void);
        ~Alerts(void);

        bool sendMobile(string text) { return SendNotification(text); } 
        bool sendMail(string subject, string text) { return SendMail(subject, text); }
        bool setPrice(double &priceLevels[]);

};

extern Alerts *alerts;

Alerts::Alerts(void): alertOn(true) {}

void Alerts::~Alerts(void) {}


