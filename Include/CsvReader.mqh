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

#include <Files/FileTxt.mqh>
#include "enum_file_state.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCsvReader : public CFileTxt
  {
public:
                     CCsvReader();
                    ~CCsvReader();

   int               Open(const string file_name,
                          const int open_flags,
                          ushort delimeter='\t');

   bool              HasHeader(void) const           { return m_hasheader; }
   void              HasHeader(const bool hasheader) { m_hasheader=hasheader; }

   ushort            Seperator(void) const             { return m_seperator; }
   void              Seperator(const ushort seperator) { m_seperator=seperator; }

   int               LineNumber(void) const { return m_linenumber; }

   int               ReadLine(void);                // Skip a line
   int               ReadLine(string &line);        // Read complete line 
   int               ReadLine(MqlParam &data[]);    // Read values from line

   void              FieldDesc(MqlParam &fields[]);
   MqlParam          FieldDesc(const int index);

protected:
   ushort            m_seperator;
   int               m_linenumber;
   bool              m_hasheader;
   MqlParam          m_field_desc[];
   MqlParam          m_field_data[];
   bool              Assign(const ENUM_DATATYPE type,
                            const string source,
                            MqlParam &target);

private:
   static void       StringTrimAndLower(string &string_var);
   static void       StringTrimAndUpper(string &string_var);
  };
