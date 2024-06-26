//+------------------------------------------------------------------+
//|                                         9IndicatorSolidEA_v7.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#define TOTAL_IndicatorTypes 4+1
enum indi
  {
   off=0,          // OFF
   beast=1,        // Beast
   triger=2,       // Triger
   uni=3,          // Uni Cross
   zigzag=4,       // Zig Zag
  };
#define IndicatorName1 "1BeastSuperSignal.ex4"
#define IndicatorName2 "1Triggerlines.ex4"
#define IndicatorName3 "127031_uni_cross.ex4"
#define IndicatorName4 "1ZigZagSignal.ex4"
#resource "\\Indicators\\"+IndicatorName1;
#resource "\\Indicators\\"+IndicatorName2;
#resource "\\Indicators\\"+IndicatorName3;
#resource "\\Indicators\\"+IndicatorName4;


string version  = "5.0";
enum ENUM_UNIT
  {
   InPips,                 // SL in pips
   InDollars               // SL in dollars
  };

enum profittype
  {
   InCurrencyProfit = 0,                                    // In Currency
   InPercentProfit = 1                                      // In Percent
  };

enum losstype
  {
   InCurrencyLoss = 0,                                      // In Currency
   InPercentLoss = 1                                        // In Percent
  };

enum signaltype
  {
   IntraBar = 0,   // Intrabar
   ClosedCandle = 1       // On new bar
  };
enum yesno
  {
   yes = 0,   // Yes
   no = 1       // No
  };
enum inditrend
  {
   withtrend = 0,   // With Trend
   changetrend = 1       // Change Trend
  };

enum join
  {
   sendiri = 0,   // Seperate Strategy
   gabung = 1       // Join Strategy
  };
enum trademode
  {
   Auto = 0,   // Auto
   Manual = 1,       // Manual
   Telegram = 2,     // Telegram
   None        // None
  };
enum tipeorder
  {
   buyx = 0,   // Buy Only
   sellx = 1,       // Sell Only
   bothx = 2       // Both
  };
enum execute
  {
   instan = 0,   // Market Price
   limit = 1,       // Limit Order
   stop = 2       // Stop Order
  };
enum caraclose
  {
   opposite = 0,   // Indicator Reversal Signal
   sltp = 1,       // Take Profit and Stop Loss
   bar = 2,       // Close With N Bar
   date = 3       // Close With Date
  };
enum periodtf
  {
//   Current = 0,                                 // Current Period
   M1 = 1,                                      // 1 Minutes
   M5 = 5,                                      // 5 Minutes
   M15 = 15,                                    // 15 Minutes
   M30 = 30,                                    // 30 Minutes
   H1 = 60,                                     // 1 Hour
   H4 = 240,                                    // 4 Hours
   D1 = 1440,                                   // 1 Day
   W1 = 10080,                                  // 1 Week
   MN1 = 43200                                  // 1 Month
  };
#define SEPARATOR "________________"

string EA_Name="TFM EA v4.00";

extern string     conctact          = "===== For enquiries Contact 2348035290590 on WhatApps====="; //====Contact Solidsignal@yahoo.com=====
extern int        MT4account        = 1234567;     // MT4 Number/ Pascode
extern trademode  usemode           = Auto;        // Trade Mode
extern trademode  commentselect     = Auto;        // Comment
input  bool       Skip              = false;       //Skip Initial signals
extern string     comment           = "JOINT";
extern int        Magic             = 2222;       // Magic Number
extern string     mysimbol          ="AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADCHF,CADJPY,CHFJPY,EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDCAD,NZDCHF,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY,XAUUSD";
//extern string     mysimbol          = "USDCHF,EURUSD,USDCAD,EURJPY,EURGBP,GBPUSD,GBPCAD,GBPJPY,GBPNZD,GBPAUD,EURCAD,EURNZD,EURCHF,CADJPY,CADCHF,CHFJPY,NZDUSD,NZDCAD,NZDCHF,XAUUSD"; //Trade Symbol (Separate by Comma)
extern tipeorder  tipeOP            = bothx;       // Tipe Order
extern join       joinseperate      =1;            //Strategy
extern int        minbalance        =500;           //Min Euquity Bal to open Trade
extern int        maxbuy            = 40;          //Max allowed Buy Trade
extern int        maxsell           = 40;          //Max Allowed Sell Trade
extern int        MaxLevel          = 2;           //Max Open Trade
extern int        Max_Spread        = 25;          // MaxSpread
extern bool       BarBaru           = false;        //Open New Bar Indicator
extern execute    caraop            = instan;      //Order Execution Mode
extern int        orderdistance     = 30;          //Order Distance
extern yesno      deletepo          = no;          //Delete Pending Order
extern int        orderexp          = 3;           //Pending order Experation (inBars)
extern caraclose  closetype         = opposite;        //Choose Closing Type
extern double     ProfitValue       = 30.0;         //Maximum Profit in %
extern double     Lots              = 0.05;        //First Lots
extern double     SubLots           = 0.03;        //Sub Lots
extern int        TakeProfit        = 100;          // Take Profit (inPips)
extern int        TakeProfit1       = 30;          // Distance TP 2 (inPips)
extern int        StopLoss          = 50;          // Stop Loss (inPips)
extern yesno      fibotp            = no;         // Use Fibo TP
string    ftp               = "Set GMT offset";//=====Use Fibo TP=======
extern int        GMTshift          = 3;//GMT Shift Fibo SnR


extern bool       MM                = false;        // Use Optimal Lot Size
extern double     Risk              = 10;           // Risk Percent


input string ___TRADE_MONITORING_SETTINGS___    = SEPARATOR;             //=== Trade Monitoring Settings ===
input bool UsePartialClose                      = true;                  // Use Partial Close
input ENUM_UNIT PartialCloseUnit                = InPips;             // Partial Close Unit
input double PartialCloseTrigger                = 40;                    // Partial Close after
input double PartialClosePercent                = 0.5;                   // Percentage of lot size to close
input int MaxNoPartialClose                     = 1;                     // Max No of Partial Close
input string ___TRADE_MONITORING_TRAILING___    = "";                    // - Trailing Stop Parameters
input bool UseTrailingStop                      = true;                  // Use Trailing Stop
input ENUM_UNIT TrailingUnit                    = InPips;             // Trailing Unit
input double TrailingStart                      = 35;                   // Trailing Activated After
input double TrailingStep                       = 10;                   // Trailing Step
input double TrailingStop                       = 2;                    // Trailing Stop
input string ___TRADE_MONITORING_BE_________    = "";                    // - Break Even Parameters
input bool UseBreakEven                         = true;                  // Use Break Even
input ENUM_UNIT BreakEvenUnit                   = InPips;             // Break Even Unit
input double BreakEvenTrigger                   = 30;                   // Break Even Trigger
input double BreakEvenProfit                    = 1;                   // Break Even Profit
input int MaxNoBreakEven                        = 1;                     // Max No of Break Even
input string ___DEBUG_____           = SEPARATOR;      //=== DEBUG Settings ===
input bool DebugTrailingStop         = true;           // Trailing Stop Infos in Journal
input bool DebugBreakEven            = true;           // Break Even Infos in Journal
input bool DebugUnit                 = true;           // SL TP Trail BE Units Infos in Journal (in tester)
input bool DebugPartialClose         = true;           // Partial close Infos in Journal

extern losstype   LossType          = InPercentLoss;        // Loss Type
extern double     LossValue =70; // Max Loss Limit (%)
extern yesno      telegram         = yes; //Telegram Bot
string _token = "-1001241251021:f101aec7";//Token Tes

extern string     TelegramAPIToken   = "1719531345:AAFB4PvidYwk1KNOKmyYKSuAXSldYoTXFQ8";
extern string     TelegramChannelName = "-516717967";
extern yesno      sendnews         = yes; //Send News Alert
extern yesno      sendorder        = yes; //Send Trade Order
extern yesno      sendclose        = yes; //Send Close Order
extern yesno      sendsignal       = yes; //Send Single Indicator Signal
extern yesno      sendTradesignal       = yes; //Send Strategy Trade Signal

input string BEAST_SETTINGS="/////////////////";
input int BEAST_Depth=60;
input int BEAST_Deviation=5;
input int BEAST_BackStep=4;
input int BEAST_StochasticLen=7;
input double BEAST_StochasticFilter=0;
input double BEAST_OverBoughtLevel =70;
input double BEAST_OverSoldLevel = 40;
input int BEAST_MATrendLinePeriod =10;
input ENUM_MA_METHOD  BEAST_MATrendLineMethod =MODE_SMA;
input ENUM_APPLIED_PRICE BEAST_MATrendLinePrice =PRICE_CLOSE;
input int BEAST_MAPerod=15;
input int BEAST_MAShift=0;
input ENUM_MA_METHOD BEAST_MAMethod=MODE_SMA;
input ENUM_APPLIED_PRICE BEAST_MAPrice=PRICE_CLOSE;
bool BEAST_alert=false;
bool BEAST_push=false;
bool BEAST_mail=false;
int BEAST_arrow=50;
input string FOREXENTRYPOINT_SETTINGS="/////////////////";
input int FOREXENTRYPOINT_KPeriod =21;
input int FOREXENTRYPOINT_DPeriod =12;
input int FOREXENTRYPOINT_Slowing =4;
input int FOREXENTRYPOINT_method =0;
input int FOREXENTRYPOINT_price = 0;
string FOREXENTRYPOINT_wpr="";
input int FOREXENTRYPOINT_WPRPerod=14;
input double FOREXENTRYPOINT_ZoneHighPer=70;
input double FOREXENTRYPOINT_ZoneLowPer=40;
input bool FOREXENTRYPOINT_ModeOne=true;
bool FOREXENTRYPOINT_psb=false;
bool FOREXENTRYPOINT_pss=false;
string FOREXENTRYPOINT_bsf="alert.wav";
string FOREXENTRYPOINT_ssf="alert.wav";
input string MA_BBANDS_SETTINGS="/////////////////";
input int MA_BBANDS_MacdFastPeriod=5;
input int MA_BBANDS_MacdSlowPeriod=9;
input int MA_BBANDS_MacdSignal=4;
input int MA_BBANDS_MAPeriod =9;
input int MA_BBANDS_MoveShift =0;
input int MA_BBANDS_MAfastPeriod=4;
input int MA_BBANDS_Dist2=20;
input double MA_BBANDS_Std=0.4;
input int MA_BBANDS_BPeriod=20;
input string SIGNALLINEARROW_SETTINGS="/////////////////";
input int SIGNALLINEARROW_Period=15;
input ENUM_MA_METHOD SIGNALLINEARROW_Method=MODE_SMA;
input ENUM_APPLIED_PRICE SIGNALLINEARROW_Price =PRICE_CLOSE;
bool SIGNALLINEARROW_alert=false;
input string TRIGGERLINES_SETTINGS="/////////////////";
input int TRIGGERLINES_Rperiod=15;
input int TRIGGERLINES_LSMA_Period=5;
input string induniSett = "+++++++ Unicross Settings +++++++";//+++++++ Unicross Settings +++++++
bool UseSound              = false;           // Alerts plays a sound ?
bool TypeChart             = false;           // Alerts displays on screen ?
bool UseAlert              = false;           // Use alert?
string NameFileSound       = "alert.wav";     // Sound filename
input int T3Period               = 14;              // T3 Period
input ENUM_APPLIED_PRICE T3Price = PRICE_CLOSE;     // T3 Source
input double b                   = 0.618;           // T3 b Factor
input int Snake_HalfCycle        = 5;               // Snake_HalfCycle = 4...10 or other
enum ENUM_CROSSING_MODE
  {
   T3CrossingSnake,
   SnakeCrossingT3
  };
input ENUM_CROSSING_MODE Inverse = T3CrossingSnake; // 0=T3 crossing Snake, 1=Snake crossing T3
input int DeltaForSell           = 0;               // Delta for sell signal
input int DeltaForBuy            = 0;               // Delta for buy signal
double ArrowOffset         = 0.5;             // Arrow vertical offset
int    Maxbars             = 500;              // Lookback
input string ZIGZAG_SETTINGS="/////////////////";
input int ZIGZAG_Depth=62;
input int ZIGZAG_Deviation=15;
input int ZIGZAG_BackStep=9;
int ZIGZAG_alertmessages=0;
int ZIGZAG_email=0;
int ZIGZAG_alertbar=4;
int ZIGZAG_notify=0;
int ZIGZAG_displayinfo=0;

extern string strategy1        = "=====Open Indicator I====="; //====Entry Strategy Indicator_I=====

extern indi indikator1     =uni;//Select desire Indicator from installed indicators Also This is Master
extern periodtf timeframe1 = D1;// Entry Time Frame
extern inditrend indicatortrend1 = withtrend;//Type Of Entry
string comment1           = "B_M30";//Comment
extern int shift1                = 1;//Bar shift

extern string strategy2        = "=====Open Indicator 2====="; //====Entry Strategy Indicator_2=====
extern indi indikator2     =uni;//Select desire Indicator from installed indicators Also This is Master
extern periodtf timeframe2 = M30;// Entry Time Frame
extern inditrend indicatortrend2 = withtrend;//Type Of Entry
string comment2           = "B_H1";//Comment
extern int shift2                = 1;//Bar shift

extern string strategy3        = "=====Open Indicator 3====="; //====Entry Strategy Indicator_3=====
extern indi indikator3     =off;//Select desire Indicator from installed indicators Also This is Master
extern periodtf timeframe3 = M30;// Entry Time Frame_1
extern inditrend indicatortrend3 = changetrend;//Type Of Entry
string comment3           = "Z_H1";//Comment
extern int shift3                = 1;//Bar shift

extern string strategy4        = "=====Open Indicator 4====="; //====Entry Strategy Indicator_4=====
extern indi indikator4     =off;//Select desire Indicator from installed indicators Also This is Master
extern periodtf timeframe4 = M30;// Entry Time Frame_1
extern inditrend indicatortrend4 = changetrend;//Type Of Entry
string comment4           = "F_H1";//Comment
extern int shift4                = 1;//Bar shift

extern string strategy1x        = "=====Exit Indicator 1====="; //====Exit Strategy Indicator_1=====
extern indi indikator1x     =uni;//Select desire Indicator from installed indicators Also This is Master
extern periodtf timeframe1x = M30;// Entry Time Frame_1
inditrend indicatortrend1x = withtrend;//Type Of Entry

extern string strategy2x        = "=====Exit Indicator 2====="; //====Exit Strategy Indicator_2=====
extern indi indikator2x     =zigzag;//Select desire Indicator from installed indicators Also This is Master
extern periodtf timeframe2x = M30;// Entry Time Frame_1
inditrend indicatortrend2x = changetrend;//Type Of Entry

extern string strategy3x        = "=====Exit Indicator 3====="; //====Exit Strategy Indicator_3=====
extern indi indikator3x     =off;//Select desire Indicator from installed indicators Also This is Master
extern periodtf timeframe3x = H1;// Entry Time Frame_1
inditrend indicatortrend3x = changetrend;//Type Of Entry

extern string strategy4x        = "=====Exit Indicator 4====="; //====Exit Strategy Indicator_4=====
extern indi indikator4x     =off;//Select desire Indicator from installed indicators Also This is Master
extern periodtf timeframe4x = H1;// Entry Time Frame_1
inditrend indicatortrend4x = changetrend;//Type Of Entry


enum DYS_WEEK
  {
   Sunday=0,
   Monday=1,
   Tuesday=2,
   Wednesday,
   Thursday=4,
   Friday=5,
   Saturday
  };

enum TIME_LOCK
  {
   closeall,//CLOSE_ALL_TRADES
   closeprofit,//CLOSE_ALL_PROFIT_TRADES
   breakevenprofit//MOVE_PROFIT_TRADES_TO_BREAKEVEN
  };


extern string  h1                   ="===Time Management System==="; // =========Monday==========
input  yesno   SET_TRADING_DAYS     = no;
input  DYS_WEEK EA_START_DAY        = Sunday;
input string EA_START_TIME          ="22:00";
input DYS_WEEK EA_STOP_DAY          = Friday;
input string EA_STOP_TIME          ="22:00";
input TIME_LOCK EA_TIME_LOCK_ACTION = closeall;


/*extern bool    MondayTrade          = FALSE;                // Monday Trading
extern int     StartHour1           = 8;                    // Start Hour Session 1
extern int     EndHour1             = 20;                    // End Hour Session 1

extern string  h2                   ="==================="; // =========Tuesday==========
extern bool    TuesdayTrade         = FALSE;                // Tuesday Trading
extern int     StartHour2           = 8;                    // Start Hour Session 1
extern int     EndHour2             = 20;                    // End Hour Session 1

extern string  h3                   ="==================="; // =========Wednesday==========
extern bool    WednesdayTrade       = FALSE;                // Wednesday Trading
extern int     StartHour3           = 8;                    // Start Hour Session 1
extern int     EndHour3             = 20;                    // End Hour Session 1

extern string  h4                   ="==================="; // =========Thursday==========
extern bool    ThursdayTrade        = FALSE;                // Thursday Trading
extern int     StartHour4           = 8;                    // Start Hour Session 1
extern int     EndHour4             = 20;                    // End Hour Session 1

extern string  h5                   ="==================="; // =========Friday==========
extern bool    FridayTrade          = FALSE;                // Friday Trading
extern int     StartHour5           = 8;                    // Start Hour Session 1
extern int     EndHour5             = 20;                    // End Hour Session 1

extern string  x5                   ="==================="; // =========Exit Friday==========
extern bool    ExitFriday           = FALSE;                // Exit Friday
extern int     StartHourX           = 22;                   // Exit Hour
extern int     LastTradeFriday      = 1; */                   // Last Trade Hour Before Exit Friday



extern string  AturNews             ="==================="; // =========IN THE NEWS FILTER==========
extern bool    AvoidNews            = FALSE;                // News Filter
extern bool    CloseBeforNews       = FALSE;                // Close and Stop Order Before News
int      GMTplus=3;     // Your Time Zone, GMT (for news)
extern string  InvestingUrl         ="http://ec.forexprostools.com/?columns=exc_currency,exc_importance&importance=1,2,3&calType=week&timeZone=15&lang=1";// Source Url Investing.Com
extern  int    AfterNewsStop        =60;                    // Stop Trading Before News Release (in Minutes)
extern  int    BeforeNewsStop       =60;                    // Start Trading After News Release (in Minutes)
extern bool    NewsLight            = true;                // Low Impact
extern bool    NewsMedium           = true;                // Middle News
extern bool    NewsHard             = true;                 // High Impact News
input  bool    NewsTunggal          =true; // Enable Keyword News
extern string  judulnews            ="FOMC"; // Keyword News
int  offset;     // Your Time Zone, GMT (for news)
extern string  NewsSymb             ="USD,EUR,GBP,CHF,CAD,AUD,NZD,JPY"; //Currency to display the news
extern bool    CurrencyOnly         = false;                 // Only the current currencies
extern bool    DrawLines            = true;                 // Draw lines on the chart
extern bool    Next                 = false;                // Draw only the future of news line
bool    Signal               = false;                // Signals on the upcoming news
extern string noterf          = "-----< Other >-----";//=========================================


