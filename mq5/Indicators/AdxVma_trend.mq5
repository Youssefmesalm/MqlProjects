//------------------------------------------------------------------
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
//------------------------------------------------------------------
#property indicator_separate_window
#property indicator_buffers 7
#property indicator_plots   3
#property indicator_label1  "AdxVma trend filling"
#property indicator_type1   DRAW_FILLING
#property indicator_color1  C'160,231,160',C'231,160,160'
#property indicator_label2  "AdxVma trend histogram"
#property indicator_type2   DRAW_COLOR_HISTOGRAM
#property indicator_color2  clrGray,clrLimeGreen,clrGreen,clrRed,clrMaroon
#property indicator_width2  2
#property indicator_label3  "AdxVma trend"
#property indicator_type3   DRAW_COLOR_LINE
#property indicator_color3  clrGray,clrLimeGreen,clrRed
#property indicator_width3  2

//
//
//
//
//

enum enPrices
{
   pr_close,      // Close
   pr_open,       // Open
   pr_high,       // High
   pr_low,        // Low
   pr_median,     // Median
   pr_typical,    // Typical
   pr_weighted,   // Weighted
   pr_average,    // Average (high+low+open+close)/4
   pr_medianb,    // Average median body (open+close)/2
   pr_tbiased,    // Trend biased price
   pr_tbiased2,   // Trend biased (extreme) price
   pr_haclose,    // Heiken ashi close
   pr_haopen ,    // Heiken ashi open
   pr_hahigh,     // Heiken ashi high
   pr_halow,      // Heiken ashi low
   pr_hamedian,   // Heiken ashi median
   pr_hatypical,  // Heiken ashi typical
   pr_haweighted, // Heiken ashi weighted
   pr_haaverage,  // Heiken ashi average
   pr_hamedianb,  // Heiken ashi median body
   pr_hatbiased,  // Heiken ashi trend biased price
   pr_hatbiased2  // Heiken ashi trend biased (extreme) price
};
enum enMaTypes
{
   ma_sma,    // Simple moving average
   ma_ema,    // Exponential moving average
   ma_smma,   // Smoothed MA
   ma_lwma,   // Linear weighted MA
   ma_adxvma  // AdxVma
};

input ENUM_TIMEFRAMES TimeFrame         = PERIOD_CURRENT; // Time frame
input double          AdxVmaPeriod      = 10;             // AdxVma period
input enPrices        AdxVmaPrice       = pr_close;       // Price
input enMaTypes       SmoothMethod      = ma_adxvma;      // Smoothing method
input int             SmoothPeriod      = 5;              // Smoothing period (<=1 for no smoothing)
input bool            AlertsOn          = false;          // Turn alerts on?
input bool            AlertsOnCurrent   = true;           // Alert on current bar?
input bool            AlertsMessage     = true;           // Display messageas on alerts?
input bool            AlertsSound       = false;          // Play sound on alerts?
input bool            AlertsEmail       = false;          // Send email on alerts?
input bool            AlertsNotify      = false;          // Send push notification on alerts?
input bool            Interpolate       = true;           // Interpolate in multi time frame mode?


//
//
//
//
//

double  val[],valc[],valfu[],valfd[],histo[],histoc[],count[];
int     _mtfHandle = INVALID_HANDLE; ENUM_TIMEFRAMES timeFrame;
#define _mtfCall iCustom(_Symbol,timeFrame,getIndicatorName(),PERIOD_CURRENT,AdxVmaPeriod,AdxVmaPrice,SmoothMethod,SmoothPeriod,AlertsOn,AlertsOnCurrent,AlertsMessage,AlertsSound,AlertsEmail,AlertsNotify)


//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

