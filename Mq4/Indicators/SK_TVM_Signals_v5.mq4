
//+------------------------------------------------------------------+
//|                                                    SK_TVM_EA.mq4 |
//|                                https://www.yousuf-mesalm.com     |
//+------------------------------------------------------------------+
#define Copyright          "Copyright © 2020 YM Labs"
#property copyright        Copyright
#define Link               "https://www.yousuf-mesalm.com "
#property link             Link
#define Version            "1.00"
#property version          Version
#property strict

//---
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Black
#define ExpertName         "SK_TVM"
#define OBJPREFIX          "MT - "
//---

//---
#define CLIENT_BG_WIDTH    1190
#define INDENT_TOP         15
//---
#define OPENPRICE          0
#define CLOSEPRICE         1
//---
#define OP_ALL            -1
//---
#define KEY_UP             38
#define KEY_DOWN           40

//---
enum ENUM_TF {DAILY/*Daily*/,WEEKLY/*Weekly*/,MONTHLY/*Monthly*/};
enum ENUM_MODE {FULL/*Full*/,COMPACT/*Compact*/,MINI/*Mini*/};
//--- User inputs
input int Pairs_By_Page =6;
int  Pairs_N_page =Pairs_By_Page-1;

input int FirstBB_Period=20;
input double FirstBB_Deviation=1;
input ENUM_APPLIED_PRICE FirstBB_Applied=PRICE_CLOSE;
input int SeconedBB_Period=20;
input double SeconedBB_Deviation=4;
input ENUM_APPLIED_PRICE SeconedBB_Applied=PRICE_CLOSE;
input ENUM_TIMEFRAMES CandleStickPatternTF=PERIOD_CURRENT;
// News inputs
sinput string News="<----------------------News Settings >-------------";
string gs_76 = "";
int g_window_84 = 0;
string gsa_88[7] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
string gsa_92[12] = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
extern string o_______Table_______o = "";
extern bool DisplayTable = TRUE;
extern string TableTitle = "Calendar";
extern bool NarrowTable = FALSE;
bool TableShowClock = false;
extern int TableNumEvents = 10;
extern int TableLookBackMns = 30;
extern int TableLookAheadHrs = 48;
extern int TableHorizAlign = 1;
extern int TableVertAlign = -1;
extern int TableSubWindow = 0;
extern bool TableBackground = TRUE;
extern string o_____VertLines____o = "";
extern bool DisplayVertLines = FALSE;
extern int VLineMaxPeriod = 15;
extern int VLineLookAheadMns = 60;
extern string o______Filters______o = "";
bool gi_180 = TRUE;
extern bool IncludeLowImpact = TRUE;
extern bool IncludeMediumImpact = TRUE;
extern bool IncludeHighImpact = TRUE;
extern bool IncludeHolidays = TRUE;
extern bool IncludeMeetings = TRUE;
extern bool IncludeSpeeches = TRUE;
bool gi_208 = TRUE;
bool gi_212 = TRUE;
bool gi_216 = TRUE;
extern bool IncludeSymbolCurrencies = TRUE;
extern string CurrencyFilterList = "ALL";
extern string o______Alarms_______o = "";
extern bool SoundAlarms = TRUE;
extern string Alarm1Wav = "";
extern int Alarm1Mns = 5;
extern string Alarm2Wav = "news.wav";
extern int Alarm2Mns = 0;
extern string o______Colors_______o = "";
extern color ColorBreaking = LimeGreen;
extern color ColorHigh = C'0xFF,0x20,0x00';
extern color ColorMedium = C'0xFF,0x9F,0x00';
extern color ColorLow = C'0xDC,0xD7,0x1D';
extern color ColorHoliday = CadetBlue;
extern color ColorDefault = C'0xC8,0xC8,0xC8';
extern color ColorBack1 = C'0x20,0x38,0x40';
extern color ColorBack2 = C'0x18,0x2A,0x30';
extern string o_______Data________o = "";
extern bool UseAlternateSource = FALSE;
input int ExpiryAfter_x_Miniutes=5;
datetime signal_time=0;

int snrStatus=-1;
datetime singalTime[];

#include <Arrays\ArrayObj.mqh>

//--- input variables
input  string   InpFileName  = "summary_by_symbols.csv"; // Filename
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/// Class CSymbolSummary for grouping closed trades by symbol in ArrayObj.
class CSymbolSummary : public CObject
  {
public:
   string            symbol;
   int               count;
   double            vols;
   double            prof;
   double            comm;
   double            swap;
public:
                     CSymbolSummary() : count(0),vols(0),prof(0),comm(0),swap(0) {   }
                    ~CSymbolSummary() {   }
   void              Update(double v,double p,double c,double s) { vols+=v; prof+=p; comm+=c; swap+=s; count+=1; }
public:
   //--- method of comparing the objects
   virtual int       Compare(const CObject *node,const int mode=0) const
     {
      const CSymbolSummary *obj=dynamic_cast<const CSymbolSummary *>(node);
      return(StringCompare(this.symbol,obj.symbol));  // 1, 0, -1
     }
  };

input string  G="                    < - - -  General  - - - >";
ENUM_MODE SelectedMode  = COMPACT;/*Dashboard (Size)*/
input double  BuyLevel            = 90;
input double SellLevel           = 10;
input string Prefix           = "";//Symbol Prefix
input string Suffix           = "";//Symbol Suffix
string TradeSymbols    = "AUDCAD;AUDCHF;AUDJPY;AUDNZD;AUDUSD;CADCHF;CADJPY;CHFJPY;EURAUD;EURCAD;EURCHF;EURGBP;EURJPY;EURNZD;EURUSD;GBPAUD;GBPCAD;GBPCHF;GBPNZD;GBPUSD;GBPJPY;NZDCHF;NZDCAD;NZDJPY;NZDUSD;USDCAD;USDCHF;USDJPY;";/*Symbol List (separated by " ; ")*/


input string                  G1= "                    < - - -  Alerts  - - - >";
input bool SmartAlert         = true;/*Smart Alerts*/
input bool _Alert             = true;/*Pop-ups*/
input bool Push               = false;/*Push*/
input bool Mail               = false;/*Email*/
input string                 G2 = "                    < - - -  Graphics  - - - >";
input color COLOR_BORDER      = C'255,151,25';/*Panel Border*/
input color COLOR_CBG_LIGHT   = C'252,252,252';/*Chart Background (Light)*/
input color COLOR_CBG_DARK    = C'28,27,26';/*Chart Background (Dark)*/



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
   pr_haopen,     // Heiken ashi open
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
enum enColorOn
  {
   cc_onSlope,   // Change color on slope change
   cc_onMiddle,  // Change color on middle line cross
   cc_onLevels   // Change color on outer levels cross
  };
enum enLevelType
  {
   lev_float, // Floating levels
   lev_quan   // Quantile levels
  };


//--- Global variables
string sTradeSymbols          = TradeSymbols;
string sFontType              = "";
//---
double RiskP                  = 0;
double RiskC                  = 0;
double RiskInpC               = 0;
double RiskInpP               = 0;
//---
int ResetAlertUp              = 0;
int ResetAlertDwn             = 0;
bool UserIsEditing            = false;
bool UserWasNotified          = false;
//---
double StopLossDist           = 0;
double RiskInp                = 0;
double RR                     = 0;
double _TP                    = 0;
//---
int SelectedTheme             = 1;
int PriceRowLeft              = 0;
int PriceRowRight             = 0;
bool ShowTradePanel           = true;
//---
int ErrorInterval             = 300;
int LastReason                = 0;
string ErrorSound             = "error.wav";
bool SoundIsEnabled           = false;
bool AlarmIsEnabled           = false;
int ProfitMode                = 0;
//---
bool AUDAlarm                 = true;
bool CADAlarm                 = true;
bool CHFAlarm                 = true;
bool EURAlarm                 = true;
bool GBPAlarm                 = true;
bool JPYAlarm                 = true;
bool NZDAlarm                 = true;
bool USDAlarm                 = true;
//---
bool AUDTrigger               = false;
bool CADTrigger               = false;
bool CHFTrigger               = false;
bool EURTrigger               = false;
bool GBPTrigger               = false;
bool JPYTrigger               = false;
bool NZDTrigger               = false;
bool USDTrigger               = false;
//----
string SuggestedPair          = "";
int LastTimeFrame             = 0;
int LastMode                  = -1;
//---
bool AutoSL                   = false;
bool AutoTP                   = false;
bool AutoLots                 = false;
bool ClearedTemplate          = false;
bool FirstRun                 = true;
//---
color COLOR_BG                = clrNONE;
color COLOR_FONT              = clrNONE;
//---
color COLOR_GREEN             = clrForestGreen;
color COLOR_RED               = clrFireBrick;
color COLOR_SELL              = C'225,68,29';
color COLOR_BUY               = C'3,95,172';
color COLOR_CLOSE             = clrNONE;
color COLOR_AUTO              = clrDodgerBlue;
color COLOR_LOW               = clrNONE;
color COLOR_MARKER            = clrNONE;
int FONTSIZE                  = 9;
//---
int _x1                       = 0;
int _y1                       = 0;
int ChartX                    = 0;
int ChartY                    = 0;
int Chart_XSize               = 0;
int Chart_YSize               = 0;
int CalcTF                    = 0;
datetime drop_time            = 0;
datetime stauts_time          = 0;
//---
color COLOR_REGBG             = C'27,27,27';
color COLOR_REGFONT           = clrSilver;
//---
int Bck_Win_X                 = 255;
int Bck_Win_Y                 = 150;
//---
string newpairs[];
string UsedSymbols[];
//---
string MB_CAPTION=ExpertName+" v"+Version+" | "+Copyright;
//---
string PriceRowLeftArr[]= {"Bid","Low","Open","Pivot"};
string PriceRowRightArr[]= {"Ask","High","Open","Pivot"};

datetime tim1,tim2,tim3,tim4,tim5,tim6,tim7,tim8,tim9;
//string Symbols[];
int signal[][6];




//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   IndicatorShortName(ExpertName);

   int HowManySymbols=SymbolsTotal(true);
   string ListSymbols=" ";
   for(int i=0; i<HowManySymbols; i++)
     {
      ListSymbols=StringConcatenate(ListSymbols,SymbolName(i,true),",");
     }

   u_sep=StringGetCharacter(sep,0);
   kz=StringSplit(ListSymbols,u_sep,newpairs);
   int index =0;
   int index2 =0;


   ArrayResize(finalpairs,ArraySize(newpairs));
   for(int i=0; i<ArraySize(newpairs); i++)
     {
      finalpairs[index2]=newpairs[i];
      index2++;
     }
   ArrayResize(currentpage,Pairs_N_page+1);

   for(int i=0; i<=Pairs_N_page; i++)
     {
      currentpage[i]=finalpairs[starter-i];

     }
   ArrayResize(singalTime,ArraySize(currentpage));
   for(int i=0; i<ArraySize(singalTime); i++)
     {
      singalTime[i]=0;
     }
//---- CreateTimer
   EventSetMillisecondTimer(100);

//--- StrategyTester
   if(MQLInfoInteger(MQL_TESTER))
     {
      _OnTester();
      return(INIT_SUCCEEDED);
     }

//--- Disclaimer
   if(!GlobalVariableCheck(OBJPREFIX+"Disclaimer") || GlobalVariableGet(OBJPREFIX+"Disclaimer")!=1)
     {
      //---
      string message="hope you like this product";
      //---
      if(MessageBox(message,MB_CAPTION,MB_OKCANCEL|MB_ICONWARNING)==IDOK)
         GlobalVariableSet(OBJPREFIX+"Disclaimer",1);


     }

//---
   if(!GlobalVariableCheck(OBJPREFIX+"Theme"))
      SelectedTheme=1;
   else
      SelectedTheme=(int)GlobalVariableGet(OBJPREFIX+"Theme");

//---
   if(SelectedTheme==0)
     {
      COLOR_BG=C'240,240,240';
      COLOR_FONT=C'40,41,59';
      COLOR_GREEN=clrForestGreen;
      COLOR_RED=clrIndianRed;
      COLOR_LOW=clrGoldenrod;
      COLOR_MARKER=clrDarkOrange;
     }
   else
     {
      COLOR_BG=C'28,28,28';
      COLOR_FONT=clrSilver;
      COLOR_GREEN=clrLimeGreen;
      COLOR_RED=clrRed;
      COLOR_LOW=clrYellow;
      COLOR_MARKER=clrGold;
     }

//---
   if(LastReason==0)
     {

      //--- OfflineChart
      if(ChartGetInteger(0,CHART_IS_OFFLINE))
        {
         MessageBox("The currenct chart is offline, make sure to uncheck \"Offline chart\" under Properties(F8)->Common.",
                    MB_CAPTION,MB_OK|MB_ICONERROR);

        }

      //--- CheckConnection
      if(!TerminalInfoInteger(TERMINAL_CONNECTED))
         MessageBox("Warning: No Internet connection found!\nPlease check your network connection.",
                    MB_CAPTION+" | "+"#"+IntegerToString(123),MB_OK|MB_ICONWARNING);

      //---
      if(!SymbolInfoInteger(_Symbol,SYMBOL_TRADE_MODE))//Symbol
         MessageBox("Warning: Trading is disabled for the symbol "+_Symbol+" at the trade server side.",
                    MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED),MB_OK|MB_ICONWARNING);

      //--- CheckDotsPerInch
      if(TerminalInfoInteger(TERMINAL_SCREEN_DPI)!=96)
        {
         Comment("Warning: 96 DPI highly recommended !");
         Sleep(3000);
         Comment("");
        }

     }

//--- Init ChartSize
   Chart_XSize = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
   Chart_YSize = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
   ChartX=Chart_XSize;
   ChartY=Chart_YSize;

//--- CheckSoundIsEnabled
   if(!GlobalVariableCheck(OBJPREFIX+"Sound"))
      SoundIsEnabled=true;
   else
      SoundIsEnabled=GlobalVariableGet(OBJPREFIX+"Sound");

//--- Alert
   if(!GlobalVariableCheck(OBJPREFIX+"Alarm"))
      AlarmIsEnabled=true;
   else
      AlarmIsEnabled=GlobalVariableGet(OBJPREFIX+"Alarm");

   if(!_Alert && !Push && !Mail)
     {
      //---
      AlarmIsEnabled=false;
      //---
      if(ObjectFind(0,OBJPREFIX+"ALARMIO")==0)
         if(ObjectGetInteger(0,OBJPREFIX+"ALARMIO",OBJPROP_COLOR)!=C'59,41,40')
            ObjectSetInteger(0,OBJPREFIX+"ALARMIO",OBJPROP_COLOR,C'59,41,40');
     }