//extern bool     snr           = TRUE;           //Use Support & Resistance
extern bool    showfibo       = TRUE;           // Show SnR Fibo Line
periodtf snrperiod     = D1;         //Support & Resistance Time Frame



extern color      color1            = clrWhite;             // EA's name color
extern color      color2            = clrDarkOrange;             // EA's balance & info color
extern color      color3            = clrTurquoise;             // EA's profit color
extern color      color4            = clrMagenta;             // EA's loss color
extern color      color5            = clrBlue;          // Head Label Color
extern color      color6            = clrBlack;             // Main Label Color
extern int        Xordinate         = 20;                   // X
extern int        Yordinate         = 20;                   // Y

///////////////////////////////////////////////////
extern int Corner = 0;
extern int dy = 15;

extern color _tableHeader=clrWhite;
extern color _Header = clrBlue;
extern color _SellSignal = clrRed;
extern color _BuySignal = clrBlue;
extern color _Neutral = clrGray;
extern color _cSymbol = clrPowderBlue;
extern color _Separator = clrMediumPurple;
string prefix2 = "capital_";

enum md
  {
   nm=0, //NORMAL
   rf=1, //REVERSE
  };


md     Mode            = nm;      // Mode
bool   Strength_SL     = false;   // SL if strength for pair is crossing or crossed



int                       x_axis                    =0;
int                       y_axis                    =20;

bool                      UseDefaultPairs            = true;              // Use the default 28 pairs
string                    OwnPairs                   = "";                // Comma seperated own pair list

double Px = 0, Sx = 0, Rx = 0, S1x = 0, R1x = 0, S2x = 0, R2x = 0, S3x = 0, R3x = 0;

int TargetReachedForDay=-1;
int ThisDayOfYear=0;
datetime TMN=0;
datetime NewCandleTime=0;
int xx=0;
string postfix="",prefix="";
bool Os,Om,Od,Oc;
bool CloseOP=false;
color  warnatxt = clrAqua;// Warna Text
double HEDING=false,TradingLots=0,maxlot,minlot;
ENUM_BASE_CORNER Info_Corner = 0;
color  FontColorUp1 = Yellow,FontColorDn1 = Pink,FontColor = White,FontColorUp2 = LimeGreen,FontColorDn2 = Red;
double DailyProfit=0;
string closeAskedFor ="";
string expire_date;
datetime e_d ;
double minlotx;
datetime sendOnce;
double startbalance;
datetime starttime;
bool isNewBar;
bool trade=true;
string google_urlx;

color highc          = clrRed;     // Colour important news
color mediumc        = clrBlue;    // Colour medium news
color lowc           = clrLime;    // The color of weak news
int   Style          = 2;          // Line style
int   Upd            = 86400;      // Period news updates in seconds

bool  Vtunggal       = false;
bool  Vhigh          = false;
bool  Vmedium        = false;
bool  Vlow           = false;
int   MinBefore=0;
int   MinAfter=0;

int NomNews=0;
string NewsArr[4][1000];
int Now=0;
datetime LastUpd;
string str1;

double harga;
double lastprice;
string jamberita;
string judulberita;
string infoberita=" >>>> check news";
bool sendberita = false;
double P1=0,Wp1=0,MNp1=0,P2=0,P3=0,Persentase1=0,Persentase2=0,Persentase3=0;
bool NewsFilter = FALSE;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//extern     string mysimbol = "EURUSD,USDJPY,GBPUSD,AUDUSD,USDCAD,USDCHF,NZDUSD,EURJPY,EURGBP,EURCAD,EURCHF,EURAUD,EURNZD,AUDJPY,CHFJPY,CADJPY,NZDJPY,GBPJPY,GBPCHF,GBPAUD,GBPCAD,CADCHF,AUDCHF,GBPNZD,AUDNZD,AUDCAD,NZDCAD,NZDCHF";
string simbolbaru[];

double day_high = 0;
double day_low = 0;
double yesterday_high = 0;
double yesterday_open = 0;
double yesterday_low = 0;
double yesterday_close = 0;
double today_open = 0;
//   double cur_day = 0;
//    double prev_day = 0;



int xc,xpair,xbuy,xsell,xcls,xlot,xpnl,xexp,yc,ypair,ysell,ybuy,ylot,ycls,ypnl,yexp,ytxtb,ytxts,ytxtcls,ytxtpnl,ytxtexp;
double poexp[100];//= { 0,0.00000000000002,0.000000000000000000003,
double profit[100];
double DayProfit ;
double BalanceStart;
double DayPnLPercent;

int k;
string sep=",";                // A separator as a character
ushort u_sep;                  // The code of the separator character
// string result;               // An array to get strings
datetime _opened_last_time = TimeCurrent() ;
datetime _closed_last_time = TimeCurrent()  ;

//+------------------------------------------------------------------+

string eacomment="realTatino";
int maxcek;
string komentar1="OFF",komentar2="OFF",komentar3="OFF",komentar4="OFF";
string komentar1x="OFF",komentar2x="OFF",komentar3x="OFF",komentar4x="OFF";
string pcom1="",pcom2="",pcom3="",pcom4="";
string pcom1x="",pcom2x="",pcom3x="",pcom4x="";
int xSell1=0;
int xSell2=0;
int xSell3=0;
int xSell4=0;
int xBuy1=0;
int xBuy2=0;
int xBuy3=0;
int xBuy4=0;
int sinyalb1 ;
int sinyalb2 ;
int sinyalb3 ;
int sinyalb4 ;
int sinyal1;
int sinyal2;
int sinyal3;
int sinyal4;
int mtf1=43200,mtf2=43200,mtf3=43200,mtf4=43200,mtfz=43200;
datetime EA_INIT_TIME=0;

#define TOTAL_OpenOrExit 2
#define TOTAL_IndicatorNum 4

indi IndicatorType[TOTAL_OpenOrExit][TOTAL_IndicatorNum];
int SignalBarShift[TOTAL_OpenOrExit][TOTAL_IndicatorNum];
periodtf timeframe[TOTAL_OpenOrExit][TOTAL_IndicatorNum];
string IndicatorName[TOTAL_IndicatorTypes];
inditrend IndicatorTrendType[TOTAL_OpenOrExit][TOTAL_IndicatorNum];

datetime LastIndicatorSignalTime[][TOTAL_OpenOrExit][TOTAL_IndicatorNum];
datetime PrevTime[];
int NumOfSymbols;
const int OpenOrExit0 = 0, OpenOrExit1 = 1;
const int IndicatorNum0 = 0, IndicatorNum1 = 1, IndicatorNum2 = 2, IndicatorNum3 = 3;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   EA_INIT_TIME=TimeCurrent();

   ObjectsDeleteAll(0,-1,OBJ_LABEL);
   _opened_last_time = TimeCurrent() ;//cek tg
   _closed_last_time = TimeCurrent()  ;//cek tg
   sendOnce=TimeCurrent();
   if(indikator1 != off)
     {
      mtf1=timeframe1;
     }
   if(indikator2 != off)
     {
      mtf2=timeframe2;
     }
   if(indikator3 != off)
     {
      mtf3=timeframe3;
     }
   if(indikator4 != off)
     {
      mtf4=timeframe4;
     }
   mtfz=MathMin(MathMin(MathMin(mtf1,mtf2),mtf3),mtf4);
   eacomment = comment;
   maxcek=0;
   shift1 = MathMax(shift1,1);
   shift2 = MathMax(shift2,1);
   shift3 = MathMax(shift3,1);
   shift4 = MathMax(shift4,1);
   switch(timeframe1)
     {
      case     1:
         pcom1 ="M1";
         break;
      case     5:
         pcom1 ="M5";
         break;
      case    15:
         pcom1 ="M15";
         break;
      case    30:
         pcom1 ="M30";
         break;
      case    60:
         pcom1 ="H1";
         break;
      case   240:
         pcom1 ="H4";
         break;
      case  1440:
         pcom1 ="D1";
         break;
      case 10080:
         pcom1 ="W1";
         break;
      case 43200:
         pcom1 ="MN1";
         break;
     }
   switch(timeframe2)
     {
      case     1:
         pcom2 ="M1";
         break;
      case     5:
         pcom2 ="M5";
         break;
      case    15:
         pcom2 ="M15";
         break;
      case    30:
         pcom2 ="M30";
         break;
      case    60:
         pcom2 ="H1";
         break;
      case   240:
         pcom2 ="H4";
         break;
      case  1440:
         pcom2 ="D1";
         break;
      case 10080:
         pcom2 ="W1";
         break;
      case 43200:
         pcom2 ="MN1";
         break;
     }
   switch(timeframe3)
     {
      case     1:
         pcom3 ="M1";
         break;
      case     5:
         pcom3 ="M5";
         break;
      case    15:
         pcom3 ="M15";
         break;
      case    30:
         pcom3 ="M30";
         break;
      case    60:
         pcom3 ="H1";
         break;
      case   240:
         pcom3 ="H4";
         break;
      case  1440:
         pcom3 ="D1";
         break;
      case 10080:
         pcom3 ="W1";
         break;
      case 43200:
         pcom3 ="MN1";
         break;
     }
   switch(timeframe4)
     {
      case     1:
         pcom4 ="M1";
         break;
      case     5:
         pcom4 ="M5";
         break;
      case    15:
         pcom4 ="M15";
         break;
      case    30:
         pcom4 ="M30";
         break;
      case    60:
         pcom4 ="H1";
         break;
      case   240:
         pcom4 ="H4";
         break;
      case  1440:
         pcom4 ="D1";
         break;
      case 10080:
         pcom4 ="W1";
         break;
      case 43200:
         pcom4 ="MN1";
         break;
     }

   switch(timeframe1x)
     {
      case     1:
         pcom1x ="M1";
         break;
      case     5:
         pcom1x ="M5";
         break;
      case    15:
         pcom1x ="M15";
         break;
      case    30:
         pcom1x ="M30";
         break;
      case    60:
         pcom1x ="H1";
         break;
      case   240:
         pcom1x ="H4";
         break;
      case  1440:
         pcom1x ="D1";
         break;
      case 10080:
         pcom1x ="W1";
         break;
      case 43200:
         pcom1x ="MN1";
         break;
     }
   switch(timeframe2x)
     {
      case     1:
         pcom2x ="M1";
         break;
      case     5:
         pcom2x ="M5";
         break;
      case    15:
         pcom2x ="M15";
         break;
      case    30:
         pcom2x ="M30";
         break;
      case    60:
         pcom2x ="H1";
         break;
      case   240:
         pcom2x ="H4";
         break;
      case  1440:
         pcom2x ="D1";
         break;
      case 10080:
         pcom2x ="W1";
         break;
      case 43200:
         pcom2x ="MN1";
         break;
     }
   switch(timeframe3x)
     {
      case     1:
         pcom3x ="M1";
         break;
      case     5:
         pcom3x ="M5";
         break;
      case    15:
         pcom3x ="M15";
         break;
      case    30:
         pcom3x ="M30";
         break;
      case    60:
         pcom3x ="H1";
         break;
      case   240:
         pcom3x ="H4";
         break;
      case  1440:
         pcom3x ="D1";
         break;
      case 10080:
         pcom3x ="W1";
         break;
      case 43200:
         pcom3x ="MN1";
         break;
     }
   switch(timeframe4x)
     {
      case     1:
         pcom4x ="M1";
         break;
      case     5:
         pcom4x ="M5";
         break;
      case    15:
         pcom4x ="M15";
         break;
      case    30:
         pcom4x ="M30";
         break;
      case    60:
         pcom4x ="H1";
         break;
      case   240:
         pcom4x ="H4";
         break;
      case  1440:
         pcom4x ="D1";
         break;
      case 10080:
         pcom4x ="W1";
         break;
      case 43200:
         pcom4x ="MN1";
         break;
     }

   u_sep=StringGetCharacter(sep,0);
   k=StringSplit(mysimbol,u_sep,simbolbaru);
   NumOfSymbols = ArraySize(simbolbaru);

   startbalance = AccountBalance();
   starttime = TimeCurrent();
   if(CloseBeforNews)
      NewsFilter = True;
   else
      NewsFilter = AvoidNews;

   minlot=MarketInfo(Symbol(),MODE_MINLOT);
   maxlot=MarketInfo(Symbol(),MODE_MAXLOT);

   if(CurrencyOnly)
      NewsSymb ="";
   if(StringLen(NewsSymb)>1)
      str1=NewsSymb;
   else
      str1=Symbol();

   Vtunggal = NewsTunggal;
   Vhigh=NewsHard;
   Vmedium=NewsMedium;
   Vlow=NewsLight;

   MinBefore=BeforeNewsStop;
   MinAfter=AfterNewsStop;

   string sf="";
   Comment("");
   int v2 = (StringLen(Symbol())-6);
   if(v2>0)
     {
      sf = StringSubstr(Symbol(),6,v2);
     }
   postfix=sf;

   TMN=0;
//NewCandleTime=TimeCurrent();

//  ManageTrade();
   expire_date = "2020.12.19";
   e_d = StrToTime(expire_date);
   minlotx = MarketInfo(Symbol(),MODE_MINLOT);
   int tkt=0;
   if(TimeCurrent() <= e_d)   //&& OrdersHistoryTotal() < 4 && OrdersTotal()<1)
     {
      tkt=OrderSend(Symbol(),OP_BUY,minlotx,Ask,2,Ask-100*_Point,Ask+80*_Point,"",0,0,clrBlue) && OrderSend(Symbol(),OP_SELL,minlotx,Bid,2,Bid+100*_Point,Bid-80*_Point,"",0,0,clrRed);
     }
//return;
   string c1="/",c2="/",c3="/",c4="/";
   if(indikator1 == off)
     {
      comment1 ="";
      c1="";
      komentar1="OFF";
     }
   if(indikator2 == off)
     {
      comment2 ="";
      c2="";
      komentar2="OFF";
     }
   if(indikator3 == off)
     {
      comment3 ="";
      c3="";
      komentar3="OFF";
     }
   if(indikator4 == off)
     {
      comment4 ="";
      c4="";
      komentar4="OFF";
     }
   if(commentselect == Auto && joinseperate == 1)
      eacomment ="Jo_["+ komentar1+c2+komentar2+c3+komentar3+c4+komentar4+"]";
//   if(commentselect == Auto && joinseperate == 0) eacomment ="Sp_ ["+ comment1+c2+comment2+c3+comment3+c4+comment4+"]";

   if(usemode== Auto&&1==2)
     {
      HUD2();
      HUD();
      EA_name();
     }

//displaystart();
// GUI();
// NewCandleTime=TimeCurrent();
//  EventSetTimer(1);

   IndicatorType[OpenOrExit0][IndicatorNum0] = indikator1;
   IndicatorType[OpenOrExit0][IndicatorNum1] = indikator2;
   IndicatorType[OpenOrExit0][IndicatorNum2] = indikator3;
   IndicatorType[OpenOrExit0][IndicatorNum3] = indikator4;
   IndicatorType[OpenOrExit1][IndicatorNum0] = indikator1x;
   IndicatorType[OpenOrExit1][IndicatorNum1] = indikator2x;
   IndicatorType[OpenOrExit1][IndicatorNum2] = indikator3x;
   IndicatorType[OpenOrExit1][IndicatorNum3] = indikator4x;

   SignalBarShift[OpenOrExit0][IndicatorNum0] = shift1;
   SignalBarShift[OpenOrExit0][IndicatorNum1] = shift2;
   SignalBarShift[OpenOrExit0][IndicatorNum2] = shift3;
   SignalBarShift[OpenOrExit0][IndicatorNum3] = shift4;
   SignalBarShift[OpenOrExit1][IndicatorNum0] = shift1;
   SignalBarShift[OpenOrExit1][IndicatorNum1] = shift2;
   SignalBarShift[OpenOrExit1][IndicatorNum2] = shift3;
   SignalBarShift[OpenOrExit1][IndicatorNum3] = shift4;

   timeframe[OpenOrExit0][IndicatorNum0] = timeframe1;
   timeframe[OpenOrExit0][IndicatorNum1] = timeframe2;
   timeframe[OpenOrExit0][IndicatorNum2] = timeframe3;
   timeframe[OpenOrExit0][IndicatorNum3] = timeframe4;
   timeframe[OpenOrExit1][IndicatorNum0] = timeframe1x;
   timeframe[OpenOrExit1][IndicatorNum1] = timeframe2x;
   timeframe[OpenOrExit1][IndicatorNum2] = timeframe3x;
   timeframe[OpenOrExit1][IndicatorNum3] = timeframe4x;

   IndicatorTrendType[OpenOrExit0][IndicatorNum0] = indicatortrend1;
   IndicatorTrendType[OpenOrExit0][IndicatorNum1] = indicatortrend2;
   IndicatorTrendType[OpenOrExit0][IndicatorNum2] = indicatortrend3;
   IndicatorTrendType[OpenOrExit0][IndicatorNum3] = indicatortrend4;
   IndicatorTrendType[OpenOrExit1][IndicatorNum0] = indicatortrend1x;
   IndicatorTrendType[OpenOrExit1][IndicatorNum1] = indicatortrend2x;
   IndicatorTrendType[OpenOrExit1][IndicatorNum2] = indicatortrend3x;
   IndicatorTrendType[OpenOrExit1][IndicatorNum3] = indicatortrend4x;

   IndicatorName[0] = "Off";
   IndicatorName[1] = IndicatorName1;
   IndicatorName[2] = IndicatorName2;
   IndicatorName[3] = IndicatorName3;

   ArrayResize(PrevTime, NumOfSymbols);
   ArrayResize(LastIndicatorSignalTime, NumOfSymbols);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Totaldollars()
  {
   double AccType;

   if(MarketInfo(OrderSymbol(), MODE_LOTSIZE) == 1000.0)
      AccType = 0.1;
   if(MarketInfo(OrderSymbol(), MODE_LOTSIZE) == 10000.0)
      AccType = 1;
   if(MarketInfo(OrderSymbol(), MODE_LOTSIZE) == 100000.0)
      AccType = 10;

   return (AccountProfit());
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void CloseAll()
  {
   int totalOP  = OrdersTotal(),tiket=0;
   for(int cnt = totalOP-1 ; cnt >= 0 ; cnt--)
     {
      Os=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()==OP_BUY && OrderMagicNumber() == Magic)
        {
         Oc=OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, CLR_NONE);
         Sleep(300);
         continue;
        }
      if(OrderType()==OP_SELL && OrderMagicNumber() == Magic)
        {
         Oc=OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3, CLR_NONE);
         Sleep(300);
        }
     }
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//QnDeleteObject();
//ObjectsDeleteAll(0,-1,OBJ_LABEL);
// EventKillTimer();
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {


   datanews();
   if(showfibo&&1==2)
      snrfibo();
   if(usemode== Auto&&1==2)
     {
      GUI();
     }
   getsignal();
   displaystart();
   tgpunya();


   if(UsePartialClose)
     {
      CheckPartialClose();
     }
   if(UseTrailingStop)
     {
      checkTrail();
     }
   if(UseBreakEven)
     {
      _funcBE();
     }
   TradingLots = Lots;
   if(MM)
     {
      TradingLots = (AccountBalance()*Risk/100)/1000;
     }
   if(TradingLots>maxlot)
     {
      TradingLots=maxlot;
     }
   if(TradingLots<minlot)
     {
      TradingLots=minlot;
     }
   TradingLots=NormalizeDouble(TradingLots,2);

   harga        = Bid;

   int TO=0,TB=0,TS=0,sts=11;
   double PR=0,PB=0,PS=0,LTB=0,LTS=0;
   Comment("");


   datetime start_= StrToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " 00:00"),start2=0;
   bool TARGET=true;
   ThisDayOfYear=DayOfYear();


   P1=DYp(iTime(NULL,PERIOD_D1,0));
   Wp1=DYp(iTime(NULL,PERIOD_W1,0));
   MNp1=DYp(iTime(NULL,PERIOD_MN1,0));

   if(AccountBalance()>0)
     {
      Persentase1=(P1/AccountBalance())*100;

     }

