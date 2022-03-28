//+------------------------------------------------------------------+
//|                                   Copyright 2022, Yousuf Mesalm. |
//|                                    https://www.Yousuf-mesalm.com |
//+------------------------------------------------------------------+
#property link "https://www.Yousuf-mesalm.com"
#property description "Developed by Yousuf Mesalm"
#property description "https://www.Yousuf-mesalm.com"
#property description "https://www.mql5.com/en/users/20163440"
#define Copyright          "Copyright 2022, Yousuf Mesalm."
#property copyright Copyright
#define Link               "https://www.mql5.com/en/users/20163440"
#property link Link
#define Version            "1.00"
#property version Version
#property strict
#property description Link
//Define
#define SEPARATOR "________________"
#define TOTAL_OpenOrExit 2

//---
#define INAME     "FFC"
#define TITLE     0
#define COUNTRY   1
#define DATE      2
#define TIME      3
#define IMPACT    4
#define FORECAST  5
#define PREVIOUS  6
// defination
#define  NL "\n"
#define ExpertName         "Solid EA"
#define OBJPREFIX          "YM - "
//---
#define CLIENT_BG_WIDTH    700
#define INDENT_TOP         15
//---
#define OPENPRICE          0
#define CLOSEPRICE         1
//---
#define OP_ALL            -1
//---
#define KEY_UP             38
#define KEY_DOWN           40


//includes
#include <YM\Utilities\Utilities.mqh>
#include <YM\EXecute\EXecute.mqh>
#include <YM\Position\Position.mqh>
#include <YM\Order\Order.mqh>
#include  <YM\HistoryPosition\HistoryPosition.mqh>
#import "urlmon.dll"
int URLDownloadToFileW(int pCaller,string szURL,string szFileName,int dwReserved,int Callback);
#import
// includes
#include <Telegram.mqh>
//enumeration
enum indi
  {
   off = 0,
// OFF
   beast = 1,
// Beast
   triger = 2,
// Triger
   uni = 3,
// Uni Cross
   zigzag = 4,
// Zig Zag
   HMA = 5,
// HMA
   HMATreend = 6,
//HMa Trend
  };

enum ENUM_UNIT
  {
   InPips,
// SL in pips
   InDollars // SL in dollars
  };

enum profittype
  {
   InDollarsProfit = 0, //In Dollars
   InPercentProfit = 1, // In Percent
   InPipsProfit         =2
  };

enum losstype
  {
   InDollarsLoss = 0,// In sollars
   InPercentLoss = 1, // In Percent
   InPipsLoss       =2,
  };

enum signaltype
  {
   IntraBar = 0,
// Intrabar
   ClosedCandle = 1 // On new bar
  };

enum inditrend
  {
   withtrend = 0,
// With Trend
   changetrend = 1 // Change Trend
  };

enum Strategy_Type
  {
   single = 0,
//Single Strategy
   seperate = 1,
// Seperate Strategy
   join = 2 // Join Strategy
  };
enum trademode
  {
   Auto = 0,
// Auto
   Manual = 1,
// Manual
   Telegram = 2,
// Telegram
   None // None
  };
enum typeorder
  {
   buyx = 0,
// Buy Only
   sellx = 1,
// Sell Only
   bothx = 2 // Both
  };
enum execute
  {
   instan = 0,
// Market Price
   limit = 1,
// Limit Order
   stop = 2 // Stop Order
  };
enum caraclose
  {
   opposite = 0,
// Indicator Reversal Signal
   sltp = 1,
// Take Profit and Stop Loss
   bar = 2,
// Close With N Bar
   date = 3 // Close With Date
  };
enum periodtf
  {
//   Current = 0,                                 // Current Period
   M1 = 1,
// 1 Minutes
   M5 = 5,
// 5 Minutes
   M15 = 15,
// 15 Minutes
   M30 = 30,
// 30 Minutes
   H1 = 60,
// 1 Hour
   H4 = 240,
// 4 Hours
   D1 = 1440,
// 1 Day
   W1 = 10080,
// 1 Week
   MN1 = 43200 // 1 Month
  };
enum ENUM_CROSSING_MODE
  {
   T3CrossingSnake,
   SnakeCrossingT3
  };


enum DYS_WEEK
  {
   Sunday = 0,
   Monday = 1,
   Tuesday = 2,
   Wednesday,
   Thursday = 4,
   Friday = 5,
   Saturday
  };

enum TIME_LOCK
  {
   closeall,
//CLOSE_ALL_TRADES
   closeprofit,
//CLOSE_ALL_PROFIT_TRADES
   breakevenprofit//MOVE_PROFIT_TRADES_TO_BREAKEVEN
  };

enum md
  {
   nm = 0,
//NORMAL
   rf = 1,
//REVERSE
  };
enum closeStrategy
  {
   singleClose,
   joinClose,
  };

enum ENUM_TF
  {
   DAILY/*Daily*/,
   WEEKLY/*Weekly*/,
   MONTHLY/*Monthly*/
  };
enum ENUM_MODE
  {
   FULL/*Full*/,
   COMPACT/*Compact*/,
   MINI/*Mini*/
  };


string EA_Name = "TFM EA v1.00";

//User Input
input string h0 = "========General===========";
input int MT4account = 1234567; // MT4 Number/ Pascode
input string EAPass = ""; // EA PassWord
input trademode usemode = Auto; // Trade Mode
input typeorder Trade_Direction = bothx; // Trade Direction
input bool Show_Trading_Session = false;
input execute Execution_Mode = instan; //Order Execution Mode
input int orderdistance = 30; //Order Distance
input bool delete_Pending = false; //Delete Pending Order
input int Bars_to_Delete_Pending=0; // Number of Bars to delete Pending
input trademode commentselect = Auto; // Comment
input string comment = "YM"; // Auto Comment
input string Prefix = ""; //Symbol Prefix
input string Suffix = ""; //Symbol Suffix
input string TradeSymbols = "AUDCAD;AUDCHF;AUDJPY;AUDNZD;AUDUSD;CADCHF"; /*Symbol List (separated by " ; ")*/
extern bool ShowDashboard = true;
input ENUM_MODE SelectedMode = COMPACT; /*Dashboard (Size)*/
input bool Skip = false; //Skip Initial signals
input int magic_Number = 2222; // magic_Number Number


input string h1 = "================Time Management System ========================";
input bool SET_TRADING_DAYS = false;
input DYS_WEEK EA_START_DAY = Sunday;
input string EA_START_TIME = "22:00";
input DYS_WEEK EA_STOP_DAY = Friday;
input string EA_STOP_TIME = "22:00";

input TIME_LOCK EA_TIME_LOCK_ACTION = closeall;
input Strategy_Type Strategy = single; //Strategy
input string Master1 = "====================Open Indicator I======================"; //==== Master Indicator_I=====
input indi indikator1 = uni; //Select desire Indicator from installed indicators Also This is Master
input ENUM_TIMEFRAMES timeframe1 = PERIOD_D1; // Entry Time Frame
string comment1 = "B_M30"; //Comment
extern int shift1 = 1; //Bar shift

input string Slave2 = "=====Open Indicator 2====="; //====Slave Indicator_2=====
input indi indikator2 = uni; //Select desire Indicator from installed indicators Also This is Master
input ENUM_TIMEFRAMES timeframe2 = PERIOD_M30; // Entry Time Frame
string comment2 = "B_H1"; //Comment
extern int shift2 = 1; //Bar shift

input string Slave3 = "=====Open Indicator 3====="; //====Entry Slave Indicator_3=====
input indi indikator3 = off; //Select desire Indicator from installed indicators Also This is Master
input ENUM_TIMEFRAMES timeframe3 = PERIOD_M30; // Entry Time Frame_1
string comment3 = "Z_H1"; //Comment
extern int shift3 = 1; //Bar shift

input string Slave4 = "=====Open Indicator 4====="; //====Entry Slave Indicator_4=====
input indi indikator4 = off; //Select desire Indicator from installed indicators Also This is Master
input ENUM_TIMEFRAMES timeframe4 = PERIOD_M30; // Entry Time Frame_1
string comment4 = "F_H1"; //Comment
extern int shift4 = 1; //Bar shift

input caraclose closetype = opposite; //Choose Closing Type
input closeStrategy close_Strategy = singleClose;
input string strategy1x = "=====Exit Indicator 1====="; //====Exit Strategy Indicator_1=====
input indi indikator1x = uni; //Select desire Indicator from installed indicators Also This is Master
input ENUM_TIMEFRAMES timeframe1x = PERIOD_M30; // Entry Time Frame_1

input string strategy2x = "=====Exit Indicator 2====="; //====Exit Strategy Indicator_2=====
input indi indikator2x = zigzag; //Select desire Indicator from installed indicators Also This is Master
input ENUM_TIMEFRAMES timeframe2x = PERIOD_M30; // Entry Time Frame_1

input string h2 = "============Money Management========";
input double Lots = 0.05; //First Lots
input double SubLots = 0.03; //Sub Lots
input double Risk = 10; // Risk Percent
input bool MM = false; // Use Optimal Lot Size
input string h4 = "=============TP and SL ===============";
input double TakeProfit = 100; // Take Profit (inPips)
input bool useAuto_TP = true;
input double StopLoss = 50; // Stop Loss (inPips)
input bool useAuto_SL = true;
input double TakeProfit1 = 30; // Distance TP 2 (inPips)


input int minbalance = 500; //Min Euquity Bal to open Trade
input int maxbuy = 40; //Max allowed Buy Trade
input int maxsell = 40; //Max Allowed Sell Trade
input int MaxLevel = 2; //Max Open Trade
input int Max_Spread = 25; // MaxSpread
input bool BarBaru = false; //Open New Bar Indicator

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int orderexp = 3; //Pending order Experation (inBars)
input profittype Profit_Type= InDollarsProfit;
input double ProfitValue = 30.0; //Maximum Profit in %
input losstype LossType = InDollarsLoss; // Loss Type
input double LossValue = 70; // Max Loss Limit (%)

input bool fibotp = false; // Use Fibo TP
input bool showfibo = TRUE; // Show SnR Fibo Line

input int GMTshift = 3; //GMT Shift Fibo SnR
input string ___TRADE_MONITORING_SETTINGS___ = SEPARATOR; //=== Trade Monitoring Settings ===
input bool UsePartialClose = true; // Use Partial Close
input ENUM_UNIT PartialCloseUnit = InPips; // Partial Close Unit
input double PartialCloseTrigger = 40; // Partial Close after
input double PartialClosePercent = 0.5; // Percentage of lot size to close
input int MaxNoPartialClose = 1; // Max No of Partial Close
input string ___TRADE_MONITORING_TRAILING___ = ""; // - Trailing Stop Parameters
input bool UseTrailingStop = true; // Use Trailing Stop
input ENUM_UNIT TrailingUnit = InPips; // Trailing Unit
input double TrailingStart = 35; // Trailing Activated After
input double TrailingStep = 10; // Trailing Step
input double TrailingStop = 2; // Trailing Stop
input string ___TRADE_MONITORING_BE_________ = ""; // - Break Even Parameters
input bool UseBreakEven = true; // Use Break Even
input ENUM_UNIT BreakEvenUnit = InPips; // Break Even Unit
input double BreakEvenTrigger = 30; // Break Even Trigger
input double BreakEvenProfit = 1; // Break Even Profit
input int MaxNoBreakEven = 1; // Max No of Break Even
input string ___DEBUG_____ = SEPARATOR; //=== DEBUG Settings ===
input bool DebugTrailingStop = true; // Trailing Stop Infos in Journal
input bool DebugBreakEven = true; // Break Even Infos in Journal
input bool DebugUnit = true; // SL TP Trail BE Units Infos in Journal (in tester)
input bool DebugPartialClose = true; // Partial close Infos in Journal


// Telegram
input string h3 = "===================telegram=================";
input bool useTel = true; // Use Telegram Alerts
input string InpChannelName = "EurusdMaster"; // Telegram Channel ID
input string InpToken = "2043876400:AAEMW9M249adjW7vVgcFBsP-4WoCPx81Q74"; // Telegram Token
input bool sendnews = true; //Send News Alert
input bool sendorder = true; //Send Trade Order
input bool sendclose = true; //Send Close Order
input bool sendsignal = true; //Send Single Indicator Signal
input bool sendTradesignal = true; //Send Strategy Trade Signal

input string BEAST_SETTINGS = "======================Beast Indicator Settings================";
input int BEAST_Depth = 60;
input int BEAST_Deviation = 5;
input int BEAST_BackStep = 4;
input int BEAST_StochasticLen = 7;
input double BEAST_StochasticFilter = 0;
input double BEAST_OverBoughtLevel = 70;
input double BEAST_OverSoldLevel = 40;
input int BEAST_MATrendLinePeriod = 10;
input ENUM_MA_METHOD BEAST_MATrendLineMethod = MODE_SMA;
input ENUM_APPLIED_PRICE BEAST_MATrendLinePrice = PRICE_CLOSE;
input int BEAST_MAPerod = 15;
input int BEAST_MAShift = 0;
input ENUM_MA_METHOD BEAST_MAMethod = MODE_SMA;
input ENUM_APPLIED_PRICE BEAST_MAPrice = PRICE_CLOSE;
input bool BEAST_alert = false;
input bool BEAST_push = false;
input bool BEAST_mail = false;
input int BEAST_arrow = 50;
input string TRIGGERLINES_SETTINGS = "=================Triger Settings ========================";
input int TRIGGERLINES_Rperiod = 15;
input int TRIGGERLINES_LSMA_Period = 5;
input string induniSett = "======================= Unicross Settings =========================="; //+++++++ Unicross Settings +++++++
input int T3Period = 14; // T3 Period
input ENUM_APPLIED_PRICE T3Price = PRICE_CLOSE; // T3 Source
input double B_Factor = 0.618; // T3 b Factor
input int Snake_HalfCycle = 5; // Snake_HalfCycle = 4...10 or other
input bool UseSound = false;
input bool UseAlert = false;
input bool TypeChart = false;
input string NameFileSound = "alert.wav";
input ENUM_CROSSING_MODE Inverse = T3CrossingSnake; // 0=T3 crossing Snake, 1=Snake crossing T3
input int DeltaForSell = 0; // Delta for sell signal
input int DeltaForBuy = 0; // Delta for buy signal
double ArrowOffset = 0.5; // Arrow vertical offset
int Maxbars = 500; // Lookback
input string       ZIGZAG_SETTINGS = "================Zigzag Indicator Settings ==========";
input int          ZIGZAG_Depth = 62;
input int          ZIGZAG_Deviation = 15;
input int          ZIGZAG_BackStep = 9;


//-------------------------------------------- EXTERNAL VARIABLE ---------------------------------------------
//------------------------------------------------------------------------------------------------------------
extern bool    ReportActive      = false;                // Report for active chart only (override other inputs)
extern bool    IncludeHigh       = true;                 // Include high
extern bool    IncludeMedium     = true;                 // Include medium
extern bool    IncludeLow        = true;                 // Include low
extern bool    IncludeSpeaks     = true;                 // Include speaks
extern bool    IncludeHolidays   = false;                // Include holidays
extern string  FindKeyword       = "";                   // Find keyword
extern string  IgnoreKeyword     = "";                   // Ignore keyword
extern bool    AllowUpdates      = true;                 // Allow updates
extern int     UpdateHour        = 4;                    // Update every (in hours)
input string   lb_0              = "";                   // ------------------------------------------------------------
input string   lb_1              = "";                   // ------> PANEL SETTINGS
extern bool    ShowPanel         = true;                 // Show panel
bool            AllowSubwindow    = false;                // Show Panel in sub window
extern ENUM_BASE_CORNER Corner   = 2;                    // Panel side
extern string  PanelTitle="Forex Calendar @ Forex Factory"; // Panel title
extern color   TitleColor        = C'46,188,46';         // Title color
extern bool    ShowPanelBG       = true;                 // Show panel backgroud
extern color   Pbgc              = C'25,25,25';          // Panel backgroud color
extern color   LowImpactColor    = C'91,192,222';        // Low impact color
extern color   MediumImpactColor = C'255,185,83';        // Medium impact color
extern color   HighImpactColor   = C'217,83,79';         // High impact color
extern color   HolidayColor      = clrOrchid;            // Holidays color
extern color   RemarksColor      = clrGray;              // Remarks color
extern color   PreviousColor     = C'170,170,170';       // Forecast color
extern color   PositiveColor     = C'46,188,46';         // Positive forecast color
extern color   NegativeColor     = clrTomato;            // Negative forecast color
extern bool    ShowVerticalNews  = true;                 // Show vertical lines
extern int     ChartTimeOffset   = 0;                    // Chart time offset (in hours)
extern int     EventDisplay      = 10;                   // Hide event after (in minutes)
input string   lb_2              = "";                   // ------------------------------------------------------------
input string   lb_3              = "";                   // ------> SYMBOL SETTINGS
extern bool    ReportForUSD      = true;                 // Report for USD
extern bool    ReportForEUR      = true;                 // Report for EUR
extern bool    ReportForGBP      = true;                 // Report for GBP
extern bool    ReportForNZD      = true;                 // Report for NZD
extern bool    ReportForJPY      = true;                 // Report for JPY
extern bool    ReportForAUD      = true;                 // Report for AUD
extern bool    ReportForCHF      = true;                 // Report for CHF
extern bool    ReportForCAD      = true;                 // Report for CAD
extern bool    ReportForCNY      = false;                // Report for CNY
input string   lb_4              = "";                   // ------------------------------------------------------------
input string   lb_5              = "";                   // ------> INFO SETTINGS
extern bool    ShowInfo          = true;                 // Show Symbol info ( Strength / Bar Time / Spread )
extern color   InfoColor         = C'255,185,83';        // Info color
extern int     InfoFontSize      = 8;                    // Info font size
input string   lb_6              = "";                   // ------------------------------------------------------------
input string   lb_7              = "";                   // ------> NOTIFICATION
input string   lb_8              = "";                   // *Note: Set (-1) to disable the Alert
extern int     Alert1Minutes     = 30;                   // Minutes before first Alert
extern int     Alert2Minutes     = -1;                   // Minutes before second Alert
extern bool    PopupAlerts       = false;                // Popup Alerts
extern bool    SoundAlerts       = true;                 // Sound Alerts
extern string  AlertSoundFile    = "news.wav";           // Sound file name
extern bool    EmailAlerts       = false;                // Send email
extern bool    NotificationAlerts= false;                // Send push notification
input bool     AvoidNews         = FALSE;                // News Filter
input bool     CloseBeforNews    = FALSE;                // Close and Stop Order Before News
input int      AfterNewsStop     = 60;                   // Stop Trading Before News Release (in Minutes)
input int      BeforeNewsStop    = 60;                   // Start Trading After News Release (in Minutes)

