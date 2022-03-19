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

#include  <YM\Execute\Execute.mqh>
#include  <YM\Position\Position.mqh>
#include <Indicators\Oscilators.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>
#include <Arrays\ArrayString.mqh>
#include <Arrays\ArrayObj.mqh>
#include  <TradeState.mqh>
//Enumuration
enum entry
  {
   buy,
   sell,
   buyAndsell,
   none,
  };

// inputs



sinput string                        set1                  = "Trading Settings";
input long                           magic_Number          = 2020;
input string                         comment               ="EA";
input entry                          EntryType             =buy;
input bool                           useMoneyManagment     =true;
input double                         xDollars              =1000; 
input double                         lot                   =0.1; // Lot for every xDollars
input double                         LotMultipiler         =1.5;
input int                            MultipilerStep        =15;
input double                         sl                    =100;
input double                         tp                    =100;
input bool                          Use_Trailing           = true;
input bool                          Use_BreakEven          = true;
input int                          TrailingStop            = 10;
input int                          BreakEvent              = 5;
input int                                 trailingStop=50;  //trailing stop for Profit trades
sinput string                              set2 = "<------------- Currency Pairs Settings----------->";
input string                               Suffix="";
input string                               Perfix="";
input string                               Pair1 = "EURUSD";
input string                               Pair2 = "USDCHF";
input string                               Pair3 = "USDCAD";
input string                               Pair4 = "USDJPY";
input string                               Pair5 = "GBPUSD";
input string                               Pair6 = "";
input string                               Pair7 = "";
input string                               Pair8 = "";
input string                               Pair9 = "";
input string                               Pair10 = "";
input string                               Pair11 = "";
input string                               Pair12 = "";
input string                               Pair13 = "";
input string                               Pair14 = "";
input string                               Pair15 = "";
input string                               Pair16 = "";
input string                               Pair17 = "";
input string                               Pair18 = "";
input string                               Pair19 = "";
input string                               Pair20 = "";
input string                               Pair21 = "";
input string                               Pair22 = "";
input string                               Pair23 = "";
input string                               Pair24 = "";
input string                               Pair25 = "";
input string                               Pair26 = "";
input string                               Pair27 = "";
input string                               Pair28 = "";
input string                               Pair29 = "";
input string                               Pair30 = "";
input string                               Close_Pips_SetUP = "------< Close_Pips_SetUP >------";
input bool                                 use_close_per_symbol_pip=true;
input int                                  closeTP_buy_in_pips_eachpair=50;
input int                                  closeTP_sell_in_pips_eachpair=50;
input int                                  closeTP_all_in_pips_eachpair=50;
input int                                  closeSL_buy_in_pips_eachpair=-50;
input int                                  closeSL_sell_in_pips_eachpair=-50;
input int                                  closeSL_all_in_pips_eachpair=-50;
input string                               Close_USD_SetUP = "------< Close_USD_SetUP >------";
input bool                                 use_close_per_symbol_usd=true;
input int                                  closeTP_buy_in_USD_eachpair=50;
input int                                  closeTP_sell_in_USD_eachpair=50;
input int                                  closeTP_all_in_USD_eachpair=50;
input int                                  closeSL_buy_in_USD_eachpair=-50;
input int                                  closeSL_sell_in_USD_eachpair=-50;
input int                                  closeSL_All_in_USD_eachpair=-50;
input string                               Close_Account_SetUP = "------< Close_Account_SetUP >------";
input bool                                 use_close_per_account_usd=true;
input int                                  closeTP_in_USD_All_account=50;
input int                                  closeSL_in_USD_All_account=-50;
input int                                  MAX_Pair_Number =5;
input bool                                 ShowPanel=false;
// indicator
sinput string                              Set2="------<Indicator settings >------";
input int                                  Mperiod=40;
input ENUM_APPLIED_PRICE                   Applied =PRICE_CLOSE;
input int                                  CCiValue=100;
input string                               Time_SetUP = "------< Time_SetUP >------";
input bool                                 UseTimeFilter=false;
input string                               TimeStart="12:00";
input string                               TimeStop="14:00";
extern string       Trade_Day_SetUP                    = "------< Trade_Day_SetUP >------";
extern bool         Trade_sunday                       = true;
extern bool         Trade_monday                       = true;
extern bool         Trade_tuseday                      = true;
extern bool         Trade_wednisday                    = true;
extern bool         Trade_Thursday                     = true;
extern bool         Trade_friday                       = true;
//variables
double newLot;
bool Pass=false;
color N=clrNONE;
input color ObjectColor=clrLime;
input color ProfitColor=clrLime;
input color LoseColor=clrRed;
color ColorPS,ColorPB,ColorAccountP,ColorSymbolP;
//Arrrays
string AllPairs[30];
double BTP[],BSL[],SSL[],STP[];
string symbols[];
string Head[6];
// Class object
CExecute *trades[];
CPosition *Positions[];
CPosition *SellPositions[];
CPosition *BuyPositions[];
CUtilities *tools[];
CiCCI *CCi[];
CChartObjectLabel label;
CArrayObj *Panel=new CArrayObj;
CChartObjectEdit Heading;
CChartObjectHLine HLine;
CArrayString *MaxPair=new CArrayString;
CTradeState TradeState(TRADE_BUY_AND_SELL);  // Set the default mode to Buy And Sell
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//Arrays Resize and initialization
   AllPairs[0]=Pair1;
   AllPairs[1]=Pair2;
   AllPairs[2]=Pair3;
   AllPairs[3]=Pair4;
   AllPairs[4]=Pair5;
   AllPairs[5]=Pair6;
   AllPairs[6]=Pair7;
   AllPairs[7]=Pair8;
   AllPairs[8]=Pair9;
   AllPairs[9]=Pair10;
   AllPairs[10]=Pair11;
   AllPairs[11]=Pair12;
   AllPairs[12]=Pair13;
   AllPairs[13]=Pair14;
   AllPairs[14]=Pair15;
   AllPairs[15]=Pair16;
   AllPairs[16]=Pair17;
   AllPairs[17]=Pair18;
   AllPairs[18]=Pair19;
   AllPairs[19]=Pair20;
   AllPairs[20]=Pair21;
   AllPairs[21]=Pair22;
   AllPairs[22]=Pair23;
   AllPairs[23]=Pair24;
   AllPairs[24]=Pair25;
   AllPairs[25]=Pair26;
   AllPairs[26]=Pair27;
   AllPairs[27]=Pair28;
   AllPairs[28]=Pair29;
   AllPairs[29]=Pair30;
   Head[0]="status";
   Head[1]="BuyTp";
   Head[2]="BuySL";
   Head[3]="SellTp";
   Head[4]="SellSl";
   Head[5]= "Price";

   int total=ArraySize(AllPairs);
   for(int i=0; i<total; i++)
     {
      if(AllPairs[i]!="")
        {
         if(SymbolSelect(AllPairs[i],true))
           {
            Print(AllPairs[i]+" added to Market watch");
           }
         else
           {
            Print(AllPairs[i]+" doesn't Exist");
           }
         int size=ArraySize(symbols);
         ArrayResize(symbols,size+1,size+1);
         ArrayResize(trades,size+1,size+1);
         ArrayResize(Positions,size+1,size+1);
         ArrayResize(SellPositions,size+1,size+1);
         ArrayResize(BuyPositions,size+1,size+1);
         ArrayResize(tools,size+1,size+1);
         ArrayResize(CCi,size+1,size+1);
         ArrayResize(SSL,size+1,size+1);
         ArrayResize(STP,size+1,size+1);
         ArrayResize(BSL,size+1,size+1);
         ArrayResize(BTP,size+1,size+1);
         symbols[size]=AllPairs[i];
         trades[size] = new CExecute(symbols[size], magic_Number);
         BuyPositions[size] = new CPosition(symbols[size], magic_Number, GROUP_POSITIONS_BUYS);
         SellPositions[size] = new CPosition(symbols[size], magic_Number, GROUP_POSITIONS_SELLS);
         Positions[size] = new CPosition(symbols[size], magic_Number, GROUP_POSITIONS_ALL);
         tools[size] = new CUtilities(symbols[size]);
         CCi[size]=new CiCCI;
         CCi[size].Create(symbols[size],PERIOD_CURRENT,Mperiod,Applied);
        }
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   bool TradeAlow=(sTimeFilter(TimeStart,TimeStop)&&UseTimeFilter)||!UseTimeFilter;
   double profit = 0;
   double points = 0;
   
   //Money managment
   if(useMoneyManagment)
     {
      newLot=(AccountInfoDouble(ACCOUNT_BALANCE)/xDollars)*lot;
     }
   else
      newLot=lot;
//------------------------
   //symbols loop
   int total=ArraySize(symbols);
   for(int i=0; i<total; i++)
     {
       // Max pair numbers logic 
      if(Positions[i].GroupTotal()==0)
        {
         if(MaxPair.Search(symbols[i])!=-1)
           {
            int idx=MaxPair.Search(symbols[i]);
            MaxPair.Delete(idx);
            CArrayObj *line=Panel.At(idx);

            while(line.Total())
               delete line.Detach(0);
            Panel.Detach(idx);
           }
        }
      MaxPair.Sort();
      //================================== 
      
      if(day_trade()==true&&TradeAlow==true)
        {

         if(MaxPair.Total()<MAX_Pair_Number||(MaxPair.Search(symbols[i])!=-1&&MaxPair.Total()==MAX_Pair_Number))
           {
           // entry logic
            CCi[i].Refresh(-1);
            double CCI1=MathAbs(CCi[i].Main(1));
            double CCI2=MathAbs(CCi[i].Main(2));
            double diff=CCI1-CCI2;
            
            if(diff>=CCiValue)
              {
              
              // buy condition
               if(EntryType==buy||EntryType==buyAndsell)
                 {
                  if(BuyPositions[i].GroupTotal()==0)
                    {
                    
                     if(CCi[i].Main(1)>CCi[i].Main(2))
                       {
                        double Lot=tools[i].NormalizeVolume(newLot);
                        trades[i].Position(TYPE_POSITION_BUY,Lot,sl,tp,SLTP_PIPS,30,comment);
                        bool found=false;
                        for(int c=0; c<MaxPair.Total(); c++)
                          {
                           if(MaxPair.At(c)==symbols[i])
                             {
                              found=true;
                             }
                          }
                        if(!found)
                          {
                           MaxPair.Add(symbols[i]);
                           CArrayObj *PanelLine=new CArrayObj;
                           PanelLine.Resize(4);
                           Panel.Add(PanelLine);

                          }
                       }
                    }
                 }

               // Sell Condition
               if(EntryType==sell||EntryType==buyAndsell)
                 {
                  if(SellPositions[i].GroupTotal()==0)
                    {
                     if(CCi[i].Main(1)<CCi[i].Main(2))
                       {
                        double Lot=tools[i].NormalizeVolume(newLot);
                        trades[i].Position(TYPE_POSITION_SELL,Lot,sl,tp,SLTP_PIPS,30,comment);
                        bool found=false;
                        for(int c=0; c<MaxPair.Total(); c++)
                          {
                           if(MaxPair.At(c)==symbols[i])
                             {
                              found=true;
                             }
                          }
                        if(!found)
                          {
                           MaxPair.Add(symbols[i]);
                           CArrayObj *PanelLine=new CArrayObj;
                           PanelLine.Resize(4);
                           Panel.Add(PanelLine);
                          }
                       }
                    }
                 }
              }
           }
        }
      // Draw Right info dasboard
      if(symbols[i]==Symbol())
        {
         dashboard(Positions[i],BuyPositions[i],SellPositions[i]);
        }
        
      averageTpSl(Positions[i],BuyPositions[i],SellPositions[i],tools[i],symbols[i],BSL[i],BTP[i],SSL[i],STP[i]);
      profit+=Positions[i].GroupTotalProfit();
      ClosingEachSymbol(Positions[i],BuyPositions[i],SellPositions[i],tools[i],points);
      Hedging(trades[i],Positions[i],BuyPositions[i],SellPositions[i],tools[i]);
      Trailing(BuyPositions[i],SellPositions[i],tools[i]);
      // Draw Left  dasboard
      if(ShowPanel)
        {
         CreateDashboardTitles();
         SetPanelData();
        }
     }

   ClosingAccount(profit);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void ClosingEachSymbol(CPosition & Pos,CPosition  & BuyPos,CPosition & SellPos, CUtilities & tool,double & points)
  {

// take profit with dollar for each symbol
   if(use_close_per_symbol_usd)
     {
      if((closeTP_sell_in_USD_eachpair>0&&SellPos.GroupTotalProfit() >= closeTP_sell_in_USD_eachpair)
         ||(closeTP_all_in_USD_eachpair>0&&SellPos.GroupTotalProfit() >= closeTP_all_in_USD_eachpair))
        {
         SellPos.GroupCloseAll(20);
        }
      if((closeTP_buy_in_USD_eachpair>0&&BuyPos.GroupTotalProfit() >= closeTP_buy_in_USD_eachpair)
         ||(closeTP_all_in_USD_eachpair>0&&BuyPos.GroupTotalProfit() >= closeTP_all_in_USD_eachpair))
        {
         BuyPos.GroupCloseAll(20);
        }

      //Stop loss with dollar for each symbol

      if((closeSL_sell_in_USD_eachpair<0&&SellPos.GroupTotalProfit() <= closeSL_sell_in_USD_eachpair)
         ||(closeSL_All_in_USD_eachpair<0&&SellPos.GroupTotalProfit() <= closeSL_All_in_USD_eachpair))
        {
         SellPos.GroupCloseAll(20);
        }
      if((closeSL_buy_in_USD_eachpair<0&&BuyPos.GroupTotalProfit() <= closeSL_buy_in_USD_eachpair)
         ||(closeSL_All_in_USD_eachpair<0&&BuyPos.GroupTotalProfit() <= closeSL_All_in_USD_eachpair))
        {
         BuyPos.GroupCloseAll(20);
        }
     }
// take profit with point for each symbol

   double Bpt = 0,Spt=0;
   int tt = Pos.GroupTotal();
   if(tt>1)
     {
      for(int x = 0; x < tt; x++)
        {
         if(Pos[x].GetType() == ORDER_TYPE_BUY)
           {
            Bpt += tool.Bid() - Pos[x].GetPriceOpen() ;
           }
         else
            if(Pos[x].GetType() == ORDER_TYPE_SELL)
              {
               Spt += Pos[x].GetPriceOpen() - tool.Bid() ;
              }
        }
        
      if(use_close_per_symbol_pip)
        {
         if(Bpt>=closeTP_buy_in_pips_eachpair * tool.Pip()&&closeTP_buy_in_pips_eachpair!=0)
           {
            BuyPos.GroupCloseAll(20);
           }
         if(Spt>=closeTP_sell_in_pips_eachpair * tool.Pip()&&closeTP_sell_in_pips_eachpair!=0)
           {
            SellPos.GroupCloseAll(20);
           }
         if(Bpt<=closeSL_buy_in_pips_eachpair * tool.Pip()&&closeSL_buy_in_pips_eachpair!=0)
           {
            BuyPos.GroupCloseAll(20);
           }
         if(Spt<=closeSL_sell_in_pips_eachpair * tool.Pip()&&closeSL_sell_in_pips_eachpair!=0)
           {
            SellPos.GroupCloseAll(20);
           }
         if((Bpt+Spt)>=closeTP_all_in_pips_eachpair*tool.Pip()&&closeTP_all_in_pips_eachpair!=0)
           {
            Pos.GroupCloseAll(20);
           }

         if((Bpt+Spt)<=closeSL_all_in_pips_eachpair*tool.Pip()&&closeSL_all_in_pips_eachpair!=0)
           {
            Pos.GroupCloseAll(20);
           }
        }

      points += (Bpt+Spt) /tool.Pip();

     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClosingAccount(double & profit)
  {
// close all account postion with profit
   int t=ArraySize(symbols);
   for(int i = 0; i < t; i++)
     {
      if(profit >= closeTP_in_USD_All_account && use_close_per_account_usd&&closeTP_in_USD_All_account!=0)
        {
         Positions[i].GroupCloseAll(20);
        }
      if(profit <= closeSL_in_USD_All_account && use_close_per_account_usd&&closeSL_in_USD_All_account!=0)
        {
         Positions[i].GroupCloseAll(20);
        }


     }
  }
//+------------------------------------------------------------------+
void Hedging(CExecute & OpenHedge,CPosition & Pos,CPosition  & BuyPos,CPosition & SellPos, CUtilities & tool)
  {
   int  posTotal=Pos.GroupTotal();
   int  sellTotal=SellPos.GroupTotal();
   int  buyTotal=BuyPos.GroupTotal();
   if(sellTotal>0)
     {
      if(sellTotal>1)
         SellPos[0].Modify(0,0,SLTP_PIPS);
      if(SellPos[sellTotal-1].GetProfit()<0
         &&tool.Bid()-SellPos[sellTotal-1].GetPriceOpen()>=MultipilerStep*tool.Pip())
        {
         double lastLot=tool.NormalizeVolume(SellPos[sellTotal-1].GetVolume()*LotMultipiler,ROUNDING_OFF);
         OpenHedge.Position(TYPE_POSITION_SELL,lastLot,0,0,SLTP_PIPS,30,comment);

        }
     }

   if(buyTotal>0)
     {
      if(buyTotal>1)
         BuyPos[0].Modify(0,0,SLTP_PIPS);
      if(BuyPos[buyTotal-1].GetProfit()<0
         &&BuyPos[buyTotal-1].GetPriceOpen()-tool.Bid()>=MultipilerStep*tool.Pip())
        {
         double lastLot=tool.NormalizeVolume(BuyPos[buyTotal-1].GetVolume()*LotMultipiler,ROUNDING_OFF);
         OpenHedge.Position(TYPE_POSITION_BUY,lastLot,0,0,SLTP_PIPS,30,comment);
        }

     }
  }
//+------------------------------------------------------------------+
// account info on right
//+------------------------------------------------------------------+
void dashboard(CPosition & Pos,CPosition  & BuyPos,CPosition & SellPos)
  {
 
   if(AccountInfoDouble(ACCOUNT_PROFIT)>=0)
     {
      ColorAccountP=ProfitColor;
     }
   else
     {
      ColorAccountP=LoseColor;
     }
   if(Pos.GroupTotalProfit()>=0)
     {
      ColorSymbolP=ProfitColor;
     }
   else
     {
      ColorSymbolP=LoseColor;
     }
   if(SellPos.GroupTotalProfit()>=0)
     {
      ColorPS=ProfitColor;
     }
   else
     {
      ColorPS=LoseColor;
     }
   if(BuyPos.GroupTotalProfit()>=0)
     {
      ColorPB=ProfitColor;
     }
   else
     {
      ColorPB=LoseColor;
     }


   Info("info1",1,25,200,"Account Balance : ",10,"",clrLime);
   Info("info11",1,25,50,DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2),10,"",clrLime);
   Info("info2",1,50,200,"Account Equity : ",10,"",clrLime);
   Info("info22",1,50,50,DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2),10,"",clrLime);
   Info("info3",1,75,200,"Account Profit : ",10,"",clrLime);
   Info("info33",1,75,50,DoubleToString(AccountInfoDouble(ACCOUNT_PROFIT),2),10,"",ColorAccountP);
   Info("info4",1,100,200,"Symbol Profit : ",10,"",clrLime);
   Info("info44",1,100,50,DoubleToString(Pos.GroupTotalProfit(),2),10,"",ColorSymbolP);
   Info("info5",1,125,200,"Sell Profit : ",10,"",clrLime);
   Info("info55",1,125,50,DoubleToString(SellPos.GroupTotalProfit(),2),10,"",ColorPS);
   Info("info6",1,150,200,"Buy Profit : ",10,"",clrLime);
   Info("info66",1,150,50,DoubleToString(BuyPos.GroupTotalVolume(),2),10,"",ColorPB);
   Info("info9",1,175,200,"Number of Sell : ",10,"",clrLime);
   Info("info99",1,175,50,IntegerToString(SellPos.GroupTotal()),10,"",clrLime);
   Info("info8",1,200,200,"Number of Buy : ",10,"",clrLime);
   Info("info88",1,200,50,IntegerToString(BuyPos.GroupTotal()),10,"",clrLime);



//Info("info09",0,25,20,"Max Account DrawDown : ",10,"",clrLime);
//Info("info00",0,25,200,DoubleToStr(MAXD,2),10,"",clrLime);
//Info("infoP",0,50,20,"Max Account Profit : ",10,"",clrLime);
//Info("infoP1",0,50,200,DoubleToStr(MAXP,2),10,"",clrLime);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Info(string NAME,double CORNER,int Y,int X,string TEXT,int FONTSIZE,string FONT,color FONTCOLOR)
  {
   label.Create(0,NAME,0,0,0);
   label.Description(TEXT);
   label.Corner(CORNER_RIGHT_UPPER);
   label.X_Distance(X);
   label.Y_Distance(Y);
   label.Font(FONT);
   label.Color(FONTCOLOR);
  }
//+------------------------------------------------------------------+
//time fillter
//-----------------------------------------------------------------

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|              create dashboard title                              |
//+------------------------------------------------------------------+
int Y_Move = 20;
void CreateDashboardTitles()
  {
   int X_Shift, Y_Shift;
   Y_Shift = 10 + Y_Move;
   int sizeSym = MaxPair.Total();
   X_Shift = 10;
   Y_Shift = 40 + Y_Move;
   for(int i = 0; i < sizeSym; i++)
     {
      CArrayObj *Line=Panel.At(i);
      if(Line.At(0)==NULL)
        {
         CChartObjectEdit *edit= new CChartObjectEdit();
         Line.Insert(edit,0);
        }
      CChartObjectEdit *e=Line.At(0);

      CreatePanel(MaxPair.At(i),e,MaxPair.At(i), X_Shift, Y_Shift, 60, 25, clrYellow, clrBlack, clrBlack, 9, true, false, 0, ALIGN_CENTER);
      Y_Shift += 25;
     }
   int sizeTF = ArraySize(Head);
   X_Shift = 80;
   Y_Shift = 10 + Y_Move;
   for(int i = 0; i < sizeTF; i++)
     {
      CreatePanel(Head[i], Heading, Head[i], X_Shift, Y_Shift, 75, 25,  clrYellow, clrBlack, clrBlack, 9, true, false, 0, ALIGN_CENTER);
      X_Shift += 73;
     }
  }



//+------------------------------------------------------------------+
//|           create panel box                                                       |
//+------------------------------------------------------------------+
void CreatePanel(string name, CChartObjectEdit & Edit, string text, int XDistance, int YDistance, int Width, int Hight,
                 color BGColor_, color InfoColor, color boarderColor, int fontsize, bool readonly = false, bool Obj_Selectable = false, int Corner = 0, ENUM_ALIGN_MODE Align = ALIGN_LEFT)
  {


   Edit.Create(0,name,0,0,0,0,0);
   Edit.X_Distance(XDistance);
   Edit.Y_Distance(YDistance);
   Edit.Width(Width);
   Edit.X_Size(Width);
   Edit.Y_Size(Hight);
   Edit.Description(text);
   Edit.Font("Arial");
   Edit.FontSize(fontsize);
   Edit.Corner(CORNER_LEFT_UPPER);
   Edit.Color(InfoColor);
   Edit.SetInteger(OBJPROP_BGCOLOR,BGColor_);
   Edit.SetInteger(OBJPROP_BORDER_COLOR,boarderColor);
   Edit.Selectable(true);
   Edit.ReadOnly(true);
   Edit.TextAlign(Align);


  }
//+------------------------------------------------------------------+
//create and update panel
//--------------------------------------------------------------------
void SetPanelData()
  {

   int X_Shift, Y_Shift;
   int sizeSym = MaxPair.Total();
   int sizeTF = ArraySize(Head);
   Y_Shift = 40 + Y_Move;

// for loop on all symbols
   for(int i = 0; i < sizeSym; i++)
     {
      X_Shift = 80;
      int symbolIDX;
      for(int c=0; c<ArraySize(symbols); c++)
        {
         if(symbols[c]==MaxPair.At(i))
           {
            symbolIDX=c;
           }
        }
      // for loop on all TF for each symbol
      for(int j = 0; j < sizeTF; j++)
        {
         string stats;
         if(j==0)
           {
            stats=(BuyPositions[symbolIDX].GroupTotal()>0&&SellPositions[symbolIDX].GroupTotal()>0)?"BuyAndSell":(BuyPositions[symbolIDX].GroupTotal()>0&&SellPositions[symbolIDX].GroupTotal()==0)?"Buy":(BuyPositions[symbolIDX].GroupTotal()==0&&SellPositions[symbolIDX].GroupTotal()>0)?"Sell":"None";
           }

         CArrayObj *Line=Panel.At(i);
         CChartObjectEdit *e=Line.At(j+1);
         if(e==NULL)
           {
            CChartObjectEdit *edit=new CChartObjectEdit;
            Line.Insert(edit,j+1);
           }
         CChartObjectEdit *edit=Line.At(j+1);
         double Bavtp=0,Bavsl=0;
         double Savtp=0,Savsl=0;
         if(BuyPositions[symbolIDX].GroupTotal()==1)
           {
            if(BuyPositions[symbolIDX].SelectByIndex(0))
              {
               Bavtp=BuyPositions[symbolIDX].GetTakeProfit();
               Bavsl=BuyPositions[symbolIDX].GetStopLoss();
              }
           }
         if(BuyPositions[symbolIDX].GroupTotal()>1)
           {
            Bavtp=BTP[symbolIDX];
            Bavsl=BSL[symbolIDX];
           }
         if(SellPositions[symbolIDX].GroupTotal()==1)
           {
            if(SellPositions[symbolIDX].SelectByIndex(0))
              {
               Savtp=SellPositions[symbolIDX].GetTakeProfit();
               Savsl=SellPositions[symbolIDX].GetStopLoss();
              }
           }
         if(SellPositions[symbolIDX].GroupTotal()>1)
           {
            Savtp=STP[symbolIDX];
            Savsl=SSL[symbolIDX];
           }
         if(SellPositions[symbolIDX].GroupTotal()<1)
           {
            Savtp=0;
            Savsl=0;
           }
         if(BuyPositions[symbolIDX].GroupTotal()<1)
           {
            Bavtp=0;
            Bavsl=0;
           }

         string   Txt=j==0?stats:j==1?DoubleToString(Bavtp,(int)tools[symbolIDX].Digits()):j==2?DoubleToString(Bavsl,(int)tools[symbolIDX].Digits()):j==3?DoubleToString(Savtp,(int)tools[symbolIDX].Digits()):j==4?DoubleToString(Savsl,(int)tools[symbolIDX].Digits()):DoubleToString(tools[symbolIDX].Bid(),(int)tools[symbolIDX].Digits());
         CreatePanel(MaxPair.At(i)+Head[j], edit, Txt, X_Shift, Y_Shift, 75, 25, clrGreen, clrBlack, clrWhite, 9, true, false, 0, ALIGN_CENTER);

         X_Shift += 73;
        }
      Y_Shift += 25;
     }
  }                                                             
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool sTimeFilter(string inStart,string inEnd,string inString=":")
  {
   bool Result=true;
   int TimeHourStart,TimeMinuteStart,TimeHourEnd,TimeMinuteEnd;
   static datetime TimeStarts,TimeEnd;
//---
   sInputTimeConvert(TimeHourStart,TimeMinuteStart,inStart,inString);
   sInputTimeConvert(TimeHourEnd,TimeMinuteEnd,inEnd,inString);
   TimeStarts=StringToTime(IntegerToString(TimeHourStart)+":"+IntegerToString(TimeMinuteStart));
   TimeEnd=StringToTime(IntegerToString(TimeHourEnd)+":"+IntegerToString(TimeMinuteEnd));
//---
   if((TimeStarts<=TimeEnd) && ((TimeCurrent()<TimeStarts) || (TimeCurrent()>TimeEnd)))
      Result=false;
   if((TimeStarts>TimeEnd) && (TimeCurrent()<TimeStarts) && (TimeCurrent()>TimeEnd))
      Result=false;
//---
   return(Result);
  }
//+------------------------------------------------------------------+
//| sInputTimeConvert                                                |
//+------------------------------------------------------------------+
int sInputTimeConvert(int &inHour,int &inMinute,string inInput,string inString=":")
  {
   int PS;
//---
   PS=StringFind(inInput,inString,0);
   inMinute=(int)StringToDouble(StringSubstr(inInput,PS+1,StringLen(inInput)-PS));
   inHour=(int)StringToDouble(StringSubstr(inInput,0,PS));
//---
   return(PS);
  }
//+------------------------------------------------------------------+
// trailing sl
//--------------------------------------------------------------------
void Trailing(CPosition  & BuyPos,CPosition & SellPos, CUtilities & tool)
  {
  
  //buy
   int buy_total = BuyPos.GroupTotal();
   if(Use_Trailing || Use_BreakEven)
     {
      if(buy_total==1)
         for(int i = 0; i < buy_total; i++)
           {
            if(BuyPos.SelectByIndex(i))
              {
               if(Use_BreakEven)
                 {
                  if((BuyPos.GetStopLoss() < BuyPos.GetPriceOpen() || BuyPos.GetStopLoss() == 0)
                     && tool.Bid() >= (BuyPos.GetPriceOpen() + BreakEvent * tool.Pip()))
                    {
                     BuyPos.Modify(BuyPos.GetPriceOpen(), BuyPos.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
               if(Use_Trailing)
                 {
                  if(tool.Bid() - BuyPos.GetPriceOpen() > tool.Pip() * TrailingStop)
                    {
                     if(BuyPos.GetStopLoss() < tool.Bid() - tool.Pip() * TrailingStop)
                       {
                        double ModfiedSl = tool.Bid() - (tool.Pip() * TrailingStop);
                        BuyPos.Modify(ModfiedSl, BuyPos.GetTakeProfit(), SLTP_PRICE);
                       }
                    }
                 }
              }
           }
     }
//+------------------------------------------------------------------+
//|     sell                                                             |
//+------------------------------------------------------------------+
   int sell_total = SellPos.GroupTotal();
   if(Use_Trailing || Use_BreakEven)
     {
      if(sell_total==1)
         for(int i = 0; i < sell_total; i++)
           {
            if(SellPos.SelectByIndex(i))
              {
               if(Use_BreakEven)
                 {
                  if((SellPos.GetStopLoss() > SellPos.GetPriceOpen() || SellPos.GetStopLoss() == 0)
                     && tool.Ask() <= (SellPos.GetPriceOpen() - BreakEvent * tool.Pip()))
                    {
                     SellPos.Modify(SellPos.GetPriceOpen(), SellPos.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
               if(Use_Trailing)
                 {
                  if(SellPos.GetPriceOpen() - tool.Ask() > tool.Pip() * TrailingStop)
                    {
                     if(SellPos.GetStopLoss() > tool.Ask() + tool.Pip() * TrailingStop)
                       {
                        double ModfiedSl = tool.Ask() + tool.Pip() * TrailingStop;
                        SellPos.Modify(ModfiedSl, SellPos.GetTakeProfit(), SLTP_PRICE);
                       }
                    }
                 }
              }
           }
     }
  }


//+------------------------------------------------------------------+
//|     get average tp ,sl, BE                                                             |
//+------------------------------------------------------------------+
void averageTpSl(CPosition & Pos,CPosition & buyPos, CPosition & sellPos,CUtilities & tool,string  symb,double & BSl,double & BTp,double & SSl,double & STp)
  {
   double buy_order_lots=0,sell_order_lots=0,BuyLotprice=0,SellLotprice=0,BUY_L=0,SELL_L=0;
   double last_buy_price=0,last_sell_price=0;
   double NewAverageBUYprice, NewAverageSELLprice;
   if(symb==Symbol())
     {
      
         ObjectDelete(0,"BBE");
         ObjectDelete(0,"buySl");
         ObjectDelete(0,"buyTp");

        
      
         ObjectDelete(0,"SBE");
         ObjectDelete(0,"sellSl");
         ObjectDelete(0,"sellTp");
        
     }
   if(use_close_per_symbol_pip)
     {
      int tb=buyPos.GroupTotal();
      if(tb>1)
        {
         for(int i=0; i<tb; i++)
           {
            BUY_L=buyPos[i].GetVolume();
            BuyLotprice+=(BUY_L*buyPos.GetPriceOpen());
            buy_order_lots+=BUY_L;

           }
         NewAverageBUYprice=BuyLotprice/buy_order_lots;
         BTp=tool.NormalizePrice(NewAverageBUYprice+closeTP_buy_in_pips_eachpair*(tool.Pip()/tb),ROUNDING_OFF);
         BSl=tool.NormalizePrice(NewAverageBUYprice-(-closeSL_buy_in_pips_eachpair)*(tool.Pip()/tb),ROUNDING_OFF);
         //Draw lines
         if(symb==Symbol())
           {
            HLine.Create(0,"BBE",0,NewAverageBUYprice);
            HLine.Color(clrYellow);
            HLine.Create(0,"buySl",0,BSl);
            HLine.Color(clrRed);
            HLine.Create(0,"buyTp",0,BTp);
            HLine.Color(clrGreen);

           }
        }

      int ts=sellPos.GroupTotal();
      if(ts>1)
        {
         for(int i=0; i<ts; i++)
           {
            SELL_L=sellPos[i].GetVolume();
            SellLotprice+=(SELL_L*sellPos.GetPriceOpen());
            sell_order_lots+=SELL_L;

           }
         NewAverageSELLprice=SellLotprice/sell_order_lots;
         STp=tool.NormalizePrice(NewAverageSELLprice-closeTP_sell_in_pips_eachpair*(tool.Pip()/ts),ROUNDING_OFF);
         SSl=tool.NormalizePrice(NewAverageSELLprice+(-closeSL_sell_in_pips_eachpair)*(tool.Pip()/ts),ROUNDING_OFF);
         //Draw lines
         if(symb==Symbol())
           {
            HLine.Create(0,"SBE",0,NewAverageSELLprice);
            HLine.Color(clrYellow);
            HLine.Create(0,"sellSl",0,SSl);
            HLine.Color(clrRed);
            HLine.Create(0,"sellTp",0,STp);
            HLine.Color(clrGreen);
           }
        }
     }
  }
//+------------------------------------------------------------------+
bool day_trade()
  {
   if(Trade_sunday == true&& DayOfWeek() ==0)
      return (true);
   if(Trade_monday  == true&& DayOfWeek() ==1)
      return (true);
   if(Trade_tuseday  == true&& DayOfWeek() ==2)
      return (true);
   if(Trade_wednisday  == true&& DayOfWeek() ==3)
      return (true);
   if(Trade_Thursday  == true&& DayOfWeek() ==4)
      return (true);
   if(Trade_friday  == true&& DayOfWeek() ==5)
      return (true);

   if(Trade_sunday == false&& DayOfWeek() ==0)
      return (false);
   if(Trade_monday  == false&& DayOfWeek() ==1)
      return (false);
   if(Trade_tuseday  == false&& DayOfWeek() ==2)
      return (false);
   if(Trade_wednisday  == false&& DayOfWeek() ==3)
      return (false);
   if(Trade_Thursday  == false&& DayOfWeek() ==4)
      return (false);
   if(Trade_friday  == false&& DayOfWeek() ==5)
      return (false);

   return(false);
  }