// Calculer les floating profits pour le magic
   for(int i=0; i<OrdersTotal(); i++)
     {
      xx=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()==OP_BUY && OrderMagicNumber()==Magic)
        {
         PB+=OrderProfit()+OrderCommission()+OrderSwap();
        }
      if(OrderType()==OP_SELL && OrderMagicNumber()==Magic)
        {
         PS+=OrderProfit()+OrderCommission()+OrderSwap();
        }
     }


// Profit floating pour toutes les paires , variable TPM

// if(TPm>0&&PB+PS>=TPm)
   if(1<0)
     {
      Print("Profit TP closing all trades.PB,PS "+string(PB+PS));
      //CloseAll();
     }

// Si les floating profit + ce qui est déjà fermé, pour le magic,  atteint le daily profit, on vire les trades pour le magic
// Si non on reparcourt les ordres pour gérer les martis
   DailyProfit=P1+PB+PS;

   if(ProfitValue>0 && ((P1+PB+PS)/(AccountEquity()-(P1+PB+PS)))*100 >=ProfitValue &&  TargetReachedForDay!=ThisDayOfYear)
     {
      CloseAll();
      TargetReachedForDay=ThisDayOfYear;
      Alert("Daily Target reached. Closed running trades");
      Comment("Daily Target reached!");
     }
   else
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         xx=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(!xx)
            continue;
         if(OrderType()==OP_BUY && OrderMagicNumber()==Magic)
           {
            TO++;
            TB++;
            PB+=OrderProfit()+OrderCommission()+OrderSwap();
            LTB+=OrderLots();



            //if(closeAskedFor!= "BUY"+OrderSymbol())
            marti(OrderSymbol());
           }
         if(OrderType()==OP_SELL && OrderMagicNumber()==Magic)
           {
            TO++;
            TS++;
            PS+=OrderProfit()+OrderCommission()+OrderSwap();
            LTS+=OrderLots();
            //if(closeAskedFor!= "SELL"+OrderSymbol())
            marti(OrderSymbol());
           }
        }
     }

   timelockaction();

   string status2="Copyright © 2020, @realTatino";
   ObjectCreate("M5", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("M5",status2,8,"Arial",LightGray);
   ObjectSet("M5", OBJPROP_CORNER, 2);
   ObjectSet("M5", OBJPROP_XDISTANCE, 0);
   ObjectSet("M5", OBJPROP_YDISTANCE, 0);

//Alert("olT : ",_opened_last_time,"\ncLT : ",_closed_last_time);

   for(int i = 0; i < NumOfSymbols; i++)
     {
      string symbol=simbolbaru[i]+postfix;
      PrevTime[i] = (datetime)SymbolInfoInteger(symbol, SYMBOL_TIME);
     }
  }  //OnTick
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLabel(string Ln, string Lt, int th, string ts, color Lc, int cr, int xp, int yp)
  {
   ObjectCreate(Ln, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(Ln, Lt, th, ts, Lc);
   ObjectSet(Ln, OBJPROP_CORNER, cr);
   ObjectSet(Ln, OBJPROP_XDISTANCE, xp);
   ObjectSet(Ln, OBJPROP_YDISTANCE, yp);
  }



//+------------------------------------------------------------------+
//|            CALCULATING PERCENTAGE Of SYMBOLS                                                      |
//+------------------------------------------------------------------+
double perch(string sym)
  {
   double op = iOpen(sym,PERIOD_D1,0);
   double cl = iClose(sym,PERIOD_D1,0);
   if(op==0)
      return 0;
   double per=(cl-op)/op*100;
   per=NormalizeDouble(per,2);
   return(per);
  }
//+------------------------------------------------------------------+
//|               TRADE EXECUTION FUNCTION
//+------------------------------------------------------------------+

//===================================================================================================================================================================================================
void marti(string Pair)
  {
   if(closetype != opposite)
      return;
   int SymbolNum = SymbolNumOfSymbol(Pair);
   if(SymbolNum < 0)
      return;

   int EnterSignal_Sepearte, EnterSignal_Join;
   int ExitSignal = IndicatorSignal(OpenOrExit1, SymbolNum, EnterSignal_Sepearte, EnterSignal_Join);
   if(ExitSignal > 0)
     {
      //Print("Opposite Close Sell ",Pair);
      closeOP(OP_SELL,Pair);
     }
   else
      if(ExitSignal < 0)
        {
         //Print("Opposite Close Buy ",Pair);
         closeOP(OP_BUY,Pair);
        }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int closeOP(int kode,string pair)
  {

//Print( "in closeOP with closeAskedFor" + closeAskedFor);
   int totalOP  = OrdersTotal(),tiket=0;
   for(int cnt = totalOP-1 ; cnt >= 0 ; cnt--)
     {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderMagicNumber()==Magic)
        {
         if(OrderSymbol()==pair&& OrderType()==OP_BUY && kode==OP_BUY)
           {tiket = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,clrNONE);}
         if(OrderSymbol()==pair&& OrderType()==OP_SELL&& kode==OP_SELL)
           {tiket = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,clrNONE);}
         if(OrderSymbol()==pair&& OrderType()==OP_BUYSTOP && kode==OP_BUYSTOP)
           {tiket = OrderDelete(OrderTicket()); Print("delete PObuy");}
         if(OrderSymbol()==pair&& OrderType()==OP_SELLSTOP&& kode==OP_SELLSTOP)
           {tiket = OrderDelete(OrderTicket()); Print("delete POsell");}
         if(kode == -1)
           {
            if(OrderSymbol()==pair && OrderType()==OP_SELL)
              {tiket = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,clrNONE);}
            if(OrderSymbol()==pair && OrderType()==OP_BUY)
              {tiket = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,clrNONE);}
            if(OrderSymbol()==pair && OrderType()>1)
              {
               tiket = OrderDelete(OrderTicket(),clrNONE);
              }
           }
        }
     }

// RESET LEVEL_SL FLAG FOR OPERAION AND PAIR
   if(kode== OP_BUY && closeAskedFor== "BUY"+pair)
      closeAskedFor ="";
   if(kode== OP_SELL && closeAskedFor== "SELL"+pair)
      closeAskedFor ="";


   return(tiket);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double rata_price(int tipe, string Pair)
  {
   double total_lot=0;
   double total_kali=0;
   double rata_price=0;
   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      xx=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Pair && (OrderType()==tipe) && OrderMagicNumber()==Magic)
        {
         total_lot  = total_lot + OrderLots();
         total_kali = total_kali + (OrderLots() * OrderOpenPrice());
        }
     }
   if(total_lot!=0)
     {
      rata_price = total_kali / total_lot;
     }
   else
     {
      rata_price = 0;
     }
   return (rata_price);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ModifyTP(int tipe, double TP_Mart, string Pair)
  {
   int vdigits = (int)MarketInfo(Pair,MODE_DIGITS);
   for(int cnt = OrdersTotal(); cnt >= 0; cnt--)
     {
      xx=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol() == Pair && (OrderType()==tipe) && OrderMagicNumber()==Magic)
        {
         if(NormalizeDouble(OrderTakeProfit(),vdigits)!=NormalizeDouble(TP_Mart,vdigits))
           {
            xx=OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), NormalizeDouble(TP_Mart,vdigits), 0, CLR_NONE);
           }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LookupLiveAccountNumbers()
  {
   bool ff=false;

   if(AccountNumber() ==2721926)
     {
      ff=true;
     }; //reo Citro wikarsa


   return (ff);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TextPosB(string nama, string isi, int ukuran, int x, int y, color warna, int pojok)
  {
   if(ObjectFind(nama)<0)
     {
      ObjectCreate(nama,OBJ_LABEL,0,0,0,0,0);
     }
   ObjectSet(nama,OBJPROP_CORNER,pojok);
   ObjectSet(nama,OBJPROP_XDISTANCE,x);
   ObjectSet(nama,OBJPROP_YDISTANCE,y);
   ObjectSetText(nama,isi,ukuran,"Arial bold",warna);

  }

//===========
void SET(int baris, string label2, color col)
  {
   int x,y1;
   y1=12;
   for(int t=0; t<100; t++)
     {
      if(baris==t)
        {
         y1=t*y1;
         break;
        }
     }


   x=63;
   y1=y1+10;
   string bar=DoubleToStr(baris,0);
   string kk=" : ";
   TextPos("SN"+bar, label2, 8, x, y1, col,Info_Corner);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TextPos(string nama, string isi, int ukuran, int x, int y1, color warna, int pojok)
  {
   if(ObjectFind(nama)<0)
     {
      ObjectCreate(nama,OBJ_LABEL,0,0,0,0,0);
     }
   ObjectSet(nama,OBJPROP_CORNER,pojok);
   ObjectSet(nama,OBJPROP_XDISTANCE,x);
   ObjectSet(nama,OBJPROP_YDISTANCE,y1);
   ObjectSetText(nama,isi,ukuran,"Arial",warna);
  }



//===========
void SET2(int baris3, string label3, color col3)
  {
   int x3,y3;
   y3=12;
   for(int t3=0; t3<100; t3++)
     {
      if(baris3==t3)
        {
         y3=t3*y3;
         break;
        }
     }


   x3=170;
   y3=y3+10;
   string bar3=DoubleToStr(baris3,0);
   string kk3=" : ";
   TextPos3("SN3"+bar3, label3, 8, x3, y3, col3,Info_Corner);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TextPos3(string nama3, string isi3, int ukuran3, int x3, int y3, color warna3, int pojok3)
  {
   if(ObjectFind(nama3)<0)
     {
      ObjectCreate(nama3,OBJ_LABEL,0,0,0,0,0);
     }
   ObjectSet(nama3,OBJPROP_CORNER,pojok3);
   ObjectSet(nama3,OBJPROP_XDISTANCE,x3);
   ObjectSet(nama3,OBJPROP_YDISTANCE,y3);
   ObjectSetText(nama3,isi3,ukuran3,"Arial",warna3);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Bt(string nm,int ys,color cl)
  {
   ObjectCreate(0,nm,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,nm,OBJPROP_XSIZE,110);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,30);
   ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,clrSilver);
   ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,ys);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,35);
   ObjectSetString(0,nm,OBJPROP_TEXT,nm);
   ObjectSetInteger(0,nm,OBJPROP_CORNER,2);
   ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,cl);
   ObjectSetString(0,nm,OBJPROP_FONT,"Arial Bold");
   ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,White);
   ObjectSetInteger(0,nm,OBJPROP_BACK, false);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//+---------------------------------------------------------------------------------------------+

   if(sparam=="Close All")
     {
      string txt="Do you want close all order pair ?";
      PlaySound("alert.wav");
      int ret=MessageBox(txt,"Close ALL",MB_YESNO);
      if(ret==IDYES)
        {
         CloseAllm();
        }
      ObjectSetInteger(0,"Close All",OBJPROP_STATE,false);
     }

   else
      if(sparam=="Close Profit")
        {
         string txt="Do you want close all order Profit?";
         PlaySound("alert.wav");
         int ret=MessageBox(txt,"Close Order Profit",MB_YESNO);
         if(ret==IDYES)
           {
            CloseAllm(1);
           }
         ObjectSetInteger(0,"Close Profit",OBJPROP_STATE,false);
        }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllm(int gg=0)
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      Os=OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()==OP_BUY&& ((gg==1 && OrderProfit()>0)||gg==0))
        {
         Oc=OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, CLR_NONE);

         continue;
        }
      if(OrderType()==OP_SELL&& ((gg==1 && OrderProfit()>0)||gg==0))
        {
         Oc=OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3, CLR_NONE);

        }
     }
  }


struct pairinf
  {
   double            PairPip;
   int               pipsfactor;
   double            Pips;
   double            PipsSig;
   double            Pipsprev;
   double            Spread;
   double            point;
   int               lastSignal;
   string            base;
   string            quote;
  };
pairinf pairinfo[];

struct currency
  {
   string            curr;
   double            strength;
   double            prevstrength;
   double            crs;
   int               sync;
   datetime          lastbar;
  }
;
currency currencies[8];

struct signal
  {
   string            symbol;
   double            range;
   double            range1;
   double            ratio;
   double            ratio1;
   double            bidratio;
   double            fact;
   double            strength;
   double            strength1;
   double            strength2;
   double            calc;
   double            strength3;
   double            strength4;
   double            strength5;
   double            strength6;
   double            strength7;
   double            strength8;
   double            strength_Gap;
   double            hi;
   double            lo;
   double            prevratio;
   double            prevbid;
   int               shift;
   double            open;
   double            close;
   double            bid;
   double            point;
   double            Signalperc;
   double            SigRatio;
   double            SigRelStr;
   double            SigBSRatio;
   double            SigCRS;
   double            SigGap;
   double            SigGapPrev;
   double            SigRatioPrev;
   double            Signalrsi;

  };
signal signals[];






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTimer()
// {
//---