//---
   if(!GlobalVariableCheck(OBJPREFIX+"Dashboard"))
      ShowTradePanel=true;
   else
      ShowTradePanel=GlobalVariableGet(OBJPREFIX+"Dashboard");

//---
   if(LastReason==0)
      ChartGetColor();

//--- Hide OneClick Arrow
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,true);
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,false);

//--- ChartChanged
   if(LastReason==REASON_CHARTCHANGE)
      _PlaySound("switch.wav");

//---
   if(ShowTradePanel)
      ChartMouseScrollSet(false);
   else
      ChartMouseScrollSet(true);


//---
   if(SelectedMode!=LastMode)
      ObjectsDeleteAll(0,OBJPREFIX,-1,-1);

//--- Init Speed Prices
   for(int i=ArraySize(newpairs)-1; i>=0; i--)
      GlobalVariableSet(OBJPREFIX+Prefix+newpairs[i]+Suffix+" - Price",(SymbolInfoDouble(Prefix+newpairs[i]+Suffix,SYMBOL_ASK)+SymbolInfoDouble(Prefix+newpairs[i]+Suffix,SYMBOL_BID))/2);

//--- Animation
   if(LastReason==0 && ShowTradePanel)
     {
      //---
      ObjectsCreateAll();
      ObjectSetInteger(0,OBJPREFIX+"PRICEROW_Lª",OBJPROP_COLOR,clrNONE);
      ObjectSetInteger(0,OBJPREFIX+"PRICEROW_Rª",OBJPROP_COLOR,clrNONE);
      //---
      SetStatus("6","Please wait...");
      //---


     }

//---
   FirstRun=false;

//--- Dropped Time
   drop_time=TimeLocal();

//--- Border Color
   if(ShowTradePanel)
     {
      //---
      if(ObjectFind(0,OBJPREFIX+"BORDER[]")==0 || ObjectFind(0,OBJPREFIX+"BCKGRND[]")==0)
        {
         //---
         if(ObjectGetInteger(0,OBJPREFIX+"BORDER[]",OBJPROP_COLOR)!=COLOR_BORDER)
           {
            ObjectSetInteger(0,OBJPREFIX+"BORDER[]",OBJPROP_COLOR,COLOR_BORDER);
            ObjectSetInteger(0,OBJPREFIX+"BORDER[]",OBJPROP_BGCOLOR,COLOR_BORDER);
            ObjectSetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_COLOR,COLOR_BORDER);
           }
        }
     }
//---
   if(!ShowTradePanel)
     {
      //---
      if(ObjectFind(0,OBJPREFIX+"MIN"+"BCKGRND[]")==0)
        {
         //---
         if(ObjectGetInteger(0,OBJPREFIX+"MIN"+"BCKGRND[]",OBJPROP_COLOR)!=COLOR_BORDER)
           {
            ObjectSetInteger(0,OBJPREFIX+"MIN"+"BCKGRND[]",OBJPROP_COLOR,COLOR_BORDER);
            ObjectSetInteger(0,OBJPREFIX+"MIN"+"BCKGRND[]",OBJPROP_BGCOLOR,COLOR_BORDER);
           }
        }
     }
//----
   pagescode();


   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---- DestroyTimer
   EventKillTimer();

//--- Save global variables
   if(reason!=REASON_INITFAILED && !MQLInfoInteger(MQL_TESTER))
     {
      //---
      for(int i=0; i<ArraySize(newpairs); i++)
        {
         //---
         GlobalVariableDel(Prefix+newpairs[i]+Suffix+" - Price");
         //---
         if(ShowTradePanel)
           {
            GlobalVariableSet(OBJPREFIX+Prefix+newpairs[i]+Suffix+" - Stoploss",StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>"+" - "+Prefix+newpairs[i]+Suffix,OBJPROP_TEXT)));
            GlobalVariableSet(OBJPREFIX+Prefix+newpairs[i]+Suffix+" - Takeprofit",StringToDouble(ObjectGetString(0,OBJPREFIX+"_TP<>"+" - "+Prefix+newpairs[i]+Suffix,OBJPROP_TEXT)));
            GlobalVariableSet(OBJPREFIX+Prefix+newpairs[i]+Suffix+" - Lotsize",StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>"+" - "+Prefix+newpairs[i]+Suffix,OBJPROP_TEXT)));
           }
        }
      //---
      if(ShowTradePanel)
        {
         GlobalVariableSet(OBJPREFIX+"Stoploss",StringToDouble(ObjectGetString(0,OBJPREFIX+"SL<>",OBJPROP_TEXT)));
         GlobalVariableSet(OBJPREFIX+"Takeprofit",StringToDouble(ObjectGetString(0,OBJPREFIX+"_TP<>",OBJPROP_TEXT)));
         GlobalVariableSet(OBJPREFIX+"Lotsize",StringToDouble(ObjectGetString(0,OBJPREFIX+"LOTSIZE<>",OBJPROP_TEXT)));
        }
      //---
      GlobalVariableSet(OBJPREFIX+"Theme",SelectedTheme);
      //---
      GlobalVariableSet(OBJPREFIX+"Dashboard",ShowTradePanel);
      //---
      GlobalVariableSet(OBJPREFIX+"Sound",SoundIsEnabled);
      //---
      GlobalVariableSet(OBJPREFIX+"Alarm",AlarmIsEnabled);
      //---
      GlobalVariableSet(OBJPREFIX+"AutoSL",AutoSL);
      GlobalVariableSet(OBJPREFIX+"AutoTP",AutoTP);
      GlobalVariableSet(OBJPREFIX+"AutoLots",AutoLots);
      //---
      GlobalVariableSet(OBJPREFIX+"RR",RR);
      GlobalVariableSet(OBJPREFIX+"Risk",RiskInp);
      //---
      GlobalVariableSet(OBJPREFIX+"PRL",PriceRowLeft);
      GlobalVariableSet(OBJPREFIX+"PRR",PriceRowRight);
      //---
      GlobalVariablesFlush();
     }
//--- DeleteObjects
   if(reason<=REASON_REMOVE || reason==REASON_CLOSE || reason==REASON_RECOMPILE || reason==REASON_INITFAILED || reason==REASON_ACCOUNT)
     {
      ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
      DelteMinWindow();
     }

//---
   if(reason<=REASON_REMOVE || reason==REASON_CLOSE || reason==REASON_RECOMPILE)
     {
      //---
      if(ClearedTemplate)
         ChartSetColor(2);
     }

//--- UnblockScrolling
   ChartMouseScrollSet(true);

//--- UserIsRegistred
   if(!GlobalVariableCheck(OBJPREFIX+"Registred"))
      GlobalVariableSet(OBJPREFIX+"Registred",1);

//---
   LastMode=SelectedMode;

//--- StoreDeinitReason
   LastReason=reason;
//----

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
int pages,starter =Pairs_N_page ;
string aSymbols[];
string finalpairs[];
string currentpage[];

datetime tim;
string sep=",";                // A separator as a character
ushort u_sep;                  // The code of the separator character
int kz ;

//+------------------------------------------------------------------+
//|                                                                  |
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
//----
//Comment(SymbolsTotal(true));




//---
   if(ShowTradePanel)
     {
      //---
      ObjectsCreateAll();
      draw_again();
      //---
      for(int i=0; i<ArraySize(newpairs); i++)
        {
         ObjectsUpdateAll(Prefix+newpairs[i]+Suffix);

        }

      //--- MoveWindow
      if(LastReason==REASON_CHARTCHANGE)
        {
         Chart_XSize=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
         Chart_YSize=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
         //---
         ChartX=Chart_XSize;
         ChartY=Chart_YSize;
         //---
         LastReason=0;
        }
      //---
      if(ChartX!=Chart_XSize || ChartY!=Chart_YSize)
        {
         ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
         //---
         ObjectsCreateAll();
         //---
         ChartX=Chart_XSize;
         ChartY=Chart_YSize;
        }
      //---
      Chart_XSize=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
      Chart_YSize=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);

      //--- Connected
      if(TerminalInfoInteger(TERMINAL_CONNECTED))
        {
         //---
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT)!="ü")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT,"ü");//SetObject
         //---
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP)!="Connected")//GetObject
           {
            double Ping=TerminalInfoInteger(TERMINAL_PING_LAST);//SetPingToMs
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP,"Connected..."+"\nPing: "+DoubleToString(Ping/1000,2)+" ms");//SetObject
           }
        }
      //--- Disconnected
      else
        {
         //---
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT)!="ñ")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TEXT,"ñ");//SetObject
         //---
         if(ObjectGetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP)!="No connection!")//GetObject
            ObjectSetString(0,OBJPREFIX+"CONNECTION",OBJPROP_TOOLTIP,"No connection!");//SetObject
        }
      //--- ResetStatus
      if(stauts_time<TimeLocal()-1)
         ResetStatus();
      //---
      // Comment("");
      ChartRedraw();
     }
   else
      CreateMinWindow();
