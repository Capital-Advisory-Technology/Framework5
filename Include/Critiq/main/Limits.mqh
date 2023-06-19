class Limits {
    protected:
        int timeFrom;
        int timeTo;
    
    public:
        Limits(void);
        ~Limits(void);

        void setIntraDay(int cTimeFrom, int cTimeTo) {
            timeFrom = cTimeFrom;
            timeTo = cTimeTo;
        };
        bool intraDayAllowed();
};

extern Limits *limits = new Limits;

Limits::Limits(void) : timeFrom(0),
                       timeTo(0) {}

Limits::~Limits(void) {}

bool Limits::intraDayAllowed() {
    MqlDateTime dtNow;
    TimeCurrent(dtNow);
    int currentHour = dtNow.hour;

    if (timeFrom == 0 && timeTo == 0) {
        Print("Limits | intraDayAllowed | No limits set");
        return true;
    }
    if (timeFrom <= currentHour && currentHour <= timeTo) {
        Print("Limits | intraDayAllowed | Intraday allowed");
        Print("Limits | intraDayAllowed | Time from: ", timeFrom, " Time to: ", timeTo, " Current hour: ", currentHour);
        return true;
    }
    
    return false;
}