//+------------------------------------------------------------------+
//| The CSV file is read as a hole line                              |
//+------------------------------------------------------------------+
CCsvReader::CCsvReader()
   : m_seperator(','),
     m_hasheader(false),
     m_linenumber(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCsvReader::~CCsvReader()
  {
  }
//+------------------------------------------------------------------+
//| Pass information about the field types                           |
//+------------------------------------------------------------------+
void CCsvReader::FieldDesc(MqlParam &fields[])
  {
   ArrayResize(m_field_desc,ArraySize(fields));
   for(int i=0; i<ArraySize(fields);++i)
     {
      m_field_desc[i]=fields[i];
     }
  }
//+------------------------------------------------------------------+
//| Open the text file                                               |
//+------------------------------------------------------------------+
int CCsvReader::Open(const string file_name,
                     const int open_flags,
                     ushort delimeter='\t')
  {
   m_seperator=delimeter;

// As we we use CFileTxt and want to read a whole line
// we have to change the supplied open_flags,
// because the user of this class may not expect this.
   int t_openflags=open_flags;
// Remove attributs not supported or not wanted
   t_openflags     &= (~0) ^ FILE_ANSI;
   t_openflags     &= (~0) ^ FILE_CSV;
   t_openflags     &= (~0) ^ FILE_WRITE;
   t_openflags     &= (~0) ^ FILE_REWRITE;
// Add attributs  wanted      
   t_openflags     |=FILE_UNICODE;
   t_openflags     |=FILE_TXT;
   t_openflags     |=FILE_READ;
   t_openflags     |=FILE_SHARE_READ;
  m_handle= CFile::Open(file_name,t_openflags);
   return m_handle;
  }
//+------------------------------------------------------------------+
//| Read a line without returning its contents                       |
//| i.E. it could be used to skip header line                        |
//| @returns >= 0 if no errors                                       |
//|          FILE_STATE_EOF if end of file was found                 |
//¦          FILE_STATE_ERROR on other file error                    |
//+------------------------------------------------------------------+
int CCsvReader::ReadLine(void)
  {
   string foo;
   return ReadLine(foo);
  }
//+------------------------------------------------------------------+
//| Read a line without splitting it into fields                     |
//| @returns >= 0 if no errors                                       |
//|          FILE_STATE_EOF if end of file was found                 |
//¦          FILE_STATE_ERROR on other file error                    |
//+------------------------------------------------------------------+
int CCsvReader::ReadLine(string &line)
  {
   if(m_handle==INVALID_HANDLE)
     {
      m_linenumber=-1;
      return (int) FILE_STATE_ERROR;
     }
//--- read data from the file
   line=ReadString();
   
//--- a line with contents read?   
   if(line!="")
     {
      ++m_linenumber;
      return 1;
     }
   else
//--- when no contents in the line and EOF
//    we do not know if there was an empty line, 
//    so we ignore the last empty line   
   if(IsEnding())
     {
      return FILE_STATE_EOF;
     }
   else   
      {
//--- an empty line was read, but not at EOF()      
      ++m_linenumber;
      return 0;
      }
//--- the code should never come here
   printf("Error in CsvReader logic");      
   return 1;
  }
//+------------------------------------------------------------------+
//| Read a line, split it, fill  MqlParam array                      |
//| @returns >= 0 = number of fields found in line read,             |
//|          FILE_STATE_EOF if end of file was found                 |
//¦          FILE_STATE_ERROR on other file error                    |
//+------------------------------------------------------------------+
int CCsvReader::ReadLine(MqlParam &fields[])
  {
   ArrayResize(fields,0,32);
   string line;
   int resultread=ReadLine(line);
   if(resultread<0) // Error reading file?
      return resultread;

//--- Split the string to substrings
   string tmp_fields[];
   ushort sep=StringGetCharacter(",",0);
   int resultsplit=StringSplit(line,sep,tmp_fields);
  if(resultsplit>0)
     {
      ArrayResize(fields,resultsplit);
      for(int i=0; i<resultsplit;++i)
        {
         // Allways return the string repesentation of the field
         fields[i].string_value=tmp_fields[i];
         if(i<ArraySize(m_field_desc))
           {
            if(m_field_desc[i].type!=TYPE_STRING)
               Assign(m_field_desc[i].type,tmp_fields[i],fields[i]);
           }
        }
      return resultsplit;
     }
   return 0;
  }
//+------------------------------------------------------------------+
//| Convert a string and store the result in an MqlParam             |
//| i.E. it could be used to skip header line                        |
//| @returns >= 0 if no errors                                       |
//|          FILE_STATE_EOF if end of file was found                 |
//¦          FILE_STATE_ERROR on other file error                    |
//+------------------------------------------------------------------+
bool CCsvReader::Assign(const ENUM_DATATYPE type,
                        const string source,
                        MqlParam &target)
  {
   string tmp=source;;
   target.integer_value=0;
   target.double_value=0.0;

   switch(type)
     {
      case TYPE_BOOL:
         StringTrimAndLower(tmp);
         if(tmp=="0" || tmp=="false" || tmp=="")
           {
            target.integer_value=0;
           }
         else
           {
            target.integer_value=1;
           }
         return true;
         break;

      case TYPE_COLOR:
         target.integer_value=StringToColor(source);
         return true;
         break;

      case TYPE_DATETIME:
         target.integer_value=(long) StringToTime(source);
         return true;
         break;

      case TYPE_DOUBLE:
      case TYPE_FLOAT:
         StringTrimAndLower(tmp);
         target.double_value=StringToDouble(tmp);
         return true;
         break;

      case TYPE_CHAR:
      case TYPE_INT:
      case TYPE_SHORT:
      case TYPE_LONG:
      case TYPE_UCHAR:
      case TYPE_USHORT:
      case TYPE_UINT:
      case TYPE_ULONG:
         target.integer_value=StringToInteger(tmp);
         return true;
         break;

      case TYPE_STRING:
         target.string_value=tmp;
         return true;
         break;

      default:
         return false;
         break;
     }
   return false;
  }
//+------------------------------------------------------------------+
static void CCsvReader::StringTrimAndLower(string &string_var)
  {
   StringTrimLeft(string_var);
   StringTrimRight(string_var);
   StringToLower(string_var);
  }
//+------------------------------------------------------------------+
static void CCsvReader::StringTrimAndUpper(string &string_var)
  {
   StringTrimLeft(string_var);
   StringTrimRight(string_var);
   StringToUpper(string_var);
  }
//+------------------------------------------------------------------+