//input bool     snr           = TRUE;           //Use Support & Resistance
periodtf snrperiod = D1; //Support & Resistance Time Frame


bool KeyboardTrading = true; /*Keyboard Trading*/
input string h6      = "============================= Graphics ==========================";
input color COLOR_BORDER = C'255, 151, 25'; /*Panel Border*/
input color COLOR_CBG_LIGHT = C'252, 252, 252'; /*Chart Background (Light)*/
input color COLOR_CBG_DARK = C'28, 27, 26'; /*Chart Background (Dark)*/
//--- Global variables
string sTradeSymbols = TradeSymbols;
string sFontType = "";
//---
double RiskP = 0;
double RiskC = 0;
double RiskInpC = 0;
double RiskInpP = 0;
//---
int ResetAlertUp = 0;
int ResetAlertDwn = 0;
bool UserIsEditing = false;
bool UserWasNotified = false;
//---
double StopLossDist = 0;
double RiskInp = 0;
double RR = 0;
double _TP = 0;
//---
int SelectedTheme = 0;
int PriceRowLeft = 0;
int PriceRowRight = 0;
//---
int ErrorInterval = 300;
int LastReason = 0;
string ErrorSound = "error.wav";
bool SoundIsEnabled = false;
bool AlarmIsEnabled = false;
int ProfitMode = 0;
//---
bool AUDAlarm = true;
bool CADAlarm = true;
bool CHFAlarm = true;
bool EURAlarm = true;
bool GBPAlarm = true;
bool JPYAlarm = true;
bool NZDAlarm = true;
bool USDAlarm = true;
//---
bool AUDTrigger = false;
bool CADTrigger = false;
bool CHFTrigger = false;
bool EURTrigger = false;
bool GBPTrigger = false;
bool JPYTrigger = false;
bool NZDTrigger = false;
bool USDTrigger = false;
//----
string SuggestedPair = "";
int LastTimeFrame = 0;
int LastMode = -1;
//---
bool AutoSL = false;
bool AutoTP = false;
bool AutoLots = false;
bool ClearedTemplate = false;
bool FirstRun = true;
//---
color COLOR_BG = clrNONE;
color COLOR_FONT = clrNONE;
//---
color COLOR_GREEN = clrForestGreen;
color COLOR_RED = clrFireBrick;
color COLOR_SELL = C'225, 68, 29';
color COLOR_BUY = C'3, 95, 172';
color COLOR_CLOSE = clrNONE;
color COLOR_AUTO = clrDodgerBlue;
color COLOR_LOW = clrNONE;
color COLOR_MARKER = clrNONE;
int FONTSIZE = 9;
//---
int _x1 = 0;
int _y1 = 0;
int ChartX = 0;
int ChartY = 0;
int Chart_XSize = 0;
int Chart_YSize = 0;
int CalcTF = 0;
datetime drop_time = 0;
datetime stauts_time = 0;
//---
color COLOR_REGBG = C'27, 27, 27';
color COLOR_REGFONT = clrSilver;
//---
int Bck_Win_X = 255;
int Bck_Win_Y = 150;
//---
string aSymbols[];
string UsedSymbols[];
//---
string MB_CAPTION = ExpertName+" v"+Version+" | "+Copyright;

//---
// Arrays
string Symbols[];
int MasterSignal[] ;
int Signal4[];
int Signal2[];
int Signal3[];
int exit1[];
int exit2[];
string cc0 = "";
bool MaxSellExceed=false;
bool MaxBuyExceed=false;
datetime startTime=0;
datetime lastorder_close=0;
string PriceRowLeftArr[]= {"Bid","Low","Open","Pivot"};
string PriceRowRightArr[]= {"Ask","High","Open","Pivot"};

//news
//--- Vars and arrays
string xmlFileName;
string sData;
string Event[200][7];
string eTitle[10],eCountry[10],eImpact[10],eForecast[10],ePrevious[10];
int eMinutes[10];
datetime eTime[10];
double MinuteBuffer[200];
double ImpactBuffer[200];
int anchor,x0,x1,x2,xf,xp;
int Factor;
//--- Alert
bool FirstAlert;
bool SecondAlert;
datetime AlertTime;
//--- time
datetime xmlModifed;
int TimeOfDay;
datetime Midnight;
bool IsEvent;

// Class object
CExecute *trades[];
CPosition *Positions[];
CPosition *SellPositions[];
CPosition *BuyPositions[];
COrder *Pendings[];
COrder *SellPendings[];
COrder *BuyPendings[];
CUtilities *tools[];
CHistoryPosition *Hist[];


//telegram bot class
//+------------------------------------------------------------------+
//|   CMyBot                                                         |
//+------------------------------------------------------------------+
class CMyBot: public CCustomBot
  {
private:
   string            m_button[35];
public:
   //+------------------------------------------------------------------+
   void              CMyBot::CMyBot(void) {}

   //+------------------------------------------------------------------+
   void              ProcessMessages(string update)
     {
      if(cc0 != "")
        {
         int res = bot.SendMessage(InpChannelName, cc0, false, false);
         if(res != 0)
            Print("Error: ", GetErrorDescription(res));
         else
            cc0 = "";
        }
     }
  };
CMyBot bot;
int getme_result;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- check for DLL
   if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED))
     {
      Alert(INAME+": Please Allow DLL Imports!");
      return(INIT_FAILED);
     }
//--- 4/5 digit brokers
   if(Digits%2==1)
      Factor=10;
   else
      Factor=1;
//--- get today time
   TimeOfDay=(int)TimeLocal()%86400;
   Midnight=TimeLocal()-TimeOfDay;
//--- set xml file name ffcal_week_this (fixed name)
   xmlFileName=INAME+"-ffcal_week_this.xml";
//--- checks the existence of the file.
   if(!FileIsExist(xmlFileName))
     {
      xmlDownload();
      xmlRead();
     }
//--- else just read it
   else
      xmlRead();
//--- get last modification time
   xmlModifed=(datetime)FileGetInteger(xmlFileName,FILE_MODIFY_DATE,false);
//--- check for updates
   if(AllowUpdates)
     {
      if(xmlModifed<TimeLocal()-(UpdateHour*3600))
        {
         Print(INAME+": xml file is out of date");
         xmlUpdate();
        }
      //--- set timer to update old xml file every x hours
      else
         EventSetTimer(UpdateHour*3600);
     }
//--- set panel corner
   switch(Corner)
     {
      case CORNER_LEFT_UPPER:
         x0=5;
         x1=165;
         x2=15;
         xf=340;
         xp=390;
         anchor=0;
         break;
      case CORNER_RIGHT_UPPER:
         x0=455;
         x1=265;
         x2=440;
         xf=110;
         xp=60;
         anchor=0;
         break;
      case CORNER_RIGHT_LOWER:
         x0=455;
         x1=265;
         x2=440;
         xf=110;
         xp=60;
         anchor=2;
         break;
      case CORNER_LEFT_LOWER:
         x0=5;
         x1=165;
         x2=15;
         xf=340;
         xp=390;
         anchor=2;
         break;
     }

   if(useTel)
     {
      //--- set token
      bot.Token(InpToken);
      //--- check token
      getme_result = bot.GetMe();
     }
   startTime=TimeCurrent();
//--- Disclaimer
   if(!GlobalVariableCheck(OBJPREFIX+"Disclaimer") || GlobalVariableGet(OBJPREFIX+"Disclaimer") != 1)
     {
      //---
      string message = "DISCLAIMER:\n\n Hello ";
      //---
      if(MessageBox(message, MB_CAPTION, MB_OKCANCEL|MB_ICONWARNING) == IDOK)
         GlobalVariableSet(OBJPREFIX+"Disclaimer", 1);

     }

//---
   if(!GlobalVariableCheck(OBJPREFIX+"Theme"))
      SelectedTheme = 1;
   else
      SelectedTheme = (int)GlobalVariableGet(OBJPREFIX+"Theme");

//---
   if(SelectedTheme == 0)
     {
      COLOR_BG = C'240,240,240';
      COLOR_FONT = C'40,41,59';
      COLOR_GREEN = clrForestGreen;
      COLOR_RED = clrIndianRed;
      COLOR_LOW = clrGoldenrod;
      COLOR_MARKER = clrDarkOrange;
     }
   else
     {
      COLOR_BG = C'28,28,28';
      COLOR_FONT = clrSilver;
      COLOR_GREEN = clrLimeGreen;
      COLOR_RED = clrRed;
      COLOR_LOW = clrYellow;
      COLOR_MARKER = clrGold;
     }

//---
   if(LastReason == 0)
     {
      //--- OfflineChart
      if(ChartGetInteger(0, CHART_IS_OFFLINE))
        {
         MessageBox("The currenct chart is offline, make sure to uncheck \"Offline chart\" under Properties(F8)->Common.",
                    MB_CAPTION, MB_OK|MB_ICONERROR);

        }

      //--- CheckConnection
      if(!TerminalInfoInteger(TERMINAL_CONNECTED))
         MessageBox("Warning: No Internet connection found!\nPlease check your network connection.",
                    MB_CAPTION+" | "+"#"+IntegerToString(123), MB_OK|MB_ICONWARNING);

      //--- CheckTradingIsAllowed
      if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))//Terminal
        {
         MessageBox("Warning: Check if automated trading is allowed in the terminal settings!",
                    MB_CAPTION+" | "+"#"+IntegerToString(123), MB_OK|MB_ICONWARNING);
        }
      else
        {
         if(!MQLInfoInteger(MQL_TRADE_ALLOWED))//CheckBox
           {
            MessageBox("Warning: Automated trading is forbidden in the program settings for "+__FILE__,
                       MB_CAPTION+" | "+"#"+IntegerToString(123), MB_OK|MB_ICONWARNING);
           }
        }

      //---
      if(!AccountInfoInteger(ACCOUNT_TRADE_EXPERT))//Server
         MessageBox("Warning: Automated trading is forbidden for the account "+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+" at the trade server side.",
                    MB_CAPTION+" | "+"#"+IntegerToString(123), MB_OK|MB_ICONWARNING);

      //---
      if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))//Investor
         MessageBox("Warning: Trading is forbidden for the account "+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"."+
                    "\n\nPerhaps an investor password has been used to connect to the trading account."+
                    "\n\nCheck the terminal journal for the following entry:"+
                    "\n\'"+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"\': trading has been disabled - investor mode.",
                    MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED), MB_OK|MB_ICONWARNING);

      //---
      if(!SymbolInfoInteger(_Symbol, SYMBOL_TRADE_MODE))//Symbol
         MessageBox("Warning: Trading is disabled for the symbol "+_Symbol+" at the trade server side.",
                    MB_CAPTION+" | "+"#"+IntegerToString(ERR_TRADE_DISABLED), MB_OK|MB_ICONWARNING);

      //--- CheckDotsPerInch
      if(TerminalInfoInteger(TERMINAL_SCREEN_DPI) != 96)
        {
         Comment("Warning: 96 DPI highly recommended !");
         Sleep(3000);
         Comment("");
        }

     }

//--- Check for Symbols (Analysis)
   for(int i = 0; i < ArraySize(Symbols); i++)
     {
      SymbolSelect(Prefix+Symbols[i]+Suffix, true);
     }

//--- Input Symbols Changed
   if(sTradeSymbols != TradeSymbols || LastReason == 0)
     {
      //---
      ArrayResize(aSymbols, 0, 0);
      ObjectsDeleteAll(0, OBJPREFIX, -1, -1);
      //--- Get Trade Symobols
      if(StringFind(TradeSymbols, ";", 0) == -1)
        {
         //---
         string message = "No separator found !\nMake sure to separate symbols with a semicolon \" ; \".";
         //---
         MessageBox(message, MB_CAPTION, MB_OK|MB_ICONERROR);
         Comment(message);
         //---
         ObjectsDeleteAll(0, OBJPREFIX, -1, -1);
        }
      StringSplit(TradeSymbols, StringGetCharacter(";", 0), Symbols);
      int size = ArraySize(Symbols);
      ArrayResize(trades, size, size);
      ArrayResize(tools, size, size);

      ArrayResize(Positions, size, size);
      ArrayResize(SellPositions, size, size);
      ArrayResize(BuyPositions, size, size);
      ArrayResize(Pendings, size, size);
      ArrayResize(BuyPendings, size, size);
      ArrayResize(SellPendings, size, size);
      ArrayResize(MasterSignal,size,size);
      ArrayResize(Signal2,size,size);
      ArrayResize(Signal3,size,size);
      ArrayResize(Signal4,size,size);
      ArrayResize(exit1,size,size);
      ArrayResize(exit2,size,size);
      ArrayResize(Hist,size,size);
      for(int i = 0; i < size; i++)
        {
         Symbols[i] = Prefix+Symbols[i]+Suffix;
         if(SymbolSelect(Symbols[i], true))
           {
            Print(Symbols[i]+" added to Market watch");
           }



         trades[i] = new CExecute(Symbols[i], magic_Number);
         BuyPositions[i] = new CPosition(Symbols[i], magic_Number, GROUP_POSITIONS_BUYS);
         SellPositions[i] = new CPosition(Symbols[i], magic_Number, GROUP_POSITIONS_SELLS);
         Positions[i] = new CPosition(Symbols[i], magic_Number, GROUP_POSITIONS_ALL);
         Pendings[i]=new COrder(Symbols[i],magic_Number,GROUP_ORDERS_ALL);
         BuyPendings[i]=new COrder(Symbols[i],magic_Number,GROUP_ORDERS_BUY_STOP);
         SellPendings[i]=new COrder(Symbols[i],magic_Number,GROUP_ORDERS_SELL_STOP);
         Hist[i]=new CHistoryPosition(Symbols[i],magic_Number,GROUP_HISTORY_POSITIONS_ALL);
         tools[i] = new CUtilities(Symbols[i]);
         MasterSignal[i]=0;
         Signal2[i]=0;
         Signal3[i]=0;
         Signal4[i]=0;
         exit1[i]=0;
         exit2[i]=0;
        }


     }
//--- CheckData
   if(TerminalInfoInteger(TERMINAL_CONNECTED) && (LastReason == 0 || LastReason == REASON_PARAMETERS))
     {
      //---
      ResetLastError();
      //---
      for(int i = 0; i < ArraySize(Symbols); i++)
        {
         //---
         double test = iHigh(Symbols[i], PERIOD_CURRENT, 0);
         //---
         if(test == 0)
           {
            //---
            for(int a = 0; a < 10; a++)
              {
               //---
               Comment("Loading Data...");
               Sleep(1);
               //---
               double _High = iHigh(Symbols[i], PERIOD_CURRENT, 0);
               double _Low = iLow(Symbols[i], PERIOD_CURRENT, 0);
               double _Close = iClose(Symbols[i], PERIOD_CURRENT, 0);
               //---
               double _Bid = SymbolInfoDouble(Symbols[i], SYMBOL_BID);
               double _Ask = SymbolInfoDouble(Symbols[i], SYMBOL_ASK);
               //---
               if(_High != 0 && _Low != 0 && _Close != 0 && _Bid != 0 && _Ask != 0)
                  break;
              }
           }
        }
      //---
      Comment("");
     }

