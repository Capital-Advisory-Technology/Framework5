#include <Critiq-Include/main/Limits.mqh>
#include <Critiq-Include/Signals/TrendFlex2.mqh>

#property copyright "Copyright 2023, Critiq"
#property version   "1.00"

input int inpFastPeriod = 30;
input int inpSlowPeriod = 10;

TrendFlex trendFlex = new TrendFlex();

int OnInit() {
    Print("Fast period: " + inpFastPeriod); 
    Print("Slow period: " + inpSlowPeriod);

    trendFlex.setFastPeriod(60);
    trendFlex.setSlowPeriod(30);
  
    Print("HERE -- HERE -- HERE");

    Print("Fast period: " + trendFlex.getFastPeriod()); 
    Print("Slow period: " + trendFlex.getSlowPeriod());

    return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason) {
    

}

void OnTick() {

   
}
