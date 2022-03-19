//+------------------------------------------------------------------+
//|                                                             .mqh |
//|                                                    Yousuf Mesalm |
//|                            https://www.mql5.com/en/users/20163440|
//+------------------------------------------------------------------+
#property copyright "Yousuf Mesalm"
#property link "https://www.mql5.com/en/users/20163440"
#property strict
#include <Controls/Dialog.mqh>
#include <Controls/Label.mqh>
#include "Box.mqh"


#define CONTROL_WIDTH (60)
#define CONTROL_HEIGHT (30)
#define BACKGROUND C'0x19,0x37,0x53'
#define BUTTON_GREEN C'0x8F,0xD6,0xA7'



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CDashboard : public CAppDialog
  {
private:
   /* data */
   CBox              m_main;
   CBox              m_head_row;
   CLabel            m_head_label;
   CLabel            m_head_signal;
   CLabel            m_head_buy;
   CLabel            m_head_sell;
   CBox              m_M1_row;
   CLabel            m_M1_label;
   CLabel            m_M1_signal;
   CLabel            m_M1_buy;
   CLabel            m_M1_sell;
   CBox              m_M5_row;
   CLabel            m_M5_label;
   CLabel            m_M5_signal;
   CLabel            m_M5_buy;
   CLabel            m_M5_sell;
   CBox              m_M15_row;
   CLabel            m_M15_label;
   CLabel            m_M15_signal;
   CLabel            m_M15_buy;
   CLabel            m_M15_sell;
   CBox              m_M30_row;
   CLabel            m_M30_label;
   CLabel            m_M30_signal;
   CLabel            m_M30_buy;
   CLabel            m_M30_sell;

   CBox              m_H1_row;
   CLabel            m_H1_label;
   CLabel            m_H1_signal;
   CLabel            m_H1_buy;
   CLabel            m_H1_sell;
   CBox              m_H4_row;
   CLabel            m_H4_label;
   CLabel            m_H4_signal;
   CLabel            m_H4_buy;
   CLabel            m_H4_sell;
   CBox              m_D1_row;
   CLabel            m_D1_label;
   CLabel            m_D1_signal;
   CLabel            m_D1_buy;
   CLabel            m_D1_sell;
   CBox              m_W1_row;
   CLabel            m_W1_label;
   CLabel            m_W1_signal;
   CLabel            m_W1_buy;
   CLabel            m_W1_sell;
   CBox              m_MN_row;
   CLabel            m_MN_label;
   CLabel            m_MN_signal;
   CLabel            m_MN_buy;
   CLabel            m_MN_sell;

   // variables

public:
                     CDashboard();
                    ~CDashboard();
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
   virtual bool      OnTick();
   
   void              Set_M1_Signal(string signal) {m_M1_signal.Text(signal);};
   void              Set_M5_Signal(string signal) {m_M5_signal.Text(signal);};
   void              Set_M15_Signal(string signal) {m_M15_signal.Text(signal);};
   void              Set_M30_Signal(string signal) {m_M30_signal.Text(signal);};
   void              Set_H1_Signal(string signal) {m_H1_signal.Text(signal);};
   void              Set_H4_Signal(string signal) {m_H4_signal.Text(signal);};
   void              Set_D1_Signal(string signal) {m_D1_signal.Text(signal);};
   void              Set_W1_Signal(string signal) {m_W1_signal.Text(signal);};
   void              Set_MN_Signal(string signal) {m_MN_signal.Text(signal);};
   void              Set_M1_buyTotal(string total) {m_M1_buy.Text(total);}
   void              Set_M5_buyTotal(string total) {m_M5_buy.Text(total);}
   void              Set_M15_buyTotal(string total) {m_M15_buy.Text(total);}
   void              Set_M30_buyTotal(string total) {m_M30_buy.Text(total);}
   void              Set_H1_buyTotal(string total) {m_H1_buy.Text(total);}
   void              Set_H4_buyTotal(string total) {m_H4_buy.Text(total);}
   void              Set_D1_buyTotal(string total) {m_D1_buy.Text(total);}
   void              Set_W1_buyTotal(string total) {m_W1_buy.Text(total);}
   void              Set_MN_buyTotal(string total) {m_MN_buy.Text(total);}
   void              Set_M5_sellTotal(string total) {m_M5_sell.Text(total);}
   void              Set_M15_sellTotal(string total) {m_M15_sell.Text(total);}
   void              Set_M30_sellTotal(string total) {m_M30_sell.Text(total);}
   void              Set_H1_sellTotal(string total) {m_H1_sell.Text(total);}
   void              Set_H4_sellTotal(string total) {m_H4_sell.Text(total);}
   void              Set_D1_sellTotal(string total) {m_D1_sell.Text(total);}
   void              Set_W1_sellTotal(string total) {m_W1_sell.Text(total);}
   void              Set_MN_sellTotal(string total) {m_MN_sell.Text(total);}
   void              Set_M1_sellTotal(string total) {m_M1_sell.Text(total);}

protected:
   // Create functions
   virtual bool      CreateMain(const long chart, const string name, const int subwin);
   virtual bool      CreateheadRow(const long chart, const string name, const int subwin);
   virtual bool      CreateM1Row(const long chart, const string name, const int subwin);
   virtual bool      CreateM5Row(const long chart, const string name, const int subwin);
   virtual bool      CreateM15Row(const long chart, const string name, const int subwin);
   virtual bool      CreateM30Row(const long chart, const string name, const int subwin);
   virtual bool      CreateH1Row(const long chart, const string name, const int subwin);
   virtual bool      CreateH4Row(const long chart, const string name, const int subwin);
   virtual bool      CreateD1Row(const long chart, const string name, const int subwin);
   virtual bool      CreateW1Row(const long chart, const string name, const int subwin);
   virtual bool      CreateMNRow(const long chart, const string name, const int subwin);

   //Events Handler

  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDashboard ::CDashboard()
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDashboard ::~CDashboard()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2)
  {
   if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))
      return false;
   if(!CreateMain(chart, name, subwin))
      return false;
      if(!CreateheadRow(chart, name, subwin))
      return false;
   if(!CreateM1Row(chart, name, subwin))
      return false;
   if(!CreateM5Row(chart, name, subwin))
      return false;
   if(!CreateM15Row(chart, name, subwin))
      return false;
   if(!CreateM30Row(chart, name, subwin))
      return false;
   if(!CreateH1Row(chart, name, subwin))
      return false;
   if(!CreateH4Row(chart, name, subwin))
      return false;
   if(!CreateD1Row(chart, name, subwin))
      return false;
   if(!CreateW1Row(chart, name, subwin))
      return false;
   if(!CreateMNRow(chart, name, subwin))
      return false;
       if(!m_main.Add(m_head_row))
      return false;
   if(!m_main.Add(m_M1_row))
      return false;
   if(!m_main.Add(m_M5_row))
      return false;
   if(!m_main.Add(m_M15_row))
      return false;
   if(!m_main.Add(m_M30_row))
      return false;
   if(!m_main.Add(m_H1_row))
      return false;
   if(!m_main.Add(m_H4_row))
      return false;
   if(!m_main.Add(m_D1_row))
      return false;
   if(!m_main.Add(m_W1_row))
      return false;
   if(!m_main.Add(m_MN_row))
      return false;
   if(!m_main.Pack())
      return false;
   if(!Add(m_main))
      return false;
   return (true);
  }