//----


   return(rates_total);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(ShowTradePanel)
     {
      ObjectDelete(0,OBJPREFIX+"Today");
      ObjectDelete(0,OBJPREFIX+"Clock");
      ObjectDelete(0,OBJPREFIX+"SYDNRY_Clock");
      ObjectDelete(0,OBJPREFIX+"TOKYO_Clock");
      ObjectDelete(0,OBJPREFIX+"FRANKFORT_Clock");
      ObjectDelete(0,OBJPREFIX+"LONDON_Clock");
      ObjectDelete(0,OBJPREFIX+"NEWYORK_Clock");
      LabelCreate(0,OBJPREFIX+"Today",0,_x1+ Dpi(CLIENT_BG_WIDTH)-950,_y1+30,CORNER_LEFT_UPPER,StringConcatenate(f0_41(TimeLocal())),"Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
      LabelCreate(0,OBJPREFIX+"Clock",0,_x1+ Dpi(CLIENT_BG_WIDTH)-700,_y1+30,CORNER_LEFT_UPPER,TimeToString(TimeLocal(),TIME_SECONDS),"Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
      LabelCreate(0,OBJPREFIX+"SYDNRY_Clock",0,_x1+ Dpi(CLIENT_BG_WIDTH-390),_y1+40,CORNER_LEFT_UPPER,TimeToString(TimeGMT()+60*11*60,TIME_MINUTES),"Arial Black",9,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
      LabelCreate(0,OBJPREFIX+"TOKYO_Clock",0,_x1+ Dpi(CLIENT_BG_WIDTH-290),_y1+40,CORNER_LEFT_UPPER,TimeToString(TimeGMT()+60*9*60,TIME_MINUTES),"Arial Black",9,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
      LabelCreate(0,OBJPREFIX+"FRANKFORT_Clock",0,_x1+ Dpi(CLIENT_BG_WIDTH-190),_y1+40,CORNER_LEFT_UPPER,TimeToString(TimeGMT()-60*60,TIME_MINUTES),"Arial Black",9,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
      LabelCreate(0,OBJPREFIX+"LONDON_Clock",0,_x1+ Dpi(CLIENT_BG_WIDTH-90),_y1+40,CORNER_LEFT_UPPER,TimeToString(TimeGMT(),TIME_MINUTES),"Arial Black",9,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
      LabelCreate(0,OBJPREFIX+"NEWYORK_Clock",0,_x1+ Dpi(CLIENT_BG_WIDTH+10),_y1+40,CORNER_LEFT_UPPER,TimeToString(TimeGMT()-60*5*60,TIME_MINUTES),"Arial Black",9,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
     }
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//----
   if(id==CHARTEVENT_KEYDOWN)
     {

      //---
      if(true)
        {
         //---

         //---

         //--- Switch Symbol (UP)
         if(lparam==KEY_UP)
           {
            //---
            int index=0;
            //---
            for(int i=0; i<ArraySize(newpairs); i++)
              {
               if(_Symbol==Prefix+newpairs[i]+Suffix)
                 {
                  //---
                  index=i-1;
                  //---
                  if(index<0)
                     index=ArraySize(newpairs)-1;
                  //---
                  if(SymbolFind(Prefix+newpairs[index]+Suffix,false))
                    {
                     ChartSetSymbolPeriod(0,Prefix+newpairs[index]+Suffix,PERIOD_CURRENT);
                     SetStatus("ÿ","Switched to "+newpairs[index]);
                     break;
                    }
                 }
              }
           }

         //--- Switch Symbol (DOWN)
         if(lparam==KEY_DOWN)
           {
            //---
            int index=0;
            //---
            for(int i=0; i<ArraySize(newpairs); i++)
              {
               //---
               if(_Symbol==Prefix+newpairs[i]+Suffix)
                 {
                  //---
                  index=i+1;
                  //---
                  if(index>=ArraySize(newpairs))
                     index=0;
                  //---
                  if(SymbolFind(Prefix+newpairs[index]+Suffix,false))
                    {
                     ChartSetSymbolPeriod(0,Prefix+newpairs[index]+Suffix,PERIOD_CURRENT);
                     SetStatus("ÿ","Switched to "+newpairs[index]);
                     break;
                    }
                 }
              }
           }
        }
     }

//--- OBJ_CLICKS
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam==OBJPREFIX+"exportcsv")
        {

         Export();
         ObjectSetInteger(0,OBJPREFIX+"exportcsv",OBJPROP_STATE,false);//SetObject
        }

      if(sparam==OBJPREFIX+"pagbtn")
        {
         deletepanel();
         for(int i=0; i<ArraySize(singalTime); i++)
           {
            singalTime[i]=0;
           }
         ObjectDelete(0,OBJPREFIX+"Pages");
         pages =(ArraySize(finalpairs)/Pairs_N_page)+1;
         if(starter+Pairs_N_page>ArraySize(finalpairs))
           {starter=0;}
         if(starter<=ArraySize(finalpairs))
           {
            starter =starter+Pairs_N_page;
           }
         int x=150;//ChartMiddleX()-(Dpi(CLIENT_BG_WIDTH)/2);
         int y=50;//ChartMiddleY()-(fr_y2/2);


         LabelCreate(0,OBJPREFIX+"Pages",0,x+50,y-10,CORNER_LEFT_UPPER,"Page "+IntegerToString(starter/Pairs_N_page,0,0)+"/"+IntegerToString(pages-1,0,0),"Arial Black",10,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");

         int HowManySymbols=SymbolsTotal(true);
         string ListSymbols=" ";
         for(int i=0; i<HowManySymbols; i++)
           {
            ListSymbols=StringConcatenate(ListSymbols,SymbolName(i,true),",");
           }

         u_sep=StringGetCharacter(sep,0);
         kz=StringSplit(ListSymbols,u_sep,newpairs);
         int index =0;
         int index2 =0;


         ArrayResize(finalpairs,ArraySize(newpairs));
         for(int i=0; i<ArraySize(newpairs); i++)
           {

            finalpairs[index2]=newpairs[i];
            index2++;

           }
         ArrayResize(currentpage,Pairs_N_page+1);
         for(int i=0; i<Pairs_N_page; i++)
           {
            currentpage[i]=finalpairs[starter-i];

           }
         pages =(ArraySize(finalpairs)/Pairs_N_page)+1;

         draw_again();

         ObjectSetInteger(0,OBJPREFIX+"pagbtn",OBJPROP_STATE,false);//SetObject
        }


      //---


      if(sparam==OBJPREFIX+"pagbtn2")
        {
         for(int i=0; i<ArraySize(singalTime); i++)
           {
            singalTime[i]=0;
           }
         if(starter/Pairs_N_page>1)
           {
            deletepanel();
            ObjectDelete(0,OBJPREFIX+"Pages");
            pages =(ArraySize(finalpairs)/Pairs_N_page)+1;
            if(starter-Pairs_N_page<=0)
              {starter=0;}
            if(starter<=ArraySize(finalpairs)&& starter>Pairs_N_page)
              {
               starter =starter-Pairs_N_page;
              }

            int x=150;//ChartMiddleX()-(Dpi(CLIENT_BG_WIDTH)/2);
            int y=50;//ChartMiddleY()-(fr_y2/2);


            LabelCreate(0,OBJPREFIX+"Pages",0,x+50,y-10,CORNER_LEFT_UPPER,"Page "+IntegerToString(starter/Pairs_N_page,0,0)+"/"+IntegerToString(pages-1,0,0),"Arial Black",10,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");

            int HowManySymbols=SymbolsTotal(true);
            string ListSymbols=" ";
            for(int i=0; i<HowManySymbols; i++)
              {
               ListSymbols=StringConcatenate(ListSymbols,SymbolName(i,true),",");
              }

            u_sep=StringGetCharacter(sep,0);
            kz=StringSplit(ListSymbols,u_sep,newpairs);
            int index =0;
            int index2 =0;


            ArrayResize(finalpairs,ArraySize(newpairs));
            for(int i=0; i<ArraySize(newpairs); i++)
              {

               finalpairs[index2]=newpairs[i];
               index2++;


              }
            ArrayResize(currentpage,Pairs_N_page+1);
            for(int i=0; i<=Pairs_N_page; i++)
              {
               currentpage[i]=finalpairs[starter-i];

              }
            pages =(ArraySize(finalpairs)/Pairs_N_page)+1;

            draw_again();

           }
         ObjectSetInteger(0,OBJPREFIX+"pagbtn2",OBJPROP_STATE,false);//SetObject
        }






      //---
      for(int i=0; i<ArraySize(newpairs); i++)
        {

         //--- SymoblSwitcher
         if(sparam==OBJPREFIX+Prefix+newpairs[i]+Suffix)
           {
            ChartSetSymbolPeriod(0,Prefix+newpairs[i]+Suffix,PERIOD_CURRENT);
            SetStatus("ÿ","Switched to "+newpairs[i]);
            break;
           }
        }

      //--- RemoveExpert
      if(sparam==OBJPREFIX+"EXIT")
        {
         //---
         if(MessageBox("Are you sure you want to exit?",MB_CAPTION,MB_ICONQUESTION|MB_YESNO)==IDYES)
            ChartIndicatorDelete(0, 0, ExpertName);
        }

      //--- Minimize
      if(sparam==OBJPREFIX+"MINIMIZE")
        {
         ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
         CreateMinWindow();
         ShowTradePanel=false;
         ChartMouseScrollSet(true);
         ChartSetColor(2);
         ClearedTemplate=false;
        }

      //--- Maximize
      if(sparam==OBJPREFIX+"MIN"+"MAXIMIZE")
        {
         DelteMinWindow();
         ObjectsCreateAll();
         ShowTradePanel=true;
         ChartMouseScrollSet(false);
        }

      //--- Ping
      if(sparam==OBJPREFIX+"CONNECTION")
        {
         //---
         double Ping=TerminalInfoInteger(TERMINAL_PING_LAST);//SetPingToMs
         //---
         if(TerminalInfoInteger(TERMINAL_CONNECTED))
            SetStatus("\n","Ping: "+DoubleToString(Ping/1000,2)+" ms");
         else
            SetStatus("ý","No Internet connection...");
        }


      //--- SwitchTheme
      if(sparam==OBJPREFIX+"THEME")
        {
         //---
         if(SelectedTheme==0)
           {
            ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
            COLOR_BG=C'28,28,28';
            COLOR_FONT=clrSilver;
            COLOR_GREEN=clrLimeGreen;
            COLOR_RED=clrRed;
            COLOR_LOW=clrYellow;
            COLOR_MARKER=clrGold;
            ObjectsCreateAll();
            SelectedTheme=1;
            //---
            SetStatus("ÿ","Dark theme selected...");
            Sleep(250);
            ResetStatus();
           }
         else
           {
            ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
            COLOR_BG=C'240,240,240';
            COLOR_FONT=C'40,41,59';
            COLOR_GREEN=clrForestGreen;
            COLOR_RED=clrIndianRed;
            COLOR_LOW=clrGoldenrod;
            COLOR_MARKER=clrDarkOrange;
            ObjectsCreateAll();
            SelectedTheme=0;
            //---
            SetStatus("ÿ","Light theme selected...");
            Sleep(250);
            ResetStatus();
           }
        }

      //--- SwitchTheme
      if(sparam==OBJPREFIX+"TEMPLATE")
        {
         //---
         if(!ClearedTemplate)
           {
            //---
            if(SelectedTheme==0)
              {
               ChartSetColor(0);
               ClearedTemplate=true;
               SetStatus("ÿ","Chart color cleared...");
              }
            else
              {
               ChartSetColor(1);
               ClearedTemplate=true;
               SetStatus("ÿ","Chart color cleared...");
              }
           }
         else
           {
            ChartSetColor(2);
            ClearedTemplate=false;
            SetStatus("ÿ","Original chart color applied...");
           }
        }

      //--- GetParameters
      GetParam(sparam);

      //--- SoundManagement
      if(sparam==OBJPREFIX+"SOUND" || sparam==OBJPREFIX+"SOUNDIO")
        {
         //--- EnableSound
         if(!SoundIsEnabled)
           {
            SoundIsEnabled=true;
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,C'59,41,40');//SetObject
            SetStatus("þ","Sounds enabled...");
            PlaySound("sound.wav");
           }
         //--- DisableSound
         else
           {
            SoundIsEnabled=false;
            ObjectSetInteger(0,OBJPREFIX+"SOUNDIO",OBJPROP_COLOR,clrNONE);//SetObject
            SetStatus("ý","Sounds disabled...");
           }
        }
      //--- AlarmManagement
      if(sparam==OBJPREFIX+"ALARM" || sparam==OBJPREFIX+"ALARMIO")
        {
         //--- EnableSound
         if(!AlarmIsEnabled)
           {
            //---
            AlarmIsEnabled=true;
            //---
            ObjectSetInteger(0,OBJPREFIX+"ALARMIO",OBJPROP_COLOR,clrNONE);
            //---
            string message="\n";
            //---
            if(_Alert)
               message="[Pop-up]";
            //---
            if(Push)
               StringAdd(message,"[Push]");
            //---
            if(Mail)
               StringAdd(message,"[Email]");
            //---
            if(!_Alert && !Push && !Mail)
              {
               Alert(OBJPREFIX+"No alert method selected!");
               return;
              }
            //---
            Alert("Alerts enabled "+message);
            SetStatus("þ","Alerts enabled...");
           }
         //--- DisableSound
         else
           {
            //---
            AlarmIsEnabled=false;
            ObjectSetInteger(0,OBJPREFIX+"ALARMIO",OBJPROP_COLOR,C'59,41,40');
            //---
            SetStatus("ý","Alerts disabled...");
           }
        }

      //--- Balance
      if(sparam==OBJPREFIX+"BALANCE«")
        {
         //---
         string text="";
         //---
         if(_AccountCurrency()=="$" || _AccountCurrency()=="£")
            text=_AccountCurrency()+DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2);
         else
            text=DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2)+_AccountCurrency();
         //---
         SetStatus("","Equity: "+text);
        }




      //--- Switch PriceRow Left
      if(sparam==OBJPREFIX+"PRICEROW_Lª")
        {
         //---
         PriceRowLeft++;
         //---
         if(PriceRowLeft>=ArraySize(PriceRowLeftArr))//Reset
            PriceRowLeft=0;
         //---
         ObjectSetString(0,OBJPREFIX+"PRICEROW_Lª",OBJPROP_TEXT,0,PriceRowLeftArr[PriceRowLeft]);/*SetObject*/
         //---
         SetStatus("É","Switched to "+PriceRowLeftArr[PriceRowLeft]+" mode...");
         //---
         for(int i=0; i<ArraySize(newpairs); i++)
            ObjectSetString(0,OBJPREFIX+"PRICEROW_L"+" - "+newpairs[i],OBJPROP_TOOLTIP,PriceRowLeftArr[PriceRowLeft]+" "+newpairs[i]);
        }

      //--- Switch PriceRow Right
      if(sparam==OBJPREFIX+"PRICEROW_Rª")
        {
         //---
         PriceRowRight++;
         //---
         if(PriceRowRight>=ArraySize(PriceRowRightArr))//Reset
            PriceRowRight=0;
         //---
         ObjectSetString(0,OBJPREFIX+"PRICEROW_Rª",OBJPROP_TEXT,0,PriceRowRightArr[PriceRowRight]);/*SetObject*/
         //---
         SetStatus("Ê","Switched to "+PriceRowRightArr[PriceRowRight]+" mode...");
         //---
         for(int i=0; i<ArraySize(newpairs); i++)
            ObjectSetString(0,OBJPREFIX+"PRICEROW_R"+" - "+newpairs[i],OBJPROP_TOOLTIP,PriceRowRightArr[PriceRowRight]+" "+newpairs[i]);
        }




     }

//--- OnEdit
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {

      //--- RRInpA
      double RRInpA=StringToDouble(ObjectGetString(0,OBJPREFIX+"RR<>",OBJPROP_TEXT));
      //---
      if(RRInpA<0.1)
        {
         ObjectSetString(0,OBJPREFIX+"RR<>",OBJPROP_TEXT,0,DoubleToString(0.1,2));/*SetObject*/
         RRInpA=0.1;
        }
      //---
      ObjectSetString(0,OBJPREFIX+"RR<>",OBJPROP_TEXT,0,DoubleToString(RRInpA,2));/*SetObject*/

      //---

      //---
      UserIsEditing=false;
     }
//----
  }
//+------------------------------------------------------------------+
//| _OnTester                                                        |
//+------------------------------------------------------------------+
void _OnTester()
  {
//---
   if(AccountFreeMarginCheck(_Symbol,OP_BUY,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN))>=0)
     {
      double lots=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
      //---
      int tkt=OrderSend(_Symbol,OP_BUY,lots,SymbolInfoDouble(_Symbol,SYMBOL_ASK),0,0,0,NULL,0,0,clrNONE);
      //---
      if(tkt>0)
         int c_tkt=OrderClose(tkt,lots,SymbolInfoDouble(_Symbol,SYMBOL_BID),0,clrNONE);
     }
//---
  }

//+------------------------------------------------------------------+
//| ObjectsCreateAll                                                 |
//+------------------------------------------------------------------+
void ObjectsCreateAll()
  {
//---
   int fr_y2=Dpi(140);
//---
   for(int i=0; i<ArraySize(newpairs); i++)
     {
      //---
      if(SelectedMode==FULL)
         fr_y2+=Dpi(25);
      //---
      if(SelectedMode==COMPACT)
         fr_y2+=Dpi(21);
      //---
      if(SelectedMode==MINI)
         fr_y2+=Dpi(17);
     }
//---
   int x=150;//ChartMiddleX()-(Dpi(CLIENT_BG_WIDTH)/2);
   int y=50;//ChartMiddleY()-(fr_y2/2);
//---
   int height=140+160;
//---

   RectLabelCreate(0,OBJPREFIX+"BCKGRND[]",0,x-140,y,Dpi(CLIENT_BG_WIDTH+110),height+(Pairs_N_page*20),COLOR_BG,BORDER_FLAT,CORNER_LEFT_UPPER,COLOR_BORDER,STYLE_SOLID,1,false,false,true,0,"\n");
   RectLabelCreate(0,OBJPREFIX+"BORDER[]",0,x-140,y,Dpi(CLIENT_BG_WIDTH+110),Dpi(INDENT_TOP),COLOR_BORDER,BORDER_FLAT,CORNER_LEFT_UPPER,COLOR_BORDER,STYLE_SOLID,1,false,false,true,0,"\n");
   LabelCreate(0,OBJPREFIX+"Pages",0,x+50,y-10,CORNER_LEFT_UPPER,"Page "+IntegerToString(starter/Pairs_N_page,0,0)+"/"+IntegerToString(pages-1,0,0),"Arial Black",10,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
   ButtonCreate(0,OBJPREFIX+"pagbtn",0,x+130,y-22,70,20,CORNER_LEFT_UPPER,"Next page >","Trebuchet MS",8,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"pagbtn2",0,x-30,y-22,70,20,CORNER_LEFT_UPPER,"< Prev. page","Trebuchet MS",8,C'59,41,40',C'160,192,255',C'144,176,239',false,false,false,true,1,"\n");
   ButtonCreate(0,OBJPREFIX+"exportcsv",0,x-120,y-22,70,20,CORNER_LEFT_UPPER,"Export CSV","Trebuchet MS",10,clrBlack,clrRed,C'144,176,239',false,false,false,true,1,"\n");

   pages =(ArraySize(finalpairs)/Pairs_N_page)+1;


   _x1=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_XDISTANCE);
   _y1=(int)ObjectGetInteger(0,OBJPREFIX+"BCKGRND[]",OBJPROP_YDISTANCE);
//---
//---
   LabelCreate(0,OBJPREFIX+"CAPTION",0,_x1+(Dpi(CLIENT_BG_WIDTH+110)/2)-Dpi(16),_y1,CORNER_LEFT_UPPER,ExpertName,"Arial Black",9,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"EXIT",0,(_x1+Dpi(CLIENT_BG_WIDTH+110))-Dpi(10),_y1-Dpi(2),CORNER_LEFT_UPPER,"r","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"MINIMIZE",0,(_x1+Dpi(CLIENT_BG_WIDTH+110))-Dpi(30),_y1-Dpi(2),CORNER_LEFT_UPPER,"2","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+" ",0,(_x1+Dpi(CLIENT_BG_WIDTH+110))-Dpi(50),_y1-Dpi(2),CORNER_LEFT_UPPER,"s","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"TIME",0,(_x1+Dpi(CLIENT_BG_WIDTH+110))-Dpi(85),_y1+Dpi(1),CORNER_LEFT_UPPER,TimeToString(0,TIME_SECONDS),"Tahoma",8,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Local Time",false);
   LabelCreate(0,OBJPREFIX+"TIME§",0,(_x1+Dpi(CLIENT_BG_WIDTH+110))-Dpi(120),_y1,CORNER_LEFT_UPPER,"Â","Wingdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Local Time",false);
//---
   LabelCreate(0,OBJPREFIX+"CONNECTION",0,_x1+Dpi(15),_y1-Dpi(2),CORNER_LEFT_UPPER,"ü","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"Connection",false);
//---
   LabelCreate(0,OBJPREFIX+"THEME",0,_x1+Dpi(40),_y1-Dpi(4),CORNER_LEFT_UPPER,"N","Webdings",15,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Theme",false);
//---
   LabelCreate(0,OBJPREFIX+"TEMPLATE",0,_x1+Dpi(65),_y1-Dpi(2),CORNER_LEFT_UPPER,"+","Webdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Background",false);
//---
   int middle=Dpi(CLIENT_BG_WIDTH/2);
//---
   LabelCreate(0,OBJPREFIX+"STATUS",0,_x1+middle+(middle/2),_y1+Dpi(8),CORNER_LEFT_UPPER,"\n","Wingdings",10,C'59,41,40',0,ANCHOR_LEFT,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"STATUS«",0,_x1+middle+(middle/2)+Dpi(15),_y1+Dpi(8),CORNER_LEFT_UPPER,"\n",sFontType,8,C'59,41,40',0,ANCHOR_LEFT,false,false,true,1,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"SOUND",0,_x1+Dpi(90),_y1-Dpi(2),CORNER_LEFT_UPPER,"X","Webdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Sounds",false);
//---
   color soundclr=SoundIsEnabled?C'59,41,40':clrNONE;
//---
   LabelCreate(0,OBJPREFIX+"SOUNDIO",0,_x1+Dpi(100),_y1-Dpi(1),CORNER_LEFT_UPPER,"ð","Webdings",10,soundclr,0,ANCHOR_UPPER,false,false,true,1,"Sounds",false);
//---
   LabelCreate(0,OBJPREFIX+"ALARM",0,_x1+Dpi(115),_y1-Dpi(1),CORNER_LEFT_UPPER,"%","Wingdings",12,C'59,41,40',0,ANCHOR_UPPER,false,false,true,1,"Alerts",false);
//---
   color alarmclr=AlarmIsEnabled?clrNONE:C'59,41,40';
//---
   if(!_Alert && !Push && !Mail)
      alarmclr=C'59,41,40';
//---
   LabelCreate(0,OBJPREFIX+"ALARMIO",0,_x1+Dpi(115),_y1-Dpi(6),CORNER_LEFT_UPPER,"x",sFontType,16,alarmclr,0,ANCHOR_UPPER,false,false,true,1,"Alerts",false);
//---
   int csm_fr_x1=_x1+Dpi(50);
   int csm_fr_x2=_x1+Dpi(95);
   int csm_fr_x3=_x1+Dpi(137);
   int csm_dist_b=Dpi(150);

   LabelCreate(0,OBJPREFIX+"BALANCE«",0,_x1+Dpi(300),_y1+Dpi(8),CORNER_LEFT_UPPER,DoubleToStr(AccountBalance(),2),sFontType,8,C'59,41,40',0,ANCHOR_CENTER,false,false,true,0,"\n");
//---

   color autosl=AutoSL?COLOR_AUTO:COLOR_FONT;
   color autotp=AutoTP?COLOR_AUTO:COLOR_FONT;
   color autolots=AutoLots?COLOR_AUTO:COLOR_FONT;
//---

   int fr_y=_y1+Dpi(95);
   LabelCreate(0,OBJPREFIX+"x12--1",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1180,_y1+50,CORNER_LEFT_UPPER,"----------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--12",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1100,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--13",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1000,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--14",0,_x1+ Dpi(CLIENT_BG_WIDTH)-900,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--15",0,_x1+ Dpi(CLIENT_BG_WIDTH)-800,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--16",0,_x1+ Dpi(CLIENT_BG_WIDTH)-700,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--17",0,_x1+ Dpi(CLIENT_BG_WIDTH)-600,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--18",0,_x1+ Dpi(CLIENT_BG_WIDTH)-500,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--19",0,_x1+ Dpi(CLIENT_BG_WIDTH)-400,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--110",0,_x1+ Dpi(CLIENT_BG_WIDTH)-300,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--111",0,_x1+ Dpi(CLIENT_BG_WIDTH)-200,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--112",0,_x1+ Dpi(CLIENT_BG_WIDTH)-100,_y1+50,CORNER_LEFT_UPPER,"---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--113",0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+50,CORNER_LEFT_UPPER,    "---------------------------------------------------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x12--114",0,_x1+ Dpi(CLIENT_BG_WIDTH)+100,_y1+50,CORNER_LEFT_UPPER,"-------","Arial Black",5,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   BitmapCreate(0,OBJPREFIX+"logo",0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+80,CORNER_LEFT_UPPER,"logo.bmp",clrRed,50,50,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--1",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1180,_y1+80,CORNER_LEFT_UPPER,"--------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--12",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1100,_y1+80,CORNER_LEFT_UPPER,"-------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--13",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1000,_y1+80,CORNER_LEFT_UPPER,"-------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--14",0,_x1+ Dpi(CLIENT_BG_WIDTH)-900,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--15",0,_x1+ Dpi(CLIENT_BG_WIDTH)-800,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--16",0,_x1+ Dpi(CLIENT_BG_WIDTH)-700,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--17",0,_x1+ Dpi(CLIENT_BG_WIDTH)-600,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--18",0,_x1+ Dpi(CLIENT_BG_WIDTH)-500,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--19",0,_x1+ Dpi(CLIENT_BG_WIDTH)-400,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--110",0,_x1+ Dpi(CLIENT_BG_WIDTH)-300,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--111",0,_x1+ Dpi(CLIENT_BG_WIDTH)-200,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--112",0,_x1+ Dpi(CLIENT_BG_WIDTH)-100,_y1+80,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--113",0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+80,CORNER_LEFT_UPPER,    "--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x1--114",0,_x1+ Dpi(CLIENT_BG_WIDTH)+100,_y1+80,CORNER_LEFT_UPPER,"-------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");


   LabelCreate(0,OBJPREFIX+"x--1",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1180,_y1+110,CORNER_LEFT_UPPER,"--------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--2",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1100,_y1+110,CORNER_LEFT_UPPER,"-------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--3",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1000,_y1+110,CORNER_LEFT_UPPER,"-------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--4",0,_x1+ Dpi(CLIENT_BG_WIDTH)-900,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--5",0,_x1+ Dpi(CLIENT_BG_WIDTH)-800,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--6",0,_x1+ Dpi(CLIENT_BG_WIDTH)-700,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--7",0,_x1+ Dpi(CLIENT_BG_WIDTH)-600,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--8",0,_x1+ Dpi(CLIENT_BG_WIDTH)-500,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--9",0,_x1+ Dpi(CLIENT_BG_WIDTH)-400,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--10",0,_x1+ Dpi(CLIENT_BG_WIDTH)-300,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--11",0,_x1+ Dpi(CLIENT_BG_WIDTH)-200,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--12",0,_x1+ Dpi(CLIENT_BG_WIDTH)-100,_y1+110,CORNER_LEFT_UPPER,"--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--13",0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+110,CORNER_LEFT_UPPER,    "--------------------------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"x--14",0,_x1+ Dpi(CLIENT_BG_WIDTH)+100,_y1+110,CORNER_LEFT_UPPER,"-------","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");

   for(int i=0; i<ArraySize(currentpage); i++)
     {

      string pairs;
      CreateSymbGUI(Prefix+currentpage[i]+Suffix,_y1+150+(i*20));

      pairs =Prefix+currentpage[i]+Suffix;
      LabelCreate(0,OBJPREFIX+"bid"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-1110,_y1+125+(i*20),CORNER_LEFT_UPPER, DoubleToString(MarketInfo(pairs,MODE_BID),(int)MarketInfo(pairs,MODE_DIGITS)),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");

      //---
      if(SelectedMode==FULL)
         fr_y+=Dpi(25);
      //---
      if(SelectedMode==COMPACT)
         fr_y+=Dpi(21);
      //---
      if(SelectedMode==MINI)
         fr_y+=Dpi(17);


     }

   LabelCreate(0,OBJPREFIX+"SCRIP",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1180,_y1+67,CORNER_LEFT_UPPER,"Pairs :","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"Bid",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1100,_y1+67,CORNER_LEFT_UPPER,"Bid  ","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"TimeFrames",0,_x1+ Dpi(CLIENT_BG_WIDTH)-950,_y1+67,CORNER_LEFT_UPPER,"TimeFrames","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"Trend",0,_x1+ Dpi(CLIENT_BG_WIDTH)-730,_y1+67,CORNER_LEFT_UPPER,"Trend","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"Signal Status",0,_x1+ Dpi(CLIENT_BG_WIDTH-300),_y1+67,CORNER_LEFT_UPPER,"Signal Status","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"signal",0,_x1+ Dpi(CLIENT_BG_WIDTH-150),_y1+67,CORNER_LEFT_UPPER,"signal","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"time",0,_x1+ Dpi(CLIENT_BG_WIDTH-150),_y1+97,CORNER_LEFT_UPPER,"time","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");

   LabelCreate(0,OBJPREFIX+"CandelStick",0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+67,CORNER_LEFT_UPPER,"Candle Pattern","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"Snr Status",0,_x1+ Dpi(CLIENT_BG_WIDTH-450),_y1+67,CORNER_LEFT_UPPER,"Snr Status","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"Expiry",0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+67,CORNER_LEFT_UPPER,"Expiry","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"m1",0,_x1+ Dpi(CLIENT_BG_WIDTH)-1040,_y1+97,CORNER_LEFT_UPPER,"M1","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"m5",0,_x1+ Dpi(CLIENT_BG_WIDTH)-990,_y1+97,CORNER_LEFT_UPPER,"M5","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"m115",0,_x1+ Dpi(CLIENT_BG_WIDTH)-940,_y1+97,CORNER_LEFT_UPPER,"M15","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"m30",0,_x1+ Dpi(CLIENT_BG_WIDTH)-890,_y1+97,CORNER_LEFT_UPPER,"M30","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"H1",0,_x1+ Dpi(CLIENT_BG_WIDTH)-840,_y1+97,CORNER_LEFT_UPPER,"H1","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"H4",0,_x1+ Dpi(CLIENT_BG_WIDTH)-790,_y1+97,CORNER_LEFT_UPPER,"H4","Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");

   LabelCreate(0,OBJPREFIX+"Date",0,_x1+ Dpi(CLIENT_BG_WIDTH-1180),_y1+30,CORNER_LEFT_UPPER,"Date","Arial Black",13,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
//LabelCreate(0,OBJPREFIX+"Today",0,_x1+ Dpi(CLIENT_BG_WIDTH)-950,_y1+30,CORNER_LEFT_UPPER,StringConcatenate(f0_41(TimeLocal())),"Arial Black",12,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
//LabelCreate(0,OBJPREFIX+"Clock",0,_x1+ Dpi(CLIENT_BG_WIDTH)-800,_y1+30,CORNER_LEFT_UPPER,TimeToString(TimeLocal(),TIME_SECONDS),"Arial Black",12,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"SYDNRY",0,_x1+ Dpi(CLIENT_BG_WIDTH-400),_y1+25,CORNER_LEFT_UPPER,"SYDNEY","Arial Black",9,clrYellow,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"TOKYO",0,_x1+ Dpi(CLIENT_BG_WIDTH-300),_y1+25,CORNER_LEFT_UPPER,"TOKYO","Arial Black",9,clrYellow,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"FRANKFORT",0,_x1+ Dpi(CLIENT_BG_WIDTH-200),_y1+25,CORNER_LEFT_UPPER,"FRANKFORT","Arial Black",9,clrYellow,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"LONDON",0,_x1+ Dpi(CLIENT_BG_WIDTH-100),_y1+25,CORNER_LEFT_UPPER,"LONDON","Arial Black",9,clrYellow,0,ANCHOR_LEFT,false,false,false,0,"\n");
   LabelCreate(0,OBJPREFIX+"NEWYORK",0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+25,CORNER_LEFT_UPPER,"NEWYORK","Arial Black",9,clrYellow,0,ANCHOR_LEFT,false,false,false,0,"\n");


  }
//+------------------------------------------------------------------+
//| CreateSymbGUI                                                    |
//+------------------------------------------------------------------+
void CreateSymbGUI(string _Symb,int Y)
  {
//---

   color startcolor=FirstRun?clrNONE:COLOR_FONT;
//---
   LabelCreate(0,OBJPREFIX+_Symb,0,_x1+Dpi(10),Y,CORNER_LEFT_UPPER,StringSubstr(_Symb,StringLen(Prefix),6)+":",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");



   int fr_x=Dpi(330);
//---
   for(int i=0; i<10; i++)
     {
      //LabelCreate(0,OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i),0,_x1+fr_x,Y,CORNER_LEFT_UPPER,"l","Arial Black",12,clrNONE,0.0,ANCHOR_RIGHT,false,false,true,0);
      fr_x-=Dpi(5);
     }
//---
   double bid=MarketInfo(_Symb,MODE_BID);
//---
   int digits=(int)MarketInfo(_Symb,MODE_DIGITS);

//--- KeyboardTrading
   if(ShowTradePanel)
     {
      //---
      if(true)
        {
         //---
         if(_Symb==_Symbol)
           {
            //---
            if(ObjectFind(0,OBJPREFIX+"MARKER")!=0)
               LabelCreate(0,OBJPREFIX+"MARKER",0,_x1+Dpi(10),Y+Dpi(5),CORNER_LEFT_UPPER,"_______",sFontType,FONTSIZE,COLOR_MARKER,0,ANCHOR_LEFT,false,false,true,0,"\n");
            else
              {
               //---
               if(ObjectGetInteger(0,OBJPREFIX+"MARKER",OBJPROP_YDISTANCE,0)!=Y+Dpi(5))
                  ObjectDelete(0,OBJPREFIX+"MARKER");
              }
           }
        }
      else
        {
         //---
         if(ObjectFind(0,OBJPREFIX+"MARKER")==0)
            ObjectDelete(0,OBJPREFIX+"MARKER");
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| CreateProBar                                                     |
//+------------------------------------------------------------------+
void CreateProBar(string _Symb,int x,int y)
  {
//---
   int fr_y_pb=y;
//---
   for(int i=1; i<11; i++)
     {
      LabelCreate(0,OBJPREFIX+"PB#"+IntegerToString(i)+" - "+_Symb,0,x,fr_y_pb,CORNER_LEFT_UPPER,"0","Webdings",25,clrNONE,0,ANCHOR_RIGHT,false,false,true,0,"\n");
      fr_y_pb-=Dpi(5);
     }
//---
  }

//+------------------------------------------------------------------+
//| CreateMinWindow                                                  |
//+------------------------------------------------------------------+
void CreateMinWindow()
  {
//---
   RectLabelCreate(0,OBJPREFIX+"MIN"+"BCKGRND[]",0,Dpi(1),Dpi(20),Dpi(163),Dpi(25),COLOR_BORDER,BORDER_FLAT,CORNER_LEFT_LOWER,COLOR_BORDER,STYLE_SOLID,1,false,false,true,0,"\n");
//---
   LabelCreate(0,OBJPREFIX+"MIN"+"CAPTION",0,Dpi(140)-Dpi(64),Dpi(18),CORNER_LEFT_LOWER,"Scanner","Arial Black",8,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//---
   LabelCreate(0,OBJPREFIX+"MIN"+"MAXIMIZE",0,Dpi(156),Dpi(23),CORNER_LEFT_LOWER,"1","Webdings",10,C'59,41,40',0,ANCHOR_UPPER,false,false,true,0,"\n",false);
//---
  }
//+------------------------------------------------------------------+
//| DelteMinWindow                                                   |
//+------------------------------------------------------------------+
void DelteMinWindow()
  {
//---
   ObjectDelete(0,OBJPREFIX+"MIN"+"BCKGRND[]");
   ObjectDelete(0,OBJPREFIX+"MIN"+"CAPTION");
   ObjectDelete(0,OBJPREFIX+"MIN"+"MAXIMIZE");
//---
  }

//+------------------------------------------------------------------+
//| UpdateSymbolGUI                                                  |
//+------------------------------------------------------------------+
void ObjectsUpdateAll(string _Symb)
  {
//--- Market info
   double bid=MarketInfo(_Symb,MODE_BID),ask=MarketInfo(_Symb,MODE_ASK),avg=(ask+bid)/2;
//---
   double TFHigh=iHigh(_Symb,CalcTF,0),TFLow=iLow(_Symb,CalcTF,0),TFOpen=iOpen(_Symb,CalcTF,0);
//---
   double TFLastHigh=iHigh(_Symb,CalcTF,1),TFLastLow=iLow(_Symb,CalcTF,1),TFLastClose=iClose(_Symb,CalcTF,1);
//---
   long Spread=SymbolInfoInteger(_Symb,SYMBOL_SPREAD);
   int digits = (int)MarketInfo(_Symb,MODE_DIGITS);


//--- Range
   double pts=MarketInfo(_Symb,MODE_POINT);
//---
   double range=0;
//---
   if(pts!=0)
      range=(TFHigh-TFLow)/pts;

//--- SetRange

//---

//--- Spread
   ObjectSetString(0,OBJPREFIX+"SPREAD"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(MarketInfo(_Symb,MODE_SPREAD),0)+"p");

//---
   if(Spread>=100)
      ObjectSetInteger(0,OBJPREFIX+"SPREAD"+" - "+_Symb,OBJPROP_COLOR,clrOrangeRed);
   else
      ObjectSetInteger(0,OBJPREFIX+"SPREAD"+" - "+_Symb,OBJPROP_COLOR,COLOR_FONT);


//---
   color COLOR_HEDGE=(SelectedTheme==0)?clrDarkOrange:clrGold;

//--- Get Currencies

//---
   double symbol_r=SymbPerc(_Symb);

//--- Percent
   ObjectSetString(0,OBJPREFIX+"RANGE%"+" - "+_Symb,OBJPROP_TEXT,DoubleToString(SymbPerc(_Symb),0)+"%");
   ObjectSetInteger(0,OBJPREFIX+_Symb,OBJPROP_COLOR,COLOR_FONT);
   ObjectSetInteger(0,OBJPREFIX+"RANGE%"+" - "+_Symb,OBJPROP_COLOR,COLOR_FONT);

//-
//---




//---
  }



//+------------------------------------------------------------------+
//| GetParam                                                         |
//+------------------------------------------------------------------+
void GetParam(string p)
  {
//---
   if(p==OBJPREFIX+" ")
     {
      //---
      double pVal=TerminalInfoInteger(TERMINAL_PING_LAST);
      //---
      MessageBox
      (
         //---
         dString("99A6D43B833CB976021189ABAEEACF5D")+AccountInfoString(ACCOUNT_NAME)
         +"\n"+
         dString("47D4F60E4272BE70FB300EB05BD2AEC9")+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))
         +"\n"+
         dString("83744D48C2D63F90DD2F812DBB5CFC0C")+IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE))
         +"\n\n"+
         //---
         dString("B001C36F24DDD87AFB300EB05BD2AEC9")+AccountInfoString(ACCOUNT_COMPANY)
         +"\n"+
         dString("808FEF727352434E021189ABAEEACF5D")+AccountInfoString(ACCOUNT_SERVER)
         +"\n"+
         dString("70FA849373E41928")+DoubleToString(pVal/1000,2)+dString("CDB9155CB6080FC4")
         +"\n\n"+
         //---
         dString("47EFF8FADDDA4F05FB300EB05BD2AEC9")+dString("97BA10D5D76C54AE")
         +"\n\n"+
         dString("7823F8858C13A39B7CC5A7EC4F40E381")
         +"\n"+
         dString("3D1E8ABC29DB2E92F1B07FD9CB96A45738FCA32595840B48C24BEEC18191F150087C9AFD999E487F")
         +"\n\n"+
         dString("589AC65F2BB83753")
         +"\n"+
         dString("3D1E8ABC29DB2E92F1B07FD9CB96A45738FCA32595840B4801D4FEEBA49183BD6314E740BF3EB954")
         //---
         ,MB_CAPTION,MB_ICONINFORMATION|MB_OK
      );
     }
//---
  }
//+------------------------------------------------------------------+
//| GetSetInputsA                                                    |
//+------------------------------------------------------------------+
void GetSetInputsA()
  {
//---
   double balance=AccountInfoDouble(ACCOUNT_BALANCE);

//---
   if(StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT))-RiskInpP!=0)
     {
      //---
      RiskC=(balance/100)*StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT));
      //---
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT,0,DoubleToString(RiskC,2));/*SetObject*/
      //---
      RiskInpP=StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT));
     }

//---
   if(StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT))-RiskInpC!=0)
     {
      //---
      if(balance!=0)
         RiskP=StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT))*100/balance;
      //---
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT,0,DoubleToString(RiskP,2));/*SetObject*/
      //---
      RiskInpC=StringToDouble(ObjectGetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT));
     }

