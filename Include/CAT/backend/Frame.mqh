

class Frame {
    protected:
        datetime prevBarTime;
        bool isNewBar();

    public:
        Frame(void);
        ~Frame(void);

        void OnBar();
        void OnTick();
};

extern Frame *frame; // create pointer to object

void Frame::Frame(void) { } // constructor

void Frame::~Frame(void) { }  // deconstructor

void Frame::OnTick() {
    
    /* should be made in a conveyer belt principle
    
       If (!isNewBar) return;

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

