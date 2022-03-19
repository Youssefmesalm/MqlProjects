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
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_plots   6
//---- plot The Asian session
#property indicator_label1  "Asian session High"
#property indicator_color1  MistyRose
#property indicator_style1  STYLE_DOT
#property indicator_width1  500

#property indicator_label2  " Asian session Low"
#property indicator_color2  MistyRose
#property indicator_style2  STYLE_DOT
#property indicator_width2  500

//---- plot The European session
#property indicator_label3  " European session Low"
#property indicator_color3  Lavender
#property indicator_style3  STYLE_DOT
#property indicator_width3  500
//---- plot The European session
#property indicator_label4  "European session High"

#property indicator_color4  Lavender
#property indicator_style4  STYLE_DOT
#property indicator_width4  500
//---- plot The American session
#property indicator_label5  "American session Low"
#property indicator_color5  PaleGreen
#property indicator_style5  STYLE_DOT
#property indicator_width5  500
//---- plot The American session
#property indicator_label6  "American session High"
#property indicator_color6  PaleGreen
#property indicator_style6  STYLE_DOT
#property indicator_width6  500




double      AsiaHigh[];
double      AsiaLow[];
double      EuropaHigh[];
double      EuropaLow[];
double      AmericaHigh[];
double      AmericaLow[];
//    Time constants are specified across Greenwich
const int   AsiaOpen=0;
const int   AsiaClose=9;
const int   AsiaOpenSummertime=1;   // The Asian session shifts
const int   AsiaCloseSummertime=10; // after the time changes
const int   EuropaOpen=6;
const int   EuropaClose=15;
const int   AmericaOpen=13;
const int   AmericaClose=22;
//    Global variable
int         ShiftTime;  //Displacement of the buffer for construction of the future sessions
double      HighForFutureSession;   // High for the future session
double      LowForFutureSession;    // Low for the future session
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  ChartForegroundSet(true,0);
//--- Verify Time Period
   if(PeriodSeconds(_Period)>=PeriodSeconds(PERIOD_H2))
     {
      return(-1);
     }
//--- Displacement of the buffer for construction of the future sessions
   ShiftTime=PeriodSeconds(PERIOD_D1)/PeriodSeconds(_Period);