//---
   if(RiskInpP<0.01)
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"RISK%<>",OBJPROP_TEXT,0,DoubleToString(0.01,2));/*SetObject*/

//---
   if(RiskInpC<=0)
      if(!UserIsEditing)
         ObjectSetString(0,OBJPREFIX+"RISK$<>",OBJPROP_TEXT,0,DoubleToString(0.01,2));/*SetObject*/
//---
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SymbPerc(string _Symb)
  {
//---
   double percent=0,range=iHigh(_Symb,CalcTF,0)-iLow(_Symb,CalcTF,0);
//---
   if(range!=0)
      percent=100*((iClose(_Symb,CalcTF,0)-iLow(_Symb,CalcTF,0))/range);
//---
   return(percent);
  }
//+------------------------------------------------------------------+
//| ±Str                                                             |
//+------------------------------------------------------------------+
string ±Str(double Inp,int Precision)
  {
//--- PositiveValue
   if(Inp>0)
      return("+"+DoubleToString(Inp,Precision));
//--- NegativeValue
   else
      return(DoubleToString(Inp,Precision));
//---
  }
//+------------------------------------------------------------------+
//| ±Clr                                                             |
//+------------------------------------------------------------------+
color ±Clr(double Inp)
  {
//---
   color clr=clrNONE;
//--- PositiveValue
   if(Inp>0)
      clr=COLOR_GREEN;
//--- NegativeValue
   if(Inp<0)
      clr=COLOR_RED;
//--- NeutralValue
   if(Inp==0)
      clr=COLOR_FONT;
//---
   return(clr);
  }