//--- Init ChartSize
   Chart_XSize = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   Chart_YSize = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
   ChartX = Chart_XSize;
   ChartY = Chart_YSize;

//--- CheckSoundIsEnabled
   if(!GlobalVariableCheck(OBJPREFIX+"Sound"))
      SoundIsEnabled = true;
   else
      SoundIsEnabled = GlobalVariableGet(OBJPREFIX+"Sound");

//--- Alert
   if(!GlobalVariableCheck(OBJPREFIX+"Alarm"))
      AlarmIsEnabled = true;
   else
      AlarmIsEnabled = GlobalVariableGet(OBJPREFIX+"Alarm");



//---
   if(!GlobalVariableCheck(OBJPREFIX+"Dashboard"))
      ShowDashboard = true;
   else
      ShowDashboard = GlobalVariableGet(OBJPREFIX+"Dashboard");


//---
   PriceRowLeft = (int)GlobalVariableGet(OBJPREFIX+"PRL");
   PriceRowRight = (int)GlobalVariableGet(OBJPREFIX+"PRR");

//---
   if(LastReason == 0)
      ChartGetColor();

//--- Hide OneClick Arrow
   ChartSetInteger(0, CHART_SHOW_ONE_CLICK, true);
   ChartSetInteger(0, CHART_SHOW_ONE_CLICK, false);

//--- ChartChanged
   if(LastReason == REASON_CHARTCHANGE)
      _PlaySound("switch.wav");

//---
   if(ShowDashboard)
      ChartMouseScrollSet(false);
   else
      ChartMouseScrollSet(true);
//---
   if(SelectedMode != LastMode)
      ObjectsDeleteAll(0, OBJPREFIX, -1, -1);

//--- Init Speed Prices
   for(int i = ArraySize(Symbols)-1; i >= 0; i--)
      GlobalVariableSet(OBJPREFIX+Prefix+Symbols[i]+Suffix+" - Price", (SymbolInfoDouble(Prefix+Symbols[i]+Suffix, SYMBOL_ASK)+SymbolInfoDouble(Prefix+Symbols[i]+Suffix, SYMBOL_BID))/2);

//--- Animation
   if(LastReason == 0 && ShowDashboard)
     {
      //---
      ObjectsCreateAll();
      ObjectSetInteger(0, OBJPREFIX+"PRICEROW_Lª", OBJPROP_COLOR, clrNONE);
      ObjectSetInteger(0, OBJPREFIX+"PRICEROW_Rª", OBJPROP_COLOR, clrNONE);
      //---
      SetStatus("6", "Please wait...");


      //---

      //---
      ResetStatus();
      //---
     }

//---
   FirstRun = false;

//--- Dropped Time
   drop_time = TimeLocal();

//--- Border Color
   if(ShowDashboard)
     {
      //---
      if(ObjectFind(0, OBJPREFIX+"BORDER[]") == 0 || ObjectFind(0, OBJPREFIX+"BCKGRND[]") == 0)
        {
         //---
         if(ObjectGetInteger(0, OBJPREFIX+"BORDER[]", OBJPROP_COLOR) != COLOR_BORDER)
           {
            ObjectSetInteger(0, OBJPREFIX+"BORDER[]", OBJPROP_COLOR, COLOR_BORDER);
            ObjectSetInteger(0, OBJPREFIX+"BORDER[]", OBJPROP_BGCOLOR, COLOR_BORDER);
            ObjectSetInteger(0, OBJPREFIX+"BCKGRND[]", OBJPROP_COLOR, COLOR_BORDER);
           }
        }
     }
//---
   if(!ShowDashboard)
     {
      //---
      if(ObjectFind(0, OBJPREFIX+"MIN"+"BCKGRND[]") == 0)
        {
         //---
         if(ObjectGetInteger(0, OBJPREFIX+"MIN"+"BCKGRND[]", OBJPROP_COLOR) != COLOR_BORDER)
           {
            ObjectSetInteger(0, OBJPREFIX+"MIN"+"BCKGRND[]", OBJPROP_COLOR, COLOR_BORDER);
            ObjectSetInteger(0, OBJPREFIX+"MIN"+"BCKGRND[]", OBJPROP_BGCOLOR, COLOR_BORDER);
           }
        }
     }
   int size = ArraySize(Symbols);
// loop on all symbols
   for(int i = 0; i < size; i++)
     {
      // Delete Pending Orders After  Bars
      if(delete_Pending&&Bars_to_Delete_Pending>0)
         DeletePeblndingWithCandle(Pendings[i]);

      int mainSignal = 0;
      bool change=false;
      bool exitchange=false;
      if(indikator1 != off)
        {
         int m=initialSignal(indikator1, timeframe1, comment1, shift1, Symbols[i]);
         if(m!=MasterSignal[i]&&m!=0)
           {
            MasterSignal[i] = m;
            Print(MasterSignal[i]);
            change=true;
           }
        }
      if(indikator2 != off)
        {
         int s2=initialSignal(indikator2, timeframe2, comment2, shift2, Symbols[i]);
         if(s2!=Signal2[i]&&s2!=0)
           {
            Signal2[i] = s2;
            change=true;
           }
        }
      if(indikator3 != off)
        {
         int s3=initialSignal(indikator3, timeframe3, comment3, shift3, Symbols[i]);
         if(s3!=Signal3[i]&&s3!=0)
           {
            Signal3[i] =s3;
            change=true;
           }
        }
      if(indikator4 != off)
        {
         int s4=initialSignal(indikator4, timeframe4, comment4, shift4, Symbols[i]);
         if(s4!=Signal4[i]&&s4!=0)
           {
            Signal4[i] = s4;
            change=true;
           }
        }
      if(indikator1x != off)
        {
         int x1=initialSignal(indikator1x, timeframe1x, comment, 0, Symbols[i]);
         if(x1!=0&&x1!=exit1[i])
           {
            exit1[i] = x1;
            exitchange=true;
           }
        }
      if(indikator2x != off)
        {
         int x2=initialSignal(indikator2x, timeframe2x, comment4, 0, Symbols[i]);
         if(x2!=0&&x2!=exit2[i])
           {
            exit2[i] =x2 ;
            exitchange=true;
           }
        }
     }
   cc0 = "Started Successfuly!";
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer

   for(int i=ObjectsTotal(); i>=0; i--)
     {
      string name=ObjectName(i);
      if(StringFind(name,INAME)==0)
         ObjectDelete(name);
     }
//--- Kill update timer only if removed
   if(reason==1)
      EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   Telegram();
   if(showfibo)
      snrfibo();
   ClosingFilter();
   bool TradeAllow=TradeDays();
   if(TradeAllow)
     {
      int size = ArraySize(Symbols);
      // loop on all symbols
      for(int i = 0; i < size; i++)
        {
         // Delete Pending Orders After  Bars
         if(delete_Pending&&Bars_to_Delete_Pending>0)
            DeletePeblndingWithCandle(Pendings[i]);

         int mainSignal = 0;
         bool change=false;
         bool exitchange=false;
         if(indikator1 != off)
           {
            int m=GetIndicatorsSignal(indikator1, timeframe1, comment1, shift1, Symbols[i]);
            if(m!=MasterSignal[i]&&m!=0)
              {
               MasterSignal[i] = m;
               Print(MasterSignal[i]);
               change=true;
              }
           }
         if(indikator2 != off)
           {
            int s2=GetIndicatorsSignal(indikator2, timeframe2, comment2, shift2, Symbols[i]);
            if(s2!=Signal2[i]&&s2!=0)
              {
               Signal2[i] = s2;
               change=true;
              }
           }
         if(indikator3 != off)
           {
            int s3=GetIndicatorsSignal(indikator3, timeframe3, comment3, shift3, Symbols[i]);
            if(s3!=Signal3[i]&&s3!=0)
              {
               Signal3[i] =s3;
               change=true;
              }
           }
         if(indikator4 != off)
           {
            int s4=GetIndicatorsSignal(indikator4, timeframe4, comment4, shift4, Symbols[i]);
            if(s4!=Signal4[i]&&s4!=0)
              {
               Signal4[i] = s4;
               change=true;
              }
           }
         if(indikator1x != off)
           {
            int x1=GetIndicatorsSignal(indikator1x, timeframe1x, comment, 0, Symbols[i]);
            if(x1!=0&&x1!=exit1[i])
              {
               exit1[i] = x1;
               exitchange=true;
              }
           }
         if(indikator2x != off)
           {
            int x2=GetIndicatorsSignal(indikator2x, timeframe2x, comment4, 0, Symbols[i]);
            if(x2!=0&&x2!=exit2[i])
              {
               exit2[i] =x2 ;
               exitchange=true;
              }
           }
         // ======================================== Single Strategy ===================================
         if(Strategy == single&&change)
           {
            // =====================================Buy =====================================
            if(Trade_Direction == buyx || Trade_Direction == bothx)
              {
               if(MasterSignal[i] > 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment1;
                  Buy(i, Cmnt,indikator1,timeframe1);
                  mainSignal = 1;
                  change=false;

                 }
               if(Signal2[i] > 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment2;
                  Buy(i, Cmnt,indikator2,timeframe2);

                  mainSignal = 1;
                  change=false;
                 }
               if(Signal3[i] > 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment3;
                  Buy(i, Cmnt,indikator3,timeframe3);
                  mainSignal = 1;
                  change=false;
                 }
               if(Signal4[i] > 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment4;
                  Buy(i, Cmnt,indikator4,timeframe4);
                  mainSignal = 1;
                  change=false;
                 }
              }

            // ========================================Sell =================================
            if(Trade_Direction == sellx || Trade_Direction == bothx)
              {
               if(MasterSignal[i] < 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment1;
                  Sell(i, Cmnt,indikator1,timeframe1);
                  mainSignal = -1;
                  change=false;
                 }
               if(Signal2[i] < 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment2;
                  Sell(i, Cmnt,indikator2,timeframe2);
                  mainSignal = -1;
                  change=false;
                 }
               if(Signal3[i] < 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment3;
                  Sell(i, Cmnt,indikator3,timeframe3);
                  mainSignal = -1;
                  change=false;
                 }
               if(Signal4[i] < 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment4;
                  Sell(i, Cmnt,indikator4,timeframe4);
                  mainSignal = -1;
                  change=false;
                 }
              }
           }

         // ======================================== Seperate Strategy ===================================
         if(Strategy == seperate&&change)
           {
            // =====================================Buy =====================================
            if(Trade_Direction == buyx || Trade_Direction == bothx)
              {

               if(Signal2[i] > 0 && MasterSignal[i] > 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment2;
                  Buy(i, Cmnt,indikator1,timeframe1,indikator2,timeframe2);
                  mainSignal = 1;
                  change=false;
                 }
               if(Signal3[i] > 0 && MasterSignal[i] > 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment3;
                  Buy(i, Cmnt,indikator1,timeframe1,indikator3,timeframe3);
                  mainSignal = 1;
                  change=false;
                 }
               if(Signal4[i] > 0 && MasterSignal[i] > 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment4;
                  Buy(i, Cmnt,indikator1,timeframe1,indikator4,timeframe4);
                  mainSignal = 1;
                  change=false;
                 }
              }

            // ========================================Sell =================================
            if(Trade_Direction == sellx || Trade_Direction == bothx)
              {

               if(Signal2[i] < 0 && MasterSignal[i] < 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment2;
                  Sell(i, Cmnt,indikator1,timeframe1,indikator2,timeframe2);
                  mainSignal = -1;
                  change=false;
                 }
               if(Signal3[i] < 0 && MasterSignal[i] < 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment3;
                  Sell(i, Cmnt,indikator1,timeframe1,indikator3,timeframe3);
                  mainSignal = -1;
                  change=false;
                 }
               if(Signal4[i] < 0 && MasterSignal[i] < 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment4;
                  Sell(i, Cmnt,indikator1,timeframe1,indikator4,timeframe4);
                  mainSignal = -1;
                  change=false;
                 }
              }
           }
         // ======================================== Join Strategy ===================================
         if(Strategy == join&&change)
           {
            // =====================================Buy =====================================
            if(Trade_Direction == buyx || Trade_Direction == bothx)
              {

               if(Signal2[i] > 0 && Signal3[i] > 0 && Signal4[i] > 0 && MasterSignal[i] > 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment2;
                  Buy(i, Cmnt,indikator1,timeframe1,indikator2,timeframe2,indikator3,timeframe3,indikator4,timeframe4);
                  change=false;
                  mainSignal = 1;
                 }


              }

            // ========================================Sell =================================
            if(Trade_Direction == sellx || Trade_Direction == bothx)
              {

               if(Signal2[i] < 0 && Signal3[i] < 0 && Signal4[i] < 0 && MasterSignal[i] < 0)
                 {
                  string Cmnt = commentselect == Auto?comment: comment2;
                  Sell(i, Cmnt,indikator1,timeframe1,indikator2,timeframe2,indikator3,timeframe3,indikator4,timeframe4);
                  mainSignal = -1;
                  change=false;
                 }

              }
           }
         if(closetype == opposite&&exitchange)
           {
            if(close_Strategy == singleClose)
              {
               if(exit1[i] > 0)
                 {
                  BuyPositions[i].GroupCloseAll(30);
                  BuyPendings[i].GroupCloseAll(30);
                  CloseSignal(i,0);
                 }
               if(exit1[i] < 0)
                 {
                  SellPositions[i].GroupCloseAll(30);
                  SellPendings[i].GroupCloseAll(30);
                  CloseSignal(i,1);
                 }
              }
           }
         if(close_Strategy == joinClose)
           {
            if(exit1[i] > 0 && exit2[i] > 0)
              {
               BuyPositions[i].GroupCloseAll(30);
               BuyPendings[i].GroupCloseAll(30);
               CloseSignal(i,0);
              }
            if(exit1[i] < 0 && exit2[i] < 0)
              {
               SellPositions[i].GroupCloseAll(30);
               SellPendings[i].GroupCloseAll(30);
               CloseSignal(i,0);
              }

           }


        }

     }
   NewsFeed();
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