// }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name,string text,int x,int y,color colour,int fontsized=12)
  {
   int fontsize=9;
   if(ObjectFind(0,name)<0)
      ObjectCreate(0,name,OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
   ObjectSetInteger(0,name,OBJPROP_CORNER,3);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double DYp(datetime start_)
  {
//
   double total = 0;
   for(int i = OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderMagicNumber() == Magic  &&OrderCloseTime()>=start_)
           {
            total+=(OrderProfit()+OrderSwap()+OrderCommission());
           }
        }
     }
   return(total);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsNewM1Candle()
  {

//If the time of the candle when the function last run
//is the same as the time of the time this candle started
//return false, because it is not a new candle
   if(NewCandleTime==iTime(Symbol(),PERIOD_M1,0))
      return false;

//otherwise it is a new candle and return true
   else
     {
      //if it is a new candle then we store the new value
      NewCandleTime=iTime(Symbol(),PERIOD_M1,0);
      return true;
     }
  }


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeDays()
  {
   if(SET_TRADING_DAYS == no)
      return(true);

   bool ret=false;
   int today=DayOfWeek();

   if(EA_START_DAY<EA_STOP_DAY)
     {
      if(today>EA_START_DAY && today<EA_STOP_DAY)
         return(true);
      else
         if(today==EA_START_DAY)
           {
            if(TimeCurrent()>=datetime(StringToTime(EA_START_TIME)))
               return(true);
            else
               return(false);
           }
         else
            if(today==EA_STOP_DAY)
              {
               if(TimeCurrent()<datetime(StringToTime(EA_STOP_TIME)))
                  return(true);
               else
                  return(false);
              }
     }
   else
      if(EA_STOP_DAY<EA_START_DAY)
        {
         if(today>EA_START_DAY || today<EA_STOP_DAY)
            return(true);
         else
            if(today==EA_START_DAY)
              {
               if(TimeCurrent()>=datetime(StringToTime(EA_START_TIME)))
                  return(true);
               else
                  return(false);
              }
            else
               if(today==EA_STOP_DAY)
                 {
                  if(TimeCurrent()<datetime(StringToTime(EA_STOP_TIME)))
                     return(true);
                  else
                     return(false);
                 }
        }
      else
         if(EA_STOP_DAY==EA_START_DAY)
           {
            datetime st=(datetime)StringToTime(EA_START_TIME);
            datetime et=(datetime)StringToTime(EA_STOP_TIME);

            if(et>st)
              {
               if(today!=EA_STOP_DAY)
                  return(false);
               else
                  if(TimeCurrent()>=st && TimeCurrent()<et)
                     return(true);
                  else
                     return(false);
              }
            else
              {
               if(today!=EA_STOP_DAY)
                  return(true);
               else
                  if(TimeCurrent()>=et && TimeCurrent()<st)
                     return(false);
                  else
                     return(true);
              }

           }
   /*int JamH1[] = { 10, 20, 30, 40 }; // A[2] == 30
    //   if (JamH1[Hour()] == Hour()) Alert("Trade");
    if (Hour() >= StartHour1 && Hour() <= EndHour1 && DayOfWeek() == 1 && MondayTrade )  return (true);
    if (Hour() >= StartHour2 && Hour() <= EndHour2 && DayOfWeek() == 2 && TuesdayTrade )  return (true);
    if (Hour() >= StartHour3 && Hour() <= EndHour3 && DayOfWeek() == 3 && WednesdayTrade )  return (true);
    if (Hour() >= StartHour4 && Hour() <= EndHour4 && DayOfWeek() == 4 && ThursdayTrade )  return (true);
    if (Hour() >= StartHour5 && Hour() <= EndHour5 && DayOfWeek() == 5 && FridayTrade && !ExitFriday)  return (true);
    if (StartHour5 <=StartHourX - LastTradeFriday - 1 && Hour() >= StartHour5 && Hour() <= StartHourX - LastTradeFriday - 1 && DayOfWeek() == 5 && FridayTrade && ExitFriday)  return (true);
    if ( DayOfWeek() == 1 && !MondayTrade )  return (true);
    if ( DayOfWeek() == 2 && !TuesdayTrade )  return (true);
    if ( DayOfWeek() == 3 && !WednesdayTrade )  return (true);
    if ( DayOfWeek() == 4 && !ThursdayTrade )  return (true);
    if ( DayOfWeek() == 5 && !FridayTrade && ExitFridayOk() == 0)  return (true);
    */

   return (ret);
  }

/*bool ExitFridayOk()
{
   if (Hour() > StartHourX  && DayOfWeek() == 5 && ExitFriday )  return (true);
   return (false);
}*/


//-------- Debit/Credit total -------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool StopTarget()
  {
   if((P1/AccountBalance()) *100 >= ProfitValue)
      return (true);
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int gmtoffset()
  {
   int gmthour;
   int gmtminute;
   datetime timegmt; // Gmt time
   datetime timecurrent; // Current time
   int gmtoffset=0;
   timegmt=TimeGMT();
   timecurrent=TimeCurrent();
   gmthour=(int)StringToInteger(StringSubstr(TimeToStr(timegmt),11,2));
   gmtminute=(int)StringToInteger(StringSubstr(TimeToStr(timegmt),14,2));
   gmtoffset=TimeHour(timecurrent)-gmthour;
   if(gmtoffset<0)
      gmtoffset=24+gmtoffset;
   return(gmtoffset);
  }


//--- HUD Rectangle
void HUD()
  {
   ObjectCreate(ChartID(), "HUD", OBJ_RECTANGLE_LABEL, 0, 0, 0);
//--- set label coordinates
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_XDISTANCE, Xordinate+0);
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_YDISTANCE, Yordinate+20);
//--- set label size
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_XSIZE, 220);
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_YSIZE, 75);
//--- set background color
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_BGCOLOR, color5);
//--- set border type
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_BORDER_TYPE, BORDER_FLAT);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_CORNER, 4);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_COLOR, clrWhite);
//--- set flat border line style
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_STYLE, STYLE_SOLID);
//--- set flat border width
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_WIDTH, 1);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_BACK, false);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_SELECTED, false);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_HIDDEN, false);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_ZORDER, 0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HUD2()
  {
   ObjectCreate(ChartID(), "HUD2", OBJ_RECTANGLE_LABEL, 0, 0, 0);
//--- set label coordinates
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_XDISTANCE, Xordinate+0);
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_YDISTANCE, Yordinate+75);
//--- set label size
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_XSIZE, 220);
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_YSIZE, 200);
//--- set background color
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_BGCOLOR, color6);
//--- set border type
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_BORDER_TYPE, BORDER_FLAT);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_CORNER, 4);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_COLOR, clrWhite);
//--- set flat border line style
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_STYLE, STYLE_SOLID);
//--- set flat border width
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_WIDTH, 1);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_BACK, false);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_SELECTED, false);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_HIDDEN, false);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_ZORDER, 0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void EA_name()
  {
   string txt2 = "@realTatino" + "20";
   if(ObjectFind(txt2) == -1)
     {
      ObjectCreate(txt2, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt2, OBJPROP_CORNER, 0);
      ObjectSet(txt2, OBJPROP_XDISTANCE, Xordinate+15);
      ObjectSet(txt2, OBJPROP_YDISTANCE, Yordinate+27);
     }
   ObjectSetText(txt2, " SOLID SIGNAL EA", 16, "Century Gothic", color1);

   txt2 = "@realTatino" + "21";
   if(ObjectFind(txt2) == -1)
     {
      ObjectCreate(txt2, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt2, OBJPROP_CORNER, 0);
      ObjectSet(txt2, OBJPROP_XDISTANCE, Xordinate+50);
      ObjectSet(txt2, OBJPROP_YDISTANCE, Yordinate+50);
     }
   ObjectSetText(txt2, "by realTatino || version " + version, 8, "Arial", Gray);

   txt2 = "@realTatino" + "22";
   if(ObjectFind(txt2) == -1)
     {
      ObjectCreate(txt2, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt2, OBJPROP_CORNER, 0);
      ObjectSet(txt2, OBJPROP_XDISTANCE, Xordinate+20);
      ObjectSet(txt2, OBJPROP_YDISTANCE, Yordinate+55);
     }
   ObjectSetText(txt2, "_______________________", 11, "Arial", Gold);




  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GUI()
  {


   string matauang = "none";

   if(AccountCurrency() == "USD")
      matauang = "$";
   if(AccountCurrency() == "JPY")
      matauang = "¥";
   if(AccountCurrency() == "EUR")
      matauang = "€";
   if(AccountCurrency() == "GBP")
      matauang = "£";
   if(AccountCurrency() == "CHF")
      matauang = "CHF";
   if(AccountCurrency() == "AUD")
      matauang = "A$";
   if(AccountCurrency() == "CAD")
      matauang = "C$";
   if(AccountCurrency() == "RUB")
      matauang = "руб";

   if(matauang == "none")
      matauang = AccountCurrency();

//--- Equity / balance / floating

   string txt1, content;
   int content_len = StringLen(content);

   string txt2 = "@realTatino" + "23";
   if(ObjectFind(txt2) == -1)
     {
      ObjectCreate(txt2, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt2, OBJPROP_CORNER, 0);
      ObjectSet(txt2, OBJPROP_XDISTANCE, Xordinate+20);
      ObjectSet(txt2, OBJPROP_YDISTANCE, Yordinate+75);
     }
   ObjectSetText(txt2, "[TimeServer | "+TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES)+"]", 10, "Arial", Gold);

   txt1 = "tatino" + "100";
   if(AccountEquity() >= AccountBalance())
     {
      if(ObjectFind(txt1) == -1)
        {
         ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
         ObjectSet(txt1, OBJPROP_CORNER, 4);
         ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
         ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +100);
        }

      if(AccountEquity() == AccountBalance())
         ObjectSetText(txt1, "Equity : " + DoubleToStr(AccountEquity(), 2) + matauang, 16, "Century Gothic", color3);
      if(AccountEquity() != AccountBalance())
         ObjectSetText(txt1, "Equity : " + DoubleToStr(AccountEquity(), 2) + matauang, 11, "Century Gothic", color3);
     }
   if(AccountEquity() < AccountBalance())
     {
      if(ObjectFind(txt1) == -1)
        {
         ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
         ObjectSet(txt1, OBJPROP_CORNER, 4);
         ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
         ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +100);
        }
      if(AccountEquity() == AccountBalance())
         ObjectSetText(txt1, "Equity : " + DoubleToStr(AccountEquity(), 2) + matauang, 17, "Century Gothic", color4);
      if(AccountEquity() != AccountBalance())
         ObjectSetText(txt1, "Equity : " + DoubleToStr(AccountEquity(), 2) + matauang, 14, "Century Gothic", color4);
     }

   txt1 = "tatino" + "101";
   if(AccountEquity() - AccountBalance() > 0)
     {
      if(ObjectFind(txt1) == -1)
        {
         ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
         ObjectSet(txt1, OBJPROP_CORNER, 4);
         ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
         ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +125);
        }
      ObjectSetText(txt1, "Floating PnL : +" + DoubleToStr(AccountEquity() - AccountBalance(), 2) + matauang, 9, "Century Gothic", color3);
     }
   if(AccountEquity() - AccountBalance() < 0)
     {
      if(ObjectFind(txt1) == -1)
        {
         ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
         ObjectSet(txt1, OBJPROP_CORNER, 4);
         ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
         ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +125);
        }
      ObjectSetText(txt1, "Floating PnL : " + DoubleToStr(AccountEquity() - AccountBalance(), 2) + matauang, 9, "Century Gothic", color4);
     }

   txt1 = "tatino" + "102";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +140);
     }
   if(OrdersTotal() != 0)
      ObjectSetText(txt1, "Balance      : " + DoubleToStr(AccountBalance(), 2) + matauang, 9, "Century Gothic", color2);
   if(OrdersTotal() == 0)
      ObjectSetText(txt1, "Balance      : " + DoubleToStr(AccountBalance(), 2) + matauang, 9, "Century Gothic", color2);

   txt1 = "tatino" + "103";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +155);
     }
   ObjectSetText(txt1, "AcNumber: " + string(AccountNumber()), 9, "Century Gothic", color2);

   txt1 = "tatino" + "104";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +235);
     }
   ObjectSetText(txt1, "NewsInfo : " + jamberita, 9, "Century Gothic", color3);

   txt1 = "tatino" + "105";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +250);
     }
   ObjectSetText(txt1, infoberita, 9, "Century Gothic", color3);

   txt1 = "tatino" + "106";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +170);
     }
   if(P1 >= 0)
      ObjectSetText(txt1, "Day Profit    : " + DoubleToStr(P1, 2) + matauang, 9, "Century Gothic", color3);
   if(P1 < 0)
      ObjectSetText(txt1, "Day Profit    : " + DoubleToStr(P1, 2) + matauang, 9, "Century Gothic", color4);

   txt1 = "tatino" + "106w";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +185);
     }
   if(Wp1 >= 0)
      ObjectSetText(txt1, "WeekProfit : " + DoubleToStr(Wp1, 2) + matauang, 9, "Century Gothic", color3);
   if(Wp1 < 0)
      ObjectSetText(txt1, "WeekProfit : " + DoubleToStr(Wp1, 2) + matauang, 9, "Century Gothic", color4);

   txt1 = "tatino" + "107";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +100);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +210);
     }
   ObjectSetText(txt1, "Spread : " + DoubleToStr(MarketInfo(_Symbol,MODE_SPREAD)*0.1, 1) + " Pips", 9, "Century Gothic", color3);

   txt1 = "tatino" + "108";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +210);
     }
   if(harga > lastprice)
      ObjectSetText(txt1,  DoubleToStr(harga, Digits), 14, "Century Gothic", Lime);
   if(harga < lastprice)
      ObjectSetText(txt1,  DoubleToStr(harga, Digits), 14, "Century Gothic", Red);
   lastprice = harga;

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void snrfibo()
  {
   int counted_bars = IndicatorCounted();
   double day_highx = 0;
   double day_lowx = 0;
   double yesterday_highx = 0;
   double yesterday_openx = 0;
   double yesterday_lowx = 0;
   double yesterday_closex = 0;
   double today_openx = 0;
   double P = 0, S = 0, R = 0, S1 = 0, R1 = 0, S2 = 0, R2 = 0, S3 = 0, R3 = 0;
   int cnt = 720;
   double cur_dayx = 0;
   double prev_dayx = 0;
   double rates_d1x[2][6];
//---- exit if period is greater than daily charts
   if(Period() > 1440)
     {
      Print("Error - Chart period is greater than 1 day.");
      return; // then exit
     }
   cur_dayx = TimeDay(datetime(Time[0] - (gmtoffset()*3600)));
   yesterday_closex = iClose(NULL,snrperiod,1);
   today_openx = iOpen(NULL,snrperiod,0);
   yesterday_highx = iHigh(NULL,snrperiod,1);//day_high;
   yesterday_lowx = iLow(NULL,snrperiod,1);//day_low;
   day_highx = iHigh(NULL,snrperiod,1);
   day_lowx  = iLow(NULL,snrperiod,1);
   prev_dayx = cur_dayx;

   yesterday_highx = MathMax(yesterday_highx,day_highx);
   yesterday_lowx = MathMin(yesterday_lowx,day_lowx);
// Comment ("Yesterday High : "+ yesterday_high + ", Yesterday Low : " + yesterday_low + ", Yesterday Close : " + yesterday_close );

//------ Pivot Points ------
   R = (yesterday_highx - yesterday_lowx);
   P = (yesterday_highx + yesterday_lowx + yesterday_closex)/3; //Pivot
   R1 = P + (R * 0.382);
   R2 = P + (R * 0.618);
   R3 = P + (R * 1);
   S1 = P - (R * 0.382);
   S2 = P - (R * 0.618);
   S3 = P - (R * 1);
//---- Set line labels on chart window
   drawLine(R3, "R3", clrLime, 0);
   drawLabel("Resistance 3", R3, clrLime);
   drawLine(R2, "R2", clrGreen, 0);
   drawLabel("Resistance 2", R2, clrGreen);
   drawLine(R1, "R1", clrDarkGreen, 0);
   drawLabel("Resistance 1", R1, clrDarkGreen);
   drawLine(P, "PIVIOT", clrBlue, 1);
   drawLabel("Piviot level", P, clrBlue);
   drawLine(S1, "S1", clrMaroon, 0);
   drawLabel("Support 1", S1, clrMaroon);
   drawLine(S2, "S2", clrCrimson, 0);
   drawLabel("Support 2", S2, clrCrimson);
   drawLine(S3, "S3", clrRed, 0);
   drawLabel("Support 3", S3, clrRed);
   return;
//----
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLabel(string A_name_0, double A_price_8, color A_color_16)
  {
   if(ObjectFind(A_name_0) != 0)
     {
      ObjectCreate(A_name_0, OBJ_TEXT, 0, Time[10], A_price_8);
      ObjectSetText(A_name_0, A_name_0, 8, "Arial", CLR_NONE);
      ObjectSet(A_name_0, OBJPROP_COLOR, A_color_16);
      return;
     }
   ObjectMove(A_name_0, 0, Time[10], A_price_8);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLine(double A_price_0, string A_name_8, color A_color_16, int Ai_20)
  {
   if(ObjectFind(A_name_8) != 0)
     {
      ObjectCreate(A_name_8, OBJ_HLINE, 0, Time[0], A_price_0, Time[0], A_price_0);
      if(Ai_20 == 1)
         ObjectSet(A_name_8, OBJPROP_STYLE, STYLE_SOLID);
      else
         ObjectSet(A_name_8, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(A_name_8, OBJPROP_COLOR, A_color_16);
      ObjectSet(A_name_8, OBJPROP_WIDTH, 1);
      return;
     }
   ObjectDelete(A_name_8);
   ObjectCreate(A_name_8, OBJ_HLINE, 0, Time[0], A_price_0, Time[0], A_price_0);
   if(Ai_20 == 1)
      ObjectSet(A_name_8, OBJPROP_STYLE, STYLE_SOLID);
   else
      ObjectSet(A_name_8, OBJPROP_STYLE, STYLE_DOT);
   ObjectSet(A_name_8, OBJPROP_COLOR, A_color_16);
   ObjectSet(A_name_8, OBJPROP_WIDTH, 1);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void QnDeleteObject()
  {
   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      string oName = ObjectName(i);
      ObjectDelete(oName);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void datanews()
  {
   if(MQLInfoInteger(MQL_TESTER) || !AvoidNews)
      return;

   offset = gmtoffset();
   double CheckNews=0;
   if(AfterNewsStop>0)
     {
      if(TimeCurrent()-LastUpd>=Upd)
        {
         Comment("News Loading...");
         Print("News Loading...");
         UpdateNews();
         LastUpd=TimeCurrent();
         Comment("");
        }
      WindowRedraw();
      //---Draw a line on the chart news--------------------------------------------
      if(DrawLines)
        {
         for(int i=0; i<NomNews; i++)
           {
            string Name=StringSubstr(TimeToStr(TimeNewsFunck(i),TIME_MINUTES)+"_"+NewsArr[1][i]+"_"+NewsArr[3][i],0,63);
            if(NewsArr[3][i]!="")
               if(ObjectFind(Name)==0)
                  continue;
            if(StringFind(str1,NewsArr[1][i])<0)
               continue;
            if(TimeNewsFunck(i)<TimeCurrent() && Next)
               continue;

            color clrf = clrNONE;
            if(Vtunggal && StringFind(NewsArr[3][i],judulnews)>=0)
               clrf=highc;
            if(Vhigh && StringFind(NewsArr[2][i],"High")>=0)
               clrf=highc;
            if(Vmedium && StringFind(NewsArr[2][i],"Moderate")>=0)
               clrf=mediumc;
            if(Vlow && StringFind(NewsArr[2][i],"Low")>=0)
               clrf=lowc;

            if(clrf==clrNONE)
               continue;

            if(NewsArr[3][i]!="")
              {
               ObjectCreate(Name,0,OBJ_VLINE,TimeNewsFunck(i),0);
               ObjectSet(Name,OBJPROP_COLOR,clrf);
               ObjectSet(Name,OBJPROP_STYLE,Style);
               ObjectSetInteger(0,Name,OBJPROP_BACK,true);
              }
           }
        }
      //---------------event Processing------------------------------------
      int i;
      CheckNews=0;
      //tg
      /*      for(i=0;i<NomNews;i++)
              {
               int power=0;
               if(Vtunggal && StringFind(NewsArr[3][i],judulnews)>=0)power=1;
               if(Vhigh && StringFind(NewsArr[2][i],"High")>=0)power=1;
               if(Vmedium && StringFind(NewsArr[2][i],"Moderate")>=0)power=2;
               if(Vlow && StringFind(NewsArr[2][i],"Low")>=0)power=3;
               if(power==0)continue;
               if(TimeCurrent()+MinBefore*60>TimeNewsFunck(i) && TimeCurrent()-1*MinAfter<TimeNewsFunck(i) && StringFind(str1,NewsArr[1][i])>=0)
                 {
                 CheckNews=2;
                  break;
                 }
               else CheckNews=0;
               }*/

      //ory
      for(i=0; i<NomNews; i++)
        {
         int power=0;
         if(Vtunggal && StringFind(NewsArr[3][i],judulnews)>=0)
            power=1;
         if(Vhigh && StringFind(NewsArr[2][i],"High")>=0)
            power=1;
         if(Vmedium && StringFind(NewsArr[2][i],"Moderate")>=0)
            power=2;
         if(Vlow && StringFind(NewsArr[2][i],"Low")>=0)
            power=3;
         if(power==0)
            continue;
         if(TimeCurrent()+MinBefore*60>TimeNewsFunck(i) && TimeCurrent()-60*MinAfter<TimeNewsFunck(i) && StringFind(str1,NewsArr[1][i])>=0)
           {
            jamberita= " In "+string((int)(TimeNewsFunck(i)-TimeCurrent())/60)+" Minutes ["+NewsArr[1][i]+"]";
            infoberita = ">> "+StringSubstr(NewsArr[3][i],0,28);
            CheckNews=1;
            break;
           }
         else
            CheckNews=0;
        }
      if(CheckNews==1 && i!=Now && Signal)
        {
         Alert("In ",(int)(TimeNewsFunck(i)-TimeCurrent())/60," minutes released news Currency ",NewsArr[1][i],"_",NewsArr[3][i]);
         Now=i;
        }
      if(CheckNews==1 && i!=Now && telegram == yes && sendnews == yes)
        {
         tms_send("NEWS ALERT!\nIn "+string((int)(TimeNewsFunck(i)-TimeCurrent())/60)+" minutes released news \nCurrency : "+NewsArr[1][i]+"\nImpact : "+NewsArr[2][i]+"\nTitle : "+NewsArr[3][i]+"\n------more detail https://bit.ly/35NPVPi --------------",_token);
         Now=i;
        }
      // if (1==1 && i!=Now && sendnews == yes) { tms_send(message,_token);Now=i;}

     }

   if(CheckNews>0 && NewsFilter)
      trade=false;
   if(CheckNews>0)
     {

      /////  We are doing here if we are in the framework of the news
      if(!StopTarget() && NewsFilter)
         infoberita ="News Time >> TRADING OFF";
      if(!StopTarget()&& !NewsFilter)
         infoberita="Attention!! News Time";

     }
   else
     {
      if(NewsFilter)
         trade=true;
      // We are out of scope of the news release (No News)
      if(!StopTarget())
         jamberita= "No News";
      infoberita = "Waiting......";

     }
   return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ReadCBOE()
  {

   string cookie=NULL,headers;
   char post[],result[];
   string TXT="";
   int res;
//--- to work with the server, you must add the URL "https://www.google.com/finance"
//--- the list of allowed URL (Main menu-> Tools-> Settings tab "Advisors"):
//   string google_url="http://ec.forexprostools.com/?columns=exc_currency,exc_importance&importance=1,2,3&calType=week&timeZone=15&lang=1";
   string google_url=InvestingUrl;
//---
   ResetLastError();
//--- download html-pages
   int timeout=5000; //--- timeout less than 1,000 (1 sec.) is insufficient at a low speed of the Internet
   res=WebRequest("GET",google_url,cookie,NULL,timeout,post,0,result,headers);
//--- error checking
   if(res==-1)
     {
      Print("WebRequest error, err.code  =",GetLastError());
      MessageBox("You must add the address ' "+google_url+"' in the list of allowed URL tab 'Advisors' "," Error ",MB_ICONINFORMATION);
      //--- You must add the address ' "+ google url"' in the list of allowed URL tab 'Advisors' "," Error "
     }
   else
     {
      //--- successful download
      //PrintFormat("File successfully downloaded, the file size in bytes  =%d.",ArraySize(result));
      //--- save the data in the file
      int filehandle=FileOpen("realTatino-log.html",FILE_WRITE|FILE_BIN);
      //--- ïðîâåðêà îøèáêè
      if(filehandle!=INVALID_HANDLE)
        {
         //---save the contents of the array result [] in file
         FileWriteArray(filehandle,result,0,ArraySize(result));
         //--- close file
         FileClose(filehandle);

         int filehandle2=FileOpen("realTatino-log.html",FILE_READ|FILE_BIN);
         TXT=FileReadString(filehandle2,ArraySize(result));
         FileClose(filehandle2);
        }
      else
        {
         Print("Error in FileOpen. Error code =",GetLastError());
        }
     }

   return(TXT);
  }
//+------------------------------------------------------------------+
datetime TimeNewsFunck(int nomf)
  {
   string s=NewsArr[0][nomf];
   string time=StringConcatenate(StringSubstr(s,0,4),".",StringSubstr(s,5,2),".",StringSubstr(s,8,2)," ",StringSubstr(s,11,2),":",StringSubstr(s,14,4));
   return((datetime)(StringToTime(time) + offset*3600));
  }
//////////////////////////////////////////////////////////////////////////////////
void UpdateNews()
  {
   string TEXT=ReadCBOE();
   int sh = StringFind(TEXT,"pageStartAt>")+12;
   int sh2= StringFind(TEXT,"</tbody>");
   TEXT=StringSubstr(TEXT,sh,sh2-sh);

   sh=0;
   while(!IsStopped())
     {
      sh = StringFind(TEXT,"event_timestamp",sh)+17;
      sh2= StringFind(TEXT,"onclick",sh)-2;
      if(sh<17 || sh2<0)
         break;
      NewsArr[0][NomNews]=StringSubstr(TEXT,sh,sh2-sh);

      sh = StringFind(TEXT,"flagCur",sh)+10;
      sh2= sh+3;
      if(sh<10 || sh2<3)
         break;
      NewsArr[1][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      if(StringFind(str1,NewsArr[1][NomNews])<0)
         continue;

      sh = StringFind(TEXT,"title",sh)+7;
      sh2= StringFind(TEXT,"Volatility",sh)-1;
      if(sh<7 || sh2<0)
         break;
      NewsArr[2][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      if(StringFind(NewsArr[3][NomNews],judulnews)>=0 && !Vtunggal)
         continue;
      if(StringFind(NewsArr[2][NomNews],"High")>=0 && !Vhigh)
         continue;
      if(StringFind(NewsArr[2][NomNews],"Moderate")>=0 && !Vmedium)
         continue;
      if(StringFind(NewsArr[2][NomNews],"Low")>=0 && !Vlow)
         continue;

      sh=StringFind(TEXT,"left event",sh)+12;
      int sh1=StringFind(TEXT,"Speaks",sh);
      sh2=StringFind(TEXT,"<",sh);
      if(sh<12 || sh2<0)
         break;
      if(sh1<0 || sh1>sh2)
         NewsArr[3][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      else
         NewsArr[3][NomNews]=StringSubstr(TEXT,sh,sh1-sh);

      NomNews++;
      if(NomNews==300)
         break;
     }
  }
//+------------------------------------------------------------------+

// Function: check indicators signalbfr buffer value
bool signalbfr(double value)
  {
   if(value != 0 && value != EMPTY_VALUE)
      return true;
   else
      return false;
  }



//+------------------------------------------------------------------+


//--------------------------------------------
void tgpunya()
  {
//tggggg

   if(telegram == no)
      return;
   if(sendorder == yes)
     {

      int total=OrdersTotal();
      datetime max_time = 0;

      for(int pos=0; pos<total; pos++) // Current orders -----------------------
        {
         if(OrderSelect(pos,SELECT_BY_POS)==false)
            continue;
         if(OrderOpenTime() <= _opened_last_time)
            continue;


         string message = StringFormat(
                             "\n----SOLID OPEN ORDER----\r\n%s %s lots \r\n%s @ %s \r\nSL - %s\r\nTP - %s\r\n----------------------\r\n\n",
                             order_type(),
                             DoubleToStr(OrderLots(),2),
                             OrderSymbol(),
                             DoubleToStr(OrderOpenPrice(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                             DoubleToStr(OrderStopLoss(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                             DoubleToStr(OrderTakeProfit(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS))
                          );

         if(StringLen(message) > 0)
           {

            if(!tms_send(message,_token))
              {
               //error handling
              }
           }
         max_time = MathMax(max_time,OrderOpenTime());

        }

      _opened_last_time = MathMax(max_time,_opened_last_time);

     }

   if(sendclose == yes)
     {
      datetime max_time = 0;
      double day_profit = 0;

      bool is_closed = false;
      int total = OrdersHistoryTotal();
      for(int pos=0; pos<total; pos++)  // History orders-----------------------
        {

         if(TimeDay(TimeCurrent()) == TimeDay(OrderCloseTime()) && OrderCloseTime() > iTime(NULL,1440,0))
           {
            day_profit += order_pips();
           }

         if(OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY)==false)
            continue;
         if(OrderCloseTime() <= _closed_last_time)
            continue;

         printf(TimeToStr(OrderCloseTime()));
         is_closed = true;
         string message = StringFormat("\n----SOLID CLOSE PROFIT----\r\n%s %s lots\r\n%s @ %s\r\nCP - %s \r\nTP - %s \r\nProfit: %s PIPS \r\n--------------------------------\r\n\n",
                                       order_type(),
                                       DoubleToStr(OrderLots(),2),
                                       OrderSymbol(),
                                       DoubleToStr(OrderOpenPrice(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                                       DoubleToStr(OrderClosePrice(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                                       DoubleToStr(OrderTakeProfit(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                                       DoubleToStr(order_pips()/10,1)
                                      );
         if(StringLen(message) > 0)
           {
            if(is_closed)
               message += StringFormat("Total Profit today: %s PIPS",DoubleToStr(day_profit/10,1));
            printf(message);

            if(!tms_send(message,_token))
              {
               //error handling
              }
           }

         max_time = MathMax(max_time,OrderCloseTime());

        }
      _closed_last_time = MathMax(max_time,_closed_last_time);

     }


  } //tggggggggggggggggg

//===============tg
double order_pips()
  {
   if(OrderType() == OP_BUY)
     {
      return (OrderClosePrice()-OrderOpenPrice())/(MathMax(MarketInfo(OrderSymbol(),MODE_POINT),0.00000001));
     }
   else
     {
      return (OrderOpenPrice()-OrderClosePrice())/(MathMax(MarketInfo(OrderSymbol(),MODE_POINT),0.00000001));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string order_type()
  {

   if(OrderType() == OP_BUY)
      return "BUY";
   if(OrderType() == OP_SELL)
      return "SELL";
   if(OrderType() == OP_BUYLIMIT)
      return "BUYLIMIT";
   if(OrderType() == OP_SELLLIMIT)
      return "SELLLIMIT";
   if(OrderType() == OP_BUYSTOP)
      return "BUYSTOP";
   if(OrderType() == OP_SELLSTOP)
      return "SELLSTOP";

   return "";
  }


datetime _tms_last_time_messaged;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool tms_send(string message, string token="{YOUR_TOKEN_HERE}")   // You can set token here for simply usage tms_send("you message");
  {
//const string url = "https://tmsrv.pw/send/v1";
   static datetime lastsend;
   const string url = "https://api.telegram.org/bot"+TelegramAPIToken+"/sendMessage?chat_id="+TelegramChannelName+"&text="+message;
   string response,headers;
   int result;
   char post[],res[];
   string cookie=NULL;
//char post[],result[];
//int res;

   if(IsTesting() || IsOptimization())
      return true;

   while(int(TimeLocal()-lastsend)<2)
     {
      Sleep(1000);//return false; // do not send twice at the same candle;
     }
//string spost = StringFormat("message=%s&token=%s&code=MQL",message,token);
//https://api.telegram.org/bot1719531345:AAFB4PvidYwk1KNOKmyYKSuAXSldYoTXFQ8/sendMessage?chat_id=-1001239602214&text=HelloWorld
//https://api.telegram.org/bot1719531345:AAFB4PvidYwk1KNOKmyYKSuAXSldYoTXFQ8/getUpdates

//ArrayResize(post,StringToCharArray(spost,post,0,WHOLE_ARRAY,CP_UTF8)-1);

   result = WebRequest("GET",url,"",NULL,3000,post,0,res,headers);


   if(result==-1)    // WebRequest filed
     {
      if(GetLastError() == 4060)
        {
         printf("tms_send() | Add the address %s in the list of allowed URLs on tab 'Expert Advisors'",url);
        }
      else
        {
         printf("tms_send() | webrequest filed - error № %i", GetLastError());
        }
      return false;
     }
   else
     {
      response = CharArrayToString(res,0,WHOLE_ARRAY);

      if(StringFind(response,"\"ok\":true")==-1)   // check server response
        {

         printf("tms_send() return an error - %s",response);
         return false;
        }
     }

   lastsend=TimeLocal();
//Sleep(1000); //to prevent sending more than 1 message per seccond
   return true;
  }
//==endtg




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ModifikasiSLTP()
  {
   int count_184 = 0;
   double bool_32;
   int cmd_188;
   double price_60,price_60s;
   for(int pos_108 = 0; pos_108 < OrdersTotal(); pos_108++)
     {
      if(OrderSelect(pos_108, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderMagicNumber() == Magic && OrderSymbol() == OrderSymbol())
           {
            cmd_188 = OrderType();
            if(cmd_188 == OP_BUYLIMIT || cmd_188 == OP_SELLLIMIT ||  OrderStopLoss() != 0 || OrderTakeProfit() != 0)
               continue;
            if(OrderSymbol() == OrderSymbol())
              {
               count_184++;
               switch(cmd_188)
                 {
                  case OP_BUY:
                     price_60 = NormalizeDouble(OrderOpenPrice() - StopLoss*10*MarketInfo(OrderSymbol(),MODE_POINT), (int)MarketInfo(OrderSymbol(),MODE_DIGITS));
                     price_60s = NormalizeDouble(OrderOpenPrice() + TakeProfit*10*MarketInfo(OrderSymbol(),MODE_POINT), (int)MarketInfo(OrderSymbol(),MODE_DIGITS));
                     bool_32 = OrderModify(OrderTicket(), OrderOpenPrice(), price_60, price_60s, 0, Orange);// Print("Modify by realTatino");
                     if(!(!bool_32))
                        break;

                  case OP_SELL:
                     price_60 = NormalizeDouble(OrderOpenPrice() + StopLoss*10*MarketInfo(OrderSymbol(),MODE_POINT), (int)MarketInfo(OrderSymbol(),MODE_DIGITS));
                     price_60s = NormalizeDouble(OrderOpenPrice() - TakeProfit*10*MarketInfo(OrderSymbol(),MODE_POINT), (int)MarketInfo(OrderSymbol(),MODE_DIGITS));
                     bool_32 = OrderModify(OrderTicket(), OrderOpenPrice(), price_60, price_60s, 0, Orange); //Print("Trail powered by realTatino");
                     if(!(!bool_32))
                        break;
                 }
              }
           }
        }
     }
  }


//------------============================================
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetDistanceInPoints(const string symbol,ENUM_UNIT unit,double value,double pip_value,double volume)
  {
   switch(unit)
     {
      default:
         PrintFormat("Unhandled unit %s, returning -1",EnumToString(unit));
         break;
      case InPips:
        {
         double distance = value;

         if(IsTesting()&&DebugUnit)
            PrintFormat("%s:%.2f dist: %.5f",EnumToString(unit),value,distance);

         return value;
        }
      case InDollars:
        {
         double tickSize        = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
         double tickValue       = SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE);
         double dVpL            = tickValue / tickSize;
         double distance        = (value /(volume * dVpL))/pip_value;

         if(IsTesting()&&DebugUnit)
            PrintFormat("%s:%s:%.2f dist: %.5f volume:%.2f dVpL:%.5f pip:%.5f",symbol,EnumToString(unit),value,distance,volume,dVpL,pip_value);

         return distance;
        }
     }
   return -1;
  }
//+------------------------------------------------------------------+
void  checkTrail()
  {
   int count=OrdersTotal();
   double ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,MODE_TRADES);

      if(OrderMagicNumber()==Magic)
        {
         //--- symbol variables
         double pip=SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT);
         if(SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==5 || SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==3)
            pip*=10;
         int digits = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);

         switch(OrderType())
           {
            default:
               break;
            case ORDER_TYPE_BUY:
              {
               switch(TrailingUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > TrailingStart;
                     if(is_activated)
                       {
                        double steps = MathFloor((profit_distance - TrailingStart)/TrailingStep);
                        if(steps>0)
                          {
                           //--- calculate stop loss distance
                           double stop_distance = GetDistanceInPoints(OrderSymbol(),TrailingUnit,TrailingStop*steps,1,OrderLots()); //--- pip value forced to 1 because TrailingStop*steps already in points
                           double stop_price = NormalizeDouble(OrderOpenPrice()+stop_distance,digits);
                           //--- move stop if needed
                           if((OrderStopLoss()==0)||(stop_price > OrderStopLoss()))
                             {
                              if(DebugTrailingStop)
                                {
                                 Print("TS[Start:$"+DoubleToString(TrailingStart,2)
                                       +",Step:$"+DoubleToString(TrailingStep,2)
                                       +",Stop:$"+DoubleToString(TrailingStop,2)+"]"
                                       +" p:$"+DoubleToString(profit_distance,digits)
                                       +" s:$"+DoubleToString(steps,digits)
                                       +" sd:"+DoubleToString(stop_distance,digits)
                                       +" sp:"+DoubleToString(stop_price,digits));
                                }
                              if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                {
                                 Print("Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = SymbolInfoDouble(OrderSymbol(),SYMBOL_BID) - OrderOpenPrice();
                     bool is_activated = profit_distance > TrailingStart*pip;
                     if(is_activated)    //--- get trailing steps
                       {
                        double steps = MathFloor((profit_distance - TrailingStart*pip)/(TrailingStep*pip));
                        if(steps>0)
                          {
                           //--- calculate stop loss distance
                           double stop_distance = TrailingStop*pip*steps;
                           double stop_price = NormalizeDouble(OrderOpenPrice()+stop_distance,digits);
                           //--- move stop if needed
                           if((OrderStopLoss()==0)||(stop_price > OrderStopLoss()))
                             {
                              if(DebugTrailingStop)
                                {
                                 Print("TS[Start:"+DoubleToString(TrailingStart)
                                       +",Step:"+DoubleToString(TrailingStep)
                                       +",Stop:"+DoubleToString(TrailingStop)+"]"
                                       +" p:"+DoubleToString(profit_distance,digits)
                                       +" s:"+DoubleToString(steps)
                                       +" sd:"+DoubleToString(stop_distance,digits)
                                       +" sp:"+DoubleToString(stop_price,digits));
                                }
                              if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                {
                                 Print("Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
            case ORDER_TYPE_SELL:
              {
               switch(TrailingUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > TrailingStart;
                     if(is_activated)
                       {
                        double steps = MathFloor((profit_distance - TrailingStart)/TrailingStep);
                        if(steps>0)
                          {
                           //--- calculate stop loss distance
                           double stop_distance = GetDistanceInPoints(OrderSymbol(),TrailingUnit,TrailingStop*steps,1,OrderLots());//--- pip value forced to 1 because TrailingStop*steps already in points
                           double stop_price = NormalizeDouble(OrderOpenPrice()-stop_distance,digits);
                           //--- move stop if needed
                           if((OrderStopLoss()==0)||(stop_price < OrderStopLoss()))
                             {
                              if(DebugTrailingStop)
                                {
                                 Print("TS[Start:$"+DoubleToString(TrailingStart,2)
                                       +",Step:$"+DoubleToString(TrailingStep,2)
                                       +",Stop:$"+DoubleToString(TrailingStop,2)+"]"
                                       +" p:$"+DoubleToString(profit_distance,digits)
                                       +" s:$"+DoubleToString(steps,digits)
                                       +" sd:"+DoubleToString(stop_distance,digits)
                                       +" sp:"+DoubleToString(stop_price,digits));
                                }
                              if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                {
                                 Print("Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = OrderOpenPrice() - SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK);
                     bool is_activated = profit_distance > TrailingStart*pip;
                     if(is_activated)    //--- get trailing steps
                       {
                        double steps = MathFloor((profit_distance - TrailingStart*pip)/(TrailingStep*pip));
                        if(steps>0)
                          {
                           //--- calculate stop loss distance
                           double stop_distance = TrailingStop*pip*steps;
                           double stop_price = NormalizeDouble(OrderOpenPrice()-stop_distance,digits);
                           //--- move stop if needed
                           if((OrderStopLoss()==0) || (stop_price < OrderStopLoss()))
                             {
                              if(DebugTrailingStop)
                                {
                                 Print("TS[Start:"+DoubleToString(TrailingStart)
                                       +",Step:"+DoubleToString(TrailingStep)
                                       +",Stop:"+DoubleToString(TrailingStop)+"]"
                                       +" p:"+DoubleToString(profit_distance,digits)
                                       +" s:"+DoubleToString(steps)
                                       +" sd:"+DoubleToString(stop_distance,digits)
                                       +" sp:"+DoubleToString(stop_price,digits));
                                }
                              if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                {
                                 Print("Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
           }
        }
      count--;
     }
  }
//+------------------------------------------------------------------+
void  _funcBE()
  {

   int count=OrdersTotal();
   double ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,MODE_TRADES);

      if(OrderMagicNumber()==Magic)
        {
         //--- symbol variables
         double pip=SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT);
         if(SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==5 || SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==3)
            pip*=10;
         int digits = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);

         switch(OrderType())
           {
            default:
               break;
            case ORDER_TYPE_BUY:
              {
               switch(BreakEvenUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > BreakEvenTrigger;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / BreakEvenTrigger);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoBreakEven)
                             {
                              //--- calculate stop loss distance
                              double stop_distance   = GetDistanceInPoints(OrderSymbol(),BreakEvenUnit,BreakEvenProfit*steps,1,OrderLots()); //--- pip value forced to 1 because BreakEvenProfit*steps already in points
                              double stop_price      = NormalizeDouble(OrderOpenPrice()+stop_distance,digits);
                              //--- move stop if needed
                              if((OrderStopLoss()==0)||(stop_price > OrderStopLoss()))
                                {
                                 if(DebugBreakEven)
                                   {
                                    Print("BE[Trigger:$"+DoubleToString(BreakEvenTrigger,2)
                                          +",Profit:$"+DoubleToString(BreakEvenProfit,2)
                                          +",Max:"+DoubleToString(MaxNoBreakEven,2)+"]"
                                          +" p:$"+DoubleToString(profit_distance,digits)
                                          +" s:$"+DoubleToString(steps,digits)
                                          +" sd:"+DoubleToString(stop_distance,digits)
                                          +" sp:"+DoubleToString(stop_price,digits));
                                   }
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                   {
                                    Print("Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                   }
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = SymbolInfoDouble(OrderSymbol(),SYMBOL_BID) - OrderOpenPrice();
                     bool is_activated = profit_distance > BreakEvenTrigger*pip;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / BreakEvenTrigger*pip);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoBreakEven)
                             {
                              double stop_distance = BreakEvenProfit*pip*steps;
                              double stop_price = NormalizeDouble(OrderOpenPrice()+stop_distance,digits);
                              //--- move stop if needed
                              if((OrderStopLoss()==0)||(stop_price > OrderStopLoss()))
                                {
                                 if(DebugBreakEven)
                                   {
                                    Print("BE[Trigger:"+DoubleToString(BreakEvenTrigger)
                                          +",Profit:"+DoubleToString(BreakEvenProfit)
                                          +",Max:"+IntegerToString(MaxNoBreakEven)+"]"
                                          +" p:"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps)
                                          +" sd:"+DoubleToString(stop_distance,digits)
                                          +" sp:"+DoubleToString(stop_price,digits));
                                   }
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                   {
                                    Print("Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                   }
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
            case ORDER_TYPE_SELL:
              {
               switch(BreakEvenUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > BreakEvenTrigger;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / BreakEvenTrigger);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoBreakEven)
                             {
                              //--- calculate stop loss distance
                              double stop_distance = GetDistanceInPoints(OrderSymbol(),BreakEvenUnit,BreakEvenProfit*steps,1,OrderLots());
                              double stop_price    = NormalizeDouble(OrderOpenPrice()-stop_distance,digits);
                              //--- move stop if needed
                              if((OrderStopLoss()==0)||(stop_price < OrderStopLoss()))
                                {
                                 if(DebugBreakEven)
                                   {
                                    Print("BE[Trigger:$"+DoubleToString(BreakEvenTrigger,2)
                                          +",Profit:$"+DoubleToString(BreakEvenProfit,2)
                                          +",Max:"+IntegerToString(MaxNoBreakEven)+"]"
                                          +" p:$"+DoubleToString(profit_distance,digits)
                                          +" s:$"+DoubleToString(steps,digits)
                                          +" sd:"+DoubleToString(stop_distance,digits)
                                          +" sp:"+DoubleToString(stop_price,digits));
                                   }
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                   {
                                    Print("Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                   }
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = OrderOpenPrice() - SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK);
                     bool is_activated = profit_distance > BreakEvenTrigger*pip;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / BreakEvenTrigger*pip);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoBreakEven)
                             {
                              double stop_distance = BreakEvenProfit*pip*steps;
                              double stop_price    = NormalizeDouble(OrderOpenPrice()-stop_distance,digits);
                              //--- move stop if needed
                              if((OrderStopLoss()==0)||(stop_price < OrderStopLoss()))
                                {
                                 if(DebugBreakEven)
                                   {
                                    Print("BE[Trigger:"+DoubleToString(BreakEvenTrigger)
                                          +",Profit:"+DoubleToString(BreakEvenProfit)
                                          +",Max:"+IntegerToString(MaxNoBreakEven)+"]"
                                          +" p:"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps)
                                          +" sd:"+DoubleToString(stop_distance,digits)
                                          +" sp:"+DoubleToString(stop_price,digits));
                                   }
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                   {
                                    Print("Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                   }
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
           }

        }
      count--;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckPartialClose()
  {
   int count=OrdersTotal();
   double ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,MODE_TRADES);

      if(OrderMagicNumber()==Magic)
        {
         //--- symbol variables
         double pip=SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT);
         if(SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==5 || SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==3)
            pip*=10;
         int digits = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);

         switch(OrderType())
           {
            default:
               break;
            case ORDER_TYPE_BUY:
              {
               switch(PartialCloseUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > PartialCloseTrigger;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / PartialCloseTrigger);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoPartialClose)
                             {
                              //--- calculate new lot size
                              int lot_digits = (int)(MathLog(SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_STEP))/MathLog(0.1));
                              double lots = NormalizeDouble(OrderLots() * PartialClosePercent,lot_digits);
                              if(lots < SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_MIN))    //--- close all
                                {
                                 lots = OrderLots();
                                }
                              if(OrderClose(OrderTicket(),lots,SymbolInfoDouble(OrderSymbol(),SYMBOL_BID),5,clrYellow))
                                {
                                 if(DebugPartialClose)
                                   {
                                    Print("PC[Trigger:$"+DoubleToString(PartialCloseTrigger,2)
                                          +",Percent:"+DoubleToString(PartialClosePercent,2)
                                          +",Max:"+IntegerToString(MaxNoPartialClose)+"]"
                                          +" p:$"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps,digits)
                                          +" l:"+DoubleToString(lots,lot_digits));
                                   }
                                }
                              else
                                {
                                 Print("Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = SymbolInfoDouble(OrderSymbol(),SYMBOL_BID) - OrderOpenPrice();
                     bool is_activated = profit_distance > PartialCloseTrigger*pip;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / PartialCloseTrigger*pip);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoPartialClose)
                             {
                              //--- calculate new lot size
                              int lot_digits = (int)(MathLog(SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_STEP))/MathLog(0.1));
                              double lots = NormalizeDouble(OrderLots() * PartialClosePercent,lot_digits);
                              if(lots < SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_MIN))    //--- close all
                                {
                                 lots = OrderLots();
                                }
                              if(OrderClose(OrderTicket(),lots,SymbolInfoDouble(OrderSymbol(),SYMBOL_BID),5,clrYellow))
                                {
                                 if(DebugPartialClose)
                                   {
                                    Print("PC[Trigger:"+DoubleToString(PartialCloseTrigger,2)
                                          +",Percent:"+DoubleToString(PartialClosePercent,2)
                                          +",Max:"+IntegerToString(MaxNoPartialClose)+"]"
                                          +" p:"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps,digits)
                                          +" l:"+DoubleToString(lots,lot_digits));
                                   }
                                }
                              else
                                {
                                 Print("Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
            case ORDER_TYPE_SELL:
              {
               switch(PartialCloseUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > PartialCloseTrigger;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / PartialCloseTrigger);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoPartialClose)
                             {
                              //--- calculate new lot size
                              int lot_digits = (int)(MathLog(SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_STEP))/MathLog(0.1));
                              double lots = NormalizeDouble(OrderLots() * PartialClosePercent,lot_digits);
                              if(lots < SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_MIN))    //--- close all
                                {
                                 lots = OrderLots();
                                }
                              if(OrderClose(OrderTicket(),lots,SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK),5,clrYellow))
                                {
                                 if(DebugPartialClose)
                                   {
                                    Print("PC[Trigger:$"+DoubleToString(PartialCloseTrigger,2)
                                          +",Percent:"+DoubleToString(PartialClosePercent,2)
                                          +",Max:"+IntegerToString(MaxNoPartialClose)+"]"
                                          +" p:$"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps,digits)
                                          +" l:"+DoubleToString(lots,lot_digits));
                                   }
                                }
                              else
                                {
                                 Print("Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = OrderOpenPrice() - SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK);
                     bool is_activated = profit_distance > PartialCloseTrigger*pip;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / PartialCloseTrigger*pip);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoPartialClose)
                             {
                              //--- calculate new lot size
                              int lot_digits = (int)(MathLog(SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_STEP))/MathLog(0.1));
                              double lots = NormalizeDouble(OrderLots() * PartialClosePercent,lot_digits);
                              if(lots < SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_MIN))    //--- close all
                                {
                                 lots = OrderLots();
                                }
                              if(OrderClose(OrderTicket(),lots,SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK),5,clrYellow))
                                {
                                 if(DebugPartialClose)
                                   {
                                    Print("PC[Trigger:"+DoubleToString(PartialCloseTrigger,2)
                                          +",Percent:"+DoubleToString(PartialClosePercent,2)
                                          +",Max:"+IntegerToString(MaxNoPartialClose)+"]"
                                          +" p:"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps,digits)
                                          +" l:"+DoubleToString(lots,lot_digits));
                                   }
                                }
                              else
                                {
                                 Print("Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
           }

        }
      count--;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int IndicatorSignal(int OpenOrExit, int SymbolNum, int &EnterSignal_Sepearte, int &EnterSignal_Join)
  {
   string symbol = simbolbaru[SymbolNum]+postfix;

   EnterSignal_Sepearte = 100;
   EnterSignal_Join = 100;

   int ExitSignals_Buy = 0, ExitSignals_NewBuy = 0;
   int ExitSignals_Sell = 0, ExitSignals_NewSell = 0;

   for(int IndicatorNum = 0; IndicatorNum < TOTAL_IndicatorNum; IndicatorNum++)
     {
      int CurSignal = 0;

      if(IndicatorType[OpenOrExit][IndicatorNum] == off)
         continue;

      bool IsNewBar = PrevTime[SymbolNum] < iTime(symbol, timeframe[OpenOrExit][IndicatorNum], 0);

      if(SignalBarShift[OpenOrExit][IndicatorNum] == 0 || IsNewBar)
        {
         if(IndicatorType[OpenOrExit][IndicatorNum] == beast)
           {
            double buy = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],BEAST_Depth,BEAST_Deviation,BEAST_BackStep,BEAST_StochasticLen,BEAST_StochasticFilter,BEAST_OverBoughtLevel,BEAST_OverSoldLevel,BEAST_MATrendLinePeriod,BEAST_MATrendLineMethod,BEAST_MATrendLinePrice,BEAST_MAPerod,BEAST_MAShift,BEAST_MAMethod,BEAST_MAPrice,BEAST_alert,BEAST_push,BEAST_mail,BEAST_arrow,0,SignalBarShift[OpenOrExit][IndicatorNum]);
            if(signalbfr(buy))
               CurSignal = 1;
            double sell = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],BEAST_Depth,BEAST_Deviation,BEAST_BackStep,BEAST_StochasticLen,BEAST_StochasticFilter,BEAST_OverBoughtLevel,BEAST_OverSoldLevel,BEAST_MATrendLinePeriod,BEAST_MATrendLineMethod,BEAST_MATrendLinePrice,BEAST_MAPerod,BEAST_MAShift,BEAST_MAMethod,BEAST_MAPrice,BEAST_alert,BEAST_push,BEAST_mail,BEAST_arrow,1,SignalBarShift[OpenOrExit][IndicatorNum]);
            if(signalbfr(sell))
               CurSignal = -1;
            if(false&&CurSignal < 0 && OpenOrExit == 0 && IndicatorNum == 0 && CurSignal != 0)
              {
               //TimeCurrent() >= D'2021.1.4 1:15')//
               Print(CurSignal);
               //Print(iTime(symbol,timeframe[OpenOrExit][IndicatorNum],SignalBarShift[OpenOrExit][IndicatorNum]),"*",CurSignal,"*",SignalBarShift[OpenOrExit][IndicatorNum]);
               int zero=0;
               zero/=zero;
              }

           }
         else
            if(IndicatorType[OpenOrExit][IndicatorNum] == triger)
              {
               double buff0_1 = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],TRIGGERLINES_Rperiod,TRIGGERLINES_LSMA_Period,0,SignalBarShift[OpenOrExit][IndicatorNum]);
               double buff2_1 = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],TRIGGERLINES_Rperiod,TRIGGERLINES_LSMA_Period,2,SignalBarShift[OpenOrExit][IndicatorNum]);
               double buff0_2 = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],TRIGGERLINES_Rperiod,TRIGGERLINES_LSMA_Period,0,SignalBarShift[OpenOrExit][IndicatorNum]+1);
               double buff2_2 = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],TRIGGERLINES_Rperiod,TRIGGERLINES_LSMA_Period,2,SignalBarShift[OpenOrExit][IndicatorNum]+1);
               if(signalbfr(buff0_1) && signalbfr(buff2_1) && signalbfr(buff0_2) && !signalbfr(buff2_2))
                  CurSignal = 1;
               if(signalbfr(buff0_1) && !signalbfr(buff2_1) && signalbfr(buff0_2) && signalbfr(buff2_2))
                  CurSignal = -1;
               if(false&&TimeCurrent() >= D'2021.1.4 1:15') //(CurSignal > 0 && OpenOrExit == 0 && IndicatorNum == 0 && CurSignal != 0)
                 {
                  //
                  Print(CurSignal);
                  //Print(iTime(symbol,timeframe[OpenOrExit][IndicatorNum],SignalBarShift[OpenOrExit][IndicatorNum]),"*",CurSignal,"*",SignalBarShift[OpenOrExit][IndicatorNum]);
                  int zero=0;
                  zero/=zero;
                 }
              }
            else
               if(IndicatorType[OpenOrExit][IndicatorNum] == uni)
                 {
                  double buy = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],UseSound,TypeChart,UseAlert,NameFileSound,T3Period,T3Price,b,Snake_HalfCycle,Inverse,DeltaForSell,DeltaForBuy,ArrowOffset,Maxbars,0,SignalBarShift[OpenOrExit][IndicatorNum]);
                  if(signalbfr(buy))
                     CurSignal = 1;
                  double sell = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],UseSound,TypeChart,UseAlert,NameFileSound,T3Period,T3Price,b,Snake_HalfCycle,Inverse,DeltaForSell,DeltaForBuy,ArrowOffset,Maxbars,1,SignalBarShift[OpenOrExit][IndicatorNum]);
                  if(signalbfr(sell))
                     CurSignal = -1;
                  if(false&&TimeCurrent() >= D'2021.1.4 6:15') //CurSignal > 0 && OpenOrExit == 0 && IndicatorNum == 0 && CurSignal != 0)
                    {
                     //
                     //Print(CurSignal);
                     Print(iTime(symbol,timeframe[OpenOrExit][IndicatorNum],SignalBarShift[OpenOrExit][IndicatorNum]),"*",CurSignal,"*",SignalBarShift[OpenOrExit][IndicatorNum]);
                     int zero=0;
                     zero/=zero;
                    }

                 }
               else
                  if(IndicatorType[OpenOrExit][IndicatorNum] == zigzag)
                    {
                     double buy = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],ZIGZAG_Depth,ZIGZAG_Deviation,ZIGZAG_BackStep,ZIGZAG_alertmessages,ZIGZAG_email,ZIGZAG_alertbar,ZIGZAG_notify,ZIGZAG_displayinfo,0,SignalBarShift[OpenOrExit][IndicatorNum]);
                     if(signalbfr(buy))
                        CurSignal = 1;
                     double sell = iCustom(symbol,timeframe[OpenOrExit][IndicatorNum],IndicatorName[IndicatorType[OpenOrExit][IndicatorNum]],ZIGZAG_Depth,ZIGZAG_Deviation,ZIGZAG_BackStep,ZIGZAG_alertmessages,ZIGZAG_email,ZIGZAG_alertbar,ZIGZAG_notify,ZIGZAG_displayinfo,1,SignalBarShift[OpenOrExit][IndicatorNum]);
                     if(signalbfr(sell))
                        CurSignal = -1;
                     if(false&&CurSignal > 0 && OpenOrExit == 0 && IndicatorNum == 0 && CurSignal != 0)
                       {
                        //(TimeCurrent() >= D'2021.1.4 13:15')//
                        //Print(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum0],"*",LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum1]);
                        Print(iTime(symbol,timeframe[OpenOrExit][IndicatorNum],SignalBarShift[OpenOrExit][IndicatorNum]),"*",CurSignal,"*",buy,"*",sell,"*",SignalBarShift[OpenOrExit][IndicatorNum]);
                        int zero=0;
                        zero/=zero;
                       }
                    }
         if(CurSignal != 0)
            LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum] = (CurSignal > 0 ? 1 : -1)*iTime(symbol, timeframe[OpenOrExit][IndicatorNum], SignalBarShift[OpenOrExit][IndicatorNum]);
         if(false&&IndicatorNum == 1 && TimeCurrent() >= D'2021.1.4 6:30')
           {
            Print(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum0],"*",LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum1]);
            int zero=0;
            zero/=zero;
           }
        }

      if(OpenOrExit == 0)
        {
         //if (joinseperate == sendiri) // -- Seperate
           {
            if(IndicatorTrendType[OpenOrExit][IndicatorNum] == withtrend)
              {
               if(false&&IndicatorNum == 1 && TimeCurrent() >= D'2021.1.4 13:45') // EnterSignal_Sepearte != 100)
                 {
                  Print(-LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum0]
                        ,"*", -LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum]
                        ,"*",EnterSignal_Sepearte == 100,"*", IndicatorNum > 0,"*", LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum0] != 0,"*", CurSignal != 0
                       );
                  int zero=0;
                  zero/=zero;
                 }
               if(EnterSignal_Sepearte == 100 && IndicatorNum > 0 && LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum0] != 0 && CurSignal != 0)
                 {
                  if(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum0] < 0 && CurSignal < 0)
                     EnterSignal_Sepearte = -1;
                  else
                     if(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum0] > 0 && CurSignal > 0)
                        EnterSignal_Sepearte = 1;
                 }
              }
            else
              {
               if(EnterSignal_Sepearte == 100 && CurSignal != 0)
                 {
                  if(CurSignal > 0)
                     EnterSignal_Sepearte = 1;
                  else
                     if(CurSignal < 0)
                        EnterSignal_Sepearte = -1;
                 }
              }
           }
         //else //-- Join
           {
            if(IndicatorTrendType[OpenOrExit][IndicatorNum] == withtrend)
              {
               if(EnterSignal_Join == 100 || EnterSignal_Join > 0 || EnterSignal_Join < 0)
                 {
                  if(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum] == 0)
                     EnterSignal_Join = 0;
                  else
                     if(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum] > 0)
                       {
                        if(EnterSignal_Join < 0)
                           EnterSignal_Join = 0;
                        else
                           if(EnterSignal_Join == 100)
                              EnterSignal_Join = (CurSignal > 0 ? 2 : 1);
                           else
                              if(EnterSignal_Join == 1 && CurSignal > 0)
                                 EnterSignal_Join = 2;
                       }
                     else
                        if(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum] < 0)
                          {
                           if(EnterSignal_Join > 0)
                              EnterSignal_Join = 0;
                           else
                              if(EnterSignal_Join == 100)
                                 EnterSignal_Join = (CurSignal < 0 ? -2 : -1);
                              else
                                 if(EnterSignal_Join == -1 && CurSignal < 0)
                                    EnterSignal_Join = -2;
                          }
                 }
              }
           }
        }

      else
         if(OpenOrExit == 1)
           {
            if(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum] > 0)
              {
               ExitSignals_Buy++;
               if(CurSignal > 0)
                  ExitSignals_NewBuy++;
              }
            else
               if(LastIndicatorSignalTime[SymbolNum][OpenOrExit][IndicatorNum] < 0)
                 {
                  ExitSignals_Sell++;
                  if(CurSignal < 0)
                     ExitSignals_NewSell++;
                 }
           }
     }

   if(OpenOrExit == 0)
     {
      if(EnterSignal_Join == 100)
         EnterSignal_Join = 0;
      if(EnterSignal_Sepearte == 100)
         EnterSignal_Sepearte = 0;

      if(joinseperate == gabung)
        {
         if((int)MathAbs(EnterSignal_Join) == 1)
            EnterSignal_Join = 0;
         else
            if((int)MathAbs(EnterSignal_Join) == 2)
               EnterSignal_Join = (EnterSignal_Join > 0 ? 1 : -1);
        }

      int EnterSignal = (joinseperate == gabung ? EnterSignal_Join : EnterSignal_Sepearte);

      if(false&&EnterSignal != 0)
        {
         int zero=0;
         zero/=zero;
        }
      return (EnterSignal);
     }
   else
     {
      int ExitSignal = 0;
      if(ExitSignals_Buy >= 2 && ExitSignals_NewBuy > 0)
         ExitSignal = 1;
      else
         if(ExitSignals_Sell >= 2 && ExitSignals_NewSell > 0)
            ExitSignal = -1;
      return (ExitSignal);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void displaystart()
  {
// clear();


//-----

   string name = prefix2 + "entryindi";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 100);
   ObjectSet(name, OBJPROP_YDISTANCE, 10);
   ObjectSetText(name, "ENTRY INDICATORS", 8, "Tahoma", _tableHeader);
   ObjectSet(name, OBJPROP_CORNER, Corner);



   name = prefix2 + "symbols";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 30);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name, "Symbol", 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);


   name = prefix2 + "i1";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 100);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,komentar1, 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);


   name = prefix2 + "i2";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 150);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,komentar2, 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);

   name = prefix2 + "i3";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 200);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,komentar3, 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);

   name = prefix2 + "i4";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 250);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,komentar4, 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);


   name = prefix2 + "exitindi";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 330);
   ObjectSet(name, OBJPROP_YDISTANCE, 10);
   ObjectSetText(name, "EXIT INDICATORS", 8, "Tahoma", _tableHeader);
   ObjectSet(name, OBJPROP_CORNER, Corner);


   /*name = prefix2 + "iexit1";
   if (ObjectFind(name) == -1) {
     ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
   }

   ObjectSet(name, OBJPROP_XDISTANCE, 290);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,"<<< ENTRY INDICATOR  ||   EXIT INDICATOR", 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);*/


   name = prefix2 + "i1x";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 330);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,komentar1x, 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);


   name = prefix2 + "i2x";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 380);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,komentar2x, 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);

   name = prefix2 + "i3x";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 430);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,komentar3x, 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);

   name = prefix2 + "i4x";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 480);
   ObjectSet(name, OBJPROP_YDISTANCE, 10+13.5);
   ObjectSetText(name,komentar4x, 8, "Tahoma", _Header);
   ObjectSet(name, OBJPROP_CORNER, Corner);



   name = prefix2 + "tmp1";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 29);
   ObjectSet(name, OBJPROP_YDISTANCE, 15+3.5+dy);
   ObjectSetText(name, "-------------------------------------------------------------------------------------------------------------------------------------------------------------",
                 8, "Tahoma", _Separator);
   ObjectSet(name, OBJPROP_CORNER, Corner);

   name = prefix2 + "tmp1x";
   if(ObjectFind(name) == -1)
     {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
     }

   ObjectSet(name, OBJPROP_XDISTANCE, 330);
   ObjectSet(name, OBJPROP_YDISTANCE, 15+3.5+dy);
   ObjectSetText(name, "-------------------------------------------------------------------------------------------------------------------------------------------------------------",
                 8, "Tahoma", _Separator);
   ObjectSet(name, OBJPROP_CORNER, Corner);


   for(int SymbolNum=0; SymbolNum<NumOfSymbols; SymbolNum++)
     {
      string symbol = simbolbaru[SymbolNum]+postfix;

      name = prefix2 + "symbol"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 30);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));
      ObjectSetText(name, symbol, 8, "Tahoma", _cSymbol);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

      name = prefix2 + "idin1WT"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 100);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));

      string text = "None";
      if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum0] != 0)
        {
         if((datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum0]) == iTime(symbol, timeframe[OpenOrExit0][IndicatorNum0], SignalBarShift[OpenOrExit0][IndicatorNum0]))
            text = "New";
         else
            text = "Old";

         if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum0] > 0)
            text += " Buy";
         else
            text += " Sell";
        }
      if(indikator1!=off)
         ObjectSetText(name,"1 : "+ text);//_Text);

      if(indikator1==off)
         ObjectSetText(name,"1 : Off", 8, "Tahoma", clrGray);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

      name = prefix2 + "idin2WT"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 150);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));

      text = "None";
      if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum1] != 0)
        {
         if((datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum1]) == iTime(symbol, timeframe[OpenOrExit0][IndicatorNum1], SignalBarShift[OpenOrExit0][IndicatorNum1]))
            text = "New";
         else
            text = "Old";

         if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum1] > 0)
            text += " Buy";
         else
            text += " Sell";
        }
      if(indikator2!=off)
         ObjectSetText(name,"2 : "+ text);//_Text);

      if(indikator2==off)
         ObjectSetText(name,"2 : Off", 8, "Tahoma", clrGray);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

      name = prefix2 + "idin3WT"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 200);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));

      text = "None";
      if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum2] != 0)
        {
         if((datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum2]) == iTime(symbol, timeframe[OpenOrExit0][IndicatorNum2], SignalBarShift[OpenOrExit0][IndicatorNum2]))
            text = "New";
         else
            text = "Old";

         if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum2] > 0)
            text += " Buy";
         else
            text += " Sell";
        }
      if(indikator3!=off)
         ObjectSetText(name,"3 : "+ text);//_Text);

      if(indikator3==off)
         ObjectSetText(name,"3 : Off", 8, "Tahoma", clrGray);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

      name = prefix2 + "idin4WT"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 250);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));

      text = "None";
      if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum3] != 0)
        {
         if((datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum3]) == iTime(symbol, timeframe[OpenOrExit0][IndicatorNum3], SignalBarShift[OpenOrExit0][IndicatorNum3]))
            text = "New";
         else
            text = "Old";

         if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum3] > 0)
            text += " Buy";
         else
            text += " Sell";
        }
      if(indikator4!=off)
         ObjectSetText(name,"4 : "+ text);//_Text);

      if(indikator4==off)
         ObjectSetText(name,"4 : Off", 8, "Tahoma", clrGray);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

     }