void OnInit()
{
   SetIndexBuffer(0,valfu  ,INDICATOR_DATA);
   SetIndexBuffer(1,valfd  ,INDICATOR_DATA);
   SetIndexBuffer(2,histo ,INDICATOR_DATA);
   SetIndexBuffer(3,histoc,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(4,val    ,INDICATOR_DATA);
   SetIndexBuffer(5,valc   ,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(6,count ,INDICATOR_CALCULATIONS);
      for (int k=0; k<2; k++) PlotIndexSetInteger(k,PLOT_SHOW_DATA,false);
      timeFrame = MathMax(_Period,TimeFrame);
         if (timeFrame != _Period) _mtfHandle = _mtfCall;
      IndicatorSetString(INDICATOR_SHORTNAME,timeFrameToString(TimeFrame)+" AdxVma trend ("+string(AdxVmaPeriod)+","+string(SmoothPeriod)+")");
}
void OnDeinit(const int reason) { Comment(""); }

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

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
   if (Bars(_Symbol,_Period)<rates_total) return(-1);

      //
      //
      //
      //
      //

      if (timeFrame!=_Period)
      {
         double result[]; datetime currTime[],nextTime[]; 
            if (!timeFrameCheck(timeFrame,time))         return(0);
            if (_mtfHandle==INVALID_HANDLE) _mtfHandle = _mtfCall;
            if (_mtfHandle==INVALID_HANDLE)              return(0);
            if (CopyBuffer(_mtfHandle,6,0,1,result)==-1) return(0); 
      
                //
                //
                //
                //
                //
              
                #define _mtfRatio PeriodSeconds(timeFrame)/PeriodSeconds(_Period)
                int i,k,n,limit = MathMin(MathMax(prev_calculated-1,0),MathMax(rates_total-(int)result[0]*_mtfRatio-1,0));
                for (i=limit; i<rates_total && !_StopFlag; i++ )
                {
                  #define _mtfCopy(_buff,_buffNo) if (CopyBuffer(_mtfHandle,_buffNo,time[i],1,result)==-1) break; _buff[i] = result[0]
                          _mtfCopy(valfu ,0);
                          _mtfCopy(valfd ,1);
                          _mtfCopy(histo ,2);
                          _mtfCopy(histoc,3);
                          _mtfCopy(val   ,4);
                          _mtfCopy(valc  ,5);
                   
                          //
                          //
                          //
                          //
                          //
                   
                          if (!Interpolate) continue;  CopyTime(_Symbol,timeFrame,time[i  ],1,currTime); 
                              if (i<(rates_total-1)) { CopyTime(_Symbol,timeFrame,time[i+1],1,nextTime); if (currTime[0]==nextTime[0]) continue; }
                              for(n=1; (i-n)> 0 && time[i-n] >= currTime[0]; n++) continue;	
                              for(k=1; (i-k)>=0 && k<n; k++)
                              {
                                 #define _mtfInterpolate(_buff) _buff[i-k] = _buff[i]+(_buff[i-n]-_buff[i])*k/n
                                 _mtfInterpolate(histo);
                                 _mtfInterpolate(val   );
                                 _mtfInterpolate(valfu );
                                 _mtfInterpolate(valfd );
                              }                              
                }
                return(i);
      }

   //
   //
   //
   //
   //

   int i=(int)MathMax(prev_calculated-1,0); for (; i<rates_total  && !_StopFlag; i++)
   {
      double trendup,trenddn;
         iAdxvma(getPrice(AdxVmaPrice,open,close,high,low,i,rates_total),AdxVmaPeriod,i,rates_total,trendup,trenddn,1);
         val[i]    = (trendup>0) ? iCustomMa(SmoothMethod,trendup,SmoothPeriod,i,rates_total,0) : iCustomMa(SmoothMethod,trenddn,SmoothPeriod,i,rates_total,0);
         valc[i]   = (trendup>0) ? 1 : (trenddn>0) ? 2 : (i>0) ? valc[i-1] : 0; 
         valfu[i]  = (trendup>0) ? val[i] : 0;
         valfd[i]  = (trendup>0) ? 0 : val[i];
         histo[i]  = val[i];
         histoc[i] = (i>0) ? (valc[i]==1) ? (val[i]>val[i-1]) ? 1 : 2 : (val[i]<val[i-1]) ? 4 : 3 : 0;
   }      
   count[rates_total-1] = MathMax(rates_total-prev_calculated+1,1);
   manageAlerts(time,valc,rates_total);
   return(i);
}


//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
//
//
//
//
//

#define _adxvmaInstances     2
#define _adxvmaInstancesSize 7
double  _adxvmaWork[][_adxvmaInstances*_adxvmaInstancesSize];
#define _adxvmaWprc 0
#define _adxvmaWpdm 1
#define _adxvmaWmdm 2
#define _adxvmaWpdi 3
#define _adxvmaWmdi 4
#define _adxvmaWout 5
#define _adxvmaWval 6

double iAdxvma(double price, double period, int i, int bars, double& trendp, double& trendm, int instanceNo=0)
{
   if (ArrayRange(_adxvmaWork,0)!=bars) ArrayResize(_adxvmaWork,bars); instanceNo*=_adxvmaInstancesSize;
   
   //
   //
   //
   //
   //
   
   for (int k=0; k<7; k++) _adxvmaWork[i][instanceNo+k] = price;
   if (period>1)
   {
      double diff = (i>0) ? _adxvmaWork[i][instanceNo+_adxvmaWprc]-_adxvmaWork[i-1][instanceNo+_adxvmaWprc] : 0;
      double tpdm = (diff>0) ?  diff : 0;
      double tmdm = (diff<0) ? -diff : 0;
         _adxvmaWork[i][instanceNo+_adxvmaWpdm] = (i>0) ? ((period-1.0)*_adxvmaWork[i-1][instanceNo+_adxvmaWpdm]+tpdm)/period : tpdm;
         _adxvmaWork[i][instanceNo+_adxvmaWmdm] = (i>0) ? ((period-1.0)*_adxvmaWork[i-1][instanceNo+_adxvmaWmdm]+tmdm)/period : tmdm;

      double trueRange = _adxvmaWork[i][instanceNo+_adxvmaWpdm]+_adxvmaWork[i][instanceNo+_adxvmaWmdm];
      double tpdi      = (trueRange>0) ? _adxvmaWork[i][instanceNo+_adxvmaWpdm]/trueRange : 0;
      double tmdi      = (trueRange>0) ? _adxvmaWork[i][instanceNo+_adxvmaWmdm]/trueRange : 0;
         _adxvmaWork[i][instanceNo+_adxvmaWpdi] = (i>0) ? ((period-1.0)*_adxvmaWork[i-1][instanceNo+_adxvmaWpdi]+tpdi)/period : tpdi;
         _adxvmaWork[i][instanceNo+_adxvmaWmdi] = (i>0) ? ((period-1.0)*_adxvmaWork[i-1][instanceNo+_adxvmaWmdi]+tmdi)/period : tmdi;
                                         trendp = _adxvmaWork[i][instanceNo+_adxvmaWpdi]-0.5;
                                         trendm = _adxvmaWork[i][instanceNo+_adxvmaWmdi]-0.5;
   
      //
      //
      //
      //
      //
      
      double tout  = 0; 
         if ((_adxvmaWork[i][instanceNo+_adxvmaWpdi]+_adxvmaWork[i][instanceNo+_adxvmaWmdi])>0) 
               tout = MathAbs(_adxvmaWork[i][instanceNo+_adxvmaWpdi]-_adxvmaWork[i][instanceNo+_adxvmaWmdi])/(_adxvmaWork[i][instanceNo+_adxvmaWpdi]+_adxvmaWork[i][instanceNo+_adxvmaWmdi]);
                              _adxvmaWork[i][instanceNo+_adxvmaWout] = (i>0) ? ((period-1.0)*_adxvmaWork[i-1][instanceNo+_adxvmaWout]+tout)/period : tout;

      double thi = (i>0) ? MathMax(_adxvmaWork[i][instanceNo+_adxvmaWout],_adxvmaWork[i-1][instanceNo+_adxvmaWout]) : _adxvmaWork[i][instanceNo+_adxvmaWout];
      double tlo = (i>0) ? MathMin(_adxvmaWork[i][instanceNo+_adxvmaWout],_adxvmaWork[i-1][instanceNo+_adxvmaWout]) : _adxvmaWork[i][instanceNo+_adxvmaWout];
         for (int k = 2; k<period && i-k>=0; k++)
         {
            thi = MathMax(_adxvmaWork[i-k][instanceNo+_adxvmaWout],thi);
            tlo = MathMin(_adxvmaWork[i-k][instanceNo+_adxvmaWout],tlo);
         }            
      double vi = ((thi-tlo)>0) ? (_adxvmaWork[i][instanceNo+_adxvmaWout]-tlo)/(thi-tlo) : 0;
                                   _adxvmaWork[i][instanceNo+_adxvmaWval] = (i>0) ? ((period-vi)*_adxvmaWork[i-1][instanceNo+_adxvmaWval]+vi*_adxvmaWork[i][instanceNo+_adxvmaWprc])/period : price;

   }          
   
   //
   //
   //
   //
   //
   
   return(_adxvmaWork[i][instanceNo+_adxvmaWval]);
}

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
//
//
//
//
//

#define _maInstances 2
#define _maWorkBufferx1 1*_maInstances
double iCustomMa(int mode, double price, double length, int r, int bars, int instanceNo=0)
{
   double dummy;
   switch (mode)
   {
      case ma_sma    : return(iSma(price,(int)length,r,bars,instanceNo));
      case ma_ema    : return(iEma(price,length,r,bars,instanceNo));
      case ma_smma   : return(iSmma(price,(int)length,r,bars,instanceNo));
      case ma_lwma   : return(iLwma(price,(int)length,r,bars,instanceNo));
      case ma_adxvma : return(iAdxvma(price,length,r,bars,dummy,dummy,instanceNo));
      default        : return(price);
   }
}

//
//
//
//
//

double workSma[][_maWorkBufferx1];
double iSma(double price, int period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workSma,0)!= _bars) ArrayResize(workSma,_bars); int k=1;

   workSma[r][instanceNo+0] = price;
   double avg = price; for(; k<period && (r-k)>=0; k++) avg += workSma[r-k][instanceNo+0];  avg /= (double)k;
   return(avg);
}

