<chart>
id=132842731885908089
symbol=EURUSD
period=60
leftpos=30741
digits=5
scale=2
graph=0
fore=0
grid=1
volume=0
scroll=1
shift=0
ohlc=1
one_click=0
one_click_btn=1
askline=0
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=66
window_top=66
window_right=937
window_bottom=468
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
askline_color=255
stops_color=255

<window>
height=100
fixed_height=0
<indicator>
name=main
<object>
type=25
object_name=CloseAllOrders
period_flags=0
create_time=1639798130
description=CloseBuy
color=16777215
font=Arial
fontsize=13
anchor_pos=0
background=0
filling=0
selectable=0
hidden=1
zorder=0
corner=0
x_distance=1040
y_distance=25
size_x=200
size_y=50
bgcolor=32768
frcolor=-1
state=0
</object>
<object>
type=25
object_name=NewCycle
period_flags=0
create_time=1639798130
description=New Cycle
color=16777215
font=Arial
fontsize=13
anchor_pos=0
background=0
filling=0
selectable=0
hidden=1
zorder=0
corner=0
x_distance=1040
y_distance=70
size_x=200
size_y=50
bgcolor=2139610
frcolor=-1
state=0
</object>
</indicator>
</window>

<expert>
name=work btrous\Cycle EA-v02
flags=855
window_num=0
<inputs>
General_Settings=------< General_Settings >------
Lots=0.1
takeprofit=300
stoploss=200
MagicNumber=121221
Maximum_Order=10
Multiple_SetUP=------< Multiple_SetUP >------
UseMultiple=true
Multi=2
Money_Management_Settings=------< Money_Management_Settings >------
Money_Management=true
Strategy_type_Settings=------< Strategy_type_Settings >------
Strategy_type=0
RSI_SetUP=------< RSI_SetUP >------
UseRSI=true
RSI_Period=14
RSI_price=0
RSI_High_Value=70
RSI_Low_Value=30
Stochastic_SetUP=------< Stochastic_SetUP >------
UseStochastic=true
K_Period=5
D_Period=3
Slowing=3
Stochastic_Method=0
Stochastic_price=1
STO_High_Value=80
STO_Low_Value=20
MA_SetUP=------< MA_SetUP >------
UseMA=true
period=13
MA_Method=0
MA_price=0
Time_SetUP=------< Time_SetUP >------
UseTimeFilter=true
StartTime=10:00
EndTime=23:00
Trailing_SetUP=------< Trailing_SetUP >------
Use_Trailing=false
TrailingStop=300
TrailingStep=100
</inputs>
</expert>
</chart>

