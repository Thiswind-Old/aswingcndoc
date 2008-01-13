/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.aswing{
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.EmptyLayout;
import org.aswing.geom.IntDimension;
import org.aswing.Insets;
import org.aswing.geom.IntPoint;

/**
 * 流布局用于安排有向流中的组件，这非常类似于段落中的文本行。
 * 流布局一般用来安排面板中的按钮。它使得按钮呈水平放置，
 * 直到同一条线上再也没有适合的按钮。
 * 每行都是居中的。
 * <p></p>
 * 流布局将使每个组件的尺寸都为他们的最佳尺寸
 *
 * @author 	iiley
 */
public class FlowLayout extends EmptyLayout{

    /**
     * 此值指示每一行组件都应该是左对齐的。
     */
    public static const LEFT:int 	= AsWingConstants.LEFT;

    /**
     * 此值指示每一行组件都应该是居中的。
     */
    public static const CENTER:int 	= AsWingConstants.CENTER;

    /**
     * 此值指示每一行组件都应该是右对齐的。
     */
    public static const RIGHT:int 	= AsWingConstants.RIGHT;

    /**
     * <code>align</code>属性决定如何分配每一行的空白部分
     * 可以是以下三个值之一：
     * It can be one of the following values:
     * <ul>
     * <code>LEFT</code>
     * <code>RIGHT</code>
     * <code>CENTER</code>
     * </ul>
     *
     * @see #getAlignment
     * @see #setAlignment
     */
    protected var align:int;

    /**
     * The flow layout manager allows a seperation of
     * components with gaps.  The horizontal gap will
     * specify the space between components.
     * 流布局允许通过间隙来分隔组件。水平间隙用于指定组件之间的空白。
     *
     * @see #getHgap()
     * @see #setHgap(int)
     */
    protected var hgap:int;

    /**
     * 流布局允许通过间隙来分隔组件。垂直间隙用于指定行之间的空白。
     *
     * @see #getHgap()
     * @see #setHgap(int)
     */
    protected var vgap:int;
    
    /**
     * 间隙是否作用于容器四周
     */
    protected var margin:Boolean;

    /**
     * <p>  
     * 建立一个新的流布局并指定对齐方式与水平间隙和垂直间隙。
     * </p>
     * 对齐方式参数的值必须是这几个中的一个
     * <code>FlowLayout.LEFT</code>, <code>FlowLayout.RIGHT</code>,or <code>FlowLayout.CENTER</code>.
     * @param      align   对齐方式，默认为左对齐(LEFT)
     * @param      hgap    组件之间的水平间隙，默认为 5
     * @param      vgap    组件之间的垂直间隙，默认为 5
     * @param      margin  间隙是否作为四周空白
     */
    public function FlowLayout(align:int=AsWingConstants.LEFT, hgap:int=5, vgap:int=5, margin:Boolean=true) {
    	this.margin = margin;
		this.hgap = hgap;
		this.vgap = vgap;
        setAlignment(align);
    }
    
    /**
     * 设置间隙是否作为四周空白。
     */
    public function setMargin(b:Boolean):void{
    	margin = b;
    }
    
    /**
     * 返回间隙是否作为四周空白。
     */    
    public function isMargin():Boolean{
    	return margin;
    }

    /**
     * 获取该布局的对齐方式。
     * 可能的值为 <code>FlowLayout.LEFT</code>,<code>FlowLayout.RIGHT</code>, <code>FlowLayout.CENTER</code>,
     * @return     该布局的对齐方式
     * @see        #setAlignment
     */
    public function getAlignment():int {
		return align;
    }

    /**
     * 设置该布局的对齐方式。
     * 允许的值为
     * <ul>
     * <li><code>FlowLayout.LEFT</code>
     * <li><code>FlowLayout.RIGHT</code>
     * <li><code>FlowLayout.CENTER</code>
     * </ul>
     * @param      align 以上值中的一个
     * @see        #getAlignment()
     */
    public function setAlignment(align:int):void {
    	if(LEFT != LEFT && align != RIGHT && align != CENTER ){
    		throw new ArgumentError("Alignment must be LEFT OR RIGHT OR CENTER !");
    	}
        this.align = align;
    }

    /**
     * 获取组件之间的水平间隙。
     * @return     组件之间的水平间隙
     * @see        #setHgap()
     */
    public function getHgap():int {
		return hgap;
    }

    /**
     * 设置组件之间的水平间隙。
     * @param hgap 组件之间的水平间隙
     * @see        #getHgap()
     */
    public function setHgap(hgap:int):void {
		this.hgap = hgap;
    }

    /**
     * 获取组件之间的垂直间隙。
     * @return     组件之间的垂直间隙
     * @see        #setVgap()
     */
    public function getVgap():int {
		return vgap;
    }

    /**
     * 设置组件直接的垂直间隙。
     * @param vgap 组件直接的垂直间隙
     * @see        #getVgap()
     */
    public function setVgap(vgap:int):void {
		this.vgap = vgap;
    }

    /**
     * 返回该布局提供给指定容器中<i>可视</i>组件的最佳尺寸。
     * @param target 需要布置的容器
     * @return    对子组件进行布局的容器的最佳尺寸
     * @see Container
     * @see #doLayout()
     */
    override public function preferredLayoutSize(target:Container):IntDimension {
		var dim:IntDimension = new IntDimension(0, 0);
		var nmembers:int = target.getComponentCount();

		var counted:int = 0;
		for (var i:int = 0 ; i < nmembers ; i++) {
	    	var m:Component = target.getComponent(i);
	    	if (m.isVisible()) {
				var d:IntDimension = m.getPreferredSize();
				dim.height = Math.max(dim.height, d.height);
                if (counted > 0) {
                    dim.width += hgap;
                }
				dim.width += d.width;
				counted ++;
	    	}
		}
		var insets:Insets = target.getInsets();
		dim.width += insets.left + insets.right;
		dim.height += insets.top + insets.bottom;
		if(margin){
			dim.width += hgap*2;
			dim.height += vgap*2;
		}
    	return dim;
    }

    /**
     * 返回需要对<i>可视</i>组件进行布局的容器的最小尺寸。
     * @param target 要布局的容器
     * @return    需要对<i>可视</i>组件进行布局的容器的最小尺寸
     * @see #preferredLayoutSize()
     * @see Container
     * @see Container#doLayout()
     */
    override public function minimumLayoutSize(target:Container):IntDimension {
		return target.getInsets().getOutsideSize();
    }
    
    /**
     * Centers the elements in the specified row, if there is any slack.
     * @param target the component which needs to be moved
     * @param x the x coordinate
     * @param y the y coordinate
     * @param width the width dimensions
     * @param height the height dimensions
     * @param rowStart the beginning of the row
     * @param rowEnd the the ending of the row
     */
    private function moveComponents(target:Container, x:int, y:int, width:int, height:int,
                                rowStart:int, rowEnd:int):void {
		switch (align) {
			case LEFT:
	    		x += 0;
	    		break;
			case CENTER:
	    		x += width / 2;
	   			break;
			case RIGHT:
	    		x += width;
	    		break;
		}
		for (var i:int = rowStart ; i < rowEnd ; i++) {
	    	var m:Component = target.getComponent(i);
	    	var d:IntDimension = m.getSize();
	    	var td:IntDimension = target.getSize();
	    	if (m.isVisible()) {
        	    m.setLocation(new IntPoint(x, y + (height - d.height) / 2));
                x += d.width + hgap;
	    	}
		}
    }

    /**
     * 布置容器。该方法使每个组件都显示为其最佳尺寸以符合<code>FlowLayout</code>
     * 对象的排列方式。
     * @param target 要布局的容器
     * @see Container
     * @see Container#doLayout
     */
    override public function layoutContainer(target:Container):void {
		var insets:Insets = target.getInsets();
	    var td:IntDimension = target.getSize();
	    var marginW:int = margin ? hgap*2 : 0;
	    var marginH:int = margin ? vgap*2 : 0;
		var maxwidth:int = td.width - (insets.left + insets.right + marginW);
		var nmembers:int = target.getComponentCount();
		var x:int = 0;
		var y:int = insets.top + (margin ? vgap : 0);
		var rowh:int = 0;
		var start:int = 0;

		for (var i:int = 0 ; i < nmembers ; i++) {
	    	var m:Component = target.getComponent(i);
	    	if (m.isVisible()) {
				var d:IntDimension = m.getPreferredSize();
				m.setSize(d);

				if ((x == 0) || ((x + d.width) <= maxwidth)) {
		    		if (x > 0) {
						x += hgap;
		    		}
		    		x += d.width;
		    		rowh = Math.max(rowh, d.height);
				} else {
		    		moveComponents(target, insets.left + (margin ? hgap : 0), y, maxwidth - x, rowh, start, i);
		    		x = d.width;
		    		y += vgap + rowh;
		    		rowh = d.height;
		    		start = i;
				}
	    	}
		}
		moveComponents(target, insets.left + (margin ? hgap : 0), y, maxwidth - x, rowh, start, nmembers);
    }
    
    /**
     * 返回描述该 <code>FlowLayout</code> 对象的字符串。
     * @return     一个描述该布局的字符串
     */
    public function toString():String {
		var str:String = "";
		switch (align) {
	 	 	case LEFT:        str = ",align=left"; break;
	 		case CENTER:      str = ",align=center"; break;
	  		case RIGHT:       str = ",align=right"; break;
		}
		return "FlowLayout[hgap=" + hgap + ",vgap=" + vgap + str + "]";
    }
}
}
