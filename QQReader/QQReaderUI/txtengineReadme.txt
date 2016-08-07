TXT引擎功能
1、- (BOOL) openDoc:(NSString*)filePath
功能：打开书，ReadEngineMessage_Start
做的事情：
1）获取文件总的大小
2）编码检测，得到文件的编码、字节序和文件开头无意义字节长度
3）得到文件最开始一段内容，unicode格式保存
4）初始化当前段、当前行、缓存段落链表
5）更新百分比

2、- (void) setBoundRect:(QRRect*)rect  fullRect:(QRRect*)frect
功能：设置显示区域，ReadEngineMessage_SetOwnRect
做的事情：
1）设置显示区域的矩形（相对于屏幕上下左右都有缩进）

3、- (BOOL) recalc
功能：更新行高和行间距，ReadEngineMessage_RecalcPageSize
做的事情：
1）字号发生变化，同步更新行高和行间距

4、- (BOOL) gotoParagraph:(QRParagraf*)panchor
功能：跳转到某个位置，ReadEngineMessage_GoToBookMark
做的事情：
1）panchor->page_off  某个段落的字节偏移
   panchor->line_ldx  段落里某个字相对于段首的字符偏移
2）该函数内部调用了- (BOOL) gotoAnchor:( QRParagraf*) panchor

===============================
1-4就是整个打开书的流程，已经完成了分段分行等排版工作


5、- (BOOL) repaint:(QRCanvas*)canvas rect:(QRRect*)rect
功能：页面渲染，ReadEngineMessage_DrawPage
1）获取设置信息、颜色、行高
2）一行一行渲染文字，_currPrgf、_currLine告诉你该画什么内容
3）一直到该页的高度到头为止
================================
渲染就这一个函数

6、- (BOOL) pageUp:(unsigned long) pageNumber
功能：往上翻一页，ReadEngineMessage_ScrollPageUp
1）和渲染流程差不多，就是不用绘制
2）一行一行往下跳，更新_currPrgf、_currLine
3）遇到缓存（_prgfGroup）不足就重新读buffer

7、- (BOOL) pageDown:(unsigned long)pageNumber
参考pageUp

8、- (BOOL) pageDownOffset:(NSInteger)offset
功能：翻一定偏移（上下翻页用到）
1）根据偏移和行高转换成行数，再往上或往下滚几行
=================================
翻页相关

9、- (BOOL) relayout
功能：重排版，ReadEngineMessage_Relayout
1）将原来的排版信息清空，重新排版（转屏，改字号字体，原来的分行信息无效）
2）一行一行渲染文字，_currPrgf、_currLine告诉你该画什么内容
3）一直到该页的高度到头为止
=================================
排版相关

10、- (BOOL) gotoPosition: (unsigned long) percent
功能：百分比跳转，ReadEngineMessage_GoToPosition
1）用户滑动进度条跳转
2）转换成gotoTop、gotoBottom、gotoAnchor三种情况

11、-(BOOL) gotoTop

12、-(BOOL) gotoBottom
==================================
跳转相关，核心函数是gotoAnchor


13、- (BOOL)  getBookmark:(QRBookmark*) bookmark
功能：在当前位置生成书签，ReadEngineMessage_GetBookMark
1）得到当前百分比，赋值给书签
2）得到当前页起始文字，赋值给书签
3）得到当前的page_off,line_idx,赋值给书签
===================================
书签相关

14、- (BOOL) getPercent:( unsigned long *) ppercent
功能：计算当前位置百分比
1）当前段字节偏移+字符偏移转化成的字节偏移（近似算法），得到当前字的字节偏移，和文件长度相除。
2）以上算法在最后一页会算成99.xx%，所以到达文件尾需特殊处理。

15、- (BOOL) isTop
功能：是否到最后一页，ReadEngineMessage_IsPageBottom
1）当前段字节偏移+字符偏移转化成的字节偏移（近似算法），得到当前字的字节偏移。
2）和文件从最后一页往前算一页的偏移进行比较。

16、- (BOOL) isBottom
功能：是否到最后一页，ReadEngineMessage_IsPageBottom
1）当前段字节偏移+字符偏移转化成的字节偏移（近似算法），得到当前字的字节偏移。
2）和文件从最后一页往前算一页的偏移进行比较。

17、- (BOOL) closeDoc
功能：关闭书
1）停止智能断章，释放章节数组
2）把当前段、当前行、缓存段落链表置空
3）成员变量置空