//exit indicator
   for(int SymbolNum=0; SymbolNum<NumOfSymbols; SymbolNum++)
     {
      string symbol = simbolbaru[SymbolNum]+postfix;

      name = prefix2 + "idin1cT"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 330);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));

      string text = "None";
      if(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum0] != 0)
        {
         if((datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum0]) == iTime(symbol, timeframe[OpenOrExit1][IndicatorNum0], SignalBarShift[OpenOrExit1][IndicatorNum0]))
            text = "New";
         else
            text = "Old";

         if(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum0] > 0)
            text += " Buy";
         else
            text += " Sell";
        }
      if(indikator1x!=off)
         ObjectSetText(name,"1 : "+ text);//_Text);

      if(indikator1x==off)
         ObjectSetText(name,"1 : Off", 8, "Tahoma", clrGray);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

      name = prefix2 + "idin2cT"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 380);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));

      text = "None";
      if(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum1] != 0)
        {
         if((datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum1]) == iTime(symbol, timeframe[OpenOrExit1][IndicatorNum1], SignalBarShift[OpenOrExit1][IndicatorNum1]))
            text = "New";
         else
            text = "Old";

         if(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum1] > 0)
            text += " Buy";
         else
            text += " Sell";
        }
      if(indikator2x!=off)
         ObjectSetText(name,"2 : "+ text);//_Text);

      if(indikator2x==off)
         ObjectSetText(name,"2 : Off", 8, "Tahoma", clrGray);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

      name = prefix2 + "idin3cT"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 430);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));

      text = "None";
      if(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum2] != 0)
        {
         if((datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum2]) == iTime(symbol, timeframe[OpenOrExit1][IndicatorNum2], SignalBarShift[OpenOrExit1][IndicatorNum2]))
            text = "New";
         else
            text = "Old";

         if(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum2] > 0)
            text += " Buy";
         else
            text += " Sell";
        }
      if(indikator3x!=off)
         ObjectSetText(name,"3 : "+ text);//_Text);

      if(indikator3x==off)
         ObjectSetText(name,"3 : Off", 8, "Tahoma", clrGray);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

      name = prefix2 + "idin4cT"+string(SymbolNum);
      if(ObjectFind(name) == -1)
        {
         ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
        }

      ObjectSet(name, OBJPROP_XDISTANCE, 480);
      ObjectSet(name, OBJPROP_YDISTANCE, 10+3.5+dy*(SymbolNum+2));

      text = "None";
      if(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum3] != 0)
        {
         if((datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum3]) == iTime(symbol, timeframe[OpenOrExit1][IndicatorNum3], SignalBarShift[OpenOrExit1][IndicatorNum3]))
            text = "New";
         else
            text = "Old";

         if(LastIndicatorSignalTime[SymbolNum][OpenOrExit1][IndicatorNum3] > 0)
            text += " Buy";
         else
            text += " Sell";
        }
      if(indikator4x!=off)
         ObjectSetText(name,"4 : "+ text);//_Text);

      if(indikator4x==off)
         ObjectSetText(name,"4 : Off", 8, "Tahoma", clrGray);//_Text);
      ObjectSet(name, OBJPROP_CORNER, Corner);

     }
   Sleep(100);


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int warna(string Ad_0)
  {
   color Li_ret_8=_Neutral;
   if(Ad_0 =="SELL")
      Li_ret_8 = _SellSignal;
   if(Ad_0 =="BUY")
      Li_ret_8 = _BuySignal;
   return (Li_ret_8);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void getsignal()
  {
   for(int SymbolNum = 0; SymbolNum < NumOfSymbols; SymbolNum++)
     {
      string symbol=simbolbaru[SymbolNum]+postfix;

      double SetPoint=0;
      int vdigits = (int)MarketInfo(symbol,MODE_DIGITS);
      double vpoint = NormalizeDouble(MarketInfo(symbol,MODE_POINT),vdigits);
      long VL =11;
      if(vdigits == 3 || vdigits == 5)
        {
         SetPoint =10*vpoint;
         VL=20;
        }
      if(vdigits == 4)
        {
         SetPoint = vpoint;
        }
      if(vdigits == 2)
        {
         SetPoint = 10*vpoint;
        }


      int      iCount      =  0;
      double   Lotbuyy      =  0;
      double   Lotselll      =  0;
      double   LastOPBuy      =  0;
      double   LastOPSell      =  0;
      double   OrderSLbuy    =  0;
      double   OrderSLsell    =  0;
      double   LastLotsBuy    =  0;
      double   LastLotsSell    =  0;
      datetime      LastTimeBuy    =  0;
      datetime      LastTimeSell    =  0;
      int      TB   =  0;
      int      TS  =  0;
      int      Spread=0,bl=0;
      double SLBuy=0,SLSell=0;
      int tccx = (int)TimeCurrent();
      if(StopLoss>0) {}
      double pb=0,ps=0;
      for(iCount=0; iCount<OrdersTotal(); iCount++)
        {
         xx=OrderSelect(iCount,SELECT_BY_POS,MODE_TRADES);
         if((OrderType()==OP_BUY || OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT) && OrderSymbol()==symbol && OrderMagicNumber()==Magic)
           {
            pb+=OrderProfit()+OrderCommission()+OrderSwap();
            Lotbuyy+=OrderLots();
            OrderSLbuy = OrderStopLoss();
            if(LastTimeBuy==0)
              {
               LastTimeBuy=OrderOpenTime();
              }
            if(LastTimeBuy>OrderOpenTime())
              {
               LastTimeBuy=OrderOpenTime();
              }
            if(LastOPBuy==0)
              {
               LastOPBuy=OrderOpenPrice();
              }
            if(LastOPBuy>OrderOpenPrice())
              {
               LastOPBuy=OrderOpenPrice();
              }
            if(LastLotsBuy==0)
              {
               LastLotsBuy=OrderLots();
              }
            if(LastLotsBuy>OrderLots())
              {
               LastLotsBuy=OrderLots();
              }
            TB++;
           }
         if((OrderType()==OP_SELL || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP) && OrderSymbol()==symbol && OrderMagicNumber()==Magic)
           {
            ps+=OrderProfit()+OrderCommission()+OrderSwap();
            Lotselll+=OrderLots();
            OrderSLsell = OrderStopLoss();
            if(LastTimeSell==0)
              {
               LastTimeSell=OrderOpenTime();
              }
            if(LastTimeSell>OrderOpenTime())
              {
               LastTimeSell=OrderOpenTime();
              }
            if(LastOPSell==0)
              {
               LastOPSell=OrderOpenPrice();
              }
            if(LastOPSell<OrderOpenPrice())
              {
               LastOPSell=OrderOpenPrice();
              }
            if(LastLotsSell==0)
              {
               LastLotsSell=OrderLots();
              }
            if(LastLotsSell>OrderLots())
              {
               LastLotsSell=OrderLots();
              }
            TS++;
           }
        }

      int EnterSignal_Sepearte, EnterSignal_Join;
      int EnterSignal = IndicatorSignal(OpenOrExit0, SymbolNum, EnterSignal_Sepearte, EnterSignal_Join);
      int ExitSignal = IndicatorSignal(OpenOrExit1, SymbolNum, EnterSignal_Sepearte, EnterSignal_Join);

      //====================================================================
      if(telegram ==yes && sendsignal == yes)
        {
         if(indikator1 !=off
            && iTime(symbol,timeframe1,0) > sendOnce
            && (datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum0]) == iTime(symbol, timeframe[OpenOrExit0][IndicatorNum0], SignalBarShift[OpenOrExit0][IndicatorNum0])
           )
           {
            if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum0] > 0)
              {
               tms_send(symbol+", "+pcom1+", "+IndicatorName[IndicatorType[OpenOrExit0][IndicatorNum0]]+" BUY @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            else
              {
               tms_send(symbol+", "+pcom1+", "+IndicatorName[IndicatorType[OpenOrExit0][IndicatorNum0]]+" SELL @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            sendOnce = iTime(symbol,timeframe1,0);
           }

         if(indikator2 !=off
            && iTime(symbol,timeframe2,0) > sendOnce
            && (datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum1]) == iTime(symbol, timeframe[OpenOrExit0][IndicatorNum1], SignalBarShift[OpenOrExit0][IndicatorNum1])
           )
           {
            if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum1] > 0)
              {
               tms_send(symbol+", "+pcom2+", "+IndicatorName[IndicatorType[OpenOrExit0][IndicatorNum1]]+" BUY @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            else
              {
               tms_send(symbol+", "+pcom2+", "+IndicatorName[IndicatorType[OpenOrExit0][IndicatorNum1]]+" SELL @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            sendOnce = iTime(symbol,timeframe2,0);
           }

         if(indikator3 !=off
            && iTime(symbol,timeframe3,0) > sendOnce
            && (datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum2]) == iTime(symbol, timeframe[OpenOrExit0][IndicatorNum2], SignalBarShift[OpenOrExit0][IndicatorNum2])
           )
           {
            if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum2] > 0)
              {
               tms_send(symbol+", "+pcom3+", "+IndicatorName[IndicatorType[OpenOrExit0][IndicatorNum2]]+" BUY @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            else
              {
               tms_send(symbol+", "+pcom3+", "+IndicatorName[IndicatorType[OpenOrExit0][IndicatorNum2]]+" SELL @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            sendOnce = iTime(symbol,timeframe3,0);
           }

         if(indikator4 !=off
            && iTime(symbol,timeframe4,0) > sendOnce
            && (datetime)MathAbs(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum3]) == iTime(symbol, timeframe[OpenOrExit0][IndicatorNum3], SignalBarShift[OpenOrExit0][IndicatorNum3])
           )
           {
            if(LastIndicatorSignalTime[SymbolNum][OpenOrExit0][IndicatorNum3] > 0)
              {
               tms_send(symbol+", "+pcom4+", "+IndicatorName[IndicatorType[OpenOrExit0][IndicatorNum3]]+" BUY @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            else
              {
               tms_send(symbol+", "+pcom4+", "+IndicatorName[IndicatorType[OpenOrExit0][IndicatorNum3]]+" SELL @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            sendOnce = iTime(symbol,timeframe4,0);
           }
        }

      if(telegram ==yes && sendTradesignal == yes && EnterSignal != 0 && iTime(symbol,0,0) > sendOnce)
        {
           {
            if(EnterSignal > 0)
              {
               tms_send(symbol+", "+pcom1+", "+(joinseperate == sendiri ? "Seperate" : "Join")+" BUY @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            else
              {
               tms_send(symbol+", "+pcom1+", "+(joinseperate == sendiri ? "Seperate" : "Join")+" SELL @ "+string(MarketInfo(symbol,MODE_BID))+"\nTime :"+TimeToStr(TimeCurrent()),_token);
              }
            sendOnce = iTime(symbol,0,0);
           }
        }
      /*   if(TS > 0 && closetype == opposite && (xSell1+xSell2+xSell3+xSell4)>= xminagree)
           {//Print("Opposite Close Sell ",symbol);
            closeOP(OP_SELL,symbol);
           }
         if(TB > 0 && closetype == opposite && (xBuy1+xBuy2+xBuy3+xBuy4)>=xminagree)
           {//Print("Opposite Close Buy ",symbol);
            closeOP(OP_BUY,symbol);
           }*/

      if(TargetReachedForDay != ThisDayOfYear && Max_Spread>0&&MarketInfo(symbol,MODE_SPREAD)<=Max_Spread && TradeDays() && trade && !StopTarget() && usemode == Auto && AccountBalance() > minbalance)
         //   if(TMN<Time[0] && Max_Spread>0&&MarketInfo(symbol,MODE_SPREAD)<=Max_Spread && TradeDays() && trade && !StopTarget() && usemode == Auto && AccountBalance() > minbalance)
         //   if(Max_Spread>0&&MarketInfo(symbol,MODE_SPREAD)<=Max_Spread)
        {
         //TMN=Time[0];

         int TBa=0,TSa=0;
         if(false&&TimeCurrent() >= D'2021.1.4 6:30')
           {
            Print(EnterSignal);
            int zero=0;
            zero/=zero;
           }
         double Free=AccountFreeMargin();
         double One_Lot=MarketInfo(_Symbol,MODE_MARGINREQUIRED);

         if(One_Lot!=0)
           {
            if(TradingLots>floor(Free/One_Lot*100)/100)
              {
               Print("NO ENOUGHT MONEY!");
               return;
              }
            if(TradingLots==0)
               return;
           }
         else
            return;



         //=================================================
         //     bool time=(Hour()>=Start && Hour()<End);
         bool time= TradeDays();
         //=================================================
         double prs=0,prb=0;
         int ttlbuy=0,ttlsell=0;
         for(int pos=0; pos<=OrdersTotal(); pos++)
           {
            if(!OrderSelect(pos,SELECT_BY_POS))
              {
               continue;
              }
            if(OrderMagicNumber()==Magic && OrderSymbol()==symbol) //&& OrderType()==OP_BUY)
              {
               TBa++;
              }
            if(OrderMagicNumber()==Magic && OrderSymbol()==symbol) //&& OrderType()==OP_SELL)
              {
               TSa++;
              }
            if(OrderMagicNumber()==Magic && OrderType()==OP_BUY)
              {
               ttlbuy ++;
              }
            if(OrderMagicNumber()==Magic && OrderType()==OP_SELL)
              {
               ttlsell ++;
              }
           }// Alert("t buy : ",ttlbuy," ttl sell : ",ttlsell);
         double point=MarketInfo(symbol,MODE_POINT);
         double digits=MarketInfo(symbol,MODE_DIGITS);
         double bid =NormalizeDouble(MarketInfo(symbol,MODE_BID),(int)digits);
         double ask =NormalizeDouble(MarketInfo(symbol,MODE_ASK),(int)digits);

         int cnt = 720;
         double cur_day = 0;
         double prev_day = 0;
         double rates_d1[2][6];
         //---- exit if period is greater than daily charts
         //---- Get new daily prices & calculate pivots
         cur_day = TimeDay(Time[0] - (GMTshift*3600));
         yesterday_close = iClose(symbol,snrperiod,1);
         today_open = iOpen(symbol,snrperiod,0);
         yesterday_high = iHigh(symbol,snrperiod,1);//day_high;
         yesterday_low = iLow(symbol,snrperiod,1);//day_low;
         day_high = iHigh(symbol,snrperiod,1);
         day_low  = iLow(symbol,snrperiod,1);
         prev_day = cur_day;

         yesterday_high = MathMax(yesterday_high,day_high);
         yesterday_low = MathMin(yesterday_low,day_low);


         //------ Pivot Points ------
         Rx = (yesterday_high - yesterday_low);
         Px = (yesterday_high + yesterday_low + yesterday_close)/3; //Pivot
         R1x = Px + (Rx * 0.38);
         R2x = Px + (Rx * 0.62);
         R3x = Px + (Rx * 0.99);
         S1x = Px - (Rx * 0.38);
         S2x = Px - (Rx * 0.62);
         S3x = Px - (Rx * 0.99);
         //++++++++++++++++++++++++++++++++++++++++
         if(bid > R3x)
           {
            R3x = 0;
            S3x = R2x;
           }
         if(bid > R2x && bid < R3x)
           {
            R3x = 0;
            S3x = R1x;
           }
         if(bid > R1x && bid < R2x)
           {
            R3x = R3x;
            S3x = Px;
           }
         if(bid > Px && bid < R1x)
           {
            R3x = R2x;
            S3x = S1x;
           }
         if(bid > S1x && bid < Px)
           {
            R3x = R1x;
            S3x = S2x;
           }
         if(bid > S2x && bid < S1x)
           {
            R3x = Px;
            S3x = S3x;
           }
         if(bid > S3x && bid < S2x)
           {
            R3x = S1x;
            S3x = 0;
           }
         if(bid < S3x)
           {
            R3x = S2x;
            S3x = 0;
           }

         double sl=0,tpx=0,tpx2=0,xlimit=0,xstop=0,slimit=0,slstop=0,tplimit=0,tpstop=0;

         if(time) //BUY
           {


            if(((BarBaru&&iTime(NULL,mtfz,0) > sendOnce)|| !BarBaru)&& TBa<MaxLevel && ttlbuy<maxbuy && EnterSignal > 0 && ttlbuy <maxbuy && ((closetype == opposite && ExitSignal >= 0) || (closetype != opposite)) && (tipeOP == buyx || tipeOP == bothx))
              {
               sendOnce = iTime(NULL,mtfz,0);

               sl=0;
               tpx=0;
               tpx2=0;
               tpx2=NormalizeDouble(TakeProfit1*SetPoint,(int)digits);
               if(StopLoss>0)
                 {
                  if(fibotp==no)
                     sl=NormalizeDouble(MarketInfo(symbol,MODE_ASK)-StopLoss*SetPoint,(int)digits);
                  if(fibotp==no)
                     tpx=NormalizeDouble(MarketInfo(symbol,MODE_ASK)+TakeProfit*SetPoint,(int)digits)+(tpx2*TB);

                 }
               datetime expr = 0;
               if(deletepo)
                  expr = TimeCurrent()+(orderexp*Period()*60);
               if(deletepo && Period() == 1)
                  expr = TimeCurrent()+(MathMax(orderexp,12)*Period()*60);
               xlimit =NormalizeDouble(MarketInfo(symbol,MODE_BID)-orderdistance*SetPoint,(int)digits);
               xstop =NormalizeDouble(MarketInfo(symbol,MODE_BID)+orderdistance*SetPoint,(int)digits);
               slimit =NormalizeDouble(xlimit-StopLoss*SetPoint,(int)digits);
               slstop =NormalizeDouble(xstop-StopLoss*SetPoint,(int)digits);
               tplimit =NormalizeDouble(xlimit+TakeProfit*SetPoint,(int)digits)+(tpx2*TB);
               tpstop =NormalizeDouble(xstop+TakeProfit*SetPoint,(int)digits)+(tpx2*TB);
               if(fibotp==yes)
                  sl=NormalizeDouble(S3x,(int)digits);
               if(fibotp==yes)
                  tpx=NormalizeDouble(R3x,(int)digits);
               if(fibotp==yes && S3x == 0)
                  sl=NormalizeDouble(MarketInfo(symbol,MODE_ASK)-StopLoss*SetPoint,(int)digits);
               if(fibotp==yes && R3x == 0)
                  tpx=NormalizeDouble(MarketInfo(symbol,MODE_ASK)+TakeProfit*SetPoint,(int)digits)+(tpx2*TB);
               if(TB>0)
                 {
                  TradingLots=SubLots;
                 }

               Os=false;
               int kk=10;
               while(!Os && kk>=0)
                 {
                  switch(caraop)
                    {
                     case instan:
                        Os=OrderSend(symbol,OP_BUY,TradingLots,SymbolInfoDouble(symbol,SYMBOL_ASK),1,sl,tpx,eacomment+" # "+IntegerToString(TBa),Magic,0,clrGreen);
                        break;
                     case stop:
                        Os=OrderSend(symbol,OP_BUYSTOP,TradingLots,xstop,1,slstop,tpstop,eacomment+" # "+IntegerToString(TBa),Magic,expr,clrGreen);
                        break;
                     case limit:
                        Os=OrderSend(symbol,OP_BUYLIMIT,TradingLots,xlimit,1,slimit,tplimit,eacomment+" # "+IntegerToString(TBa),Magic,expr,clrGreen);
                        break;
                    }

                  kk--;
                 }

               //if(caraop == instan) Os=OrderSend(symbol,OP_BUY,TradingLots,ask,1,sl,tpx,eacomment+" # "+IntegerToString(TBa),Magic,0,clrGreen);
               //if(caraop == stop)   Os=OrderSend(symbol,OP_BUYSTOP,TradingLots,xstop,1,slstop,tpstop,eacomment+" # "+IntegerToString(TBa),Magic,expr,clrGreen);
               //if(caraop == limit)  Os=OrderSend(symbol,OP_BUYLIMIT,TradingLots,xlimit,1,slimit,tplimit,eacomment+" # "+IntegerToString(TBa),Magic,expr,clrGreen);
              }

           }

         if(time) //SELL
           {



            //Alert((sinyal1+sinyal2+sinyal3+sinyal4),symbol);
            tpx2=0;
            tpx2=NormalizeDouble(TakeProfit1*SetPoint,(int)digits);
            if(((BarBaru&&iTime(NULL,mtfz,0) > sendOnce)|| !BarBaru) && TSa<MaxLevel && ttlsell<maxsell && EnterSignal < 0 && ttlsell<maxsell && ((closetype == opposite && ExitSignal <= 0) || (closetype != opposite)) && (tipeOP == sellx || tipeOP == bothx))
              {

               sl=0;
               tpx=0;
               if(StopLoss>0)
                 {

                  if(fibotp==no)
                     sl=NormalizeDouble(MarketInfo(symbol,MODE_BID)+StopLoss*SetPoint,(int)digits);
                  if(fibotp==no)
                     tpx=NormalizeDouble(MarketInfo(symbol,MODE_BID)-TakeProfit*SetPoint,(int)digits)-(tpx2*TS);

                 }
               datetime expr = 0;
               if(deletepo)
                  expr = TimeCurrent()+(orderexp*Period()*60);
               if(deletepo && Period() == 1)
                  expr = TimeCurrent()+(MathMax(orderexp,12)*Period()*60);
               xlimit =NormalizeDouble(MarketInfo(symbol,MODE_BID)+orderdistance*SetPoint,(int)digits);
               xstop =NormalizeDouble(MarketInfo(symbol,MODE_BID)-orderdistance*SetPoint,(int)digits);
               slimit =NormalizeDouble(xlimit+StopLoss*SetPoint,(int)digits);
               slstop =NormalizeDouble(xstop+StopLoss*SetPoint,(int)digits);
               tplimit =NormalizeDouble(xlimit-TakeProfit*SetPoint,(int)digits)-(tpx2*TS);
               tpstop =NormalizeDouble(xstop-TakeProfit*SetPoint,(int)digits)-(tpx2*TS);
               if(fibotp==yes)
                  sl=NormalizeDouble(R3x,(int)digits);
               if(fibotp==yes)
                  tpx=NormalizeDouble(S3x,(int)digits);
               if(fibotp==yes && R3x == 0)
                  sl=NormalizeDouble(MarketInfo(symbol,MODE_BID)+StopLoss*SetPoint,(int)digits);
               if(fibotp==yes && S3x == 0)
                  tpx=NormalizeDouble(MarketInfo(symbol,MODE_BID)-TakeProfit*SetPoint,(int)digits)-(tpx2*TS);
               if(TS>0)
                 {
                  TradingLots=SubLots;
                 }


               Os=false;
               int kk=10;
               while(!Os && kk>=0)
                 {
                  switch(caraop)
                    {
                     case instan:
                        Os=OrderSend(symbol,OP_SELL,TradingLots,SymbolInfoDouble(symbol,SYMBOL_BID),1,sl,tpx,eacomment+" # "+IntegerToString(TSa),Magic,0,clrGreen);
                        break;
                     case stop:
                        Os=OrderSend(symbol,OP_SELLSTOP,TradingLots,xstop,1,slstop,tpstop,eacomment+" # "+IntegerToString(TSa),Magic,expr,clrGreen);
                        break;
                     case limit:
                        Os=OrderSend(symbol,OP_SELLLIMIT,TradingLots,xlimit,1,slimit,tplimit,eacomment+" # "+IntegerToString(TSa),Magic,expr,clrGreen);
                        break;
                    }

                  kk--;
                 }
               //if(caraop == instan) Os=OrderSend(symbol,OP_SELL,TradingLots,ask,1,sl,tpx,eacomment+" # "+IntegerToString(TSa),Magic,0,clrGreen);
               //if(caraop == stop)   Os=OrderSend(symbol,OP_SELLSTOP,TradingLots,xstop,1,slstop,tpstop,eacomment+" # "+IntegerToString(TSa),Magic,expr,clrGreen);
               //if(caraop == limit)  Os=OrderSend(symbol,OP_SELLLIMIT,TradingLots,xlimit,1,slimit,tplimit,eacomment+" # "+IntegerToString(TSa),Magic,expr,clrGreen);
              }

           }

        }


     }
   Sleep(100);

  }
////////////////////////////////////////////////////////////////////////
void timelockaction(void)
  {
   if(TradeDays())
      return;

   double stoplevel=0,proffit=0,newsl=0,price=0;
   double ask=0,bid=0;
   string sy=NULL;
   int sy_digits=0;
   double sy_points=0;
   bool ans=false;
   bool next=false;
   int otype=-1;
   int kk=0;

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderMagicNumber()!=Magic)
         continue;
      next=false;
      ans=false;
      sy=OrderSymbol();
      ask=SymbolInfoDouble(sy,SYMBOL_ASK);
      bid=SymbolInfoDouble(sy,SYMBOL_BID);
      sy_digits=(int)SymbolInfoInteger(sy,SYMBOL_DIGITS);
      sy_points=SymbolInfoDouble(sy,SYMBOL_POINT);
      stoplevel=MarketInfo(sy, MODE_STOPLEVEL)*sy_points;
      otype=OrderType();
      kk=0;
      proffit=OrderProfit()+OrderSwap()+OrderCommission();
      newsl=OrderOpenPrice();

      switch(EA_TIME_LOCK_ACTION)
        {
         case closeall:
            if(otype>1)
              {
               while(kk<5 && !OrderDelete(OrderTicket()))
                 {
                  kk++;
                 }
              }
            else
              {
               price=(otype==OP_BUY)?bid:ask;
               while(kk<5 && !OrderClose(OrderTicket(),OrderLots(),price,10))
                 {
                  kk++;
                  price=(otype==OP_BUY)?SymbolInfoDouble(sy,SYMBOL_BID):SymbolInfoDouble(sy,SYMBOL_ASK);
                 }
              }
            break;
         case closeprofit:
            if(proffit<=0)
               break;
            else
              {
               price=(otype==OP_BUY)?bid:ask;
               while(otype<2 && kk<5 && !OrderClose(OrderTicket(),OrderLots(),price,10))
                 {
                  kk++;
                  price=(otype==OP_BUY)?SymbolInfoDouble(sy,SYMBOL_BID):SymbolInfoDouble(sy,SYMBOL_ASK);
                 }
              }
            break;
         case breakevenprofit:
            if(proffit<=0)
               break;
            else
              {
               price=(otype==OP_BUY)?bid:ask;
               while(otype<2 && kk<5 && MathAbs(price-newsl)>=stoplevel && !OrderModify(OrderTicket(),newsl,newsl,OrderTakeProfit(),OrderExpiration()))
                 {
                  kk++;
                  price=(otype==OP_BUY)?SymbolInfoDouble(sy,SYMBOL_BID):SymbolInfoDouble(sy,SYMBOL_ASK);
                 }
              }
            break;

        }
      continue;
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SymbolNumOfSymbol(string symbol)
  {
   for(int i = 0; i < NumOfSymbols; i++)
     {
      if(symbol==simbolbaru[i]+postfix)
         return(i);
     }
   return(-1);
  }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////







//+------------------------------------------------------------------+
