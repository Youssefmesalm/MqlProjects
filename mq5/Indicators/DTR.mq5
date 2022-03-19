//+------------------------------------------------------------------+
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
#property strict

//includes
#include <MQL_Easy\Utilities\Utilities.mqh>
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   2
#property indicator_type1   DRAW_FILLING
#property indicator_type2   DRAW_FILLING
#property indicator_color1 clrLimeGreen,clrLimeGreen
#property indicator_color2 clrRed,clrRed
#property indicator_width1 1
#property indicator_width2 1
#property indicator_label1 "Upper Band"
#property indicator_label2 "LowerBand"


CUtilities tools;
//Buffers Arraus
datetime NewDayTime=0;
double DTRU[],DTRU1[],DTRD[],DTRD1[];
double TRU,TRU1,TRD,TRD1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

//--- indicator digits
   IndicatorSetInteger(INDICATOR_DIGITS,Digits());
//--- drawing style
   SetIndexBuffer(0,DTRU,INDICATOR_DATA);
   SetIndexBuffer(1,DTRU1,INDICATOR_DATA);
   SetIndexBuffer(2,DTRD,INDICATOR_DATA);
   SetIndexBuffer(3,DTRD1,INDICATOR_DATA);

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

   int limit;
   if(prev_calculated==0)
     {
      ArrayInitialize(DTRU,0);
      ArrayInitialize(DTRU1,0);
      ArrayInitialize(DTRD,0);
      ArrayInitialize(DTRD1,0);
      ArraySetAsSeries(DTRU,true);
      ArraySetAsSeries(DTRU1,true);
      ArraySetAsSeries(DTRD,true);
      ArraySetAsSeries(DTRD1,true);
      limit=rates_total-2;
     }
   else
      limit=rates_total-1-prev_calculated;
//--- the main loop of calculations
   int DayBars=iBars(Symbol(),PERIOD_D1);
   datetime Start=iTime(Symbol(),PERIOD_D1,DayBars-1);
   for(int i=limit; i>=0; i--)
     {
      datetime t=iTime(Symbol(),PERIOD_CURRENT,i);
      int idx=iBarShift(Symbol(),PERIOD_D1,t,false);
      datetime Day=iTime(Symbol(),PERIOD_D1,idx);
      if(idx<DayBars-1)
        {
         if(Day>NewDayTime)
           {
            double PDH=iHigh(Symbol(),PERIOD_D1,idx+1);
            double PDL=iLow(Symbol(),PERIOD_D1,idx+1);

            double YRANGE=(PDH-PDL)*0.55;
            double YRANGE1=(PDH-PDL)*0.35;
            NewDayTime=Day;
            TRU=iOpen(Symbol(),PERIOD_D1,idx)+YRANGE;
            TRD=iOpen(Symbol(),PERIOD_D1,idx)-YRANGE;
            TRU1=iOpen(Symbol(),PERIOD_D1,idx)+YRANGE1;
            TRD1=iOpen(Symbol(),PERIOD_D1,idx)-YRANGE1;
            DTRD[i]=TRD;
            DTRD1[i]=TRD1;
            DTRU[i]=TRU;
            DTRU1[i]=TRU1;
           }
         else
           {
            DTRD[i]=TRD;
            DTRD1[i]=TRD1;
            DTRU[i]=TRU;
            DTRU1[i]=TRU1;
           }
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