//+------------------------------------------------------------------+
//| ±ClrBR                                                           |
//+------------------------------------------------------------------+
color ±ClrBR(double Inp)
  {
//---
   color clr=clrNONE;
//--- PositiveValue
   if(Inp>0)
      clr=COLOR_BUY;
//--- NegativeValue
   if(Inp<0)
      clr=COLOR_SELL;
//--- NeutralValue
   if(Inp==0)
      clr=COLOR_FONT;
//---
   return(clr);
  }
//+------------------------------------------------------------------+
//| Deposits                                                         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| _AccountCurrency                                                 |
//+------------------------------------------------------------------+
string _AccountCurrency()
  {
//---
   string txt="";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="AUD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="BGN")
      txt="B";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CAD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CHF")
      txt="F";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="COP")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CRC")
      txt="₡";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CUP")
      txt="₱";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="CZK")
      txt="K";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="EUR")
      txt="€";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="GBP")
      txt="£";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="GHS")
      txt="¢";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="HKD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="JPY")
      txt="¥";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="NGN")
      txt="₦";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="NOK")
      txt="k";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="NZD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="USD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="RUB")
      txt="₽";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="SGD")
      txt="$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="ZAR")
      txt="R";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="SEK")
      txt="k";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY)=="VND")
      txt="₫";
//---
   if(txt=="")
      txt="$";
//---
   return(txt);
  }
//+------------------------------------------------------------------+
//| PriceByTkt                                                       |
//+------------------------------------------------------------------+
double PriceByTkt(const int Type,const int Ticket)
  {
//---
   double price=0;
//---
   if(OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      //---
      if(Type==OPENPRICE)
         price=OrderOpenPrice();
      //---
      if(Type==CLOSEPRICE)
         price=OrderClosePrice();
     }
//---
   return(price);
  }
//+------------------------------------------------------------------+
//| SymbolFind                                                       |
//+------------------------------------------------------------------+
bool SymbolFind(const string _Symb,int mode)
  {
//---
   bool result=false;
//---
   for(int i=0; i<SymbolsTotal(mode); i++)
     {
      //---
      if(_Symb==SymbolName(i,mode))
        {
         result=true;//SymbolFound
         break;
        }
     }
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| SetStatus                                                        |
//+------------------------------------------------------------------+
void SetStatus(string Char,string Text)
  {
//---
   Comment("");
//---
   stauts_time=TimeLocal();
//---
   ObjectSetString(0,OBJPREFIX+"STATUS",OBJPROP_TEXT,Char);
   ObjectSetString(0,OBJPREFIX+"STATUS«",OBJPROP_TEXT,Text);
//---
  }
//+------------------------------------------------------------------+
//| ResetStatus                                                      |
//+------------------------------------------------------------------+
void ResetStatus()
  {
//---
   if(ObjectGetString(0,OBJPREFIX+"STATUS",OBJPROP_TEXT)!="\n" || ObjectGetString(0,OBJPREFIX+"STATUS«",OBJPROP_TEXT)!="\n")
     {
      ObjectSetString(0,OBJPREFIX+"STATUS",OBJPROP_TEXT,"\n");
      ObjectSetString(0,OBJPREFIX+"STATUS«",OBJPROP_TEXT,"\n");
     }
//---
  }
//+------------------------------------------------------------------+
//| Dpi                                                              |
//+------------------------------------------------------------------+
int Dpi(int Size)
  {
//---
   int screen_dpi=TerminalInfoInteger(TERMINAL_SCREEN_DPI);

   int base_width=Size;
   int width=(base_width*screen_dpi)/96;
   int scale_factor=(TerminalInfoInteger(TERMINAL_SCREEN_DPI)*100)/96;
//---
   width=(base_width*scale_factor)/100;
//---
   return(width);
  }


//+------------------------------------------------------------------+
//| dString                                                          |
//+------------------------------------------------------------------+
string dString(string text)
  {
//---
   uchar in[],out[],key[];
//---
   StringToCharArray("H+#eF_He",key);
//---
   StringToCharArray(text,in,0,StringLen(text));
//---
   HexToArray(text,in);
//---
   CryptDecode(CRYPT_DES,in,key,out);
//---
   string result=CharArrayToString(out);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| HexToArray                                                       |
//+------------------------------------------------------------------+
bool HexToArray(string str,uchar &arr[])
  {
//--- By Andrew Sumner & Alain Verleyen
//--- https://www.mql5.com/en/forum/157839/page3
#define HEXCHAR_TO_DECCHAR(h) (h<=57?(h-48):(h-55))
//---
   int strcount = StringLen(str);
   int arrcount = ArraySize(arr);
   if(arrcount < strcount / 2)
      return false;
//---
   uchar tc[];
   StringToCharArray(str,tc);
//---
   int i=0,j=0;
//---
   for(i=0; i<strcount; i+=2)
     {
      //---
      uchar tmpchr=(HEXCHAR_TO_DECCHAR(tc[i])<<4)+HEXCHAR_TO_DECCHAR(tc[i+1]);
      //---
      arr[j]=tmpchr;
      j++;
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| ArrayToHex                                                       |
//+------------------------------------------------------------------+
//--- By Andrew Sumner & Alain Verleyen
//--- https://www.mql5.com/en/forum/157839/page3
string ArrayToHex(uchar &arr[],int count=-1)
  {
   string res="";
//---
   if(count<0 || count>ArraySize(arr))
      count=ArraySize(arr);
//---
   for(int i=0; i<count; i++)
      res+=StringFormat("%.2X",arr[i]);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//|  ChartSetColor                                                   |
//+------------------------------------------------------------------+
void ChartSetColor(const int Type)
  {
//--- Set Light
   if(Type==0)
     {
      ChartSetInteger(0,CHART_COLOR_BACKGROUND,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_FOREGROUND,COLOR_FONT);
      ChartSetInteger(0,CHART_COLOR_GRID,clrNONE);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_VOLUME,COLOR_CBG_LIGHT);
      ChartSetInteger(0,CHART_COLOR_ASK,clrNONE);
      ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,COLOR_CBG_LIGHT);
      //---
      ChartSetInteger(0,CHART_SHOW_OHLC,false);
      ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
      ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,false);
      ChartSetInteger(0,CHART_SHOW_GRID,false);
      ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
      ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,false);
     }

//--- Set Dark
   if(Type==1)
     {
      ChartSetInteger(0,CHART_COLOR_BACKGROUND,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_FOREGROUND,COLOR_FONT);
      ChartSetInteger(0,CHART_COLOR_GRID,clrNONE);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_VOLUME,COLOR_CBG_DARK);
      ChartSetInteger(0,CHART_COLOR_ASK,clrNONE);
      ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,COLOR_CBG_DARK);
      //---
      ChartSetInteger(0,CHART_SHOW_OHLC,false);
      ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
      ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,false);
      ChartSetInteger(0,CHART_SHOW_GRID,false);
      ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
      ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,false);
     }

