//+------------------------------------------------------------------+
//|                                              Candle stick EA.mq5 |
//|                                   Copyright 2022, Yousuf Mesalm. |
//|                                    https://www.Yousuf-mesalm.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Yousuf Mesalm."
#property link      "https://www.Yousuf-mesalm.com"
#property link      "https://www.mql5.com/en/users/20163440"
#property description      "Developed by Yousuf Mesalm"
#property description      "https://www.Yousuf-mesalm.com"
#property description      "https://www.mql5.com/en/users/20163440"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   2
#property indicator_label1  "SQZPRo"
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_color1  clrAqua,clrYellow,clrRed,clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "SqueezeMomentumLine"
#property indicator_type2   DRAW_COLOR_ARROW 
#property indicator_color2  clrAqua, clrYellow, clrRed, clrBlue,clrOrange,clrLime
#property indicator_style2  STYLE_SOLID
#property indicator_width2  5
#include <Indicators\Trend.mqh>
#include <Indicators\Oscilators.mqh>
color colors[] =
  {
   clrAqua, clrYellow, clrRed, clrBlue,clrOrange,clrLime
  };

int length = 20;
CiMA SMA;
CiATR DEVKC;
CiStdDev DEVBB;
double mom[], price[];
double momColor[];
double iB[], iC[], lB[], lC[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SMA.Create(Symbol(), PERIOD_CURRENT, length, 0, MODE_SMA, MODE_CLOSE);
   DEVBB.Create(Symbol(), PERIOD_CURRENT, length, 0, MODE_SMA, MODE_CLOSE);
   DEVKC.Create(Symbol(), PERIOD_CURRENT, length);
//--- indicator buffers mapping
   SetIndexBuffer(0, mom, INDICATOR_DATA);
   SetIndexBuffer(1, momColor, INDICATOR_COLOR_INDEX);
   ArraySetAsSeries(mom, true);
   ArraySetAsSeries(momColor, true);
   SetIndexBuffer(2, price,  INDICATOR_CALCULATIONS);
   ArraySetAsSeries(price,   true);
   SetIndexBuffer(3, lB,    INDICATOR_DATA);
   SetIndexBuffer(4, lC,    INDICATOR_COLOR_INDEX);
      PlotIndexSetInteger(3,PLOT_ARROW,108);
//--- Set as an empty value 0
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0); 
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   if(rates_total <= length)
      return(0);
   int limit = rates_total - prev_calculated;
   if(limit > 1)
     {
      ArrayInitialize(mom, 0.0);
         ArrayInitialize(lB,    0);
         ArrayInitialize(lC,    0); 
      limit = rates_total - length - 1;
     }
   for(int i = limit; i >= 0; i--)
     {
      SMA.Refresh(-1);
      DEVBB.Refresh(-1);
      DEVKC.Refresh(-1);
      //Bollinger 2x
      double upBB = SMA.Main(i) + DEVBB.Main(i) * 2;
      double lowBB = SMA.Main(i) - DEVBB.Main(i) * 2;
      //Keltner 2x
      double upKCWide = SMA.Main(i) + DEVKC.Main(i) * 2;
      double lowKCWide = SMA.Main(i) - DEVKC.Main(i) * 2;
      //Keltner 1.5x
      double upKCNormal = SMA.Main(i) + DEVKC.Main(i)  * 1.5;
      double lowKCNormal = SMA.Main(i) - DEVKC.Main(i)  * 1.5;
      //Keltner 1x
      double upKCNarrow = SMA.Main(i) + DEVKC.Main(i) ;
      double lowKCNarrow = SMA.Main(i) - DEVKC.Main(i) ;
      double sqzOnWide  = (lowBB >= lowKCWide) && (upBB <= upKCWide) ;//WIDE SQUEEZE: ORANGE
      double sqzOnNormal  = (lowBB >= lowKCNormal) && (upBB <= upKCNormal); //NORMAL SQUEEZE: RED
      double sqzOnNarrow  = (lowBB >= lowKCNarrow) && (upBB <= upKCNarrow); //NARROW SQUEEZE: YELLOW
      double sqzOffWide = (lowBB < lowKCWide) && (upBB > upKCWide); //FIRED WIDE SQUEEZE: GREEN
      double noSqz  = (sqzOnWide == false) && (sqzOffWide == false); //NO SQUEEZE: BLUE
      int idxH = iHighest(NULL, 0, MODE_HIGH, length, i);
      if(idxH == -1)
         return false;
      int idxL = iLowest(NULL, 0, MODE_LOW, length, i);
      if(idxL == -1)
         return false;
      double avg = (high[idxH] + low[idxL]) / 2;
      avg = (avg + SMA.Main(i)) / 2 ;
      price[i] = close[i] - avg;
      double error;
      mom[i] = -LinearRegression(price, length, i, error);
      //Momentum histogram color
      int color_indrx = mom[i] > 0 ? mom[i] > mom[i + 1] ? 0 : 3 : mom[i] < mom[i + 1] ? 2 : 1 ;
      momColor[i] = color_indrx;
      PlotIndexSetInteger(0, PLOT_LINE_COLOR, 0, colors[color_indrx]);
      color_indrx = noSqz ? 3 : sqzOnNarrow ? 1 : sqzOnNormal ? 2 : sqzOnWide ? 4 : 5;
      lC[i]=color_indrx;
      lB[i]=0.001;
      PlotIndexSetInteger(3, PLOT_LINE_COLOR, 0, colors[color_indrx]);
     }
  
//--- return value of prev_calculated for next call
return(rates_total);
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LinearRegression(const double& array[], int period, int shift, double& error)
  {
   double sumy = 0,
          sumx = 0,
          sumxy = 0,
          sumx2 = 0;
   int iLimit = shift + period;
   for(int iBar = shift; iBar < iLimit; iBar++)
     {
      sumy += array[iBar];
      sumxy += array[iBar] * iBar;
      sumx += iBar;
      sumx2 += iBar * iBar;
     }
   double slope = (period * sumxy - sumx * sumy) / (sumx * sumx - period * sumx2) ;
   double intercept = (sumy + slope * sumx) / period;
//return intercept + slope * (period-1-shift);
   return slope;
  }

//+------------------------------------------------------------------+