//---
   if(ShowDashboard)
     {
      //---
      ObjectsCreateAll();
      //---
      for(int i=0; i<ArraySize(Symbols); i++)
        {
         ObjectsUpdateAll(Symbols[i]);
         GetSetInputs(Symbols[i]);
        }
      //---
      GetSetInputsA();

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
      Comment("");
      ChartRedraw();
     }
   else
      CreateMinWindow();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   Print(INAME+": xml file is out of date");
   xmlUpdate();
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
      if(KeyboardTrading)
        {


         //--- Switch Symbol (UP)
         if(lparam==KEY_UP)
           {
            //---
            int index=0;
            //---
            for(int i=0; i<ArraySize(Symbols); i++)
              {
               if(_Symbol==Symbols[i])
                 {
                  //---
                  index=i-1;
                  //---
                  if(index<0)
                     index=ArraySize(Symbols)-1;
                  //---
                  if(SymbolFind(Symbols[index],false))
                    {
                     ChartSetSymbolPeriod(0,Symbols[index],PERIOD_CURRENT);
                     SetStatus("ÿ","Switched to "+Symbols[index]);
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
            for(int i=0; i<ArraySize(Symbols); i++)
              {
               //---
               if(_Symbol==Symbols[i])
                 {
                  //---
                  index=i+1;
                  //---
                  if(index>=ArraySize(Symbols))
                     index=0;
                  //---
                  if(SymbolFind(Symbols[index],false))
                    {
                     ChartSetSymbolPeriod(0,Symbols[index],PERIOD_CURRENT);
                     SetStatus("ÿ","Switched to "+Symbols[index]);
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


      //---
      for(int i=0; i<ArraySize(Symbols); i++)
        {

         //--- SymoblSwitcher
         if(sparam==OBJPREFIX+Symbols[i])
           {
            ChartSetSymbolPeriod(0,Symbols[i],PERIOD_CURRENT);
            SetStatus("ÿ","Switched to "+Symbols[i]);
            break;
           }
        }

      //--- RemoveExpert
      if(sparam==OBJPREFIX+"EXIT")
        {
         //---
         if(MessageBox("Are you sure you want to exit?",MB_CAPTION,MB_ICONQUESTION|MB_YESNO)==IDYES)
            ExpertRemove();//Exit
        }

      //--- Minimize
      if(sparam==OBJPREFIX+"MINIMIZE")
        {
         ObjectsDeleteAll(0,OBJPREFIX,-1,-1);
         CreateMinWindow();
         ShowDashboard=false;
         ChartMouseScrollSet(true);
         ChartSetColor(2);
         ClearedTemplate=false;
        }

      //--- Maximize
      if(sparam==OBJPREFIX+"MIN"+"MAXIMIZE")
        {
         DelteMinWindow();
         ObjectsCreateAll();
         ShowDashboard=true;
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
         for(int i=0; i<ArraySize(Symbols); i++)
            ObjectSetString(0,OBJPREFIX+"PRICEROW_L"+" - "+Symbols[i],OBJPROP_TOOLTIP,PriceRowLeftArr[PriceRowLeft]+" "+Symbols[i]);
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
         for(int i=0; i<ArraySize(Symbols); i++)
            ObjectSetString(0,OBJPREFIX+"PRICEROW_R"+" - "+Symbols[i],OBJPROP_TOOLTIP,PriceRowRightArr[PriceRowRight]+" "+Symbols[i]);
        }
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
         for(int i=0; i<ArraySize(Symbols); i++)
            ObjectSetString(0,OBJPREFIX+"PRICEROW_R"+" - "+Symbols[i],OBJPROP_TOOLTIP,PriceRowRightArr[PriceRowRight]+" "+Symbols[i]);
        }


     }

//----
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void NewsFeed()
  {
   string sTags[7]= {"<title>","<country>","<date><![CDATA[","<time><![CDATA[","<impact><![CDATA[","<forecast><![CDATA[","<previous><![CDATA["};
   string eTags[7]= {"</title>","</country>","]]></date>","]]></time>","]]></impact>","]]></forecast>","]]></previous>"};
   int index=0;
   int next=-1;
   int BoEvent=0,begin=0,end=0;
   string myEvent="";
//--- Minutes calculation
   datetime EventTime=0;
   int EventMinute=0;
//--- split the currencies into the two parts
   string MainSymbol=StringSubstr(Symbol(),0,3);
   string SecondSymbol=StringSubstr(Symbol(),3,3);
//--- loop to get the data from xml tags
   while(true)
     {
      BoEvent=StringFind(sData,"<event>",BoEvent);
      if(BoEvent==-1)
         break;
      BoEvent+=7;
      next=StringFind(sData,"</event>",BoEvent);
      if(next == -1)
         break;
      myEvent = StringSubstr(sData,BoEvent,next-BoEvent);
      BoEvent = next;
      begin=0;
      for(int i=0; i<7; i++)
        {
         Event[index][i]="";
         next=StringFind(myEvent,sTags[i],begin);
         //--- Within this event, if tag not found, then it must be missing; skip it
         if(next==-1)
            continue;
         else
           {
            //--- We must have found the sTag okay...
            //--- Advance past the start tag
            begin=next+StringLen(sTags[i]);
            end=StringFind(myEvent,eTags[i],begin);
            //---Find start of end tag and Get data between start and end tag
            if(end>begin && end!=-1)
               Event[index][i]=StringSubstr(myEvent,begin,end-begin);
           }
        }
      //--- filters that define whether we want to skip this particular currencies or events
      if(ReportActive && MainSymbol!=Event[index][COUNTRY] && SecondSymbol!=Event[index][COUNTRY])
         continue;
      if(!IsCurrency(Event[index][COUNTRY]))
         continue;
      if(!IncludeHigh && Event[index][IMPACT]=="High")
         continue;
      if(!IncludeMedium && Event[index][IMPACT]=="Medium")
         continue;
      if(!IncludeLow && Event[index][IMPACT]=="Low")
         continue;
      if(!IncludeSpeaks && StringFind(Event[index][TITLE],"Speaks")!=-1)
         continue;
      if(!IncludeHolidays && Event[index][IMPACT]=="Holiday")
         continue;
      if(Event[index][TIME]=="All Day" ||
         Event[index][TIME]=="Tentative" ||
         Event[index][TIME]=="")
         continue;
      if(FindKeyword!="")
        {
         if(StringFind(Event[index][TITLE],FindKeyword)==-1)
            continue;
        }
      if(IgnoreKeyword!="")
        {
         if(StringFind(Event[index][TITLE],IgnoreKeyword)!=-1)
            continue;
        }
      //--- sometimes they forget to remove the tags :)
      if(StringFind(Event[index][TITLE],"<![CDATA[")!=-1)
         StringReplace(Event[index][TITLE],"<![CDATA[","");
      if(StringFind(Event[index][TITLE],"]]>")!=-1)
         StringReplace(Event[index][TITLE],"]]>","");
      if(StringFind(Event[index][TITLE],"]]>")!=-1)
         StringReplace(Event[index][TITLE],"]]>","");
      //---
      if(StringFind(Event[index][FORECAST],"&lt;")!=-1)
         StringReplace(Event[index][FORECAST],"&lt;","");
      if(StringFind(Event[index][PREVIOUS],"&lt;")!=-1)
         StringReplace(Event[index][PREVIOUS],"&lt;","");

      //--- set some values (dashes) if empty
      if(Event[index][FORECAST]=="")
         Event[index][FORECAST]="---";
      if(Event[index][PREVIOUS]=="")
         Event[index][PREVIOUS]="---";
      //--- Convert Event time to MT4 time
      EventTime=datetime(MakeDateTime(Event[index][DATE],Event[index][TIME]));
      //--- calculate how many minutes before the event (may be negative)
      EventMinute=int(EventTime-TimeGMT())/60;
      //--- only Alert once
      if(EventMinute==0 && AlertTime!=EventTime)
        {
         FirstAlert =false;
         SecondAlert=false;
         AlertTime=EventTime;
        }
      //--- Remove the event after x minutes
      if(EventMinute+EventDisplay<0)
         continue;
      //--- Set buffers
      index++;
     }
//--- loop to set arrays/buffers that uses to draw objects and alert
   for(int i=0; i<index; i++)
     {
      for(int n=i; n<10; n++)
        {
         eTitle[n]    = Event[i][TITLE];
         eCountry[n]  = Event[i][COUNTRY];
         eImpact[n]   = Event[i][IMPACT];
         eForecast[n] = Event[i][FORECAST];
         ePrevious[n] = Event[i][PREVIOUS];
         eTime[n]     = datetime(MakeDateTime(Event[i][DATE],Event[i][TIME]))-TimeGMTOffset();
         eMinutes[n]  = (int)(eTime[n]-TimeLocal())/60;
         MinuteBuffer[index]=EventMinute;
         ImpactBuffer[index]=ImpactToNumber(Event[index][IMPACT]);
         //--- Check if there are any events
         if(ObjectFind(eTitle[n])!=0)
            IsEvent=true;
        }
     }
//--- check then call draw / alert function
   if(IsEvent)
      DrawEvents();
   else
      Draw("no more events","NO MORE EVENTS",14,"Arial Black",RemarksColor,2,10,30,"Get some rest!");
//--- call info function
   if(ShowInfo)
      SymbolInfo();

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetIndicatorsSignal(indi indicator, ENUM_TIMEFRAMES period, string cmnt, int shift, string symbol)
  {
   int signal = 0;
   double buy = 0,
          sell = 0;
   if(indicator == beast)
     {
      buy = iCustom(symbol, period, "1BeastSuperSignal.ex4", BEAST_Depth, BEAST_Deviation, BEAST_BackStep, BEAST_StochasticLen, BEAST_StochasticFilter, BEAST_OverBoughtLevel, BEAST_OverSoldLevel, BEAST_MATrendLinePeriod, BEAST_MATrendLineMethod, BEAST_MATrendLinePrice, BEAST_MAPerod, BEAST_MAShift, BEAST_MAMethod, BEAST_MAPrice, BEAST_alert, BEAST_push, BEAST_mail, BEAST_arrow, 0, shift);
      if(ValidateBuffer(buy))
         signal = 1;
      sell = iCustom(symbol, period, "1BeastSuperSignal.ex4", BEAST_Depth, BEAST_Deviation, BEAST_BackStep, BEAST_StochasticLen, BEAST_StochasticFilter, BEAST_OverBoughtLevel, BEAST_OverSoldLevel, BEAST_MATrendLinePeriod, BEAST_MATrendLineMethod, BEAST_MATrendLinePrice, BEAST_MAPerod, BEAST_MAShift, BEAST_MAMethod, BEAST_MAPrice, BEAST_alert, BEAST_push, BEAST_mail, BEAST_arrow, 1, shift);
      if(ValidateBuffer(sell))
         signal = -1;

     }
   if(indicator == triger)
     {
      double buff0_1 = iCustom(symbol, period, "1Triggerlines.ex4", TRIGGERLINES_Rperiod, TRIGGERLINES_LSMA_Period, 0, shift);
      double buff2_1 = iCustom(symbol, period, "1Triggerlines.ex4", TRIGGERLINES_Rperiod, TRIGGERLINES_LSMA_Period, 2, shift);
      double buff0_2 = iCustom(symbol, period, "1Triggerlines.ex4", TRIGGERLINES_Rperiod, TRIGGERLINES_LSMA_Period, 0, shift+1);
      double buff2_2 = iCustom(symbol, period, "1Triggerlines.ex4", TRIGGERLINES_Rperiod, TRIGGERLINES_LSMA_Period, 2, shift+1);
      if(ValidateBuffer(buff0_1) && ValidateBuffer(buff2_1) && ValidateBuffer(buff0_2) && !ValidateBuffer(buff2_2))
         signal = 1;
      if(ValidateBuffer(buff0_1) && !ValidateBuffer(buff2_1) && ValidateBuffer(buff0_2) && ValidateBuffer(buff2_2))
         signal = -1;

     }

   if(indicator == uni)
     {
      buy = iCustom(symbol, period, "127031_uni_cross.ex4", UseSound, TypeChart, UseAlert, NameFileSound, T3Period, T3Price, B_Factor, Snake_HalfCycle, Inverse, DeltaForSell, DeltaForBuy, ArrowOffset, Maxbars, 0, shift);
      if(ValidateBuffer(buy))
         signal = 1;
      sell = iCustom(symbol, period, "127031_uni_cross.ex4", UseSound, TypeChart, UseAlert, NameFileSound, T3Period, T3Price, B_Factor, Snake_HalfCycle, Inverse, DeltaForSell, DeltaForBuy, ArrowOffset, Maxbars, 1, shift);
      if(ValidateBuffer(sell))
         signal = -1;
     }
   if(indicator == zigzag)
     {
      buy = iCustom(symbol, period, "1ZigZagSignal.ex4", ZIGZAG_Depth, ZIGZAG_Deviation, ZIGZAG_BackStep, 0, shift);
      if(ValidateBuffer(buy))
         signal = 1;
      sell = iCustom(symbol, period, "1ZigZagSignal.ex4", ZIGZAG_Depth, ZIGZAG_Deviation, ZIGZAG_BackStep, 1, shift);
      if(ValidateBuffer(sell))
         signal = -1;
     }
   if(indicator == HMA)
     {
      buy = iCustom(symbol, period, "HMA_nrp_alerts_m_arrows.ex4", 3, shift);
      if(ValidateBuffer(buy))
         signal = 1;
      sell = iCustom(symbol, period, "HMA_nrp_alerts_m_arrows.ex4", 4, shift);
      if(ValidateBuffer(sell))
         signal = -1;
     }

// need review on chart
   if(indicator == HMATreend)
     {
      buy = iCustom(symbol, period, "hma-trend-indicator_new _build.ex4", 0, shift);
      if(ValidateBuffer(buy))
         signal = 1;
      sell = iCustom(symbol, period, "hma-trend-indicator_new _build.ex4", 1, shift);
      if(ValidateBuffer(sell))
         signal = -1;
     }
   return signal;
  }
// dashboard functions
int initialSignal(indi indicator, ENUM_TIMEFRAMES period, string cmnt, int shift, string symbol)
  {
   int signal = 0;
   double buy = 0,
          sell = 0;

   if(indicator == beast)
     {
      for(int x=0; x<500; x++)
        {
         buy = iCustom(symbol, period, "1BeastSuperSignal.ex4", BEAST_Depth, BEAST_Deviation, BEAST_BackStep, BEAST_StochasticLen, BEAST_StochasticFilter, BEAST_OverBoughtLevel, BEAST_OverSoldLevel, BEAST_MATrendLinePeriod, BEAST_MATrendLineMethod, BEAST_MATrendLinePrice, BEAST_MAPerod, BEAST_MAShift, BEAST_MAMethod, BEAST_MAPrice, BEAST_alert, BEAST_push, BEAST_mail, BEAST_arrow, 0, x);
         if(ValidateBuffer(buy))
           {
            signal = 1;
            break;
           }
         sell = iCustom(symbol, period, "1BeastSuperSignal.ex4", BEAST_Depth, BEAST_Deviation, BEAST_BackStep, BEAST_StochasticLen, BEAST_StochasticFilter, BEAST_OverBoughtLevel, BEAST_OverSoldLevel, BEAST_MATrendLinePeriod, BEAST_MATrendLineMethod, BEAST_MATrendLinePrice, BEAST_MAPerod, BEAST_MAShift, BEAST_MAMethod, BEAST_MAPrice, BEAST_alert, BEAST_push, BEAST_mail, BEAST_arrow, 1, x);
         if(ValidateBuffer(sell))
           {
            signal = -1;
            break;
           }
        }
     }

   if(indicator == triger)
     {
      for(int x=0; x<500; x++)
        {
         double buff0_1 = iCustom(symbol, period, "1Triggerlines.ex4", TRIGGERLINES_Rperiod, TRIGGERLINES_LSMA_Period, 0, x);
         double buff2_1 = iCustom(symbol, period, "1Triggerlines.ex4", TRIGGERLINES_Rperiod, TRIGGERLINES_LSMA_Period, 2, x);
         double buff0_2 = iCustom(symbol, period, "1Triggerlines.ex4", TRIGGERLINES_Rperiod, TRIGGERLINES_LSMA_Period, 0, x+1);
         double buff2_2 = iCustom(symbol, period, "1Triggerlines.ex4", TRIGGERLINES_Rperiod, TRIGGERLINES_LSMA_Period, 2, x+1);
         if(ValidateBuffer(buff0_1) && ValidateBuffer(buff2_1) && ValidateBuffer(buff0_2) && !ValidateBuffer(buff2_2))
           {
            signal = 1;
            break;
           }
         if(ValidateBuffer(buff0_1) && !ValidateBuffer(buff2_1) && ValidateBuffer(buff0_2) && ValidateBuffer(buff2_2))
           {
            signal = -1;
            break;
           }
        }
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(indicator == uni)
     {
      for(int x=0; x<500; x++)
        {
         buy = iCustom(symbol, period, "127031_uni_cross.ex4", UseSound, TypeChart, UseAlert, NameFileSound, T3Period, T3Price, B_Factor, Snake_HalfCycle, Inverse, DeltaForSell, DeltaForBuy, ArrowOffset, Maxbars, 0, x);
         if(ValidateBuffer(buy))
           {
            signal = 1;
            break;
           }
         sell = iCustom(symbol, period, "127031_uni_cross.ex4", UseSound, TypeChart, UseAlert, NameFileSound, T3Period, T3Price, B_Factor, Snake_HalfCycle, Inverse, DeltaForSell, DeltaForBuy, ArrowOffset, Maxbars, 1, x);
         if(ValidateBuffer(sell))
           {
            signal = -1;
            break;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(indicator == zigzag)
     {
      for(int x=0; x<500; x++)
        {
         buy = iCustom(symbol, period, "1ZigZagSignal.ex4", ZIGZAG_Depth, ZIGZAG_Deviation, ZIGZAG_BackStep, 0, x);
         if(ValidateBuffer(buy))
           {
            signal = 1;
            break;
           }
         sell = iCustom(symbol, period, "1ZigZagSignal.ex4", ZIGZAG_Depth, ZIGZAG_Deviation, ZIGZAG_BackStep, 1, x);
         if(ValidateBuffer(sell))
           {
            signal = -1;
            break;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(indicator == HMA)
     {
      for(int x=0; x<500; x++)
        {
         buy = iCustom(symbol, period, "HMA_nrp_alerts_m_arrows.ex4", 3, x);
         if(ValidateBuffer(buy))
           {
            signal = 1;
            break;
           }
         sell = iCustom(symbol, period, "HMA_nrp_alerts_m_arrows.ex4", 4, x);
         if(ValidateBuffer(sell))
           {
            signal = -1;
            break;
           }
        }
     }

// need review on chart
   if(indicator == HMATreend)
     {
      for(int x=0; x<500; x++)
        {
         buy = iCustom(symbol, period, "hma-trend-indicator_new _build.ex4", 0, x);
         if(ValidateBuffer(buy))
           {
            signal = 1;
            break;
           }
         sell = iCustom(symbol, period, "hma-trend-indicator_new _build.ex4", 1, x);
         if(ValidateBuffer(sell))
           {
            signal = -1;
            break;
           }
        }
     }
   return signal;
  }
//+------------------------------------------------------------------+
void CloseSignal(int i,int type)
  {
   string ordertype=type==0?"Buy":"Sell";
   Hist[i].SetHistoryRange(startTime,TimeCurrent());
   int totalHistory=Hist[i].GroupTotal();
   datetime time=0;
   long ticket=-1;
   for(int zz= 0; zz<totalHistory; zz++)
     {
      datetime timeClose=Hist[i][zz].GetTimeClose();
      if(timeClose>time)
        {
         time=timeClose;
         ticket=Hist[i][zz].GetTicket();
        }
     }
   if(totalHistory>0&&time>lastorder_close)
     {
      double Profit=Hist[i][ticket].GetProfit();
      string txt="";
      lastorder_close=time;
      if(Profit>=0)
        {
         txt="Profit: ";
        }
      else
        {
         txt="Loss: ";
        }
      cc0=ordertype+" Order Closed Buy "+Get_Strategy(1)+"on "+Symbols[i]+" @ "+(string)Hist[i][ticket].GetPriceClose()+txt+(string)Profit+" Time: "+ TimeToString(Hist[i][ticket].GetTimeClose(),TIME_MINUTES)+" Date: "+ TimeToString(Hist[i][ticket].GetTimeClose(),TIME_DATE);
     }
  }


// Function: check indicators ValidateBuffer buffer value
bool ValidateBuffer(double value)
  {
   if(value != 0 && value != EMPTY_VALUE)
      return true;
   else
      return false;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double CalcLot(string symbol)
  {
   double Lot;
   if(MM)
     {
      int nd;
      if(SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN) < 0.1)
        {
         nd = 2;
        }
      else
         if(SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN) > 0.1)
           {
            nd = 0;
           }
         else
           {
            nd = 1;
           }

      Lot = NormalizeDouble((AccountInfoDouble(ACCOUNT_EQUITY)*Risk/1000)/StopLoss, nd);
      if(Lot < SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN))
         Lot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
      if(Lot > SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX))
         Lot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
     }
   else
     {
      Lot = Lots;
     }
   return Lot;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Get_Timeframe(ENUM_TIMEFRAMES tf)
  {
   string txt="";

   switch(tf)
     {
      case     1:
         txt ="M1";
         break;
      case     5:
         txt ="M5";
         break;
      case    15:
         txt ="M15";
         break;
      case    30:
         txt ="M30";
         break;
      case    60:
         txt ="H1";
         break;
      case   240:
         txt ="H4";
         break;
      case  1440:
         txt ="D1";
         break;
      case 10080:
         txt ="W1";
         break;
      case 43200:
         txt ="MN1";
         break;
     }
   return txt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Get_Indicator(indi indicator)
  {
   string txt="";

   switch(indicator)
     {
      case     1:
         txt ="Beast";
         break;
      case     2:
         txt ="Triger";
         break;
      case    3:
         txt ="Uni";
         break;
      case    4:
         txt ="Zigzag";
         break;
      case    5:
         txt ="HMA";
         break;
      case   6:
         txt ="HMATrend";
         break;
     }
   return txt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Get_Strategy(int type)
  {
   string txt="";
   if(type==0)
      switch(Strategy)
        {
         case     0:
            txt ="Single Signal";
            break;
         case     1:
            txt ="Seperate Signal";
            break;
         case    2:
            txt ="Joint Signal";
            break;
        }
   if(type==1)
      switch(close_Strategy)
        {
         case     0:
            txt ="Seperate SIGNAL ";
            break;
         case     1:
            txt ="Joint Signal";
            break;

        }
   return txt;
  }
//+------------------------------------------------------------------+
void Buy(int i, string Cmnt, indi i1,ENUM_TIMEFRAMES tf1=0,indi i2=0,ENUM_TIMEFRAMES tf2=0, indi i3=0,ENUM_TIMEFRAMES tf3=0, indi i4=0,ENUM_TIMEFRAMES tf4=0)
  {

   double volume = CalcLot(Symbols[i]);
   string s1=Get_Indicator(i1)+" "+Get_Timeframe(tf1)+" ";
   string s2=i2==0?"":Get_Indicator(i2)+" "+Get_Timeframe(tf2)+" ";
   string s3=i3==0?"":Get_Indicator(i3)+" "+Get_Timeframe(tf3)+" ";
   string s4=i4==0?"":Get_Indicator(i4)+" "+Get_Timeframe(tf4)+" ";

// =====================================Buy =====================================
   if(Execution_Mode == instan)
     {
      if(usemode==Auto&&!MaxBuyExceed)
         trades[i].Position(TYPE_POSITION_BUY, volume, StopLoss, TakeProfit, SLTP_PIPS, 30, Cmnt);
      cc0=Get_Strategy(0)+", "+Symbols[i]+", Buy, " +s1+s2+s3+s4+" @ "+(string)tools[i].Ask()+" Time: "+ TimeToString(TimeCurrent(),TIME_MINUTES)+" Date: "+ TimeToString(TimeCurrent(),TIME_DATE);
     }
   if(Execution_Mode == limit&&!MaxBuyExceed)
     {
      double openPrice = tools[i].Bid()-orderdistance*tools[i].Pip();
      if(usemode==Auto)
         trades[i].Order(TYPE_ORDER_BUYLIMIT, volume, openPrice, StopLoss, TakeProfit, SLTP_PIPS, 0, 30, Cmnt);
      cc0=Get_Strategy(0)+", "+Symbols[i]+", BuyLimit, "+s1+s2+s3+s4+" @ "+(string)openPrice+" Time: "+ TimeToString(TimeCurrent(),TIME_MINUTES)+" Date: "+ TimeToString(TimeCurrent(),TIME_DATE);
     }
   if(Execution_Mode == stop&&!MaxBuyExceed)
     {
      double openPrice = tools[i].Ask()+orderdistance*tools[i].Pip();
      if(usemode==Auto)
         trades[i].Order(TYPE_ORDER_BUYSTOP, volume, openPrice, StopLoss, TakeProfit, SLTP_PIPS, 0, 30, Cmnt);
      cc0=Get_Strategy(0)+", "+Symbols[i]+", BuyStop, "+s1+s2+s3+s4+" @ "+(string)openPrice+" Time: "+ TimeToString(TimeCurrent(),TIME_MINUTES)+" Date: "+ TimeToString(TimeCurrent(),TIME_DATE);
     }


  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Sell(int i, string Cmnt, indi i1,ENUM_TIMEFRAMES tf1=0,indi i2=0,ENUM_TIMEFRAMES tf2=0, indi i3=0,ENUM_TIMEFRAMES tf3=0, indi i4=0,ENUM_TIMEFRAMES tf4=0)
  {
   double volume = CalcLot(Symbols[i]);
   string s1=Get_Indicator(i1)+" "+Get_Timeframe(tf1)+" ";
   string s2=i2==0?"":Get_Indicator(i2)+" "+Get_Timeframe(tf2)+" ";
   string s3=i3==0?"":Get_Indicator(i3)+" "+Get_Timeframe(tf3)+" ";
   string s4=i4==0?"":Get_Indicator(i4)+" "+Get_Timeframe(tf4)+" ";
   if(Execution_Mode == instan)
     {
      if(usemode==Auto&&!MaxSellExceed)
         trades[i].Position(TYPE_POSITION_SELL, volume, StopLoss, TakeProfit, SLTP_PIPS, 30, Cmnt);
      cc0=Get_Strategy(0)+", "+Symbols[i]+", Sell, "+s1+s2+s3+s4+" @ "+(string)tools[i].Bid()+" Time: "+ TimeToString(TimeCurrent(),TIME_MINUTES)+" Date: "+ TimeToString(TimeCurrent(),TIME_DATE);

     }
   if(Execution_Mode == limit&&!MaxSellExceed)
     {
      double openPrice = tools[i].Ask()+orderdistance*tools[i].Pip();
      if(usemode==Auto)
         trades[i].Order(TYPE_ORDER_SELLLIMIT, volume, openPrice, StopLoss, TakeProfit, SLTP_PIPS, 0, 30, Cmnt);
      cc0=Get_Strategy(0)+", "+Symbols[i]+" ,SellLimit, "+s1+s2+s3+s4+" @ "+(string)openPrice+" Time: "+ TimeToString(TimeCurrent(),TIME_MINUTES)+" Date: "+ TimeToString(TimeCurrent(),TIME_DATE);

     }
   if(Execution_Mode == stop&&!MaxSellExceed)
     {
      double openPrice = tools[i].Bid()-orderdistance*tools[i].Pip();
      if(usemode==Auto)
         trades[i].Order(TYPE_ORDER_SELLSTOP, volume, openPrice, StopLoss, TakeProfit, SLTP_PIPS, 0, 30, Cmnt);
      cc0=Get_Strategy(0)+", "+Symbols[i]+", SellStop, "+s1+s2+s3+s4+" @ "+(string)openPrice+" Time: "+ TimeToString(TimeCurrent(),TIME_MINUTES)+" Date: "+ TimeToString(TimeCurrent(),TIME_DATE);

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClosingFilter()
  {
   int size=ArraySize(Symbols);
   double Profit=0;
   int Tb=0,Ts=0;
   double ProfitInPips=0;
   for(int x=0; x<size; x++)
     {
      Profit=Profit+Positions[x].GroupTotalProfit();
      Ts=Ts+SellPositions[x].GroupTotal();
      Tb=Tb+BuyPositions[x].GroupTotal();
      ProfitInPips=ProfitInPips+profitPipsPerSymbol(Positions[x],tools[x]);
     }
   if(Ts>maxsell)
      MaxSellExceed=true;
   else
      MaxSellExceed=false;
   if(Tb>maxbuy)
      MaxBuyExceed=true;
   else
      MaxBuyExceed=false;
   int totalopened=Ts+Tb;
   if(totalopened>MaxLevel)
     {
      MaxSellExceed=true;
      MaxBuyExceed=true;
     }
   if(Profit_Type==InDollarsProfit)
     {
      if(Profit>ProfitValue)
        {
         closAll();
        }
     }
   if(Profit_Type==InPercentProfit)
     {
      double pp=Profit/AccountBalance();
      if(ProfitValue<pp)
         closAll();
     }
   if(Profit_Type==InPipsProfit&&ProfitValue!=0)
     {
      if(ProfitValue<ProfitInPips)
         closAll();
     }
   if(LossType==InDollarsLoss&&LossValue!=0)
     {
      if(Profit<0&&LossValue<MathAbs(Profit))
         closAll();
     }
   if(LossType==InPercentLoss&&LossValue!=0)
     {
      if(Profit<0)
        {
         double lp=MathAbs(Profit)/AccountBalance();
         if(LossValue<lp)
            closAll();
        }
     }
   if(LossType==InPipsLoss&&LossValue!=0)
     {
      if(ProfitInPips<0&&LossValue<MathAbs(ProfitInPips))
        {
         closAll();
        }
     }
  }
//+------------------------------------------------------------------+
void closAll()
  {
   int size=ArraySize(Symbols);
   for(int i=0; i<size; i++)
     {
      Positions[i].GroupCloseAll(30);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double profitPipsPerSymbol(CPosition & pos,CUtilities & tool)
  {
   int size = pos.GroupTotal();
   double pips=0;
   for(int x=0; x<size; x++)
     {
      double PriceOpen= pos[x].GetPriceOpen();
      pips=pips+(tool.Bid()-PriceOpen);
     }
   pips=pips/tool.Pip();
   return pips;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeletePeblndingWithCandle(COrder & pending)
  {
   int size=pending.GroupTotal();
   for(int i=0; i<size; i++)
     {
      datetime timeOpen=pending[i].GetTimeSetUp();
      string symb=pending[i].GetSymbol();
      datetime timetoDelete=iTime(symb,0,Bars_to_Delete_Pending);
      if(timeOpen<=timetoDelete)
        {
         pending[i].Close(30);
        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Telegram()
  {
   if(useTel&& cc0!="")
     {
      if(getme_result!=0)
        {
         Print("Error : ",(getme_result));
        }

      //--- reading messages
      bot.GetUpdates();

      //--- processing messages
      bot.ProcessMessages(cc0);
     }
  }
//+------------------------------------------------------------------+
bool TradeDays()
  {
   if(SET_TRADING_DAYS == false)
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
//+------------------------------------------------------------------+
//| Balance                                                          |
//+------------------------------------------------------------------+
string Balance()
  {
//---
   string text = "";
//---
   if(_AccountCurrency() == "$" || _AccountCurrency() == "£")
      text = _AccountCurrency()+DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE), 2);
   else
      text = DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE), 2)+_AccountCurrency();
//---
   string result = "Balance: "+text;
//---

//---
   return(result);
  }
//+------------------------------------------------------------------+
//| ObjectsCreateAll                                                 |
//+------------------------------------------------------------------+
void ObjectsCreateAll()
  {
//---
   int fr_y2 = Dpi(100);
//---
   for(int i = 0; i < ArraySize(Symbols); i++)
     {
      //---
      if(SelectedMode == FULL)
         fr_y2 += Dpi(25);
      //---
      if(SelectedMode == COMPACT)
         fr_y2 += Dpi(21);
      //---
      if(SelectedMode == MINI)
         fr_y2 += Dpi(17);
     }
//---
   int x = (Dpi(10));
   int y = (20);
//---
   int height = fr_y2+Dpi(3);
//---
   RectLabelCreate(0, OBJPREFIX+"BCKGRND[]", 0, x, y, Dpi(CLIENT_BG_WIDTH), height, COLOR_BG, BORDER_FLAT, CORNER_LEFT_UPPER, COLOR_BORDER, STYLE_SOLID, 1, false, false, true, 0, "\n");
//---
   _x1 = (int)ObjectGetInteger(0, OBJPREFIX+"BCKGRND[]", OBJPROP_XDISTANCE);
   _y1 = (int)ObjectGetInteger(0, OBJPREFIX+"BCKGRND[]", OBJPROP_YDISTANCE);
//---
   RectLabelCreate(0, OBJPREFIX+"BORDER[]", 0, x, y, Dpi(CLIENT_BG_WIDTH), Dpi(INDENT_TOP), COLOR_BORDER, BORDER_FLAT, CORNER_LEFT_UPPER, COLOR_BORDER, STYLE_SOLID, 1, false, false, true, 0, "\n");
//---
   LabelCreate(0, OBJPREFIX+"CAPTION", 0, _x1+(Dpi(CLIENT_BG_WIDTH)/2)-Dpi(16), _y1, CORNER_LEFT_UPPER, ExpertName, "Arial Black", 9, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 0, "\n");
//---
   LabelCreate(0, OBJPREFIX+"EXIT", 0, (_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(10), _y1-Dpi(2), CORNER_LEFT_UPPER, "r", "Webdings", 10, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "\n", false);
//---
   LabelCreate(0, OBJPREFIX+"MINIMIZE", 0, (_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(30), _y1-Dpi(2), CORNER_LEFT_UPPER, "2", "Webdings", 10, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "\n", false);
//---
   LabelCreate(0, OBJPREFIX+" ", 0, (_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(50), _y1-Dpi(2), CORNER_LEFT_UPPER, "s", "Webdings", 10, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "\n", false);
//---
   LabelCreate(0, OBJPREFIX+"TIME", 0, (_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(85), _y1+Dpi(1), CORNER_LEFT_UPPER, TimeToString(TimeLocal(), TIME_SECONDS), "Tahoma", 8, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "Local Time", false);
   LabelCreate(0, OBJPREFIX+"TIME§", 0, (_x1+Dpi(CLIENT_BG_WIDTH))-Dpi(120), _y1, CORNER_LEFT_UPPER, "Â", "Wingdings", 12, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "Local Time", false);
//---
   LabelCreate(0, OBJPREFIX+"CONNECTION", 0, _x1+Dpi(15), _y1-Dpi(2), CORNER_LEFT_UPPER, "ü", "Webdings", 10, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 0, "Connection", false);
//---
   LabelCreate(0, OBJPREFIX+"THEME", 0, _x1+Dpi(40), _y1-Dpi(4), CORNER_LEFT_UPPER, "N", "Webdings", 15, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "Theme", false);
//---
   LabelCreate(0, OBJPREFIX+"TEMPLATE", 0, _x1+Dpi(65), _y1-Dpi(2), CORNER_LEFT_UPPER, "+", "Webdings", 12, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "Background", false);
//---
   int middle = Dpi(CLIENT_BG_WIDTH/2);
//---
   LabelCreate(0, OBJPREFIX+"STATUS", 0, _x1+middle+(middle/2), _y1+Dpi(8), CORNER_LEFT_UPPER, "\n", "Wingdings", 10, C'59, 41, 40', 0, ANCHOR_LEFT, false, false, true, 1, "\n", false);
//---
   LabelCreate(0, OBJPREFIX+"STATUS«", 0, _x1+middle+(middle/2)+Dpi(15), _y1+Dpi(8), CORNER_LEFT_UPPER, "\n", sFontType, 8, C'59, 41, 40', 0, ANCHOR_LEFT, false, false, true, 1, "\n", false);
//---
   LabelCreate(0, OBJPREFIX+"SOUND", 0, _x1+Dpi(90), _y1-Dpi(2), CORNER_LEFT_UPPER, "X", "Webdings", 12, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "Sounds", false);
//---
   color soundclr = SoundIsEnabled?C'59,41,40': clrNONE;
//---
   LabelCreate(0, OBJPREFIX+"SOUNDIO", 0, _x1+Dpi(100), _y1-Dpi(1), CORNER_LEFT_UPPER, "ð", "Webdings", 10, soundclr, 0, ANCHOR_UPPER, false, false, true, 1, "Sounds", false);
//---
   LabelCreate(0, OBJPREFIX+"ALARM", 0, _x1+Dpi(115), _y1-Dpi(1), CORNER_LEFT_UPPER, "%", "Wingdings", 12, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 1, "Alerts", false);
//---
   color alarmclr = AlarmIsEnabled?clrNONE: C'59,41,40';
//---

//---
   LabelCreate(0, OBJPREFIX+"ALARMIO", 0, _x1+Dpi(115), _y1-Dpi(6), CORNER_LEFT_UPPER, "x", sFontType, 16, alarmclr, 0, ANCHOR_UPPER, false, false, true, 1, "Alerts", false);
//---
   int csm_fr_x1 = _x1+Dpi(50);
   int csm_fr_x2 = _x1+Dpi(95);
   int csm_fr_x3 = _x1+Dpi(137);
   int csm_dist_b = Dpi(150);
//---

   LabelCreate(0, OBJPREFIX+"BALANCE«", 0, _x1+Dpi(200), _y1+Dpi(8), CORNER_LEFT_UPPER, Balance(), sFontType, 8, C'59, 41, 40', 0, ANCHOR_CENTER, false, false, true, 0, "Balance is :"+Balance());
   LabelCreate(0, OBJPREFIX+"Pairs", 0, _x1+Dpi(10), _y1+Dpi(30), CORNER_LEFT_UPPER, "Pairs", "Arial Black", 12, COLOR_FONT, 0, ANCHOR_LEFT, false, false, true, 0, "\n");
   LabelCreate(0, OBJPREFIX+"Master", 0, _x1+Dpi(100), _y1+Dpi(30), CORNER_LEFT_UPPER, "Master", "Arial Black", 10, COLOR_FONT, 0, ANCHOR_LEFT, false, false, true, 0, "\n");
   LabelCreate(0, OBJPREFIX+"slave 1", 0, _x1+Dpi(200), _y1+Dpi(30), CORNER_LEFT_UPPER, "Slave 1", "Arial Black", 10, COLOR_FONT, 0, ANCHOR_LEFT, false, false, true, 0, "\n");
   LabelCreate(0, OBJPREFIX+"slave 2", 0, _x1+Dpi(300), _y1+Dpi(30), CORNER_LEFT_UPPER, "Slave 2", "Arial Black", 10, COLOR_FONT, 0, ANCHOR_LEFT, false, false, true, 0, "\n");
   LabelCreate(0, OBJPREFIX+"slave 3", 0, _x1+Dpi(400), _y1+Dpi(30), CORNER_LEFT_UPPER, "Slave 3", "Arial Black", 10, COLOR_FONT, 0, ANCHOR_LEFT, false, false, true, 0, "\n");
   LabelCreate(0, OBJPREFIX+"Exit 1", 0, _x1+Dpi(500), _y1+Dpi(30), CORNER_LEFT_UPPER, "Exit 1", "Arial Black", 10, COLOR_FONT, 0, ANCHOR_LEFT, false, false, true, 0, "\n");
   LabelCreate(0, OBJPREFIX+"Exit 2", 0, _x1+Dpi(600), _y1+Dpi(30), CORNER_LEFT_UPPER, "Exit 2", "Arial Black", 10, COLOR_FONT, 0, ANCHOR_LEFT, false, false, true, 0, "\n");

//--- SymbolsGUI
   int fr_y = _y1+Dpi(60);

//---
   for(int i = 0; i < ArraySize(Symbols); i++)
     {
      //---
      CreateSymbGUI(i, fr_y);
      //---
      if(SelectedMode == FULL)
         fr_y += Dpi(25);
      //---
      if(SelectedMode == COMPACT)
         fr_y += Dpi(21);
      //---
      if(SelectedMode == MINI)
         fr_y += Dpi(17);
     }

  }
//+------------------------------------------------------------------+
//| CreateSymbGUI                                                    |
//+------------------------------------------------------------------+
void CreateSymbGUI(int i, int Y)
  {
//---
   string _Symb = Symbols[i];
   color startcolor = FirstRun?clrNONE: COLOR_FONT;
   double countb = 0,
          counts = 0,
          countf = 0;

//---
   LabelCreate(0,OBJPREFIX+_Symb,0,_x1+Dpi(10),Y,CORNER_LEFT_UPPER,StringSubstr(_Symb,StringLen(Prefix),6)+":",sFontType,FONTSIZE,COLOR_FONT,0,ANCHOR_LEFT,false,false,true,0,_Symb);
//---

//---
   LabelCreate(0,OBJPREFIX+_Symb+"Master1",0,_x1+Dpi(100),Y,CORNER_LEFT_UPPER,MasterSignal[i]>0?"5":MasterSignal[i]<0?"6":"4","Webdings",15,MasterSignal[i]>0?clrLimeGreen:MasterSignal[i]<0?clrRed:clrYellow,0,ANCHOR_LEFT,false,false,true,0,_Symb);
   LabelCreate(0,OBJPREFIX+_Symb+"Indicator 1",0,_x1+Dpi(200),Y,CORNER_LEFT_UPPER,Signal2[i]>0?"5":Signal2[i]<0?"6":"4","Webdings",15,Signal2[i]>0?clrLimeGreen:Signal2[i]<0?clrRed:clrYellow,0,ANCHOR_LEFT,false,false,true,0,_Symb);
   LabelCreate(0,OBJPREFIX+_Symb+"Indicator 2",0,_x1+Dpi(300),Y,CORNER_LEFT_UPPER,Signal3[i]>0?"5":Signal3[i]<0?"6":"4","Webdings",15,Signal3[i]>0?clrLimeGreen:Signal3[i]<0?clrRed:clrYellow,0,ANCHOR_LEFT,false,false,true,0,_Symb);
   LabelCreate(0,OBJPREFIX+_Symb+"Indicator 3",0,_x1+Dpi(400),Y,CORNER_LEFT_UPPER,Signal4[i]>0?"5":Signal4[i]<0?"6":"4","Webdings",15,Signal4[i]>0?clrLimeGreen:Signal4[i]<0?clrRed:clrYellow,0,ANCHOR_LEFT,false,false,true,0,_Symb);
   LabelCreate(0,OBJPREFIX+_Symb+"Exit1",0,_x1+Dpi(500),Y,CORNER_LEFT_UPPER,exit1[i]>0?"5":exit1[i]<0?"6":"4","Webdings",15,exit1[i]>0?clrLimeGreen:exit1[i]<0?clrRed:clrYellow,0,ANCHOR_LEFT,false,false,true,0,_Symb);
   LabelCreate(0,OBJPREFIX+_Symb+"Exit2",0,_x1+Dpi(600),Y,CORNER_LEFT_UPPER,exit2[i]>0?"5":exit2[i]<0?"6":"4","Webdings",15,exit2[i]>0?clrLimeGreen:exit2[i]<0?clrRed:clrYellow,0,ANCHOR_LEFT,false,false,true,0,_Symb);
//---

//---
  }
//+------------------------------------------------------------------+
//| CreateProBar                                                     |
//+------------------------------------------------------------------+
void CreateProBar(string _Symb, int x, int y)
  {
//---
   int fr_y_pb = y;
//---
   for(int i = 1; i < 11; i++)
     {
      LabelCreate(0, OBJPREFIX+"PB#"+IntegerToString(i)+" - "+_Symb, 0, x, fr_y_pb, CORNER_LEFT_UPPER, "0", "Webdings", 25, clrNONE, 0, ANCHOR_RIGHT, false, false, true, 0, "\n");
      fr_y_pb -= Dpi(5);
     }
//---
  }
//+------------------------------------------------------------------+
//| UpdateProBar                                                     |
//+------------------------------------------------------------------+
void UpdateProBar(string _Symb, double Percent)
  {
//---
   for(int i = 1; i < 11; i++)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+IntegerToString(i)+" - "+_Symb, OBJPROP_COLOR, SelectedTheme == 0?clrGainsboro: C'80, 80, 80');
//---
   if(Percent >= 0)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"1"+" - "+_Symb, OBJPROP_COLOR, C'255, 0, 0');
//---
   if(Percent > 10)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"2"+" - "+_Symb, OBJPROP_COLOR, C'255, 69, 0');
//---
   if(Percent > 20)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"3"+" - "+_Symb, OBJPROP_COLOR, C'255, 150, 0');
//---
   if(Percent > 30)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"4"+" - "+_Symb, OBJPROP_COLOR, C'255, 165, 0');
//---
   if(Percent > 40)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"5"+" - "+_Symb, OBJPROP_COLOR, C'255, 215, 0');
//---
   if(Percent > 50)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"6"+" - "+_Symb, OBJPROP_COLOR, C'255, 255, 0');
//---
   if(Percent > 60)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"7"+" - "+_Symb, OBJPROP_COLOR, C'173, 255, 47');
//---
   if(Percent > 70)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"8"+" - "+_Symb, OBJPROP_COLOR, C'124, 252, 0');
//---
   if(Percent > 80)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"9"+" - "+_Symb, OBJPROP_COLOR, C'0, 255, 0');
//---
   if(Percent > 90)
      ObjectSetInteger(0, OBJPREFIX+"PB#"+"10"+" - "+_Symb, OBJPROP_COLOR, C'0, 255, 0');
//---
  }
//+------------------------------------------------------------------+
//| CreateMinWindow                                                  |
//+------------------------------------------------------------------+
void CreateMinWindow()
  {
//---
   RectLabelCreate(0, OBJPREFIX+"MIN"+"BCKGRND[]", 0, Dpi(1), Dpi(20), Dpi(163), Dpi(25), COLOR_BORDER, BORDER_FLAT, CORNER_LEFT_LOWER, COLOR_BORDER, STYLE_SOLID, 1, false, false, true, 0, "\n");
//---
   LabelCreate(0, OBJPREFIX+"MIN"+"CAPTION", 0, Dpi(140)-Dpi(64), Dpi(18), CORNER_LEFT_LOWER, "MultiTrader", "Arial Black", 8, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 0, "\n", false);
//---
   LabelCreate(0, OBJPREFIX+"MIN"+"MAXIMIZE", 0, Dpi(156), Dpi(23), CORNER_LEFT_LOWER, "1", "Webdings", 10, C'59, 41, 40', 0, ANCHOR_UPPER, false, false, true, 0, "\n", false);
//---
  }
//+------------------------------------------------------------------+
//| DelteMinWindow                                                   |
//+------------------------------------------------------------------+
void DelteMinWindow()
  {
//---
   ObjectDelete(0, OBJPREFIX+"MIN"+"BCKGRND[]");
   ObjectDelete(0, OBJPREFIX+"MIN"+"CAPTION");
   ObjectDelete(0, OBJPREFIX+"MIN"+"MAXIMIZE");
//---
  }

//+------------------------------------------------------------------+
//| UpdateSymbolGUI                                                  |
//+------------------------------------------------------------------+
void ObjectsUpdateAll(string _Symb)
  {
//--- Market info
   double bid = SymbolInfoDouble(_Symb, SYMBOL_BID),
          ask = SymbolInfoDouble(_Symb, SYMBOL_ASK),
          avg = (ask+bid)/2;
//---
   double TFHigh = iHigh(_Symb, PERIOD_CURRENT, 0),
          TFLow = iLow(_Symb, PERIOD_CURRENT, 0),
          TFOpen = iOpen(_Symb, PERIOD_CURRENT, 0);
//---
   double TFLastHigh = iHigh(_Symb, PERIOD_CURRENT, 1),
          TFLastLow = iLow(_Symb, PERIOD_CURRENT, 1),
          TFLastClose = iClose(_Symb, PERIOD_CURRENT, 1);
//---
   long Spread = SymbolInfoInteger(_Symb, SYMBOL_SPREAD);
   int digits = (int)SymbolInfoInteger(_Symb, SYMBOL_DIGITS);

//--- Range
   double pts = SymbolInfoDouble(_Symb, SYMBOL_POINT);

  }

//


//+------------------------------------------------------------------+
//| SpeedOmeter                                                      |
//+------------------------------------------------------------------+
void SpeedOmeter(string _Symb)
  {
//--- CalcSpeed
   double Pts = SymbolInfoDouble(_Symb, SYMBOL_POINT),
          LastPrice = 0,
          CurrentPrice = 0;

//---
   if(Pts != 0)
     {
      //---
      LastPrice = GlobalVariableGet(OBJPREFIX+_Symb+" - Price")/Pts;
      //---
      CurrentPrice = ((SymbolInfoDouble(_Symb, SYMBOL_ASK)+SymbolInfoDouble(_Symb, SYMBOL_BID))/2)/Pts;
     }

//---
   double Speed = NormalizeDouble((CurrentPrice-LastPrice), 0);

//---
   GlobalVariableSet(OBJPREFIX+_Symb+" - Price", (SymbolInfoDouble(_Symb, SYMBOL_ASK)+SymbolInfoDouble(_Symb, SYMBOL_BID))/2);

//--- SetMaxSpeed
   if(Speed > 99)
      Speed = 99;



//--- ResetColors
   if(ShowDashboard)
     {
      //---
      for(int i = 0; i < (10); i++)
        {
         //--- SetObjects
         if(ObjectFind(0, OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i, 0, 0)) == 0)
            ObjectSetInteger(0, OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i, 0, 0), OBJPROP_COLOR, clrNONE);
         //---
         if(ObjectFind(0, OBJPREFIX+"SPEEDª"+" - "+_Symb) == 0)
            ObjectSetInteger(0, OBJPREFIX+"SPEEDª"+" - "+_Symb, OBJPROP_COLOR, clrNONE);
        }
      //--- SetColor&Text
      for(int i = 0; i < MathAbs(Speed); i++)
        {
         //--- PositiveValue
         if(Speed > 0)
           {
            //--- SetObjects
            if(ObjectFind(0, OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i, 0, 0)) == 0)
               ObjectSetInteger(0, OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i, 0, 0), OBJPROP_COLOR, COLOR_BUY);
            //---
            if(ObjectFind(0, OBJPREFIX+"SPEEDª"+" - "+_Symb) == 0)
               ObjectSetInteger(0, OBJPREFIX+"SPEEDª"+" - "+_Symb, OBJPROP_COLOR, COLOR_BUY);
           }
         //--- NegativeValue
         if(Speed < 0)
           {
            //--- SetObjects
            if(ObjectFind(0, OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i, 0, 0)) == 0)
               ObjectSetInteger(0, OBJPREFIX+"SPEED#"+" - "+_Symb+IntegerToString(i, 0, 0), OBJPROP_COLOR, COLOR_SELL);
            //---
            if(ObjectFind(0, OBJPREFIX+"SPEEDª"+" - "+_Symb) == 0)
               ObjectSetInteger(0, OBJPREFIX+"SPEEDª"+" - "+_Symb, OBJPROP_COLOR, COLOR_SELL);
           }
         //---
         if(ObjectFind(0, OBJPREFIX+"SPEEDª"+" - "+_Symb) == 0)
            ObjectSetString(0, OBJPREFIX+"SPEEDª"+" - "+_Symb, OBJPROP_TEXT, 0, ±Str(Speed, 0)); //SetObject
        }
     }
//---
  }


//+------------------------------------------------------------------+
//| GetSetInputs                                                     |
//+------------------------------------------------------------------+
void GetSetInputs(const string _Symb)
  {

//---
  }
//+------------------------------------------------------------------+
//| GetParam                                                         |
//+------------------------------------------------------------------+
void GetParam(string p)
  {
//---
   if(p == OBJPREFIX+" ")
     {
      //---
      double pVal = TerminalInfoInteger(TERMINAL_PING_LAST);
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
         dString("70FA849373E41928")+DoubleToString(pVal/1000, 2)+dString("CDB9155CB6080FC4")
         +"\n\n"+
         //---
         dString("47EFF8FADDDA4F05FB300EB05BD2AEC9")+dString("97BA10D5D76C54AE")
         +"\n\n"+
         "Author: "+"Dr YouSuf MeSalm "
         +"\n\n"+
         "www.YousufMesalm.com"
         +"\n\n"+
         Link
         //---, MB_CAPTION, MB_ICONINFORMATION|MB_OK
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
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);

  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| SymbPerc                                                         |
//+------------------------------------------------------------------+
double SymbPerc(string _Symb)
  {
//---
   double percent = 0,
          range = iHigh(_Symb, PERIOD_CURRENT, 0)-iLow(_Symb, PERIOD_CURRENT, 0);
//---
   if(range != 0)
      percent = 100*((iClose(_Symb, PERIOD_CURRENT, 0)-iLow(_Symb, PERIOD_CURRENT, 0))/range);
//---
   return(percent);
  }
//+------------------------------------------------------------------+
//| ±Str                                                             |
//+------------------------------------------------------------------+
string ±Str(double Inp, int Precision)
  {
//--- PositiveValue
   if(Inp > 0)
      return("+"+DoubleToString(Inp, Precision));
//--- NegativeValue
   else
      return(DoubleToString(Inp, Precision));
//---
  }
//+------------------------------------------------------------------+
//| ±Clr                                                             |
//+------------------------------------------------------------------+
color ±Clr(double Inp)
  {
//---
   color clr = clrNONE;
//--- PositiveValue
   if(Inp > 0)
      clr = COLOR_GREEN;
//--- NegativeValue
   if(Inp < 0)
      clr = COLOR_RED;
//--- NeutralValue
   if(Inp == 0)
      clr = COLOR_FONT;
//---
   return(clr);
  }
//+------------------------------------------------------------------+
//| ±ClrBR                                                           |
//+------------------------------------------------------------------+
color ±ClrBR(double Inp)
  {
//---
   color clr = clrNONE;
//--- PositiveValue
   if(Inp > 0)
      clr = COLOR_BUY;
//--- NegativeValue
   if(Inp < 0)
      clr = COLOR_SELL;
//--- NeutralValue
   if(Inp == 0)
      clr = COLOR_FONT;
//---
   return(clr);
  }

//+------------------------------------------------------------------+
//| _AccountCurrency                                                 |
//+------------------------------------------------------------------+
string _AccountCurrency()
  {
//---
   string txt = "";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "AUD")
      txt = "$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "BGN")
      txt = "B";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "CAD")
      txt = "$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "CHF")
      txt = "F";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "COP")
      txt = "$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "CRC")
      txt = "₡";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "CUP")
      txt = "₱";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "CZK")
      txt = "K";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "EUR")
      txt = "€";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "GBP")
      txt = "£";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "GHS")
      txt = "¢";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "HKD")
      txt = "$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "JPY")
      txt = "¥";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "NGN")
      txt = "₦";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "NOK")
      txt = "k";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "NZD")
      txt = "$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "USD")
      txt = "$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "RUB")
      txt = "₽";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "SGD")
      txt = "$";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "ZAR")
      txt = "R";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "SEK")
      txt = "k";