//--- indicators
   SetIndexBuffer(0,AsiaHigh,INDICATOR_DATA);
   SetIndexBuffer(1,AsiaLow,INDICATOR_DATA);
   SetIndexBuffer(2,EuropaHigh,INDICATOR_DATA);
   SetIndexBuffer(3,EuropaLow,INDICATOR_DATA);
   SetIndexBuffer(4,AmericaHigh,INDICATOR_DATA);
   SetIndexBuffer(5,AmericaLow,INDICATOR_DATA);

   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexStyle(4,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexStyle(5,DRAW_HISTOGRAM,STYLE_DOT);
   IndicatorDigits(Digits);
   SetIndexShift(0,ShiftTime);
   SetIndexShift(1,ShiftTime);
   SetIndexShift(2,ShiftTime);
   SetIndexShift(3,ShiftTime);
   SetIndexShift(4,ShiftTime);
   SetIndexShift(5,ShiftTime);

//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {

//--- auxiliary variables
   int  i=1;

   MqlDateTime time1, time2;
//--- set position for beginning
   if(prev_calculated==0)
     {
      i=ShiftTime+1;
      ArrayInitialize(AsiaHigh, 0.0);
      ArrayInitialize(AsiaLow, 0.0);
      ArrayInitialize(EuropaHigh, 0.0);
      ArrayInitialize(EuropaLow, 0.0);
      ArrayInitialize(AmericaHigh, 0.0);
      ArrayInitialize(AmericaLow, 0.0);
     }
   else
      i=prev_calculated-ShiftTime;
//--- start calculations

   while(i<rates_total)
     {
      HighForFutureSession=MathMax(high[rates_total+1-i],high[rates_total+2-i]);
      LowForFutureSession=MathMin(low[rates_total+1-i],low[rates_total+2-i]);
      TimeToStruct(time[rates_total-1-i], time1);
      TimeToStruct(time[rates_total-i], time2);
      if(time1.day!=time2.day)
        {

         DrawTimeZone(time[rates_total-1-i],rates_total-1-i);
        }
      i++;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+--------------------------------------------------------------------+
// Summertime determination is reserved for the future calculations
//+--------------------------------------------------------------------+
bool Summertime(datetime time)
  {
   if(TimeDaylightSavings()!=0)
      return(true);
   else
      return(false);
  }
//+--------------------------------------------------------------------+
// Calculation and filling of buffers of time zones
//+--------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawTimeZone(datetime Start, int Index)
  {
   int rates_total,shift,shift_end,_startIndex=Index+ShiftTime;
   double high[], low[], HighSession, LowSession;
   datetime AsiaStart, AsiaEnd, EuropaStart, EuropaEnd, AmericaStart, AmericaEnd;
   datetime _start=Start+(TimeLocal()-TimeGMT());

// Processing of the Asian session
   AsiaStart=_start+(Summertime(Start)?AsiaOpenSummertime:AsiaOpen)*PeriodSeconds(PERIOD_H1);
   AsiaEnd=_start+(Summertime(Start)?AsiaCloseSummertime:AsiaClose)*PeriodSeconds(PERIOD_H1)-1;

   rates_total=CopyHigh(NULL,_Period,AsiaStart,AsiaEnd,high);

   if(rates_total<=0)
      HighSession=HighForFutureSession;
   else
      HighSession=high[ArrayMaximum(high,rates_total,0)];
   rates_total=CopyLow(NULL,_Period,AsiaStart,AsiaEnd,low);
   if(rates_total<=0)
      LowSession=LowForFutureSession;
   else
      LowSession=low[ArrayMinimum(low,rates_total,0)];
   shift=int((AsiaStart-Start)/PeriodSeconds(_Period));
   shift_end=int((AsiaEnd-Start)/PeriodSeconds(_Period)+1);

   for(int i=shift; i<shift_end ; i++)
     {

      AsiaHigh[_startIndex-i]=HighSession;
      AsiaLow[_startIndex-i]=LowSession;
     }

// Processing of the European session
   EuropaStart=_start+EuropaOpen*PeriodSeconds(PERIOD_H1);
   EuropaEnd=_start+EuropaClose*PeriodSeconds(PERIOD_H1)-1;
   rates_total=CopyHigh(NULL,_Period,EuropaStart,EuropaEnd,high);
   if(rates_total<=0)
      HighSession=HighForFutureSession;
   else
      HighSession=high[ArrayMaximum(high,rates_total,0)];
   rates_total=CopyLow(NULL,_Period,EuropaStart,EuropaEnd,low);
   if(rates_total<=0)
      LowSession=LowForFutureSession;
   else
      LowSession=low[ArrayMinimum(low,rates_total,0)];
   shift=int((EuropaStart-Start)/PeriodSeconds(_Period));
   shift_end=int((EuropaEnd-Start)/PeriodSeconds(_Period)+1);
   for(int x=shift; x<shift_end; x++)
     {

      EuropaHigh[_startIndex-x]=HighSession;
      EuropaLow[_startIndex-x]=LowSession;
     }

// Processing of the American session
   AmericaStart=_start+AmericaOpen*PeriodSeconds(PERIOD_H1);
   AmericaEnd=_start+AmericaClose*PeriodSeconds(PERIOD_H1)-1;
   rates_total=CopyHigh(NULL,_Period,AmericaStart,AmericaEnd,high);
   if(rates_total<=0)
      HighSession=HighForFutureSession;
   else
      HighSession=high[ArrayMaximum(high,rates_total,0)];
   rates_total=CopyLow(NULL,_Period,AmericaStart,AmericaEnd,low);
   if(rates_total<=0)
      LowSession=LowForFutureSession;
   else
      LowSession=low[ArrayMinimum(low,rates_total,0)];
   shift=int((AmericaStart-Start)/PeriodSeconds(_Period));
   shift_end=int((AmericaEnd-Start)/PeriodSeconds(_Period)+1);
   for(int z=shift; z<shift_end; z++)
     {
      AmericaHigh[_startIndex-z]=HighSession;
      AmericaLow[_startIndex-z]=LowSession;
     }
// Memory clearing
   ArrayResize(high,0);
   ArrayResize(low,0);
  }
//+------------------------------------------------------------------+
bool ChartForegroundSet(const bool value,const long chart_ID=0)
  {
//--- reset the error value
   ResetLastError();
//--- set property value
   if(!ChartSetInteger(chart_ID,CHART_FOREGROUND,0,value))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }