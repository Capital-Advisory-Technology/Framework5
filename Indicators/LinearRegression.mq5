#property copyright   "CAT, 2024"
#property version     "1.00"
#property description "Linear Regression Line"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_label1  "Linear Regression Line"
#property indicator_type1   DRAW_LINE
#property indicator_color1 clrMediumSeaGreen

// input parameters
input int period = 14; // Linear regression period

// indicator buffers
double LinearRegBuffer[];

/* Custom indicator initialization function */
int OnInit() {
  // Indicator buffer initialization
  SetIndexBuffer(0, LinearRegBuffer, INDICATOR_DATA);

  // Accuracy
  IndicatorSetInteger(INDICATOR_DIGITS, _Digits+1);

  // First bar from which index to draw
  PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, period);
  // default set to EMPTY_VALUE
  PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
  
  // Indicator name
  IndicatorSetString(INDICATOR_SHORTNAME,"Generalized double DEMA ("+(string)period+")");

  return(INIT_SUCCEEDED);
}

/*
Linear Regression calculations
Currently only contains Close price
*/
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
   
  if (rates_total < period - 1 + begin)
    return(0);  
  
  // first calculations or number of bar change
  if (prev_calculated == 0) {
    ArrayInitialize(LinearRegBuffer, 0);
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, period - 1 + begin);
  }

  // fill linear regression buffer
  LinearRegression(rates_total, prev_calculated, begin, price);
  
  return(rates_total);
}

void LinearRegression(int rates_total, int prev_calculated, int begin, const double &price[]) {
  int i, start;

  if (prev_calculated == 0) {
    start = period + begin;
    LinearRegBuffer[begin] = price[begin];
    
    // set empty values for first start bars
    for (i = begin + 1; i < start; i++) {

      // linear regression formula
      double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

      for (int j = 0; j < period; j++) {
          int index = i - j;
          if (index < 0) continue; // Ensure we do not access out of bounds

          sumX += j;
          sumY += price[index];
          sumXY += j * price[index];
          sumX2 += j * j;
      }

      double b = (period * sumXY - sumX * sumY) / (period * sumX2 - sumX * sumX);
      double a = (sumY - b * sumX) / period;
      
      printf("Value of regression" + string(LinearRegBuffer[i]));

      LinearRegBuffer[i] = a + b * (period - 1);
    }  
  } else {
    start = prev_calculated - 1; 
  }
  
  /* Main loop
    Linear Regression calculation */
  for (i = start; i < rates_total && !IsStopped(); i++) {
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

    for(int j = 0; j < period; j++) {
        sumX += j;
        sumY += price[i - j];
        sumXY += j * price[i - j];
        sumX2 += j * j;
    }

    double b = (period * sumXY - sumX * sumY) / (period * sumX2 - sumX * sumX);
    double a = (sumY - b * sumX) / period;
    LinearRegBuffer[i] = a + b * (period - 1);
  } 
}