//---
   if(AccountInfoString(ACCOUNT_CURRENCY) == "VND")
      txt = "₫";
//---
   if(txt == "")
      txt = "$";
//---
   return(txt);
  }


//+------------------------------------------------------------------+
//| SymbolFind                                                       |
//+------------------------------------------------------------------+
bool SymbolFind(const string _Symb, int mode)
  {
//---
   bool result = false;
//---
   for(int i = 0; i < SymbolsTotal(mode); i++)
     {
      //---
      if(_Symb == SymbolName(i, mode))
        {
         result = true; //SymbolFound
         break;
        }
     }
//---
   return(result);
  }

//+------------------------------------------------------------------+
//| Symbols                                                          |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| SetFull                                                          |
//+------------------------------------------------------------------+
void SetFull()
  {
//---
   ArrayResize(UsedSymbols, 28, 0);
//---
   UsedSymbols[0] = "AUDCAD";
   UsedSymbols[1] = "AUDCHF";
   UsedSymbols[2] = "AUDJPY";
   UsedSymbols[3] = "AUDNZD";
   UsedSymbols[4] = "AUDUSD";
//---
   UsedSymbols[5] = "CADCHF";
   UsedSymbols[6] = "CADJPY";
   UsedSymbols[7] = "CHFJPY";
//---
   UsedSymbols[8] = "EURAUD";
   UsedSymbols[9] = "EURCAD";
   UsedSymbols[10] = "EURCHF";
   UsedSymbols[11] = "EURGBP";
   UsedSymbols[12] = "EURJPY";
   UsedSymbols[13] = "EURNZD";
   UsedSymbols[14] = "EURUSD";
//---
   UsedSymbols[15] = "GBPAUD";
   UsedSymbols[16] = "GBPCAD";
   UsedSymbols[17] = "GBPCHF";
//---
   UsedSymbols[18] = "GBPNZD";
   UsedSymbols[19] = "GBPUSD";
   UsedSymbols[20] = "GBPJPY";
//---
   UsedSymbols[21] = "NZDCHF";
   UsedSymbols[22] = "NZDCAD";
   UsedSymbols[23] = "NZDJPY";
   UsedSymbols[24] = "NZDUSD";
//---
   UsedSymbols[25] = "USDCAD";
   UsedSymbols[26] = "USDCHF";
   UsedSymbols[27] = "USDJPY";
//---
  }