//
//
//
//
//

double workEma[][_maWorkBufferx1];
double iEma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workEma,0)!= _bars) ArrayResize(workEma,_bars);

   workEma[r][instanceNo] = price;
   if (r>0 && period>1)
          workEma[r][instanceNo] = workEma[r-1][instanceNo]+(2.0/(1.0+period))*(price-workEma[r-1][instanceNo]);
   return(workEma[r][instanceNo]);
}

//
//
//
//
//

double workSmma[][_maWorkBufferx1];
double iSmma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workSmma,0)!= _bars) ArrayResize(workSmma,_bars);

   workSmma[r][instanceNo] = price;
   if (r>1 && period>1)
          workSmma[r][instanceNo] = workSmma[r-1][instanceNo]+(price-workSmma[r-1][instanceNo])/period;
   return(workSmma[r][instanceNo]);
}

//
//
//
//
//

double workLwma[][_maWorkBufferx1];
double iLwma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workLwma,0)!= _bars) ArrayResize(workLwma,_bars);
   
   workLwma[r][instanceNo] = price; if (period<1) return(price);
      double sumw = period;
      double sum  = period*price;

      for(int k=1; k<period && (r-k)>=0; k++)
      {
         double weight = period-k;
                sumw  += weight;
                sum   += weight*workLwma[r-k][instanceNo];  
      }             
      return(sum/sumw);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