// Create main
bool CDashboard::CreateMain(const long chart, const string name, const int subwin)
  {
   if(!m_main.Create(chart, name + "main", subwin, 0, 0, CDialog::ClientAreaWidth(), CDialog::ClientAreaHeight()))
      return false;
   m_main.LayoutStyle(LAYOUT_STYLE_VERTICAL);
   m_main.Padding(20);
   m_main.ColorBackground(BACKGROUND);
   return (true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateheadRow(const long chart, const string name, const int subwin)
  {
   if(!m_head_row.Create(chart, name + "head_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_head_label.Create(chart, name + "head_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_head_signal.Create(chart, name + "head_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_head_buy.Create(chart, name + "head_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_head_sell.Create(chart, name + "head_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_head_buy.Text("buy");
   m_head_buy.Color(clrWhite);
   m_head_sell.Text("sell");
   m_head_sell.Color(clrWhite);
   m_head_label.Text("Period");
   m_head_label.Color(clrWhite);
   m_head_signal.Text("signal");
   m_head_signal.Color(clrWhite);
   m_head_row.ColorBackground(BACKGROUND);
   if(!m_head_row.Add(m_head_label))
      return false;
   if(!m_head_row.Add(m_head_signal))
      return false;
   if(!m_head_row.Add(m_head_buy))
      return false;
   if(!m_head_row.Add(m_head_sell))
      return false;
   return (true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateM1Row(const long chart, const string name, const int subwin)
  {
   if(!m_M1_row.Create(chart, name + "M1_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_M1_label.Create(chart, name + "M1_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M1_signal.Create(chart, name + "M1_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M1_buy.Create(chart, name + "M1_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M1_sell.Create(chart, name + "M1_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_M1_buy.Text("0");
   m_M1_buy.Color(clrWhite);
   m_M1_sell.Text("0");
   m_M1_sell.Color(clrWhite);
   m_M1_label.Text("M1");
   m_M1_label.Color(clrWhite);
   m_M1_signal.Text("None");
   m_M1_signal.Color(clrWhite);
   m_M1_row.ColorBackground(BACKGROUND);
   if(!m_M1_row.Add(m_M1_label))
      return false;
   if(!m_M1_row.Add(m_M1_signal))
      return false;
   if(!m_M1_row.Add(m_M1_buy))
      return false;
   if(!m_M1_row.Add(m_M1_sell))
      return false;
   return (true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateM5Row(const long chart, const string name, const int subwin)
  {
   if(!m_M5_row.Create(chart, name + "M5_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_M5_label.Create(chart, name + "M5_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M5_signal.Create(chart, name + "M5_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M5_buy.Create(chart, name + "M5_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M5_sell.Create(chart, name + "M5_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_M5_buy.Text("0");
   m_M5_buy.Color(clrWhite);
   m_M5_sell.Text("0");
   m_M5_sell.Color(clrWhite);
   m_M5_label.Text("M5");
   m_M5_signal.Text("None");
   m_M5_label.Color(clrWhite);
   m_M5_signal.Color(clrWhite);
   m_M5_row.ColorBackground(BACKGROUND);
   if(!m_M5_row.Add(m_M5_label))
      return false;
   if(!m_M5_row.Add(m_M5_signal))
      return false;
   if(!m_M5_row.Add(m_M5_buy))
      return false;
   if(!m_M5_row.Add(m_M5_sell))
      return false;
   return (true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateM15Row(const long chart, const string name, const int subwin)
  {
   if(!m_M15_row.Create(chart, name + "M15_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_M15_label.Create(chart, name + "M15_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M15_signal.Create(chart, name + "M15_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M15_buy.Create(chart, name + "M15_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M15_sell.Create(chart, name + "M15_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_M15_buy.Text("0");
   m_M15_buy.Color(clrWhite);
   m_M15_sell.Text("0");
   m_M15_sell.Color(clrWhite);
   m_M15_label.Text("M15");
   m_M15_signal.Text("None");
   m_M15_label.Color(clrWhite);
   m_M15_signal.Color(clrWhite);
   m_M15_row.ColorBackground(BACKGROUND);
   if(!m_M15_row.Add(m_M15_label))
      return false;
   if(!m_M15_row.Add(m_M15_signal))
      return false;
   if(!m_M15_row.Add(m_M15_buy))
      return false;
   if(!m_M15_row.Add(m_M15_sell))
      return false;
   return (true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateM30Row(const long chart, const string name, const int subwin)
  {
   if(!m_M30_row.Create(chart, name + "M30_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_M30_label.Create(chart, name + "M30_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M30_signal.Create(chart, name + "M30_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M30_buy.Create(chart, name + "M30_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_M30_sell.Create(chart, name + "M30_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_M30_buy.Text("0");
   m_M30_buy.Color(clrWhite);
   m_M30_sell.Text("0");
   m_M30_sell.Color(clrWhite);
   m_M30_label.Text("M30");
   m_M30_signal.Text("None");
   m_M30_label.Color(clrWhite);
   m_M30_signal.Color(clrWhite);
   m_M30_row.ColorBackground(BACKGROUND);
   if(!m_M30_row.Add(m_M30_label))
      return false;
   if(!m_M30_row.Add(m_M30_signal))
      return false;
   if(!m_M30_row.Add(m_M30_buy))
      return false;
   if(!m_M30_row.Add(m_M30_sell))
      return false;
   return (true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateH1Row(const long chart, const string name, const int subwin)
  {
   if(!m_H1_row.Create(chart, name + "H1_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_H1_label.Create(chart, name + "H1_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_H1_signal.Create(chart, name + "H1_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_H1_buy.Create(chart, name + "H1_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_H1_sell.Create(chart, name + "H1_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_H1_buy.Text("0");
   m_H1_buy.Color(clrWhite);
   m_H1_sell.Text("0");
   m_H1_sell.Color(clrWhite);
   m_H1_label.Text("H1");
   m_H1_signal.Text("None");
   m_H1_label.Color(clrWhite);
   m_H1_signal.Color(clrWhite);
   m_H1_row.ColorBackground(BACKGROUND);
   if(!m_H1_row.Add(m_H1_label))
      return false;
   if(!m_H1_row.Add(m_H1_signal))
      return false;
   if(!m_H1_row.Add(m_H1_buy))
      return false;
   if(!m_H1_row.Add(m_H1_sell))
      return false;
   return (true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateH4Row(const long chart, const string name, const int subwin)
  {
   if(!m_H4_row.Create(chart, name + "H4_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_H4_label.Create(chart, name + "H4_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_H4_signal.Create(chart, name + "H4_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_H4_buy.Create(chart, name + "H4_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_H4_sell.Create(chart, name + "H4_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_H4_buy.Text("0");
   m_H4_buy.Color(clrWhite);
   m_H4_sell.Text("0");
   m_H4_sell.Color(clrWhite);
   m_H4_label.Text("H4");
   m_H4_signal.Text("None");
   m_H4_label.Color(clrWhite);
   m_H4_signal.Color(clrWhite);
   m_H4_row.ColorBackground(BACKGROUND);
   if(!m_H4_row.Add(m_H4_label))
      return false;
   if(!m_H4_row.Add(m_H4_signal))
      return false;
   if(!m_H4_row.Add(m_H4_buy))
      return false;
   if(!m_H4_row.Add(m_H4_sell))
      return false;
   return (true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateD1Row(const long chart, const string name, const int subwin)
  {
   if(!m_D1_row.Create(chart, name + "D1_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_D1_label.Create(chart, name + "D1_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_D1_signal.Create(chart, name + "D1_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_D1_buy.Create(chart, name + "D1_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_D1_sell.Create(chart, name + "D1_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_D1_buy.Text("0");
   m_D1_buy.Color(clrWhite);
   m_D1_sell.Text("0");
   m_D1_sell.Color(clrWhite);
   m_D1_label.Text("D1");
   m_D1_signal.Text("None");
   m_D1_label.Color(clrWhite);
   m_D1_signal.Color(clrWhite);
   m_D1_row.ColorBackground(BACKGROUND);
   if(!m_D1_row.Add(m_D1_label))
      return false;
   if(!m_D1_row.Add(m_D1_signal))
      return false;
   if(!m_D1_row.Add(m_D1_buy))
      return false;
   if(!m_D1_row.Add(m_D1_sell))
      return false;
   return (true);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateW1Row(const long chart, const string name, const int subwin)
  {
   if(!m_W1_row.Create(chart, name + "W1_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_W1_label.Create(chart, name + "W1_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_W1_signal.Create(chart, name + "W1_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_W1_buy.Create(chart, name + "W1_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_W1_sell.Create(chart, name + "W1_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_W1_buy.Text("0");
   m_W1_buy.Color(clrWhite);
   m_W1_sell.Text("0");
   m_W1_sell.Color(clrWhite);
   m_W1_label.Text("W1");
   m_W1_signal.Text("None");
   m_W1_label.Color(clrWhite);
   m_W1_signal.Color(clrWhite);
   m_W1_row.ColorBackground(BACKGROUND);
   if(!m_W1_row.Add(m_W1_label))
      return false;
   if(!m_W1_row.Add(m_W1_signal))
      return false;
   if(!m_W1_row.Add(m_W1_buy))
      return false;
   if(!m_W1_row.Add(m_W1_sell))
      return false;
   return (true);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::CreateMNRow(const long chart, const string name, const int subwin)
  {
   if(!m_MN_row.Create(chart, name + "MN_row", subwin, 0, 0, CDialog::ClientAreaWidth(), CONTROL_HEIGHT))
      return false;
   if(!m_MN_label.Create(chart, name + "MN_label", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_MN_signal.Create(chart, name + "MN_signal", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_MN_buy.Create(chart, name + "MN_buy", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   if(!m_MN_sell.Create(chart, name + "MN_sell", subwin, 0, 0, CONTROL_WIDTH, CONTROL_HEIGHT))
      return false;
   m_MN_buy.Text("0");
   m_MN_buy.Color(clrWhite);
   m_MN_sell.Text("0");
   m_MN_sell.Color(clrWhite);
   m_MN_label.Text("MN");
   m_MN_signal.Text("None");
   m_MN_label.Color(clrWhite);
   m_MN_signal.Color(clrWhite);
   m_MN_row.ColorBackground(BACKGROUND);
   if(!m_MN_row.Add(m_MN_label))
      return false;
   if(!m_MN_row.Add(m_MN_signal))
      return false;
   if(!m_MN_row.Add(m_MN_buy))
      return false;
   if(!m_MN_row.Add(m_MN_sell))
      return false;
   return (true);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CDashboard::OnTick(void)
  {
   return true;
  }
//+------------------------------------------------------------------+