//+------------------------------------------------------------------+
//| SetStatus                                                        |
//+------------------------------------------------------------------+
void SetStatus(string Char, string Text)
  {
//---
   Comment("");
//---
   stauts_time = TimeLocal();
//---
   ObjectSetString(0, OBJPREFIX+"STATUS", OBJPROP_TEXT, Char);
   ObjectSetString(0, OBJPREFIX+"STATUS«", OBJPROP_TEXT, Text);
//---
  }
//+------------------------------------------------------------------+
//| ResetStatus                                                      |
//+------------------------------------------------------------------+
void ResetStatus()
  {
//---
   if(ObjectGetString(0, OBJPREFIX+"STATUS", OBJPROP_TEXT) != "\n" || ObjectGetString(0, OBJPREFIX+"STATUS«", OBJPROP_TEXT) != "\n")
     {
      ObjectSetString(0, OBJPREFIX+"STATUS", OBJPROP_TEXT, "\n");
      ObjectSetString(0, OBJPREFIX+"STATUS«", OBJPROP_TEXT, "\n");
     }
//---
  }
//+------------------------------------------------------------------+
//| Dpi                                                              |
//+------------------------------------------------------------------+
int Dpi(int Size)
  {
//---
   int screen_dpi = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   int base_width = Size;
   int width = (base_width*screen_dpi)/96;
   int scale_factor = (TerminalInfoInteger(TERMINAL_SCREEN_DPI)*100)/96;
//---
   width = (base_width*scale_factor)/100;
//---
   return(width);
  }