void manageAlerts(const datetime& time[], double& trend[], int bars)
{
   if (!AlertsOn) return;
      int whichBar = bars-1; if (!AlertsOnCurrent) whichBar = bars-2; datetime time1 = time[whichBar];
      if (trend[whichBar] != trend[whichBar-1])
      {
         if (trend[whichBar] == 1) doAlert(time1,"up");
         if (trend[whichBar] == 2) doAlert(time1,"down");
      }         
}   

//
//
//
//
//

void doAlert(datetime forTime, string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != forTime) 
   {
      previousAlert  = doWhat;
      previousTime   = forTime;

      //
      //
      //
      //
      //

      message = timeFrameToString(_Period)+" "+_Symbol+" at "+TimeToString(TimeLocal(),TIME_SECONDS)+" AdxVma trend state changed to "+doWhat;
         if (AlertsMessage) Alert(message);
         if (AlertsEmail)   SendMail(_Symbol+" AdxVma trend",message);
         if (AlertsNotify)  SendNotification(message);
         if (AlertsSound)   PlaySound("alert2.wav");
   }
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//
//

#define _pricesInstances 1
#define _pricesSize      4
double workHa[][_pricesInstances*_pricesSize];
double getPrice(int tprice, const double& open[], const double& close[], const double& high[], const double& low[], int i,int _bars, int instanceNo=0)
{
  if (tprice>=pr_haclose)
   {
      if (ArrayRange(workHa,0)!= _bars) ArrayResize(workHa,_bars); instanceNo*=_pricesSize;
         
         //
         //
         //
         //
         //
         
         double haOpen;
         if (i>0)
                haOpen  = (workHa[i-1][instanceNo+2] + workHa[i-1][instanceNo+3])/2.0;
         else   haOpen  = (open[i]+close[i])/2;
         double haClose = (open[i] + high[i] + low[i] + close[i]) / 4.0;
         double haHigh  = MathMax(high[i], MathMax(haOpen,haClose));
         double haLow   = MathMin(low[i] , MathMin(haOpen,haClose));

         if(haOpen  <haClose) { workHa[i][instanceNo+0] = haLow;  workHa[i][instanceNo+1] = haHigh; } 
         else                 { workHa[i][instanceNo+0] = haHigh; workHa[i][instanceNo+1] = haLow;  } 
                                workHa[i][instanceNo+2] = haOpen;
                                workHa[i][instanceNo+3] = haClose;
         //
         //
         //
         //
         //
         
         switch (tprice)
         {
            case pr_haclose:     return(haClose);
            case pr_haopen:      return(haOpen);
            case pr_hahigh:      return(haHigh);
            case pr_halow:       return(haLow);
            case pr_hamedian:    return((haHigh+haLow)/2.0);
            case pr_hamedianb:   return((haOpen+haClose)/2.0);
            case pr_hatypical:   return((haHigh+haLow+haClose)/3.0);
            case pr_haweighted:  return((haHigh+haLow+haClose+haClose)/4.0);
            case pr_haaverage:   return((haHigh+haLow+haClose+haOpen)/4.0);
            case pr_hatbiased:
               if (haClose>haOpen)
                     return((haHigh+haClose)/2.0);
               else  return((haLow+haClose)/2.0);        
            case pr_hatbiased2:
               if (haClose>haOpen)  return(haHigh);
               if (haClose<haOpen)  return(haLow);
                                    return(haClose);        
         }
   }
   
   //
   //
   //
   //
   //
   
   switch (tprice)
   {
      case pr_close:     return(close[i]);
      case pr_open:      return(open[i]);
      case pr_high:      return(high[i]);
      case pr_low:       return(low[i]);
      case pr_median:    return((high[i]+low[i])/2.0);
      case pr_medianb:   return((open[i]+close[i])/2.0);
      case pr_typical:   return((high[i]+low[i]+close[i])/3.0);
      case pr_weighted:  return((high[i]+low[i]+close[i]+close[i])/4.0);
      case pr_average:   return((high[i]+low[i]+close[i]+open[i])/4.0);
      case pr_tbiased:   
               if (close[i]>open[i])
                     return((high[i]+close[i])/2.0);
               else  return((low[i]+close[i])/2.0);        
      case pr_tbiased2:   
               if (close[i]>open[i]) return(high[i]);
               if (close[i]<open[i]) return(low[i]);
                                     return(close[i]);        
   }
   return(0);
}

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

