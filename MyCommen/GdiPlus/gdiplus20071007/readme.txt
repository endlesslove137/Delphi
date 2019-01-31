GDI+ for Delphi说明：

    本来准备以C++的GDI+类为基础，改写为完全的VCL风格供（类似Delphi的Graphics.pas单元）Delphi程序使用，断断续续写了一段时间后放弃了，主要原因，一是GDI+的坐标系统采用的计量类型有整数和实数2套，按VCL风格写就必须放弃一套，但是GDI+的每一套有不那么完整；二是如果与现有C++、.net的GDI+风格完全不兼容的话，移植已经存在的大量C++和.net的GDI+代码工作量太大；另外在改写的时候，网上已经有GDI+ for Pascal版本在流通，要考虑兼容性，所以就改写成现在这个样子了。
    同目前网上流通的Pascal版本比较，本版本主要有以下几个不同的特点：
    1、数据类型尽可能保持VCL风格，如布尔、枚举和集合类型等（例如字体风格类型直接使用现有的VCL类型TFontStyles），不少函数也改写成了VCL属性形式；
    2、除destructor方法外，其它GDI+类方法都增加了VCL异常检验；
    3、增加了一些与VCL类型的转换函数，如TARGB与TColor、TGpPoint与TPoint、TGpRect与TRect之间的相互转换函数；
    4、有些类方法的参数（主要指TGraphics）在原C++类中的排列顺序不那么科学，因此参照.net风格重新进行排列；
    5、增加了标准颜色画笔类TPens类型的Pens全局函数和标准颜色画刷类TBrushs类型的Brushs全局函数，不仅能非常方便地使用141种标准颜色画笔和画刷（类似.net GDI+的功能），也可方便的使用非标准颜色的画笔和画刷；
    6、修正了目前网上流通的GDI+ for Pascal版本的TGpFontFamily类和TGpStringFormat类中的几个class方法因为仿照原C++的静态方法时没考虑VCL类的特点，用户稍不注意就会Free这些类的Native数据，从而造成这些类返回的对象无法使用的BUG。

GDI+ for C++Builder说明：

    基本参照GDI+ for Delphi的形式改写，使用时只需包含Gdiplus.hpp，增加Gdiplus.lib到工程中即可，应注意的是部分原始数据类型定义头文件依然使用了原C++头文件。

    更新：原版本GdipColor.h文件在BCB6下存在版本兼容错误，现予更正。

    如果在使用中，属于改写造成的错误请反馈给本人，我的邮箱：maozefa@hotmail.com

