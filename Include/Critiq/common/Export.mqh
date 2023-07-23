class DataExport {
    protected:
        int db;
        double stat_values[3];

        void InitDatabase();

    public:
        DataExport();
        ~DataExport();

        void OnTesterInit();
        void OnTester();
        void OnTesterDeinit();
};

extern DataExport *dataExport = new DataExport;

DataExport::DataExport() {}
DataExport::~DataExport() {}

void DataExport::OnTesterInit() {
    db = DatabaseOpen("critiq", DATABASE_OPEN_CREATE | DATABASE_OPEN_READWRITE );
    if (db == INVALID_HANDLE) {
        Print(__FUNCTION__, ": Cannot open database");
    }
    InitDatabase();
}

void DataExport::OnTester() {
    double deposit = TesterStatistics(STAT_INITIAL_DEPOSIT);
    double TotalNetProfit = TesterStatistics(STAT_PROFIT);
    double MaximalDrawdown = MathMax(TesterStatistics(STAT_EQUITY_DD),TesterStatistics(STAT_BALANCE_DD));
    stat_values[0]=deposit;
    stat_values[1]=TotalNetProfit;
    stat_values[2]=MaximalDrawdown;

    FrameAdd("Statistics", 1, 0, stat_values);
}

void DataExport::OnTesterDeinit() {
    string name ="";  // Public name/frame label
    ulong  pass =0;   // Number of the optimization pass at which the frame is added
    long   id   =0;   // Public id of the frame
    double val  =0.0; // Single numerical value of the frame
    string parameter[];
    uint   parameter_count;

    while(FrameNext(pass,name,id,val,stat_values)) {
        if (FrameInputs(pass, parameter, parameter_count)) {
            for (uint i=0; i < parameter_count; i++) {
                // Print("Parameter ",i," = ",parameter[i]);
            }
        }

        for (int i=0; i < ArraySize(stat_values); i++) {
            // Print("Value ",i," = ",stat_values[i]);
        }
    }


    DatabaseClose(db);
}


void DataExport::InitDatabase() {

    if(!DatabaseTableExists(db, "strategies")) {
        if(!DatabaseExecute(db, "CREATE TABLE IF NOT EXISTS strategies(id INTEGER PRIMARY KEY, name TEXT NOT NULL, UNIQUE(name))")) {
                 Print("DB: ", " create table failed with code ", GetLastError());
        DatabaseClose(db);
        }
    }

    if(!DatabaseTableExists(db, "backtests")) {
        string query = "CREATE TABLE backtests("
                        "id INTEGER PRIMARY KEY, "
                        "strategy_id INTEGER NOT NULL, "
                        "symbol TEXT NOT NULL, "
                        "inputs TEXT NOT NULL, "
                        "FOREIGN KEY(strategy_id) REFERENCES strategies(id), "
                        "UNIQUE(inputs, symbol))";
        
        if(!DatabaseExecute(db, query)) {
            Print("DB: ", " create table failed with code ", GetLastError());
            DatabaseClose(db);
        }
    }

    if(!DatabaseTableExists(db, "backtests_stats")) {
        string query = "CREATE TABLE backtests_stats("
                        "id INTEGER PRIMARY KEY, "
                        "backtest_id INTEGER NOT NULL, "
                        "deposit REAL NOT NULL, "
                        "profit REAL NOT NULL, "
                        "max_dd REAL NOT NULL, "
                        "FOREIGN KEY(backtest_id) REFERENCES backtests(id))";
        
        if(!DatabaseExecute(db, query)) {
            Print("DB: ", " create table failed with code ", GetLastError());
            DatabaseClose(db);
        }
    }
}