//--- Set Original
   if(Type==2)
     {
      ChartSetInteger(0,CHART_COLOR_BACKGROUND,ChartColor_BG);
      ChartSetInteger(0,CHART_COLOR_FOREGROUND,ChartColor_FG);
      ChartSetInteger(0,CHART_COLOR_GRID,ChartColor_GD);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,ChartColor_UP);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,ChartColor_DWN);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,ChartColor_BULL);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,ChartColor_BEAR);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE,ChartColor_LINE);
      ChartSetInteger(0,CHART_COLOR_VOLUME,ChartColor_VOL);
      ChartSetInteger(0,CHART_COLOR_ASK,ChartColor_ASK);
      ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,ChartColor_LVL);
      //---
      ChartSetInteger(0,CHART_SHOW_OHLC,ChartColor_OHLC);
      ChartSetInteger(0,CHART_SHOW_ASK_LINE,ChartColor_ASKLINE);
      ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,ChartColor_PERIODSEP);
      ChartSetInteger(0,CHART_SHOW_GRID,ChartColor_GRID);
      ChartSetInteger(0,CHART_SHOW_VOLUMES,ChartColor_SHOWVOL);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,ChartColor_OBJDESCR);
      ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,ChartColor_TRADELVL);
     }

//---
   if(Type==3)
     {
      ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrWhite);
      ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);
      ChartSetInteger(0,CHART_COLOR_GRID,clrSilver);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,clrBlack);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrBlack);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrWhite);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrBlack);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrBlack);
      ChartSetInteger(0,CHART_COLOR_VOLUME,clrGreen);
      ChartSetInteger(0,CHART_COLOR_ASK,clrOrangeRed);
      ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,clrOrangeRed);
      //---
      ChartSetInteger(0,CHART_SHOW_OHLC,false);
      ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
      ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,false);
      ChartSetInteger(0,CHART_SHOW_GRID,false);
      ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
     }
//---
  }
//+------------------------------------------------------------------+
//| ChartGetColor                                                    |
//+------------------------------------------------------------------+
//---- Original Template
color ChartColor_BG=0,ChartColor_FG=0,ChartColor_GD=0,ChartColor_UP=0,ChartColor_DWN=0,ChartColor_BULL=0,ChartColor_BEAR=0,ChartColor_LINE=0,ChartColor_VOL=0,ChartColor_ASK=0,ChartColor_LVL=0;
//---
bool ChartColor_OHLC=false,ChartColor_ASKLINE=false,ChartColor_PERIODSEP=false,ChartColor_GRID=false,ChartColor_SHOWVOL=false,ChartColor_OBJDESCR=false,ChartColor_TRADELVL=false;
//----
void ChartGetColor()
  {
   ChartColor_BG=(color)ChartGetInteger(0,CHART_COLOR_BACKGROUND,0);
   ChartColor_FG=(color)ChartGetInteger(0,CHART_COLOR_FOREGROUND,0);
   ChartColor_GD=(color)ChartGetInteger(0,CHART_COLOR_GRID,0);
   ChartColor_UP=(color)ChartGetInteger(0,CHART_COLOR_CHART_UP,0);
   ChartColor_DWN=(color)ChartGetInteger(0,CHART_COLOR_CHART_DOWN,0);
   ChartColor_BULL=(color)ChartGetInteger(0,CHART_COLOR_CANDLE_BULL,0);
   ChartColor_BEAR=(color)ChartGetInteger(0,CHART_COLOR_CANDLE_BEAR,0);
   ChartColor_LINE=(color)ChartGetInteger(0,CHART_COLOR_CHART_LINE,0);
   ChartColor_VOL=(color)ChartGetInteger(0,CHART_COLOR_VOLUME,0);
   ChartColor_ASK=(color)ChartGetInteger(0,CHART_COLOR_ASK,0);
   ChartColor_LVL=(color)ChartGetInteger(0,CHART_COLOR_STOP_LEVEL,0);
//---
   ChartColor_OHLC=ChartGetInteger(0,CHART_SHOW_OHLC,0);
   ChartColor_ASKLINE=ChartGetInteger(0,CHART_SHOW_ASK_LINE,0);
   ChartColor_PERIODSEP=ChartGetInteger(0,CHART_SHOW_PERIOD_SEP,0);
   ChartColor_GRID=ChartGetInteger(0,CHART_SHOW_GRID,0);
   ChartColor_SHOWVOL=ChartGetInteger(0,CHART_SHOW_VOLUMES,0);
   ChartColor_OBJDESCR=ChartGetInteger(0,CHART_SHOW_OBJECT_DESCR,0);
   ChartColor_TRADELVL=ChartGetInteger(0,CHART_SHOW_TRADE_LEVELS,0);
//---
  }
