/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.aswing{
	
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.EmptyLayout;
import org.aswing.geom.IntDimension;
import org.aswing.Insets;
import org.aswing.geom.IntRectangle;

/**
 * 这是一个布置容器的边框布局，它可以对容器组件进行安排，并调整其大小，
 * 使其符合下列五个区域：
 * 北、南、东、西、中。
 * 每个区域最多只能包含一个组件，并通过相应的常量进行标识：
 * <code>NORTH</code>, <code>SOUTH</code>, <code>EAST</code>,
 * <code>WEST</code>, 和 <code>CENTER</code>.
 * 当使用边框布局将一个组件添加到容器中时，要使用这五个常量之一，例如：
 * 例如：
 * <pre>
 *    var p:JPanel = new JPanel();
 *    p.setLayout(new BorderLayout());
 *    p.append(new JButton("Okay"), BorderLayout.SOUTH);
 * </pre>
 * 为了方便起见，<code>BorderLayout</code> 将缺少字符串说明的情况解释为常量 <code>CENTER</code>：
 * <pre>
 *    var p2:JPanel = new JPanel();
 *    p2.setLayout(new BorderLayout());
 *    p2.append(new TextArea());  //与 p.append(new JTextArea(), BorderLayout.CENTER);相同
 * </pre>
 * 
 * <p>
 * 下面的图片描述了BorderLayout排列子组件的方式
 * <br></br>
 * <img src="../../aswingImg/BorderLayout.JPG" ></img>
 * </p>
 * @see http://gceclub.sun.com.cn/Java_Docs/jdk6/html/zh_CN/api/java/awt/BorderLayout.html
 * @author iiley
 */
 
public class BorderLayout extends EmptyLayout{
	private var hgap:Number;

	private var vgap:Number;

	private var north:Component;

	private var west:Component;

	private var east:Component;

    private var south:Component;

	private var center:Component;
    
    private var firstLine:Component;

	private var lastLine:Component;

	private var firstItem:Component;

	private var lastItem:Component;
	
	private var defaultConstraints:String;

    /**
     * 北区域的布局约束（容器顶部）。
     */
    public static const NORTH:String  = "North";

    /**
     * 南区域的布局约束（容器底部）。
     */
    public static const SOUTH:String  = "South";

    /**
     * 东区域的布局约束（容器右边）。
     */
    public static const EAST :String  = "East";

    /**
     * 西区域的布局约束（容器左边）。
     */
    public static const WEST :String  = "West";

    /**
     * 中间区域的布局约束（容器中央）。
     */
    public static const CENTER:String  = "Center";

	
	public static const BEFORE_FIRST_LINE:String  = "First";


    public static const AFTER_LAST_LINE:String  = "Last";


    public static const BEFORE_LINE_BEGINS:String  = "Before";


    public static const AFTER_LINE_ENDS:String  = "After";


    public static const PAGE_START:String  = BEFORE_FIRST_LINE;


    public static const PAGE_END:String  = AFTER_LAST_LINE;


    public static const LINE_START:String  = BEFORE_LINE_BEGINS;


    public static const LINE_END:String  = AFTER_LINE_ENDS;

    /**
     * 构造一个具有指定组件间距的边框布局。
     * 水平间距由 <code>hgap</code> 指定，
     * 垂直间距由 <code>vgap</code> 指定。
     * @param   hgap   水平间距。
     * @param   vgap   垂直间距。
     */
    public function BorderLayout(hgap:int = 0, vgap:int = 0) {
		this.hgap = hgap;
		this.vgap = vgap;
		this.defaultConstraints = CENTER; 
    }
	
	/**
	 * 
	 */
	public function setDefaultConstraints(constraints:Object):void {
		defaultConstraints = constraints.toString();
	}
	
	/**
	 * 返回组件之间的水平间距。
	 */ 
    public function getHgap():int {
		return hgap;
    }
	
	/**
	 * 设置组件之间的水平间距。
	 */
    public function setHgap(hgap:int):void {
		this.hgap = hgap;
    }
	
	/**
	 * 返回组件之间的垂直间距。
	 */ 
    public function getVgap():int {
		return vgap;
    }
	
	/**
	 *  设置组件之间的垂直间距。
	 */
    public function setVgap(vgap:int):void {
		this.vgap = vgap;
    }
	
	/**
	 * 
	 */
    override public function addLayoutComponent(comp:Component, constraints:Object):void {
    	var name:String = constraints != null ? constraints.toString() : null;
	    addLayoutComponentByAlign(name, comp);
    }

    private function addLayoutComponentByAlign(name:String, comp:Component):void {
		if (name == null) {
	   		name = defaultConstraints;
		}

		if (CENTER == name) {
		    center = comp;
		} else if (NORTH == name) {
		    north = comp;
		} else if (SOUTH == name) {
		    south = comp;
		} else if (EAST == name) {
		    east = comp;
		} else if (WEST == name) {
		    west = comp;
		} else if (BEFORE_FIRST_LINE == name) {
		    firstLine = comp;
		} else if (AFTER_LAST_LINE == name) {
		    lastLine = comp;
		} else if (BEFORE_LINE_BEGINS == name) {
		    firstItem = comp;
		} else if (AFTER_LINE_ENDS == name) {
		    lastItem = comp;
		} else {
			//defaut center
		    center = comp;
		}
    }
    
	/**
	 * 
	 */
    override public function removeLayoutComponent(comp:Component):void {
		if (comp == center) {
		    center = null;
		} else if (comp == north) {
		    north = null;
		} else if (comp == south) {
		    south = null;
		} else if (comp == east) {
		    east = null;
		} else if (comp == west) {
		    west = null;
		}
		if (comp == firstLine) {
		    firstLine = null;
		} else if (comp == lastLine) {
		    lastLine = null;
		} else if (comp == firstItem) {
		    firstItem = null;
		} else if (comp == lastItem) {
		    lastItem = null;
		}
    }
	/**
	 * 
	 */
    override public function minimumLayoutSize(target:Container):IntDimension {
		return target.getInsets().getOutsideSize();
    }
	
	/**
	 * 
	 */
    override public function preferredLayoutSize(target:Container):IntDimension {
    	var dim:IntDimension = new IntDimension(0, 0);
	    var ltr:Boolean = true;
	    var c:Component = null;
		
		var d:IntDimension;
		if ((c=getChild(EAST,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width += d.width + hgap;
		    dim.height = Math.max(d.height, dim.height);
		}
		if ((c=getChild(WEST,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width += d.width + hgap;
		    dim.height = Math.max(d.height, dim.height);
		}
		if ((c=getChild(CENTER,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width += d.width;
		    dim.height = Math.max(d.height, dim.height);
		}
		if ((c=getChild(NORTH,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width = Math.max(d.width, dim.width);
		    dim.height += d.height + vgap;
		}
		if ((c=getChild(SOUTH,ltr)) != null) {
		    d = c.getPreferredSize();
		    dim.width = Math.max(d.width, dim.width);
		    dim.height += d.height + vgap;
		}
	
		var insets:Insets = target.getInsets();
		dim.width += insets.left + insets.right;
		dim.height += insets.top + insets.bottom;
		return dim;
    }
	/**
	 *
	 */
    override public function getLayoutAlignmentX(target:Container):Number{
    	return 0.5;
    }
	
	/**
	 * 
	 */
    override public function getLayoutAlignmentY(target:Container):Number{
    	return 0.5;
    }

    /**
     * <p>
     * 使用此边框布局对容器参数进行布局。
     * </p>
     * <p>
     * 为了满足此 <code>BorderLayout</code> 对象的约束条件，
     * 此方法实际上会重塑指定容器中的组件。
     * <code>NORTH</code> 和 <code>SOUTH</code> 组件（如果有）分别放置在容器的顶部和底部。
     * <code>WEST</code> 和 <code>EAST</code> 组件分别放置在容器的左边和右边。
     * 最后，<code>CENTER</code> 对象放置在中间的任何剩余空间内。
     * </p>
     * <p>
     * 大多数应用程序并不直接调用此方法。容器调用其 doLayout 方法时将调用此方法。
     * </p>
     * @param   target   要布置的容器。
     * @see     Container
     * @see     Container#doLayout()
     */
    override public function layoutContainer(target:Container):void{
    	var td:IntDimension = target.getSize();
		var insets:Insets = target.getInsets();
		var top:int = insets.top;
		var bottom:int = td.height - insets.bottom;
		var left:int = insets.left;
		var right:int = td.width - insets.right;
	    var ltr:Boolean = true;
	    var c:Component = null;
	
		var d:IntDimension;
		if ((c=getChild(NORTH,ltr)) != null) {
		    d = c.getPreferredSize();
		    c.setBounds(new IntRectangle(left, top, right - left, d.height));
		    top += d.height + vgap;
		}
		if ((c=getChild(SOUTH,ltr)) != null) {
		    d = c.getPreferredSize();
		    c.setBounds(new IntRectangle(left, bottom - d.height, right - left, d.height));
		    bottom -= d.height + vgap;
		}
		if ((c=getChild(EAST,ltr)) != null) {
		    d = c.getPreferredSize();
		    c.setBounds(new IntRectangle(right - d.width, top, d.width, bottom - top));
		    right -= d.width + hgap;
		    //Flashout.log("East prefer size : " + d);
		}
		if ((c=getChild(WEST,ltr)) != null) {
		    d = c.getPreferredSize();
		    c.setBounds(new IntRectangle(left, top, d.width, bottom - top));
		    left += d.width + hgap;
		}
		if ((c=getChild(CENTER,ltr)) != null) {
		    c.setBounds(new IntRectangle(left, top, right - left, bottom - top));
		}
      
    }

    /**
     * 返回给定约束位置对应的组件。
     *
     * @param   key     所需的绝对位置，CENTER、NORTH、SOUTH、EAST 和 WEST 之一。
     * @param   ltr     Is the component line direction left-to-right?
     * 					该组件方向是否从左向右？ //TODO 未理解...
     */
    private function getChild(key:String, ltr:Boolean):Component {
        var result:Component = null;

        if (key == NORTH) {
            result = (firstLine != null) ? firstLine : north;
        }
        else if (key == SOUTH) {
            result = (lastLine != null) ? lastLine : south;
        }
        else if (key == WEST) {
            result = ltr ? firstItem : lastItem;
            if (result == null) {
                result = west;
            }
        }
        else if (key == EAST) {
            result = ltr ? lastItem : firstItem;
            if (result == null) {
                result = east;
            }
        }
        else if (key == CENTER) {
            result = center;
        }
        if (result != null && !result.isVisible()) {
            result = null;
        }
        return result;
    }

    public function toString():String {
		return "BorderLayout[hgap=" + hgap + ",vgap=" + vgap + "]";
    }
}
}