//+------------------------------------------------------------------+
//| dString                                                          |
//+------------------------------------------------------------------+
string dString(string text)
  {
//---
   uchar in[],
         out[],
         key[];
//---
   StringToCharArray("H+#eF_He", key);
//---
   StringToCharArray(text, in, 0, StringLen(text));
//---
   HexToArray(text, in);
//---
   CryptDecode(CRYPT_DES, in, key, out);
//---
   string result = CharArrayToString(out);
//---
   return(result);
  }
//+------------------------------------------------------------------+
//| HexToArray                                                       |
//+------------------------------------------------------------------+
bool HexToArray(string str, uchar &arr[])
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
   StringToCharArray(str, tc);
//---
   int i = 0,
       j = 0;
//---
   for(i = 0; i < strcount; i += 2)
     {
      //---
      uchar tmpchr = (HEXCHAR_TO_DECCHAR(tc[i])<<4)+HEXCHAR_TO_DECCHAR(tc[i+1]);
      //---
      arr[j] = tmpchr;
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
string ArrayToHex(uchar &arr[], int count = -1)
  {
   string res = "";
//---
   if(count < 0 || count > ArraySize(arr))
      count = ArraySize(arr);
//---
   for(int i = 0; i < count; i++)
      res += StringFormat("%.2X", arr[i]);
//---
   return(res);
  }
//+------------------------------------------------------------------+
//|  ChartSetColor                                                   |
//+------------------------------------------------------------------+
void ChartSetColor(const int Type)
  {
//--- Set Light
   if(Type == 0)
     {
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, COLOR_CBG_LIGHT);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, COLOR_FONT);
      ChartSetInteger(0, CHART_COLOR_GRID, clrNONE);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, COLOR_CBG_LIGHT);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, COLOR_CBG_LIGHT);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, COLOR_CBG_LIGHT);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, COLOR_CBG_LIGHT);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, COLOR_CBG_LIGHT);
      ChartSetInteger(0, CHART_COLOR_VOLUME, COLOR_CBG_LIGHT);
      ChartSetInteger(0, CHART_COLOR_ASK, clrNONE);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, COLOR_CBG_LIGHT);
      //---
      ChartSetInteger(0, CHART_SHOW_OHLC, false);
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, false);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, false);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_SHOW_VOLUMES, false);
      ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, false);
      ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, false);
     }

//--- Set Dark
   if(Type == 1)
     {
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, COLOR_CBG_DARK);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, COLOR_FONT);
      ChartSetInteger(0, CHART_COLOR_GRID, clrNONE);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, COLOR_CBG_DARK);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, COLOR_CBG_DARK);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, COLOR_CBG_DARK);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, COLOR_CBG_DARK);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, COLOR_CBG_DARK);
      ChartSetInteger(0, CHART_COLOR_VOLUME, COLOR_CBG_DARK);
      ChartSetInteger(0, CHART_COLOR_ASK, clrNONE);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, COLOR_CBG_DARK);
      //---
      ChartSetInteger(0, CHART_SHOW_OHLC, false);
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, false);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, false);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_SHOW_VOLUMES, false);
      ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, false);
      ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, false);
     }

//--- Set Original
   if(Type == 2)
     {
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, ChartColor_BG);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, ChartColor_FG);
      ChartSetInteger(0, CHART_COLOR_GRID, ChartColor_GD);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, ChartColor_UP);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, ChartColor_DWN);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, ChartColor_BULL);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, ChartColor_BEAR);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, ChartColor_LINE);
      ChartSetInteger(0, CHART_COLOR_VOLUME, ChartColor_VOL);
      ChartSetInteger(0, CHART_COLOR_ASK, ChartColor_ASK);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, ChartColor_LVL);
      //---
      ChartSetInteger(0, CHART_SHOW_OHLC, ChartColor_OHLC);
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, ChartColor_ASKLINE);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, ChartColor_PERIODSEP);
      ChartSetInteger(0, CHART_SHOW_GRID, ChartColor_GRID);
      ChartSetInteger(0, CHART_SHOW_VOLUMES, ChartColor_SHOWVOL);
      ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, ChartColor_OBJDESCR);
      ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, ChartColor_TRADELVL);
     }

//---
   if(Type == 3)
     {
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrWhite);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrBlack);
      ChartSetInteger(0, CHART_COLOR_GRID, clrSilver);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, clrBlack);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrBlack);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrWhite);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrBlack);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrBlack);
      ChartSetInteger(0, CHART_COLOR_VOLUME, clrGreen);
      ChartSetInteger(0, CHART_COLOR_ASK, clrOrangeRed);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, clrOrangeRed);
      //---
      ChartSetInteger(0, CHART_SHOW_OHLC, false);
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, false);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, false);
      ChartSetInteger(0, CHART_SHOW_GRID, false);
      ChartSetInteger(0, CHART_SHOW_VOLUMES, false);
      ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, false);
     }
//---
  }
//+------------------------------------------------------------------+
//| ChartGetColor                                                    |
//+------------------------------------------------------------------+
//---- Original Template
color ChartColor_BG = 0, ChartColor_FG = 0, ChartColor_GD = 0, ChartColor_UP = 0, ChartColor_DWN = 0, ChartColor_BULL = 0, ChartColor_BEAR = 0, ChartColor_LINE = 0, ChartColor_VOL = 0, ChartColor_ASK = 0, ChartColor_LVL = 0;
//---
bool ChartColor_OHLC = false, ChartColor_ASKLINE = false, ChartColor_PERIODSEP = false, ChartColor_GRID = false, ChartColor_SHOWVOL = false, ChartColor_OBJDESCR = false, ChartColor_TRADELVL = false;
//----
void ChartGetColor()
  {
   ChartColor_BG = (color)ChartGetInteger(0, CHART_COLOR_BACKGROUND, 0);
   ChartColor_FG = (color)ChartGetInteger(0, CHART_COLOR_FOREGROUND, 0);
   ChartColor_GD = (color)ChartGetInteger(0, CHART_COLOR_GRID, 0);
   ChartColor_UP = (color)ChartGetInteger(0, CHART_COLOR_CHART_UP, 0);
   ChartColor_DWN = (color)ChartGetInteger(0, CHART_COLOR_CHART_DOWN, 0);
   ChartColor_BULL = (color)ChartGetInteger(0, CHART_COLOR_CANDLE_BULL, 0);
   ChartColor_BEAR = (color)ChartGetInteger(0, CHART_COLOR_CANDLE_BEAR, 0);
   ChartColor_LINE = (color)ChartGetInteger(0, CHART_COLOR_CHART_LINE, 0);
   ChartColor_VOL = (color)ChartGetInteger(0, CHART_COLOR_VOLUME, 0);
   ChartColor_ASK = (color)ChartGetInteger(0, CHART_COLOR_ASK, 0);
   ChartColor_LVL = (color)ChartGetInteger(0, CHART_COLOR_STOP_LEVEL, 0);
//---
   ChartColor_OHLC = ChartGetInteger(0, CHART_SHOW_OHLC, 0);
   ChartColor_ASKLINE = ChartGetInteger(0, CHART_SHOW_ASK_LINE, 0);
   ChartColor_PERIODSEP = ChartGetInteger(0, CHART_SHOW_PERIOD_SEP, 0);
   ChartColor_GRID = ChartGetInteger(0, CHART_SHOW_GRID, 0);
   ChartColor_SHOWVOL = ChartGetInteger(0, CHART_SHOW_VOLUMES, 0);
   ChartColor_OBJDESCR = ChartGetInteger(0, CHART_SHOW_OBJECT_DESCR, 0);
   ChartColor_TRADELVL = ChartGetInteger(0, CHART_SHOW_TRADE_LEVELS, 0);
//---
  }