//+------------------------------------------------------------------+
//| ChartMiddleX                                                     |
//+------------------------------------------------------------------+
int ChartMiddleX()
  {
   return((int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| ChartMiddleY                                                     |
//+------------------------------------------------------------------+
int ChartMiddleY()
  {
   return((int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| Create rectangle label                                           |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_rectangle_label
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              x=0,                      // X coordinate
                     const int              y=0,                      // Y coordinate
                     const int              width=50,                 // width
                     const int              height=18,                // height
                     const color            back_clr=C'236,233,216',  // background color
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color            clr=clrRed,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=true,              // hidden in the object list
                     const long             z_order=0,                // priority for mouse click
                     const string           tooltip="\n")             // tooltip for mouse hover
  {
//---- reset the error value
   ResetLastError();
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create a rectangle label! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BitmapCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="BitMap",             // label name
                  const int               sub_window=0,             // subwindow index
                  const int               x=0,                      // X coordinate
                  const int               y=0,                      // Y coordinate
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                  const string            file="",             // text
                  const color             clr=clrRed,               // color
                  const int             width=10,          // visibility scope X coordinate
                  const int             height=10,         // visibility scope Y coordinate
                  const double            angle=0.0,                // text slope
                  const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0,                // priority for mouse click
                  const string            tooltip="\n",             // tooltip for mouse hover
                  const bool              tester=true)              // create object in the strategy tester
  {

//--- reset the error value
   ResetLastError();
//--- CheckTester
   if(!tester && MQLInfoInteger(MQL_TESTER))
      return(false);
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_BITMAP,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create text label! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XOFFSET,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YOFFSET,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_BMPFILE,file);;
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }

//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a text label                                              |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_label
bool LabelCreate(const long              chart_ID=0,               // chart's ID
                 const string            name="Label",             // label name
                 const int               sub_window=0,             // subwindow index
                 const int               x=0,                      // X coordinate
                 const int               y=0,                      // Y coordinate
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text="Label",             // text
                 const string            font="Arial",             // font
                 const int               font_size=10,             // font size
                 const color             clr=clrRed,               // color
                 const double            angle=0.0,                // text slope
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                 const bool              back=false,               // in the background
                 const bool              selection=false,          // highlight to move
                 const bool              hidden=true,              // hidden in the object list
                 const long              z_order=0,                // priority for mouse click
                 const string            tooltip="\n",             // tooltip for mouse hover
                 const bool              tester=true)              // create object in the strategy tester
  {
//--- reset the error value
   ResetLastError();
//--- CheckTester
   if(!tester && MQLInfoInteger(MQL_TESTER))
      return(false);
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create text label! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create Edit object                                               |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_edit
bool EditCreate(const long             chart_ID=0,               // chart's ID
                const string           name="Edit",              // object name
                const int              sub_window=0,             // subwindow index
                const int              x=0,                      // X coordinate
                const int              y=0,                      // Y coordinate
                const int              width=50,                 // width
                const int              height=18,                // height
                const string           text="Text",              // text
                const string           font="Arial",             // font
                const int              font_size=10,             // font size
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type
                const bool             read_only=false,          // ability to edit
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                const color            clr=clrBlack,             // text color
                const color            back_clr=clrWhite,        // background color
                const color            border_clr=clrNONE,       // border color
                const bool             back=false,               // in the background
                const bool             selection=false,          // highlight to move
                const bool             hidden=true,              // hidden in the object list
                const long             z_order=0,                // priority for mouse click
                const string           tooltip="\n")             // tooltip for mouse hover
  {
//--- reset the error value
   ResetLastError();
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create \"Edit\" object! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
      ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the button                                                |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_button
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               x=0,                      // X coordinate
                  const int               y=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0,                // priority for mouse click
                  const string            tooltip="\n")             // tooltip for mouse hover
  {
//--- reset the error value
   ResetLastError();
//---
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create the button! Error code = ",_LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ObjectSetString(chart_ID,name,OBJPROP_TOOLTIP,tooltip);
     }
//---
   return(true);
  }
//+--------------------------------------------------------------------+
//| ChartMouseScrollSet                                                |
//+--------------------------------------------------------------------+
//https://docs.mql4.com/constants/chartconstants/charts_samples
bool ChartMouseScrollSet(const bool value)
  {
//--- reset the error value
   ResetLastError();
//---
   if(!ChartSetInteger(0,CHART_MOUSE_SCROLL,0,value))
     {
      Print(__FUNCTION__,
            ", Error Code = ",_LastError);
      return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| PlaySound                                                        |
//+------------------------------------------------------------------+
void _PlaySound(const string FileName)
  {
//---
   if(SoundIsEnabled)
      PlaySound(FileName);
//---
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double sup(int mbars,string sym,int multiplier)
  {
   double ratio1 = iMA(sym,0,mbars,0,0,0,1)-(iStdDev(sym,0,mbars,0,0,0,1)*multiplier);
   return(ratio1);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double res(int mbars,string sym,int multiplier)
  {
   double ratio1 = iMA(sym,0,mbars,0,0,0,1)+(iStdDev(sym,0,mbars,0,0,0,1)*multiplier);
   return(ratio1);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deletepanel()
  {
   for(int i=0; i<=ObjectsTotal(); i++)
     {
      for(int x=0; x<ArraySize(currentpage); x++)
        {
         ObjectDelete(0,OBJPREFIX+currentpage[x]);
        }
      ObjectDelete(0,OBJPREFIX+"bid"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"bid"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"m1"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"m5"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"m15"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"m30"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"h1"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"h4"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"CS"+IntegerToString(i,0,0));
      ObjectDelete(0,OBJPREFIX+"trend"+IntegerToString(i,0,0));

      //ObjectDelete(0,OBJPREFIX+"Clock");

      ObjectDelete(0,OBJPREFIX+"snr status"+IntegerToString(i,0,0));



      string Name= ObjectName(0,i);

      if(StringSubstr(Name, 0, 3) == "DCC" ||
         StringSubstr(Name, 0, 4) == "Doji" ||
         StringSubstr(Name, 0, 3) == "HMR" ||
         StringSubstr(Name, 0, 3) == "Prc" ||
         StringSubstr(Name, 0, 2) == "SS" ||
         StringSubstr(Name, 0, 3) == "S_E")
        {
         ObjectDelete(0,Name);
        }
     }




  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void draw_again()
  {

   int fr_y2=Dpi(140);
//---
   for(int i=0; i<ArraySize(newpairs); i++)
     {

      //---
      if(SelectedMode==FULL)
         fr_y2+=Dpi(25);
      //---
      if(SelectedMode==COMPACT)
         fr_y2+=Dpi(21);
      //---
      if(SelectedMode==MINI)
         fr_y2+=Dpi(17);
     }

   int fr_y=_y1+Dpi(95);
   deletepanel();
   ArrayResize(signal,ArraySize(currentpage));
   for(int i=0; i<ArraySize(currentpage); i++)
     {

      string pairs;
      CreateSymbGUI(Prefix+currentpage[i]+Suffix,_y1+125+(i*20));

      pairs =Prefix+currentpage[i]+Suffix;
      LabelCreate(0,OBJPREFIX+"bid"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-1110,_y1+125+(i*20),CORNER_LEFT_UPPER, DoubleToStr(SymbolInfoDouble(pairs,SYMBOL_BID),(int)MarketInfo(pairs,MODE_DIGITS)),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
      ENUM_TIMEFRAMES TF[6]= {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4};
      for(int z=0; z<ArraySize(TF); z++)
        {
         double Up1Band=iBands(pairs,TF[z],FirstBB_Period,FirstBB_Deviation,0,FirstBB_Applied,1,0);
         double Dn1Band=iBands(pairs,TF[z],FirstBB_Period,FirstBB_Deviation,0,FirstBB_Applied,2,0);
         double Up2Band=iBands(pairs,TF[z],SeconedBB_Period,SeconedBB_Deviation,0,SeconedBB_Applied,1,0);
         double Dn2Band=iBands(pairs,TF[z],SeconedBB_Period,SeconedBB_Deviation,0,SeconedBB_Applied,2,0);
         double Price=SymbolInfoDouble(pairs,SYMBOL_BID);
         string txt=z==0?"m1":z==1?"m5":z==2?"m15":z==3?"m30":z==4?"h1":"h4";
         if(Price>=Up1Band&&Price<=Up2Band)
           {
            LabelCreate(0,OBJPREFIX+txt+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-1040+(z*50),_y1+125+(i*20),CORNER_LEFT_UPPER, "5","Webdings",15,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");
            signal[i][z]=1;
           }
         else
            if(Price>=Dn1Band&&Price<=Up1Band)
              {
               LabelCreate(0,OBJPREFIX+txt+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-1040+(z*50),_y1+125+(i*20),CORNER_LEFT_UPPER, "4","Webdings",15,clrYellow,0,ANCHOR_LEFT,false,false,true,0,"\n");
               signal[i][z]=0;
              }
            else
               if(Price>=Dn2Band&&Price<=Dn1Band)
                 {
                  LabelCreate(0,OBJPREFIX+txt+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-1040+(z*50),_y1+125+(i*20),CORNER_LEFT_UPPER, "6","Webdings",15,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
                  signal[i][z]=-1;
                 }
        }

      double resist=iCustom(pairs,0,"support-resistance-breakout-arrows",0,0);
      double support=iCustom(pairs,0,"support-resistance-breakout-arrows",1,0);
      for(int x=0; x<Bars(pairs,0); x++)
        {
         resist=iCustom(pairs,0,"support-resistance-breakout-arrows",0,x);
         support=iCustom(pairs,0,"support-resistance-breakout-arrows",1,x);
         if(x==0&&iClose(pairs,0,0)>=resist&&iOpen(pairs,0,0)<resist)
           {
            LabelCreate(0,OBJPREFIX+"snr status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-450),_y1+125+(i*20),CORNER_LEFT_UPPER, "resistance breakout",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
            snrStatus=4;
            break;
           }
         else
            if(x==0&&iClose(pairs,0,0)<=support&&iOpen(pairs,0,0)>support)
              {
               LabelCreate(0,OBJPREFIX+"snr status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-450),_y1+125+(i*20),CORNER_LEFT_UPPER, "Support breakout",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");
               snrStatus=3;
               break;
              }
            else
               if((iClose(pairs,0,x)<=support&&iOpen(pairs,0,x)>support)||(iClose(pairs,0,x)>=support&&iOpen(pairs,0,x)<support))
                 {
                  LabelCreate(0,OBJPREFIX+"snr status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-450),_y1+125+(i*20),CORNER_LEFT_UPPER, "Support area",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");
                  snrStatus=1;
                  break;
                 }
               else
                  if((iClose(pairs,0,x)<=resist&&iOpen(pairs,0,x)>resist)||(iClose(pairs,0,x)>=resist&&iOpen(pairs,0,x)<resist))
                    {
                     LabelCreate(0,OBJPREFIX+"snr status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-450),_y1+125+(i*20),CORNER_LEFT_UPPER, "resistance area",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
                     snrStatus=2;
                     break;
                    }


        }
      bool sig=false;
      if(signal[i][0]==1&&signal[i][1]==1&&signal[i][2]==1&&signal[i][3]==1&&(snrStatus==1||snrStatus==4))
        {
         if(ObjectGetString(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),OBJPROP_TEXT)!="Strong Buy")
           {
            singalTime[i]=0;
            ObjectDelete(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0));
            LabelCreate(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-300),_y1+125+(i*20),CORNER_LEFT_UPPER, "Strong Buy",sFontType,FONTSIZE,clrLime,0,ANCHOR_LEFT,false,false,true,0,"\n");
            if(singalTime[i]==0)
              {
               singalTime[i]=iTime(pairs,TF[0],0);
              }
            ObjectDelete(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0));
            ObjectDelete(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0));
            LabelCreate(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-150),_y1+125+(i*20),CORNER_LEFT_UPPER,TimeToString(singalTime[i],TIME_DATE)+" "+TimeToString(singalTime[i],TIME_MINUTES),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
            LabelCreate(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+125+(i*20),CORNER_LEFT_UPPER,TimeToString(singalTime[i]+ExpiryAfter_x_Miniutes*60),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");



            if(signal_time!=iTime(pairs,TF[0],0))
              {
               Alert("Strong Buy Signal on "+pairs);
               signal_time=iTime(pairs,TF[0],0);
              }
           }
         sig=true;
        }else
      if(signal[i][0]==-1&&signal[i][1]==-1&&signal[i][2]==-1&&signal[i][3]==-1&&(snrStatus==2||snrStatus==3))
        {
         if(ObjectGetString(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),OBJPROP_TEXT)!="Strong Sell")
           {
            singalTime[i]=0;
            ObjectDelete(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0));
            LabelCreate(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-300),_y1+125+(i*20),CORNER_LEFT_UPPER, "Strong Sell",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
            if(singalTime[i]==0)
              {
               singalTime[i]=iTime(pairs,TF[0],0);
              }
            ObjectDelete(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0));
            ObjectDelete(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0));
            LabelCreate(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-150),_y1+125+(i*20),CORNER_LEFT_UPPER,TimeToString(singalTime[i],TIME_DATE)+" "+TimeToString(singalTime[i],TIME_MINUTES),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");

            LabelCreate(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+125+(i*20),CORNER_LEFT_UPPER,TimeToString(singalTime[i]+ExpiryAfter_x_Miniutes*60),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");

            if(signal_time!=iTime(pairs,TF[0],0))
              {
               Alert("Strong Sell Signal on "+pairs);
               signal_time=iTime(pairs,TF[0],0);
              }
           }
         sig=true;
        }else
      if(signal[i][0]==1&&signal[i][1]==1&&signal[i][2]==1&&(snrStatus==1||snrStatus==4))
        {
        string val=ObjectGetString(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),OBJPROP_TEXT);
        Print(val+ pairs);
         if(ObjectGetString(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),OBJPROP_TEXT)!="Buy")
           {
            singalTime[i]=0;
            ObjectDelete(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0));

            LabelCreate(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-300),_y1+125+(i*20),CORNER_LEFT_UPPER, "Buy",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");
            if(singalTime[i]==0)
              {
               singalTime[i]=iTime(pairs,TF[0],0);
              }
            ObjectDelete(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0));
            ObjectDelete(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0));
            LabelCreate(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-150),_y1+125+(i*20),CORNER_LEFT_UPPER,TimeToString(singalTime[i],TIME_DATE)+" "+TimeToString(singalTime[i],TIME_MINUTES),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");

            LabelCreate(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+125+(i*20),CORNER_LEFT_UPPER,TimeToString(singalTime[i]+ExpiryAfter_x_Miniutes*60),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
           }
         sig=true;
        }else
      if(signal[i][0]==-1&&signal[i][1]==-1&&signal[i][2]==-1&&(snrStatus==2||snrStatus==3))
        {
         if(ObjectGetString(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),OBJPROP_TEXT)!="Sell")
           {
            singalTime[i]=0;
            ObjectDelete(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0));

            LabelCreate(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-300),_y1+125+(i*20),CORNER_LEFT_UPPER, "Sell",sFontType,FONTSIZE,clrMagenta,0,ANCHOR_LEFT,false,false,true,0,"\n");
            if(singalTime[i]==0)
              {
               singalTime[i]=iTime(pairs,TF[0],0);
              }
            ObjectDelete(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0));
            ObjectDelete(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0));
            LabelCreate(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-150),_y1+125+(i*20),CORNER_LEFT_UPPER,TimeToString(singalTime[i],TIME_DATE)+" "+TimeToString(singalTime[i],TIME_MINUTES),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
          
            LabelCreate(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH),_y1+125+(i*20),CORNER_LEFT_UPPER,TimeToString(singalTime[i]+ExpiryAfter_x_Miniutes*60),sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
           }
         sig=true;
        }else

      if(signal[i][0]==0&&signal[i][1]==0&&signal[i][2]==0)
        {
         if(ObjectGetString(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),OBJPROP_TEXT)!="Wait")
           {
            singalTime[i]=0;
            //BitmapLabelCreate(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-630,_y1+125+(i*20),CORNER_LEFT_UPPER)
            ObjectDelete(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0));

            LabelCreate(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-300),_y1+125+(i*20),CORNER_LEFT_UPPER, "Wait",sFontType,FONTSIZE,clrYellow,0,ANCHOR_LEFT,false,false,true,0,"\n");

            if(singalTime[i]==0)
              {
               singalTime[i]=iTime(pairs,TF[0],0);
              }
            ObjectDelete(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0));

            LabelCreate(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-150),_y1+125+(i*20),CORNER_LEFT_UPPER,"___",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");

           }
         sig=true;
        }else
      if(!sig)
        {
         if(ObjectGetString(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),OBJPROP_TEXT)!="No Signal")
           {
            singalTime[i]=0;
            ObjectDelete(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0));
            ObjectDelete(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0));
            LabelCreate(0,OBJPREFIX+"signal status"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-300),_y1+125+(i*20),CORNER_LEFT_UPPER, "No Signal",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
            LabelCreate(0,OBJPREFIX+"signal time"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-150),_y1+125+(i*20),CORNER_LEFT_UPPER,"___",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");
            ObjectDelete(0,OBJPREFIX+"expiry"+IntegerToString(i,0,0));

           }
        }
      if(signal[i][0]==0&&signal[i][1]==0&&signal[i][2]==0&&signal[i][3]==0&&signal[i][4]==0)
        {
         LabelCreate(0,OBJPREFIX+"trend"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-730,_y1+125+(i*20),CORNER_LEFT_UPPER, "Side Trend",sFontType,FONTSIZE,clrYellow,0,ANCHOR_LEFT,false,false,true,0,"\n");

        }
      else
         if(signal[i][0]==1&&signal[i][1]==1&&signal[i][2]==1&&signal[i][3]==1&&signal[i][4]==1)
           {
            LabelCreate(0,OBJPREFIX+"trend"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-730,_y1+125+(i*20),CORNER_LEFT_UPPER, "Up Trend",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");

           }
         else
            if(signal[i][0]==-1&&signal[i][1]==-1&&signal[i][2]==-1&&signal[i][3]==-1&&signal[i][4]==-1)
              {
               LabelCreate(0,OBJPREFIX+"trend"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-730,_y1+125+(i*20),CORNER_LEFT_UPPER, "Down Trend",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");

              }
            else
              {
               LabelCreate(0,OBJPREFIX+"trend"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH)-730,_y1+125+(i*20),CORNER_LEFT_UPPER, "No Trend",sFontType,FONTSIZE,clrWhite,0,ANCHOR_LEFT,false,false,true,0,"\n");

              }
      double shootingStar=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",0,1);
      double Bullishhammer=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",1,1);
      double EveningStar=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",2,1);
      double MorningStar=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",3,1);
      double EveningDojiStar=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",4,1);
      double MorningDojiStar=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",5,1);
      double DarkCloud=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",6,1);
      double BearishEngulfing=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",7,1);
      double BullishEngulfing=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",8,1);
      double PireceLine=iCustom(pairs,CandleStickPatternTF,"CandleStick Pattern",9,1);
      bool pattern=false;
      if(shootingStar>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Shooting Star",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(Bullishhammer>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Bullish Hammer",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(EveningStar>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Evening Star",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(MorningStar>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Morning Star",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");

        }
      if(EveningDojiStar>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Evening Doji Star",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(MorningDojiStar>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Morning Doji Star",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(DarkCloud>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Dark Cloud",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(BearishEngulfing>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Bearish Engulfing",sFontType,FONTSIZE,clrRed,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(BullishEngulfing>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Bullish Engulfing",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(PireceLine>0)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "Piercing line pattern",sFontType,FONTSIZE,clrGreen,0,ANCHOR_LEFT,false,false,true,0,"\n");
         pattern=true;
        }
      if(!pattern)
        {
         LabelCreate(0,OBJPREFIX+"CS"+IntegerToString(i,0,0),0,_x1+ Dpi(CLIENT_BG_WIDTH-620),_y1+125+(i*20),CORNER_LEFT_UPPER, "No Pattern",sFontType,FONTSIZE,clrYellow,0,ANCHOR_LEFT,false,false,true,0,"\n");

        }
      //LabelCreate(0,OBJPREFIX+"Today",0,_x1+ Dpi(CLIENT_BG_WIDTH)-950,_y1+30,CORNER_LEFT_UPPER,StringConcatenate(f0_41(TimeLocal())),"Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");
      //LabelCreate(0,OBJPREFIX+"Clock",0,_x1+ Dpi(CLIENT_BG_WIDTH)-700,_y1+30,CORNER_LEFT_UPPER,TimeToString(TimeLocal(),TIME_SECONDS),"Arial Black",10,clrWhite,0,ANCHOR_LEFT,false,false,false,0,"\n");

      //}
      //---
      if(SelectedMode==FULL)
         fr_y+=Dpi(25);
      //---
      if(SelectedMode==COMPACT)
         fr_y+=Dpi(21);
      //---
      if(SelectedMode==MINI)
         fr_y+=Dpi(17);


     }

  }


string entry  ;
string entryprice ;
string entrytime  ;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void Export()
  {
   if(MQLInfoInteger(MQL_DLLS_ALLOWED)==false)
     {
      Alert("Error: DLL imports is not allowed in the program settings.");

     }



   if(ExportSummaryBySymbol(InpFileName))
     {
      //--- open the .csv file with the associated Windows program
      Execute(TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files\\"+InpFileName);

      Print("Data  is exported to ",TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files\\"+InpFileName);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ExportSummaryBySymbol(string filename)
  {




//--- Sorted array of CSymbolSummary objects
   CArrayObj arr;
   arr.Sort(MODE_ASCEND);

//--- now process the list of history orders


   int handle;

//---------- SIZE --------------//
   if(true)
     {
      ResetLastError();
      //--- use FILE_ANSI to correctly display .csv files within Excel 2013 and above.
      handle=FileOpen(filename,FILE_WRITE|FILE_SHARE_READ|FILE_CSV|FILE_ANSI,',');
      if(handle==INVALID_HANDLE)
        {
         Alert("File open failed, error ",_LastError);
         return(false);
        }

      FileWrite(handle,"Symbol","bid","m1","m5","m15","m30","H1","H4","Trend","Signal Status"
                ,"Signal Time","Candle Pattern","Snr Status","Expiry","High","Low","Signal Time"
               );
     }

   else
      return(false);

//---------- FOR --------------//
   CSymbolSummary *summary=NULL;

   int count = arr.Total();
//   for(int i=0; i<ArraySize(finalpairs); i++)
//     {
//
//      if(iLow(finalpairs[i],PERIOD_M1,1)==iLow(finalpairs[i],0,iLowest(finalpairs[i],0,MODE_LOW,Strength_Bar1,0)) && iClose(finalpairs[i],PERIOD_M1,1)>iLow(finalpairs[i],0,iLowest(finalpairs[i],0,MODE_LOW,Strength_Bar1,0)) && sigma1_value(finalpairs[i], Strength_Bar1,iClose(finalpairs[i],0,0))*100<=1)
//        {
//         entry ="Buy" ;
//         entryprice =DoubleToStr(iClose(finalpairs[i],0,0),(int)MarketInfo(finalpairs[i],MODE_DIGITS));
//         entrytime =TimeToStr(iTime(finalpairs[i],0,0),TIME_DATE|TIME_MINUTES);
//
//        }
//      else
//         if(iHigh(finalpairs[i],PERIOD_M1,1)==iHigh(finalpairs[i],0,iHighest(finalpairs[i],0,MODE_HIGH,Strength_Bar1,0)) && iClose(finalpairs[i],PERIOD_M1,1)<iHigh(finalpairs[i],0,iHighest(finalpairs[i],0,MODE_HIGH,Strength_Bar1,0)) && sigma1_value(finalpairs[i], Strength_Bar1,iClose(finalpairs[i],0,0))*100>=99)
//           {
//            entry ="Sell" ;
//            entryprice =DoubleToStr(iClose(finalpairs[i],0,0),(int)MarketInfo(finalpairs[i],MODE_DIGITS));
//            entrytime =TimeToStr(iTime(finalpairs[i],0,0),TIME_DATE|TIME_MINUTES);
//
//           }
//         else
//           {
//            entry ="No signal" ;
//            entryprice ="No Price";
//            entrytime ="No Time";
//
//           }
//
//
//      //      FileWrite(handle,
//      //                finalpairs[i],
//      //                entry,
//      //                entryprice,
//      //                DoubleToStr(iClose(finalpairs[i],0,0)),
//      //                //DoubleToStr(sigma1_value(finalpairs[i], Strength_Bar1,iClose(finalpairs[i],0,0))*100,2),
//      //                //DoubleToStr(sigma1_value(finalpairs[i], Strength_Bar2,iClose(finalpairs[i],0,0))*100,2),
//      //                //DoubleToStr(sigma1_value(finalpairs[i], Strength_Bar3,iClose(finalpairs[i],0,0))*100,2),
//      //                //DoubleToStr(sup(Strength_Bar1,finalpairs[i],3),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //DoubleToStr(sup(Strength_Bar1,finalpairs[i],2),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //DoubleToStr(sup(Strength_Bar1,finalpairs[i],1),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //DoubleToStr(iMA(finalpairs[i],0,Strength_Bar1,0,0,0,1),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //DoubleToStr(res(Strength_Bar1,finalpairs[i],1),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //DoubleToStr(res(Strength_Bar1,finalpairs[i],2),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //DoubleToStr(res(Strength_Bar1,finalpairs[i],3),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //DoubleToStr(MathMax(iHigh(finalpairs[i],PERIOD_M1,1), iHigh(finalpairs[i],0,iHighest(finalpairs[i],0,MODE_HIGH,Strength_Bar1,0))),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //DoubleToStr(MathMin(iLow(finalpairs[i],PERIOD_M1,1),iLow(finalpairs[i],0,iLowest(finalpairs[i],0,MODE_LOW,Strength_Bar1,0))),(int)MarketInfo(finalpairs[i],MODE_DIGITS)),
//      //                //entrytime
//      //
//      //               );
//     }

//--- complete cleaning of the array with the release of memory
   arr.Shutdown();

//--- footer
   FileWrite(handle,"");
//---
   FileClose(handle);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#import "shell32.dll"
int ShellExecuteW(int hWnd,string Verb,string File,string Parameter,string Path,int ShowCommand);
#import
//+------------------------------------------------------------------+
//| Execute Windows command/program or open a document/webpage       |
//+------------------------------------------------------------------+
void Execute(const string command,const string parameters="")
  {
   shell32::ShellExecuteW(0,"open",command,parameters,NULL,1);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void pagescode()
  {
   deletepanel();
   for(int i=0; i<ArraySize(singalTime); i++)
     {
      singalTime[i]=0;
     }
   pages =(ArraySize(finalpairs)/Pairs_N_page)+1;
   if(starter+Pairs_N_page>ArraySize(finalpairs))
     {starter=0;}
   if(starter<=ArraySize(finalpairs))
     {
      starter =starter+Pairs_N_page;
     }
   int x=150;//ChartMiddleX()-(Dpi(CLIENT_BG_WIDTH)/2);
   int y=50;//ChartMiddleY()-(fr_y2/2);


   LabelCreate(0,OBJPREFIX+"Pages",0,x+50,y-10,CORNER_LEFT_UPPER,"Page "+IntegerToString(starter/Pairs_N_page,0,0)+"/"+IntegerToString(pages-1,0,0),"Arial Black",10,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,"\n");

   int HowManySymbols=SymbolsTotal(true);
   string ListSymbols=" ";
   for(int i=0; i<HowManySymbols; i++)
     {
      ListSymbols=StringConcatenate(ListSymbols,SymbolName(i,true),",");
     }

   u_sep=StringGetCharacter(sep,0);
   kz=StringSplit(ListSymbols,u_sep,newpairs);
   int index =0;
   int index2 =0;


   ArrayResize(finalpairs,ArraySize(newpairs));
   for(int i=0; i<ArraySize(newpairs); i++)
     {

      finalpairs[index2]=newpairs[i];
      index2++;

     }
   ArrayResize(currentpage,Pairs_N_page+1);
   for(int i=0; i<=Pairs_N_page; i++)
     {
      currentpage[i]=finalpairs[starter-i];

     }
   pages =(ArraySize(finalpairs)/Pairs_N_page)+1;

   draw_again();

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double sigma1_value(string sym, int strg, double price)
  {
   double mean =  iMA(sym,0,strg,0,0,0,1) ;
   double std  =  iStdDev(sym,0,strg,0,0,0,1);
   double ratio1 = 68.26;
   double ratio2 = 95.44;
   double ratio3 = 99.72;
   double ratio4 = 100;

   double high =   MathMax(iHigh(sym,PERIOD_M1,1), iHigh(sym,0,iHighest(sym,0,MODE_HIGH,strg,1))) ;
   double low  =  MathMin(iLow(sym,PERIOD_M1,1),iLow(sym,0,iLowest(sym,0,MODE_LOW,strg,1))) ;

   double ratio1_ = 68.26/2;;
   double ratio2_ = MathAbs(ratio2-ratio1)/2;
   double ratio3_ = MathAbs(ratio3-ratio2)/2;
   double ratio4_ = ratio4/ratio3 ;


   double factor1 = 68.26/2/std;
   double factor2 = MathAbs(ratio2-ratio1)/2/std;
   double factor3 = MathAbs(ratio3-ratio2)/2/std;
   double factor4 = ratio4/ratio3/std;


   double res1= mean +std;
   double res2= mean +(std*2);
   double res3= mean +(std*3);

   double sup1= mean -std;
   double sup2= mean -(std*2);
   double sup3= mean -(std*3);

   /*double segmaup1=50+(((res1-mean)/100)*factor1);
    Print(segmaup1);
    double segmaup2= mean -std;
    double segmaup3= mean -std;
    */


   double lvl1up = (0.5+ ((MathAbs(res1-mean)/100)*factor1)) ;
   double lvl2up = lvl1up+ ((MathAbs(res2-res1)/100)*factor2);
   double lvl3up = lvl2up+ ((MathAbs(res3-res2)/100)*factor3);
   double lvl4up = lvl3up+ ((MathAbs(high-res3)/100)*factor4);



   double lvl1dn = (0.5- ((MathAbs(sup1-mean)/100)*factor1)) ;
   double lvl2dn = lvl1dn- ((MathAbs(sup1-sup2)/100)*factor2);
   double lvl3dn = lvl2dn- ((MathAbs(sup2-sup3)/100)*factor3);
   double lvl4dn = lvl3dn- ((MathAbs(low-sup3)/100)*factor4);


   if(price>=res1 && price <res2)
     {
      return(lvl1up+ ((MathAbs(price-res1)/100)*factor2));
     }

   if(price>=res2 && price <res3)
     {
      return(lvl2up+ ((MathAbs(price-res2)/100)*factor3));
     }

   if(price>=res3 && price <high)
     {
      return(lvl3up+ ((MathAbs(price-res3)/100)*factor4));
     }





   if(price<=sup1 && price >sup2)
     {
      return(lvl1dn-((MathAbs(price-sup1)/100)*factor2));
     }

   if(price<=sup2 && price >sup3)
     {
      return(lvl2dn- ((MathAbs(price-res2)/100)*factor3));
     }

   if(price<=sup3 && price >low)
     {
      return(lvl3dn-((MathAbs(price-sup3)/100)*factor4));
     }

   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Create the arrow                                                 |
//+------------------------------------------------------------------+
bool ArrowCreate(const long              chart_ID=0,           // chart's ID
                 const string            name="Arrow",         // arrow name
                 const int               sub_window=0,         // subwindow index
                 int                x=0,               // anchor point time
                 int                  y=0,              // anchor point price
                 const uchar             arrow_code=252,       // arrow code
                 const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // anchor point position
                 const color             clr=clrRed,           // arrow color
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style
                 const int               width=3,              // arrow size
                 const bool              back=false,           // in the background
                 const bool              selection=true,       // highlight to move
                 const bool              hidden=true,          // hidden in the object list
                 const long              z_order=0)            // priority for mouse click
  {

//--- reset the error value
   ResetLastError();
//--- create an arrow
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create an arrow! Error code = ",GetLastError());
         return(false);
        }
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      //--- set the arrow code
      ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
      //--- set anchor type
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      //--- set the arrow color
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      //--- set the border line style
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      //--- set the arrow's size
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
      //--- display in the foreground (false) or background (true)
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      //--- enable (true) or disable (false) the mode of moving the arrow by mouse
      //--- when creating a graphical object using ObjectCreate function, the object cannot be
      //--- highlighted and moved by default. Inside this method, selection parameter
      //--- is true by default making it possible to highlight and move the object
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      //--- hide (true) or display (false) graphical object name in the object list
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      //--- set the priority for receiving the event of a mouse click in the chart
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
     }
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//| Change anchor type                                               |
//+------------------------------------------------------------------+
bool ArrowAnchorChange(const long              chart_ID=0,        // chart's ID
                       const string            name="Arrow",      // object name
                       const ENUM_ARROW_ANCHOR anchor=ANCHOR_TOP) // anchor type
  {
//--- reset the error value
   ResetLastError();
//--- change anchor type
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor))
     {
      Print(__FUNCTION__,
            ": failed to change anchor type! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete an arrow                                                  |
//+------------------------------------------------------------------+
bool ArrowDelete(const long   chart_ID=0,   // chart's ID
                 const string name="Arrow") // arrow name
  {
//--- reset the error value
   ResetLastError();
//--- delete an arrow
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete an arrow! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//| Check anchor point values and set default values                 |
//| for empty ones                                                   |
//+------------------------------------------------------------------+
void ChangeArrowEmptyPoint(datetime &time,double &price)
  {
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Create Bitmap Label object                                       |
//+------------------------------------------------------------------+
bool BitmapLabelCreate(const long              chart_ID=0,               // chart's ID
                       const string            name="BmpLabel",          // label name
                       const int               sub_window=0,             // subwindow index
                       const int               x=0,                      // X coordinate
                       const int               y=0,                      // Y coordinate
                       const string            file_on="",               // image in On mode
                       const int               width=0,                  // visibility scope X coordinate
                       const int               height=0,                 // visibility scope Y coordinate
                       const int               x_offset=10,              // visibility scope shift by X axis
                       const int               y_offset=10,              // visibility scope shift by Y axis
                       const bool              state=false,              // pressed/released
                       const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                       const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                       const color             clr=clrRed,               // border color when highlighted
                       const ENUM_LINE_STYLE   style=STYLE_SOLID,        // line style when highlighted
                       const int               point_width=1,            // move point size
                       const bool              back=false,               // in the background
                       const bool              selection=false,          // highlight to move
                       const bool              hidden=true,              // hidden in the object list
                       const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a bitmap label
   if(ObjectFind(chart_ID,name)!=0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_BITMAP_LABEL,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create \"Bitmap Label\" object! Error code = ",GetLastError());
         return(false);
        }
      //--- set the images for On and Off modes
      if(!ObjectSetString(chart_ID,name,OBJPROP_BMPFILE,0,file_on))
        {
         Print(__FUNCTION__,
               ": failed to load the image for On mode! Error code = ",GetLastError());
         return(false);
        }

      //--- set label coordinates
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      //--- set visibility scope for the image; if width or height values
      //--- exceed the width and height (respectively) of a source image,
      //--- it is not drawn; in the opposite case,
      //--- only the part corresponding to these values is drawn
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      //--- set the part of an image that is to be displayed in the visibility scope
      //--- the default part is the upper left area of an image; the values allow
      //--- performing a shift from this area displaying another part of the image
      ObjectSetInteger(chart_ID,name,OBJPROP_XOFFSET,x_offset);
      ObjectSetInteger(chart_ID,name,OBJPROP_YOFFSET,y_offset);
      //--- define the label's status (pressed or released)
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      //--- set the chart's corner, relative to which point coordinates are defined
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      //--- set anchor type
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      //--- set the border color when object highlighting mode is enabled
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      //--- set the border line style when object highlighting mode is enabled
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      //--- set a size of the anchor point for moving an object
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,point_width);
      //--- display in the foreground (false) or background (true)
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      //--- enable (true) or disable (false) the mode of moving the label by mouse
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      //--- hide (true) or display (false) graphical object name in the object list
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      //--- set the priority for receiving the event of a mouse click in the chart
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+


//


// 1C87E1D5E9B9F532C8C3AC87514AEBF1
string f0_6(int ai_0)
  {
   string ls_4 = ai_0 + 100;
   return (StringSubstr(ls_4, 1));
  }

// DF1FB33930688DD4EF20887553F0BE5E
string f0_41(int ai_0)
  {
   return (StringConcatenate(gsa_88[TimeDayOfWeek(ai_0)], " ", f0_6(TimeDay(ai_0)), " ", gsa_92[TimeMonth(ai_0) - 1], " ",TimeYear(ai_0)));
  }
//+------------------------------------------------------------------+
