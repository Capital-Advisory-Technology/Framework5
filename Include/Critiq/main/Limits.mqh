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
    Print("Current hour: ", currentHour, " Time from: ", timeFrom, " Time to: ", timeTo);
    if (timeFrom == 0 && timeTo == 0) return true;
    if (timeFrom <= currentHour && currentHour <= timeTo) return true;
    
    return false;
}