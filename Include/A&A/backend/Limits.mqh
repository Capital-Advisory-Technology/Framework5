class Limits {
    protected:
        int timeFrom;
        int timeTo;
    private:
        bool intraDayAllowed();
    public:
        Limits(void);
        ~Limits(void);

        void setIntraDay(int cTimeFrom = 0, int cTimeTo = 0) {
            timeFrom = cTimeFrom;
            timeTo = cTimeTo;
        };
        
        bool refresh();
};

Limits::Limits(void) : timeFrom(0),
                       timeTo(0) {}

Limits::~Limits(void) {}

bool Limits::intraDayAllowed() {
    if (timeFrom == 0 && timeTo == 0) return true;

    MqlDateTime dtNow;
    TimeCurrent(dtNow);
    int currentHour = dtNow.hour;

    if (timeFrom <= currentHour && currentHour <= timeTo) return true;
    
    return false;
}

bool Limits::refresh() {
    // Add extra functionality with && operators
    // Remember to write functions in allowed style
    return intraDayAllowed();
}