string getIndicatorName()
{
   string path = MQL5InfoString(MQL5_PROGRAM_PATH);
   string data = TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Indicators\\";
   string name = StringSubstr(path,StringLen(data));
      return(name);
}

//
//
//
//
//

int    _tfsPer[]={PERIOD_M1,PERIOD_M2,PERIOD_M3,PERIOD_M4,PERIOD_M5,PERIOD_M6,PERIOD_M10,PERIOD_M12,PERIOD_M15,PERIOD_M20,PERIOD_M30,PERIOD_H1,PERIOD_H2,PERIOD_H3,PERIOD_H4,PERIOD_H6,PERIOD_H8,PERIOD_H12,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
string _tfsStr[]={"1 minute","2 minutes","3 minutes","4 minutes","5 minutes","6 minutes","10 minutes","12 minutes","15 minutes","20 minutes","30 minutes","1 hour","2 hours","3 hours","4 hours","6 hours","8 hours","12 hours","daily","weekly","monthly"};
string timeFrameToString(int period)
{
   if (period==PERIOD_CURRENT) 
       period = _Period;   
         int i; for(i=0;i<ArraySize(_tfsPer);i++) if(period==_tfsPer[i]) break;
   return(_tfsStr[i]);   
}

//
//
//
//
//

bool timeFrameCheck(ENUM_TIMEFRAMES _timeFrame,const datetime& time[])
{
   static bool warned=false;
   if (time[0]<SeriesInfoInteger(_Symbol,_timeFrame,SERIES_FIRSTDATE))
   {
      datetime startTime,testTime[]; 
         if (SeriesInfoInteger(_Symbol,PERIOD_M1,SERIES_TERMINAL_FIRSTDATE,startTime))
         if (startTime>0)                       { CopyTime(_Symbol,_timeFrame,time[0],1,testTime); SeriesInfoInteger(_Symbol,_timeFrame,SERIES_FIRSTDATE,startTime); }
         if (startTime<=0 || startTime>time[0]) { Comment(MQL5InfoString(MQL5_PROGRAM_NAME)+"\nMissing data for "+timeFrameToString(_timeFrame)+" time frame\nRe-trying on next tick"); warned=true; return(false); }
   }
   if (warned) { Comment(""); warned=false; }
   return(true);
}