//+------------------------------------------------------------------+
//| ChartMiddleX                                                     |
//+------------------------------------------------------------------+
int ChartMiddleX()
  {
   return((int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| ChartMiddleY                                                     |
//+------------------------------------------------------------------+
int ChartMiddleY()
  {
   return((int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS)/2);
  }
//+------------------------------------------------------------------+
//| Create rectangle label                                           |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_rectangle_label
bool RectLabelCreate(const long chart_ID = 0, // chart's ID
                     const string name = "RectLabel", // label name
                     const int sub_window = 0, // subwindow index
                     const int x = 0, // X coordinate
                     const int y = 0, // Y coordinate
                     const int width = 50, // width
                     const int height = 18, // height
                     const color back_clr = C'236, 233, 216', // background color
                     const ENUM_BORDER_TYPE border = BORDER_SUNKEN, // border type
                     const ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color clr = clrRed, // flat border color (Flat)
                     const ENUM_LINE_STYLE style = STYLE_SOLID, // flat border style
                     const int line_width = 1, // flat border width
                     const bool back = false, // in the background
                     const bool selection = false, // highlight to move
                     const bool hidden = true, // hidden in the object list
                     const long z_order = 0, // priority for mouse click
                     const string tooltip = "\n") // tooltip for mouse hover
  {
//---- reset the error value
   ResetLastError();
//---
   if(ObjectFind(chart_ID, name) != 0)
     {
      if(!ObjectCreate(chart_ID, name, OBJ_RECTANGLE_LABEL, sub_window, 0, 0))
        {
         Print(__FUNCTION__,
               ": failed to create a rectangle label! Error code = ", _LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_TYPE, border);
      ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
      ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, line_width);
      ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
      ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
      ObjectSetString(chart_ID, name, OBJPROP_TOOLTIP, tooltip);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a text label                                              |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_label
bool LabelCreate(const long chart_ID = 0, // chart's ID
                 const string name = "Label", // label name
                 const int sub_window = 0, // subwindow index
                 const int x = 0, // X coordinate
                 const int y = 0, // Y coordinate
                 const ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string text = "Label", // text
                 const string font = "Arial", // font
                 const int font_size = 10, // font size
                 const color clr = clrRed, // color
                 const double angle = 0.0, // text slope
                 const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // anchor type
                 const bool back = false, // in the background
                 const bool selection = false, // highlight to move
                 const bool hidden = true, // hidden in the object list
                 const long z_order = 0, // priority for mouse click
                 const string tooltip = "\n", // tooltip for mouse hover
                 const bool tester = true) // create object in the strategy tester
  {
//--- reset the error value
   ResetLastError();
//--- CheckTester
   if(!tester && MQLInfoInteger(MQL_TESTER))
      return(false);
//---
   if(ObjectFind(chart_ID, name) < 0)
     {
      if(!ObjectCreate(chart_ID, name, OBJ_LABEL, sub_window, 0, 0))
        {
         Print(__FUNCTION__,
               ": failed to create text label! Error code = ", _LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
      ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
      ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
      ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
      ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, angle);
      ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
      ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
      ObjectSetString(chart_ID, name, OBJPROP_TOOLTIP, tooltip);
     }
   else
     {
      ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create Edit object                                               |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_edit
bool EditCreate(const long chart_ID = 0, // chart's ID
                const string name = "Edit", // object name
                const int sub_window = 0, // subwindow index
                const int x = 0, // X coordinate
                const int y = 0, // Y coordinate
                const int width = 50, // width
                const int height = 18, // height
                const string text = "Text", // text
                const string font = "Arial", // font
                const int font_size = 10, // font size
                const ENUM_ALIGN_MODE align = ALIGN_CENTER, // alignment type
                const bool read_only = false, // ability to edit
                const ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                const color clr = clrBlack, // text color
                const color back_clr = clrWhite, // background color
                const color border_clr = clrNONE, // border color
                const bool back = false, // in the background
                const bool selection = false, // highlight to move
                const bool hidden = true, // hidden in the object list
                const long z_order = 0, // priority for mouse click
                const string tooltip = "\n") // tooltip for mouse hover
  {
//--- reset the error value
   ResetLastError();
//---
   if(ObjectFind(chart_ID, name) != 0)
     {
      if(!ObjectCreate(chart_ID, name, OBJ_EDIT, sub_window, 0, 0))
        {
         Print(__FUNCTION__,
               ": failed to create \"Edit\" object! Error code = ", _LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
      ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
      ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
      ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
      ObjectSetInteger(chart_ID, name, OBJPROP_ALIGN, align);
      ObjectSetInteger(chart_ID, name, OBJPROP_READONLY, read_only);
      ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
      ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
      ObjectSetString(chart_ID, name, OBJPROP_TOOLTIP, tooltip);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the button                                                |
//+------------------------------------------------------------------+
//https://docs.mql4.com/constants/objectconstants/enum_object/obj_button
bool ButtonCreate(const long chart_ID = 0, // chart's ID
                  const string name = "Button", // button name
                  const int sub_window = 0, // subwindow index
                  const int x = 0, // X coordinate
                  const int y = 0, // Y coordinate
                  const int width = 50, // button width
                  const int height = 18, // button height
                  const ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                  const string text = "Button", // text
                  const string font = "Arial", // font
                  const int font_size = 10, // font size
                  const color clr = clrBlack, // text color
                  const color back_clr = C'236, 233, 216', // background color
                  const color border_clr = clrNONE, // border color
                  const bool state = false, // pressed/released
                  const bool back = false, // in the background
                  const bool selection = false, // highlight to move
                  const bool hidden = true, // hidden in the object list
                  const long z_order = 0, // priority for mouse click
                  const string tooltip = "\n") // tooltip for mouse hover
  {
//--- reset the error value
   ResetLastError();
//---
   if(ObjectFind(chart_ID, name) != 0)
     {
      if(!ObjectCreate(chart_ID, name, OBJ_BUTTON, sub_window, 0, 0))
        {
         Print(__FUNCTION__,
               ": failed to create the button! Error code = ", _LastError);
         return(false);
        }
      //--- SetObjects
      ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
      ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
      ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
      ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
      ObjectSetInteger(chart_ID, name, OBJPROP_STATE, state);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
      ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
      ObjectSetString(chart_ID, name, OBJPROP_TOOLTIP, tooltip);
     }
   else
     {
      ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
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
   if(!ChartSetInteger(0, CHART_MOUSE_SCROLL, 0, value))
     {
      Print(__FUNCTION__,
            ", Error Code = ", _LastError);
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
//+------------------------------------------------------------------+
void  checkTrail()
  {
   int count=OrdersTotal();
   double ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,MODE_TRADES);

      if(OrderMagicNumber()==magic_Number)
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

      if(OrderMagicNumber()==magic_Number)
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

      if(OrderMagicNumber()==magic_Number)
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
//|                                                                  |
//+------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------+
//| Download XML file from forexfactory                                                       |
//| for windows 7 and later file path would be:                                               |
//| C:\Users\xxx\AppData\Roaming\MetaQuotes\Terminal\xxxxxxxxxxxxxxx\MQL4\Files\xmlFileName   |
//+-------------------------------------------------------------------------------------------+
void xmlDownload()
  {
//---
   ResetLastError();
   string sUrl="https://nfs.faireconomy.media/ff_calendar_thisweek.xml";
   string FilePath=StringConcatenate(TerminalInfoString(TERMINAL_DATA_PATH),"\\MQL4\\files\\",xmlFileName);
   int FileGet=URLDownloadToFileW(NULL,sUrl,FilePath,0,NULL);
   if(FileGet==0)
      PrintFormat(INAME+": %s file downloaded successfully!",xmlFileName);
//--- check for errors
   else
      PrintFormat(INAME+": failed to download %s file, Error code = %d",xmlFileName,GetLastError());
//---
  }
//+------------------------------------------------------------------+
//| Read the XML file                                                |
//+------------------------------------------------------------------+
void xmlRead()
  {
//---
   ResetLastError();
   int FileHandle=FileOpen(xmlFileName,FILE_BIN|FILE_READ);
   if(FileHandle!=INVALID_HANDLE)
     {
      //--- receive the file size
      ulong size=FileSize(FileHandle);
      //--- read data from the file
      while(!FileIsEnding(FileHandle))
         sData=FileReadString(FileHandle,(int)size);
      //--- close
      FileClose(FileHandle);
     }
//--- check for errors
   else
      PrintFormat(INAME+": failed to open %s file, Error code = %d",xmlFileName,GetLastError());
//---
  }
//+------------------------------------------------------------------+
//| Check for update XML                                             |
//+------------------------------------------------------------------+
void xmlUpdate()
  {
//--- do not download on saturday
   if(TimeDayOfWeek(Midnight)==6)
      return;
   else
     {
      Print(INAME+": check for updates...");
      Print(INAME+": delete old file");
      FileDelete(xmlFileName);
      xmlDownload();
      xmlRead();
      xmlModifed=(datetime)FileGetInteger(xmlFileName,FILE_MODIFY_DATE,false);
      PrintFormat(INAME+": updated successfully! last modified: %s",(string)xmlModifed);
     }
//---
  }
//+------------------------------------------------------------------+
//| Draw panel and events on the chart                               |
//+------------------------------------------------------------------+
void DrawEvents()
  {
   string FontName = "Arial";
   int    FontSize = 8;
   string eToolTip = "";
//--- draw backbround / date / special note
   if(ShowPanel && ShowPanelBG)
     {
      eToolTip="Hover on the Event!";
      Draw("BG","gggg",85,"Webdings",Pbgc,Corner,x0,3,eToolTip);
      Draw("Date",DayToStr(Midnight)+", "+MonthToStr()+" "+(string)TimeDay(Midnight),FontSize+1,"Arial Black",TitleColor,Corner,x2,95,"Today");
      Draw("Title",PanelTitle,FontSize,FontName,TitleColor,Corner,x1,95,"Panel Title");
      Draw("Spreator","------",10,"Arial",RemarksColor,Corner,x2,83,eToolTip);
     }
//--- draw objects / alert functions
   for(int i=0; i<5; i++)
     {
      eToolTip=eTitle[i]+"\nCurrency: "+eCountry[i]+"\nTime left: "+(string)eMinutes[i]+" Minutes"+"\nImpact: "+eImpact[i];
      //--- impact color
      color EventColor=ImpactToColor(eImpact[i]);
      //--- previous/forecast color
      color ForecastColor=PreviousColor;
      if(ePrevious[i]>eForecast[i])
         ForecastColor=NegativeColor;
      else
         if(ePrevious[i]<eForecast[i])
            ForecastColor=PositiveColor;
      //--- past event color
      if(eMinutes[i]<0)
         EventColor=ForecastColor=PreviousColor=RemarksColor;
      //--- panel
      if(ShowPanel)
        {
         //--- date/time / title / currency
         Draw("Event "+(string)i,
              DayToStr(eTime[i])+"  |  "+
              TimeToStr(eTime[i],TIME_MINUTES)+"  |  "+
              eCountry[i]+"  |  "+
              eTitle[i],FontSize,FontName,EventColor,Corner,x2,70-i*15,eToolTip);
         //--- forecast
         Draw("Event Forecast "+(string)i,"[ "+eForecast[i]+" ]",FontSize,FontName,ForecastColor,Corner,xf,70-i*15,
              "Forecast: "+eForecast[i]);
         //--- previous
         Draw("Event Previous "+(string)i,"[ "+ePrevious[i]+" ]",FontSize,FontName,PreviousColor,Corner,xp,70-i*15,
              "Previous: "+ePrevious[i]);
        }
      //--- vertical news
      if(ShowVerticalNews)
         DrawLine("Event Line "+(string)i,eTime[i]+(ChartTimeOffset*3600),EventColor,eToolTip);
      //--- Set alert message
      if(eImpact[i]=="High")
        {
         string AlertMessage=(string)eMinutes[i]+" Minutes until ["+eTitle[i]+"] Event on "+eCountry[i]+
                             "\nImpact: "+eImpact[i]+
                             "\nForecast: "+eForecast[i]+
                             "\nPrevious: "+ePrevious[i];
         //--- first alert
         if(Alert1Minutes!=-1 && eMinutes[i]==Alert1Minutes && !FirstAlert)
           {
            setAlerts("First Alert! "+AlertMessage);
            FirstAlert=true;
           }
         //--- second alert
         if(Alert2Minutes!=-1 && eMinutes[i]==Alert2Minutes && !SecondAlert)
           {
            setAlerts("Second Alert! "+AlertMessage);
            SecondAlert=true;
           }
        }
      //--- break if no more data
      if(eTitle[i]==eTitle[i+1])
        {
         Draw(INAME+" no more events","NO MORE EVENTS",8,"Arial",RemarksColor,Corner,x2,50-i*15,"Get some rest!");
         break;
        }
     }
//---
  }
//+-----------------------------------------------------------------------------------------------+
//| Subroutine: to ID currency even if broker has added a prefix to the symbol, and is used to    |
//| determine the news to show, based on the users external inputs - by authors (Modified)        |
//+-----------------------------------------------------------------------------------------------+
bool IsCurrency(string symbol)
  {
//---
   if(ReportForUSD && symbol == "USD")
      return(true);
   else
      if(ReportForGBP && symbol == "GBP")
         return(true);
      else
         if(ReportForEUR && symbol == "EUR")
            return(true);
         else
            if(ReportForCAD && symbol == "CAD")
               return(true);
            else
               if(ReportForAUD && symbol == "AUD")
                  return(true);
               else
                  if(ReportForCHF && symbol == "CHF")
                     return(true);
                  else
                     if(ReportForJPY && symbol == "JPY")
                        return(true);
                     else
                        if(ReportForNZD && symbol == "NZD")
                           return(true);
                        else
                           if(ReportForCNY && symbol == "CNY")
                              return(true);
   return(false);
//---
  }
//+------------------------------------------------------------------+
//| Converts ff time & date into yyyy.mm.dd hh:mm - by deVries       |
//+------------------------------------------------------------------+
string MakeDateTime(string strDate,string strTime)
  {
//---
   int n1stDash=StringFind(strDate, "-");
   int n2ndDash=StringFind(strDate, "-", n1stDash+1);

   string strMonth=StringSubstr(strDate,0,2);
   string strDay=StringSubstr(strDate,3,2);
   string strYear=StringSubstr(strDate,6,4);

   int nTimeColonPos=StringFind(strTime,":");
   string strHour=StringSubstr(strTime,0,nTimeColonPos);
   string strMinute=StringSubstr(strTime,nTimeColonPos+1,2);
   string strAM_PM=StringSubstr(strTime,StringLen(strTime)-2);

   int nHour24=StrToInteger(strHour);
   if((strAM_PM=="pm" || strAM_PM=="PM") && nHour24!=12)
      nHour24+=12;
   if((strAM_PM=="am" || strAM_PM=="AM") && nHour24==12)
      nHour24=0;
   string strHourPad="";
   if(nHour24<10)
      strHourPad="0";
   return(StringConcatenate(strYear, ".", strMonth, ".", strDay, " ", strHourPad, nHour24, ":", strMinute));
//---
  }
//+------------------------------------------------------------------+
//| set impact Color - by authors                                    |
//+------------------------------------------------------------------+
color ImpactToColor(string impact)
  {
//---
   if(impact == "High")
      return (HighImpactColor);
   else
      if(impact == "Medium")
         return (MediumImpactColor);
      else
         if(impact == "Low")
            return (LowImpactColor);
         else
            if(impact == "Holiday")
               return (HolidayColor);
            else
               return (RemarksColor);
//---
  }
//+------------------------------------------------------------------+
//| Impact to number - by authors                                    |
//+------------------------------------------------------------------+
int ImpactToNumber(string impact)
  {
//---
   if(impact == "High")
      return(3);
   else
      if(impact == "Medium")
         return(2);
      else
         if(impact == "Low")
            return(1);
         else
            return(0);
//---
  }
//+------------------------------------------------------------------+
//| Convert day of the week to text                                  |
//+------------------------------------------------------------------+
string DayToStr(datetime time)
  {
   int ThisDay=TimeDayOfWeek(time);
   string day="";
   switch(ThisDay)
     {
      case 0:
         day="Sun";
         break;
      case 1:
         day="Mon";
         break;
      case 2:
         day="Tue";
         break;
      case 3:
         day="Wed";
         break;
      case 4:
         day="Thu";
         break;
      case 5:
         day="Fri";
         break;
      case 6:
         day="Sat";
         break;
     }
   return(day);
  }
//+------------------------------------------------------------------+
//| Convert months to text                                           |
//+------------------------------------------------------------------+
string MonthToStr()
  {
   int ThisMonth=Month();
   string month="";
   switch(ThisMonth)
     {
      case 1:
         month="Jan";
         break;
      case 2:
         month="Feb";
         break;
      case 3:
         month="Mar";
         break;
      case 4:
         month="Apr";
         break;
      case 5:
         month="May";
         break;
      case 6:
         month="Jun";
         break;
      case 7:
         month="Jul";
         break;
      case 8:
         month="Aug";
         break;
      case 9:
         month="Sep";
         break;
      case 10:
         month="Oct";
         break;
      case 11:
         month="Nov";
         break;
      case 12:
         month="Dec";
         break;
     }
   return(month);
  }
//+------------------------------------------------------------------+
//| Candle Time Left / Spread                                        |
//+------------------------------------------------------------------+
void SymbolInfo()
  {
//---
   string TimeLeft=TimeToStr(Time[0]+Period()*60-TimeCurrent(),TIME_MINUTES|TIME_SECONDS);
   string Spread=DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD)/Factor,1);
   double DayClose=iClose(NULL,PERIOD_D1,1);
   if(DayClose!=0)
     {
      double Strength=((Bid-DayClose)/DayClose)*100;
      string Label=DoubleToStr(Strength,2)+"%"+" / "+Spread+" / "+TimeLeft;
      ENUM_BASE_CORNER corner=1;
      if(Corner==1)
         corner=3;
      string arrow="q";
      if(Strength>0)
         arrow="p";
      string tooltip="Strength / Spread / Candle Time";
      Draw(INAME+": info",Label,InfoFontSize,"Calibri",InfoColor,corner,120,20,tooltip);
      Draw(INAME+": info arrow",arrow,InfoFontSize-2,"Wingdings 3",InfoColor,corner,130,18,tooltip);
     }
//---
  }
//+------------------------------------------------------------------+
//| draw event text                                                  |
//+------------------------------------------------------------------+
void Draw(string name,string label,int size,string font,color clr,ENUM_BASE_CORNER c,int x,int y,string tooltip)
  {
//---
   name=INAME+": "+name;
   int windows=0;
   if(AllowSubwindow && WindowsTotal()>1)
      windows=1;
   ObjectDelete(name);
   ObjectCreate(name,OBJ_LABEL,windows,0,0);
   ObjectSetText(name,label,size,font,clr);
   ObjectSet(name,OBJPROP_CORNER,c);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
//--- justify text
   ObjectSet(name,OBJPROP_ANCHOR,anchor);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,tooltip);
   ObjectSet(name,OBJPROP_SELECTABLE,0);
//---
  }
//+------------------------------------------------------------------+
//| draw vertical lines                                              |
//+------------------------------------------------------------------+
void DrawLine(string name,datetime time,color clr,string tooltip)
  {
//---
   name=INAME+": "+name;
   ObjectDelete(name);
   ObjectCreate(name,OBJ_VLINE,0,time,0);
   ObjectSet(name,OBJPROP_COLOR,clr);
   ObjectSet(name,OBJPROP_STYLE,2);
   ObjectSet(name,OBJPROP_WIDTH,0);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,tooltip);
//---
  }
//+------------------------------------------------------------------+
//| Notifications                                                    |
//+------------------------------------------------------------------+
void setAlerts(string message)
  {
//---
   if(PopupAlerts)
      Alert(message);
   if(SoundAlerts)
      PlaySound(AlertSoundFile);
   if(NotificationAlerts)
      SendNotification(message);
   if(EmailAlerts)
      SendMail(INAME,message);
   if(sendnews)
     {
      cc0=message;
     }
//---
  }
//+--------------------------- END ----------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
